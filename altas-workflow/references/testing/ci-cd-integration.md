# CI/CD 测试集成指南

> **调用时机**: 需要将测试集成到持续集成/部署流水线时加载
> **配合使用**: `references/testing/pytest-patterns.md`、`references/testing/test-data-management.md`

---

## 核心原则

1. **快速反馈**: 测试应在 10 分钟内完成，关键测试 < 5 分钟
2. **稳定可靠**: Flaky rate < 1%，不允许随机失败
3. **全面覆盖**: 每次提交运行完整测试套件
4. **清晰报告**: 失败信息可操作，覆盖率可视化
5. **成本可控**: 合理利用缓存和并行化

---

## GitHub Actions 完整模板

### 基础模板（推荐起点）

```yaml
# .github/workflows/test.yml
name: Test Suite

on:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

jobs:
  test:
    name: Python ${{ matrix.python-version }} Tests
    runs-on: ubuntu-latest
    
    strategy:
      fail-fast: false
      matrix:
        python-version: ['3.9', '3.10', '3.11', '3.12']
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: testuser
          POSTGRES_PASSWORD: testpass
          POSTGRES_DB: testdb
        ports:
          - 5432:5432
        options: >-
          --health-cmd="pg_isready"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=5
      
      redis:
        image: redis:7-alpine
        ports:
          - 6379:6379
        options: >-
          --health-cmd="redis-cli ping"
          --health-interval=10s
          --health-timeout=5s
          --health-retries=5

    steps:
    - name: Checkout code
      uses: actions/checkout@v4

    - name: Set up Python ${{ matrix.python-version }}
      uses: actions/setup-python@v5
      with:
        python-version: ${{ matrix.python-version }}
        cache: 'pip'

    - name: Install dependencies
      run: |
        python -m pip install --upgrade pip
        pip install -r requirements-test.txt

    - name: Create test database
      env:
        PGPASSWORD: testpass
      run: |
        psql -h localhost -U testuser -d testdb -c "CREATE EXTENSION IF NOT EXISTS uuid-ossp;"

    - name: Run linting
      run: |
        pylint src/ tests/ || true  # 不阻塞但记录问题
        ruff check src/ tests/

    - name: Run type checking
      run: mypy src/

    - name: Run tests with coverage
      env:
        DATABASE_URL: postgresql://testuser:testpass@localhost:5432/testdb
        REDIS_URL: redis://localhost:6379/0
      run: |
        pytest \
          --cov=src \
          --cov-report=xml \
          --cov-report=term-missing \
          --junitxml=test-results.xml \
          --tb=short \
          -v

    - name: Upload coverage to Codecov
      if: matrix.python-version == '3.11'
      uses: codecov/codecov-action@v3
      with:
        files: ./coverage.xml
        flags: unittests
        name: codecov-umbrella
        fail_ci_if_error: false

    - name: Upload test results
      if: always()
      uses: actions/upload-artifact@v4
      with:
        name: test-results-py${{ matrix.python-version }}
        path: test-results.xml
        retention-days: 7

    - name: Check coverage threshold
      run: |
        python -c "
        import xml.etree.ElementTree as ET
        tree = ET.parse('coverage.xml')
        root = tree.getroot()
        line_rate = float(root.attrib.get('line-rate', 0))
        coverage_pct = line_rate * 100
        print(f'Coverage: {coverage_pct:.1f}%')
        assert coverage_pct >= 80, f'Coverage {coverage_pct:.1f}% is below 80% threshold'
        "

    - name: Summary
      if: always()
      run: echo "✅ Python ${{ matrix.python-version }} tests completed"
```

### 高级模板（带并行化和缓存优化）

```yaml
# .github/workflows/test-optimized.yml
name: Optimized Test Suite

on:
  push:
    branches: [main]
  pull_request:

concurrency:
  group: ${{ github.workflow }}-${{ github.ref }}
  cancel-in-progress: true

env:
  PYTHON_VERSION: '3.11'

jobs:
  # Job 1: 快速单元测试（必须通过才能合并）
  unit-tests:
    name: Unit Tests (Fast)
    runs-on: ubuntu-latest
    timeout-minutes: 10
    
    steps:
    - uses: actions/checkout@v4
    
    - uses: actions/setup-python@v5
      with:
        python-version: ${{ env.PYTHON_VERSION }}
        cache: 'pip'
    
    - name: Install dependencies
      run: pip install -r requirements-test.txt
    
    - name: Run unit tests only
      run: |
        pytest tests/unit/ \
          -n auto \
          --dist=loadscope \
          --tb=short \
          -q \
          --maxfail=5 \
          --durations=10
  
  # Job 2: 集成测试（使用服务容器）
  integration-tests:
    name: Integration Tests
    runs-on: ubuntu-latest
    needs: unit-tests
    timeout-minutes: 20
    
    services:
      postgres:
        image: postgres:15-alpine
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: testdb
        options: >-
          --health-cmd pg_isready
          --health-interval 5s
          --health-timeout 5s
          --health-retries 5
        ports:
          - 5432:5432
    
    steps:
    - uses: actions/checkout@v4
    
    - uses: actions/setup-python@v5
      with:
        python-version: ${{ env.PYTHON_VERSION }}
        cache: 'pip'
    
    - name: Cache test data
      uses: actions/cache@v4
      with:
        path: ~/.cache/pytest
        key: pytest-data-${{ hashFiles('tests/integration/**') }}
        restore-keys: pytest-data-
    
    - name: Install dependencies
      run: pip install -r requirements-test.txt
    
    - name: Run integration tests
      env:
        DATABASE_URL: postgresql://test:test@localhost:5432/testdb
      run: |
        pytest tests/integration/ \
          -n 4 \
          --tb=long \
          --cov=src \
          --cov-report=xml \
          --junitxml=integration-results.xml
  
  # Job 3: E2E 测试（可选，较慢）
  e2e-tests:
    name: E2E Tests
    runs-on: ubuntu-latest
    needs: integration-tests
    if: github.event_name == 'pull_request'
    timeout-minutes: 30
    
    steps:
    - uses: actions/checkout@v4
    
    - uses: actions/setup-python@v5
      with:
        python-version: ${{ env.PYTHON_VERSION }}
        cache: 'pip'
    
    - name: Start Docker Compose environment
      run: docker-compose -f docker-compose.test.yml up -d
    
    - name: Wait for services
      run: |
        sleep 10
        docker-compose -f docker-compose.test.yml ps
    
    - name: Install and run E2E tests
      run: |
        pip install -r requirements-test.txt
        pytest tests/e2e/ \
          --tb=long \
          --screenshot=only-on-failure \
          --video=retain-on-failure
    
    - name: Stop Docker Compose
      if: always()
      run: docker-compose -f docker-compose.test.yml down -v
  
  # Job 4: 质量门禁
  quality-gate:
    name: Quality Gate
    runs-on: ubuntu-latest
    needs: [unit-tests, integration-tests]
    if: always()
    
    steps:
    - name: Check all jobs passed
      run: |
        echo "Unit Tests: ${{ needs.unit-tests.result }}"
        echo "Integration Tests: ${{ needs.integration-tests.result }}"
        
        if [[ "${{ needs.unit-tests.result }}" == "failure" ]] || \
           [[ "${{ needs.integration-tests.result }}" == "failure" ]]; then
          echo "::error::One or more test jobs failed"
          exit 1
        fi
        
        echo "::notice::All quality checks passed ✅"
```

---

## GitLab CI 模板

```yaml
# .gitlab-ci.yml
stages:
  - lint
  - test
  - report

variables:
  PIP_CACHE_DIR: "$CI_PROJECT_DIR/.cache/pip"

cache:
  paths:
    - .cache/pip
    - venv/

before_script:
  - python -m venv venv
  - source venv/bin/activate
  - pip install --upgrade pip
  - pip install -r requirements-test.txt

lint:
  stage: lint
  script:
    - ruff check src/ tests/
    - mypy src/
  allow_failure: true  # 不阻塞但记录问题

test:unit:
  stage: test
  script:
    - pytest tests/unit/ -v --cov=src --cov-report=xml
  coverage: '/TOTAL\s+\d+\s+\d+\s+(\d+)%/'
  artifacts:
    when: always
    reports:
      junit: test-results.xml
      coverage_report:
        coverage_format: cobertura
        path: coverage.xml
    paths:
      - coverage.xml
      - htmlcov/
    expire_in: 7 days

test:integration:
  stage: test
  services:
    - name: postgres:15-alpine
      alias: db
    - name: redis:7-alpine
      alias: redis
  variables:
    POSTGRES_DB: testdb
    POSTGRES_USER: testuser
    POSTGRES_PASSWORD: testpass
    DATABASE_URL: "postgresql://testuser:testpass@db:5432/testdb"
  script:
    - pytest tests/integration/ -v --tb=short
  artifacts:
    when: on_failure
    reports:
      junit: integration-results.xml

pages:
  stage: report
  script:
    - mkdir -p public/coverage
    - cp -r htmlcov/* public/coverage/
  artifacts:
    paths:
      - public
  only:
    - main
```

---

## 测试优化策略

### 1. 并行化执行

#### pytest-xdist 配置

```ini
# pytest.ini 或 pyproject.toml
[tool.pytest.ini_options]
addopts = 
    -n auto              # 自动检测 CPU 核心数
    --dist=loadscope     # 按模块分配 worker
    --maxprocesses=8     # 最大进程数限制

# 或者按文件大小智能分配
# --dist=loadfile        # 按文件分配（适合文件大小不均的情况）
```

```python
# conftest.py - Worker 初始化
import pytest

@pytest.fixture(scope="session")
def worker_id(worker_id):
    """获取当前 worker ID"""
    return worker_id

# 在 fixture 中使用
@pytest.fixture
def per_worker_database(worker_id):
    """每个 worker 使用独立数据库"""
    db = create_test_db(f"test_{worker_id}")
    yield db
    drop_test_db(db)
```

#### 并行执行最佳实践

| 策略 | 适用场景 | 命令示例 |
|------|---------|----------|
| `auto` | 通用场景 | `pytest -n auto` |
| `logical` | CPU 密集型 | `pytest -n logical` |
| `loadscope` | 有共享状态 | `pytest -n 4 --dist=loadscope` |
| `loadfile` | 文件大小差异大 | `pytest -n 4 --dist=loadfile` |

**注意事项**：
- 避免在并发测试中使用全局可变状态
- 数据库测试需要独立连接或数据库
- 文件系统操作需要使用临时目录 (`tmp_path`)
- 使用 `worker_id` 区分不同 worker 的资源

### 2. 缓存策略

#### pip 缓存

```yaml
# GitHub Actions
- uses: actions/setup-python@v5
  with:
    python-version: '3.11'
    cache: 'pip'  # 自动缓存 pip 下载

# GitLab CI
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - .cache/pip/
```

#### pytest 缓存

```bash
# 启用 pytest 缓存（默认已开启）
pytest --cache-clear  # 清除缓存重新开始

# 缓存目录结构
.pytest_cache/
├── v/                  # 版本信息
├── cache/lastfailed    # 上次失败的测试
├── cache/stepwise      # 断点续跑状态
└── ...
```

```python
# conftest.py - 自定义缓存键
@pytest.fixture
def expensive_computation():
    """缓存昂贵计算结果"""
    cache_key = "expensive_calc_result"
    
    cached = config.cache.get(cache_key, None)
    if cached is not None:
        return cached
    
    result = perform_expensive_calculation()
    config.cache.set(cache_key, result)
    
    return result
```

#### 依赖安装缓存

```yaml
# 更细粒度的依赖缓存
- name: Get pip cache dir
  id: pip-cache
  run: echo "dir=$(pip cache dir)" >> $GITHUB_OUTPUT

- name: Cache dependencies
  uses: actions/cache@v4
  with:
    path: ${{ steps.pip-cache.outputs.dir }}
    key: ${{ runner.os }}-pip-${{ hashFiles('**/requirements*.txt') }}
    restore-keys: |
      ${{ runner.os }}-pip-

- name: Install dependencies
  run: |
    pip install --no-cache-dir -r requirements.txt
    pip install --no-cache-dir -r requirements-test.txt
```

### 3. 测试分片

#### 按测试时长分片

```bash
# 先收集测试时长
pytest --durations=0 -q

# 手动分片到多个 job
# Job 1: 最慢的测试
pytest tests/slow_module_1.py tests/slow_module_2.py

# Job 2: 中等速度测试
pytest tests/medium_*.py

# Job 3: 快速测试
pytest tests/unit/ -k "not slow"
```

#### 自动分片脚本

```python
# scripts/split_tests.py
"""根据历史执行时间自动分片测试"""

import subprocess
import json
from pathlib import Path

def get_test_durations():
    """获取每个测试的历史执行时间"""
    result = subprocess.run(
        ["pytest", "--collect-only", "-q", "--durations=0"],
        capture_output=True,
        text=True
    )
    # 解析输出...
    return durations

def split_tests(tests, num_shards):
    """将测试均匀分配到指定数量的分片中"""
    sorted_tests = sorted(tests.items(), key=lambda x: x[1], reverse=True)
    
    shards = [[] for _ in range(num_shards)]
    shard_times = [0] * num_shards
    
    for test_name, duration in sorted_tests:
        min_index = shard_times.index(min(shard_times))
        shards[min_index].append(test_name)
        shard_times[min_index] += duration
    
    return shards

if __name__ == "__main__":
    tests = get_test_durations()
    shards = split_tests(tests, num_shards=4)
    
    for i, shard in enumerate(shards):
        print(f"Shard {i}: {len(shard)} tests")
        Path(f"shard_{i}.txt").write_text("\n".join(shard))
```

```yaml
# 使用分片
- name: Split tests
  run: python scripts/split_tests.py

- name: Run shard 0
  run: pytest $(cat shard_0.txt)

- name: Run shard 1
  run: pytest $(cat shard_1.txt)
```

### 4. 超时控制

#### 单个测试超时

```bash
# 安装
pip install pytest-timeout

# 配置
# pytest.ini
[tool.pytest.ini_options]
timeout = 30            # 默认超时 30 秒
timeout_method = signal  # 使用信号终止（Unix）

# 运行
pytest --timeout=30
```

```python
# 为特定测试设置超时
import pytest

@pytest.mark.timeout(60)  # 这个测试允许 60 秒
def test_slow_operation():
    ...

# 动态超时
def test_with_dynamic_timeout():
    import pytest
    pytest.timeout(10)  # 运行时动态设置
```

#### 整体套件超时

```bash
# 整个测试会话超时
pytest --timeout=300  # 5 分钟总超时

# 按类/模块超时
@pytest.mark.timeout(120, method='thread')
class TestSlowFeature:
    """整个类使用线程级超时"""
    def test_part_1(self): ...
    def test_part_2(self): ...
```

### 5. Flaky Test 重试机制

```bash
# 安装
pip install pytest-rerunfailures

# 配置重试次数
# pytest.ini
addopts = --reruns 2         # 失败后重试 2 次
         --reruns-delay 2    # 每次重试间隔 2 秒

# 仅对标记的测试重试
pytest -m "flaky" --reruns 3

# 忽略某些错误不重试
pytest --reruns 2 --rerun-except AssertionError
```

```python
# 标记 flaky 测试
import pytest

@pytest.mark.flaky(reruns=3, reruns_delay=1)
def test_sometimes_fails():
    """已知的不稳定测试"""
    ...

# 条件性重试
@pytest.mark.xfail(reason="Known issue #123", strict=False)
def test_known_bug():
    """预期失败但不阻塞 CI"""
    ...
```

---

## 覆盖率报告与门禁

### Codecov 集成

```yaml
# 上传覆盖率
- name: Upload to Codecov
  uses: codecov/codecov-action@v3
  with:
    token: ${{ secrets.CODECOV_TOKEN }}
    files: ./coverage.xml,./integration-coverage.xml
    flags: unittests,integration
    name: codecov-umbrella
    fail_ci_if_error: true
    verbose: true
```

### 覆盖率门禁检查

```python
# scripts/check_coverage.py
"""检查覆盖率是否达标"""
import sys
import xml.etree.ElementTree as ET

MINIMUM_COVERAGE = {
    'line': 80,
    'branch': 75,
    'function': 85,
}

def check_coverage(xml_file):
    tree = ET.parse(xml_file)
    root = tree.getroot()
    
    packages = root.findall('.//package')
    if not packages:
        # 单模块项目
        line_rate = float(root.get('line-rate', 0))
        print(f"Total Line Coverage: {line_rate*100:.1f}%")
        if line_rate * 100 < MINIMUM_COVERAGE['line']:
            print(f"❌ Below minimum {MINIMUM_COVERAGE['line']}%")
            return False
        return True
    
    all_passed = True
    for pkg in packages:
        name = pkg.get('name', 'root')
        line_rate = float(pkg.get('line-rate', 0)) * 100
        branch_rate = float(pkg.get('branch-rate', 0)) * 100
        
        status = "✅" if line_rate >= MINIMUM_COVERAGE['line'] else "❌"
        print(f"{status} {name}: Lines={line_rate:.1f}%, Branch={branch_rate:.1f}%")
        
        if line_rate < MINIMUM_COVERAGE['line']:
            all_passed = False
    
    return all_passed

if __name__ == "__main__":
    xml_file = sys.argv[1] if len(sys.argv) > 1 else "coverage.xml"
    passed = check_coverage(xml_file)
    sys.exit(0 if passed else 1)
```

```yaml
# 在 CI 中使用
- name: Check coverage thresholds
  run: python scripts/check_coverage.py coverage.xml
```

### 覆盖率趋势监控

```yaml
# 定期任务：每周生成覆盖率报告
name: Weekly Coverage Report

on:
  schedule:
    - cron: '0 9 * * 1'  # 每周一早上 9 点

jobs:
  report:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - name: Generate coverage trend
      run: |
        # 这里可以调用 Codecov API 获取历史数据
        # 生成 Markdown 报告
        echo "# Coverage Trend Report" >> $GITHUB_STEP_SUMMARY
        echo "| Week | Coverage | Change |" >> $GITHUB_STEP_SUMMARY
        echo "|------|----------|--------|" >> $GITHUB_STEP_SUMMARY
```

---

## 测试结果通知

### Slack 通知

```yaml
- name: Notify Slack on failure
  if: failure()
  uses: slackapi/slack-github-action@v1
  with:
    payload: |
      {
        "text": "❌ Tests Failed",
        "attachments": [
          {
            "color": "danger",
            "fields": [
              {
                "title": "Repository",
                "value": "${{ github.repository }}",
                "short": true
              },
              {
                "title": "Branch",
                "value": "${{ github.ref_name }}",
                "short": true
              },
              {
                "title": "Commit",
                "value": "${{ github.sha }}",
                "short": false
              },
              {
                "title": "Author",
                "value": "${{ github.actor }}",
                "short": true
              }
            ]
          }
        ]
      }
    env:
      SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK_URL }}
```

### PR 评论（测试摘要）

```yaml
- name: Comment PR with test summary
  if: always()
  uses: actions/github-script@v7
  with:
    script: |
      const fs = require('fs');
      
      let summary = '## 🧪 Test Results\n\n';
      
      // 解析 JUnit XML
      try {
        const data = fs.readFileSync('test-results.xml', 'utf8');
        // 解析并格式化...
        summary += '| Metric | Value |\n';
        summary += '|--------|-------|\n';
        summary += '| Total | 150 |\n';
        summary += '| Passed | 148 |\n';
        summary += '| Failed | 2 |\n';
        summary += '| Coverage | 82.5% |\n';
      } catch (e) {
        summary += '⚠️ Could not parse test results\n';
      }
      
      github.rest.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: context.issue.number,
        body: summary
      });
```

---

## 多环境测试策略

### 矩阵测试

```yaml
# 测试矩阵：Python 版本 × 数据库类型
test-matrix:
  strategy:
    fail-fast: false
    matrix:
      python-version: ['3.9', '3.10', '3.11', '3.12']
      database: ['postgres', 'mysql', 'sqlite']
      exclude:
        # 排除某些组合
        - python-version: '3.12'
          database: 'sqlite'  # SQLite 在 3.12 下有已知问题
```

### 分阶段测试

```yaml
# 阶段 1: PR 触发 - 只跑快速测试
pr-tests:
  if: github.event_name == 'pull_request'
  steps:
    - run: pytest tests/unit/ tests/fast_integration/ -x -q

# 阶段 2: 主分支推送 - 跑完整测试
main-tests:
  if: github.ref == 'refs/heads/main'
  steps:
    - run: pytest tests/ --full-test-suite

# 阶段 3: 发布前 - 跑完整 + E2E + 性能
release-tests:
  if: startsWith(github.ref, 'refs/tags/v')
  steps:
    - run: pytest tests/ --e2e --performance
```

### 条件跳过

```yaml
# 当只修改文档时不运行测试
- name: Determine if tests needed
  id: check_changes
  run: |
    if git diff --name-only HEAD~1 | grep -E '\.(py|txt|cfg|toml)$'; then
      echo "run_tests=true" >> $GITHUB_OUTPUT
    else
      echo "run_tests=false" >> $GITHUB_OUTPUT
    fi

- name: Run tests
  if: steps.check_changes.outputs.run_tests == 'true'
  run: pytest

# 或使用 paths 过滤
on:
  push:
    paths:
      - 'src/**/*.py'
      - 'tests/**/*.py'
      - 'requirements*.txt'
```

---

## 性能基准测试 CI

```yaml
benchmark:
  name: Performance Benchmark
  runs-on: ubuntu-latest
  if: github.event_name == 'push' && github.ref == 'refs/heads/main'
  
  steps:
  - uses: actions/checkout@v4
    with:
      fetch-depth: 0  # 获取完整历史用于比较
  
  - uses: actions/setup-python@v5
    with:
      python-version: '3.11'
  
  - name: Install dependencies
    run: pip install pytest-benchmark
  
  - name: Run benchmarks
    run: |
      pytest benchmarks/ \
        --benchmark-save=data \
        --benchmark-autosave \
        --benchmark-compare=0000  # 与基线比较
  
  - name: Check performance regression
    run: |
      python scripts/check_benchmark_regression.py
      # 如果性能下降超过 10% 则失败
  
  - name: Upload benchmark results
    uses: actions/upload-artifact@v4
    with:
      name: benchmark-results
      path: .benchmarks/
```

---

## Docker Compose 测试环境

```yaml
# docker-compose.test.yml
version: '3.8'

services:
  app:
    build:
      context: .
      dockerfile: Dockerfile.test
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_healthy
    environment:
      - DATABASE_URL=postgresql://test:test@db:5432/testdb
      - REDIS_URL=redis://redis:6379/0
    volumes:
      - .:/app
    command: ["pytest", "tests/", "-v"]

  db:
    image: postgres:15-alpine
    environment:
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
      POSTGRES_DB: testdb
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U test"]
      interval: 5s
      timeout: 5s
      retries: 5
    volumes:
      - pgdata:/var/lib/postgresql/data

  redis:
    image: redis:7-alpine
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 5s
      timeout: 5s
      retries: 5

volumes:
  pgdata:
```

```bash
# 本地运行完整测试环境
docker-compose -f docker-compose.test.yml up --build --abort-on-container-exit

# 仅启动服务，手动运行测试
docker-compose -f docker-compose.test.yml up -d
pytest tests/integration/
docker-compose -f docker-compose.test.yml down
```

---

## CI/CD 最佳实践清单

设计或审查 CI/CD 流水线时，逐项检查：

**可靠性**
- [ ] Flaky rate < 1%（允许 0 次随机失败）
- [ ] 失败时有清晰的错误信息和日志
- [ ] 关键测试有超时保护
- [ ] 并发安全（无共享可变状态）

**性能**
- [ ] 全量测试 < 10 分钟完成
- [ ] PR 反馈 < 5 分钟（快速测试子集）
- [ ] 使用缓存减少重复安装
- [ ] 合理并行化（CPU 核心数匹配）

**覆盖**
- [ ] 每次提交运行单元测试
- [ ] PR 运行集成测试
- [ ] Main 分支运行全量测试
- [ ] 发布前运行 E2E + 性能测试

**报告**
- [ ] 覆盖率可视化（Codecov / Coveralls）
- [ ] 失败通知（Slack/Email）
- [ ] PR 中显示测试摘要
- [ ] 历史趋势追踪

**安全**
- [ ] 敏感信息使用 Secrets 管理
- [ ] 无硬编码密码/token
- [ ] 测试数据库权限最小化
- [ ] 测试数据脱敏

---

## 常见问题排查

### 问题 1: CI 测试通过但本地失败

```bash
# 可能原因及解决方案：

# 1. 时区差异
TZ=UTC pytest  # 统一时区

# 2. 路径差异（Windows vs Linux）
# 使用 pathlib.Path 而非字符串拼接路径

# 3. 随机数未固定
export PYTHONHASHSEED=42
pytest --randomly-seed=42  # 如果使用 pytest-randomly

# 4. 并行执行顺序差异
pytest -n 1  # 串行执行确认是否为并发问题
```

### 问题 2: 测试突然变慢

```bash
# 诊断步骤：

# 1. 找出最慢的测试
pytest --durations=20

# 2. 检查是否有不必要的数据库查询
# 使用 django-debug-toolbar 或 SQL 日志

# 3. 检查 Fixture 是否被多次执行
pytest --setup-show  # 显示 fixture 创建顺序

# 4. 检查内存泄漏
pytest --memtop  # 需要 pytest-memtop
```

### 问题 3: 服务容器未就绪

```yaml
# 增加重试逻辑
- name: Wait for database
  run: |
    for i in {1..30}; do
      pg_isready -h localhost -U testuser && break || sleep 1
    done
    pg_isready -h localhost -U testuser

# 或使用更长的 healthcheck
services:
  postgres:
    options: >
      --health-cmd "pg_isready -U testuser"
      --health-interval 10s
      --health-timeout 10s
      --health-retries 10
```

---

## 快速参考卡片

```yaml
# 最小可行配置（复制即用）
name: Tests
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: '3.11'
          cache: 'pip'
      - run: pip install -r requirements-test.txt
      - run: pytest --cov=src --cov-report=xml -v
      - uses: codecov/codecov-action@v3
```

```bash
# 常用命令速查
pytest -n auto                    # 并行执行
pytest --tb=short                 # 简短 traceback
pytest -q                         # 安静模式
pytest -x                         # 首次失败停止
pytest --lf                       # 只跑上次失败的
pytest --durations=10             # 显示最慢的 10 个测试
pytest --cov=src --cov-report=html  # HTML 覆盖率报告
```

---

## 回归测试选择策略（Regression Test Selection）

> 全量测试太慢时，如何选择应该运行的测试子集？

### 测试分层策略

| 触发场景 | 测试范围 | 预期耗时 | 命令 |
|----------|----------|----------|------|
| PR / Push | unit + affected integration | < 5min | `pytest tests/unit -n auto && pytest tests/integration -k "affected"` |
| Main 分支合并 | unit + integration + API | < 15min | `pytest tests/unit tests/integration tests/api -n auto` |
| Release / 部署前 | 全量 + e2e + 性能 | < 30min | `pytest -n auto --cov=src` |
| 热修复 | unit + smoke | < 2min | `pytest tests/unit -m "not slow" -n auto` |

### 基于变更文件的测试选择

```bash
# 1. 获取变更文件列表
CHANGED_FILES=$(git diff --name-only origin/main...HEAD)

# 2. 根据变更文件选择测试
# - src/services/order.py → tests/unit/test_order.py + tests/api/test_orders.py
# - src/models/ → tests/unit/test_models.py + tests/integration/
# - src/database.py → tests/integration/ (数据库相关)

# 3. 使用 pytest-picked 自动选择
pip install pytest-picked
pytest --picked

# 4. 使用 pytest-testmon 基于依赖分析
pip install pytest-testmon
pytest --testmon
```

### pytest-testmon 集成

```yaml
# GitHub Actions - testmon 集成
- name: Run affected tests
  run: |
    pip install pytest-testmon
    pytest --testmon
  env:
    # 缓存 testmon 数据以跨运行保持
    TESTMON_DATAFILE: .testmondata

- name: Cache testmon data
  uses: actions/cache@v3
  with:
    path: .testmondata
    key: testmon-${{ runner.os }}-${{ hashFiles('**/*.py') }}
```

### 变更影响分析模板

```markdown
## 变更影响分析

### 变更文件
- `src/services/order.py` (修改)
- `src/models/order.py` (修改)

### 受影响模块
- 订单创建流程
- 订单状态机

### 应跑测试
- [x] `tests/unit/test_order.py` (直接对应)
- [x] `tests/api/test_orders.py` (API 层验证)
- [x] `tests/integration/test_order_workflow.py` (工作流验证)
- [ ] `tests/unit/test_payment.py` (间接影响，可选)
- [ ] `tests/e2e/test_checkout.py` (端到端，Release 时跑)
```

### Marker 驱动的测试分片

```toml
# pyproject.toml - 配置 marker 分片
[tool.pytest.ini_options]
markers = [
    "slow: marks tests as slow",
    "integration: marks integration tests",
    "e2e: marks end-to-end tests",
    "smoke: critical path tests (must pass)",
]
```

```bash
# PR: 只跑 unit + smoke
pytest -m "not integration and not e2e and not slow" -n auto

# Main: unit + integration，排除 e2e
pytest -m "not e2e" -n auto

# Release: 全量
pytest -n auto
```

---

**版本**: 1.1.0
**兼容**: GitHub Actions v4+, GitLab CI 15.0+, pytest 7.0+
**核心依赖**: `pytest-xdist`, `pytest-timeout`, `pytest-rerunfailures`, `pytest-cov`, `codecov`

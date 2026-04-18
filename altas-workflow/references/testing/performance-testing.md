# 性能/负载测试参考

> **调用时机**: 需要编写性能基准、负载测试或进行性能回归检测时加载
> **配合使用**: `references/testing/pytest-patterns.md`（pytest 基础）、`references/testing/ci-cd-integration.md`（CI 集成）

---

## 核心原则

1. **性能测试也需自动化** — 不要依赖手动压测
2. **基线必须可重复** — 相同环境相同数据下结果一致
3. **回归检测必须自动** — CI 中自动对比基线，超过阈值则告警
4. **性能测试与功能测试分离** — 不同目录、不同 CI 阶段

---

## 测试层级与工具选型

| 层级 | 工具 | 适用场景 | 典型耗时 |
|------|------|----------|---------|
| **单元级性能基准** | `pytest-benchmark` | 单个函数/方法的性能基线 | < 100ms |
| **API 级负载测试** | `locust` / `k6` | 接口并发、吞吐量、响应时间 | 1-10 min |
| **系统级压力测试** | `locust` + `docker` | 全系统负载、资源消耗 | 10-30 min |

### 工具选型对比

| 工具 | 语言 | 协议支持 | 学习曲线 | CI 集成 | 报告 |
|------|------|---------|---------|---------|------|
| `pytest-benchmark` | Python | 进程内 | 低 | ✅ 原生 | JSON/CSV |
| `locust` | Python | HTTP/WS | 中 | ✅ 好 | Web UI/JSON |
| `k6` | JavaScript | HTTP/WS/gRPC | 中 | ✅ 好 | JSON/HTML |
| `wrk` | C | HTTP | 低 | ⚠️ 需包装 | 终端输出 |

**推荐**: Python 项目优先用 pytest-benchmark（单元级）+ locust（API 级）；跨语言项目用 k6。

---

## 1. 单元测试级性能基准

### 1.1 pytest-benchmark 基础

```bash
pip install pytest-benchmark
```

```python
import pytest
from myapp.utils import complex_calculation

def test_complex_calculation_performance(benchmark):
    """基准测试：complex_calculation 应在 50ms 内完成"""
    result = benchmark(complex_calculation, 1000)
    assert result > 0

def test_sorting_performance(benchmark):
    """基准测试：排序 10000 个元素"""
    import random
    data = [random.randint(1, 10000) for _ in range(10000)]
    
    result = benchmark(sorted, data)
    assert len(result) == 10000
```

### 1.2 基线管理与回归检测

```python
# conftest.py
import pytest

@pytest.fixture
def benchmark_baseline():
    """从文件加载基线"""
    import json
    try:
        with open(".benchmark_baseline.json") as f:
            return json.load(f)
    except FileNotFoundError:
        return {}

def test_calculation_no_regression(benchmark, benchmark_baseline):
    """对比当前结果与基线，检测性能回归"""
    result = benchmark(complex_calculation, 1000)
    
    baseline_time = benchmark_baseline.get("complex_calculation_1000")
    if baseline_time:
        # 允许 10% 的波动
        assert benchmark.stats.stats.mean < baseline_time * 1.10, \
            f"性能回归：{benchmark.stats.stats.mean}ms > {baseline_time * 1.10}ms"
```

### 1.3 基线更新命令

```bash
# 运行基准测试并保存结果
pytest tests/performance/ --benchmark-save=baseline --benchmark-autosave

# 对比当前与基线
pytest tests/performance/ --benchmark-compare=0001

# 导出基线数据
pytest tests/performance/ --benchmark-json=benchmark.json
```

---

## 2. API 级负载测试

### 2.1 Locust 基础

```bash
pip install locust
```

```python
# tests/performance/locustfile.py
from locust import HttpUser, task, between

class APIUser(HttpUser):
    wait_time = between(1, 3)
    
    @task(3)
    def get_user(self):
        self.client.get("/api/users/1")
    
    @task(1)
    def create_order(self):
        self.client.post("/api/orders", json={
            "product_id": 1,
            "quantity": 1
        })
    
    @task(2)
    def list_products(self):
        self.client.get("/api/products?limit=20")
```

```bash
# 本地运行
locust -f tests/performance/locustfile.py --host=http://localhost:8000

# 无头模式（CI 用）
locust -f tests/performance/locustfile.py \
  --host=http://localhost:8000 \
  --headless \
  --users 100 \
  --spawn-rate 10 \
  --run-time 5m \
  --csv=results/perf_results
```

### 2.2 Locust + pytest 集成

```python
# tests/performance/test_api_load.py
import subprocess
import json
import pytest

def test_api_load_test():
    """运行 locust 负载测试并验证结果"""
    result = subprocess.run([
        "locust", "-f", "tests/performance/locustfile.py",
        "--host", "http://localhost:8000",
        "--headless", "--users", "50", "--spawn-rate", "5",
        "--run-time", "2m", "--csv", "results/load_test"
    ], capture_output=True, text=True, timeout=180)
    
    assert result.returncode == 0
    
    检查 CSV 结果
    import csv
    with open("results/load_test_stats.csv") as f:
        reader = csv.DictReader(f)
        for row in reader:
            if row.get("Name") == "Aggregated":
                avg_response = float(row["Average Response Time"])
                assert avg_response < 500, f"平均响应时间 {avg_response}ms > 500ms"
                fail_ratio = float(row["Failures/s"]) / float(row["Requests/s"])
                assert fail_ratio < 0.01, f"失败率 {fail_ratio:.2%} > 1%"
```

### 2.3 k6 负载测试（跨语言项目推荐）

```javascript
// tests/performance/api_load.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 20 },   热身
    { duration: '2m', target: 100 },   负载
    { duration: '30s', target: 0 },    冷却
  ],
  thresholds: {
    http_req_duration: ['p(95)<500'],   95% 请求 < 500ms
    http_req_failed: ['rate<0.01'],     失败率 < 1%
  },
};

export default function() {
  let res = http.get('http://localhost:8000/api/users');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  sleep(1);
}
```

```bash
k6 run tests/performance/api_load.js
```

---

## 3. 性能回归检测策略

### 3.1 基线建立

```markdown
## 性能基线文档模板

### 基线信息
- 建立日期: YYYY-MM-DD
- 环境: Python 3.11, FastAPI 0.100, PostgreSQL 15
- 数据量: 1000 用户, 10000 订单

### 基准指标
| 测试项 | P50 | P95 | P99 | 最大 |
|--------|-----|-----|-----|------|
| GET /api/users | 50ms | 120ms | 200ms | 500ms |
| POST /api/orders | 80ms | 200ms | 350ms | 800ms |
| complex_calculation(1000) | 10ms | 15ms | 20ms | 50ms |
```

### 3.2 CI 阈值设定

```yaml
# .github/workflows/performance.yml
jobs:
  performance:
    runs-on: ubuntu-latest
    steps:
      - name: Run benchmark
        run: pytest tests/performance/ --benchmark-json=benchmark.json
      
      - name: Check regression
        run: |
          python -c "
          import json
          with open('benchmark.json') as f:
              data = json.load(f)
          for bench in data['benchmarks']:
              if bench['stats']['max'] > bench['stats']['mean'] * 3:
                  print(f\"性能异常: {bench['name']} 最大耗时过长\")
                  exit(1)
          "
```

### 3.3 告警规则

| 指标 | 警告阈值 | 严重阈值 | 动作 |
|------|---------|---------|------|
| P95 响应时间 | +20% vs 基线 | +50% vs 基线 | 警告/阻塞 PR |
| 失败率 | > 0.5% | > 2% | 警告/阻塞 PR |
| 内存使用 | +15% vs 基线 | +30% vs 基线 | 警告/阻塞 PR |
| CPU 使用 | +20% vs 基线 | +40% vs 基线 | 警告/阻塞 PR |

---

## 4. 性能测试数据与隔离

### 4.1 测试数据准备

```python
@pytest.fixture(scope="session")
def performance_dataset():
    """准备性能测试专用数据集（避免与其他测试冲突）"""
    import subprocess
    subprocess.run(["python", "scripts/seed_perf_data.py"], check=True)
    yield
    清理数据
    subprocess.run(["python", "scripts/clear_perf_data.py"], check=True)
```

### 4.2 隔离策略

- **数据库隔离**: 使用独立测试数据库，不与其他测试共享
- **网络隔离**: 性能测试使用独立端口/实例
- **时间隔离**: CI 中在独立 job 运行，不与其他测试并行

---

## 5. 性能测试报告标准化

### 5.1 报告模板

```markdown
## 性能测试报告

**测试日期**: YYYY-MM-DD
**环境**: Python 3.11, FastAPI 0.100, PostgreSQL 15
**并发用户**: 100
**测试时长**: 5 分钟

### 结果摘要
| 指标 | 当前值 | 基线值 | 变化 | 状态 |
|------|--------|--------|------|------|
| P50 响应时间 | 45ms | 50ms | -10% | ✅ 通过 |
| P95 响应时间 | 110ms | 120ms | -8% | ✅ 通过 |
| P99 响应时间 | 180ms | 200ms | -10% | ✅ 通过 |
| 吞吐量 | 850 req/s | 800 req/s | +6% | ✅ 通过 |
| 失败率 | 0.1% | 0.2% | -50% | ✅ 通过 |

### 详细结果
[pytest-benchmark JSON 输出或 locust CSV]

### 结论
- 所有指标均优于基线
- 无性能回归
- 建议合并
```

---

## 6. CI 集成

### 6.1 GitHub Actions 性能测试模板

```yaml
name: Performance Tests

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 6 * * *'  # 每日 6AM

jobs:
  performance:
    runs-on: ubuntu-latest
    timeout-minutes: 30
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: testdb
        ports:
          - 5432:5432
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'
      
      - name: Install dependencies
        run: pip install -r requirements.txt pytest-benchmark locust
      
      - name: Run benchmarks
        run: pytest tests/performance/benchmarks/ --benchmark-json=benchmarks.json
      
      - name: Run load tests
        run: |
          locust -f tests/performance/locustfile.py \
            --headless --users 50 --spawn-rate 5 --run-time 2m \
            --csv=results/load_test
      
      - name: Upload results
        if: always()
        uses: actions/upload-artifact@v3
        with:
          name: performance-results
          path: |
            benchmarks.json
            results/
```

---

## 性能测试清单

- [ ] 单元测试级基准：关键函数有 pytest-benchmark 基线
- [ ] API 级负载测试：核心接口有 locust/k6 脚本
- [ ] 基线已建立并文档化
- [ ] CI 中有性能回归检测
- [ ] 性能阈值已设定（P95、失败率）
- [ ] 测试数据隔离，不与其他测试共享
- [ ] 性能测试在独立 CI job 运行
- [ ] 性能报告标准化输出

---

## 常用插件

```bash
pip install pytest-benchmark locust pytest-timeout memory-profiler
```

| 插件 | 功能 |
|------|------|
| `pytest-benchmark` | 性能基准测试 |
| `locust` | 负载/压力测试 |
| `pytest-timeout` | 测试超时控制 |
| `memory-profiler` | 内存使用分析 |

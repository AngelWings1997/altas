# 测试质量度量体系

> **调用时机**: TEST 模式下需要量化评估测试质量、设定质量门禁或生成质量报告时加载
> **配合使用**: `references/testing/pytest-patterns.md`、`references/testing/ci-cd-integration.md`

---

## 核心原则

1. **可量化**: 所有质量维度都有数值化指标
2. **可比较**: 历史数据可追踪趋势
3. **可行动**: 每个指标都对应具体的改进措施
4. **自动化**: 指标收集和分析应自动化
5. **分层级**: 不同项目/模块可有不同标准

---

## 质量指标总览

### 一级指标（必须监控）

| # | 指标 | 定义 | 工具 | 目标值 | 权重 |
|---|------|------|------|--------|------|
| 1 | **测试覆盖率** | 被测代码行数 / 总代码行数 | pytest-cov | ≥80% (核心≥95%) | ⭐⭐⭐⭐⭐ |
| 2 | **测试通过率** | 通过测试数 / 总测试数 | pytest | =100% (0 failures) | ⭐⭐⭐⭐⭐ |
| 3 | **Flaky Rate** | 不稳定测试次数 / 总运行次数 | pytest-rerunfailures | <1% | ⭐⭐⭐⭐ |
| 4 | **测试执行时间** | 完整套件运行时间 | pytest --durations | <5min (单元<2min) | ⭐⭐⭐ |

### 二级指标（建议监控）

| # | 指标 | 定义 | 工具 | 目标值 | 权重 |
|---|------|------|------|--------|------|
| 5 | **断言密度** | 断言数量 / 测试函数数量 | 自定义分析 | 2-4 个/测试 | ⭐⭐⭐⭐ |
| 6 | **Mock 比例** | 使用 Mock 的测试 / 总测试数 | 自定义分析 | <30% | ⭐⭐⭐⭐ |
| 7 | **测试复杂度** | 单个测试平均圈复杂度 | radon | <10 | ⭐⭐⭐ |
| 8 | **代码-测试比** | 测试代码行数 / 生产代码行数 | cloc | 1:1 - 2:1 | ⭐⭐⭐ |

### 三级指标（高级优化）

| # | 指标 | 定义 | 工具 | 目标值 | 权重 |
|---|------|------|------|--------|------|
| 9 | **缺陷检出率** | 测试发现的 Bug 数 / 总 Bug 数 | Jira + CI 数据 | >70% | ⭐⭐⭐ |
| 10 | **MTTD (Mean Time To Detect)** | 从引入到发现缺陷的平均时间 | Git blame + CI | <24h | ⭐⭐⭐ |
| 11 | **回归防护度** | 回归测试覆盖的关键路径比例 | 自定义追踪 | >90% | ⭐⭐⭐ |
| 12 | **测试维护成本** | 修改生产代码后需修改的测试比例 | Git diff 分析 | <20% | ⭐⭐ |

---

## 详细指标定义与测量

### 1️⃣ 测试覆盖率（Test Coverage）

#### 分层覆盖率目标

```yaml
# quality_config.yaml
coverage_thresholds:
  global:
    line: 80          # 全局行覆盖率
    branch: 75        # 分支覆盖率
    function: 85      # 函数覆盖率
  
  critical_modules:   # 核心业务逻辑
    - pattern: "src/core/**"
      line: 95
      branch: 90
      function: 98
  
  normal_modules:     # 一般业务逻辑
    - pattern: "src/services/**"
      line: 80
      branch: 75
      function: 85
  
  utility_modules:    # 工具类
    - pattern: "src/utils/**"
      line: 70
      branch: 65
      function: 75
  
  excluded:            # 排除项
    - "*/migrations/*"
    - "*/__init__.py"
    - "tests/*"
```

#### 测量命令

```bash
# 完整覆盖率报告
pytest --cov=src \
       --cov-report=term-missing \
       --cov-report=html:coverage_html \
       --cov-report=xml:coverage.xml \
       --cov-fail-under=80

# 按模块统计
pytest --cov=src/core --cov-report=term-missing
pytest --cov=src/services --cov-report=term-missing

# 排除特定文件
pytest --cov=src --cov-config=.coveragerc
```

#### .coveragerc 配置示例

```ini
[run]
source = src
branch = True
omit =
    */migrations/*
    */__init__.py
    */conftest.py
    tests/*
    venv/*

[report]
exclude_lines =
    pragma: no cover
    def __repr__
    raise NotImplementedError
    if TYPE_CHECKING:
    if DEBUG:
    @abstractmethod

show_missing = True
precision = 2

[html]
directory = coverage_html
```

#### 自动化检查脚本

```python
# scripts/check_coverage.py
"""自动化覆盖率门禁检查"""
import sys
import xml.etree.ElementTree as ET
from pathlib import Path
from typing import Dict, List, Tuple

class CoverageChecker:
    def __init__(self, config_file: str = "quality_config.yaml"):
        self.config = self._load_config(config_file)
        self.results: Dict[str, Dict] = {}
    
    def _load_config(self, config_file: str) -> dict:
        """加载配置文件"""
        try:
            import yaml
            with open(config_file) as f:
                return yaml.safe_load(f)
        except FileNotFoundError:
            return {
                "coverage_thresholds": {
                    "global": {"line": 80, "branch": 75, "function": 85}
                }
            }
    
    def parse_coverage_xml(self, xml_file: str = "coverage.xml") -> None:
        """解析 pytest-cov 生成的 XML"""
        tree = ET.parse(xml_file)
        root = tree.getroot()
        
        # 整体覆盖率
        self.results["global"] = {
            "line_rate": float(root.get("line-rate", 0)) * 100,
            "branch_rate": float(root.get("branch-rate", 0)) * 100,
        }
        
        # 按包/模块统计
        for package in root.findall(".//package"):
            name = package.get("name", "unknown")
            self.results[name] = {
                "line_rate": float(package.get("line-rate", 0)) * 100,
                "branch_rate": float(package.get("branch-rate", 0)) * 100,
            }
    
    def check_thresholds(self) -> Tuple[bool, List[str]]:
        """检查是否满足阈值要求"""
        passed = True
        messages = []
        
        thresholds = self.config.get("coverage_thresholds", {})
        global_threshold = thresholds.get("global", {})
        
        # 检查全局阈值
        global_result = self.results.get("global", {})
        for metric in ["line_rate", "branch_rate"]:
            metric_name = metric.replace("_rate", "")
            threshold = global_threshold.get(metric_name, 80)
            actual = global_result.get(metric, 0)
            
            if actual < threshold:
                passed = False
                messages.append(
                    f"❌ Global {metric_name} coverage {actual:.1f}% "
                    f"is below threshold {threshold}%"
                )
            else:
                messages.append(
                    f"✅ Global {metric_name} coverage {actual:.1f}% "
                    f"(threshold: {threshold}%)"
                )
        
        return passed, messages
    
    def generate_report(self) -> str:
        """生成 Markdown 格式报告"""
        report = ["# 📊 Test Coverage Report\n"]
        
        for name, data in self.results.items():
            line_cov = data.get("line_rate", 0)
            branch_cov = data.get("branch_rate", 0)
            
            status = "✅" if line_cov >= 80 else "⚠️" if line_cov >= 60 else "❌"
            
            report.append(f"## {status} {name}")
            report.append(f"| Metric | Value |")
            report.append(f"|--------|-------|")
            report.append(f"| Line Coverage | {line_cov:.1f}% |")
            report.append(f"| Branch Coverage | {branch_cov:.1f}% |")
            report.append("")
        
        return "\n".join(report)

if __name__ == "__main__":
    checker = CoverageChecker()
    checker.parse_coverage_xml()
    
    passed, messages = checker.check_thresholds()
    
    for msg in messages:
        print(msg)
    
    print("\n" + checker.generate_report())
    
    sys.exit(0 if passed else 1)
```

---

### 2️⃣ 测试通过率（Pass Rate）

#### 定义与计算

```
Pass Rate = (Passed Tests / Total Tests) × 100%
目标: 100%（零容忍失败）
```

#### 门禁规则

```yaml
pass_rate_rules:
  strict_mode:          # PR 合并前
    required_pass_rate: 100%
    allow_skipped: true
    allow_expected_failures: false
    
  relaxed_mode:         # 开发分支
    required_pass_rate: 100%
    allow_skipped: true
    allow_expected_failures: true
    max_failures: 0      # 零失败
  
  regression_only:      # 仅回归测试
    required_pass_rate: 100%
    fail_on_error: true
```

#### 自动化验证

```bash
# pytest 退出码含义
# 0: 所有测试通过
# 1: 有测试失败
# 2: 用户中断
# 3: 内部错误
# 4: pytest 命令行使用错误
# 5: 未收集到任何测试

# CI 中的严格检查
pytest tests/ \
  --strict-markers \     # 未注册的 marker 报错
  -W error \             # 将 warning 视为错误
  --failed-first \       # 先跑上次失败的测试
  -x                     # 首次失败即停止（可选）
```

---

### 3️⃣ Flaky Rate（不稳定测试率）

#### 计算方法

```
Flaky Rate = (Flaky Test Occurrences / Total Test Runs) × 100%

Flaky Test: 连续 3 次运行中至少 1 次结果不一致的测试
目标: <1%
```

#### 检测机制

```python
# conftest.py - Flaky test 检测器
import pytest
from pathlib import Path
import json
from datetime import datetime

FLAKY_RESULTS_FILE = Path(".flaky_results.json")

def pytest_runtest_logreport(report):
    """记录每次测试结果用于 flaky 检测"""
    if report.when == 'call':
        results = _load_flaky_results()
        test_id = report.nodeid
        
        if test_id not in results:
            results[test_id] = []
        
        results[test_id].append({
            "outcome": report.outcome,
            "timestamp": datetime.utcnow().isoformat(),
        })
        
        # 只保留最近 10 次结果
        results[test_id] = results[test_id][-10:]
        
        _save_flaky_results(results)

def _load_flaky_results() -> dict:
    if FLAKY_RESULTS_FILE.exists():
        with open(FLAKY_RESULTS_FILE) as f:
            return json.load(f)
    return {}

def _save_flaky_results(results: dict):
    with open(FLAKY_RESULTS_FILE, 'w') as f:
        json.dump(results, f, indent=2)

def pytest_terminal_summary(terminalreporter):
    """在测试结束时报告 flaky 测试"""
    results = _load_flaky_results()
    flaky_tests = []
    
    for test_id, runs in results.items():
        if len(runs) >= 3:
            outcomes = [r["outcome"] for r in runs[-3:]]
            if len(set(outcomes)) > 1:  # 最近 3 次结果不一致
                flaky_tests.append(test_id)
    
    if flaky_tests:
        terminalreporter.write_sep("=", f"⚠️  Found {len(flaky_tests)} flaky test(s)")
        for test in flaky_tests:
            terminalreporter.write_line(f"  - {test}", red=True)
        terminalreporter.write_line("\nPlease fix or mark with @pytest.mark.flaky")
```

#### 处理策略

```python
# 对已知的不稳定测试进行标记和隔离
import pytest

@pytest.mark.flaky(reruns=3, reruns_delay=1)
def test_network_dependent_operation():
    """网络依赖操作 - 可能因超时不稳定"""
    ...

# 或者临时跳过并创建 issue
@pytest.mark.xfail(
    reason="Flaky due to race condition - Issue #123",
    strict=False
)
def test_concurrent_write():
    ...
```

---

### 4️⃣ 测试执行时间（Execution Time）

#### 时间预算表

| 测试层级 | 预算时间 | 说明 |
|----------|---------|------|
| 单个单元测试 | <100ms | 快速反馈 |
| 单个集成测试 | <2s | 允许 DB 操作 |
| 单个 E2E 测试 | <30s | 包含浏览器启动 |
| 完整单元测试套件 | <2min | 开发者本地运行 |
| 完整集成测试套件 | <5min | CI 反馈循环 |
| 完整 E2E 测试套件 | <15min | 可接受较长时间 |

#### 监控命令

```bash
# 显示最慢的 20 个测试
pytest --durations=20

# 按时间排序，找出耗时最长的测试
pytest --durations=0 -q

# 输出为 CSV 用于后续分析
pytest --durations=0 --duration-min=1.0 > slow_tests.csv

# 设置单个测试超时
pip install pytest-timeout
pytest --timeout=30  # 30 秒超时

# 按类设置不同超时
@pytest.mark.timeout(300, method='thread')
class TestSlowFeature:
    ...
```

#### 自动化性能回归检测

```python
# scripts/test_performance_baseline.py
"""建立和维护测试执行时间基线"""

import subprocess
import json
from pathlib import Path
from datetime import datetime

BASELINE_FILE = Path(".test_performance_baseline.json")

def collect_durations() -> dict:
    """收集当前测试执行时长"""
    result = subprocess.run(
        ["pytest", "--durations=0", "-v", "--tb=no"],
        capture_output=True,
        text=True
    )
    
    durations = {}
    # 解析输出...
    return durations

def update_baseline(durations: dict):
    """更新基线（保留历史数据）"""
    baseline = {}
    if BASELINE_FILE.exists():
        baseline = json.loads(BASELINE_FILE.read_text())
    
    today = datetime.now().strftime("%Y-%m-%d")
    baseline[today] = {
        "total_time": sum(durations.values()),
        "slowest_tests": sorted(
            durations.items(), 
            key=lambda x: x[1], 
            reverse=True
        )[:10],
        "test_count": len(durations),
    }
    
    BASELINE_FILE.write_text(json.dumps(baseline, indent=2))

def check_regression(threshold_percent: float = 20.0) -> bool:
    """检测性能回退"""
    baseline = json.loads(BASELINE_FILE.read_text()) if BASELINE_FILE.exists() else {}
    current = collect_durations()
    
    dates = sorted(baseline.keys())
    if not dates:
        return True
    
    last_baseline = baseline[dates[-1]]
    current_total = sum(current.values())
    baseline_total = last_baseline["total_time"]
    
    increase_percent = ((current_total - baseline_total) / baseline_total) * 100
    
    if increase_percent > threshold_percent:
        print(f"⚠️ Performance regression detected!")
        print(f"   Baseline: {baseline_total:.2f}s")
        print(f"   Current:  {current_total:.2f}s")
        print(f"   Increase: +{increase_percent:.1f}%")
        return False
    
    return True

if __name__ == "__main__":
    durations = collect_durations()
    update_baseline(durations)
    
    if not check_regression():
        exit(1)
```

---

### 5️⃣ 断言密度（Assertion Density）

#### 定义

```
Assertion Density = Total Assertions / Number of Test Functions
理想范围: 2-4 个断言/测试
```

#### 为什么重要

- **太低 (<1)**: 测试可能不够充分，遗漏边界条件
- **太高 (>10)**: 测试可能过于复杂，违反单一职责
- **刚好 (2-4)**: 测试聚焦且充分

#### 测量工具

```python
# scripts/assertion_density.py
"""分析断言密度"""

import ast
from pathlib import Path
from collections import defaultdict

class AssertionVisitor(ast.NodeVisitor):
    def __init__(self):
        self.assertions = 0
        self.test_functions = 0
    
    def visit_Assert(self, node):
        self.assertions += 1
        self.generic_visit(node)
    
    def visit_Call(self, node):
        # 检测 assert 方法调用
        if isinstance(node.func, ast.Attribute):
            if node.func.attr.startswith('assert'):
                self.assertions += 1
        self.generic_visit(node)
    
    def visit_FunctionDef(self, node):
        if node.name.startswith('test_') or isinstance(node.parent, ast.ClassDef):
            self.test_functions += 1
        self.generic_visit(node)

def analyze_directory(test_dir: str = "tests") -> dict:
    visitor = AssertionVisitor()
    
    for py_file in Path(test_dir).rglob("*.py"):
        try:
            tree = ast.parse(py_file.read_text())
            visitor.visit(tree)
        except SyntaxError:
            continue
    
    density = visitor.assertions / max(visitor.test_functions, 1)
    
    return {
        "total_assertions": visitor.assertions,
        "total_test_functions": visitor.test_functions,
        "assertion_density": round(density, 2),
        "rating": self._rate_density(density),
    }

def _rate_density(self, density: float) -> str:
    if density < 1:
        return "⚠️ Too low - tests may be insufficient"
    elif density <= 4:
        return "✅ Good - adequate assertions per test"
    elif density <= 8:
        return "📝 Acceptable but consider splitting complex tests"
    else:
        return "❌ Too high - tests may be doing too much"

if __name__ == "__main__":
    result = analyze_directory()
    print(json.dumps(result, indent=2))
```

---

### 6️⃣ Mock 比例（Mock Ratio）

#### 目标与风险

```
Mock Ratio = Tests Using Mocks / Total Tests × 100%
目标: <30%
```

**高 Mock 比例的风险**：
- 测试可能验证的是 mock 行为而非真实行为
- 重构时 mock 可能掩盖接口变更
- 过度耦合到实现细节

#### 测量方法

```bash
# 统计使用 unittest.mock 的测试
grep -r "from unittest.mock\|from mock\|@patch\|mock_" tests/ | wc -l

# 统计总测试数
grep -r "def test_\|async def test_" tests/ | wc -l
```

#### 改进指南

| 当前比例 | 建议 |
|----------|------|
| <20% | ✅ 优秀，保持 |
| 20-40% | ⚠️ 可接受，审查 mock 必要性 |
| 40-60% | ❌ 过高，优先重构为集成测试 |
| >60% | 🚨 危险信号，重新设计测试策略 |

---

## 综合质量评分卡

### 评分算法

```python
# scripts/quality_scorecard.py
"""生成综合测试质量评分"""

class TestQualityScorecard:
    WEIGHTS = {
        "coverage": 0.25,
        "pass_rate": 0.25,
        "flaky_rate": 0.15,
        "execution_time": 0.10,
        "assertion_density": 0.10,
        "mock_ratio": 0.15,
    }
    
    def calculate_score(self, metrics: dict) -> dict:
        """计算加权总分"""
        scores = {}
        
        # 1. 覆盖率得分 (0-100)
        cov = metrics.get("coverage", 0)
        scores["coverage"] = min(100, cov * 1.25)  # 80% → 100分
        
        # 2. 通过率得分
        pass_rate = metrics.get("pass_rate", 0)
        scores["pass_rate"] = pass_rate  # 直接使用百分比
        
        # 3. 稳定性得分 (flaky rate 越低越好)
        flaky = metrics.get("flaky_rate", 0)
        scores["flaky_rate"] = max(0, 100 - (flaky * 10))
        
        # 4. 执行时间得分
        time = metrics.get("execution_time_seconds", 600)
        if time < 120:  # <2分钟
            scores["execution_time"] = 100
        elif time < 300:  # <5分钟
            scores["execution_time"] = 80
        elif time < 600:  # <10分钟
            scores["execution_time"] = 60
        else:
            scores["execution_time"] = max(0, 40 - (time - 600) / 30)
        
        # 5. 断言密度得分
        density = metrics.get("assertion_density", 0)
        if 2 <= density <= 4:
            scores["assertion_density"] = 100
        elif 1 <= density <= 6:
            scores["assertion_density"] = 80
        else:
            scores["assertion_density"] = 50
        
        # 6. Mock 比例得分 (越低越好)
        mock_ratio = metrics.get("mock_ratio", 0)
        scores["mock_ratio"] = max(0, 100 - (mock_ratio * 1.5))
        
        # 加权总分
        total_score = sum(
            scores[metric] * weight 
            for metric, weight in self.WEIGHTS.items()
        )
        
        return {
            "individual_scores": scores,
            "weighted_total": round(total_score, 1),
            "grade": self._get_grade(total_score),
        }
    
    def _get_grade(self, score: float) -> str:
        if score >= 90:
            return "A+ 🏆 Excellent"
        elif score >= 80:
            return "A ✅ Great"
        elif score >= 70:
            return "B 👍 Good"
        elif score >= 60:
            return "C ⚠️ Acceptable"
        else:
            return "D ❌ Needs Improvement"

def generate_report(scorecard_data: dict) -> str:
    """生成 Markdown 报告"""
    report = [
        "# 🧪 Test Quality Scorecard\n",
        f"**Overall Grade**: {scorecard_data['grade']}",
        f"**Total Score**: {scorecard_data['weighted_total']}/100\n",
        "| Metric | Score | Weight | Weighted |",
        "|--------|-------|--------|----------|",
    ]
    
    weights = TestQualityScorecard.WEIGHTS
    for metric, score in scorecard_data['individual_scores'].items():
        weighted = score * weights[metric]
        report.append(f"| {metric.replace('_', ' ').title()} | {score}/100 | {weights[weight]*100:.0f}% | {weighted:.1f} |")
    
    return "\n".join(report)

if __name__ == "__main__":
    scorer = TestQualityScorecard()
    
    # 示例数据（实际从 CI 收集）
    metrics = {
        "coverage": 82.5,
        "pass_rate": 99.2,
        "flaky_rate": 0.8,
        "execution_time_seconds": 245,
        "assertion_density": 3.2,
        "mock_ratio": 22,
    }
    
    result = scorer.calculate_score(metrics)
    print(generate_report(result))
```

### 示例输出

```
# 🧪 Test Quality Scorecard

**Overall Grade**: A+ 🏆 Excellent
**Total Score**: 91.7/100

| Metric | Score | Weight | Weighted |
|--------|-------|--------|----------|
| Coverage | 103.1/100 | 25% | 25.8 |
| Pass Rate | 99.2/100 | 25% | 24.8 |
| Flaky Rate | 92.0/100 | 15% | 13.8 |
| Execution Time | 80.0/100 | 10% | 8.0 |
| Assertion Density | 100.0/100 | 10% | 10.0 |
| Mock Ratio | 67.0/100 | 15% | 10.1 |
```

---

## 质量门禁配置

### CI/CD 门禁示例

```yaml
# .github/workflows/quality-gate.yml
name: Quality Gate

on:
  pull_request:
    branches: [main]

jobs:
  quality-check:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v4
    
    - uses: actions/setup-python@v5
      with:
        python-version: '3.11'
    
    - name: Install dependencies
      run: pip install pytest-cov pytest-timeout
    
    - name: Run tests with all checks
      run: |
        pytest tests/ \
          --cov=src \
          --cov-fail-under=80 \
          --cov-report=xml \
          --timeout=300 \
          --tb=short \
          -q
    
    - name: Check quality metrics
      run: python scripts/quality_scorecard.py
    
    - name: Generate quality badge
      if: always()
      uses: schneegans/dynamic-badges-action@v1
      with:
        auth: ${{ secrets.GITHUB_TOKEN }}
        gistID: your-gist-id
        filename: test-quality.svg
        label: Test Quality
        message: ${{ steps.score.outputs.grade }}
        color: ${{ steps.score.outputs.color }}
```

### 分级门禁策略

| 场景 | 覆盖率 | 通过率 | Flaky Rate | 执行时间 | 行动 |
|------|--------|--------|------------|----------|------|
| **PR 到 main** | ≥80% | 100% | 0% | <5min | ✅ 允许合并 |
| **PR 到 main** | 70-79% | 100% | <1% | <10min | ⚠️ 警告但允许 |
| **PR 到 main** | <70% | <100% | >1% | >10min | ❌ 阻止合并 |
| **开发分支** | ≥60% | ≥95% | <2% | 无限制 | ℹ️ 仅提醒 |
| **Release 分支** | ≥90% | 100% | 0% | <10min | 🔒 强制执行 |

---

## 改进路线图

### 阶段一：建立基线（第 1 周）

- [ ] 运行完整测试套件收集当前指标
- [ ] 建立覆盖率基线
- [ ] 记录执行时间基线
- [ ] 识别 flaky 测试清单
- [ ] 配置自动化指标收集

### 阶段二：达到门槛（第 2-4 周）

- [ ] 将覆盖率提升至 80%+
- [ ] 修复所有 flaky 测试或标记原因
- [ ] 执行时间优化至 <5 分钟
- [ ] 建立每日质量报告

### 阶段三：持续优化（持续）

- [ ] 核心模块覆盖率提升至 95%+
- [ ] 降低 mock 比例至 30% 以下
- [ ] 建立缺陷检出率跟踪
- [ ] 定期审查和调整阈值

---

## 最佳实践总结

### 团队层面

1. **定义清晰的质量 SLA**
   - 与团队达成一致的目标值
   - 写入项目文档和 CI 配置
   - 定期评审和调整

2. **可视化展示**
   - 在 README 中嵌入质量徽章
   - PR 中自动显示质量变化
   - 定期发送质量周报

3. **持续改进文化**
   - 不追责个人，关注系统改进
   - 庆祝质量提升里程碑
   - 分享最佳实践案例

### 个人层面

1. **写测试时思考质量**
   - 每个测试有明确目的
   - 断言充分但不冗余
   - 优先真实依赖，减少 mock

2. **定期自检**
   - 运行 `--durations` 关注慢测试
   - 查看覆盖率报告识别盲区
   - 审查自己的测试是否有价值

3. **学习与分享**
   - 阅读优秀开源项目的测试
   - 参加团队测试评审
   - 编写测试最佳实践文档

---

## 快速诊断命令

```bash
# 一键健康检查
echo "=== Test Suite Health Check ===" && \
echo "" && \
echo "1. Coverage:" && pytest --cov=src --co -q 2>/dev/null && \
echo "" && \
echo "2. Pass Rate:" && pytest --tb=no -q 2>&1 | tail -5 && \
echo "" && \
echo "3. Slowest Tests:" && pytest --durations=5 -q --tb=no && \
echo "" && \
echo "4. Test Count:" && pytest --collect-only -q 2>&1 | grep "test session starts" -A 1 && \
echo "" && \
echo "=== End Health Check ==="
```

---

**版本**: 1.0.0
**兼容**: Python 3.8+, pytest 7.0+, pytest-cov 4.0+
**依赖**: `pytest`, `pytest-cov`, `pytest-timeout`, `radon` (可选), `cloc` (可选)

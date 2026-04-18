# 测试可观测性

> **调用时机**: 需要调试测试失败、分析测试性能、建立测试度量体系时加载
> **配合使用**: `references/testing/test-quality-metrics.md`（质量度量）、`references/superpowers/systematic-debugging/SKILL.md`（系统化调试）

---

## 核心原则

1. **测试即代码**: 测试代码需要与生产代码同等级别的可观测性
2. **失败可解释**: 测试失败时，应能立即定位问题根因
3. **性能可度量**: 测试执行时间、资源消耗需要被监控
4. **趋势可追踪**: 测试质量指标的变化趋势需要可视化

---

## 1. 测试日志

### 结构化日志

```python
# tests/conftest.py
import logging
import json
from datetime import datetime
import pytest


class JSONFormatter(logging.Formatter):
    """JSON 格式日志，便于分析"""
    
    def format(self, record):
        log_data = {
            "timestamp": datetime.utcnow().isoformat(),
            "level": record.levelname,
            "logger": record.name,
            "message": record.getMessage(),
            "test_name": getattr(record, "test_name", None),
            "test_phase": getattr(record, "test_phase", None),
            "duration_ms": getattr(record, "duration_ms", None),
        }
        
        if record.exc_info:
            log_data["exception"] = self.formatException(record.exc_info)
        
        return json.dumps(log_data, ensure_ascii=False)


def pytest_configure(config):
    """配置测试日志"""
    # 清除默认处理器
    logging.root.handlers = []
    
    # 创建文件处理器
    file_handler = logging.FileHandler("test-results/test.log")
    file_handler.setFormatter(JSONFormatter())
    file_handler.setLevel(logging.DEBUG)
    
    # 创建控制台处理器
    console_handler = logging.StreamHandler()
    console_handler.setFormatter(
        logging.Formatter('%(asctime)s - %(levelname)s - %(message)s')
    )
    console_handler.setLevel(logging.INFO)
    
    # 配置根日志器
    logging.root.addHandler(file_handler)
    logging.root.addHandler(console_handler)
    logging.root.setLevel(logging.DEBUG)


@pytest.fixture(autouse=True)
def test_logger(request):
    """为每个测试提供结构化日志记录器"""
    logger = logging.getLogger(f"test.{request.node.name}")
    
    # 添加测试上下文
    extra = {"test_name": request.node.name}
    
    yield logger
```

### 测试执行日志

```python
# tests/test_example.py
import logging
import pytest

logger = logging.getLogger(__name__)


def test_user_registration(test_logger):
    """用户注册测试，带详细日志"""
    test_logger.info("开始用户注册测试", extra={"test_phase": "setup"})
    
    # 准备测试数据
    user_data = {"email": "test@example.com", "password": "Secure123!"}
    test_logger.debug(f"测试数据: {user_data}", extra={"test_phase": "data_prep"})
    
    # 执行操作
    test_logger.info("发送注册请求", extra={"test_phase": "execution"})
    response = api_client.post("/api/register", json=user_data)
    
    # 验证结果
    test_logger.info(f"响应状态: {response.status_code}", extra={"test_phase": "verification"})
    
    assert response.status_code == 201, f"注册失败: {response.text}"
    
    # 验证数据库
    user = db.query(User).filter_by(email=user_data["email"]).first()
    test_logger.info(f"数据库验证: user_id={user.id}", extra={"test_phase": "cleanup"})
    
    assert user is not None
    assert user.email_verified is False
```

### 日志分析

```bash
# 使用 jq 分析 JSON 日志
# 统计失败的测试
cat test-results/test.log | jq -r 'select(.level == "ERROR") | .test_name' | sort | uniq -c

# 查找最慢的测试
cat test-results/test.log | jq -r 'select(.duration_ms != null) | [.duration_ms, .test_name] | @tsv' | sort -rn | head -20

# 按测试阶段统计
cat test-results/test.log | jq -r '.test_phase' | sort | uniq -c
```

---

## 2. 测试追踪 (OpenTelemetry)

### 配置 OpenTelemetry

```python
# tests/conftest.py
from opentelemetry import trace
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.resources import Resource, SERVICE_NAME
import pytest


# 配置 Tracer
resource = Resource(attributes={
    SERVICE_NAME: "test-suite"
})

provider = TracerProvider(resource=resource)
processor = BatchSpanProcessor(OTLPSpanExporter())
provider.add_span_processor(processor)
trace.set_tracer_provider(provider)

tracer = trace.get_tracer(__name__)


@pytest.fixture(autouse=True)
def trace_test(request):
    """为每个测试创建追踪 Span"""
    with tracer.start_as_current_span(
        name=f"test:{request.node.name}",
        attributes={
            "test.file": request.node.fspath.strpath,
            "test.class": request.node.cls.__name__ if request.node.cls else None,
            "test.type": "unit" if "unit" in request.node.nodeid else "integration"
        }
    ) as span:
        yield span
        
        # 记录测试结果
        outcome = getattr(request.node, "rep_call", None)
        if outcome:
            span.set_attribute("test.outcome", outcome.outcome)
            if outcome.failed:
                span.set_attribute("test.failure_message", str(outcome.longrepr))
```

### 追踪测试步骤

```python
# tests/test_order_flow.py
from opentelemetry import trace

tracer = trace.get_tracer(__name__)


def test_order_creation_flow(api_client, db):
    """订单创建流程，带详细追踪"""
    
    with tracer.start_as_current_span("test.order_creation"):
        # Step 1: 创建用户
        with tracer.start_as_current_span("step.create_user") as span:
            user = create_test_user()
            span.set_attribute("user.id", user.id)
            span.set_attribute("user.email", user.email)
        
        # Step 2: 添加商品到购物车
        with tracer.start_as_current_span("step.add_to_cart") as span:
            product = create_test_product(price=100.00)
            cart_item = add_to_cart(user.id, product.id, quantity=2)
            span.set_attribute("product.id", product.id)
            span.set_attribute("cart.quantity", 2)
        
        # Step 3: 创建订单
        with tracer.start_as_current_span("step.create_order") as span:
            order = create_order_from_cart(user.id)
            span.set_attribute("order.id", order.id)
            span.set_attribute("order.total", float(order.total))
        
        # Step 4: 验证订单
        with tracer.start_as_current_span("step.verify_order"):
            assert order.status == "pending"
            assert order.total == 200.00
```

### 追踪数据库查询

```python
# tests/utils/sqlalchemy_tracing.py
from sqlalchemy import event
from opentelemetry import trace

tracer = trace.get_tracer("sqlalchemy")


def instrument_sqlalchemy(engine):
    """为 SQLAlchemy 添加追踪"""
    
    @event.listens_for(engine, "before_cursor_execute")
    def before_cursor_execute(conn, cursor, statement, parameters, context, executemany):
        context._span = tracer.start_span("db.query")
        context._span.set_attribute("db.statement", statement[:1000])
        context._span.set_attribute("db.parameters", str(parameters)[:500])
    
    @event.listens_for(engine, "after_cursor_execute")
    def after_cursor_execute(conn, cursor, statement, parameters, context, executemany):
        if hasattr(context, "_span"):
            context._span.end()
```

---

## 3. 测试指标 (Metrics)

### 自定义指标收集

```python
# tests/conftest.py
from opentelemetry import metrics
from opentelemetry.sdk.metrics import MeterProvider
from opentelemetry.sdk.metrics.export import PeriodicExportingMetricReader
from opentelemetry.exporter.otlp.proto.grpc.metric_exporter import OTLPMetricExporter
import time
import pytest


# 配置 Metrics
metric_reader = PeriodicExportingMetricReader(OTLPMetricExporter())
metrics_provider = MeterProvider(metric_readers=[metric_reader])
metrics.set_meter_provider(metrics_provider)

meter = metrics.get_meter(__name__)

# 定义指标
test_duration = meter.create_histogram(
    name="test.duration",
    description="Test execution duration",
    unit="ms"
)

test_outcome = meter.create_counter(
    name="test.outcome",
    description="Test outcome counts"
)

test_assertions = meter.create_histogram(
    name="test.assertions",
    description="Number of assertions per test"
)


@pytest.fixture(autouse=True)
def metrics_collector(request):
    """收集测试指标"""
    start_time = time.time()
    assertion_count = [0]  # 使用列表实现 nonlocal
    
    # 包装 assert 语句以计数
    original_assert = pytest.assertion.rewrite.AssertionRewriter
    
    yield
    
    # 记录执行时间
    duration_ms = (time.time() - start_time) * 1000
    test_duration.record(
        duration_ms,
        attributes={"test.name": request.node.name}
    )
```

### 测试覆盖率趋势

```python
# tests/utils/coverage_tracker.py
import json
from datetime import datetime
from pathlib import Path


class CoverageTracker:
    """追踪覆盖率趋势"""
    
    def __init__(self, history_file="test-results/coverage-history.json"):
        self.history_file = Path(history_file)
        self.history = self._load_history()
    
    def _load_history(self):
        if self.history_file.exists():
            with open(self.history_file) as f:
                return json.load(f)
        return []
    
    def record(self, coverage_data):
        """记录覆盖率数据"""
        entry = {
            "timestamp": datetime.utcnow().isoformat(),
            "commit": coverage_data.get("commit_sha"),
            "branch": coverage_data.get("branch"),
            "overall": coverage_data.get("totals", {}).get("percent_covered", 0),
            "by_module": coverage_data.get("modules", {})
        }
        
        self.history.append(entry)
        
        # 只保留最近 100 条记录
        self.history = self.history[-100:]
        
        with open(self.history_file, "w") as f:
            json.dump(self.history, f, indent=2)
    
    def get_trend(self, module=None, days=7):
        """获取覆盖率趋势"""
        import pandas as pd
        
        df = pd.DataFrame(self.history)
        df["timestamp"] = pd.to_datetime(df["timestamp"])
        
        if module:
            df["coverage"] = df["by_module"].apply(lambda x: x.get(module, 0))
        else:
            df["coverage"] = df["overall"]
        
        return df[df["timestamp"] > datetime.utcnow() - pd.Timedelta(days=days)]
    
    def detect_regression(self, threshold=1.0):
        """检测覆盖率下降"""
        if len(self.history) < 2:
            return None
        
        current = self.history[-1]["overall"]
        previous = self.history[-2]["overall"]
        
        drop = previous - current
        if drop > threshold:
            return {
                "previous": previous,
                "current": current,
                "drop": drop,
                "message": f"覆盖率下降 {drop:.2f}%: {previous:.2f}% -> {current:.2f}%"
            }
        return None


# pytest 插件集成
def pytest_terminal_summary(terminalreporter, exitstatus, config):
    """在测试结束时记录覆盖率"""
    try:
        import coverage
        cov = coverage.Coverage()
        cov.load()
        data = cov.get_data()
        
        tracker = CoverageTracker()
        tracker.record({
            "totals": {"percent_covered": cov.report(file=Path("/dev/null"))},
            "commit_sha": os.environ.get("GIT_COMMIT_SHA"),
            "branch": os.environ.get("GIT_BRANCH")
        })
        
        # 检测回归
        regression = tracker.detect_regression()
        if regression:
            terminalreporter.write_sep("=", "⚠️ 覆盖率回归警告")
            terminalreporter.write_line(regression["message"])
    except Exception:
        pass
```

---

## 4. 测试报告增强

### 自定义 pytest 报告

```python
# tests/conftest.py
import pytest
from pathlib import Path
import json


class TestReportPlugin:
    """自定义测试报告插件"""
    
    def __init__(self):
        self.results = []
    
    def pytest_runtest_logreport(self, report):
        """收集测试结果"""
        if report.when == "call":
            result = {
                "nodeid": report.nodeid,
                "outcome": report.outcome,
                "duration": report.duration,
                "timestamp": datetime.utcnow().isoformat(),
                "markers": [m.name for m in report.keywords.get("pytestmark", [])],
            }
            
            if report.failed:
                result["failure"] = {
                    "message": str(report.longrepr.reprcrash.message) if report.longrepr else None,
                    "traceback": str(report.longrepr) if report.longrepr else None,
                }
            
            self.results.append(result)
    
    def pytest_sessionfinish(self, session, exitstatus):
        """生成报告文件"""
        output_dir = Path("test-results")
        output_dir.mkdir(exist_ok=True)
        
        # JSON 报告
        with open(output_dir / "test-report.json", "w") as f:
            json.dump({
                "summary": {
                    "total": len(self.results),
                    "passed": sum(1 for r in self.results if r["outcome"] == "passed"),
                    "failed": sum(1 for r in self.results if r["outcome"] == "failed"),
                    "skipped": sum(1 for r in self.results if r["outcome"] == "skipped"),
                },
                "tests": self.results
            }, f, indent=2)
        
        # HTML 报告
        self._generate_html_report()
    
    def _generate_html_report(self):
        """生成 HTML 报告"""
        html = """
        <!DOCTYPE html>
        <html>
        <head>
            <title>Test Report</title>
            <style>
                body { font-family: Arial, sans-serif; margin: 20px; }
                .passed { color: green; }
                .failed { color: red; }
                .skipped { color: orange; }
                table { border-collapse: collapse; width: 100%; }
                th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
                th { background-color: #f2f2f2; }
            </style>
        </head>
        <body>
            <h1>Test Report</h1>
            <table>
                <tr>
                    <th>Test</th>
                    <th>Outcome</th>
                    <th>Duration</th>
                </tr>
        """
        
        for result in self.results:
            html += f"""
                <tr>
                    <td>{result['nodeid']}</td>
                    <td class="{result['outcome']}">{result['outcome']}</td>
                    <td>{result['duration']:.3f}s</td>
                </tr>
            """
        
        html += """
            </table>
        </body>
        </html>
        """
        
        with open("test-results/test-report.html", "w") as f:
            f.write(html)


# 注册插件
def pytest_configure(config):
    config.pluginmanager.register(TestReportPlugin())
```

---

## 5. 失败分析

### 自动失败分类

```python
# tests/utils/failure_classifier.py
import re
from dataclasses import dataclass
from typing import Optional


@dataclass
class FailureAnalysis:
    category: str
    confidence: float
    root_cause: str
    suggested_fix: str


class FailureClassifier:
    """自动分类测试失败原因"""
    
    PATTERNS = {
        "assertion_error": {
            "patterns": [r"AssertionError", r"assert .* failed"],
            "category": "Assertion Failure",
            "suggested_fix": "检查期望值和实际值是否匹配"
        },
        "timeout_error": {
            "patterns": [r"TimeoutError", r"timed out", r"Timeout"],
            "category": "Timeout",
            "suggested_fix": "增加超时时间或优化被测代码性能"
        },
        "connection_error": {
            "patterns": [r"ConnectionError", r"Connection refused", r"Cannot connect"],
            "category": "Connection Issue",
            "suggested_fix": "检查服务是否启动、网络是否连通"
        },
        "database_error": {
            "patterns": [r"OperationalError", r"IntegrityError", r"database is locked"],
            "category": "Database Error",
            "suggested_fix": "检查数据库连接、事务隔离级别"
        },
        "flaky_test": {
            "patterns": [r"flaky", r"intermittent", r"race condition"],
            "category": "Flaky Test",
            "suggested_fix": "增加同步机制、重试逻辑或重构测试"
        },
        "dependency_error": {
            "patterns": [r"ImportError", r"ModuleNotFoundError"],
            "category": "Dependency Issue",
            "suggested_fix": "安装缺失的依赖包"
        }
    }
    
    def classify(self, error_message: str, traceback: str) -> FailureAnalysis:
        """分类失败原因"""
        full_text = f"{error_message}\n{traceback}"
        
        for key, config in self.PATTERNS.items():
            for pattern in config["patterns"]:
                if re.search(pattern, full_text, re.IGNORECASE):
                    return FailureAnalysis(
                        category=config["category"],
                        confidence=0.9,
                        root_cause=error_message[:200],
                        suggested_fix=config["suggested_fix"]
                    )
        
        return FailureAnalysis(
            category="Unknown",
            confidence=0.0,
            root_cause=error_message[:200],
            suggested_fix="需要人工分析"
        )


# pytest 集成
def pytest_exception_interact(node, call, report):
    """在异常发生时分析失败原因"""
    if report.failed:
        classifier = FailureClassifier()
        analysis = classifier.classify(
            str(call.excinfo.value),
            str(call.excinfo.traceback)
        )
        
        # 添加到报告
        report._failure_analysis = analysis
        
        # 打印分析结果
        print(f"\n🔍 失败分析:")
        print(f"   类别: {analysis.category}")
        print(f"   置信度: {analysis.confidence}")
        print(f"   建议: {analysis.suggested_fix}")
```

### 失败重试分析

```python
# tests/conftest.py
import pytest
from collections import defaultdict


# 记录测试失败历史
failure_history = defaultdict(list)


def pytest_runtest_logreport(report):
    """记录测试失败历史"""
    if report.when == "call" and report.failed:
        failure_history[report.nodeid].append({
            "timestamp": datetime.utcnow().isoformat(),
            "error": str(report.longrepr) if report.longrepr else None
        })


def get_flaky_tests(threshold=3):
    """识别 Flaky 测试（多次失败但偶尔通过）"""
    flaky = []
    for test_name, failures in failure_history.items():
        if len(failures) >= threshold:
            flaky.append({
                "test": test_name,
                "failure_count": len(failures),
                "recent_failures": failures[-5:]
            })
    return flaky


@pytest.fixture(scope="session", autouse=True)
def report_flaky_tests(request):
    """在测试会话结束时报告 Flaky 测试"""
    yield
    
    flaky = get_flaky_tests()
    if flaky:
        print("\n" + "=" * 60)
        print("⚠️  检测到以下 Flaky 测试:")
        for test in flaky:
            print(f"  - {test['test']}: {test['failure_count']} 次失败")
        print("=" * 60)
```

---

## 6. 性能监控

### 测试性能分析

```python
# tests/utils/performance_profiler.py
import cProfile
import pstats
import io
from functools import wraps
import pytest


def profile_test(func):
    """装饰器：分析测试性能"""
    @wraps(func)
    def wrapper(*args, **kwargs):
        profiler = cProfile.Profile()
        profiler.enable()
        
        result = func(*args, **kwargs)
        
        profiler.disable()
        
        # 输出统计
        s = io.StringIO()
        ps = pstats.Stats(profiler, stream=s).sort_stats("cumulative")
        ps.print_stats(20)  # 前 20 个函数
        
        # 保存到文件
        output_file = f"test-results/profiles/{func.__name__}.prof"
        Path(output_file).parent.mkdir(parents=True, exist_ok=True)
        profiler.dump_stats(output_file)
        
        return result
    
    return wrapper


# pytest fixture
@pytest.fixture(scope="function")
def performance_threshold(request):
    """检查测试执行时间是否超过阈值"""
    import time
    
    threshold_ms = request.node.get_closest_marker("slow")
    threshold_ms = threshold_ms.args[0] if threshold_ms else 1000  # 默认 1s
    
    start = time.time()
    yield
    duration_ms = (time.time() - start) * 1000
    
    if duration_ms > threshold_ms:
        pytest.warn(f"测试执行时间 {duration_ms:.0f}ms 超过阈值 {threshold_ms}ms")
```

---

## 7. 可观测性清单

- [ ] 测试日志结构化（JSON 格式）
- [ ] 关键测试步骤添加追踪
- [ ] 数据库查询追踪
- [ ] 外部 API 调用追踪
- [ ] 测试执行时间指标
- [ ] 测试通过率指标
- [ ] 覆盖率趋势追踪
- [ ] 失败自动分类
- [ ] Flaky 测试识别
- [ ] HTML/JSON 测试报告
- [ ] 与 APM 系统集成（可选）

---

**版本**: 1.0.0
**依赖**: OpenTelemetry, pytest, SQLAlchemy (可选)

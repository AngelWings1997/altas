# pytest TDD Cycle Guide

> **调用时机**: 在 EXECUTE(TDD) 阶段需要用 pytest 执行 RED-GREEN-REFACTOR 循环时加载
> **配合使用**: `references/superpowers/test-driven-development/SKILL.md`（TDD 铁律与通用原则）、`references/testing/pytest-patterns.md`（pytest 模式参考）

---

## 核心原则

TDD 铁律不变：**NO PRODUCTION CODE WITHOUT A FAILING TEST FIRST.**

本文件将 TDD SKILL.md 的通用 RED-GREEN-REFACTOR 循环翻译为 pytest 惯用法。

---

## RED - 写一个失败的测试

用 pytest 写一个最小测试，描述期望行为。

```python
def test_retry_operation_retries_up_to_3_times():
    attempts = 0

    def operation():
        nonlocal attempts
        attempts += 1
        if attempts < 3:
            raise ConnectionError("fail")

    result = retry_operation(operation)

    assert result == "success"
    assert attempts == 3
```

**pytest 惯用法要点：**
- 函数名以 `test_` 开头，描述行为而非实现
- 用纯 `assert` 而非 `self.assertEqual` 等方法
- 一个测试只验证一个行为
- 不需要 mock 除非不可避免

### 用 pytest.raises 测试异常

```python
import pytest

def test_submit_form_rejects_empty_email():
    with pytest.raises(ValidationError) as exc_info:
        submit_form({"email": ""})

    assert "Email required" in str(exc_info.value)
```

### 用 @pytest.mark.xfail 标记预期失败

```python
@pytest.mark.xfail(reason="Feature not yet implemented")
def test_new_feature_behavior():
    result = new_feature(input_data)
    assert result.status == "ok"
```

---

## Verify RED - 确认测试正确失败

**MANDATORY. Never skip.**

```bash
pytest tests/test_retry.py -v
```

确认：
- 测试 **失败**（不是 error）—— 失败消息是 `AssertionError` 而非 `ImportError`/`NameError`
- 失败原因正确 —— 因为功能缺失而失败，不是因为拼写错误
- 失败消息有意义 —— 从失败信息能看出期望什么

**测试通过了？** 你在测试已有行为，修正测试。
**测试报错了（error）？** 修正代码错误，重新运行直到正确失败。

```bash
# 典型 RED 输出
$ pytest tests/test_retry.py -v
FAILED tests/test_retry.py::test_retry_operation_retries_up_to_3_times - NameError: name 'retry_operation' is not defined
```

---

## GREEN - 写最简实现

写最少的代码让测试通过。

```python
def retry_operation(fn, max_retries=3):
    for i in range(max_retries):
        try:
            return fn()
        except Exception:
            if i == max_retries - 1:
                raise
    raise RuntimeError("unreachable")
```

**pytest 惯用法要点：**
- 不添加 `@pytest.mark.parametrize`（那是 REFACTOR 阶段的事）
- 不提取 fixture（那是 REFACTOR 阶段的事）
- 不添加功能、不"改进"超出测试要求的部分
- YAGNI：不要写当前测试不需要的参数和逻辑

---

## Verify GREEN - 确认测试通过

**MANDATORY.**

```bash
pytest tests/test_retry.py -v
```

确认：
- 测试通过
- 其他测试仍然通过
- 输出干净（无 error、warning）

```bash
# 典型 GREEN 输出
$ pytest tests/test_retry.py -v
PASSED tests/test_retry.py::test_retry_operation_retries_up_to_3_times
```

**测试失败了？** 修正代码，不修正测试。
**其他测试失败了？** 立即修正。

---

## REFACTOR - 清理

只在 GREEN 之后：
- 提取 fixture 消除测试数据重复
- 用 `@pytest.mark.parametrize` 消除相似测试
- 改善命名
- 提取辅助函数

保持测试绿色。不添加行为。

### 提取 fixture

```python
import pytest

@pytest.fixture
def failing_operation():
    attempts = 0

    def _operation():
        nonlocal attempts
        attempts += 1
        if attempts < 3:
            raise ConnectionError("fail")
        return "success"

    return _operation, lambda: attempts


def test_retry_operation_retries_up_to_3_times(failing_operation):
    operation, get_attempts = failing_operation
    result = retry_operation(operation)
    assert result == "success"
    assert get_attempts() == 3
```

### 用 parametrize 消除重复

```python
@pytest.mark.parametrize("max_retries,fail_count,expected_attempts", [
    (3, 2, 3),
    (5, 4, 5),
    (3, 0, 1),
])
def test_retry_with_various_configs(max_retries, fail_count, expected_attempts):
    attempts = 0

    def operation():
        nonlocal attempts
        attempts += 1
        if attempts <= fail_count:
            raise ConnectionError("fail")
        return "success"

    result = retry_operation(operation, max_retries=max_retries)
    assert result == "success"
    assert attempts == expected_attempts
```

---

## Bug Fix 示例

**Bug：** 空邮箱被接受

**RED**
```python
def test_submit_form_rejects_empty_email():
    with pytest.raises(ValidationError, match="Email required"):
        submit_form({"email": ""})
```

**Verify RED**
```bash
$ pytest tests/test_form.py -v
FAILED - ValidationError not raised
```

**GREEN**
```python
def submit_form(data):
    if not data.get("email", "").strip():
        raise ValidationError("Email required")
    ...
```

**Verify GREEN**
```bash
$ pytest tests/test_form.py -v
PASSED
```

**REFACTOR**
如果需要验证多个字段，提取验证函数。

---

## Spec-Aware TDD with pytest

当在 ALTAS Workflow 的 Spec 下工作时：

1. **从 §4.4 Test Strategy 的 P0 条目选第一个测试**
2. **从 Contract Traceability 映射测试名**：`<REQ/API-1>` → `test_<requirement_description>`
3. **应用 Mock Strategy**：如果 §4.4 说"隔离外部 API"，在第一个测试中用 fixture + mock
4. **应用 Test Data Strategy**：如果 §4.4 说"factory + rollback"，先在 conftest 中设置 factory
5. **写 RED 测试**：断言契约当前未被满足
6. **Verify RED**：`pytest <test_file> -v`，确认因正确原因失败

### 示例：从 Test Strategy 到第一个 RED 测试

**§4.4 Test Strategy 片段：**
```
- P0: POST /api/orders 必须返回 201
- Contract Traceability: openapi.yaml#/paths/~1orders/post -> test_create_order
- Mock Strategy: 隔离支付网关
- Test Data Strategy: factory + transaction rollback
```

**第一个 RED 测试：**

```python
import pytest
from fastapi.testclient import TestClient

@pytest.fixture
def client():
    from main import app
    return TestClient(app)

def test_create_order_returns_201(client):
    response = client.post("/api/orders", json={
        "product_id": 1,
        "quantity": 2,
    })
    assert response.status_code == 201
```

**Verify RED：**
```bash
$ pytest tests/api/test_orders.py::test_create_order_returns_201 -v
FAILED - 404 Not Found (endpoint not yet implemented)
```

---

## Verification Checklist

完成 TDD 循环后逐项检查：

- [ ] 每个新函数/方法都有测试
- [ ] 每个测试都先观察失败再实现
- [ ] 每个测试因正确原因失败（功能缺失，非拼写错误）
- [ ] 每个测试写了最简实现
- [ ] 所有测试通过
- [ ] 输出干净（无 error、warning）
- [ ] 测试使用真实代码（mock 仅在不可避免时使用）
- [ ] 边界条件和异常路径已覆盖

无法勾选所有项？你跳过了 TDD。重新开始。

---

**版本**: 1.0.0
**兼容**: pytest 7.0+, Python 3.8+

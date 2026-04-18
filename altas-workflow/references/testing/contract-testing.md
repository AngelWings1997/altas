# 契约测试 (Consumer-Driven Contract Testing)

> **调用时机**: 微服务架构中需要验证服务间 API 契约兼容性时加载
> **配合使用**: `references/testing/api-testing.md`（API 测试基础）、`references/testing/pytest-patterns.md`（pytest 模式）

---

## 核心原则

1. **契约即约定** — 服务间接口是消费者与提供者之间的约定，变更需要双向验证
2. **消费者驱动** — 由消费者定义期望，提供者验证是否满足，而非反过来
3. **独立验证** — 消费者测试与提供者验证分离执行，无需集成环境
4. **变更安全网** — 契约变更时自动检测破坏性影响，阻止不兼容部署

### 与"契约优先"的关系

ALTAS Workflow 强调 **契约优先**（先找 OpenAPI/Proto 再写测试）。契约测试在此基础上增加**契约变更验证**：

| 层面 | 契约优先 | 契约测试 |
|------|----------|----------|
| 关注点 | 从契约推导测试设计 | 验证契约变更的兼容性 |
| 执行时机 | 测试编写时 | CI 持续验证 |
| 覆盖对象 | 单个服务的 API 行为 | 服务间的接口约定 |

两者互补：契约优先保证"测对了"，契约测试保证"改对了"。

---

## 何时使用

| 场景 | 是否需要契约测试 |
|------|------------------|
| 单体应用 | ❌ 不需要 |
| 2-3 个服务的简单架构 | ⚠️ 可选（集成测试可能足够） |
| 5+ 个微服务 | ✅ 推荐 |
| 多团队独立部署 | ✅ 强烈推荐 |
| API 对外开放 (Public API) | ✅ 强烈推荐 |
| 频繁变更接口的内部服务 | ✅ 推荐 |

---

## 工具选型

| 工具 | 语言 | 协议 | 契约存储 | CI 集成 |
|------|------|------|----------|---------|
| **Pact** | Python / JS / Go / Java / Rust | REST | Pact Broker / Pactflow | ✅ 成熟 |
| **Spring Cloud Contract** | Java (Spring) | REST | Git / Maven | ✅ Spring 生态 |
| **Schemathesis** | Python | REST (OpenAPI) | 无（直接从 Schema 测试） | ✅ |
| **Dredd** | JS | REST (OpenAPI) | 无 | ✅ |

**推荐**: Pact 是跨语言支持最广、生态最成熟的 CDC 框架。

---

## Pact 核心概念

### 角色

```
消费者 (Consumer)          提供者 (Provider)
    │                          │
    ├─ 1. 编写消费者测试        │
    ├─ 2. 生成 Pact 文件       │
    ├─ 3. 发布到 Broker ──────►│
    │                          ├─ 4. 获取 Pact 文件
    │                          ├─ 5. 运行提供者验证
    │                          └─ 6. 验证结果发布到 Broker
```

### 工作流

1. **消费者编写契约测试** — 定义对提供者的期望
2. **生成 Pact 文件** — JSON 格式的契约记录
3. **发布到 Pact Broker** — 中央存储，版本管理
4. **提供者验证** — 拉取 Pact 文件，验证真实实现是否满足
5. **CI 门禁** — 验证失败阻止部署

---

## 消费者测试 (Python)

### 安装

```bash
pip install pact-python pytest
```

### 基础消费者测试

```python
# tests/consumer/test_order_service_contract.py
import pytest
from pact import Consumer, Provider, Like, EachLike

# 定义消费者与提供者
pact = Consumer("OrderService").has_pact_with(Provider("PaymentService"))

@pytest.fixture
def payment_client():
    from httpx import Client
    return Client(base_url=pact.uri)


def test_process_payment_happy_path(payment_client):
    """消费者期望：支付成功时返回 201 和支付记录"""
    (
        pact.given("a valid payment method exists")
        .upon_receiving("a request to process payment")
        .with_request("POST", "/payments", body={
            "order_id": "ord-123",
            "amount": 99.99,
            "currency": "CNY",
        })
        .will_respond_with(201, body={
            "payment_id": Like("pay-456"),
            "status": Like("completed"),
            "amount": Like(99.99),
        })
    )

    with pact:
        response = payment_client.post("/payments", json={
            "order_id": "ord-123",
            "amount": 99.99,
            "currency": "CNY",
        })
        assert response.status_code == 201
        assert response.json()["status"] == "completed"


def test_process_payment_insufficient_funds(payment_client):
    """消费者期望：余额不足时返回 422"""
    (
        pact.given("payment method has insufficient funds")
        .upon_receiving("a payment request with insufficient funds")
        .with_request("POST", "/payments", body={
            "order_id": "ord-789",
            "amount": 99999.00,
            "currency": "CNY",
        })
        .will_respond_with(422, body={
            "error": Like("insufficient_funds"),
            "message": Like("Payment method has insufficient funds"),
        })
    )

    with pact:
        response = payment_client.post("/payments", json={
            "order_id": "ord-789",
            "amount": 99999.00,
            "currency": "CNY",
        })
        assert response.status_code == 422
        assert response.json()["error"] == "insufficient_funds"
```

### Matcher 详解

```python
from pact import Like, EachLike, Term, Includes

# Like: 类型匹配，值不重要（提供者返回同类型即可）
Like("any-string")       # 匹配任意字符串
Like(42)                 # 匹配任意整数
Like(True)               # 匹配任意布尔值

# Term: 正则匹配（适合枚举值、格式化字符串）
Term("completed", r"completed|pending|failed")  # 匹配枚举值
Term("2024-01-01", r"\d{4}-\d{2}-\d{2}")        # 匹配日期格式
Term("pay-123", r"pay-\d+")                      # 匹配 ID 格式

# EachLike: 数组中每个元素匹配
EachLike({"id": Like(1), "name": Like("item")})  # 匹配元素结构

# Includes: 字符串包含匹配
Includes("error")        # 字符串包含 "error"
```

### Provider State 管理

消费者测试通过 `given()` 定义 Provider State，提供者需要在验证时设置对应状态：

```python
# 消费者侧
pact.given("a valid payment method exists")  # Provider State 名称
    .upon_receiving("a request to process payment")
    ...
```

---

## 提供者验证 (Python)

### 基础提供者验证

```python
# tests/provider/test_payment_service_provider.py
import pytest
from pact import Verifier
from fastapi import FastAPI

# Provider State 回调
@app.post("/_pact/provider_states")
async def provider_states(state: dict):
    if state["state"] == "a valid payment method exists":
        # 设置测试数据：创建一个有效的支付方式
        await create_test_payment_method(user_id="test-user", balance=10000)
    elif state["state"] == "payment method has insufficient funds":
        # 设置测试数据：创建余额不足的支付方式
        await create_test_payment_method(user_id="test-user", balance=0)
    return {"result": "ok"}


def test_payment_service_honors_pact():
    """验证 PaymentService 是否满足所有消费者的契约"""
    verifier = Verifier(
        provider="PaymentService",
        provider_base_url="http://localhost:8000",
    )

    # 从 Pact Broker 获取契约
    success, logs = verifier.verify_with_broker(
        broker_url="http://localhost:9292",
        provider_states_setup_url="http://localhost:8000/_pact/provider_states",
        publish_version="1.0.0",
        publish_verification_results=True,
    )

    assert success, f"Provider verification failed: {logs}"
```

### 本地 Pact 文件验证（无 Broker）

```python
def test_payment_service_honors_local_pact():
    """从本地 Pact 文件验证"""
    verifier = Verifier(
        provider="PaymentService",
        provider_base_url="http://localhost:8000",
    )

    success, logs = verifier.verify_pacts(
        "./pacts/orderservice-paymentservice.json",
        provider_states_setup_url="http://localhost:8000/_pact/provider_states",
    )

    assert success
```

---

## Pact Broker 集成

### 部署 Pact Broker

```bash
# Docker Compose 快速部署
docker run -d \
  --name pact-broker \
  -p 9292:9292 \
  -e PACT_BROKER_DATABASE_ADAPTER=sqlite \
  pactfoundation/pact-broker
```

### CI 中发布契约

```bash
# 消费者 CI：测试通过后发布 Pact
pact-broker publish ./pacts/ \
  --consumer-app-version=${CI_COMMIT_SHA} \
  --branch=${CI_COMMIT_BRANCH} \
  --broker-base-url=http://pact-broker:9292
```

### CI 中验证契约

```bash
# 提供者 CI：拉取并验证所有消费者的契约
pact-broker can-i-deploy \
  --pacticipant=PaymentService \
  --version=${CI_COMMIT_SHA} \
  --to-environment=production \
  --broker-base-url=http://pact-broker:9292
```

### can-i-deploy 门禁

```
can-i-deploy 检查:
  PaymentService v1.2.0 → production
  ├─ OrderService 契约: ✅ 验证通过
  ├─ NotificationService 契约: ✅ 验证通过
  └─ ShippingService 契约: ❌ 验证失败 (缺少字段 tracking_url)

结果: BLOCKED — 不能部署到 production
```

---

## 与 Altas Workflow 集成

### PLAN 阶段

在 §4.4 Test Strategy 中增加契约测试相关字段：

```markdown
### Contract Testing (微服务项目)
- **Consumer Tests**: [哪些消费者需要编写契约测试]
- **Provider Verification**: [哪些提供者需要验证]
- **Pact Broker**: [Broker URL / 本地文件]
- **Provider States**: [需要哪些 Provider State]
- **CI Gate**: [can-i-deploy 门禁配置]
```

### EXECUTE 阶段

1. 先编写消费者契约测试（属于 TDD RED 阶段）
2. 发布 Pact 文件到 Broker
3. 提供者侧实现 Provider State 回调
4. 运行提供者验证
5. 确认 can-i-deploy 通过

### TEST 模式

- 微服务项目触发 TEST 模式时，自动检查是否存在 Pact 契约
- 若缺少契约测试，提示用户补充
- 测试报告的 Contract Traceability 应包含契约验证结果

---

## 常见模式

### 模式 1: 消费者先行的增量采纳

适用于已有多条微服务、逐步引入契约测试的场景：

1. 选择变更最频繁的消费者-提供者对
2. 只为该对编写契约测试
3. 验证通过后逐步扩展到其他服务对

### 模式 2: 新服务从零开始

适用于新建微服务的场景：

1. 在 PLAN 阶段定义 API 契约
2. 消费者测试先行（TDD）
3. 提供者实现后立即验证
4. CI 中持续验证

### 模式 3: 公开 API 契约验证

适用于对外提供 API 的场景：

```python
# 用 Schemathesis 直接从 OpenAPI 验证
# 不需要消费者，直接验证提供者是否满足自己的契约
import schemathesis
from hypothesis import settings

schema = schemathesis.from_path("openapi.yaml")

@schema.parametrize()
@settings(max_examples=50)
def test_api_compliance(case):
    response = case.call()
    case.validate_response(response)
```

---

## 常见问题

### Q: 契约测试和集成测试的区别？

| 维度 | 契约测试 | 集成测试 |
|------|----------|----------|
| 运行环境 | 消费者和提供者独立运行 | 需要真实集成环境 |
| 速度 | 快（Mock 交互） | 慢（真实网络调用） |
| 覆盖范围 | 接口约定（Schema、状态码） | 端到端行为 |
| 用途 | 检测不兼容变更 | 检测集成问题 |

**建议**: 契约测试覆盖接口约定，少量集成测试覆盖关键路径。

### Q: 契约测试能否替代 API 测试？

不能。契约测试验证的是"接口约定是否满足"，API 测试验证的是"行为是否正确"。例如：

- 契约测试：`POST /payments` 返回 201 和包含 `payment_id` 的 JSON ✅
- API 测试：`POST /payments` 金额为负数时返回 422 ✅
- 契约测试不关心业务逻辑验证，只关心接口形状

### Q: Provider State 越来越多怎么办？

1. 使用 Factory 模式组合 Provider State
2. 优先使用数据库种子数据而非逐个创建
3. 定期清理无用的 Provider State（与删除废弃测试同理）

### Q: Pact Broker 维护成本？

1. 小团队：使用 Pactflow 托管服务（免费额度足够）
2. 中型团队：Docker 自部署 + 定期备份
3. 大型团队：Pactflow 企业版 + SSO + RBAC

---

## 最佳实践

1. **消费者测试只写期望，不写实现** — 测试的是"我期望提供者给我什么"，不是"提供者怎么实现"
2. **使用 Like/Term 而非硬编码值** — 避免提供者返回值细微变化导致契约验证失败
3. **Provider State 命名清晰** — 用业务语言而非技术细节（`a valid payment method exists` 而非 `db has row in payments table`）
4. **CI 中必须包含 can-i-deploy** — 没有门禁的契约测试形同虚设
5. **契约测试失败 = 阻止部署** — 与功能测试失败同等对待
6. **增量采纳** — 不必一次覆盖所有服务对，从最高风险的对开始

---

## Quick Reference

| 操作 | 命令/代码 |
|------|-----------|
| 安装 Pact Python | `pip install pact-python` |
| 运行消费者测试 | `pytest tests/consumer/ -v` |
| 发布契约到 Broker | `pact-broker publish ./pacts/ --consumer-app-version=$SHA --broker-base-url=$BROKER_URL` |
| 运行提供者验证 | `pytest tests/provider/ -v` |
| 部署前检查 | `pact-broker can-i-deploy --pacticipant=$SERVICE --version=$SHA --to-environment=production` |

---

**版本**: 1.0.0
**兼容**: pact-python 2.0+, Python 3.8+

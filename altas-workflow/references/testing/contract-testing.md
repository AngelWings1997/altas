# 契约测试 (Contract Testing)

> **调用时机**: 微服务项目、前后端分离项目、多服务协作场景
> **配合使用**: `references/testing/api-testing.md`（API 测试基础）、`references/superpowers/test-driven-development/SKILL.md`（TDD 铁律）

---

## 核心原则

**契约是服务间的协议** — 消费者与提供者之间对接口行为的共同约定，变更必须双向验证。

### 契约测试 vs 集成测试

| 维度 | 契约测试 | 集成测试 |
|------|----------|----------|
| 目标 | 验证接口契约不被破坏 | 验证端到端功能正确性 |
| 依赖 | 无真实依赖（Mock） | 真实数据库、网络、第三方服务 |
| 速度 | 快（毫秒级） | 慢（秒~分钟级） |
| 隔离性 | 仅关注单个服务边界 | 关注多个服务协作 |
| 失败含义 | 契约不兼容，消费者或提供者不兼容变更 | 系统级功能异常 |

### 测试视角

| 视角 | 问题 | 工具 |
|------|------|------|
| **消费者驱动 (CDC)** | "消费者需要提供者返回什么？" | Pact、Specmatic |
| **提供者验证** | "提供者是否满足所有消费者的期望？" | Pact Broker、Provider Verifier |
| **双向契约** | "双方是否遵守同一份契约？" | OpenAPI + Dredd、Schemathesis |

---

## 工具选型

| 工具 | 语言 | 用途 | 必要性 |
|------|------|------|--------|
| **Pact** | Python/JS/Java/Go | 消费者驱动契约测试 | 推荐（微服务必选） |
| **Dredd** | 多语言 | OpenAPI 契约验证 | 可选（已有 OpenAPI 时） |
| **Schemathesis** | Python | API 模糊测试 + 契约验证 | 可选（安全敏感时） |
| **Specmatic** | JVM/多语言 | 契约驱动开发与测试 | 可选（契约即文档时） |
| **openapi-validator** | Python/JS | 运行时请求校验 | 可选（生产防护） |

---

## Pact 消费者驱动契约测试 (CDC)

### 工作流程

```
消费者 (Consumer)          Pact Broker           提供者 (Provider)
     │                        │                        │
     ├── 定义交互 ───────────►│                        │
     ├── 生成 Pact 文件 ──────►│                        │
     │                        │◄── 拉取 Pact 文件 ──────┤
     │                        │◄── 验证提供者 ──────────┤
     │                        │── 验证结果 ────────────►│
     │                        │── 是否可以部署？ ───────►│
```

### Python: pact-python

#### 1. 消费者端：定义契约

```python
import pytest
from pact import Consumer, Provider
import requests

pact = Consumer("WebApp").has_pact_with(Provider("UserService"))

@pytest.fixture
def pact_service():
    pact.start_service()
    yield pact
    pact.stop_service()

def test_get_user_by_id(pact_service):
    # 定义期望的交互
    pact_service.given("user exists").upon_receiving("get user request").with_request(
        "GET", "/users/1", headers={"Authorization": "Bearer token"}
    ).will_respond_with(200, body={"id": 1, "name": "Alice", "email": "alice@example.com"})

    with pact_service:
        # 消费者代码按契约调用
        response = requests.get(f"{pact_service.uri}/users/1", headers={"Authorization": "Bearer token"})
        assert response.json() == {"id": 1, "name": "Alice", "email": "alice@example.com"}

    # 生成 Pact 文件
    pact_service.write_pact()
```

#### 2. 提供者端：验证契约

```python
from pact import Verifier
import pytest

@pytest.fixture
def provider():
    # 启动提供者服务
    import subprocess
    proc = subprocess.Popen(["python", "-m", "app.server", "--port", "8080"])
    yield proc
    proc.terminate()

def test_provider_contracts(provider):
    verifier = Verifier(
        provider="UserService",
        provider_base_url="http://localhost:8080",
        pact_urls=["pacts/WebApp-UserService.json"]
    )
    # 运行验证，确保提供者满足消费者期望
    verifier.validate()
```

### JavaScript/TypeScript: @pact-foundation/pact

```typescript
import { Pact } from "@pact-foundation/pact";
import { createUser } from "./user-api";

const pact = new Pact({
  consumer: "FrontendApp",
  provider: "UserService",
  port: 1234,
  log: "pact/log.txt",
  dir: "pacts",
});

describe("User API", () => {
  beforeAll(() => pact.setup());
  afterAll(() => pact.finalize());

  it("creates a user", async () => {
    await pact.addInteraction({
      state: "user service ready",
      uponReceiving: "create user request",
      withRequest: {
        method: "POST",
        path: "/users",
        body: { name: "Alice", email: "alice@example.com" },
      },
      willRespondWith: {
        status: 201,
        body: { id: 1, name: "Alice", email: "alice@example.com" },
      },
    });

    const user = await createUser({ name: "Alice", email: "alice@example.com" });
    expect(user.id).toEqual(1);
  });
});
```

---

## OpenAPI 契约验证

### Dredd: 验证实现符合 OpenAPI Spec

```bash
# 安装
npm install -g dredd

# 验证 API 实现符合 openapi.yaml
dredd openapi.yaml http://localhost:3000

# 指定 Hook 处理认证和数据准备
dredd openapi.yaml http://localhost:3000 --hookfiles=./hooks.js
```

### Schemathesis: 基于契约的模糊测试

```bash
# 安装
pip install schemathesis

# 基于 OpenAPI Spec 进行模糊测试
schemathesis run http://localhost:3000/openapi.yaml

# 指定检查项
schemathesis run http://localhost:3000/openapi.yaml \
  --checks not_a_server_error \
  --checks status_code_conformance \
  --checks response_schema_conformance
```

---

## 契约变更管理

### 变更分类

| 变更类型 | 消费者影响 | 提供者影响 | 示例 |
|----------|------------|------------|------|
| **安全新增** | 无 | 无 | 添加可选响应字段 |
| **安全删除** | 无 | 无 | 删除未使用的端点 |
| **破坏性变更** | 必须更新 | 必须更新 | 修改字段类型、删除必需字段 |
| **新增必需字段** | 必须更新 | 必须提供 | 请求体增加必填字段 |

### 兼容性策略

| 策略 | 说明 | 适用场景 |
|------|------|----------|
| **向后兼容** | 老消费者继续工作 | API 演进、版本升级 |
| **向前兼容** | 新消费者能处理旧提供者 | 滚动部署 |
| **双向兼容** | 新旧版本均能互操作 | 灰度发布、A/B 测试 |

### 版本管理

```
# 推荐方案: URL 版本化
GET /v1/users    # 旧版本，继续维护
GET /v2/users    # 新版本，向后兼容

# 契约文件版本化
pacts/
├── v1/
│   ├── WebApp-UserService.json
│   └── MobileApp-UserService.json
└── v2/
    ├── WebApp-UserService.json
    └── MobileApp-UserService.json
```

---

## CI/CD 集成

### GitHub Actions: Pact 验证

```yaml
name: Contract Tests
on: [push, pull_request]

jobs:
  consumer-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Pact Consumer Tests
        run: pytest tests/contracts/ --pact-dir=./pacts
      - name: Publish Pact to Broker
        run: pact-broker publish ./pacts --consumer-app-version $GITHUB_SHA

  provider-tests:
    needs: consumer-tests
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Run Pact Provider Verification
        run: pytest tests/contracts/provider/
        env:
          PACT_BROKER_BASE_URL: ${{ secrets.PACT_BROKER_URL }}
          PACT_BROKER_TOKEN: ${{ secrets.PACT_BROKER_TOKEN }}

  can-i-deploy:
    needs: [consumer-tests, provider-tests]
    runs-on: ubuntu-latest
    steps:
      - name: Can I Deploy?
        run: |
          pact-broker can-i-deploy \
            --pacticipant UserService \
            --version $GITHUB_SHA \
            --to-environment production
```

---

## 契约测试检查清单

| 检查项 | 状态 |
|--------|------|
| 所有对外 API 有明确的契约文件（OpenAPI/Proto/Pact） | ☐ |
| 消费者端定义了期望交互和响应结构 | ☐ |
| 提供者端验证了所有消费者的契约 | ☐ |
| 契约变更通过 CI 自动检测兼容性 | ☐ |
| Pact Broker（或等价工具）管理契约版本 | ☐ |
| 破坏性变更有明确的迁移计划和通知机制 | ☐ |
| 契约测试在 CI 中自动执行，阻止不兼容部署 | ☐ |

---

## 与 API 测试的边界

| 测试类型 | 关注点 | 示例 |
|----------|--------|------|
| **契约测试** | 服务间协议不被破坏 | 字段类型、必填字段、状态码 |
| **API 测试** | 接口功能正确性 | 业务逻辑、数据计算、权限判断 |
| **集成测试** | 端到端系统正确性 | 完整用户流程、多服务协作 |

**原则**: 契约测试是 API 测试的子集，仅关注跨服务边界的协议行为，不验证内部业务逻辑。

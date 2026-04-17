# API 测试模式参考

> **来源**: 整合自 `.agents/skills/advanced-api-testing` 核心内容
> **调用时机**: TEST 模式下需要测试 HTTP API 时加载
> **配合使用**: `references/testing/pytest-patterns.md`（pytest 基础）

---

## 核心原则

**API 是契约** — 从消费者视角测试，而非实现细节。

### 测试层级

| 层级 | 目的 | 依赖 | 速度 |
|------|------|------|------|
| 契约 | 提供者-消费者协议 | 无 | 快 |
| 组件 | API 隔离测试 | Mocked | 快 |
| 集成 | 真实依赖 | 数据库、服务 | 较慢 |

### 测试矩阵

| 类别 | 测试内容 |
|------|----------|
| 认证 | 401/403、过期 token、跨用户访问 |
| 输入 | 400 验证、缺失字段、错误类型、范围 |
| 错误 | 500 优雅降级、数据库宕机、超时 |
| 幂等性 | 重复请求结果一致、幂等 key |
| 并发 | 竞态条件、并行写入 |
| 分页 | 页边界、空结果 |
| 过滤 | 多过滤器、无效过滤值 |

---

## Test Client 设置

```python
import pytest
from fastapi.testclient import TestClient
from main import app

@pytest.fixture
def client():
    """FastAPI 测试客户端"""
    return TestClient(app)

@pytest.fixture(scope="module")
def api_base_url():
    return "http://localhost:8000"
```

---

## 1. 输入验证测试

### 必填字段验证

```python
class TestCreateUserValidation:

    def test_missing_required_fields(self, client):
        response = client.post("/api/users", json={})
        assert response.status_code == 422

        errors = response.json()["detail"]
        assert any("name" in err["loc"] for err in errors)
        assert any("email" in err["loc"] for err in errors)

    @pytest.mark.parametrize("payload,expected_field", [
        ({"email": "test@example.com"}, "name"),
        ({"name": "Test"}, "email"),
        ({}, "name"),
    ])
    def test_missing_each_required_field(self, client, payload, expected_field):
        response = client.post("/api/users", json=payload)
        assert response.status_code == 422
        errors = response.json()["detail"]
        assert any(expected_field in err["loc"] for err in errors)
```

### 类型与格式验证

```python
def test_wrong_type_fields(self, client):
    response = client.post("/api/users", json={
        "name": 123,  # 应为字符串
        "email": "test@example.com"
    })
    assert response.status_code == 422

def test_invalid_email_format(self, client):
    invalid_emails = ["not-an-email", "@missing-local.com", ""]
    for email in invalid_emails:
        response = client.post("/api/users", json={
            "name": "Test",
            "email": email
        })
        assert response.status_code == 422, f"应拒绝: {email}"

def test_field_length_limits(self, client):
    response = client.post("/api/users", json={
        "name": "A" * 256,
        "email": "test@example.com"
    })
    assert response.status_code == 422

def test_null_values_for_required_fields(self, client):
    response = client.post("/api/users", json={
        "name": None,
        "email": "test@example.com"
    })
    assert response.status_code == 422
```

### 请求体格式

```python
def test_malformed_request_body(self, client):
    response = client.post(
        "/api/users",
        content=b"not valid json",
        headers={"Content-Type": "application/json"}
    )
    assert response.status_code == 400

def test_oversized_request_body(self, client):
    large_payload = {"data": "A" * (10 * 1024 * 1024)}
    response = client.post("/api/users", json=large_payload)
    assert response.status_code == 413  # Payload Too Large
```

---

## 2. 幂等性测试

```python
class TestIdempotency:

    def test_duplicate_post_with_idempotency_key(self, client):
        idempotency_key = "unique-key-12345"
        payload = {"name": "Test Order", "amount": 100}
        headers = {"Idempotency-Key": idempotency_key}

        r1 = client.post("/api/orders", json=payload, headers=headers)
        assert r1.status_code == 201
        order_id_1 = r1.json()["id"]

        r2 = client.post("/api/orders", json=payload, headers=headers)
        assert r2.status_code == 200
        order_id_2 = r2.json()["id"]

        assert order_id_1 == order_id_2

    def test_different_idempotency_keys_create_different_resources(self, client):
        payload = {"name": "Test Order", "amount": 100}
        r1 = client.post("/api/orders", json=payload,
                        headers={"Idempotency-Key": "key-1"})
        r2 = client.post("/api/orders", json=payload,
                        headers={"Idempotency-Key": "key-2"})
        assert r1.json()["id"] != r2.json()["id"]

    def test_put_delete_idempotent(self, client):
        user = client.post("/api/users", json={
            "name": "Test", "email": "test@example.com"
        }).json()
        user_id = user["id"]

        r1 = client.put(f"/api/users/{user_id}", json={
            "name": "Updated", "email": "test@example.com"
        })
        r2 = client.put(f"/api/users/{user_id}", json={
            "name": "Updated", "email": "test@example.com"
        })

        assert r1.status_code == r2.status_code or r2.status_code == 404
```

---

## 3. 并发测试

```python
import concurrent.futures

class TestConcurrency:

    def test_parallel_order_creation(self, client):
        product = client.post("/api/products", json={
            "name": "Limited Item",
            "stock": 10
        }).json()

        def create_order(_):
            return client.post("/api/orders", json={
                "product_id": product["id"],
                "quantity": 1
            })

        with concurrent.futures.ThreadPoolExecutor(max_workers=15) as executor:
            responses = list(executor.map(create_order, range(15)))

        successful = [r for r in responses if r.status_code == 201]
        assert len(successful) <= 10

        final_product = client.get(f"/api/products/{product['id']}").json()
        assert final_product["stock"] == 10 - len(successful)

    def test_race_condition_on_unique_constraint(self, client):
        email = "unique@example.com"

        def create_user_with_email(_):
            return client.post("/api/users", json={
                "name": "Test",
                "email": email
            })

        with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
            responses = list(executor.map(create_user_with_email, range(10)))

        created = sum(1 for r in responses if r.status_code == 201)
        conflicts = sum(1 for r in responses if r.status_code == 409)

        assert created == 1
        assert conflicts == 9
```

---

## 4. 错误处理测试

```python
class TestErrorHandling:

    def test_internal_server_error_returns_500(self, client, monkeypatch):
        def mock_db_failure(*args, **kwargs):
            raise Exception("Database connection lost")

        monkeypatch.setattr("app.db.get_user", mock_db_failure)

        response = client.get("/api/users/1")
        assert response.status_code == 500

        body = response.json()
        assert "detail" in body or "error" in body
        assert "Traceback" not in str(body)
        assert "password" not in str(body).lower()

    @pytest.mark.parametrize("status_code,endpoint,method,payload", [
        (401, "/api/orders", "POST", {"item": "test"}),
        (403, "/api/admin/users", "GET", None),
        (404, "/api/users/nonexistent", "GET", None),
        (405, "/api/users", "PATCH", {"name": "test"}),
        (415, "/api/users", "POST", "not json"),
        (429, "/api/users", "POST", {"name": "spam"}),
    ])
    def test_error_response_format(self, client, status_code, endpoint, method, payload):
        if method == "GET":
            response = client.get(endpoint)
        elif method == "POST":
            response = client.post(endpoint, json=payload)
        elif method == "PATCH":
            response = client.patch(endpoint, json=payload)

        assert response.status_code == status_code
        body = response.json()
        assert "detail" in body or "error" in body or "message" in body

    def test_timeout_handling(self, client):
        response = client.get("/api/slow-endpoint", timeout=1.0)
        assert response.status_code in [408, 504]
```

---

## 5. 分页测试

```python
class TestPagination:

    @pytest.fixture
    def create_test_data(self, client):
        users = []
        for i in range(50):
            user = client.post("/api/users", json={
                "name": f"User {i}",
                "email": f"user{i}@example.com"
            }).json()
            users.append(user)
        return users

    def test_default_pagination(self, client, create_test_data):
        response = client.get("/api/users")
        assert response.status_code == 200
        body = response.json()
        assert "items" in body or "data" in body
        assert "total" in body or "count" in body

    @pytest.mark.parametrize("page_size,expected_count", [
        (1, 1),
        (10, 10),
        (25, 25),
        (100, 50),
    ])
    def test_custom_page_sizes(self, client, create_test_data, page_size, expected_count):
        response = client.get(f"/api/users?limit={page_size}")
        assert response.status_code == 200
        items = response.json()["items"]
        assert len(items) == expected_count

    def test_page_boundaries(self, client, create_test_data):
        all_items = []
        page = 1
        while True:
            response = client.get(f"/api/users?page={page}&limit=10")
            items = response.json()["items"]
            if not items:
                break

            for item in items:
                assert item["id"] not in [i["id"] for i in all_items]

            all_items.extend(items)
            page += 1

        assert len(all_items) == 50

    def test_invalid_pagination_params(self, client):
        invalid_params = [
            {"page": -1}, {"page": 0}, {"limit": -10},
            {"limit": 1000}, {"page": "abc"},
        ]
        for params in invalid_params:
            response = client.get("/api/users", params=params)
            assert response.status_code in [400, 422]
```

---

## 6. 认证与授权

```python
class TestAuthentication:

    def test_no_token_returns_401(self, client):
        response = client.get("/api/users/me")
        assert response.status_code == 401

    def test_expired_token_returns_401(self, client):
        expired_token = generate_expired_token()
        response = client.get(
            "/api/users/me",
            headers={"Authorization": f"Bearer {expired_token}"}
        )
        assert response.status_code == 401

    def test_malformed_token_returns_401(self, client):
        response = client.get(
            "/api/users/me",
            headers={"Authorization": "Bearer not-a-valid-token-format!!!"}
        )
        assert response.status_code == 401

    def test_cross_user_access_returns_403(self, client):
        user_a = create_user_with_token(client, "userA")
        user_b = create_user_with_token(client, "userB")

        response = client.get(
            f"/api/users/{user_b['id']}/orders",
            headers={"Authorization": f"Bearer {user_a['token']}"}
        )
        assert response.status_code == 403

    def test_admin_can_access_all(self, client):
        admin_token = generate_admin_token()
        response = client.get(
            "/api/admin/users",
            headers={"Authorization": f"Bearer {admin_token}"}
        )
        assert response.status_code == 200
```

---

## 7. Schema 验证

```python
import jsonschema

class TestResponseSchema:

    USER_SCHEMA = {
        "type": "object",
        "required": ["id", "name", "email", "created_at"],
        "properties": {
            "id": {"type": "integer"},
            "name": {"type": "string", "minLength": 1, "maxLength": 255},
            "email": {"type": "string", "format": "email"},
            "created_at": {"type": "string", "format": "date-time"},
        },
        "additionalProperties": False,
    }

    def test_create_user_response_schema(self, client):
        response = client.post("/api/users", json={
            "name": "Test",
            "email": "test@example.com"
        })
        assert response.status_code == 201
        jsonschema.validate(response.json(), self.USER_SCHEMA)

    def test_response_no_extra_fields(self, client):
        response = client.post("/api/users", json={
            "name": "Test",
            "email": "test@example.com"
        }).json()

        allowed_fields = {"id", "name", "email", "created_at"}
        actual_fields = set(response.keys())
        assert not (actual_fields - allowed_fields)
```

---

## 测试组织

```
tests/
├── conftest.py              # 共享 fixtures（client, auth tokens）
├── api/
│   ├── test_validation.py   # 输入验证
│   ├── test_idempotency.py  # 幂等性
│   ├── test_concurrency.py  # 并发
│   ├── test_auth.py         # 认证授权
│   └── test_pagination.py   # 分页
└── schemas/
    └── test_response_schema.py  # Schema 验证
```

---

## 测试清单

编写 API 测试时，逐项检查：

- [ ] **Happy Path**: 有效请求成功返回 200/201
- [ ] **必填字段**: 缺失字段返回 422
- [ ] **类型验证**: 错误类型返回 422
- [ ] **格式验证**: 邮箱/URL 等格式校验
- [ ] **长度限制**: 超出长度返回 422
- [ ] **Null 值**: 必填字段 null 返回 422
- [ ] **无 Token**: 未认证返回 401
- [ ] **过期 Token**: Token 过期返回 401
- [ ] **跨用户访问**: 无权访问返回 403
- [ ] **404**: 不存在资源返回 404
- [ ] **500 优雅降级**: 内部错误不暴露堆栈
- [ ] **幂等性**: 重复请求结果一致
- [ ] **并发**: 竞态条件不导致数据不一致
- [ ] **分页**: 页边界、空结果、无效参数
- [ ] **Schema 一致**: 响应结构符合预期

---

## 常用插件

```bash
pip install pytest-httpx pytest-factoryboy hypothesis jsonschema
```

| 插件 | 功能 |
|------|------|
| `pytest-httpx` | HTTP Mock |
| `pytest-factoryboy` | Factory 集成 |
| `hypothesis` | 基于属性测试 |
| `jsonschema` | Schema 验证 |

---

**版本**: 1.0.0
**兼容**: pytest 7.0+, Python 3.8+, FastAPI, Flask

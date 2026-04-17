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

## 默认输入源：先找契约文件

### 契约来源优先级

1. `OpenAPI / Swagger`：如 `openapi.yaml`、`swagger.yaml`、`*.openapi.json`
2. `GraphQL Schema`：如 `schema.graphql`、`schema.graphqls`、introspection 结果
3. `Proto`：如 `*.proto`
4. 已落盘接口 Spec / requirements / 对外 API 文档

### 默认动作

进行 API 测试设计时，先执行以下动作，再写测试代码：

1. **识别契约来源文件**
   - 记录文件路径、协议类型（REST / GraphQL / gRPC）和契约版本
2. **基于契约生成接口测试矩阵**
   - 提取 endpoint / query / mutation / rpc、请求字段、响应结构、鉴权要求、错误码
3. **按契约展开核心场景**
   - `happy path`
   - `validation`
   - `auth`
   - `idempotency`
   - `error path`
   - `schema case`

### 缺少契约时

- 若接口行为无法从现有 Spec 或正式接口文档明确得出，**必须暂停并提示用户补充契约**
- 禁止从 controller / handler / serializer 等实现细节直接“猜”接口契约
- 若用户明确要求基于现有实现先补测试，必须在测试策略中标注：`Contract Source: Missing / inferred from implementation (higher risk)`

### 契约驱动接口测试矩阵模板

```markdown
| Contract Item | Source | Happy Path | Validation | Auth | Idempotency | Error Path | Schema |
|---------------|--------|------------|------------|------|-------------|------------|--------|
| `POST /orders` | `openapi.yaml#/paths/~1orders/post` | `201 create order` | `422 missing field` | `401/403` | `same Idempotency-Key` | `409/500` | `response schema matches` |
| `mutation createUser` | `schema.graphql#Mutation.createUser` | `returns created user` | `invalid email rejected` | `role required` | `N/A` | `domain error surfaced` | `selection set matches schema` |
| `GetUser` | `user.proto#rpc GetUser` | `OK returns user` | `INVALID_ARGUMENT` | `UNAUTHENTICATED` | `N/A` | `NOT_FOUND` | `protobuf fields match` |
```

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

- [ ] **契约来源已确认**: OpenAPI / GraphQL Schema / Proto / 已落盘接口文档
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
| `graphql-client` | GraphQL 测试 |
| `grpcio-tools` | gRPC 测试 |

---

## 8. GraphQL API 测试

> **适用场景**: 使用 GraphQL 作为 API 层的项目

### 安装依赖

```bash
pip install pytest-aiographql-server gql[all]
```

### Test Client 设置

```python
import pytest
from myapp.graphql_app import app

@pytest.fixture
def graphql_client():
    """GraphQL 测试客户端"""
    from starlette.testclient import TestClient
    return TestClient(app)

@pytest.fixture
def auth_headers():
    """认证头"""
    token = generate_test_token()
    return {"Authorization": f"Bearer {token}"}
```

### 查询测试 (Query)

```python
class TestGraphQLQueries:

    def test_get_user_by_id(self, graphql_client):
        query = """
            query GetUser($id: ID!) {
                user(id: $id) {
                    id
                    username
                    email
                    createdAt
                }
            }
        """
        
        variables = {"id": "1"}
        response = graphql_client.post(
            "/graphql",
            json={"query": query, "variables": variables}
        )
        
        assert response.status_code == 200
        data = response.json()
        
        assert "errors" not in data or len(data["errors"]) == 0
        assert data["data"]["user"]["id"] == "1"
        assert data["data"]["user"]["username"] is not None
        assert "@" in data["data"]["user"]["email"]

    def test_list_users_with_pagination(self, graphql_client):
        query = """
            query Users($limit: Int!, $offset: Int!) {
                users(limit: $limit, offset: $offset) {
                    totalCount
                    items {
                        id
                        username
                    }
                }
            }
        """
        
        variables = {"limit": 10, "offset": 0}
        response = graphql_client.post("/graphql", json={
            "query": query,
            "variables": variables
        })
        
        data = response.json()["data"]["users"]
        assert data["totalCount"] >= 0
        assert len(data["items"]) <= 10

    def test_nested_query(self, graphql_client):
        """测试嵌套关联查询"""
        query = """
            query GetOrder($id: ID!) {
                order(id: $id) {
                    id
                    status
                    total
                    user {
                        username
                        email
                    }
                    items {
                        productName
                        quantity
                        price
                    }
                }
            }
        """
        
        # 先创建订单数据...
        response = graphql_client.post("/graphql", json={
            "query": query,
            "variables": {"id": "order_123"}
        })
        
        order = response.json()["data"]["order"]
        assert order["user"]["username"] is not None
        assert len(order["items"]) > 0
```

### 变更测试 (Mutation)

```python
class TestGraphQLMutations:

    def test_create_user_mutation(self, graphql_client):
        mutation = """
            mutation CreateUser($input: CreateUserInput!) {
                createUser(input: $input) {
                    id
                    username
                    email
                    errors {
                        field
                        message
                    }
                }
            }
        """
        
        variables = {
            "input": {
                "username": "testuser",
                "email": "test@example.com",
                "password": "SecurePass123!"
            }
        }
        
        response = graphql_client.post("/graphql", json={
            "query": mutation,
            "variables": variables
        })
        
        result = response.json()["data"]["createUser"]
        assert result["id"] is not None
        assert result["username"] == "testuser"
        assert result["errors"] is None or len(result["errors"]) == 0

    def test_update_user_validation_error(self, graphql_client):
        mutation = """
            mutation UpdateUser($id: ID!, $input: UpdateUserInput!) {
                updateUser(id: $id, input: $input) {
                    id
                    errors {
                        field
                        message
                    }
                }
            }
        """
        
        variables = {
            "id": "1",
            "input": {
                "email": "invalid-email"  # 无效邮箱格式
            }
        }
        
        response = graphql_client.post("/graphql", json={
            "query": mutation,
            "variables": variables
        })
        
        result = response.json()["data"]["updateUser"]
        assert any("email" in err["field"].lower() for err in result["errors"])

    @pytest.mark.parametrize("field,value,expected_error", [
        ("username", "", "Username is required"),
        ("email", "not-an-email", "Invalid email format"),
        ("password", "123", "Password too short"),
    ])
    def test_create_user_validation_errors(self, graphql_client, field, value, expected_error):
        mutation = """
            mutation CreateUser($input: CreateUserInput!) {
                createUser(input: $input) {
                    id
                    errors {
                        field
                        message
                    }
                }
            }
        """
        
        variables = {"input": {field: value}}
        response = graphql_client.post("/graphql", json={
            "query": mutation,
            "variables": variables
        })
        
        errors = response.json()["data"]["createUser"]["errors"]
        assert any(expected_error.lower() in err["message"].lower() for err in errors)
```

### 认证与授权测试

```python
class TestGraphQLAuth:

    def test_unauthenticated_query_returns_data(self, graphql_client):
        """公开查询不需要认证"""
        query = "{ publicInfo { version } }"
        response = graphql_client.post("/graphql", json={"query": query})
        assert response.status_code == 200

    def test_authenticated_query_without_token_fails(self, graphql_client):
        """受保护查询需要 Token"""
        query = "{ me { id username } }"
        response = graphql_client.post("/graphql", json={"query": query})
        
        data = response.json()
        assert "errors" in data
        assert any("UNAUTHENTICATED" in str(err) for err in data["errors"])

    def test_expired_token_rejected(self, graphql_client):
        """过期 Token 被拒绝"""
        headers = {"Authorization": "Bearer expired_token_12345"}
        query = "{ me { id } }"
        
        response = graphql_client.post(
            "/graphql",
            json={"query": query},
            headers=headers
        )
        
        assert response.status_code == 200
        data = response.json()
        assert "errors" in data
```

### 错误处理测试

```python
class TestGraphQLErrors:

    def test_invalid_query_syntax(self, graphql_client):
        """语法错误返回明确错误信息"""
        invalid_query = "{ broken { query { syntax } }"
        response = graphql_client.post("/graphql", json={"query": invalid_query})
        
        data = response.json()
        assert "errors" in data
        assert "Syntax Error" in str(data["errors"])

    def test_nonexistent_field(self, graphql_client):
        """不存在的字段返回错误"""
        query = "{ user { nonexistentField } }"
        response = graphql_client.post("/graphql", json={"query": query})
        
        data = response.json()
        assert "errors" in data
        assert "Cannot query field" in str(data["errors"])

    def test_null_handling(self, graphql_client):
        """空值处理正确"""
        query = "{ user(id: \"nonexistent\") { id username } }"
        response = graphql_client.post("/graphql", json={"query": query})
        
        data = response.json()
        assert data["data"]["user"] is None
```

### GraphQL 测试清单

- [ ] Query 返回正确的字段和类型
- [ ] Mutation 正确创建/更新/删除数据
- [ ] 参数化验证所有输入字段
- [ ] 嵌套查询能正确解析关联
- [ ] 分页参数工作正常
- [ ] 认证/授权逻辑正确
- [ ] 错误消息清晰且不暴露内部细节
- [ ] 空值/null 处理一致
- [ ] Schema 变更时更新测试

---

## 9. gRPC API 测试

> **适用场景**: 使用 gRPC 作为服务间通信协议的项目

### 安装依赖

```bash
pip install pytest-grpc grpcio grpcio-tools
```

### 生成测试代码

```bash
# 从 .proto 文件生成 Python 代码
python -m grpc_tools.protoc \
    --proto_path=protos \
    --python_out=. \
    --grpc_python_out=. \
    protos/*.proto
```

### Test Server 设置

```python
import pytest
from grpc import testing
from myapp.grpc_server import serve
from protos import user_pb2, user_pb2_grpc

@pytest.fixture
def grpc_server():
    """启动测试用 gRPC 服务器"""
    server = testing.server_from_descriptor(
        user_pb2_grpc.DESCRIPTOR.services_by_name['UserService'],
        testing.implementation_service_methods({
            'GetUser': get_user_handler,
            'CreateUser': create_user_handler,
        })
    )
    
    server.start()
    yield server
    server.stop(None)
```

### Unary RPC 测试

```python
class TestUserGRPCService:

    def test_get_existing_user(self, grpc_channel):
        stub = user_pb2_grpc.UserStub(grpc_channel)
        
        request = user_pb2.GetUserRequest(user_id="123")
        response = stub.GetUser(request)
        
        assert response.user.id == "123"
        assert response.user.username is not None
        assert response.user.email is not None

    def test_get_nonexistent_user(self, grpc_channel):
        stub = user_pb2_grpc.UserStub(grpc_channel)
        
        request = user_pb2.GetUserRequest(user_id="nonexistent")
        
        with pytest.raises(grpc.RpcError) as exc_info:
            stub.GetUser(request)
        
        assert exc_info.value.code() == grpc.StatusCode.NOT_FOUND

    def test_get_user_with_invalid_id_format(self, grpc_channel):
        stub = user_pb2_grpc.UserStub(grpc_channel)
        
        request = user_pb2.GetUserRequest(user_id="invalid!@#$%")
        
        with pytest.raises(grpc.RpcError) as exc_info:
            stub.GetUser(request)
        
        assert exc_info.value.code() == grpc.StatusCode.INVALID_ARGUMENT
```

### Server Streaming 测试

```python
def test_list_users_streaming(grpc_channel):
    """测试服务器流式响应"""
    stub = user_pb2_grpc.UserStub(grpc_channel)
    
    request = user_pb2.ListUsersRequest(page_size=5)
    responses = []
    
    for response in stub.ListUsers(request):
        responses.append(response.user)
        assert response.user.id is not None
    
    assert len(responses) <= 5  # 不超过 page_size

def test_stream_with_filter(grpc_channel):
    """带过滤条件的流式请求"""
    stub = user_pb2_grpc.UserStub(grpc_channel)
    
    request = user_pb2.ListUsersRequest(
        filter_role="admin",
        page_size=100
    )
    
    admin_users = [
        resp.user for resp in stub.ListUsers(request)
    ]
    
    for user in admin_users:
        assert user.role == "admin"
```

### Client Streaming 测试

```python
def test_bulk_create_users(grpc_channel):
    """客户端流式上传"""
    stub = user_pb2_grpc.UserStub(grpc_channel)
    
    def generate_requests():
        for i in range(3):
            yield user_pb2.CreateUserRequest(
                username=f"user_{i}",
                email=f"user_{i}@example.com"
            )
    
    response = stub.BulkCreateUsers(generate_requests())
    
    assert response.created_count == 3
    assert len(response.user_ids) == 3
```

### Bidirectional Streaming 测试

```python
def test_chat_streaming(grpc_channel):
    """双向流式通信"""
    stub = chat_pb2_grpc.ChatStub(grpc_channel)
    
    def message_generator():
        messages = ["Hello", "How are you?", "Goodbye"]
        for msg in messages:
            yield chat_pb2.ChatMessage(content=msg, sender="client")
    
    responses = []
    for response in stub.Chat(message_generator()):
        responses.append(response.content)
        assert response.sender == "server"
    
    assert len(responses) == 3
```

### gRPC 错误处理测试

```python
class TestGRPCErrors:

    def test_deadline_exceeded(self, grpc_channel):
        stub = user_pb2_grpc.UserStub(grpc_channel)
        
        request = user_pb2.SlowOperationRequest(delay_seconds=10)
        
        with pytest.raises(grpc.RpcError) as exc_info:
            stub.SlowOperation(request, timeout=1.0)
        
        assert exc_info.value.code() == grpc.StatusCode.DEADLINE_EXCEEDED

    def test_unimplemented_method(self, unimplemented_channel):
        stub = user_pb2_grpc.UserStub(unimplemented_channel)
        
        request = user_pb2.GetUserRequest(user_id="1")
        
        with pytest.raises(grpc.RpcError) as exc_info:
            stub.UnimplementedMethod(request)
        
        assert exc_info.value.code() == grpc.StatusCode.UNIMPLEMENTED

    def test_resource_exhausted(self, grpc_channel):
        stub = user_pb2_grpc.UserStub(grpc_channel)
        
        large_request = user_pb2.LargeRequest(data="x" * (4 * 1024 * 1024 + 1))
        
        with pytest.raises(grpc.RpcError) as exc_info:
            stub.ProcessLargeData(large_request)
        
        assert exc_info.value.code() == grpc.StatusCode.RESOURCE_EXHAUSTED
```

### gRPC 测试最佳实践

| 场景 | 测试策略 |
|------|----------|
| **Unary RPC** | 标准请求-响应模式，验证输入输出 |
| **Server Streaming** | 验证流完整性、分页、过滤 |
| **Client Streaming** | 批量操作、验证聚合结果 |
| **Bidirectional** | 实时交互、验证消息顺序 |
| **错误处理** | 测试所有 gRPC 状态码 |
| **元数据** | 认证 Token、追踪 ID 传递 |
| **截止时间** | 超时处理、资源清理 |
| **拦截器** | 日志、监控、限流验证 |

---

## 10. WebSocket API 测试

> **适用场景**: 实时通信、推送通知等 WebSocket 接口

### 安装依赖

```bash
pip install pytest-asyncio websockets starlette
```

### 基本连接测试

```python
import pytest
from websockets import connect

@pytest.mark.asyncio
async def test_websocket_connection():
    """基本连接测试"""
    async with connect("ws://localhost:8000/ws") as ws:
        await ws.send("ping")
        response = await ws.recv()
        assert response == "pong"

@pytest.mark.asyncio
async def test_authentication_required():
    """未认证连接应被拒绝"""
    import websockets
    with pytest.raises(websockets.exceptions.InvalidStatusCode):
        async with connect("ws://localhost:8000/ws/protected") as ws:
            await ws.recv()

@pytest.mark.asyncio
async def test_authenticated_connection():
    """带 Token 的认证连接"""
    token = generate_test_token()
    uri = f"ws://localhost:8000/ws?token={token}"
    
    async with connect(uri) as ws:
        greeting = await ws.recv()
        assert "connected" in greeting.lower()
```

### 消息收发测试

```python
@pytest.mark.asyncio
async def test_send_and_receive_messages():
    """发送消息并接收响应"""
    async with connect("ws://localhost:8000/ws/chat") as ws:
        # 发送 JSON 消息
        message = {
            "type": "message",
            "content": "Hello, World!",
            "room": "general"
        }
        await ws.send(json.dumps(message))
        
        # 接收确认
        ack = await ws.recv()
        ack_data = json.loads(ack)
        assert ack_data["type"] == "ack"
        assert ack_data["message_id"] is not None
        
        # 接收广播消息
        broadcast = await ws.recv()
        broadcast_data = json.loads(broadcast)
        assert broadcast_data["type"] == "message"
        assert broadcast_data["content"] == "Hello, World!"

@pytest.mark.asyncio
async def test_message_ordering():
    """消息顺序保证"""
    async with connect("ws://localhost:8000/ws/chat") as ws:
        messages = []
        
        for i in range(5):
            await ws.send(json.dumps({"content": f"Message {i}"}))
        
        # 收集响应（可能有延迟）
        for _ in range(5):
            response = await ws.recv()
            messages.append(json.loads(response)["content"])
        
        # 验证顺序（FIFO）
        expected = [f"Message {i}" for i in range(5)]
        assert messages == expected
```

### 异常处理测试

```python
@pytest.mark.asyncio
async def test_invalid_json_rejected():
    """无效 JSON 应被拒绝并返回错误"""
    async with connect("ws://localhost:8000/ws") as ws:
        await ws.send("not valid json")
        
        error = await ws.recv()
        error_data = json.loads(error)
        assert error_data["type"] == "error"
        assert "Invalid JSON" in error_data["message"]

@pytest.mark.asyncio
async def test_large_message_handling():
    """大消息处理"""
    async with connect("ws://localhost:8000/ws") as ws:
        large_content = "x" * (1024 * 1024)  # 1MB
        
        try:
            await ws.send(json.dumps({"content": large_content}))
            response = await ws.recv()
            # 可能成功或失败，取决于实现
        except Exception as e:
            assert "too large" in str(e).lower() or "size" in str(e).lower()

@pytest.mark.asyncio
async def test_connection_timeout():
    """空闲超时断开"""
    import asyncio
    
    async with connect("ws://localhost:8000/ws") as ws:
        # 等待超过超时时间（假设 30 秒）
        await asyncio.sleep(35)
        
        # 尝试发送应该失败
        with pytest.raises(Exception):  # ConnectionClosed
            await ws.send("ping")
```

---

**版本**: 1.1.0
**兼容**: pytest 7.0+, Python 3.8+, FastAPI, Flask, GraphQL, gRPC

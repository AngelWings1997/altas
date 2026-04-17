---
name: advanced-api-testing
description: Advanced API testing patterns covering idempotency, input validation, error handling, concurrency, contract testing, and comprehensive REST/GraphQL API test strategies
---

# Advanced API Testing Patterns

Comprehensive guide for testing HTTP APIs with focus on robustness, edge cases, idempotency, validation, and error handling. Covers both pytest (Python) and Supertest (TypeScript) patterns.

## When to Use This Skill

- Testing REST or GraphQL APIs
- Validating API contracts and schemas
- Designing comprehensive API test strategies
- Preventing breaking API changes
- Testing idempotency and concurrency
- Input validation and error handling
- API performance and load testing
- Authentication and authorization testing

## Core Philosophy

**APIs are contracts** — test from consumer perspective, not implementation details.

### Testing Levels

| Level | Purpose | Dependencies | Speed |
|-------|---------|--------------|-------|
| Contract | Provider-consumer agreement | None | Fast |
| Component | API in isolation | Mocked | Fast |
| Integration | Real dependencies | Database, services | Slower |

### What to Test

- Auth: 401/403 handling, expired tokens, cross-user access
- Input: 400 validation, missing fields, wrong types, ranges
- Errors: 500 graceful handling, DB down, timeout
- Idempotency: Duplicate prevention, same idempotency key
- Concurrency: Race conditions, parallel requests
- Pagination: Page boundaries, empty results
- Filtering: Multiple filters, invalid filter values

---

## Pytest API Testing (Python)

### Test Client Setup

```python
import pytest
from httpx import AsyncClient, ASGITransport
from main import app

@pytest.fixture
def client():
    """FastAPI test client"""
    from fastapi.testclient import TestClient
    return TestClient(app)

@pytest.fixture(scope="module")
def api_base_url():
    return "http://localhost:8000"
```

### Pattern 1: Required Field Validation

```python
class TestCreateUserValidation:
    """Comprehensive input validation tests"""

    def test_missing_required_fields(self, client):
        """All required fields must be present"""
        response = client.post("/api/users", json={})
        assert response.status_code == 422  # Unprocessable Entity

        errors = response.json()["detail"]
        assert any("name" in err["loc"] for err in errors)
        assert any("email" in err["loc"] for err in errors)

    @pytest.mark.parametrize("payload,expected_field", [
        ({"email": "test@example.com"}, "name"),
        ({"name": "Test"}, "email"),
        ({}, "name"),
    ])
    def test_missing_each_required_field(self, client, payload, expected_field):
        """Test each required field individually"""
        response = client.post("/api/users", json=payload)
        assert response.status_code == 422

        errors = response.json()["detail"]
        assert any(expected_field in err["loc"] for err in errors)

    def test_wrong_type_fields(self, client):
        """Fields must have correct types"""
        response = client.post("/api/users", json={
            "name": 123,  # Should be string
            "email": "test@example.com"
        })
        assert response.status_code == 422

    def test_invalid_email_format(self, client):
        """Email must be valid format"""
        invalid_emails = [
            "not-an-email",
            "@missing-local.com",
            "missing@domain",
            "",
        ]

        for email in invalid_emails:
            response = client.post("/api/users", json={
                "name": "Test",
                "email": email
            })
            assert response.status_code == 422, f"Should reject: {email}"

    def test_field_length_limits(self, client):
        """Fields must respect length constraints"""
        response = client.post("/api/users", json={
            "name": "A" * 256,  # Too long
            "email": "test@example.com"
        })
        assert response.status_code == 422

    def test_null_values_for_required_fields(self, client):
        """Required fields cannot be null"""
        response = client.post("/api/users", json={
            "name": None,
            "email": "test@example.com"
        })
        assert response.status_code == 422
```

### Pattern 2: Idempotency Testing

```python
class TestIdempotency:
    """Idempotency ensures same request produces same result"""

    def test_duplicate_post_with_idempotency_key(self, client):
        """Same idempotency key should return same resource"""
        idempotency_key = "unique-key-12345"
        payload = {"name": "Test Order", "amount": 100}

        headers = {"Idempotency-Key": idempotency_key}

        # First request
        r1 = client.post("/api/orders", json=payload, headers=headers)
        assert r1.status_code == 201
        order_id_1 = r1.json()["id"]

        # Second request with same key
        r2 = client.post("/api/orders", json=payload, headers=headers)
        assert r2.status_code == 200  # or 201, depending on API design
        order_id_2 = r2.json()["id"]

        # Same order returned
        assert order_id_1 == order_id_2

    def test_different_idempotency_keys_create_different_resources(self, client):
        """Different keys should create different resources"""
        payload = {"name": "Test Order", "amount": 100}

        r1 = client.post("/api/orders", json=payload,
                        headers={"Idempotency-Key": "key-1"})
        r2 = client.post("/api/orders", json=payload,
                        headers={"Idempotency-Key": "key-2"})

        assert r1.json()["id"] != r2.json()["id"]

    def test_idempotency_key_expires(self, client):
        """Idempotency key should have TTL"""
        import time

        idempotency_key = "expiring-key-123"
        payload = {"name": "Test Order", "amount": 100}
        headers = {"Idempotency-Key": idempotency_key}

        # First request
        r1 = client.post("/api/orders", json=payload, headers=headers)
        assert r1.status_code == 201
        order_id_1 = r1.json()["id"]

        # Wait for TTL to expire (or mock time)
        time.sleep(300)  # 5 minutes

        # Should create new order after expiry
        r2 = client.post("/api/orders", json=payload, headers=headers)
        assert r2.json()["id"] != order_id_1

    @pytest.mark.parametrize("method,endpoint", [
        ("PUT", "/api/users/{user_id}"),
        ("DELETE", "/api/users/{user_id}"),
    ])
    def test_put_delete_idempotent(self, client, method, endpoint):
        """PUT and DELETE should be idempotent by design"""
        # Create user first
        user = client.post("/api/users", json={"name": "Test", "email": "test@example.com"}).json()
        user_id = user["id"]

        url = endpoint.format(user_id=user_id)

        if method == "PUT":
            r1 = client.put(url, json={"name": "Updated", "email": "test@example.com"})
            r2 = client.put(url, json={"name": "Updated", "email": "test@example.com"})
        else:
            r1 = client.delete(url)
            r2 = client.delete(url)

        # Same status for repeated calls
        assert r1.status_code == r2.status_code or r2.status_code == 404
```

### Pattern 3: Concurrency Testing

```python
import concurrent.futures
import threading

class TestConcurrency:
    """Race condition and parallel request testing"""

    def test_parallel_order_creation(self, client):
        """Concurrent orders should not oversell inventory"""
        # Setup: Create product with limited stock
        product = client.post("/api/products", json={
            "name": "Limited Item",
            "stock": 10
        }).json()

        def create_order(_):
            return client.post("/api/orders", json={
                "product_id": product["id"],
                "quantity": 1
            })

        # Fire 15 concurrent requests (more than stock)
        with concurrent.futures.ThreadPoolExecutor(max_workers=15) as executor:
            responses = list(executor.map(create_order, range(15)))

        # Count successful orders
        successful = [r for r in responses if r.status_code == 201]
        failed = [r for r in responses if r.status_code == 409]  # Conflict

        # Should not exceed stock
        assert len(successful) <= 10

        # Verify actual stock
        final_product = client.get(f"/api/products/{product['id']}").json()
        assert final_product["stock"] == 10 - len(successful)

    def test_concurrent_updates_last_write_wins(self, client):
        """Concurrent updates should have defined behavior"""
        user = client.post("/api/users", json={
            "name": "Original",
            "email": "test@example.com"
        }).json()

        def update_user(version):
            return client.put(f"/api/users/{user['id']}", json={
                "name": f"Version {version}",
                "email": "test@example.com"
            })

        # Concurrent updates
        with concurrent.futures.ThreadPoolExecutor(max_workers=5) as executor:
            responses = list(executor.map(update_user, range(5)))

        # All should succeed or use optimistic locking
        successful = [r for r in responses if r.status_code == 200]

        # Final state should be one of the versions
        final_user = client.get(f"/api/users/{user['id']}").json()
        assert any(f"Version {i}" == final_user["name"] for i in range(5))

    def test_race_condition_on_unique_constraint(self, client):
        """Concurrent creation with same unique field"""
        email = "unique@example.com"

        def create_user_with_email(_):
            return client.post("/api/users", json={
                "name": "Test",
                "email": email
            })

        with concurrent.futures.ThreadPoolExecutor(max_workers=10) as executor:
            responses = list(executor.map(create_user_with_email, range(10)))

        # Only one should succeed
        created = sum(1 for r in responses if r.status_code == 201)
        conflicts = sum(1 for r in responses if r.status_code == 409)

        assert created == 1
        assert conflicts == 9
```

### Pattern 4: Error Handling Testing

```python
class TestErrorHandling:
    """Comprehensive error scenario testing"""

    def test_internal_server_error_returns_500(self, client, monkeypatch):
        """500 errors should be graceful, not expose internals"""
        def mock_db_failure(*args, **kwargs):
            raise Exception("Database connection lost")

        monkeypatch.setattr("app.db.get_user", mock_db_failure)

        response = client.get("/api/users/1")
        assert response.status_code == 500

        # Should not expose stack traces or internal details
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
        (429, "/api/users", "POST", {"name": "spam"}),  # Rate limited
    ])
    def test_error_response_format(self, client, status_code, endpoint, method, payload):
        """All errors should follow consistent format"""
        if method == "GET":
            response = client.get(endpoint)
        elif method == "POST":
            response = client.post(endpoint, json=payload)
        elif method == "PATCH":
            response = client.patch(endpoint, json=payload)

        assert response.status_code == status_code

        body = response.json()
        # Consistent error structure
        assert "detail" in body or "error" in body or "message" in body

    def test_malformed_request_body(self, client):
        """Invalid JSON should return 400"""
        response = client.post(
            "/api/users",
            content=b"not valid json",
            headers={"Content-Type": "application/json"}
        )
        assert response.status_code == 400

    def test_oversized_request_body(self, client):
        """Request too large should be rejected"""
        large_payload = {"data": "A" * (10 * 1024 * 1024)}  # 10MB

        response = client.post("/api/users", json=large_payload)
        assert response.status_code == 413  # Payload Too Large

    def test_timeout_handling(self, client):
        """Long-running requests should timeout gracefully"""
        response = client.get("/api/slow-endpoint", timeout=1.0)
        assert response.status_code in [408, 504]  # Request Timeout or Gateway Timeout
```

### Pattern 5: Pagination Testing

```python
class TestPagination:
    """API pagination edge cases"""

    @pytest.fixture
    def create_test_data(self, client):
        """Create enough records for pagination testing"""
        users = []
        for i in range(50):
            user = client.post("/api/users", json={
                "name": f"User {i}",
                "email": f"user{i}@example.com"
            }).json()
            users.append(user)
        return users

    def test_default_pagination(self, client, create_test_data):
        """Default page size and structure"""
        response = client.get("/api/users")
        assert response.status_code == 200

        body = response.json()
        assert "items" in body or "data" in body
        assert "total" in body or "count" in body
        assert "page" in body or "offset" in body

    @pytest.mark.parametrize("page_size,expected_count", [
        (1, 1),
        (10, 10),
        (25, 25),
        (100, 50),  # Only 50 total
    ])
    def test_custom_page_sizes(self, client, create_test_data, page_size, expected_count):
        """Page size parameter should work correctly"""
        response = client.get(f"/api/users?limit={page_size}")
        assert response.status_code == 200

        items = response.json()["items"]
        assert len(items) == expected_count

    def test_page_boundaries(self, client, create_test_data):
        """Pagination should not skip or duplicate items"""
        all_items = []

        # Fetch all pages
        page = 1
        while True:
            response = client.get(f"/api/users?page={page}&limit=10")
            items = response.json()["items"]

            if not items:
                break

            # Check no duplicates with previous pages
            for item in items:
                assert item["id"] not in [i["id"] for i in all_items]

            all_items.extend(items)
            page += 1

        # All items retrieved
        assert len(all_items) == 50

    def test_invalid_pagination_params(self, client):
        """Invalid pagination should be handled gracefully"""
        invalid_params = [
            {"page": -1},
            {"page": 0},
            {"limit": -10},
            {"limit": 1000},  # Exceeds max
            {"page": "abc"},
        ]

        for params in invalid_params:
            response = client.get("/api/users", params=params)
            assert response.status_code in [400, 422]
```

### Pattern 6: Authentication & Authorization

```python
class TestAuthentication:
    """Auth scenarios"""

    def test_no_token_returns_401(self, client):
        """Unauthenticated access should be rejected"""
        response = client.get("/api/users/me")
        assert response.status_code == 401

    def test_expired_token_returns_401(self, client):
        """Expired tokens should be rejected"""
        expired_token = generate_expired_token()

        response = client.get(
            "/api/users/me",
            headers={"Authorization": f"Bearer {expired_token}"}
        )
        assert response.status_code == 401

    def test_malformed_token_returns_401(self, client):
        """Invalid token format should be rejected"""
        response = client.get(
            "/api/users/me",
            headers={"Authorization": "Bearer not-a-valid-token-format!!!"}
        )
        assert response.status_code == 401

    def test_cross_user_access_returns_403(self, client):
        """Users cannot access other users' data"""
        user_a = create_user_with_token(client, "userA")
        user_b = create_user_with_token(client, "userB")

        # User A tries to access User B's order
        response = client.get(
            f"/api/users/{user_b['id']}/orders",
            headers={"Authorization": f"Bearer {user_a['token']}"}
        )
        assert response.status_code == 403

    def test_admin_can_access_all(self, client):
        """Admin role should have elevated access"""
        admin_token = generate_admin_token()

        response = client.get(
            "/api/admin/users",
            headers={"Authorization": f"Bearer {admin_token}"}
        )
        assert response.status_code == 200

    def test_token_refresh(self, client):
        """Refresh token should provide new access token"""
        user = create_user_with_token(client, "testuser")

        response = client.post(
            "/api/auth/refresh",
            json={"refresh_token": user["refresh_token"]}
        )
        assert response.status_code == 200
        assert "access_token" in response.json()
```

### Pattern 7: Schema Validation Testing

```python
from pydantic import ValidationError
import jsonschema

class TestResponseSchema:
    """Validate response structure against schema"""

    USER_SCHEMA = {
        "type": "object",
        "required": ["id", "name", "email", "created_at"],
        "properties": {
            "id": {"type": "integer"},
            "name": {"type": "string", "minLength": 1, "maxLength": 255},
            "email": {"type": "string", "format": "email"},
            "created_at": {"type": "string", "format": "date-time"},
            "updated_at": {"type": "string", "format": "date-time"},
        },
        "additionalProperties": False,  # No extra fields allowed
    }

    def test_create_user_response_schema(self, client):
        """Response should match schema"""
        response = client.post("/api/users", json={
            "name": "Test",
            "email": "test@example.com"
        })

        assert response.status_code == 201
        jsonschema.validate(response.json(), self.USER_SCHEMA)

    def test_get_user_response_schema(self, client):
        """GET response should match schema"""
        user = client.post("/api/users", json={
            "name": "Test",
            "email": "test@example.com"
        }).json()

        response = client.get(f"/api/users/{user['id']}")
        assert response.status_code == 200
        jsonschema.validate(response.json(), self.USER_SCHEMA)

    def test_response_no_extra_fields(self, client):
        """Response should not contain unexpected fields"""
        response = client.post("/api/users", json={
            "name": "Test",
            "email": "test@example.com"
        }).json()

        allowed_fields = {"id", "name", "email", "created_at", "updated_at"}
        actual_fields = set(response.keys())

        # Should not have sensitive or internal fields
        assert not (actual_fields - allowed_fields)
```

---

## Best Practices

### What to Test

1. **Happy paths**: Valid requests succeed
2. **Validation**: Missing fields, wrong types, out of range
3. **Auth**: No token, expired, wrong role, cross-user
4. **Idempotency**: Duplicate requests produce same result
5. **Concurrency**: Race conditions, parallel writes
6. **Pagination**: Page boundaries, empty results, invalid params
7. **Errors**: 4xx and 5xx, consistent format, no leak internals

### Test Organization

```
tests/
├── conftest.py              # Shared fixtures (client, auth tokens)
├── api/
│   ├── test_validation.py   # Input validation tests
│   ├── test_idempotency.py  # Idempotency tests
│   ├── test_concurrency.py  # Concurrency tests
│   ├── test_auth.py         # Auth tests
│   └── test_pagination.py   # Pagination tests
└── schemas/
    └── test_response_schema.py  # Schema validation
```

### Useful Pytest Plugins

- **pytest-asyncio**: Async test support
- **pytest-httpx**: HTTP mocking
- **pytest-factoryboy**: Factory fixtures
- **hypothesis**: Property-based testing
- **pytest-xdist**: Parallel execution
- **jsonschema**: Schema validation

---

**Version**: 1.0.0
**Category**: API Testing, Integration Testing
**Compatible With**: pytest 7.0+, Python 3.8+, FastAPI, Flask

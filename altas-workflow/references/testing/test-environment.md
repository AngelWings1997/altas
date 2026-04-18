# 测试环境管理

> **调用时机**: 需要搭建、配置或隔离测试环境时加载
> **配合使用**: `references/testing/pytest-patterns.md`（pytest 基础）、`references/testing/test-data-management.md`（测试数据）

---

## 核心原则

1. **环境即代码** — 测试环境配置应该版本化管理，而非手动搭建
2. **隔离是底线** — 测试之间、测试与生产之间必须隔离
3. **本地优先** — 开发者本地应能一键启动完整测试环境
4. **CI 与本地一致** — CI 中的环境应尽量与本地一致，避免"我机器上能跑"

---

## 隔离策略

### 按依赖类型选择隔离方式

| 依赖类型 | 单元测试 | 集成测试 | E2E 测试 |
|----------|----------|----------|----------|
| 数据库 | Mock / SQLite 内存 | Test Container / 真实 DB | 真实 DB |
| 缓存 (Redis) | Mock / 内存实现 | Test Container | 真实 Redis |
| 消息队列 | Mock / 内存 Channel | Test Container | 真实 MQ |
| 第三方 API | Mock / VCR | Mock Server | Sandbox |
| 文件系统 | `tmp_path` / `tmp_path_factory` | `tmp_path` | 真实文件 |
| 时间 | freezegun / time-machine | 真实时间 | 真实时间 |

### 隔离层级

```
Level 0: 纯函数（无外部依赖）     → 无需隔离
Level 1: 内存替代（SQLite/Fake）  → 进程内隔离
Level 2: Test Container           → 容器隔离
Level 3: Docker Compose           → 网络隔离
Level 4: 独立测试环境             → 环境隔离
```

---

## Test Containers (Python)

### 安装

```bash
pip install testcontainers[postgres,redis,kafka]
```

### PostgreSQL

```python
import pytest
from testcontainers.postgres import PostgresContainer
from sqlalchemy import create_engine


@pytest.fixture(scope="session")
def postgres_container():
    with PostgresContainer("postgres:16-alpine") as postgres:
        yield postgres


@pytest.fixture(scope="session")
def db_engine(postgres_container):
    url = postgres_container.get_connection_url()
    engine = create_engine(url)
    # 运行迁移
    run_migrations(engine)
    yield engine
    engine.dispose()


@pytest.fixture
def db_session(db_engine):
    """每个测试用事务回滚隔离"""
    connection = db_engine.connect()
    transaction = connection.begin()
    session = Session(bind=connection)

    yield session

    session.close()
    transaction.rollback()
    connection.close()
```

### Redis

```python
from testcontainers.redis import RedisContainer


@pytest.fixture(scope="session")
def redis_container():
    with RedisContainer("redis:7-alpine") as redis:
        yield redis


@pytest.fixture
def redis_client(redis_container):
    import redis as r
    client = r.from_url(redis_container.get_connection_url())
    yield client
    client.flushdb()  # 测试后清理
```

### Kafka

```python
from testcontainers.kafka import KafkaContainer


@pytest.fixture(scope="session")
def kafka_container():
    with KafkaContainer("confluentinc/cp-kafka:7.5.0") as kafka:
        yield kafka
```

---

## Test Containers (Go)

### 安装

```bash
go get github.com/testcontainers/testcontainers-go
go get github.com/testcontainers/testcontainers-go/modules/postgres
```

### PostgreSQL

```go
func TestUserRepository_Integration(t *testing.T) {
    if testing.Short() {
        t.Skip("skipping integration test")
    }

    ctx := context.Background()
    pgContainer, err := postgres.RunContainer(ctx,
        testcontainers.WithImage("postgres:16-alpine"),
        postgres.WithDatabase("testdb"),
        postgres.WithUsername("test"),
        postgres.WithPassword("test"),
        testcontainers.WithWaitStrategy(
            wait.ForLog("database system is ready to accept connections").
                WithOccurrence(2).
                WithStartupTimeout(5*time.Second)),
    )
    require.NoError(t, err)
    defer pgContainer.Terminate(ctx)

    connStr, err := pgContainer.ConnectionString(ctx, "sslmode=disable")
    require.NoError(t, err)

    db, err := sql.Open("postgres", connStr)
    require.NoError(t, err)
    defer db.Close()

    // 运行迁移 + 测试逻辑
}
```

---

## Docker Compose 测试环境

### compose.test.yaml

```yaml
version: "3.8"
services:
  postgres:
    image: postgres:16-alpine
    environment:
      POSTGRES_DB: testdb
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
    ports:
      - "5433:5432"  # 避免与本地 PostgreSQL 冲突
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U test -d testdb"]
      interval: 1s
      timeout: 3s
      retries: 30

  redis:
    image: redis:7-alpine
    ports:
      - "6380:6379"
    healthcheck:
      test: ["CMD", "redis-cli", "ping"]
      interval: 1s
      timeout: 3s
      retries: 10

  mock-server:
    image: stoplight/prism:5
    command: mock -h 0.0.0.0 /api/openapi.yaml
    volumes:
      - ./openapi.yaml:/api/openapi.yaml:ro
    ports:
      - "4010:4010"
```

### pytest + Docker Compose 集成

```python
import pytest
import subprocess
import time
import requests


@pytest.fixture(scope="session")
def docker_compose():
    """启动/停止 Docker Compose 测试环境"""
    subprocess.run(
        ["docker", "compose", "-f", "compose.test.yaml", "up", "-d", "--wait"],
        check=True,
    )
    yield
    subprocess.run(
        ["docker", "compose", "-f", "compose.test.yaml", "down", "-v"],
        check=True,
    )


@pytest.fixture(scope="session")
def service_url(docker_compose):
    return "http://localhost:8000"
```

---

## 本地 vs CI 环境差异处理

### 常见差异与解决

| 差异 | 原因 | 解决方案 |
|------|------|----------|
| 端口冲突 | 本地已占用 | 使用随机端口 / `0.0.0.0:0` |
| 数据库版本不同 | 本地 vs CI 版本 | Docker 统一版本 |
| 文件路径不同 | OS 差异 | 使用 `pathlib` / `tmp_path` |
| 环境变量缺失 | CI 未配置 | `.env.test` + 默认值 |
| 时区不同 | 服务器时区不一致 | 测试中固定 UTC / freezegun |
| DNS 解析差异 | 本地 hosts / VPN | 使用 `localhost` 统一 |

### 环境配置模板

```python
# tests/conftest.py
import os

def pytest_configure(config):
    """统一测试环境配置"""
    os.environ.setdefault("APP_ENV", "test")
    os.environ.setdefault("DATABASE_URL", "sqlite:///test.db")
    os.environ.setdefault("REDIS_URL", "redis://localhost:6379/15")  # 用 DB 15 避免冲突
    os.environ.setdefault("LOG_LEVEL", "WARNING")  # 测试时减少日志噪音
```

### 随机端口模式

```python
import socket
import pytest


@pytest.fixture(scope="session")
def free_port():
    """获取一个空闲端口"""
    with socket.socket(socket.AF_INET, socket.SOCK_STREAM) as s:
        s.bind(("", 0))
        return s.getsockname()[1]


@pytest.fixture(scope="session")
def test_server(free_port):
    """在随机端口启动测试服务器"""
    os.environ["PORT"] = str(free_port)
    # 启动服务器...
    yield f"http://localhost:{free_port}"
    # 关闭服务器...
```

---

## Mock Server（外部 API 模拟）

### Prism（从 OpenAPI 生成 Mock）

```bash
# 安装
npm install -g @stoplight/prism-cli

# 启动 Mock Server
prism mock openapi.yaml --port 4010

# 在测试中使用
export PAYMENT_API_URL=http://localhost:4010
pytest tests/integration/
```

### pytest-httpx（HTTP Mock）

```python
import pytest
from httpx import AsyncClient


@pytest.fixture
def mock_payment_api(httpx_mock):
    httpx_mock.add_response(
        url="https://api.payment.com/charges",
        method="POST",
        json={"id": "ch_123", "status": "succeeded"},
        status_code=201,
    )


async def test_create_order_with_payment(mock_payment_api):
    async with AsyncClient() as client:
        response = await client.post("http://localhost:8000/api/orders", json={...})
    assert response.status_code == 201
```

### VCR 模式（录制真实响应）

```python
# pip install vcrpy
import vcr


@pytest.fixture
def payment_vcr():
    cassette = "tests/cassettes/payment_success.yaml"
    with vcr.VCR().use_cassette(cassette):
        yield
```

---

## CI 环境配置

### GitHub Actions

```yaml
jobs:
  test:
    runs-on: ubuntu-latest
    services:
      postgres:
        image: postgres:16-alpine
        env:
          POSTGRES_DB: testdb
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      redis:
        image: redis:7-alpine
        ports:
          - 6379:6379
        options: >-
          --health-cmd "redis-cli ping"
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5

    steps:
      - uses: actions/checkout@v4
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: pip install -e ".[dev]"
      - run: pytest --cov=src --cov-report=xml
      - uses: codecov/codecov-action@v3
```

### GitLab CI

```yaml
test:
  services:
    - postgres:16-alpine
    - redis:7-alpine
  variables:
    POSTGRES_DB: testdb
    POSTGRES_USER: test
    POSTGRES_PASSWORD: test
    DATABASE_URL: "postgresql://test:test@postgres/testdb"
    REDIS_URL: "redis://redis:6379/0"
  script:
    - pip install -e ".[dev]"
    - pytest --cov=src
```

---

## 最佳实践

1. **Test Container 用于集成测试** — 比 Docker Compose 更快、更隔离，适合 CI
2. **Docker Compose 用于 E2E 测试** — 需要多服务联动时更方便
3. **单元测试零外部依赖** — Mock / 内存替代，毫秒级执行
4. **环境配置集中管理** — `conftest.py` 中 `pytest_configure` 统一设置
5. **CI 与本地用同一套 Docker 镜像** — 避免版本差异导致的"本地通过 CI 失败"
6. **健康检查不可省略** — 服务启动 ≠ 就绪，必须等 health check 通过
7. **测试后清理** — 数据库 flush / 容器 terminate / 临时文件删除

---

**版本**: 1.0.0
**兼容**: Python 3.8+, Go 1.21+, Docker 20+

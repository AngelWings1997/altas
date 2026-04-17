# pytest 测试模式参考

> **来源**: 整合自 `.agents/skills/pytest-patterns` 核心内容
> **调用时机**: TEST 模式下需要编写 Python 测试时加载
> **配合使用**: `references/testing/api-testing.md`（API 测试场景）

---

## 核心原则

1. **AAA 模式**: Arrange（准备）→ Act（执行）→ Assert（验证）
2. **一个测试只验证一个行为**
3. **测试相互独立**，不依赖执行顺序
4. **使用纯 assert**，不需要特殊断言方法

---

## Fixture 模式

### 基本 Fixture

```python
import pytest

@pytest.fixture
def sample_data():
    """提供测试数据"""
    return {"name": "Alice", "age": 30}

def test_data_access(sample_data):
    assert sample_data["name"] == "Alice"
```

### Fixture 作用域

| 作用域 | 创建频率 | 适用场景 |
|--------|----------|----------|
| `function`（默认） | 每个测试 | 需要干净状态的测试 |
| `class` | 每个测试类 | 类内共享资源 |
| `module` | 每个测试文件 | 模块级设置 |
| `session` | 整个测试会话 | 数据库连接、API 客户端 |

```python
@pytest.fixture(scope="session")
def database_connection():
    """整个测试会话只创建一次"""
    conn = create_db_connection()
    yield conn
    conn.close()  # 会话结束后清理

@pytest.fixture(scope="module")
def api_client():
    """每个测试文件创建一次"""
    client = APIClient()
    client.authenticate()
    yield client
    client.logout()
```

### Fixture 依赖链

```python
@pytest.fixture
def database():
    db = Database()
    db.connect()
    yield db
    db.disconnect()

@pytest.fixture
def user_repository(database):
    return UserRepository(database)

@pytest.fixture
def sample_user(user_repository):
    user = user_repository.create(name="Test User")
    yield user
    user_repository.delete(user.id)

def test_user_operations(sample_user):
    assert sample_user.name == "Test User"
```

### Fixture 工厂

```python
@pytest.fixture
def make_user():
    """工厂模式：按需创建用户"""
    created_users = []

    def _make_user(name, email=None, **kwargs):
        email = email or f"{name}@example.com"
        user = User(name=name, email=email, **kwargs)
        created_users.append(user)
        return user

    yield _make_user

    for user in created_users:
        user.delete()

def test_multiple_users(make_user):
    alice = make_user("alice")
    bob = make_user("bob", email="bob@test.com")
    assert alice.name == "Alice"
```

### Autouse Fixture

```python
@pytest.fixture(autouse=True)
def reset_database():
    """每个测试前自动执行"""
    clear_database()
    seed_test_data()
```

---

## 参数化测试

### 基本参数化

```python
@pytest.mark.parametrize("input_value,expected", [
    (2, 4),
    (3, 9),
    (4, 16),
])
def test_square(input_value, expected):
    assert input_value ** 2 == expected
```

### 带 ID 的参数化

```python
@pytest.mark.parametrize("email,expected", [
    pytest.param("user@example.com", True, id="valid"),
    pytest.param("invalid-email", False, id="invalid"),
    pytest.param("@example.com", False, id="missing_local"),
])
def test_email_validation(email, expected):
    assert is_valid_email(email) == expected
```

### 多个参数组合

```python
@pytest.mark.parametrize("x", [0, 1])
@pytest.mark.parametrize("y", [2, 3])
def test_combinations(x, y):
    """运行 4 次: (0,2), (0,3), (1,2), (1,3)"""
    assert x < y
```

### 参数化 Fixture

```python
@pytest.fixture(params=["sqlite", "postgresql", "mysql"])
def database_type(request):
    return request.param

def test_database_connection(database_type):
    conn = connect_to_database(database_type)
    assert conn.is_connected()
```

### 参数化 + Mark 组合

```python
@pytest.mark.parametrize("input,expected", [
    ("valid@email.com", True),
    ("invalid", False),
    pytest.param("edge@case", True, marks=pytest.mark.xfail),
    pytest.param("slow@test.com", True, marks=pytest.mark.slow),
])
def test_email_validation(input, expected):
    assert is_valid_email(input) == expected
```

---

## Mock 与 Monkeypatch

### monkeypatch（自动恢复）

```python
def test_env_variable(monkeypatch):
    """测试环境变量访问"""
    monkeypatch.setenv("USER", "testuser")
    assert os.getenv("USER") == "testuser"

def test_external_api(monkeypatch):
    """Mock 外部 API"""
    class MockResponse:
        @staticmethod
        def json():
            return {"id": 1, "name": "Test User"}

    def mock_get(*args, **kwargs):
        return MockResponse()

    monkeypatch.setattr(requests, "get", mock_get)
    result = get_user_data(1)
    assert result["name"] == "Test User"
```

### unittest.mock

```python
from unittest.mock import Mock, patch

def test_mock_basic():
    mock_db = Mock()
    mock_db.get_user.return_value = {"id": 1, "name": "Alice"}

    user = mock_db.get_user(1)
    assert user["name"] == "Alice"
    mock_db.get_user.assert_called_once_with(1)

def test_patch_context():
    with patch('mymodule.database.get_connection') as mock_conn:
        mock_conn.return_value = Mock()
        # 测试代码
        assert mock_conn.called

@patch('mymodule.send_email')
def test_patch_decorator(mock_email):
    send_notification("test@example.com")
    mock_email.assert_called_once()
```

### Mock 副作用

```python
def test_mock_side_effects():
    mock_api = Mock()
    mock_api.fetch.side_effect = [
        {"status": "pending"},
        {"status": "processing"},
        {"status": "complete"}
    ]

    assert mock_api.fetch()["status"] == "pending"
    assert mock_api.fetch()["status"] == "processing"
    assert mock_api.fetch()["status"] == "complete"

def test_mock_exception():
    mock_service = Mock()
    mock_service.connect.side_effect = ConnectionError("Failed")

    with pytest.raises(ConnectionError):
        mock_service.connect()
```

---

## 测试组织

### 目录结构

```
project/
├── src/
│   └── mypackage/
│       ├── __init__.py
│       ├── models.py
│       └── services.py
├── tests/
│   ├── conftest.py          # 共享 fixtures
│   ├── unit/
│   │   ├── __init__.py
│   │   ├── test_models.py
│   │   └── test_utils.py
│   ├── integration/
│   │   ├── __init__.py
│   │   ├── conftest.py      # 集成测试专用 fixtures
│   │   └── test_services.py
│   └── e2e/
│       └── test_workflows.py
├── pytest.ini
└── pyproject.toml
```

### conftest.py - 共享 Fixtures

```python
# tests/conftest.py
import pytest

@pytest.fixture(scope="session")
def database():
    """所有测试可用的数据库连接"""
    db = Database()
    db.connect()
    yield db
    db.disconnect()

@pytest.fixture
def clean_database(database):
    """每个测试前的数据库清理"""
    database.clear_all_tables()
    return database

def pytest_configure(config):
    """注册自定义 markers"""
    config.addinivalue_line(
        "markers", "slow: marks tests as slow"
    )
    config.addinivalue_line(
        "markers", "integration: marks tests as integration tests"
    )
```

### Markers 分类

```python
import pytest

@pytest.mark.slow
def test_slow_operation():
    time.sleep(5)
    assert True

@pytest.mark.integration
def test_api_integration():
    response = requests.get("https://api.example.com")
    assert response.status_code == 200

@pytest.mark.skip(reason="功能未完成")
def test_future_feature():
    pass

@pytest.mark.skipif(sys.version_info < (3, 8), reason="需要 Python 3.8+")
def test_python38_feature():
    pass

@pytest.mark.xfail(reason="已知依赖 Bug")
def test_known_failure():
    assert False
```

运行过滤：
```bash
pytest -m slow                    # 只运行慢测试
pytest -m "not slow"              # 跳过慢测试
pytest -m "integration and not slow"
```

### 测试类组织

```python
class TestUserAuthentication:
    """相关测试分组"""

    @pytest.fixture(autouse=True)
    def setup(self):
        self.user_service = UserService()

    def test_login_success(self):
        result = self.user_service.login("user", "password")
        assert result.success

    def test_login_failure(self):
        result = self.user_service.login("user", "wrong")
        assert not result.success
```

---

## 常用内置 Fixtures

| Fixture | 用途 |
|---------|------|
| `tmp_path` | 临时目录（pathlib.Path） |
| `tmp_path_factory` | 临时目录工厂 |
| `capsys` | 捕获 stdout/stderr |
| `caplog` | 捕获日志输出 |
| `monkeypatch` | 安全修改对象/环境 |
| `request` | 测试请求对象 |

### tmp_path 示例

```python
def test_file_processing(tmp_path):
    test_file = tmp_path / "data.txt"
    test_file.write_text("test content")

    result = process_file(test_file)
    assert result.success
```

### caplog 示例

```python
def test_logging_output(caplog):
    with caplog.at_level(logging.INFO):
        process_data()

    assert "Processing started" in caplog.text
    assert any(record.levelname == "WARNING" for record in caplog.records)
```

### capsys 示例

```python
def test_print_output(capsys):
    print("Hello, World!")
    captured = capsys.readouterr()
    assert "Hello, World!" in captured.out
```

---

## 异常测试

```python
def test_divide_by_zero():
    with pytest.raises(ZeroDivisionError):
        10 / 0

def test_validation_error():
    with pytest.raises(ValueError, match="Invalid email"):
        validate_email("not-an-email")

def test_custom_error():
    with pytest.raises(ValidationError) as exc_info:
        validate_user_input({"email": "invalid"})

    assert "Invalid email format" in str(exc_info.value)
    assert exc_info.value.field == "email"
```

---

## 异步测试

```python
import pytest
import asyncio

@pytest.mark.asyncio
async def test_async_function():
    result = await async_fetch_data()
    assert result is not None

@pytest.mark.asyncio
async def test_async_timeout():
    with pytest.raises(asyncio.TimeoutError):
        await asyncio.wait_for(slow_async_operation(), timeout=1.0)

@pytest.mark.asyncio
async def test_concurrent_requests():
    tasks = [
        async_task1(),
        async_task2(),
        async_task3(),
    ]
    results = await asyncio.gather(*tasks)
    assert len(results) == 3
```

---

## 覆盖率

### 运行覆盖率

```bash
# 基本覆盖率
pytest --cov=mypackage tests/

# 终端报告
pytest --cov=mypackage --cov-report=term-missing tests/

# HTML 报告
pytest --cov=mypackage --cov-report=html tests/

# 低于阈值失败
pytest --cov=mypackage --cov-fail-under=80 tests/
```

### 配置（pytest.ini）

```ini
[pytest]
addopts =
    --cov=mypackage
    --cov-report=term-missing
    --cov-fail-under=80
```

### 排除代码

```python
def platform_specific():  # pragma: no cover
    if sys.platform == 'win32':
        pass

if TYPE_CHECKING:  # pragma: no cover
    pass
```

---

## 常用命令

```bash
pytest                          # 运行所有测试
pytest test_file.py            # 运行指定文件
pytest -k "pattern"            # 按模式过滤
pytest -m marker               # 按标记过滤
pytest -x                      # 首次失败停止
pytest --lf                    # 重跑上次失败
pytest -v                      # 详细输出
pytest -q                      # 简洁输出
pytest --cov=pkg               # 覆盖率报告
pytest -n auto                 # 并行执行（需 pytest-xdist）
pytest --collect-only          # 查看测试发现
pytest --fixtures              # 列出可用 fixtures
pytest --pdb                   # 失败时进入调试器
pytest --durations=10          # 显示最慢的 10 个测试
```

---

## 最佳实践

| 原则 | 说明 |
|------|------|
| **一测试一行为** | 每个测试只验证一个行为 |
| **描述性命名** | `test_user_login_with_invalid_credentials` |
| **AAA 模式** | Arrange → Act → Assert |
| **独立执行** | 不依赖其他测试的状态 |
| **适当作用域** | Fixture 使用最小必要作用域 |
| **关注行为而非实现** | 测试公共接口，不测私有实现 |
| **80%+ 覆盖率** | 核心逻辑优先，不追求 100% |

---

## 常用插件

```bash
pip install pytest-cov pytest-xdist pytest-asyncio pytest-mock pytest-timeout pytest-html pytest-benchmark hypothesis
```

| 插件 | 功能 |
|------|------|
| `pytest-cov` | 覆盖率报告 |
| `pytest-xdist` | 并行执行 |
| `pytest-asyncio` | 异步支持 |
| `pytest-mock` | Mock 增强 |
| `pytest-timeout` | 测试超时 |
| `pytest-html` | HTML 报告 |
| `pytest-benchmark` | 性能基准 |
| `hypothesis` | 基于属性的测试 |
| `factory-boy` | 测试数据工厂 |
| `faker` | 生成真实感测试数据 |

---

## Factory Boy 快速参考

> **详细指南**: `references/testing/test-data-management.md`

### 基本用法

```python
import factory
from myapp.models import User, Order

class UserFactory(factory.Factory):
    class Meta:
        model = User
    
    id = factory.Sequence(lambda n: n + 1)
    username = factory.Faker('user_name')
    email = factory.Faker('email')
    is_active = True

# 创建对象（不保存到数据库）
user = UserFactory.build()

# 批量创建
users = UserFactory.build_batch(size=10)

# 覆盖默认字段
admin = UserFactory.build(username="admin", is_active=True)
```

### 关联对象

```python
class OrderFactory(factory.Factory):
    class Meta:
        model = Order
    
    user = factory.SubFactory(UserFactory)
    status = "pending"

# 自动创建关联的 User
order = OrderFactory.build()

# 覆盖关联对象的字段
order = OrderFactory.build(user__username="buyer123")
```

### 常用模式

| 模式 | 用法 | 说明 |
|------|------|------|
| `Sequence` | `id = factory.Sequence(lambda n: n)` | 自增序列 |
| `Faker` | `name = factory.Faker('name')` | 使用 Faker 库 |
| `SubFactory` | `user = factory.SubFactory(UserFactory)` | 关联对象 |
| `LazyAttribute` | `full_name = factory.LazyAttribute(lambda o: f"{o.first} {o.last}")` | 惰性计算 |
| `Iterator` | `status = factory.Iterator(['pending', 'done'])` | 循环取值 |
| `post_generation` | 装饰器方法 | 创建后执行 |

---

## Faker 快速参考

> **完整 Provider 列表**: https://faker.readthedocs.io/

### 安装与初始化

```bash
pip install faker
```

```python
from faker import Faker
fake = Faker()  # 默认英文
fake_zh = Faker('zh_CN')  # 中文
```

### 常用数据生成

```python
# 个人身份
fake.name()              # 'Dr. Lisa Thompson'
fake.email()             # 'shawn@example.com'
fake.phone_number()      # '+1-(847)795-5875'

# 地址
fake.address()           # 完整地址字符串
fake.city()              # 'Port Jessicabury'
fake.zipcode()           # '22839-3874'

# 互联网
fake.url()               # 'https://www.miller.com/'
fake.domain_name()       # 'olson.net'
fake.ipv4_private()      # '192.168.143.194'
fake.uuid4()             # UUID 字符串

# 文本
fake.sentence()          # 单句话
fake.paragraph()         # 段落
fake.text(max_nb_chars=200)  # 指定长度文本

# 商业
fake.company()           # 'Brown LLC'
fake.job()               # 'Product engineer'

# 时间日期
fake.date_time_this_decade()
fake.date_between(start_date='-30d', end_date='today')

# 编程相关
fake.pyint(min_value=0, max_value=100)
fake.pyfloat(left_digits=2, right_digits=2, positive=True)
fake.pystr(min_chars=10, max_chars=20)
```

### 在 pytest 中使用

```python
@pytest.fixture
def fake_data():
    """提供 Faker 实例"""
    return Faker()

def test_user_creation(fake_data):
    name = fake_data.name()
    email = fake_data.email()
    
    user = create_user(name=name, email=email)
    
    assert user.name == name
    assert user.email == email
    assert "@" in user.email
```

---

## Hypothesis 属性测试快速参考

> **用于自动生成边界条件测试用例**

```bash
pip install hypothesis
```

```python
from hypothesis import given, strategies as st

@given(st.text(), st.text())
def test_string_concatenation(s1, s2):
    """Hypothesis 自动生成数百个测试用例"""
    result = s1 + s2
    assert len(result) == len(s1) + len(s2)
    assert result.startswith(s1) if s1 else True
    assert result.endswith(s2) if s2 else True

@given(st.integers(min_value=-1000, max_value=1000))
def test_absolute_value_is_non_negative(n):
    assert abs(n) >= 0

@given(st.lists(st.integers(), min_size=0, max_size=100))
def test_sort_idempotent(lst):
    assert sorted(sorted(lst)) == sorted(lst)

# 复合策略
UserStrategy = st.builds(
    User,
    username=st.text(min_size=3, max_size=20).map(str.strip),
    email=st.emails(),
    age=st.integers(min_value=18, max_value=120),
)

@given(UserStrategy())
def test_user_validation(user):
    assert len(user.username) >= 3
    assert "@" in user.email
    assert user.age >= 18
```

**版本**: 1.1.0
**兼容**: pytest 7.0+, Python 3.8+

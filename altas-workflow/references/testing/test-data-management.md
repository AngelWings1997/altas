# 测试数据管理策略

> **调用时机**: TEST 模式下需要系统化管理测试数据时加载
> **配合使用**: `references/testing/pytest-patterns.md`（pytest 基础）、`references/testing/api-testing.md`（API 测试）

---

## 核心原则

1. **数据独立性**: 每个测试用例拥有独立的数据集，不依赖其他测试的状态
2. **可重复性**: 相同测试在相同条件下应产生相同结果
3. **真实性**: 使用真实感数据而非 `foo/bar`，但需脱敏敏感信息
4. **最小化**: 只创建测试所需的最少数据，避免数据库膨胀
5. **自清理**: 测试结束后自动清理，不留垃圾数据

---

## 测试数据层次架构

| 层级 | 数据来源 | 隔离策略 | 适用场景 | 速度 |
|------|---------|----------|----------|------|
| **Unit** | 纯内存对象 | 无需 DB | 函数/方法级测试 | ⚡ 极快 |
| **Component** | SQLite 内存 / Mock | 每测试事务回滚 | 单模块集成测试 | 🚀 快 |
| **Integration** | Test Container (Docker) | 每测试类 truncate + 重建 | 跨服务交互 | 🐢 中等 |
| **E2E** | Docker Compose 环境 | 完整环境重建 | 用户旅程测试 | 🐌 较慢 |

### 层级选择决策树

```
需要外部依赖？
├─ 否 → Unit 层：直接使用 Python 对象/Fixture
└─ 是 → 能用 SQLite 内存数据库？
   ├─ 是 → Component 层：SQLite + SQLAlchemy
   └─ 否 → 能用 Docker？
      ├─ 是 → Integration 层：Test Container
      └─ 否 → 必须连接远程服务？
         ├─ 是 → E2E 层：完整环境或 Staging
         └─ 否 → 重构代码使其可测试
```

---

## Factory Boy 集成

### 为什么使用 Factory Boy

- **声明式定义**: 数据结构一目了然
- **链式创建**: 复杂关联对象一行搞定
- **惰性求值**: 只在访问时生成值，节省资源
- **可覆盖**: 特定测试可灵活修改字段
- **批量生成**: 批量创建测试数据集

### 安装

```bash
pip install factory-boy faker
```

### 基础 Factory 定义

```python
# tests/factories.py
import factory
from faker import Faker
from datetime import datetime, timedelta
from myapp.models import User, Order, Product

fake = Faker()

class UserFactory(factory.Factory):
    """用户工厂"""
    class Meta:
        model = User

    id = factory.Sequence(lambda n: n + 1)
    username = factory.LazyFunction(fake.user_name)
    email = factory.LazyFunction(fake.email)
    full_name = factory.LazyFunction(fake.name)
    is_active = True
    created_at = factory.LazyFunction(datetime.utcnow)

    @factory.post_generation
    def password(self, create, extracted, **kwargs):
        if not create:
            return
        self.set_password(extracted or "TestPass123!")


class ProductFactory(factory.Factory):
    """产品工厂"""
    class Meta:
        model = Product

    id = factory.Sequence(lambda n: n + 1000)
    name = factory.LazyFunction(lambda: fake.sentence(nb_words=3))
    description = factory.LazyFunction(fake.paragraph)
    price = factory.LazyFunction(lambda: round(fake.pyfloat(min_value=10, max_value=1000), 2))
    stock = factory.LazyFunction(lambda: fake.random_int(min=0, max=500))
    is_available = True


class OrderFactory(factory.Factory):
    """订单工厂 - 演示关联关系"""
    class Meta:
        model = Order

    id = factory.Sequence(lambda n: n + 5000)
    user = factory.SubFactory(UserFactory)
    status = "pending"
    total_amount = factory.LazyAttribute(lambda o: sum(item.price for item in o.items))
    created_at = factory.LazyFunction(datetime.utcnow)

    @factory.post_generation
    def items(self, create, extracted, **kwargs):
        if not create:
            return
        if extracted:
            for item_data in extracted:
                OrderItemFactory(order=self, **item_data)
```

### 在测试中使用 Factory

```python
import pytest
from tests.factories import UserFactory, ProductFactory, OrderFactory

def test_create_user():
    """基本用法"""
    user = UserFactory.build()  # 不保存到 DB
    
    assert user.username is not None
    assert user.email is not None
    assert "@" in user.email

def test_user_with_custom_fields():
    """覆盖默认字段"""
    admin_user = UserFactory.build(
        username="admin",
        email="admin@example.com",
        is_active=True
    )
    
    assert admin_user.username == "admin"
    assert admin_user.is_active is True

def test_batch_create_users():
    """批量生成"""
    users = UserFactory.build_batch(size=10)
    
    assert len(users) == 10
    usernames = {u.username for u in users}
    assert len(usernames) == 10  # 确保唯一性

def test_order_with_related_objects():
    """链式创建关联对象"""
    order = OrderFactory.build(
        user__username="buyer123",
        items=[
            {"product": ProductFactory.build(name="Widget A"), "quantity": 2},
            {"product": ProductFactory.build(name="Widget B"), "quantity": 1},
        ]
    )
    
    assert order.user.username == "buyer123"
    assert len(order.items) == 2
    assert order.total_amount > 0

@pytest.fixture
def sample_product():
    """作为 Fixture 使用"""
    return ProductFactory.build(name="Test Product", price=99.99)

def test_discount_calculation(sample_product):
    """测试折扣逻辑"""
    discounted_price = apply_discount(sample_product, percent=10)
    
    assert discounted_price == 89.99
```

### 高级 Factory 模式

#### 1. 条件字段生成

```python
class UserFactory(factory.Factory):
    class Meta:
        model = User
    
    account_type = "regular"
    
    # 根据类型动态设置权限
    @factory.lazy_attribute
    def permissions(self):
        if self.account_type == "admin":
            return ["read", "write", "delete", "manage_users"]
        elif self.account_type == "premium":
            return ["read", "write"]
        else:
            return ["read"]

class AdminUserFactory(UserFactory):
    """管理员子工厂"""
    account_type = "admin"
    email = factory.LazyFunction(lambda: f"admin_{fake.user_name()}@example.com")
```

#### 2. 序列与循环

```python
class StatusHistoryFactory(factory.Factory):
    class Meta:
        model = StatusHistory
    
    order = factory.SubFactory(OrderFactory)
    status = factory.Iterator([
        "pending",
        "processing",
        "shipped",
        "delivered"
    ])
    changed_at = factory.LazyFunction(
        lambda: datetime.utcnow() - timedelta(days=fake.random_int(min=1, max=30))
    )

def test_status_timeline():
    """生成状态历史记录"""
    history = StatusHistoryFactory.build_batch(size=4)
    
    statuses = [h.status for h in history]
    assert "pending" in statuses
    assert "delivered" in statuses
```

#### 3. 外部数据源集成

```python
class RealisticAddressFactory(factory.Factory):
    class Meta:
        model = Address
    
    street = factory.LazyFunction(fake.street_address)
    city = factory.LazyFunction(fake.city)
    state = factory.LazyFunction(fake.state_abbr)
    zip_code = factory.LazyFunction(fake.zipcode)
    country = "US"
    
    @factory.lazy_attribute
    def full_address(self):
        return f"{self.street}, {self.city}, {self.state} {self.zip_code}"
```

---

## Faker 库深度使用

### 常用 Provider 速查

```python
from faker import Faker
fake = Faker()

# 个人身份信息
fake.name()              # 'Dr. Lisa Thompson'
fake.email()             # 'kelly75@example.com'
fake.phone_number()      # '+1-(847)795-5875'
fake.ssn()               # '569-71-9646' (注意: 仅用于测试!)

# 地址
fake.address()           # 完整地址字符串
fake.latitude(), fake.longitude()
fake.country_code()      # 'US'

# 互联网
fake.url()               # 'https://www.harris.com/'
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
fake.credit_card_number()  # 卡号(仅用于测试!)
fake.credit_card_expire()  # '03/29'

# 时间日期
fake.date_time_this_decade()
fake.date_between(start_date='-30d', end_date='today')
fake.time_object()

# 文件
fake.file_name(extension='pdf')
fake.mime_type()         # 'application/pdf'

# 编程相关
fake.pyint(), fake.pyfloat()
fake.pystr(), fake.pylist()
```

### 本地化支持

```python
from faker import Faker

fake_zh = Faker('zh_CN')
fake_zh.name()           # '李伟'
fake_zh.address()        # '上海市霞区沈街C座 785065'
fake_zh.company()        # '百辰传媒有限公司'

fake_ja = Faker('ja_JP')
fake_ja.name()           # '田中 美咲'
```

### 自定义 Provider

```python
from faker.providers import BaseProvider

class TestingProvider(BaseProvider):
    """自定义测试专用 Provider"""
    
    def test_email(self, domain="test.example.com"):
        """生成测试专用邮箱"""
        return f"{self.generator.user_name()}@{domain}"
    
    def api_token(self):
        """生成 API Token 格式字符串"""
        import secrets
        return secrets.token_urlsafe(32)
    
    def error_message(self, category="validation"):
        """生成错误消息模板"""
        messages = {
            "validation": [
                "Field '{field}' is required",
                "Invalid format for '{field}'",
                "'{field}' must be between {min} and {max}",
            ],
            "auth": [
                "Invalid credentials",
                "Token expired",
                "Permission denied",
            ]
        }
        import random
        return random.choice(messages[category])

fake.add_provider(TestingProvider)

fake.test_email()        # 'john_doe@test.example.com'
fake.api_token()         # 'x7Kj9mNpQrStUvWxYz...'
fake.error_message()     # "Field 'email' is required"
```

---

## 测试数据隔离策略

### 策略 1: 事务回滚（推荐用于 Integration 测试）

```python
# tests/conftest.py
import pytest
from sqlalchemy.orm import sessionmaker
from myapp.database import engine, SessionLocal

@pytest.fixture(scope="function")
def db_session():
    """每个测试独立事务，测试结束自动回滚"""
    connection = engine.connect()
    transaction = connection.begin()
    session = SessionLocal(bind=connection)
    
    yield session
    
    session.close()
    transaction.rollback()
    connection.close()

@pytest.fixture
def user_in_db(db_session):
    """创建已持久化的用户"""
    user = UserFactory.build()
    db_session.add(user)
    db_session.commit()
    db_session.refresh(user)
    
    return user

def test_database_operation(user_in_db, db_session):
    """测试会修改数据库，但不影响其他测试"""
    user_in_db.username = "updated_username"
    db_session.commit()
    
    updated = db_session.query(User).filter_by(id=user_in_db.id).first()
    assert updated.username == "updated_username"

# 下一个测试运行时，数据库已回滚到干净状态
def test_clean_state(db_session):
    count = db_session.query(User).count()
    assert count == 0  # 上一个测试的更改已撤销
```

### 策略 2: 物理删除（适用于无法回滚的场景）

```python
@pytest.fixture(autouse=True)
def cleanup_after_test(request, db_session):
    """测试后清理所有测试数据"""
    yield
    
    if "no_cleanup" not in request.keywords:
        db_session.query(OrderItem).delete()
        db_session.query(Order).delete()
        db_session.query(Product).delete()
        db_session.query(User).delete()
        db_session.commit()
```

### 策略 3: Schema 重建（适用于 E2E 测试）

```python
@pytest.fixture(scope="session")
def e2e_db():
    """E2E 测试：每次会话重建 schema"""
    from myapp.models import Base
    
    Base.metadata.create_all(bind=engine)
    yield engine
    Base.metadata.drop_all(bind=engine)

@pytest.fixture(scope="function")
def clean_e2e_session(e2e_db):
    """每次测试前截断所有表"""
    session = SessionLocal()
    
    # 按外键依赖顺序截断
    session.execute("TRUNCATE TABLE order_items CASCADE")
    session.execute("TRUNCATE TABLE orders CASCADE")
    session.execute("TRUNCATE TABLE products CASCADE")
    session.execute("TRUNCATE TABLE users CASCADE")
    session.commit()
    
    yield session
    session.close()
```

### 策略选择指南

| 场景 | 推荐策略 | 原因 |
|------|---------|------|
| 单元测试 | 无需 DB | 使用 build() 不持久化 |
| 模块集成测试 | 事务回滚 | 快速、可靠 |
| 需要 COMMIT 的测试 | 物理删除 | 测试真实提交行为 |
| E2E 测试 | Schema 重建 | 最干净的环境 |
| 并发测试 | 独立数据库 | 避免锁冲突 |

---

## 测试数据版本管理

### Seed 数据与迁移同步

```python
# tests/seed_data.py
"""测试种子数据 - 与生产迁移保持同步"""

SEED_USERS = [
    {"id": 1, "username": "test_admin", "email": "admin@test.com", "role": "admin"},
    {"id": 2, "username": "test_user", "email": "user@test.com", "role": "user"},
]

SEED_PRODUCTS = [
    {"id": 100, "name": "Standard Widget", "price": 29.99, "stock": 100},
    {"id": 101, "name": "Premium Widget", "price": 99.99, "stock": 50},
]

def load_seed_data(session):
    """加载种子数据到测试数据库"""
    for user_data in SEED_USERS:
        session.add(User(**user_data))
    for product_data in SEED_PRODUCTS:
        session.add(Product(**product_data))
    session.commit()


# tests/conftest.py
@pytest.fixture(scope="module")
def seeded_db(session):
    """带种子数据的测试数据库"""
    load_seed_data(session)
    yield session
```

### 敏感数据脱敏规则

```python
# tests/factories/sensitive.py
"""敏感数据处理"""

import re
from faker import Faker

fake = Faker()

SENSITIVE_PATTERNS = {
    r'\b\d{3}-\d{2}-\d{4}\b': 'XXX-XX-XXXX',     # SSN
    r'\b\d{16}\b': 'XXXXXXXXXXXXXXXX',              # Credit Card
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}': '***@***.com',  # Email (可选)
}

def mask_sensitive_data(text: str) -> str:
    """脱敏文本中的敏感信息"""
    masked = text
    for pattern, replacement in SENSITIVE_PATTERNS.items():
        masked = re.sub(pattern, replacement, masked)
    return masked

class SafeUserFactory(factory.Factory):
    """安全用户工厂 - 自动脱敏日志"""
    class Meta:
        model = User
    
    username = factory.LazyFunction(fake.user_name)
    # 注意：不要在测试中使用真实 SSN/信用卡号
    
    def __repr__(self):
        return mask_sensitive_data(super().__repr__())
```

### 测试数据配置管理

```yaml
# tests/config/test_data.yaml
test_data:
  defaults:
    locale: "en_US"
    seed: 42  # 固定随机种子确保可重复
  
  database:
    cleanup_strategy: "rollback"  # rollback | delete | rebuild
    
  factories:
    user:
      default_role: "user"
      password_min_length: 8
      
  performance:
    batch_size:
      small: 10
      medium: 100
      large: 1000
        
  sensitive_fields:
    - ssn
    - credit_card_number
    - api_secret
    - password_hash
```

```python
# tests/config/loader.py
import yaml
from pathlib import Path

def load_test_config():
    config_path = Path(__file__).parent / "test_data.yaml"
    with open(config_path) as f:
        return yaml.safe_load(f)

TEST_CONFIG = load_test_config()
```

---

## 并发测试数据处理

### 问题场景

当使用 `pytest-xdist` 并行执行时，多个 worker 可能同时写入相同数据导致冲突：

```python
# ❌ 错误示例：并发时可能失败
def test_unique_constraint():
    user = UserFactory(username="unique_user")  # 多个 worker 同时创建同名用户
```

### 解决方案

#### 方案 1: Worker-aware 数据

```python
import os

def get_worker_id():
    """获取当前 pytest-xdist worker ID"""
    return os.environ.get("PYTEST_XDIST_WORKER", "gw0")

class ConcurrentSafeUserFactory(UserFactory):
    """并发安全的用户工厂"""
    
    @factory.lazy_attribute
    def username(self):
        worker_id = get_worker_id()
        return f"{fake.user_name()}_{worker_id}_{fake.random_int(min=1000, max=9999)}"
```

#### 方案 2: 独立数据库 per Worker

```pytest.ini
[pytest]
addopts = --dist=loadscope --tx=popen//python=python3.11
```

```python
# conftest.py
@pytest.fixture(scope="session")
def per_worker_db(worker_id):
    """为每个 worker 创建独立数据库"""
    db_name = f"test_db_{worker_id}"
    engine = create_engine(f"sqlite:///./test_{db_name}.db")
    
    Base.metadata.create_all(engine)
    yield engine
    Base.metadata.drop_all(engine)
    os.remove(f"./test_{db_name}.db")
```

#### 方案 3: 顺序执行关键测试

```python
@pytest.mark.xdist_group("serial")
def test_requires_serial_execution():
    """标记为串行执行，避免并发冲突"""
    ...
```

---

## 性能优化技巧

### 1. 惰性加载

```python
class LazyOrderFactory(factory.Factory):
    class Meta:
        model = Order
    
    # ❌ 每次 create 都生成
    description = factory.LazyFunction(
        lambda: fake.paragraph(nb_sentences=5)  # 每次都执行
    )
    
    # ✅ 只在访问时生成
    lazy_description = factory.LazyAttribute(
        lambda o: fake.paragraph(nb_sentences=5)  # 仅当 .lazy_description 被访问时
    )
```

### 2. 批量预生成

```python
@pytest.fixture(scope="session")
def product_pool():
    """预生成产品池，整个会话复用"""
    return ProductFactory.build_batch(size=100)

@pytest.fixture
def random_products(product_pool):
    """从池中随机抽取"""
    import random
    return random.sample(product_pool, k=5)
```

### 3. 数据库级别优化

```python
# pytest.ini
[pytest]
addopts =
    --tb=short
    -q
# 以下选项根据项目调整：
# --forked  # 每个测试独立进程（最彻底隔离）
# -n auto   # 并行执行（最快但需要处理并发）
```

---

## 最佳实践清单

编写或审查测试数据代码时，逐项检查：

**数据质量**
- [ ] 使用 Factory 而非硬编码字典
- [ ] 使用 Faker 生成真实感数据
- [ ] 敏感字段已脱敏或使用假数据
- [ ] 关联对象通过 SubFactory 创建

**数据隔离**
- [ ] 每个测试有独立数据集
- [ ] 测试结束后无残留数据
- [ ] 并发测试有防冲突机制
- [ ] 固定随机种子确保可重复

**性能考量**
- [ ] Unit 测试不涉及数据库
- [ ] Integration 测试使用事务回滚
- [ ] 批量操作使用 `build_batch`
- [ ] 避免不必要的字段生成

**维护性**
- [ ] Factory 与 Model 同步更新
- [ ] Seed 数据有版本管理
- [ ] 配置集中管理（YAML/ENV）
- [ ] 有清晰的文档注释

---

## 常见反模式

| 反模式 | 问题 | 正确做法 |
|--------|------|----------|
| 硬编码测试数据 | 脆弱、不可扩展 | 使用 Factory + Faker |
| 共享可变全局状态 | 测试间相互影响 | Fixture 作用域控制 |
| 测试间依赖顺序 | 并行执行必崩 | 每测试完全独立 |
| 清理逻辑遗漏 | 数据库膨胀 | autouse fixture 或事务 |
| 过度 Mock 真实数据 | 测试不信任 | 优先使用真实依赖 |
| 使用真实 PII 数据 | 合规风险 | Faker 生成假数据 |

---

## 快速参考卡片

```python
# 导入
from tests.factories import UserFactory, OrderFactory
from faker import Faker
fake = Faker()

# 基本操作
user = UserFactory.build()                    # 创建不保存
user = UserFactory.create()                   # 创建并保存（如果有 DB）
users = UserFactory.build_batch(size=10)      # 批量创建

# 自定义字段
admin = UserFactory.build(username="admin", role="admin")

# 关联对象
order = OrderFactory.build(user__username="buyer")

# Faker 快速使用
fake.email()           # 邮箱
fake.name()            # 姓名
fake.date_time()       # 时间
fake.pyfloat(1, 100)  # 浮点数
```

---

**版本**: 1.0.0
**兼容**: Python 3.8+, factory_boy 3.2+, faker 18+
**依赖**: `pip install factory-boy faker pytest`

# E2E 测试模式参考

> **来源**: 高级 E2E 测试技能整合
> **调用时机**: TEST 模式下需要编写 E2E 测试时加载，特别是涉及浏览器自动化、真实用户流或端到端链路验证
> **配合使用**: `references/testing/pytest-patterns.md`（pytest 基础）、`references/testing/api-testing.md`（API 层测试）

---

## 核心原则

**E2E 测试验证真实用户流** — 从外部视角测试完整系统，包括前端、后端、数据库和外部依赖。

### E2E 在测试金字塔中的位置

```
        ┌─────────┐
        │  E2E    │ ← 少量关键用户流（5-10%）
       /───────────\
      / Integration │ ← 模块间交互（20-30%）
     /───────────────\
    /    Unit Tests   │ ← 单元逻辑（60-70%）
   └──────────────────┘
```

- **单元测试**: 快、隔离、覆盖业务逻辑（首选）
- **集成测试**: 验证模块间交互（数据库、缓存、消息队列）
- **E2E 测试**: 验证真实用户流，但慢、脆弱、维护成本高

### E2E 测试的适用场景

| 场景 | 是否适合 E2E | 说明 |
|------|-------------|------|
| 关键用户旅程 | ✅ 是 | 注册→登录→核心操作→退出 |
| 跨系统集成点 | ✅ 是 | 前端→API→数据库完整链路 |
| 权限流程 | ✅ 是 | 不同角色的完整操作流 |
| 单个函数逻辑 | ❌ 否 | 应该用单元测试 |
| API 字段验证 | ❌ 否 | 应该用 API 测试 |
| 边界条件枚举 | ❌ 否 | 应该用单元/集成测试 |

---

## E2E 测试工具选型

### Playwright（推荐）

- **适用场景**: 现代 Web 应用、多浏览器支持、跨平台
- **优点**: 自动等待、支持 Chromium/Firefox/WebKit、TypeScript/Python/Java/C#、录制回放
- **缺点**: 较新、生态不如 Cypress 成熟

### Cypress

- **适用场景**: 前端为主的 E2E 测试、开发者友好
- **优点**: 实时重载、时间旅行调试、丰富的插件生态
- **缺点**: 仅支持 Chromium/Firefox（无 Safari）、标签页限制、iframe 支持弱

### pytest + Selenium/Playwright

- **适用场景**: Python 后端项目需要 E2E 测试
- **优点**: 复用 pytest 生态、与 API 测试共享 fixture
- **缺点**: 需要额外配置浏览器自动化

---

## E2E 测试环境搭建

### Playwright 安装

```bash
# 安装 Playwright
pip install playwright
playwright install

# 生成 playwright 配置
playwright codegen http://localhost:3000
```

### pytest-playwright 集成

```python
# conftest.py
import pytest
from playwright.sync_api import Page, expect

@pytest.fixture
def base_url():
    return "http://localhost:3000"

@pytest.fixture
def logged_in_page(page: Page, base_url: str):
    """登录后的页面 fixture"""
    page.goto(f"{base_url}/login")
    page.fill("input[name='email']", "test@example.com")
    page.fill("input[name='password']", "password123")
    page.click("button[type='submit']")
    page.wait_for_url("**/dashboard")
    return page
```

### Docker Compose 测试环境

```yaml
# docker-compose.e2e.yml
version: "3.8"
services:
  frontend:
    build: ./frontend
    ports:
      - "3000:3000"
    environment:
      - API_URL=http://backend:8000
    depends_on:
      - backend
  
  backend:
    build: ./backend
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql://test:test@db:5432/testdb
    depends_on:
      - db
  
  db:
    image: postgres:15
    environment:
      POSTGRES_USER: test
      POSTGRES_PASSWORD: test
      POSTGRES_DB: testdb
    ports:
      - "5432:5432"
```

```bash
# 启动 E2E 测试环境
docker compose -f docker-compose.e2e.yml up -d --wait

# 运行 E2E 测试
pytest tests/e2e/ --browser chromium

# 清理环境
docker compose -f docker-compose.e2e.yml down -v
```

---

## E2E 测试数据准备策略

### 1. API Setup（推荐）

```python
import requests
import pytest

@pytest.fixture
def api_client():
    """用于准备测试数据的 API 客户端"""
    return requests.Session()

@pytest.fixture
def test_user(api_client, base_url: str):
    """通过 API 创建测试用户"""
    response = api_client.post(f"{base_url}/api/users", json={
        "name": "E2E Test User",
        "email": f"e2e_{uuid4()}@test.com",
        "password": "securepass123"
    })
    assert response.status_code == 201
    user = response.json()
    
    yield user
    
    # Cleanup
    api_client.delete(f"{base_url}/api/users/{user['id']}")
```

### 2. Database Seed

```python
import pytest
from sqlalchemy import create_engine
from app.models import User, Base

@pytest.fixture
def seeded_db():
    """直接写入数据库准备测试数据"""
    engine = create_engine("postgresql://test:test@localhost:5432/testdb")
    with engine.begin() as conn:
        user = User(
            name="E2E Test User",
            email=f"e2e_{uuid4()}@test.com",
            password_hash=hash_password("securepass123")
        )
        conn.add(user)
    
    yield
    
    with engine.begin() as conn:
        conn.execute(User.__table__.delete().where(
            User.email.like("e2e_%@test.com")
        ))
```

### 3. UI Setup

```python
@pytest.fixture
def registered_user(page: Page, base_url: str):
    """通过 UI 注册流程创建用户"""
    page.goto(f"{base_url}/register")
    page.fill("input[name='name']", "E2E Test User")
    page.fill("input[name='email']", f"e2e_{uuid4()}@test.com")
    page.fill("input[name='password']", "securepass123")
    page.click("button[type='submit']")
    page.wait_for_url("**/dashboard")
    return page
```

---

## E2E 测试稳定性保障

### 1. 智能等待替代硬编码 sleep

```python
# ❌ 避免硬编码等待
import time
time.sleep(5)

# ✅ 使用 Playwright 自动等待
page.click("button[type='submit']")  # 自动等待按钮可点击
page.wait_for_selector(".success-message")  # 等待元素出现
page.wait_for_url("**/dashboard")  # 等待 URL 变化

# ✅ 使用 expect 断言自动重试
from playwright.sync_api import expect
expect(page.get_by_text("Welcome")).to_be_visible(timeout=10000)
```

### 2. 测试隔离与重试

```python
# pytest.ini
[pytest]
addopts = --reruns 2 --reruns-delay 1
markers =
    e2e: End-to-end tests (slow, run in CI only)
    flaky: Known flaky tests (investigate and fix)

# 单个测试重试
@pytest.mark.flaky(reruns=3, reruns_delay=2)
def test_checkout_flow(page: Page):
    ...
```

### 3. 截图与视频调试

```python
@pytest.fixture
def page_with_recording(context, request):
    """记录测试视频"""
    context = context.new_context(
        record_video_dir=f"videos/{request.node.name}"
    )
    page = context.new_page()
    yield page
    
    # 失败时保存截图
    if request.node.rep_call.failed:
        page.screenshot(path=f"screenshots/{request.node.name}.png")
```

### 4. 并行执行加速

```bash
# pytest-xdist 并行执行
pytest tests/e2e/ -n 4 --dist worksteal

# Playwright 多浏览器并行
pytest tests/e2e/ --browser chromium --browser firefox -x
```

---

## E2E 测试编写模式

### 1. Page Object 模式

```python
# pages/login_page.py
class LoginPage:
    def __init__(self, page):
        self.page = page
        self.email_input = page.get_by_label("Email")
        self.password_input = page.get_by_label("Password")
        self.login_button = page.get_by_role("button", name="Login")
    
    def navigate(self, base_url: str):
        self.page.goto(f"{base_url}/login")
    
    def login(self, email: str, password: str):
        self.email_input.fill(email)
        self.password_input.fill(password)
        self.login_button.click()
        self.page.wait_for_url("**/dashboard")

# tests/e2e/test_login_flow.py
def test_valid_login(page: Page, base_url: str):
    login_page = LoginPage(page)
    login_page.navigate(base_url)
    login_page.login("test@example.com", "password123")
    
    expect(page.get_by_text("Welcome")).to_be_visible()
```

### 2. 关键用户旅程

```python
def test_complete_checkout_flow(logged_in_page: Page):
    """验证完整购物流程：浏览→加购→结算→支付"""
    page = logged_in_page
    
    # 浏览商品
    page.click("a[href='/products']")
    page.click(".product-card >> nth=0")
    
    # 加入购物车
    page.click("button:has-text('Add to Cart')")
    expect(page.get_by_text("Added to cart")).to_be_visible()
    
    # 结算
    page.click("a[href='/cart']")
    page.click("button:has-text('Checkout')")
    
    # 填写地址
    page.fill("input[name='address']", "123 Test Street")
    page.click("button:has-text('Continue')")
    
    # 支付
    page.fill("input[name='card_number']", "4111111111111111")
    page.fill("input[name='expiry']", "12/25")
    page.click("button:has-text('Pay Now')")
    
    # 验证订单完成
    page.wait_for_url("**/order/confirmation")
    expect(page.get_by_text("Order Confirmed")).to_be_visible()
```

### 3. 权限流程测试

```python
@pytest.mark.e2e
class TestRoleBasedAccess:
    def test_admin_can_manage_users(self, admin_page: Page):
        page = admin_page
        page.click("a[href='/admin/users']")
        page.wait_for_selector(".user-management-panel")
        
        # 创建用户
        page.click("button:has-text('Add User')")
        page.fill("input[name='name']", "New User")
        page.click("button:has-text('Save')")
        expect(page.get_by_text("New User")).to_be_visible()
    
    def test_regular_user_cannot_access_admin(self, user_page: Page):
        page = user_page
        page.goto("/admin/users")
        expect(page.get_by_text("Access Denied")).to_be_visible()
        assert "admin" not in page.url
```

---

## E2E 在 CI 中的执行策略

### 何时运行 E2E 测试

| 场景 | 运行 E2E | 说明 |
|------|---------|------|
| 本地开发 | ❌ 可选 | 开发者按需运行 |
| PR 合并到 main | ✅ 必须 | 保护主分支 |
| 发布前 | ✅ 必须 | 发布门禁 |
| 定时巡检 | ✅ 推荐 | 每日/每周健康检查 |

### GitHub Actions E2E 模板

```yaml
name: E2E Tests

on:
  push:
    branches: [main]
  schedule:
    - cron: '0 2 * * *'  # 每日 2AM 运行

jobs:
  e2e:
    runs-on: ubuntu-latest
    timeout-minutes: 30
    
    services:
      postgres:
        image: postgres:15
        env:
          POSTGRES_USER: test
          POSTGRES_PASSWORD: test
          POSTGRES_DB: testdb
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
    
    steps:
      - uses: actions/checkout@v4
      
      - name: Start services
        run: |
          docker compose -f docker-compose.e2e.yml up -d --wait
          sleep 10  # 等待服务完全就绪
      
      - name: Install dependencies
        run: pip install -r requirements-e2e.txt
      
      - name: Install Playwright browsers
        run: playwright install chromium --with-deps
      
      - name: Run E2E tests
        run: pytest tests/e2e/ --browser chromium --tb=short
      
      - name: Upload artifacts on failure
        if: failure()
        uses: actions/upload-artifact@v3
        with:
          name: e2e-failure-artifacts
          path: |
            screenshots/
            videos/
            playwright-report/
      
      - name: Cleanup
        if: always()
        run: docker compose -f docker-compose.e2e.yml down -v
```

---

## E2E 与单元/集成测试的分层边界

### 职责划分

| 测试层级 | 验证内容 | 执行频率 | 典型耗时 |
|---------|---------|---------|---------|
| 单元测试 | 函数/方法逻辑 | 每次提交 | < 10ms |
| 组件测试 | 模块间交互 | 每次 PR | < 1s |
| 集成测试 | 服务间通信 | 合并到 main | < 10s |
| E2E 测试 | 用户旅程 | 合并/发布 | < 60s |

### 边界示例

```python
# ❌ 不应该在 E2E 中测试
def test_calculate_discount_percentage():
    """这是纯计算逻辑，应该用单元测试"""
    assert calculate_discount(100, 20) == 80

# ❌ 不应该在 E2E 中测试
def test_api_returns_422_for_invalid_email():
    """这是 API 字段验证，应该用 API 测试"""
    response = client.post("/users", json={"email": "invalid"})
    assert response.status_code == 422

# ✅ 应该在 E2E 中测试
def test_user_can_complete_purchase_flow():
    """这是完整用户旅程，必须用 E2E 测试"""
    # 登录→浏览→加购→结算→支付→订单确认
    # 涉及前端、后端、支付网关完整链路
```

---

## E2E 测试清单

- [ ] 覆盖了关键用户旅程（注册、登录、核心操作、退出）
- [ ] 测试数据通过 API 或 DB 准备，不依赖 UI 创建
- [ ] 使用智能等待（自动等待/断言重试），无硬编码 sleep
- [ ] 测试间隔离，无状态污染
- [ ] 失败时自动保存截图/视频用于调试
- [ ] CI 中配置了超时和重试策略
- [ ] E2E 测试数量控制在合理范围（建议 < 50 个）
- [ ] 与单元/集成测试有明确的职责划分

---

## 常用插件

```bash
pip install pytest-playwright pytest-xdist pytest-rerunfailures
```

| 插件 | 功能 |
|------|------|
| `pytest-playwright` | Playwright pytest 集成 |
| `pytest-xdist` | 并行执行加速 |
| `pytest-rerunfailures` | 失败重试机制 |
| `pytest-html` | 生成 HTML 测试报告 |

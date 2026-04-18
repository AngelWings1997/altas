# 移动端测试

> **调用时机**: 需要测试 iOS/Android 应用、混合应用(Hybrid)、移动 Web 时加载
> **配合使用**: `references/testing/e2e-testing.md`（E2E 测试基础）、`references/testing/api-testing.md`（API 测试）

---

## 核心原则

1. **设备碎片化**: 移动设备型号、屏幕尺寸、系统版本众多，需要策略性覆盖
2. **网络多样性**: 测试弱网、离线、网络切换等场景
3. **交互特殊性**: 触摸、手势、传感器、系统权限等移动端特有交互
4. **资源受限**: 关注内存、电量、存储等移动设备资源消耗

---

## 工具选型

| 工具 | 平台 | 类型 | 优点 | 缺点 |
|------|------|------|------|------|
| **Appium** | iOS/Android | 开源框架 | 跨平台、多语言绑定、WebDriver 协议 | 配置复杂、执行较慢 |
| **Detox** | iOS/Android | 灰盒测试 | 快速、稳定、同步机制 | 仅 React Native |
| **XCUITest** | iOS | 原生框架 | 苹果官方、性能最好 | 仅 iOS、需 macOS |
| **Espresso** | Android | 原生框架 | Google 官方、快速稳定 | 仅 Android |
| **Maestro** | iOS/Android | 新兴框架 | 配置简单、YAML 驱动、快速 | 社区较新 |
| **Playwright** | Mobile Web | 跨浏览器 | 与桌面端一致、快速 | 仅 Mobile Web |

**推荐组合**:
- React Native 应用: **Detox**（快速）+ **Appium**（覆盖系统级交互）
- 原生应用: **XCUITest** (iOS) + **Espresso** (Android)
- 快速冒烟测试: **Maestro**
- Mobile Web: **Playwright** 设备模拟

---

## 1. Appium 移动测试

### 环境配置

```bash
# 安装 Appium
npm install -g appium

# 安装驱动
appium driver install xcuitest      # iOS
appium driver install uiautomator2  # Android

# 启动服务
appium
```

```python
# tests/mobile/conftest.py
import pytest
from appium import webdriver
from appium.options.ios import XCUITestOptions
from appium.options.android import UiAutomator2Options


@pytest.fixture(scope="function")
def ios_driver():
    """iOS 测试驱动"""
    options = XCUITestOptions()
    options.platform_name = "iOS"
    options.platform_version = "17.0"
    options.device_name = "iPhone 15 Pro"
    options.automation_name = "XCUITest"
    options.app = "/path/to/MyApp.app"
    options.udid = "auto"
    
    driver = webdriver.Remote(
        command_executor="http://localhost:4723",
        options=options
    )
    
    yield driver
    driver.quit()


@pytest.fixture(scope="function")
def android_driver():
    """Android 测试驱动"""
    options = UiAutomator2Options()
    options.platform_name = "Android"
    options.platform_version = "14"
    options.device_name = "Pixel 7"
    options.automation_name = "UiAutomator2"
    options.app = "/path/to/myapp.apk"
    options.app_package = "com.example.myapp"
    options.app_activity = ".MainActivity"
    
    driver = webdriver.Remote(
        command_executor="http://localhost:4723",
        options=options
    )
    
    yield driver
    driver.quit()
```

### 基础测试示例

```python
# tests/mobile/test_login.py
import pytest
from selenium.webdriver.common.by import AppiumBy
from selenium.webdriver.support.ui import WebDriverWait
from selenium.webdriver.support import expected_conditions as EC


class TestLogin:
    """登录功能测试"""
    
    def test_successful_login(self, ios_driver):
        """测试成功登录"""
        driver = ios_driver
        wait = WebDriverWait(driver, 10)
        
        # 输入邮箱
        email_field = wait.until(
            EC.presence_of_element_located((AppiumBy.ACCESSIBILITY_ID, "email-input"))
        )
        email_field.send_keys("test@example.com")
        
        # 输入密码
        password_field = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "password-input")
        password_field.send_keys("Secure123!")
        
        # 点击登录
        login_button = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "login-button")
        login_button.click()
        
        # 验证登录成功
        welcome_message = wait.until(
            EC.presence_of_element_located((AppiumBy.ACCESSIBILITY_ID, "welcome-message"))
        )
        assert "Welcome" in welcome_message.text
    
    def test_invalid_credentials(self, ios_driver):
        """测试无效凭据"""
        driver = ios_driver
        wait = WebDriverWait(driver, 10)
        
        # 输入错误密码
        driver.find_element(AppiumBy.ACCESSIBILITY_ID, "email-input").send_keys("test@example.com")
        driver.find_element(AppiumBy.ACCESSIBILITY_ID, "password-input").send_keys("wrongpassword")
        driver.find_element(AppiumBy.ACCESSIBILITY_ID, "login-button").click()
        
        # 验证错误提示
        error_message = wait.until(
            EC.presence_of_element_located((AppiumBy.ACCESSIBILITY_ID, "error-message"))
        )
        assert "Invalid credentials" in error_message.text
```

### 手势操作

```python
# tests/mobile/test_gestures.py
from appium.webdriver.common.touch_action import TouchAction
from appium.webdriver.common.multi_action import MultiAction


class TestGestures:
    """手势操作测试"""
    
    def test_swipe_to_delete(self, ios_driver):
        """测试滑动删除"""
        driver = ios_driver
        
        # 找到列表项
        item = driver.find_element(AppiumBy.XPATH, "//XCUIElementTypeCell[1]")
        
        # 执行左滑
        driver.execute_script("mobile: swipeGesture", {
            "elementId": item.id,
            "direction": "left",
            "percent": 0.5
        })
        
        # 点击删除按钮
        delete_button = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "Delete")
        delete_button.click()
        
        # 验证删除成功
        items = driver.find_elements(AppiumBy.XPATH, "//XCUIElementTypeCell")
        assert len(items) == 0
    
    def test_pinch_to_zoom(self, ios_driver):
        """测试捏合缩放"""
        driver = ios_driver
        
        image = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "zoomable-image")
        
        # 获取元素中心点
        location = image.location
        size = image.size
        center_x = location["x"] + size["width"] / 2
        center_y = location["y"] + size["height"] / 2
        
        # 执行捏合放大
        driver.execute_script("mobile: pinchGesture", {
            "elementId": image.id,
            "scale": 2.0,  # 放大 2 倍
            "velocity": 1.0
        })
    
    def test_long_press(self, android_driver):
        """测试长按操作"""
        driver = android_driver
        
        element = driver.find_element(AppiumBy.ID, "com.example.myapp:id/item")
        
        # 长按
        actions = TouchAction(driver)
        actions.long_press(element).perform()
        
        # 验证上下文菜单出现
        menu = driver.find_element(AppiumBy.ID, "com.example.myapp:id/context_menu")
        assert menu.is_displayed()
```

### 系统权限处理

```python
# tests/mobile/test_permissions.py
import pytest


class TestPermissions:
    """系统权限测试"""
    
    def test_camera_permission_granted(self, ios_driver):
        """测试相机权限 - 允许"""
        driver = ios_driver
        
        # 点击需要相机权限的按钮
        driver.find_element(AppiumBy.ACCESSIBILITY_ID, "scan-qr-button").click()
        
        # 处理权限弹窗（iOS）
        try:
            allow_button = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "Allow")
            allow_button.click()
        except:
            pass  # 权限已授予
        
        # 验证相机界面打开
        camera_view = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "camera-preview")
        assert camera_view.is_displayed()
    
    def test_location_permission_denied(self, android_driver):
        """测试位置权限 - 拒绝"""
        driver = android_driver
        
        # 点击需要位置权限的按钮
        driver.find_element(AppiumBy.ID, "com.example.myapp:id/nearby-button").click()
        
        # 处理权限弹窗（Android）
        try:
            deny_button = driver.find_element(AppiumBy.ID, "com.android.permissioncontroller:id/permission_deny_button")
            deny_button.click()
        except:
            pass
        
        # 验证显示权限被拒绝提示
        error_message = driver.find_element(AppiumBy.ID, "com.example.myapp:id/permission_error")
        assert "Location permission required" in error_message.text
```

---

## 2. Detox (React Native)

### 配置

```javascript
// .detoxrc.js
module.exports = {
  apps: {
    'ios.debug': {
      type: 'ios.app',
      binaryPath: 'ios/build/Build/Products/Debug-iphonesimulator/MyApp.app',
      build: 'xcodebuild -workspace ios/MyApp.xcworkspace -scheme MyApp -configuration Debug -sdk iphonesimulator -derivedDataPath ios/build'
    },
    'android.debug': {
      type: 'android.apk',
      binaryPath: 'android/app/build/outputs/apk/debug/app-debug.apk',
      build: 'cd android && ./gradlew assembleDebug assembleAndroidTest -DtestBuildType=debug'
    }
  },
  devices: {
    simulator: {
      type: 'ios.simulator',
      device: {
        type: 'iPhone 15 Pro'
      }
    },
    emulator: {
      type: 'android.emulator',
      device: {
        avdName: 'Pixel_7_API_34'
      }
    }
  },
  configurations: {
    'ios.sim.debug': {
      device: 'simulator',
      app: 'ios.debug'
    },
    'android.emu.debug': {
      device: 'emulator',
      app: 'android.debug'
    }
  }
};
```

### 测试示例

```javascript
// e2e/login.test.js
describe('Login Flow', () => {
  beforeAll(async () => {
    await device.launchApp();
  });

  beforeEach(async () => {
    await device.reloadReactNative();
  });

  it('should login successfully with valid credentials', async () => {
    // 输入邮箱
    await element(by.id('email-input')).typeText('test@example.com');
    
    // 输入密码
    await element(by.id('password-input')).typeText('Secure123!');
    
    // 隐藏键盘
    await element(by.id('password-input')).tapReturnKey();
    
    // 点击登录
    await element(by.id('login-button')).tap();
    
    // 验证登录成功
    await expect(element(by.id('home-screen'))).toBeVisible();
    await expect(element(by.text('Welcome, test@example.com'))).toBeVisible();
  });

  it('should show error for invalid credentials', async () => {
    await element(by.id('email-input')).typeText('test@example.com');
    await element(by.id('password-input')).typeText('wrongpassword');
    await element(by.id('login-button')).tap();
    
    // 验证错误提示
    await expect(element(by.text('Invalid credentials'))).toBeVisible();
  });

  it('should navigate to forgot password', async () => {
    await element(by.id('forgot-password-link')).tap();
    await expect(element(by.id('forgot-password-screen'))).toBeVisible();
  });
});

// e2e/checkout.test.js
describe('Checkout Flow', () => {
  it('should complete purchase flow', async () => {
    // 添加商品到购物车
    await element(by.id('product-1')).tap();
    await element(by.id('add-to-cart-button')).tap();
    
    // 进入购物车
    await element(by.id('cart-tab')).tap();
    await expect(element(by.id('cart-screen'))).toBeVisible();
    
    // 结账
    await element(by.id('checkout-button')).tap();
    
    // 填写配送信息
    await element(by.id('address-input')).typeText('123 Test St');
    await element(by.id('city-input')).typeText('Test City');
    
    // 滑动确认（iOS 手势）
    await element(by.id('confirm-slider')).swipe('right', 'fast', 0.75);
    
    // 验证订单成功
    await waitFor(element(by.id('order-success')))
      .toBeVisible()
      .withTimeout(5000);
  });
});
```

---

## 3. Maestro 快速测试

### 配置

```yaml
# .maestro/config.yaml
flows:
  - "flows/**/*.yaml"

executionOrder:
  continueOnFailure: false
```

### Flow 文件

```yaml
# flows/login.yaml
appId: com.example.myapp
---
- launchApp
- tapOn: "Email"
- inputText: "test@example.com"
- tapOn: "Password"
- inputText: "Secure123!"
- tapOn: "Login"
- assertVisible: "Welcome"
```

```yaml
# flows/checkout.yaml
appId: com.example.myapp
---
- launchApp
- tapOn: "Products"
- tapOn: "Add to Cart"
- tapOn: "Cart"
- tapOn: "Checkout"
- tapOn: "Address"
- inputText: "123 Test Street"
- tapOn: "Place Order"
- assertVisible: "Order Confirmed"
- takeScreenshot: order-confirmation
```

```yaml
# flows/network-conditions.yaml
appId: com.example.myapp
---
- launchApp
- setNetwork:
    speed: slow  # 模拟慢网
- tapOn: "Load Data"
- assertVisible: "Loading..."
- waitForAnimationToEnd
- assertVisible: "Data Loaded"
```

---

## 4. Mobile Web 测试 (Playwright)

```python
# tests/mobile_web/test_responsive.py
import pytest
from playwright.sync_api import sync_playwright


MOBILE_DEVICES = [
    {"name": "iPhone 14", "viewport": {"width": 390, "height": 844}, "user_agent": "iPhone"},
    {"name": "iPhone 14 Pro Max", "viewport": {"width": 430, "height": 932}, "user_agent": "iPhone"},
    {"name": "Pixel 7", "viewport": {"width": 412, "height": 915}, "user_agent": "Android"},
    {"name": "Samsung S23", "viewport": {"width": 384, "height": 854}, "user_agent": "Android"},
]


@pytest.fixture(params=MOBILE_DEVICES)
def mobile_page(request):
    """在移动设备视口中测试"""
    device = request.param
    
    with sync_playwright() as p:
        browser = p.chromium.launch()
        context = browser.new_context(
            viewport=device["viewport"],
            user_agent=device["user_agent"]
        )
        page = context.new_page()
        
        yield page, device["name"]
        
        context.close()
        browser.close()


class TestMobileWeb:
    """Mobile Web 测试"""
    
    def test_navigation_menu(self, mobile_page):
        """测试移动端导航菜单"""
        page, device_name = mobile_page
        
        page.goto("https://example.com")
        
        # 验证汉堡菜单存在
        menu_button = page.locator('[data-testid="mobile-menu-button"]')
        assert menu_button.is_visible()
        
        # 点击展开菜单
        menu_button.click()
        
        # 验证菜单项可见
        nav_items = page.locator('[data-testid="nav-item"]')
        assert nav_items.count() > 0
    
    def test_touch_events(self, mobile_page):
        """测试触摸事件"""
        page, device_name = mobile_page
        
        page.goto("https://example.com/gallery")
        
        # 模拟滑动手势
        image = page.locator('[data-testid="gallery-image"]').first
        
        # 获取元素位置
        box = image.bounding_box()
        start_x = box["x"] + box["width"] / 2
        start_y = box["y"] + box["height"] / 2
        
        # 执行滑动
        page.mouse.move(start_x, start_y)
        page.mouse.down()
        page.mouse.move(start_x - 200, start_y)
        page.mouse.up()
        
        # 验证图片切换
        next_image = page.locator('[data-testid="gallery-image"]').nth(1)
        assert next_image.is_visible()
```

---

## 5. 网络条件测试

```python
# tests/mobile/test_network_conditions.py
import pytest


class TestNetworkConditions:
    """网络条件测试"""
    
    def test_offline_mode(self, ios_driver):
        """测试离线模式"""
        driver = ios_driver
        
        # 断开网络
        driver.execute_script("mobile: setConnectionInfo", {
            "wifi": False,
            "data": False,
            "airplaneMode": True
        })
        
        # 尝试加载数据
        driver.find_element(AppiumBy.ACCESSIBILITY_ID, "refresh-button").click()
        
        # 验证离线提示
        offline_message = driver.find_element(AppiumBy.ACCESSIBILITY_ID, "offline-message")
        assert "No internet connection" in offline_message.text
        
        # 恢复网络
        driver.execute_script("mobile: setConnectionInfo", {
            "wifi": True,
            "data": True,
            "airplaneMode": False
        })
    
    def test_slow_network(self, android_driver):
        """测试慢网条件"""
        driver = android_driver
        
        # 模拟 3G 网络
        driver.execute_script("mobile: setConnectionInfo", {
            "type": "slow",
            "latency": 100,
            "bandwidth": 1000  # 1 Mbps
        })
        
        # 测试加载超时
        driver.find_element(AppiumBy.ID, "com.example.myapp:id/load-heavy-content").click()
        
        # 验证加载指示器
        spinner = driver.find_element(AppiumBy.ID, "com.example.myapp:id/loading-spinner")
        assert spinner.is_displayed()
```

---

## 6. 设备矩阵策略

```python
# tests/mobile/device_matrix.py
DEVICE_MATRIX = {
    "iOS": [
        {"device": "iPhone 15 Pro", "os": "17.0", "priority": "P0"},
        {"device": "iPhone 14", "os": "16.0", "priority": "P1"},
        {"device": "iPhone SE", "os": "17.0", "priority": "P1"},
        {"device": "iPad Pro", "os": "17.0", "priority": "P2"},
    ],
    "Android": [
        {"device": "Pixel 7", "os": "14.0", "priority": "P0"},
        {"device": "Samsung S23", "os": "13.0", "priority": "P1"},
        {"device": "Xiaomi 13", "os": "13.0", "priority": "P2"},
        {"device": "Low-end Device", "os": "11.0", "priority": "P2"},
    ]
}


def get_test_devices(priority=None):
    """获取测试设备列表"""
    devices = []
    for platform, platform_devices in DEVICE_MATRIX.items():
        for device in platform_devices:
            if priority is None or device["priority"] in priority:
                devices.append({**device, "platform": platform})
    return devices
```

---

## 7. CI/CD 集成

```yaml
# .github/workflows/mobile-tests.yml
name: Mobile Tests

on: [push, pull_request]

jobs:
  ios-tests:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Setup Detox
        run: |
          brew tap wix/brew
          brew install applesimutils
      
      - name: Build iOS
        run: npx detox build --configuration ios.sim.debug
      
      - name: Run iOS tests
        run: npx detox test --configuration ios.sim.debug

  android-tests:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - name: Setup JDK
        uses: actions/setup-java@v4
        with:
          java-version: '17'
          distribution: 'temurin'
      
      - name: Setup Android SDK
        uses: android-actions/setup-android@v3
      
      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '18'
      
      - name: Install dependencies
        run: npm ci
      
      - name: Build Android
        run: npx detox build --configuration android.emu.debug
      
      - name: Run Android tests
        uses: reactivecircus/android-emulator-runner@v2
        with:
          api-level: 34
          arch: x86_64
          script: npx detox test --configuration android.emu.debug
```

---

## 8. 移动端测试清单

### 功能测试
- [ ] 核心用户流程（登录、注册、购买等）
- [ ] 表单输入和验证
- [ ] 导航和页面跳转
- [ ] 搜索和筛选
- [ ] 数据同步

### 交互测试
- [ ] 触摸和手势（点击、滑动、捏合、长按）
- [ ] 键盘输入和隐藏
- [ ] 系统权限（相机、位置、通知、存储）
- [ ] 深度链接
- [ ] 分享功能

### 网络测试
- [ ] 离线模式
- [ ] 弱网条件
- [ ] 网络切换（WiFi <-> 4G）
- [ ] 请求超时和重试

### 设备特性
- [ ] 屏幕旋转
- [ ] 不同屏幕尺寸
- [ ] 深色模式
- [ ] 分屏/多窗口（Android）
- [ ] 画中画

### 性能测试
- [ ] 启动时间
- [ ] 页面加载时间
- [ ] 内存使用
- [ ] 电池消耗
- [ ] 流畅度（FPS）

---

**版本**: 1.0.0
**兼容**: Appium 2.0+, Detox 20.0+, Maestro 1.30+

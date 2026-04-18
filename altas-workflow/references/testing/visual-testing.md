# 可视化测试 / 视觉回归测试

> **调用时机**: 需要验证 UI 外观一致性、防止视觉回归、测试组件视觉状态时加载
> **配合使用**: `references/testing/e2e-testing.md`（E2E 测试）、`references/testing/pytest-patterns.md`（pytest 基础）

---

## 核心原则

1. **视觉即契约**: UI 外观是用户体验的重要组成部分，需要像功能一样被测试
2. **像素级精确**: 检测任何意外的视觉变化，无论多小
3. **基线管理**: 有意识的视觉更新需要更新基线，而非忽略差异
4. **跨浏览器/设备**: 在不同视口和浏览器中验证一致性

---

## 工具选型

| 工具 | 类型 | 适用场景 | 优点 | 缺点 |
|------|------|----------|------|------|
| **Chromatic** | 云托管 | Storybook 组件测试 | 零配置、CI 集成、团队协作 | 付费（有免费额度） |
| **Storybook Test Runner** | 本地 + CI | 组件交互 + 视觉 | 开源、与 Storybook 深度集成 | 需自行配置视觉对比 |
| **Percy** | 云托管 | 全栈视觉测试 | 支持多种框架、并行快照 | 付费 |
| **Applitools** | 云托管 | AI 驱动的视觉测试 | AI 忽略动态内容、跨平台 | 较贵 |
| **Playwright** | 本地 | E2E 视觉测试 | 内置截图对比、免费 | 需自行管理基线 |
| **Cypress + cypress-image-snapshot** | 本地 | E2E 视觉测试 | 社区插件丰富 | 配置较复杂 |

**推荐组合**:
- 组件级: **Chromatic** + Storybook（最快反馈）
- 页面级: **Playwright** 截图对比（E2E 流程中）
- 全栈: **Percy** 或 **Applitools**（企业级）

---

## 1. Chromatic + Storybook 组件测试

### 安装配置

```bash
# 安装 Chromatic
npm install --save-dev chromatic

# 初始化（需要注册获取 project-token）
npx chromatic --project-token=YOUR_TOKEN
```

```json
// package.json
{
  "scripts": {
    "storybook": "storybook dev -p 6006",
    "build-storybook": "storybook build",
    "chromatic": "chromatic --exit-zero-on-changes"
  }
}
```

### 编写视觉测试 Stories

```typescript
// Button.stories.tsx
import type { Meta, StoryObj } from '@storybook/react';
import { Button } from './Button';

const meta: Meta<typeof Button> = {
  component: Button,
  title: 'Components/Button',
  // Chromatic 配置
  parameters: {
    chromatic: {
      // 延迟截图，等待动画完成
      delay: 300,
      // 指定视口
      viewports: [320, 768, 1280],
      // 忽略特定元素（如动态时间）
      ignoreSelectors: ['.timestamp'],
    },
  },
};

export default meta;
type Story = StoryObj<typeof Button>;

// 基础状态
export const Primary: Story = {
  args: {
    variant: 'primary',
    children: 'Click me',
  },
};

// 所有变体组合
export const AllVariants: Story = {
  render: () => (
    <div style={{ display: 'flex', gap: '10px' }}>
      <Button variant="primary">Primary</Button>
      <Button variant="secondary">Secondary</Button>
      <Button variant="danger">Danger</Button>
      <Button disabled>Disabled</Button>
    </div>
  ),
};

// 交互状态（hover、focus）
export const HoverState: Story = {
  args: { variant: 'primary', children: 'Hover me' },
  parameters: {
    pseudo: { hover: true },
  },
};

// 加载状态
export const Loading: Story = {
  args: {
    variant: 'primary',
    children: 'Loading',
    loading: true,
  },
};

// 长文本
export const LongText: Story = {
  args: {
    children: 'This is a very long button text that might wrap',
  },
};
```

### 交互测试（Interaction Tests）

```typescript
// Modal.stories.tsx
import { userEvent, within } from '@storybook/testing-library';
import { expect } from '@storybook/jest';

export const OpenAndClose: Story = {
  args: { triggerText: 'Open Modal' },
  play: async ({ canvasElement }) => {
    const canvas = within(canvasElement);
    
    // 打开 Modal
    await userEvent.click(canvas.getByText('Open Modal'));
    
    // 验证 Modal 内容显示
    expect(canvas.getByText('Modal Title')).toBeInTheDocument();
    
    // 关闭 Modal
    await userEvent.click(canvas.getByLabelText('Close'));
    
    // 验证 Modal 关闭
    expect(canvas.queryByText('Modal Title')).not.toBeInTheDocument();
  },
};
```

### CI 集成

```yaml
# .github/workflows/chromatic.yml
name: Chromatic

on: push

jobs:
  chromatic:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0  # Chromatic 需要完整 git 历史

      - name: Setup Node
        uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'

      - name: Install dependencies
        run: npm ci

      - name: Publish to Chromatic
        uses: chromaui/action@latest
        with:
          projectToken: ${{ secrets.CHROMATIC_PROJECT_TOKEN }}
          exitZeroOnChanges: true  # 视觉变化不阻塞 PR，但会标记
          exitOnceUploaded: true
```

---

## 2. Playwright 视觉回归测试

### 基础截图对比

```typescript
// tests/visual/button.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Button Visual', () => {
  test('primary button matches baseline', async ({ page }) => {
    await page.goto('/components/button');
    
    const button = page.locator('[data-testid="primary-button"]');
    
    // 截图对比
    await expect(button).toHaveScreenshot('primary-button.png', {
      // 允许的最大像素差异比例
      maxDiffPixelRatio: 0.02,
      // 或绝对像素数
      maxDiffPixels: 100,
      // 动画等待
      animations: 'disabled',
    });
  });

  test('button states', async ({ page }) => {
    await page.goto('/components/button');
    
    const button = page.locator('[data-testid="primary-button"]');
    
    // 默认状态
    await expect(button).toHaveScreenshot('button-default.png');
    
    // Hover 状态
    await button.hover();
    await expect(button).toHaveScreenshot('button-hover.png');
    
    // Focus 状态
    await button.focus();
    await expect(button).toHaveScreenshot('button-focus.png');
    
    // Active 状态
    await button.click();
    await expect(button).toHaveScreenshot('button-active.png');
  });
});
```

### 整页截图

```typescript
// tests/visual/pages.spec.ts
import { test, expect } from '@playwright/test';

test.describe('Page Visual', () => {
  test('homepage matches baseline', async ({ page }) => {
    await page.goto('/');
    
    // 等待关键元素加载
    await page.waitForSelector('[data-testid="hero-section"]');
    
    // 整页截图
    await expect(page).toHaveScreenshot('homepage.png', {
      fullPage: true,
      // 裁剪特定区域（可选）
      clip: { x: 0, y: 0, width: 1280, height: 800 },
    });
  });

  test('responsive breakpoints', async ({ page }) => {
    const breakpoints = [
      { name: 'mobile', width: 375, height: 667 },
      { name: 'tablet', width: 768, height: 1024 },
      { name: 'desktop', width: 1280, height: 720 },
      { name: 'wide', width: 1920, height: 1080 },
    ];

    for (const bp of breakpoints) {
      await page.setViewportSize({ width: bp.width, height: bp.height });
      await page.goto('/dashboard');
      
      await expect(page).toHaveScreenshot(`dashboard-${bp.name}.png`);
    }
  });
});
```

### 处理动态内容

```typescript
// tests/visual/dynamic.spec.ts
import { test, expect } from '@playwright/test';

test('page with dynamic content', async ({ page }) => {
  await page.goto('/feed');
  
  // 方法 1: 隐藏动态内容
  await page.addStyleTag({
    content: `
      .timestamp,
      .random-id,
      .user-avatar[src*="gravatar"] {
        visibility: hidden !important;
      }
    `
  });
  
  // 方法 2: Mock 动态数据
  await page.route('**/api/feed', async (route) => {
    await route.fulfill({
      json: {
        // 固定的测试数据
        posts: [
          { id: 'post-1', content: 'Fixed content', timestamp: '2024-01-01T00:00:00Z' },
        ]
      }
    });
  });
  
  // 方法 3: 使用 mask 遮盖特定区域
  await expect(page).toHaveScreenshot('feed.png', {
    mask: [
      page.locator('.timestamp'),
      page.locator('.random-id'),
    ],
  });
});
```

### 配置基线管理

```typescript
// playwright.config.ts
import { defineConfig, devices } from '@playwright/test';

export default defineConfig({
  testDir: './tests/visual',
  snapshotPathTemplate: '{testDir}/__snapshots__/{testFilePath}/{arg}{ext}',
  
  expect: {
    toHaveScreenshot: {
      // 全局默认配置
      maxDiffPixels: 50,
      threshold: 0.2,
      animations: 'disabled',
    },
  },
  
  projects: [
    {
      name: 'chromium',
      use: { 
        ...devices['Desktop Chrome'],
        viewport: { width: 1280, height: 720 },
      },
    },
    {
      name: 'firefox',
      use: { ...devices['Desktop Firefox'] },
    },
    {
      name: 'webkit',
      use: { ...devices['Desktop Safari'] },
    },
  ],
});
```

---

## 3. 视觉测试策略

### 测试金字塔（视觉版）

```
        ┌─────────────┐
        │  页面级 E2E  │  ← 关键用户旅程（少量）
       /   视觉测试    \
      /─────────────────\
     /    组件级视觉     \  ← 组件所有变体（中等）
    /      回归测试       \
   /───────────────────────\
  /      单元级快照          \  ← 纯渲染输出（大量）
 /        测试               \
└─────────────────────────────┘
```

### 测试范围决策树

```
需要测试视觉？
├─ 是 → 是组件还是页面？
│   ├─ 组件 → 使用 Storybook + Chromatic
│   │   ├─ 基础组件（Button/Input）→ 所有变体
│   │   └─ 复合组件（Card/Modal）→ 关键状态
│   └─ 页面 → 使用 Playwright 截图
│       ├─ 静态页面 → 整页截图
│       └─ 动态页面 → 关键区域 + Mock 数据
└─ 否 → 仅需功能测试
```

### 基线更新工作流

```bash
# 1. 本地开发时发现视觉差异
npm run test:visual

# 2. 审查差异报告
# - 预期内的变化 → 更新基线
# - 意外的回归 → 修复代码

# 3. 更新基线（有意为之的视觉变更）
npx playwright test --update-snapshots

# 4. 提交更新的基线
# - 基线应作为代码的一部分版本控制
# - PR 中包含视觉变更说明
```

---

## 4. 最佳实践

### DO ✅

- **组件隔离**: 使用 Storybook 隔离测试组件，避免页面级干扰
- **确定性数据**: 使用固定数据，避免随机内容导致误报
- **聚焦测试**: 一个测试验证一个视觉状态
- **跨浏览器**: 至少在 Chromium、Firefox、WebKit 中测试
- **响应式**: 测试关键断点（mobile、tablet、desktop）

### DON'T ❌

- **测试动态内容**: 时间、随机数、动画等不稳定内容
- **过度测试**: 不需要为每个像素测试，关注关键视觉元素
- **忽略基线更新**: 视觉变更是正常的，及时更新基线
- **仅依赖视觉**: 视觉测试补充而非替代功能测试

### 处理不稳定内容

```typescript
// 策略 1: 冻结时间
import { test } from '@playwright/test';

test.beforeEach(async ({ page }) => {
  await page.evaluate(() => {
    // 冻结 Date.now()
    Date.now = () => 1704067200000; // 2024-01-01 00:00:00
  });
});

// 策略 2: Mock Math.random()
test.beforeEach(async ({ page }) => {
  let seed = 1;
  await page.evaluate((s) => {
    Math.random = () => {
      s = (s * 9301 + 49297) % 233280;
      return s / 233280;
    };
  }, seed);
});

// 策略 3: 隐藏/遮盖
const maskSelectors = [
  '.timestamp',
  '.random-id', 
  '.ad-banner',  // 第三方广告
  '[data-testid="user-avatar"]',  // 外部图片
];
```

---

## 5. CI/CD 集成

### GitHub Actions 完整配置

```yaml
# .github/workflows/visual-tests.yml
name: Visual Tests

on:
  push:
    branches: [main]
  pull_request:

jobs:
  # 组件级视觉测试
  chromatic:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
        with:
          fetch-depth: 0
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - run: npm ci
      
      - name: Run Chromatic
        uses: chromaui/action@latest
        with:
          projectToken: ${{ secrets.CHROMATIC_PROJECT_TOKEN }}
          exitZeroOnChanges: true

  # 页面级视觉测试
  playwright-visual:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      
      - uses: actions/setup-node@v4
        with:
          node-version: '18'
          cache: 'npm'
      
      - run: npm ci
      
      - name: Install Playwright
        run: npx playwright install --with-deps
      
      - name: Build app
        run: npm run build
      
      - name: Start server
        run: npm start &
      
      - name: Wait for server
        run: npx wait-on http://localhost:3000
      
      - name: Run visual tests
        run: npx playwright test tests/visual/
      
      - name: Upload report
        if: failure()
        uses: actions/upload-artifact@v4
        with:
          name: visual-test-results
          path: |
            test-results/
            tests/visual/__snapshots__/
```

---

## 6. 故障排查

### 常见问题

| 问题 | 原因 | 解决方案 |
|------|------|----------|
| 字体渲染差异 | 系统字体不同 | 使用 web fonts 或指定字体 |
| 图片加载不稳定 | 外部 CDN | Mock 图片或使用本地资源 |
| 动画导致差异 | 截图时机不一致 | 禁用动画或等待动画完成 |
| 滚动条差异 | 操作系统差异 | 统一滚动条样式或隐藏 |
| 抗锯齿差异 | 浏览器渲染差异 | 增加阈值或使用相同浏览器 |

### 调试技巧

```bash
# 查看截图差异
npx playwright show-report

# 仅运行失败的测试
npx playwright test --last-failed

# 生成新基线（谨慎使用）
npx playwright test --update-snapshots

# 对比特定测试
npx playwright test button.spec.ts --debug
```

---

## 7. 视觉测试清单

- [ ] 组件所有视觉变体都有 Story
- [ ] 关键用户流程有页面级截图
- [ ] 响应式断点已覆盖
- [ ] 动态内容已处理（隐藏/Mock/遮盖）
- [ ] 跨浏览器测试已配置
- [ ] 基线已版本控制
- [ ] CI 中自动运行
- [ ] 团队有基线更新流程

---

**版本**: 1.0.0
**兼容**: Storybook 7.0+, Playwright 1.40+, Chromatic 10.0+

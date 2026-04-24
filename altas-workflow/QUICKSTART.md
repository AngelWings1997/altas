# ALTAS Workflow 快速启动

> 5 分钟上手 ALTAS Workflow — 融合 Spec-Driven Development、Checkpoint-Driven 与 Superpowers 的现代 AI 结对编程规范。

## 1. 最短上手

直接把任务写成命令发给 AI：

```text
[触发词]: [具体任务]
目标: [想达成的结果]
范围: [限制改哪里；不限制可省略]
限制: [不能改什么、必须兼容什么；可省略]
验证: [希望运行哪些测试/命令；可省略]
参考资料: [要先读的 Spec、日志、接口文档]
```

**示例：**

```text
>> 把 src/config.ts 中的 MAX_RETRIES 从 3 改为 5，并运行相关测试

FAST: 修复"删除用户后列表未刷新"的问题
目标: 删除成功后自动刷新列表，并显示成功提示
范围: 仅修改前端 admin 页面

sdd_bootstrap: task=新增发票下载接口, goal=支持用户下载 PDF 发票
范围: src/modules/invoice 和相关路由
限制: 沿用现有鉴权中间件

DEBUG: issue=支付成功但订单状态未更新
目标: 先给根因候选和排查路径，不要直接修改代码
参考资料: ./logs/payment-callback.log
```

## 2. 触发词速查

| 触发词 | 规模 | 什么时候用 |
|--------|------|-----------|
| `>>` | XS | 改一个常量、修 typo、改文案 |
| `FAST:` | S | 加参数校验、修小 bug、补小功能 |
| `sdd_bootstrap:` | M | 新增接口/模块、跨文件功能 |
| `DEEP:` | L | 架构重构、大范围迁移 |
| `MAP:` / `PROJECT MAP:` | - | 先理解代码，不改 |
| `DEBUG:` | - | 排查问题，先查原因再决定改不改 |
| `TEST:` | M/L | 补测试、测试报告、质量治理 |
| `MULTI:` / `CROSS:` | L | 前后端联动、跨仓库联调 |
| `REVIEW SPEC:` | - | 执行前审查 Spec/Plan |
| `REVIEW EXECUTE:` | - | 执行后三轴评审 |
| `PERF:` | M/L | 性能优化 |
| `MIGRATE:` | L | 技术迁移 |
| `ARCHIVE:` | - | 知识沉淀 |

> **不会选触发词？** 改一个点用 `>>`，小功能用 `FAST:`，正常开发用 `sdd_bootstrap:`，架构级用 `DEEP:`，先理解用 `MAP:`，排查用 `DEBUG:`。
> 完整别名见 `references/entry/aliases.md`。

## 3. 环境配置

### 安装

| 平台 | 安装方式 |
|------|----------|
| **Cursor / Trae** | 将 `SKILL.md` 内容复制到 `.cursorrules` 或全局 AI Rules |
| **Claude / OpenAI Agent** | 将 `SKILL.md` 内容作为 System Prompt 注入 |
| **Qoder** | 将 `SKILL.md` 放入项目 `.qoder/skills/` 目录 |

### 项目配置

在项目根目录创建 `mydocs/`：

```
mydocs/
├── codemap/       # 长期代码索引资产
├── context/       # 一次性需求整理
├── specs/         # 核心 Spec（组织记忆）
└── archive/       # 知识沉淀
```

### 测试框架

确保项目能一键运行测试：`npm test` / `pytest` / `go test`

## 4. 典型场景

### 场景一：日常功能 (M)

```text
sdd_bootstrap: task=为注册接口添加图形验证码, goal=安全性提升
范围: src/api/auth, src/services/auth
限制: 保持现有 Redis 方案
验证: 补充注册接口测试
参考资料: mydocs/specs/register-captcha.md
```

AI 流程：Research → Plan（等你批准）→ Execute(TDD) → Review

### 场景二：紧急修复 (XS)

```text
>> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5，并运行相关测试
```

AI 流程：直接修改 → 验证 → 1 行 summary

### 场景三：Bug 排查

```text
DEBUG: issue=审批通过后未获得授权
目标: 先定位根因候选，不要直接改代码
参考资料: ./logs/error.log, mydocs/specs/approval-flow.md
```

AI 流程：只读分析 → 输出根因候选 → 等你确认后再修复

### 场景四：测试补充

```text
TEST: 为 src/utils/validator.ts 补充单元测试，覆盖率目标 80%
范围: 仅补测试，不改现有业务行为
```

AI 流程：分析覆盖 → Test Strategy → 补测试 → 质量度量报告

## 5. 常见问题

**Q: AI 一次性输出太多代码怎么办？**
A: ALTAS 内置检查点机制。如果 AI 暴走，回复："请停止，严格执行检查点机制，每次只推进一步。"

**Q: 为什么 AI 总是先写测试？**
A: TDD 铁律。极简任务用 `>>` 跳过 TDD。

**Q: 如何中途干预计划？**
A: 在检查点回复 `[修改] 请不要使用 Redis，改为内存缓存`。

**Q: 如何选择规模？**
A: ALTAS 自动评估。也可强制指定：`>>`=XS, `FAST`=S, 默认=M, `DEEP`=L。

**Q: 参考资料 (references/) 每次都要全部读取吗？**
A: 不需要。ALTAS 采用渐进式披露，按需加载。

## 6. 规模评估速查

| 信号 | 推荐规模 | 触发词 |
|------|----------|--------|
| "改个 typo" | XS | `>>` |
| "这个接口加个参数" | S | `FAST:` |
| "新增一个 CRUD 接口" | M | `sdd_bootstrap:` |
| "重构这个模块" | M/L | `sdd_bootstrap:` 或 `DEEP:` |
| "架构级重构" | L | `DEEP:` |
| "前后端联动" | L (MULTI) | `MULTI:` |

# ALTAS Workflow 快速启动方案

## 1. 先用起来（如何使用）

如果你只想先用起来，不想先读原理，**直接复制下面的命令格式发给 AI 即可**。

### 1.1 最短上手：照着发

**你发给 AI 的内容，最好长这样：**

```text
[触发词]: [具体任务]
目标: [想达成的结果]
范围: [限制改哪里；不限制可省略]
限制: [不能改什么、必须兼容什么；可省略]
验证: [希望运行哪些测试/命令；可省略]
参考资料: [要先读的 Spec、日志、接口文档、原型、截图]
```

**30 秒内可直接上手的示例：**

```text
>> 把 src/config.ts 中的 MAX_RETRIES 从 3 改为 5，并运行相关测试或校验命令

FAST: 修复"删除用户后列表未刷新"的问题
目标: 删除成功后自动刷新列表，并显示成功提示
范围: 仅修改前端 admin 页面
限制: 不改后端接口；保持现有 React Query 方案

sdd_bootstrap: task=新增发票下载接口, goal=支持用户下载 PDF 发票
范围: src/modules/invoice 和相关路由
限制: 沿用现有鉴权中间件；不要修改支付模块数据结构
验证: 补充接口测试

DEBUG: issue=支付成功但订单状态未更新
目标: 先给根因候选和排查路径，不要直接修改代码
参考资料:
- ./logs/payment-callback.log
- mydocs/specs/order-lifecycle.md
- docs/payment-webhook.md

MAP: scope=src/modules/order
目标: 帮我梳理入口文件、核心服务、数据流和相关测试
```

**不会选触发词时，用这个判断：**
1. 改一个点、改动非常明确，用 `>>`
2. 小功能、小 bug、小范围增强，用 `FAST:`
3. 正常新增功能或跨多个文件实现，用 `sdd_bootstrap:`
4. 架构调整、大范围重构、迁移，用 `DEEP:`
5. 先理解代码，用 `MAP:` 或 `PROJECT MAP:`
6. 先排查问题，用 `DEBUG:`
7. 必须跨前后端或跨仓库一起改，用 `MULTI:` 或 `CROSS:`

欢迎使用 **ALTAS Workflow** — 融合 Spec-Driven Development、Checkpoint-Driven 与 Superpowers (TDD+Subagent) 的现代 AI 结对编程规范。

> `SKILL.md` 现在是 Bootstrap 入口，只负责路由、规模评估与门禁；详细规则请按需查看 `reference-index.md` 与 `references/`。

---

## 2. 如何使用（展开说明）

### 2.1 核心原则：直接把任务写成命令发给 AI

你不需要先解释工作流原理，先发命令即可。

**基本格式：**
```
[触发词]: [具体任务描述]
```

**最短上手路径：**
1. 判断任务大小，选一个触发词。
2. 把目标、范围、限制条件写清楚。
3. 如果有 Spec、日志、接口文档、原型图，在同一条消息中列出并明确要求 AI 先读。
4. AI 进入对应流程后，在检查点回复 `继续`、`批准`、`修改` 即可。

### 2.2 触发词速查与调用时机

| 触发词 | 规模 | 什么时候用 | 典型场景 |
|--------|------|-----------|----------|
| `>>` | XS | 改一个常量、修 typo、改文案、删文件 | 改配置、修文案、删废弃文件 |
| `FAST:` | S | 加参数校验、加分页、修定位明确的小问题 | 加验证、修小 bug、补小功能 |
| `sdd_bootstrap:` | M | 新增接口/模块、跨文件功能、需要完整流程 | 新增 CRUD、重构模块 |
| `DEEP:` | L | 架构重构、大范围迁移、跨模块改造 | 微服务拆分、数据库迁移 |
| `MAP:` / `PROJECT MAP:` | - | 刚接手项目、不确定入口在哪 | 了解项目结构 |
| `DEBUG:` | - | 线上报错、日志分析、性能异常 | 排查线上问题 |
| `MULTI:` / `CROSS:` | L | 前后端联动、跨仓库接口联调 | 多项目协作 |

### 2.2.1 测试工程师专用入口

如果你的主目标是**补现有系统测试、生成测试计划/报告、搭测试基座、做质量治理**，优先用 `TEST:`，不要硬翻译成 `FAST:` 或 `sdd_bootstrap:`。

**推荐直接这样发：**

```text
TEST: 基于 openapi.yaml 生成 pytest API 测试计划
参考资料:
- docs/openapi.yaml
```

```text
TEST: 补齐登录接口的鉴权 / 幂等 / 限流测试矩阵
参考资料:
- docs/auth-openapi.yaml
- mydocs/specs/login-security.md
```

```text
TEST: 为现有服务建立 fixture / factory 与 rollback 测试基座
范围: tests/
限制: 沿用 pytest；不要改生产代码
```

```text
TEST: 输出接口测试报告与质量门禁建议
目标: 给出 coverage、pass rate、flaky risk、slow tests、mock ratio、remaining gaps
参考资料:
- mydocs/test-plans/login-api-matrix.md
```

**什么时候用 `TEST`，什么时候走标准开发流程的 `Execute(TDD)`：**

- 用 `TEST:`：已有实现代码，当前目标是补测试、修测试、出测试报告、补测试骨架、做质量治理
- 走 `Execute(TDD)`：你正在开发新功能或修复产品 Bug，测试应服务于实现推进，而不是独立成为本轮主任务
- 如果任务同时包含“实现功能 + 补测试”，默认走 `sdd_bootstrap:` 或 `FAST:`，在执行阶段按 TDD 落地
- 如果任务核心是“先从契约/现状出发评估测试缺口”，默认走 `TEST:`

### 2.3 各触发词的详细使用指南

#### `>>`：极小改动，直接做

**什么时候用：** 任务一眼能看出改哪、改什么，预计改动不超过 5 行代码。

**你输入的命令示例：**
```text
>> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5，并运行相关测试或校验命令
>> 修改 README.md 中的安装步骤，补充 Node.js 18+ 要求
>> 将 package.json 中的 version 从 1.0.0 改为 1.1.0
>> 删除 src/utils/deprecated.ts 文件，并清理这个改动导致的无用引用
>> 在 .env.example 中添加 DATABASE_URL 和 REDIS_URL 示例值
>> 把 src/pages/Login.tsx 上"立即注册"按钮文案改成"创建账号"
>> 在 docs/api.md 的用户注册示例中补一个 curl 请求
>> 将 tsconfig.json 中的 target 从 "ES2019" 改为 "ES2020"
>> 在 src/constants/index.ts 中将 PAGE_SIZE 默认值从 10 改为 20
```

**AI 行为：**
1. 识别为 Size XS（极速）
2. 直接修改代码
3. 运行最小必要验证
4. 输出 1 行结果总结

#### `FAST:`：小任务，先给计划再做

**什么时候用：** 任务需要改几处代码、加一些逻辑，但不需要大规模重构，预计改动在 1~3 个文件内。

**你输入的命令示例：**
```text
FAST: 为用户登录接口添加登录失败次数限制，连续失败 5 次锁定账户 30 分钟；先给我 micro-spec，再执行
FAST: 给 src/api/user.ts 的 getUserById 函数添加参数校验，非法 ID 返回 400
FAST: 在 src/middleware/auth.ts 中增加 JWT 过期时间检查，并补充对应测试
FAST: 为订单查询接口添加 page 和 pageSize 参数，默认值分别是 1 和 20
FAST: 在用户注册时增加邮箱格式验证和重复邮箱校验
FAST: 修复"删除项目后列表未刷新"的问题，先说明根因再改
FAST: 为上传接口增加文件类型校验，只允许 jpg、png、pdf
FAST: 在 src/utils/format.ts 中添加金额格式化函数，支持千分位和小数点
FAST: 为 /api/products 接口添加按名称模糊搜索功能
FAST: 在用户个人中心增加修改密码功能，需验证旧密码
```

**AI 行为：**
1. 识别为 Size S（小任务）
2. 生成 micro-spec
3. 在检查点等你确认
4. 执行实现并验证
5. 回写总结

#### `sdd_bootstrap:`：标准开发，适合大多数新功能

**什么时候用：** 需要新增一个完整功能、接口或模块，涉及多个文件，需要明确 Research / Plan / Execute / Review 流程。

**你输入的命令示例：**
```text
sdd_bootstrap: task=为用户注册接口添加图形验证码防刷功能, goal=安全性提升
sdd_bootstrap: task=实现用户个人资料编辑功能, goal=支持头像上传、昵称和简介修改
sdd_bootstrap: task=为 API 添加限流能力, goal=每个用户每分钟最多 100 次请求
sdd_bootstrap: task=实现文件上传功能, goal=支持图片和 PDF，单文件最大 10MB
sdd_bootstrap: task=重构订单模块的状态流转逻辑, goal=减少重复判断并补齐测试
sdd_bootstrap: task=新增管理员审核后台接口, goal=支持列表、详情、审核通过与驳回
sdd_bootstrap: task=为支付回调增加幂等处理, goal=避免重复记账
sdd_bootstrap: task=实现购物车功能, goal=支持增删改查、数量调整和库存校验
sdd_bootstrap: task=新增消息通知模块, goal=支持站内信和邮件通知
sdd_bootstrap: task=实现数据导出功能, goal=支持 CSV 和 Excel 格式导出
```

**AI 行为：**
1. 自动评估规模，通常为 Size M
2. 先做 Research，理解现有实现和依赖
3. 输出 Plan 和 Checklist，等你批准
4. 进入 Execute，默认按 TDD 推进
5. 完成后做 Review

#### `DEEP:`：架构级任务，明确要求深度分析

**什么时候用：** 需要大规模重构、架构调整、数据库迁移、跨模块改造，需要多方案对比、风险识别、分阶段实施。

**你输入的命令示例：**
```text
DEEP: 重构认证模块拆分为独立微服务，支持 OAuth2.0 和 JWT 双模式
DEEP: 将单体应用拆分为用户服务、订单服务、商品服务三个微服务
DEEP: 重构数据访问层，从 MySQL 迁移到 PostgreSQL，并保留回滚方案
DEEP: 实现事件驱动架构，使用 Kafka 替代关键同步调用
DEEP: 重构前端架构，从 jQuery 迁移到 React，要求功能不变并分阶段上线
DEEP: 重构权限系统，从简单角色判断升级为 RBAC + 资源粒度权限
DEEP: 将现有 REST API 改造为 GraphQL，保留兼容性并分阶段迁移
DEEP: 重构日志系统，从本地文件日志迁移到 ELK 集中式日志平台
```

**AI 行为：**
1. 识别为 Size L（深度）
2. 生成 codemap，梳理现状和依赖
3. 给出多种方案和风险对比
4. 输出原子化计划与分阶段实施方案
5. 按 TDD + Review 推进

#### `DEBUG:`：先查原因，再决定改不改

**什么时候用：** 线上报错排查、日志分析、性能异常定位、用户反馈"偶发失败""数据不一致""接口超时"。

**你输入的命令示例：**
```text
DEBUG: log_path=./logs/error.log, issue=审批通过后未获得授权
DEBUG: log_path=/var/app/crash.log, issue=服务启动后 5 分钟内崩溃
DEBUG: error_message="Connection timeout", context=数据库连接池耗尽
DEBUG: user_report=支付成功但订单状态未更新, time_range=2026-04-16 14:00-16:00
DEBUG: log_path=./logs/performance.log, issue=接口响应时间超过 10 秒
DEBUG: scope=src/modules/order, issue=订单重复创建，帮我先定位根因不要直接修改
DEBUG: issue=用户上传头像后页面显示 500 错误，请优先分析 nginx 错误日志
DEBUG: scope=src/api/payment, issue=微信支付回调偶发失败，请分析日志和代码
```

**AI 行为：**
1. 进入 Debug 模式（默认只读分析）
2. 结合日志、代码、Spec 做根因定位
3. 输出症状、预期行为、根因候选、建议修复
4. 如需落地修复，再切换到 FAST 或 sdd_bootstrap

#### `MAP:` / `PROJECT MAP:`：先理解项目，再决定动手

**什么时候用：** 刚接手项目、不确定改动入口在哪、想先拿到模块结构和依赖关系。

**你输入的命令示例：**
```text
MAP: scope=src/api
MAP: scope=整个项目
MAP: scope=src/middleware
MAP: scope=认证模块
PROJECT MAP: scope=当前项目
PROJECT MAP: scope=monorepo 中的 web-console 和 api-service
MAP: scope=src/utils, 请列出所有函数和它们的依赖关系
MAP: scope=数据库模型层，请梳理表关系和关联字段
```

**AI 行为：**
1. 只读分析指定范围
2. 输出模块结构、依赖关系、关键入口
3. 不修改任何代码

#### `MULTI:` / `CROSS:`：允许跨项目协作

**什么时候用：** 前后端联动、跨仓库接口联调、一个任务必须同时改多个项目。

**你输入的命令示例：**
```text
MULTI: task=前后端联动实现用户个人主页功能
MULTI: task=统一前后端的错误码规范
MULTI: task=实现跨项目的用户认证 SSO
MULTI: task=发布功能联调，后端补接口，前端接入列表和详情页
CROSS: 允许同时修改前端和后端的 API 接口定义
MULTI: task=实现订单模块前后端联调，后端提供 REST API，前端实现列表和详情
MULTI: task=统一微服务间的鉴权机制，前端适配新的 Token 格式
```

**AI 行为：**
1. 自动扫描工作区并识别多个项目
2. 输出 Project Registry 等你确认
3. 按项目拆分计划与执行顺序
4. 记录接口契约和联动影响

### 2.4 如何把参考资料喂给 AI

ALTAS Workflow 会按场景自动读取 `references/` 下的资料，但**你自己的 Spec、日志、原型、外部文档路径，最好明确写出来**。最简单的原则是：**谁最重要，就写在同一条指令里，并明确要求"先读再做"。**

#### 方式 1：在命令后面直接跟参考资料

**何时用：** 你已经知道 AI 必须参考哪些文档，希望 AI 按指定 Spec 或工作流执行。

```text
sdd_bootstrap: task=实现用户权限管理, goal=支持 RBAC 模型
参考资料:
- mydocs/specs/auth-rbac.md
- references/superpowers/test-driven-development/SKILL.md
```

```text
FAST: 修复订单详情页金额显示错误
目标: 页面金额与后端返回值一致
范围: 仅修改前端展示层
参考资料:
- mydocs/specs/order-detail-page.md
- docs/order-api.yaml
```

#### 方式 2：明确要求"先读，再开始"

**何时用：** 资料比较关键，不能被 AI 忽略，你想强制先对齐上下文。

```text
请先阅读以下资料，不要直接开始实现：
- mydocs/specs/order-refund.md
- docs/refund-api.md

读完后执行：
FAST: 为退款接口增加重复提交保护
```

```text
请先阅读以下资料，并先给我 5 句话总结你的理解，不要直接改代码：
- mydocs/specs/login-security.md
- docs/auth-api.yaml
- screenshots/login-error.png

读完后执行：
FAST: 为登录接口增加连续失败锁定策略
目标: 连续失败 5 次锁定 30 分钟
```

#### 方式 3：把日志、报错、接口定义一起喂进去

**何时用：** Debug、联调、需要结合日志和接口协议分析。

```text
DEBUG: issue=导出报表时接口 500
请优先参考以下资料：
- ./logs/report-export.log
- docs/report-export-api.yaml
- mydocs/specs/report-center.md
输出根因候选后再等我确认，不要直接修改
```

```text
MULTI: task=联调发票下载功能
参考资料:
- ../api-service/docs/invoice-api.yaml
- ../web-console/src/pages/Invoice/README.md
- ./logs/invoice-download-error.log
要求: 先核对前后端字段是否一致，再给改动计划
```

#### 方式 4：明确"按哪份资料为准"

**何时用：** 有新旧文档并存、需求容易冲突。

```text
sdd_bootstrap: task=实现优惠券叠加规则, goal=支持满减券和折扣券组合使用
参考资料:
- mydocs/specs/coupon-rules-v2.md
- docs/legacy-coupon-design.md
要求: 如果两份资料冲突，以 mydocs/specs/coupon-rules-v2.md 为准
```

```text
FAST: 修复用户资料页手机号展示格式
参考资料:
- mydocs/specs/profile-display-v2.md
- docs/legacy-profile-page.md
要求: 如果设计稿和旧页面实现冲突，以 mydocs/specs/profile-display-v2.md 为准
```

#### 方式 5：不知道该喂什么时，先让 AI 帮你列单子

**何时用：** 你还没整理上下文、不确定 AI 需要哪些资料才能做对。

```text
我要做"订单超时自动取消"功能。开始前先告诉我应该补充哪些参考资料、日志、Spec 或接口文档，再等我提供。
```

```text
我要修"上传头像后偶发 500"的问题。先不要改代码，先告诉我你需要哪些日志、接口定义、页面路径、复现步骤和相关 Spec。
```

#### 推荐指令写法

下面这些句式最容易让 AI 按你的预期工作：

```text
请先阅读以下资料，再开始：
以 mydocs/specs/payment.md 为准，如果和旧文档冲突请指出：
先做只读分析，不要直接修改代码：
先输出计划和风险，再等我批准：
如果资料不足，先列出你还需要什么：
先给我一个最小可执行方案，不要过度设计：
先告诉我这个任务更适合用 FAST 还是 sdd_bootstrap，并说明原因：
```

#### 一组更清晰的喂资料写法

下面这些写法，通常比一句"你看一下这个文档"更有效：

```text
请先阅读 mydocs/specs/cart.md，再开始实现，不要跳过。
请同时参考 docs/cart-api.yaml 和 mydocs/specs/cart.md；如果冲突，以 mydocs/specs/cart.md 为准。
请优先看 ./logs/checkout-error.log，结合 src/modules/checkout 代码做只读分析。
请先根据 Figma 截图和接口文档判断问题是在前端展示层还是后端返回层。
如果你读完资料后发现信息不足，先列缺失项，不要直接猜测实现。
```

### 2.5 完整的指令模板

当你有一个任务时，按这个模板写指令通常最有效：

```text
[触发词]: [要做什么]
目标: [你想达到什么结果]
范围: [限制改哪些文件/模块；如果不限可省略]
限制: [不能改什么、必须兼容什么、技术约束]
验证: [希望跑哪些测试/命令；如果不确定可省略]
参考资料: [要先读的文档、Spec、日志、截图、接口定义]
```

**完整示例 1：修复问题**
```text
FAST: 修复用户删除后列表未刷新的问题
目标: 删除成功后列表自动刷新，并显示成功提示
范围: 仅修改前端 admin 页面，不改后端接口
限制: 保持现有 React Query 方案，不引入新状态库
验证: 运行相关单测和页面构建
参考资料: mydocs/specs/admin-user-list.md
```

**完整示例 2：新功能开发**
```text
sdd_bootstrap: task=新增发票下载接口, goal=支持用户下载 PDF 发票
范围: src/modules/invoice 和相关路由
限制: 沿用现有鉴权中间件；不要修改支付模块数据结构
验证: 补充接口测试
参考资料: mydocs/specs/billing.md
```

**完整示例 3：问题排查**
```text
DEBUG: issue=支付成功但订单状态未更新
目标: 先给根因候选和排查路径，不要直接修改代码
参考资料:
- ./logs/payment-callback.log
- mydocs/specs/order-lifecycle.md
- docs/payment-webhook.md
```

**完整示例 4：架构重构**
```text
DEEP: 重构商品搜索链路
目标: 将平均响应时间从 1.5s 降到 500ms 内
范围: 搜索接口、索引更新任务、缓存层
限制: 兼容当前 ES 索引结构；支持灰度发布和回滚
参考资料:
- docs/search-architecture.md
- mydocs/specs/search-performance-baseline.md
```

### 2.6 完整命令速查表

| 意图 | 命令 | 规模 | 流程 | 典型场景 |
|------|------|------|------|----------|
| **极速修改** | `>> [具体修改]` | XS | 直接执行→验证→summary | 改配置、修typo、改文案 |
| **小任务** | `FAST: [任务描述]` | S | micro-spec→批准→执行→回写 | 加参数、加校验、小功能 |
| **标准开发** | `sdd_bootstrap: task=[任务], goal=[目标]` | M | Research→Plan→Execute(TDD)→Review | 新增接口、重构模块 |
| **架构重构** | `DEEP: [架构改造描述]` | L | Research→Innovate→Plan→Execute(TDD)→Subagent→Review→Archive | 架构重构、微服务拆分 |
| **项目理解** | `MAP: scope=[范围]` | - | 只读分析，不改代码 | 了解项目结构 |
| **项目总图** | `PROJECT MAP: scope=[项目]` | - | 项目级架构地图 | 项目架构全景 |
| **排查Bug** | `DEBUG: [报错/日志路径]` | - | 系统化根因分析 | 生产问题排查 |
| **多项目** | `MULTI: task=[跨项目任务]` | L | 自动发现+作用域隔离 | 前后端联动 |
| **允许跨项目** | `CROSS: [任务描述]` | L | 显式允许跨项目改动 | 跨仓库修改 |
| **计划评审** | `REVIEW SPEC: [范围]` | - | 执行前审查 Spec/Plan | 计划审查 |
| **实现复盘** | `REVIEW EXECUTE: [范围]` | - | 执行后三轴评审 | 代码复盘 |
| **补测试** | `TEST: [目标]` | M/L | 测试现状分析→策略→补测→验证→报告 | 测试覆盖、测试报告、质量治理 |
| **性能优化** | `PERF: [目标]` | M/L | 基线→定位→优化→验证 | 性能调优 |
| **迁移任务** | `MIGRATE: [任务描述]` | L | 风险→回滚→预演→执行 | 技术迁移 |
| **归档沉淀** | `ARCHIVE: targets=[文件列表]` | - | 知识双视角沉淀 | 知识管理 |
| **退出协议** | `EXIT ALTAS` | - | 输出摘要后退出当前协议 | 结束任务 |

> **完整别名与 `MULTI` 模式控制词见 `references/entry/aliases.md`**

---

## 3. 环境配置

### 3.1 安装 Skill/Prompt

| 平台 | 安装方式 |
|------|----------|
| **Cursor / Trae** | 将 `SKILL.md` 内容复制到 `.cursorrules` 或全局 AI Rules |
| **Claude / OpenAI Agent** | 将 `SKILL.md` 内容作为 System Prompt 注入 |
| **Qoder** | 将 `SKILL.md` 放入项目 `.qoder/skills/` 目录 |

### 3.2 项目配置

在项目根目录创建 `mydocs/` 文件夹（AI也会在需要时自动创建）：

```
mydocs/
├── codemap/       # 长期代码索引资产
├── context/       # 一次性需求整理
├── specs/         # 核心Spec（组织记忆）
└── archive/       # 知识沉淀
```

### 3.3 测试框架

由于ALTAS强调TDD，确保项目能一键运行测试：`npm test` / `pytest` / `go test`

---

## 4. 典型使用场景（详细示例）

### 场景一：日常功能迭代 (Size M)

```
你输入:
sdd_bootstrap: task=为用户注册接口添加图形验证码防刷功能, goal=安全性提升
范围: src/api/auth, src/services/auth, src/routes
限制: 保持现有 Redis 方案，不改短信验证码流程
验证: 补充注册接口测试
参考资料:
- mydocs/specs/register-captcha.md
- docs/auth-api.yaml
- docs/security-baseline.md

AI行为:
1. 自动评估规模 → Size M (Standard)
2. Research → 读取现有注册接口，发现没有图形库依赖 → 输出检查点
3. Plan → 列出Checklist（引入库→改接口→加测试）→ 输出检查点等 [Approved]
4. Execute → TDD: 先写失败测试→实现逻辑→验证通过
5. Review → 三轴评审 → 确认通过
```

**实际对话示例：**

```
用户: sdd_bootstrap: task=为用户注册接口添加图形验证码防刷功能, goal=安全性提升
范围: src/api/auth, src/services/auth, src/routes
限制: 保持现有 Redis 方案，不改短信验证码流程
验证: 补充注册接口测试
参考资料:
- mydocs/specs/register-captcha.md
- docs/auth-api.yaml
- docs/security-baseline.md

AI: [Research阶段]
我已分析现有注册接口（src/api/auth/register.ts），发现：
- 当前无验证码机制
- 需要引入 svg-captcha 库
- 需要在 Redis 中存储验证码

检查点：是否继续进入 Plan 阶段？

用户: 继续

AI: [Plan阶段]
实施计划：
1. 安装 svg-captcha 和 Redis 客户端
2. 创建验证码生成接口 GET /api/captcha
3. 修改注册接口，添加验证码校验
4. 编写单元测试和集成测试

检查点：计划是否批准？

用户: 批准

AI: [Execute阶段 - TDD]
步骤1: 编写验证码生成测试...
步骤2: 实现验证码生成逻辑...
步骤3: 编写注册接口验证码校验测试...
步骤4: 实现校验逻辑...
所有测试通过 ✓

[Review阶段]
三轴评审：
- 功能完整性: ✓ 验证码生成、校验、过期清理
- 代码质量: ✓ 遵循项目规范，有完整测试
- 安全性: ✓ 验证码5分钟过期，防暴力破解

任务完成！
```

### 场景二：紧急修复线上配置 (Size XS)

```
你输入:
>> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5，并运行相关测试或校验命令

AI行为:
1. 识别为 Size XS (极速)
2. 直接修改代码→运行验证→1行summary
```

**实际对话示例：**

```
用户: >> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5，并运行相关测试或校验命令

AI: 已修改 src/config.ts: MAX_RETRIES = 5，验证通过 ✓
```

### 场景三：架构重构 (Size L)

```
你输入:
DEEP: 重构认证模块拆分为独立微服务
目标: 支持 OAuth2.0 和 JWT 双模式，并保留回滚路径
范围: auth-service, api-gateway, 用户登录链路
限制: 第一阶段不改前端登录页交互
参考资料:
- mydocs/specs/auth-service-split.md
- docs/current-auth-architecture.md
- docs/rollback-plan-template.md

AI行为:
1. 识别为 Size L (深度)
2. create_codemap → 生成认证模块代码索引
3. Research → 梳理现状链路，标识风险
4. Innovate → 给出3种方案（服务化/模块化/网关层）对比
5. Plan → 原子Checklist + Subagent分配
6. Execute → TDD驱动 + Subagent并行实现 + 两阶段Review
7. Review → 三轴评审 + Archive沉淀
```

### 场景四：Bug排查

```
你输入:
DEBUG: log_path=./logs/error.log, issue=审批通过后未获得授权
目标: 先定位根因候选，不要直接改代码
参考资料:
- mydocs/specs/approval-flow.md
- docs/permission-sync.md

AI行为:
1. 进入Debug模式（只读分析）
2. 读取日志+Spec+CodeMap → 三角定位
3. 输出: 症状/预期行为/根因候选/建议修复
4. 如需修复 → 进入RIPER流程或FAST
```

### 场景五：多项目协作

```
你输入:
MULTI: task=前后端联动发布功能
目标: 后端补发布接口，前端接入列表页和详情页
参考资料:
- ../api-service/docs/publish-api.yaml
- ../web-console/docs/publish-page.md
要求: 先输出 Project Registry 和联动顺序

AI行为:
1. 自动扫描workdir → 发现web-console + api-service
2. 输出Project Registry请确认
3. 生成双项目codemap
4. Plan按项目分组: api-service(Provider)→web-console(Consumer)
5. 执行按依赖顺序，记录Contract Interfaces
```

### 场景六：性能优化

```
你输入:
PERF: 优化首页加载速度，目标从3秒降到1秒以内
范围: 首屏请求、静态资源、关键渲染路径
参考资料:
- docs/perf-baseline-homepage.md
- ./logs/web-vitals-home.json

AI行为:
1. 建立基线 → 测量当前加载时间
2. 定位瓶颈 → 分析网络请求、资源大小、渲染性能
3. 优化方案 → 图片压缩、代码分割、缓存策略
4. 验证效果 → 确认达到目标
```

### 场景七：测试补充

```
你输入:
TEST: 为 src/utils/validator.ts 补充单元测试，覆盖率目标80%
范围: 仅补测试，不改现有业务行为
参考资料:
- mydocs/specs/input-validation.md
- docs/validator-edge-cases.md

AI行为:
1. 分析现有测试覆盖情况
2. 先输出结构化 Test Strategy（含 P0/P1/P2、测试数据与质量门禁）
3. 识别未覆盖的边界情况和关键路径
4. 编写测试用例
5. 输出 coverage、pass rate、remaining gaps 等质量度量
6. 验证覆盖率达到目标或明确剩余缺口
```

---

## 5. 常见问题 (FAQ)

**Q: AI一次性输出太多代码，跑完所有步骤怎么办？**

A: ALTAS内置检查点机制，AI完成一步后**必须**暂停等确认。如果AI暴走，回复："请停止，严格执行检查点机制，每次只推进一步。"

**Q: 为什么AI总是先写测试？太慢了。**

A: 这是Evidence First + TDD铁律。没有失败测试，AI生成的代码可能没被执行过。如果任务极简，用 `>>` 触发XS模式跳过TDD。

**Q: 如何中途干预AI的计划？**

A: 在任意检查点回复 `[修改] 请不要使用Redis，改为内存缓存`，AI会根据反馈调整Plan后重新请求Approve。

**Q: mydocs/下太多md文件，要提交Git吗？**

A: 强烈建议提交。Spec和Archive是项目的唯一真相源，防止上下文腐烂，帮助新人接手。

**Q: 如何选择XS/S/M/L？**

A: ALTAS会自动评估。你也可以强制指定：`>>`=XS, `FAST`=S, 默认=M, `DEEP`=L。执行中可随时 `[升级为M]` 或 `[降级为S]`。

**Q: 参考资料 (references/) 太多，AI每次都要全部读取吗？**

A: 不需要。ALTAS采用渐进式披露，只在命中场景时按需读取对应文件。SKILL.md中的参考索引表明确了每个文件的调用时机。

**Q: 多人团队如何协作？**

A: Spec是团队共享的真相源。每个人创建自己的Spec文件，通过Git协作。核心开发者只需Review Plan，不必Review全部代码。

**Q: 什么模型适合用ALTAS？**

A: 任何模型都能使用标准模式(M/L)。轻量模式(S/XS)特别适合强模型（Claude Opus/GPT-4+）高频多轮场景。新团队建议从标准模式开始。

---

## 6. 规模评估速查

| 信号 | 推荐规模 | 触发词 |
|------|----------|--------|
| "改个typo" | XS | `>>` |
| "加个配置项" | XS | `>>` |
| "改个按钮文案" | XS/S | `>>` 或 `FAST:` |
| "这个接口加个参数" | S | `FAST:` |
| "给这个函数加错误处理" | S | `FAST:` |
| "新增一个CRUD接口" | M | `sdd_bootstrap:` |
| "重构这个模块" | M/L | `sdd_bootstrap:` 或 `DEEP:` |
| "跨模块改数据模型" | L | `DEEP:` |
| "架构级重构" | L | `DEEP:` |
| "前后端联动" | L (MULTI) | `MULTI:` |

---

## 7. 从旧工作流迁移

| 旧工作流 | ALTAS对应 |
|----------|-----------|
| SDD-RIPER 标准模式 | Size M/L + `references/spec-driven-development/` |
| SDD-RIPER-ONE Light | Size S/M + `references/checkpoint-driven/` |
| Superpowers brainstorming | Size L Innovate阶段 + `references/superpowers/brainstorming/` |
| Superpowers TDD | Size M/L Execute阶段 + `references/superpowers/test-driven-development/` |
| Superpowers Debug | DEBUG模式 + `references/superpowers/systematic-debugging/` |
| Superpowers Subagent | Size L Execute阶段 + `references/superpowers/subagent-driven-development/` |

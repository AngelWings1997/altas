# ALTAS Workflow 快速启动方案

欢迎使用 **ALTAS Workflow** — 融合 Spec-Driven Development、Checkpoint-Driven 与 Superpowers (TDD+Subagent) 的现代 AI 结对编程规范。

> `SKILL.md` 现在是 Bootstrap 入口，只负责路由、规模评估与门禁；详细规则请按需查看 `reference-index.md` 与 `references/`。

---

## 1. 快速开始：如何使用

### 1.1 核心使用方法

ALTAS Workflow 通过**触发词**来启动不同的工作模式。你只需要在对话中输入特定格式的命令，AI 就会自动识别并执行相应流程。

**基本格式：**
```
[触发词]: [任务描述]
```

**触发词速查：**
- `>>` - 极速修改（XS）
- `FAST:` - 小任务（S）
- `sdd_bootstrap:` - 标准开发（M）
- `DEEP:` - 架构重构（L）
- `MAP:` - 项目理解
- `DEBUG:` - Bug排查
- `MULTI:` - 多项目协作

### 1.2 具体使用示例

#### 示例 1：极速修改（XS）- 最快速度

**场景：** 修改配置、改文案、修typo等极简任务

```
你输入:
>> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5

AI行为:
1. 识别为 Size XS (极速)
2. 直接修改代码 → 运行验证 → 1行summary
```

**更多示例：**
```
>> 修改 README.md 中的安装步骤，添加 Node.js 18+ 的要求
>> 将 package.json 中的 version 从 1.0.0 改为 1.1.0
>> 删除 src/utils/deprecated.ts 文件
>> 在 .env.example 中添加 DATABASE_URL 配置项
```

#### 示例 2：小任务（S）- 快速迭代

**场景：** 加参数、加错误处理、小功能等

```
你输入:
FAST: 为用户登录接口添加登录失败次数限制，超过5次锁定账户30分钟

AI行为:
1. 识别为 Size S (小任务)
2. 生成 micro-spec → 输出检查点等 [Approved]
3. 执行实现 → 验证通过 → 回写总结
```

**更多示例：**
```
FAST: 给 src/api/user.ts 的 getUserById 函数添加参数校验
FAST: 在 src/middleware/auth.ts 中添加 JWT 过期时间检查
FAST: 为订单查询接口添加分页参数 page 和 pageSize
FAST: 在用户注册时添加邮箱格式验证
```

#### 示例 3：标准开发（M）- 完整流程

**场景：** 新增CRUD接口、重构模块、跨文件功能等

```
你输入:
sdd_bootstrap: task=为用户注册接口添加图形验证码防刷功能, goal=安全性提升

AI行为:
1. 自动评估规模 → Size M (Standard)
2. Research → 读取现有注册接口，发现没有图形库依赖 → 输出检查点
3. Plan → 列出Checklist（引入库→改接口→加测试）→ 输出检查点等 [Approved]
4. Execute → TDD: 先写失败测试→实现逻辑→验证通过
5. Review → 三轴评审 → 确认通过
```

**更多示例：**
```
sdd_bootstrap: task=实现用户个人资料编辑功能, goal=支持头像上传、昵称和简介修改
sdd_bootstrap: task=重构订单模块，将订单状态管理从数据库迁移到Redis, goal=提升性能
sdd_bootstrap: task=为API添加限流功能，每用户每分钟最多100次请求, goal=防止滥用
sdd_bootstrap: task=实现文件上传功能，支持图片和PDF，最大10MB, goal=支持用户上传资料
```

#### 示例 4：架构重构（L）- 深度改造

**场景：** 架构级重构、跨模块改造、微服务拆分等

```
你输入:
DEEP: 重构认证模块拆分为独立微服务，支持OAuth2.0和JWT双模式

AI行为:
1. 识别为 Size L (深度)
2. create_codemap → 生成认证模块代码索引
3. Research → 梳理现状链路，标识风险
4. Innovate → 给出3种方案（服务化/模块化/网关层）对比
5. Plan → 原子Checklist + Subagent分配
6. Execute → TDD驱动 + Subagent并行实现 + 两阶段Review
7. Review → 三轴评审 + Archive沉淀
```

**更多示例：**
```
DEEP: 将单体应用拆分为用户服务、订单服务、商品服务三个微服务
DEEP: 重构数据访问层，从MySQL迁移到PostgreSQL，优化查询性能
DEEP: 实现事件驱动架构，使用Kafka替代同步调用，提升系统吞吐量
DEEP: 重构前端架构，从jQuery迁移到React，保持功能不变
```

#### 示例 5：Bug排查

**场景：** 生产环境问题排查、日志分析等

```
你输入:
DEBUG: log_path=./logs/error.log, issue=审批通过后未获得授权

AI行为:
1. 进入Debug模式（只读分析）
2. 读取日志+Spec+CodeMap → 三角定位
3. 输出: 症状/预期行为/根因候选/建议修复
4. 如需修复 → 进入RIPER流程或FAST
```

**更多示例：**
```
DEBUG: log_path=/var/app/crash.log, issue=服务启动后5分钟内崩溃
DEBUG: error_message="Connection timeout", context=数据库连接池耗尽
DEBUG: user_report=支付成功但订单状态未更新, time_range=2024-01-15 14:00-16:00
DEBUG: log_path=./logs/performance.log, issue=接口响应时间超过10秒
```

#### 示例 6：项目理解

**场景：** 快速了解项目结构、代码架构等

```
你输入:
MAP: scope=src/api

AI行为:
1. 只读分析 src/api 目录
2. 输出: 模块结构/依赖关系/关键文件/设计模式
3. 不修改任何代码
```

**更多示例：**
```
MAP: scope=整个项目
MAP: scope=src/middleware
MAP: scope=认证模块
PROJECT MAP: scope=当前项目
```

#### 示例 7：多项目协作

**场景：** 前后端联动、跨仓库修改等

```
你输入:
MULTI: task=前后端联动实现用户个人主页功能

AI行为:
1. 自动扫描workdir → 发现web-console + api-service
2. 输出Project Registry请确认
3. 生成双项目codemap
4. Plan按项目分组: api-service(Provider)→web-console(Consumer)
5. 执行按依赖顺序，记录Contract Interfaces
```

**更多示例：**
```
MULTI: task=统一前后端的错误码规范
MULTI: task=实现跨项目的用户认证SSO
CROSS: 允许同时修改前端和后端的API接口定义
```

### 1.3 如何喂给 AI 参考资料

ALTAS Workflow 支持**渐进式披露**，AI 会根据任务类型自动读取对应的参考资料。但如果你希望 AI 额外参考特定文档，可以明确指定：

#### 方式 1：在命令中指定参考文档

```
你输入:
sdd_bootstrap: task=实现用户权限管理, goal=支持RBAC模型
参考: references/superpowers/test-driven-development/tdd-workflow.md

AI行为:
1. 读取指定的 TDD 工作流文档
2. 按照 TDD 流程执行任务
```

#### 方式 2：要求 AI 读取特定参考资料

```
你输入:
请先阅读 references/superpowers/systematic-debugging/debug-workflow.md，
然后使用 DEBUG 模式排查问题: log_path=./logs/error.log, issue=内存泄漏
```

#### 方式 3：指定多个参考资料

```
你输入:
DEEP: 重构认证模块
参考资料:
- references/spec-driven-development/riper-workflow.md
- references/superpowers/subagent-driven-development/subagent-workflow.md
- mydocs/specs/auth-module-spec.md

AI行为:
1. 读取所有指定的参考资料
2. 综合多个工作流执行任务
```

#### 方式 4：让 AI 推荐参考资料

```
你输入:
我要实现一个复杂的缓存优化功能，应该参考哪些文档？

AI行为:
1. 分析任务特征
2. 推荐相关参考资料:
   - references/superpowers/test-driven-development/ (TDD流程)
   - references/spec-driven-development/ (Spec规范)
   - mydocs/specs/ (现有Spec)
```

### 1.4 完整命令速查表

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
| **补测试** | `TEST: [目标]` | M/L | 测试现状分析→补测→验证 | 测试覆盖 |
| **性能优化** | `PERF: [目标]` | M/L | 基线→定位→优化→验证 | 性能调优 |
| **迁移任务** | `MIGRATE: [任务描述]` | L | 风险→回滚→预演→执行 | 技术迁移 |
| **归档沉淀** | `ARCHIVE: targets=[文件列表]` | - | 知识双视角沉淀 | 知识管理 |
| **退出协议** | `EXIT ALTAS` | - | 输出摘要后退出当前协议 | 结束任务 |

> **完整别名与 `MULTI` 模式控制词见 `references/entry/aliases.md`**

---

## 2. 环境配置

### 2.1 安装 Skill/Prompt

| 平台 | 安装方式 |
|------|----------|
| **Cursor / Trae** | 将 `SKILL.md` 内容复制到 `.cursorrules` 或全局 AI Rules |
| **Claude / OpenAI Agent** | 将 `SKILL.md` 内容作为 System Prompt 注入 |
| **Qoder** | 将 `SKILL.md` 放入项目 `.qoder/skills/` 目录 |

### 2.2 项目配置

在项目根目录创建 `mydocs/` 文件夹（AI也会在需要时自动创建）：

```
mydocs/
├── codemap/       # 长期代码索引资产
├── context/       # 一次性需求整理
├── specs/         # 核心Spec（组织记忆）
├── micro_specs/   # 轻量Spec
└── archive/       # 知识沉淀
```

### 2.3 测试框架

由于ALTAS强调TDD，确保项目能一键运行测试：`npm test` / `pytest` / `go test`

---

## 3. 典型使用场景（详细示例）

### 场景一：日常功能迭代 (Size M)

```
你输入:
sdd_bootstrap: task=为用户注册接口添加图形验证码防刷功能, goal=安全性提升

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
>> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5

AI行为:
1. 识别为 Size XS (极速)
2. 直接修改代码→运行验证→1行summary
```

**实际对话示例：**

```
用户: >> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5

AI: 已修改 src/config.ts: MAX_RETRIES = 5，验证通过 ✓
```

### 场景三：架构重构 (Size L)

```
你输入:
DEEP: 重构认证模块拆分为独立微服务

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

AI行为:
1. 分析现有测试覆盖情况
2. 识别未覆盖的边界情况
3. 编写测试用例
4. 验证覆盖率达到目标
```

---

## 4. 常见问题 (FAQ)

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

## 5. 规模评估速查

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

## 6. 从旧工作流迁移

| 旧工作流 | ALTAS对应 |
|----------|-----------|
| SDD-RIPER 标准模式 | Size M/L + `references/spec-driven-development/` |
| SDD-RIPER-ONE Light | Size S/M + `references/checkpoint-driven/` |
| Superpowers brainstorming | Size L Innovate阶段 + `references/superpowers/brainstorming/` |
| Superpowers TDD | Size M/L Execute阶段 + `references/superpowers/test-driven-development/` |
| Superpowers Debug | DEBUG模式 + `references/superpowers/systematic-debugging/` |
| Superpowers Subagent | Size L Execute阶段 + `references/superpowers/subagent-driven-development/` |

# ALTAS Workflow 快速启动方案

欢迎使用 **ALTAS Workflow** — 融合 Spec-Driven Development、Checkpoint-Driven 与 Superpowers (TDD+Subagent) 的现代 AI 结对编程规范。

---

## 1. 环境配置

### 安装 Skill/Prompt

| 平台 | 安装方式 |
|------|----------|
| **Cursor / Trae** | 将 `SKILL.md` 内容复制到 `.cursorrules` 或全局 AI Rules |
| **Claude / OpenAI Agent** | 将 `SKILL.md` 内容作为 System Prompt 注入 |
| **Qoder** | 将 `SKILL.md` 放入项目 `.qoder/skills/` 目录 |

### 项目配置

在项目根目录创建 `mydocs/` 文件夹（AI也会在需要时自动创建）：

```
mydocs/
├── codemap/       # 长期代码索引资产
├── context/       # 一次性需求整理
├── specs/         # 核心Spec（组织记忆）
├── micro_specs/   # 轻量Spec
└── archive/       # 知识沉淀
```

### 测试框架

由于ALTAS强调TDD，确保项目能一键运行测试：`npm test` / `pytest` / `go test`

---

## 2. 一键执行命令

| 意图 | 命令 | 规模 | 流程 |
|------|------|------|------|
| **极速修改** | `>> 修复 [文件] 中 [内容]` | XS | 直接执行→验证→summary |
| **小任务** | `FAST: [任务描述]` | S | micro-spec→批准→执行→回写 |
| **标准开发** | `sdd_bootstrap: task=[任务], goal=[目标]` | M | Research→Plan→Execute(TDD)→Review |
| **架构重构** | `DEEP: [架构改造描述]` | L | Research→Innovate→Plan→Execute(TDD)→Subagent→Review→Archive |
| **项目理解** | `MAP: scope=[范围]` | - | 只读分析，不改代码 |
| **项目总图** | `PROJECT MAP: scope=[项目]` | - | 项目级架构地图 |
| **排查Bug** | `DEBUG: [报错/日志路径]` | - | 系统化根因分析 |
| **多项目** | `MULTI: task=[跨项目任务]` | L | 自动发现+作用域隔离 |
| **归档沉淀** | `ARCHIVE: targets=[文件列表]` | - | 知识双视角沉淀 |

---

## 3. 典型使用场景

### 场景一：日常功能迭代 (Size M)

```
你输入: sdd_bootstrap: task=为用户注册接口添加图形验证码防刷功能, goal=安全性提升

AI行为:
1. 自动评估规模 → Size M (Standard)
2. Research → 读取现有注册接口，发现没有图形库依赖 → 输出检查点
3. Plan → 列出Checklist（引入库→改接口→加测试）→ 输出检查点等 [Approved]
4. Execute → TDD: 先写失败测试→实现逻辑→验证通过
5. Review → 三轴评审 → 确认通过
```

### 场景二：紧急修复线上配置 (Size XS)

```
你输入: >> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5

AI行为:
1. 识别为 Size XS (极速)
2. 直接修改代码→运行验证→1行summary
```

### 场景三：架构重构 (Size L)

```
你输入: DEEP: 重构认证模块拆分为独立微服务

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
你输入: DEBUG: log_path=./logs/error.log, issue=审批通过后未获得授权

AI行为:
1. 进入Debug模式（只读分析）
2. 读取日志+Spec+CodeMap → 三角定位
3. 输出: 症状/预期行为/根因候选/建议修复
4. 如需修复 → 进入RIPER流程或FAST
```

### 场景五：多项目协作

```
你输入: MULTI: task=前后端联动发布功能

AI行为:
1. 自动扫描workdir → 发现web-console + api-service
2. 输出Project Registry请确认
3. 生成双项目codemap
4. Plan按项目分组: api-service(Provider)→web-console(Consumer)
5. 执行按依赖顺序，记录Contract Interfaces
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

| 信号 | 推荐规模 |
|------|----------|
| "改个typo" | XS |
| "加个配置项" | XS |
| "改个按钮文案" | XS/S |
| "这个接口加个参数" | S |
| "给这个函数加错误处理" | S |
| "新增一个CRUD接口" | M |
| "重构这个模块" | M/L |
| "跨模块改数据模型" | L |
| "架构级重构" | L |
| "前后端联动" | L (MULTI) |

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

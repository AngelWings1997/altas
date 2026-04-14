# ALTAS Workflow

> **融合三方优势 | 智能深度适配 | 渐进式披露 | 每步可反馈**

ALTAS Workflow 是一套汲取了 SDD-RIPER、SDD-RIPER-Optimized 与 Superpowers 精华的综合性 AI 工作流程规范。本规范致力于解决 AI 编程中的**上下文腐烂**、**审查瘫痪**、**代码不信任**和**难以维护**等四大工程痛点。

---

## 核心特性

### 1. 项目规模智能评估

告别"杀鸡用牛刀"或"大意失荆州"。ALTAS 根据复杂度、影响面、决策点自动选择适配的工作流深度：

| 规模 | Spec要求 | 工作流 |
|------|----------|--------|
| **XS 极速** | 跳过，事后1行summary | 直接执行→验证→summary |
| **S 快速** | micro-spec (1-3句) | micro-spec→批准→执行→回写 |
| **M 标准** | 轻量Spec落盘 | Research→Plan→Execute(TDD)→Review |
| **L 深度** | 完整Spec+Innovate+Archive | Research→Innovate→Plan→Execute(TDD)→Subagent→Review→Archive |

### 2. 流程进度可视化

每步完成后输出标准化检查点：
- 进度条展示当前阶段
- 当前成果 + 预期产出
- 结构化下一步操作指引（`[继续]`/`[修改]`/`[升级]`/`[降级]`）

### 3. 渐进式披露

- Research只谈逻辑约束，Plan只谈接口签名与Checklist，Execute才写代码
- 复杂细节写入磁盘Spec，对话中只呈现摘要和高危风险
- 参考文档按需加载，不常驻上下文

### 4. 快速启动

5分钟武装你的AI Agent。详见 [QUICKSTART.md](./QUICKSTART.md)

---

## 架构支柱

1. **Spec is Truth**: 代码是消耗品，Spec才是资产
2. **No Approval, No Execute**: 审代码前置为审计划
3. **Evidence First**: 完成由验证结果证明，非模型自宣布
4. **No Fixes Without Root Cause**: 系统化调试，禁止盲改
5. **TDD Iron Law**: M/L规模先写失败测试再写生产代码
6. **Reverse Sync**: Bug先修Spec再修代码

---

## 来源整合

| 来源 | 采纳的核心优势 |
|------|---------------|
| **SDD-RIPER** | Spec中心论、RIPER状态机、三轴Review、Multi-Project自动发现、Debug/Archive协议 |
| **SDD-RIPER-Optimized** | Checkpoint-Driven轻量模式、4级任务深度(zero/fast/standard/deep)、Done Contract、Resume Ready、Hot/Warm/Cold上下文装配 |
| **Superpowers** | TDD铁律与反模式、系统化Debug四阶段法、Subagent驱动+两阶段Review、并行Agent派遣、验证优先铁律、Rationalization预防表 |

---

## 目录导航

- [SKILL.md](./SKILL.md) - 核心系统提示词（供AI读取）
- [QUICKSTART.md](./QUICKSTART.md) - 快速启动命令与典型场景
- [references/](./references/) - 按需加载的参考资料
  - [spec-driven-development/](./references/spec-driven-development/) - SDD-RIPER 完整协议与模板
  - [checkpoint-driven/](./references/checkpoint-driven/) - Checkpoint 轻量模式模块
  - [superpowers/](./references/superpowers/) - TDD/Debug/Subagent 技能
- [protocols/](./protocols/) - 专用协议（严格模式、双模型协作等）
- [docs/](./docs/) - 方法论文档
- [references/agents/](./references/agents/) - Agent 定义（SDD-RIPER 标准版/轻量版/代码审查）
- [scripts/](./scripts/) - 自动化工具

---

## 参考资料按需调用指南

| 场景 | 读取文件 | 调用时机 |
|------|----------|----------|
| 写Spec (M/L) | `references/spec-driven-development/spec-template.md` | 进入Research时 |
| 写Spec (S) | `references/checkpoint-driven/spec-lite-template.md` | 小任务建立Spec时 |
| 查看命令详情 | `references/spec-driven-development/commands.md` | 需要命令参数时 |
| 快速参考 | `references/spec-driven-development/workflow-quickref.md` | 忘记流程时 |
| 使用示例 | `references/spec-driven-development/usage-examples.md` | 不确定如何操作时 |
| 多项目协作 | `references/spec-driven-development/multi-project.md` | MULTI模式时 |
| Archive模板 | `references/spec-driven-development/archive-template.md` | 进入Archive时 |
| 完整协议 | `references/spec-driven-development/sdd-riper-one-protocol.md` | 需要完整流程定义时 |
| Deep Planning等 | `references/checkpoint-driven/modules.md` | 命中deep/debug/review/multi场景时 |
| 命名约定 | `references/checkpoint-driven/conventions.md` | 需要落盘Spec时 |
| 设计头脑风暴 | `references/superpowers/brainstorming/SKILL.md` | Innovate阶段时 |
| 写Plan | `references/superpowers/writing-plans/SKILL.md` | Plan阶段时 |
| TDD | `references/superpowers/test-driven-development/SKILL.md` | M/L Execute阶段时 |
| 测试反模式 | `references/superpowers/test-driven-development/testing-anti-patterns.md` | TDD执行时 |
| 系统化Debug | `references/superpowers/systematic-debugging/SKILL.md` | DEBUG模式时 |
| 根因追踪 | `references/superpowers/systematic-debugging/root-cause-tracing.md` | 根因不明时 |
| 纵深防御 | `references/superpowers/systematic-debugging/defense-in-depth.md` | 需要多层防护时 |
| 条件等待 | `references/superpowers/systematic-debugging/condition-based-waiting.md` | 异步/等待问题时 |
| Subagent驱动 | `references/superpowers/subagent-driven-development/SKILL.md` | L规模执行时 |
| Subagent实现者 | `references/superpowers/subagent-driven-development/implementer-prompt.md` | 派遣实现者时 |
| Subagent Spec审查 | `references/superpowers/subagent-driven-development/spec-reviewer-prompt.md` | Subagent Spec审查时 |
| Subagent代码审查 | `references/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md` | Subagent代码审查时 |
| 并行Agent | `references/superpowers/dispatching-parallel-agents/SKILL.md` | 多独立故障时 |
| 完成前验证 | `references/superpowers/verification-before-completion/SKILL.md` | 完成前验证时 |
| 完成分支 | `references/superpowers/finishing-a-development-branch/SKILL.md` | 实现完成后 |
| Plan文档审查 | `references/superpowers/writing-plans/plan-document-reviewer-prompt.md` | Plan审查时 |
| 视觉设计辅助 | `references/superpowers/brainstorming/visual-companion.md` | 设计需可视化时 |
| Spec文档审查 | `references/superpowers/brainstorming/spec-document-reviewer-prompt.md` | 设计Spec审查时 |
| 执行Plan (非Subagent) | `references/superpowers/executing-plans/SKILL.md` | 无Subagent支持时 |
| 请求代码审查 | `references/superpowers/requesting-code-review/SKILL.md` | 请求审查时 |
| 代码审查模板 | `references/superpowers/requesting-code-review/code-reviewer.md` | 派遣审查Agent时 |
| 接收代码审查 | `references/superpowers/receiving-code-review/SKILL.md` | 收到审查反馈时 |
| Git Worktree | `references/superpowers/using-git-worktrees/SKILL.md` | 并行开发隔离时 |
| Superpowers总纲 | `references/superpowers/using-superpowers/SKILL.md` | 检查Skill适用性时 |
| 编写Skill | `references/superpowers/writing-skills/SKILL.md` | 创建新Skill时 |
| Skill 说服原则 | `references/superpowers/writing-skills/persuasion-principles.md` | 优化 Skill 效果时 |
| Skill 测试方法 | `references/superpowers/writing-skills/testing-skills-with-subagents.md` | 验证 Skill 有效性时 |
| 严格模式协议 | `protocols/RIPER-5.md` | 高风险代码修改时 |
| 双模型协作 | `protocols/SDD-RIPER-DUAL-COOP.md` | 双模型环境时 |
| 文档专家 | `protocols/RIPER-DOC.md` | DOC模式时 |
| Agent: 代码审查者 | `references/agents/code-reviewer.md` | 派遣审查Agent时 |
| 脚本: Archive构建器 | `scripts/archive_builder.py` | 自动化归档时 |
| Skill: 标准版 | `altas-workflow/references/agents/sdd-riper-one/SKILL.md` | 使用完整RIPER协议时 |
| Skill: 轻量版 | `altas-workflow/references/agents/sdd-riper-one-light/SKILL.md` | 使用Checkpoint模式时 |
| 方法论: 从传统到大模型 | `docs/从传统编程转向大模型编程.md` | 理解范式转换时 |
| 方法论: 团队落地指南 | `docs/团队落地指南.md` | 团队推广时 |
| 方法论: 手把手教程 | `docs/如何快速从零开始落地大模型编程 -- 手把手教程.md` | 入门学习时 |
| 方法论: AI原生研发范式 | `docs/AI-原生研发范式-从代码中心到文档驱动的演进.md` | 深入理解理论时 |

---

*Powered by the integration of SDD-RIPER, SDD-RIPER-Optimized (Checkpoint-Driven), and Superpowers.*

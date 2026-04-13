# ALTAS Workflow 参考资料总索引

> 本文件是 ALTAS Workflow 所有参考资料的统一发现入口。
> AI Agent 无需常驻全部内容，只需在命中场景时按需加载对应文件。

---

## 按工作流阶段索引

### PRE-RESEARCH / 输入准备

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/spec-driven-development/commands.md` | SDD-RIPER | 需要create_codemap/build_context_bundle/sdd_bootstrap命令参数时 |
| `references/spec-driven-development/sdd-riper-one-protocol.md` | SDD-RIPER | 需要完整协议定义时 |
| `references/spec-driven-development/workflow-quickref.md` | SDD-RIPER | 忘记流程快速查阅时 |

### RESEARCH / 研究对齐

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/spec-driven-development/spec-template.md` | SDD-RIPER | 写Spec (Size M/L) 时 |
| `references/checkpoint-driven/spec-lite-template.md` | SDD-RIPER-Opt | 写Spec (Size S) 时 |
| `references/checkpoint-driven/conventions.md` | SDD-RIPER-Opt | 需要落盘命名约定时 |

### INNOVATE / 方案对比

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/superpowers/brainstorming/SKILL.md` | Superpowers | Innovate阶段设计流程时 |
| `references/superpowers/brainstorming/visual-companion.md` | Superpowers | 设计需可视化展示时 |
| `references/superpowers/brainstorming/spec-document-reviewer-prompt.md` | Superpowers | 审查设计Spec时 |

### PLAN / 详细规划

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/superpowers/writing-plans/SKILL.md` | Superpowers | 写Plan拆解任务时 |
| `references/superpowers/writing-plans/plan-document-reviewer-prompt.md` | Superpowers | Plan文档审查时 |

### EXECUTE / 执行实现

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/superpowers/test-driven-development/SKILL.md` | Superpowers | M/L规模TDD执行时 |
| `references/superpowers/test-driven-development/testing-anti-patterns.md` | Superpowers | 避免测试反模式时 |
| `references/superpowers/subagent-driven-development/SKILL.md` | Superpowers | L规模Subagent驱动时 |
| `references/superpowers/subagent-driven-development/implementer-prompt.md` | Superpowers | 派遣实现者Subagent时 |
| `references/superpowers/subagent-driven-development/spec-reviewer-prompt.md` | Superpowers | Subagent Spec合规审查时 |
| `references/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md` | Superpowers | Subagent代码质量审查时 |
| `references/superpowers/dispatching-parallel-agents/SKILL.md` | Superpowers | 多独立故障并行派遣时 |
| `references/superpowers/executing-plans/SKILL.md` | Superpowers | 无Subagent支持时执行Plan |
| `references/superpowers/using-git-worktrees/SKILL.md` | Superpowers | 需要隔离工作空间时 |

### REVIEW / 审查

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/checkpoint-driven/modules.md` | SDD-RIPER-Opt | 进入Review时 (含Deep/Debug/Review/Multi模块) |
| `references/superpowers/verification-before-completion/SKILL.md` | Superpowers | 完成前验证时 |
| `references/superpowers/requesting-code-review/SKILL.md` | Superpowers | 请求代码审查时 |
| `references/superpowers/requesting-code-review/code-reviewer.md` | Superpowers | 派遣审查Agent模板 |
| `references/superpowers/receiving-code-review/SKILL.md` | Superpowers | 收到审查反馈时 |

### ARCHIVE / 知识沉淀

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/spec-driven-development/archive-template.md` | SDD-RIPER | 进入Archive时 |
| `scripts/archive_builder.py` | SDD-RIPER-Opt | 自动化归档生成时 |
| `references/superpowers/finishing-a-development-branch/SKILL.md` | Superpowers | 完成分支决策时 |

---

## 按特殊模式索引

### DEBUG 模式

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/superpowers/systematic-debugging/SKILL.md` | Superpowers | 进入Debug模式时 |
| `references/superpowers/systematic-debugging/root-cause-tracing.md` | Superpowers | 根因不明需追溯时 |
| `references/superpowers/systematic-debugging/defense-in-depth.md` | Superpowers | 需要多层防御时 |
| `references/superpowers/systematic-debugging/condition-based-waiting.md` | Superpowers | 异步/条件等待问题时 |

### MULTI 模式

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `references/spec-driven-development/multi-project.md` | SDD-RIPER | 多项目协作时 |
| `references/checkpoint-driven/modules.md` (Multi-project模块) | SDD-RIPER-Opt | 多项目场景时 |

### DOC 模式

| 文件 | 来源 | 调用时机 |
|------|------|----------|
| `protocols/RIPER-DOC.md` | SDD-RIPER | 文档撰写模式时 |

---

## 按来源分类索引

### SDD-RIPER (Spec-Driven Development)

| 文件 | 主题 |
|------|------|
| `references/spec-driven-development/sdd-riper-one-protocol.md` | 完整RIPER协议 (696行) |
| `references/spec-driven-development/spec-template.md` | Spec模板 (单项目+多项目) |
| `references/spec-driven-development/commands.md` | 7个原生命令详细参数 |
| `references/spec-driven-development/workflow-quickref.md` | 快速参考卡 |
| `references/spec-driven-development/usage-examples.md` | 使用示例 (含多项目/Debug/Archive) |
| `references/spec-driven-development/multi-project.md` | 多项目协作规则 |
| `references/spec-driven-development/archive-template.md` | Archive输出模板 |
| `protocols/RIPER-5.md` | 严格模式协议 |
| `protocols/RIPER-DOC.md` | 文档专家协议 |
| `protocols/SDD-RIPER-DUAL-COOP.md` | 双模型协作协议 |
| `docs/从传统编程转向大模型编程.md` | 方法论: 范式转换 |
| `docs/团队落地指南.md` | 方法论: 团队推广 |
| `docs/如何快速从零开始落地大模型编程 -- 手把手教程.md` | 方法论: 入门教程 |
| `docs/AI-原生研发范式-从代码中心到文档驱动的演进.md` | 方法论: 理论深化 |

### SDD-RIPER-Optimized (Checkpoint-Driven)

| 文件 | 主题 |
|------|------|
| `references/checkpoint-driven/SKILL.md` | 轻量Skill定义 |
| `references/checkpoint-driven/spec-lite-template.md` | 最小Spec模板 |
| `references/checkpoint-driven/modules.md` | 按需模块 (Deep/Debug/Review/Multi) |
| `references/checkpoint-driven/conventions.md` | 命名与目录约定 |
| `altas-workflow/references/agents/sdd-riper-one/SKILL.md` | 标准版 Skill |
| `altas-workflow/references/agents/sdd-riper-one-light/SKILL.md` | 轻量版 Skill |

### Superpowers

| 文件 | 主题 |
|------|------|
| `references/superpowers/brainstorming/SKILL.md` | 设计头脑风暴 |
| `references/superpowers/brainstorming/visual-companion.md` | 视觉设计辅助 |
| `references/superpowers/brainstorming/spec-document-reviewer-prompt.md` | 设计Spec审查 |
| `references/superpowers/writing-plans/SKILL.md` | 写Plan最佳实践 |
| `references/superpowers/writing-plans/plan-document-reviewer-prompt.md` | Plan文档审查 |
| `references/superpowers/executing-plans/SKILL.md` | 执行Plan (非Subagent) |
| `references/superpowers/test-driven-development/SKILL.md` | TDD铁律 |
| `references/superpowers/test-driven-development/testing-anti-patterns.md` | 测试反模式 |
| `references/superpowers/systematic-debugging/SKILL.md` | 系统化Debug四阶段 |
| `references/superpowers/systematic-debugging/root-cause-tracing.md` | 根因追踪 |
| `references/superpowers/systematic-debugging/defense-in-depth.md` | 纵深防御 |
| `references/superpowers/systematic-debugging/condition-based-waiting.md` | 条件等待 |
| `references/superpowers/subagent-driven-development/SKILL.md` | Subagent驱动开发 |
| `references/superpowers/subagent-driven-development/implementer-prompt.md` | 实现者提示 |
| `references/superpowers/subagent-driven-development/spec-reviewer-prompt.md` | Spec审查提示 |
| `references/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md` | 代码质量审查提示 |
| `references/superpowers/dispatching-parallel-agents/SKILL.md` | 并行Agent派遣 |
| `references/superpowers/verification-before-completion/SKILL.md` | 完成前验证 |
| `references/superpowers/finishing-a-development-branch/SKILL.md` | 完成分支 |
| `references/superpowers/requesting-code-review/SKILL.md` | 请求代码审查 |
| `references/superpowers/requesting-code-review/code-reviewer.md` | 审查Agent模板 |
| `references/superpowers/receiving-code-review/SKILL.md` | 接收代码审查 |
| `references/superpowers/using-git-worktrees/SKILL.md` | Git Worktree管理 |
| `references/superpowers/using-superpowers/SKILL.md` | Superpowers使用总纲 |
| `references/superpowers/writing-skills/SKILL.md` | 编写Skill |
| `references/superpowers/writing-skills/persuasion-principles.md` | Skill说服原则 |
| `references/superpowers/writing-skills/testing-skills-with-subagents.md` | Skill测试方法 |
| `references/agents/code-reviewer.md` | 代码审查Agent定义 |
---

## 按规模等级索引

### Size XS — 无需加载任何参考

### Size S — 按需加载

- `references/checkpoint-driven/spec-lite-template.md`
- `references/checkpoint-driven/conventions.md`

### Size M — 标准加载

- `references/spec-driven-development/spec-template.md`
- `references/spec-driven-development/commands.md`
- `references/superpowers/writing-plans/SKILL.md`
- `references/superpowers/test-driven-development/SKILL.md`
- `references/superpowers/verification-before-completion/SKILL.md`
- `references/checkpoint-driven/modules.md` (Review模块)

### Size L — 完整加载

- 全部 M 规模文件（包含TDD），加上:
- `references/superpowers/brainstorming/SKILL.md`
- `references/superpowers/subagent-driven-development/SKILL.md`
- `references/superpowers/dispatching-parallel-agents/SKILL.md`
- `references/spec-driven-development/multi-project.md`
- `references/spec-driven-development/archive-template.md`
- `references/superpowers/finishing-a-development-branch/SKILL.md`

---

## 统计

- **参考文件总数**: 50+
- **来源分布**: SDD-RIPER (14), SDD-RIPER-Opt (6), Superpowers (24+), 测试开发 (2), 工具脚本 (1+)
- **目录结构**: references/ (3大类), protocols/ (3), docs/ (4), skills/ (2), scripts/ (1)

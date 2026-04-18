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

### 核心文件

| 文件 | 说明 |
|------|------|
| [SKILL.md](./SKILL.md) | Bootstrap 入口提示词（供AI读取，负责路由/规模/门禁） |
| [QUICKSTART.md](./QUICKSTART.md) | 快速启动命令与典型场景 |
| [reference-index.md](./reference-index.md) | 参考资料统一索引入口 |
| [workflow-diagrams.md](./workflow-diagrams.md) | Mermaid 流程图集（可视化参考） |
| [SKILL-entry-review.md](./SKILL-entry-review.md) | SKILL.md 持续复核文档 |

### 目录结构

```
altas-workflow/
├── SKILL.md                    # 主入口 Skill
├── QUICKSTART.md               # 快速启动指南
├── reference-index.md          # 参考资料总索引
├── workflow-diagrams.md        # 流程图集
├── SKILL-entry-review.md       # Skill 复核文档
├── references/                 # 按需加载的参考资料
│   ├── entry/                  # 入口相关
│   ├── spec-driven-development/# SDD-RIPER 完整协议
│   ├── checkpoint-driven/      # Checkpoint 轻量模式
│   ├── superpowers/            # TDD/Debug/Subagent 技能
│   ├── special-modes/          # 特殊模式协议
│   └── agents/                 # Agent 定义
├── protocols/                  # 专用协议
├── docs/                       # 方法论文档
└── scripts/                    # 自动化工具
```

---

## 参考资料按需调用指南

> 入口触发词、别名与 `MULTI` 模式控制词统一维护在 `references/entry/aliases.md`。

### 流程可视化参考

| 文件 | 调用时机 |
|------|----------|
| [workflow-diagrams.md](./workflow-diagrams.md) | 需要可视化理解工作流、规模评估、铁律门禁、TDD循环、三轴评审等流程时 |

### 入口参考

| 文件 | 调用时机 |
|------|----------|
| [references/entry/aliases.md](./references/entry/aliases.md) | 需要确认入口触发词、别名，或查看 `MULTI` 模式控制词时 |
| [references/entry/sources.md](./references/entry/sources.md) | 需要了解入口整合来源、方法论来源映射或做工作流介绍时 |
| [references/entry/exceptions-recovery.md](./references/entry/exceptions-recovery.md) | 遇到问题升级、不确定、需要退出协议或能力降级时 |
| [references/entry/discipline-enforcing.md](./references/entry/discipline-enforcing.md) | Agent 即将违反铁律、使用借口绕过规则、或出现常见使用错误时 |

### PRD 分析 / 需求文档

| 文件 | 调用时机 |
|------|----------|
| [references/prd-analysis/SKILL.md](./references/prd-analysis/SKILL.md) | PRD 分析完整工作流（Brainstorm → Discover → Document → Review → Validate） |
| [references/prd-analysis/template.md](./references/prd-analysis/template.md) | PRD 模板结构（产品概述/用户画像/旅程/功能需求/成功指标） |
| [references/prd-analysis/validation.md](./references/prd-analysis/validation.md) | PRD 验证清单（结构验证/内容质量/边界验证/跨节一致性） |
| [references/prd-analysis/reference/output-format.md](./references/prd-analysis/reference/output-format.md) | PRD 状态报告和多角度最终验证指南 |
| [references/prd-analysis/examples/good-prd.md](./references/prd-analysis/examples/good-prd.md) | 优质 PRD 示例参考 |
| [references/prd-analysis/examples/output-example.md](./references/prd-analysis/examples/output-example.md) | 预期输出格式具体示例 |

### 按工作流阶段索引

#### PRE-RESEARCH / 输入准备

| 文件 | 调用时机 |
|------|----------|
| [references/spec-driven-development/commands.md](./references/spec-driven-development/commands.md) | 需要create_codemap/build_context_bundle/sdd_bootstrap命令参数时 |
| [references/spec-driven-development/sdd-riper-one-protocol.md](./references/spec-driven-development/sdd-riper-one-protocol.md) | 需要完整协议定义时 |
| [references/spec-driven-development/workflow-quickref.md](./references/spec-driven-development/workflow-quickref.md) | 忘记流程快速查阅时 |

#### RESEARCH / 研究对齐

| 文件 | 调用时机 |
|------|----------|
| [references/spec-driven-development/spec-template.md](./references/spec-driven-development/spec-template.md) | 写Spec (Size M/L) 时 |
| [references/checkpoint-driven/spec-lite-template.md](./references/checkpoint-driven/spec-lite-template.md) | 写Spec (Size S) 时 |
| [references/checkpoint-driven/conventions.md](./references/checkpoint-driven/conventions.md) | 需要落盘命名约定时 |

#### INNOVATE / 方案对比

| 文件 | 调用时机 |
|------|----------|
| [references/superpowers/brainstorming/SKILL.md](./references/superpowers/brainstorming/SKILL.md) | Innovate阶段设计流程时 |
| [references/superpowers/brainstorming/visual-companion.md](./references/superpowers/brainstorming/visual-companion.md) | 设计需可视化展示时 |
| [references/superpowers/brainstorming/spec-document-reviewer-prompt.md](./references/superpowers/brainstorming/spec-document-reviewer-prompt.md) | 审查设计Spec时 |

#### PLAN / 详细规划

| 文件 | 调用时机 |
|------|----------|
| [references/superpowers/writing-plans/SKILL.md](./references/superpowers/writing-plans/SKILL.md) | 写Plan拆解任务时 |
| [references/superpowers/writing-plans/plan-document-reviewer-prompt.md](./references/superpowers/writing-plans/plan-document-reviewer-prompt.md) | Plan文档审查时 |

#### EXECUTE / 执行实现

| 文件 | 调用时机 |
|------|----------|
| [references/superpowers/test-driven-development/SKILL.md](./references/superpowers/test-driven-development/SKILL.md) | M/L规模TDD执行时 |
| [references/superpowers/test-driven-development/testing-anti-patterns.md](./references/superpowers/test-driven-development/testing-anti-patterns.md) | 避免测试反模式时 |
| [references/superpowers/subagent-driven-development/SKILL.md](./references/superpowers/subagent-driven-development/SKILL.md) | L规模Subagent驱动时 |
| [references/superpowers/subagent-driven-development/implementer-prompt.md](./references/superpowers/subagent-driven-development/implementer-prompt.md) | 派遣实现者Subagent时 |
| [references/superpowers/subagent-driven-development/spec-reviewer-prompt.md](./references/superpowers/subagent-driven-development/spec-reviewer-prompt.md) | Subagent Spec合规审查时 |
| [references/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md](./references/superpowers/subagent-driven-development/code-quality-reviewer-prompt.md) | Subagent代码质量审查时 |
| [references/superpowers/dispatching-parallel-agents/SKILL.md](./references/superpowers/dispatching-parallel-agents/SKILL.md) | 多独立故障并行派遣时 |
| [references/superpowers/executing-plans/SKILL.md](./references/superpowers/executing-plans/SKILL.md) | 无Subagent支持时执行Plan |
| [references/superpowers/using-git-worktrees/SKILL.md](./references/superpowers/using-git-worktrees/SKILL.md) | 需要隔离工作空间时 |

#### REVIEW / 审查

| 文件 | 调用时机 |
|------|----------|
| [references/checkpoint-driven/modules.md](./references/checkpoint-driven/modules.md) | 进入Review时 (含Deep/Debug/Review/Multi模块) |
| [references/superpowers/verification-before-completion/SKILL.md](./references/superpowers/verification-before-completion/SKILL.md) | 完成前验证时 |
| [references/superpowers/requesting-code-review/SKILL.md](./references/superpowers/requesting-code-review/SKILL.md) | 请求代码审查时 |
| [references/superpowers/requesting-code-review/code-reviewer.md](./references/superpowers/requesting-code-review/code-reviewer.md) | 派遣审查Agent模板 |
| [references/superpowers/receiving-code-review/SKILL.md](./references/superpowers/receiving-code-review/SKILL.md) | 收到审查反馈时 |

#### ARCHIVE / 知识沉淀

| 文件 | 调用时机 |
|------|----------|
| [references/spec-driven-development/archive-template.md](./references/spec-driven-development/archive-template.md) | 进入Archive时 |
| [scripts/archive_builder.py](./scripts/archive_builder.py) | 自动化归档生成时 |
| [references/superpowers/finishing-a-development-branch/SKILL.md](./references/superpowers/finishing-a-development-branch/SKILL.md) | 完成分支决策时 |

### 按特殊模式索引

#### DEBUG 模式

| 文件 | 调用时机 |
|------|----------|
| [references/superpowers/systematic-debugging/SKILL.md](./references/superpowers/systematic-debugging/SKILL.md) | 进入 Debug 模式时 |
| [references/superpowers/systematic-debugging/root-cause-tracing.md](./references/superpowers/systematic-debugging/root-cause-tracing.md) | 根因不明需追溯时 |
| [references/superpowers/systematic-debugging/defense-in-depth.md](./references/superpowers/systematic-debugging/defense-in-depth.md) | 需要多层防御时 |
| [references/superpowers/systematic-debugging/condition-based-waiting.md](./references/superpowers/systematic-debugging/condition-based-waiting.md) | 异步/条件等待问题时 |

#### MULTI 模式

| 文件 | 调用时机 |
|------|----------|
| [references/spec-driven-development/multi-project.md](./references/spec-driven-development/multi-project.md) | 多项目协作时 |
| [references/checkpoint-driven/modules.md](./references/checkpoint-driven/modules.md) (Multi-project 模块) | 多项目场景时 |

#### DOC 模式

| 文件 | 调用时机 |
|------|----------|
| [protocols/RIPER-DOC.md](./protocols/RIPER-DOC.md) | 文档撰写模式时 |

#### REVIEW 模式

| 文件 | 调用时机 |
|------|----------|
| [references/special-modes/review.md](./references/special-modes/review.md) | 进入 REVIEW 模式时 |
| [references/checkpoint-driven/modules.md](./references/checkpoint-driven/modules.md) (Review 模块) | 三轴评审标准 |
| [references/superpowers/requesting-code-review/SKILL.md](./references/superpowers/requesting-code-review/SKILL.md) | 请求代码审查时 |
| [references/superpowers/receiving-code-review/SKILL.md](./references/superpowers/receiving-code-review/SKILL.md) | 接收审查反馈时 |

#### REFACTOR 模式

| 文件 | 调用时机 |
|------|----------|
| [references/special-modes/refactor.md](./references/special-modes/refactor.md) | 进入 REFACTOR 模式时 |
| [references/superpowers/test-driven-development/SKILL.md](./references/superpowers/test-driven-development/SKILL.md) | TDD 执行验证 |
| [references/spec-driven-development/commands.md](./references/spec-driven-development/commands.md) (create_codemap) | CodeMap 生成 |

#### TEST 模式

| 文件 | 调用时机 |
|------|----------|
| [references/special-modes/test.md](./references/special-modes/test.md) | 进入 TEST 模式时 |
| [references/superpowers/test-driven-development/SKILL.md](./references/superpowers/test-driven-development/SKILL.md) | TDD 最佳实践 |
| [references/superpowers/test-driven-development/testing-anti-patterns.md](./references/superpowers/test-driven-development/testing-anti-patterns.md) | 测试反模式 |

#### PERF 模式

| 文件 | 调用时机 |
|------|----------|
| [references/special-modes/perf.md](./references/special-modes/perf.md) | 进入 PERF 模式时 |
| [references/superpowers/verification-before-completion/SKILL.md](./references/superpowers/verification-before-completion/SKILL.md) | 验证策略 |
| [references/superpowers/finishing-a-development-branch/SKILL.md](./references/superpowers/finishing-a-development-branch/SKILL.md) | 完成分支决策 |

#### MIGRATE 模式

| 文件 | 调用时机 |
|------|----------|
| [references/special-modes/migrate.md](./references/special-modes/migrate.md) | 进入 MIGRATE 模式时 |
| [references/superpowers/brainstorming/SKILL.md](./references/superpowers/brainstorming/SKILL.md) | 风险评估 |
| [references/superpowers/verification-before-completion/SKILL.md](./references/superpowers/verification-before-completion/SKILL.md) | 迁移后验证 |

### Agent 定义

| 文件 | 调用时机 |
|------|----------|
| [references/agents/sdd-riper-one/SKILL.md](./references/agents/sdd-riper-one/SKILL.md) | 使用完整RIPER协议时 |
| [references/agents/sdd-riper-one-light/SKILL.md](./references/agents/sdd-riper-one-light/SKILL.md) | 使用Checkpoint模式时 |
| [references/agents/code-reviewer.md](./references/agents/code-reviewer.md) | 派遣审查Agent时 |

### 协议

| 文件 | 调用时机 |
|------|----------|
| [protocols/RIPER-5.md](./protocols/RIPER-5.md) | 高风险代码修改时 |
| [protocols/SDD-RIPER-DUAL-COOP.md](./protocols/SDD-RIPER-DUAL-COOP.md) | 双模型环境时 |
| [protocols/RIPER-DOC.md](./protocols/RIPER-DOC.md) | DOC模式时 |

### 方法论文档

| 文件 | 调用时机 |
|------|----------|
| [docs/从传统编程转向大模型编程.md](./docs/从传统编程转向大模型编程.md) | 理解范式转换时 |
| [docs/团队落地指南.md](./docs/团队落地指南.md) | 团队推广时 |
| [docs/如何快速从零开始落地大模型编程 -- 手把手教程.md](./docs/如何快速从零开始落地大模型编程 -- 手把手教程.md) | 入门学习时 |
| [docs/AI-原生研发范式-从代码中心到文档驱动的演进.md](./docs/AI-原生研发范式-从代码中心到文档驱动的演进.md) | 深入理解理论时 |

### Superpowers 扩展参考

| 文件 | 调用时机 |
|------|----------|
| [references/superpowers/using-superpowers/SKILL.md](./references/superpowers/using-superpowers/SKILL.md) | 检查Skill适用性时 |
| [references/superpowers/using-superpowers/references/codex-tools.md](./references/superpowers/using-superpowers/references/codex-tools.md) | Codex 平台工具映射 |
| [references/superpowers/using-superpowers/references/copilot-tools.md](./references/superpowers/using-superpowers/references/copilot-tools.md) | Copilot CLI 工具映射 |
| [references/superpowers/using-superpowers/references/gemini-tools.md](./references/superpowers/using-superpowers/references/gemini-tools.md) | Gemini 平台工具映射 |
| [references/superpowers/writing-skills/SKILL.md](./references/superpowers/writing-skills/SKILL.md) | 创建新Skill时 |
| [references/superpowers/writing-skills/persuasion-principles.md](./references/superpowers/writing-skills/persuasion-principles.md) | 优化 Skill 效果时 |
| [references/superpowers/writing-skills/testing-skills-with-subagents.md](./references/superpowers/writing-skills/testing-skills-with-subagents.md) | 验证 Skill 有效性时 |
| [references/superpowers/writing-skills/anthropic-best-practices.md](./references/superpowers/writing-skills/anthropic-best-practices.md) | Anthropic 最佳实践参考 |

### 自动化工具

| 文件 | 调用时机 |
|------|----------|
| [scripts/archive_builder.py](./scripts/archive_builder.py) | 自动化归档时 |
| [scripts/validate_aliases_sync.py](./scripts/validate_aliases_sync.py) | 验证 aliases 同步状态时 |

---

## 统计

- **参考文件总数**: 70+
- **来源分布**: SDD-RIPER (14), SDD-RIPER-Opt (6), Superpowers (24+), PRD Analysis (6), 测试开发 (18+), 工具脚本 (3)
- **目录结构**: references/ (7大类), protocols/ (4), docs/ (4), scripts/ (3)

---

*Powered by the integration of SDD-RIPER, SDD-RIPER-Optimized (Checkpoint-Driven), and Superpowers.*

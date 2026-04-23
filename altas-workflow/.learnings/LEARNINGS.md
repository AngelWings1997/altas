# Learnings Log

Captured learnings, corrections, and discoveries for ALTAS Workflow. Review before major tasks.

## 快速参考

**Categories**: correction | insight | knowledge_gap | best_practice | user_explicit | simplify_and_harden
**Areas**: workflow | routing | spec | execute | review | archive | testing | prd | config
**Statuses**: pending | in_progress | resolved | wont_fix | promoted | promoted_to_skill

### 区域标签

| Area | Scope |
|------|-------|
| `workflow` | 工作流路由、阶段、门禁 |
| `routing` | 触发词识别、模式选择 |
| `spec` | Spec 模板、格式、内容 |
| `execute` | 代码实现、工具使用 |
| `review` | 审查规则、质量标准 |
| `archive` | 知识沉淀、归档 |
| `testing` | 测试策略、框架、用例 |
| `prd` | PRD 分析、需求理解 |
| `config` | 配置、环境、设置 |

### 状态定义

| Status | Meaning |
|--------|---------|
| `pending` | Not yet addressed |
| `in_progress` | Actively being worked on |
| `resolved` | Issue fixed or knowledge integrated |
| `wont_fix` | Decided not to address (reason in Resolution) |
| `promoted` | Elevated to SKILL.md, aliases.md, or corresponding rule files |
| `promoted_to_skill` | Extracted as a reusable skill |

### 晋升快速参考

当 Recurrence-Count >= 3 + 跨 2+ 任务 + 30 天窗口 → 晋升到对应规则文件。

| 学习类型 | 晋升目标 |
|----------|----------|
| 路由/触发词修正 | SKILL.md 路由表 / aliases.md |
| 规模评估修正 | SKILL.md 规模评估表 |
| 铁律/门禁补充 | SKILL.md Hard Rules |
| 阶段门禁强化 | SKILL.md 阶段门禁 |
| 工具/平台适配 | SKILL.md 工具映射表 |
| 别名补充 | references/entry/aliases.md |
| 测试策略 | references/testing/ |
| 审查规则 | references/special-modes/review.md |
| 调试策略 | references/superpowers/systematic-debugging/ |
| 通用最佳实践 | 对应 references/ 子目录 |

## Skill Extraction Fields

When a learning is promoted to a skill, add these fields:

```markdown
**Status**: promoted_to_skill
**Skill-Path**: references/superpowers/skill-name
```

---

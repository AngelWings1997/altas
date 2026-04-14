# SKILL Entry Review

## 背景

本文件记录对 `SKILL.md` 作为技能入口的持续复核结论。

**本轮复核范围：** v4.1（入口瘦身版）+ 关联参考体系（`reference-index.md`、`references/` 全部文件、`protocols/`）

---

## 一、已解决问题（从本文移除）

以下问题已在历史版本中解决，不再保留在正文：

| # | 问题描述 | 解决方案 | 版本 |
|---|----------|----------|------|
| A | 入口过载：入口承担大量治理细节、方法说明、模板内容 | 入口已瘦身为路由门禁盘；详细内容下沉 `references/` | v3.x |
| B | frontmatter `description` 不够 discovery-first | 已改为面向触发场景的描述 | v4.0 |
| C | 入口与参考资料职责边界不清 | `reference-index.md` 作为统一发现入口；`SKILL.md` 明确标注"按需加载"策略 | v4.0 |
| D | 规则优先级表述过于激进 | 铁律表已重构为"含义"说明，不再是强制指令语气 | v4.0 |
| E | 触发词词典分散维护 | `references/entry/aliases.md` 作为单一维护源；所有入口文档改为引用 | v4.1 |
| F | 入口级依赖声明缺失 | frontmatter `dependencies` 已显式纳入 `reference-index.md`、`aliases.md`、`references/`、`protocols/` | v4.1 |
| G | 参考路径写法不稳定 | 阶段门禁摘要中的路径已改为稳定的仓库相对路径 | v4.1 |
| H | 高价值参考索引与 reference-index.md 重复 | 已删除高价值参考索引节，改为引用 `reference-index.md` | v4.2 |
| I | 常用产物与 conventions.md 重复 | 已删除常用产物节，改为引用 `reference-index.md` | v4.2 |
| J | 路由速查表按需加载列与 reference-index.md 重复 | 已简化为 `reference-index.md → 按特殊模式/按工作流阶段 → [场景]` | v4.2 |
| K | 只读纪律与 DOC/ARCHIVE 实际行为矛盾 | 已改为"分析只读，产出会写"的分类描述 | v4.2 |
| L | 规模评估与阶段门禁之间存在逻辑断层 | 已增加"规模-阶段映射"表，显式说明各规模对应阶段路径 | v4.2 |
| M | INNOVATE 阶段适用范围不清晰 | 已改为"适用 L，复杂 M 也可进入" | v4.2 |
| N | EXIT ALTAS 行为定义不够精确 | 已增加"EXIT ALTAS 规范"节，明确输出字段和 spec 损坏处理 | v4.2 |
| O | 能力降级覆盖范围有限 | 已扩展为 6 种缺失能力的降级方案 | v4.2 |
| P | reference-index.md 缺少按需加载使用指南 | 已增加"按需加载指南"节 | v4.2 |

---

## 二、本轮已收口但值得记录的变更

### 1. 路由表"只读"列的值语义调整

**变更前：** `是` / `否` / `通常是`
**变更后：** `是` / `否` / `分析只读，产出会写`

这解决了 `DOC`/`ARCHIVE`/`DEBUG` 模式被标注为"只读"但实际会写文件的问题。

### 2. 路由表"参考"列统一指向 reference-index.md

**变更前：** 每行直接列出具体参考文件路径（与 reference-index.md 内容重复）
**变更后：** 统一格式 `reference-index.md → 按特殊模式 → [场景]`，消除两处索引的维护负担

---

## 三、待确认项（需要领域专家决策）

以下问题在本轮复核时尚未推动，留待后续确认：

1. **trigger_keywords 同步机制**：frontmatter `trigger_keywords` 与 `aliases.md` 的同步是纯人工维护，是否需要建立自动化检查？
2. **EXIT ALTAS 主动退出 vs 异常中断行为区分**：当前规范未区分"用户主动 EXIT"和"异常强制退出"，是否需要分别定义？

---

## 四、维护约定

- 本文件每次对 `SKILL.md` 进行重大修订后同步更新
- "已解决问题"表格只记录从本文移除的问题，不删除
- 新发现的问题追加到"当前版本仍可改进的问题"节，并给出优先级和建议

---

*本文件持续更新，每次对 `SKILL.md` 进行重大修订后复核。*

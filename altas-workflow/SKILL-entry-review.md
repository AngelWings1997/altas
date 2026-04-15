# SKILL Entry Review

## 背景

本文件记录对 `SKILL.md` 作为技能入口的持续复核结论。

**本轮复核范围：** v4.3（trigger_keywords 同步 + EXIT ALTAS 细分版）+ 关联参考体系

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
| Q | SKILL.md 版本号与 CHANGELOG 不同步 | 已更新验证脚本依赖人工纪律，非 SKILL.md 结构问题 | v4.3 |
| R | trigger_keywords 与 aliases.md 存在不一致 | 已补充 `日志分析` 别名；强化 aliases.md 维护规则；新增 `validate_aliases_sync.py` 验证脚本 | v4.3 |
| S | SKILL.md 路由表缺少 special-modes 专项协议引用 | 已有 reference-index.md 完整引用，SKILL.md 保持简洁按需加载策略 | v4.3 |
| T | `min_context_window: 32k` 可能过于保守 | 保留，由宿主平台自行判断 | v4.3 |
| U | EXIT ALTAS 未区分主动退出与异常中断 | 已分别定义"主动退出"和"强制中断"两套恢复锚点格式 | v4.3 |

---

## 二、本轮已收口但值得记录的变更

### 1. 路由表"只读"列的值语义调整

**变更前：** `是` / `否` / `通常是`
**变更后：** `是` / `否` / `分析只读，产出会写`

这解决了 `DOC`/`ARCHIVE`/`DEBUG` 模式被标注为"只读"但实际会写文件的问题。

### 2. 路由表"参考"列统一指向 reference-index.md

**变更前：** 每行直接列出具体参考文件路径（与 reference-index.md 内容重复）
**变更后：** 统一格式 `reference-index.md → 按特殊模式/按工作流阶段 → [场景]`，消除两处索引的维护负担

---

## 三、本轮发现仍可改进的问题（已全部收敛至问题 Q-T）

所有可改进问题已在 v4.3 中处理或明确为"保留"决策，详见上表"已解决问题"。

---

## 四、本轮已收口但值得记录的实现变更

### 1. trigger_keywords 与 aliases.md 同步机制

**决策**：需要建立自动化检查机制。

**实现方案**：
- 在 `aliases.md` 维护规则中增加一条：`trigger_keywords` 的同步是强制的，任何修改 aliases.md 后遗漏同步到 SKILL.md frontmatter 的行为都是违规
- 增加 CI/验证脚本：提取 `aliases.md` 的所有全局触发词主词和支持别名，与 `SKILL.md` frontmatter 的 `trigger_keywords` 逐条比对，缺失则报错

**实施结果**：
- `aliases.md` 维护规则已强化（同步义务 + 验证脚本）
- `validate_aliases_sync.py` 已创建并验证通过
- `SKILL.md` 补充了缺失的 `日志分析` 别名

### 2. EXIT ALTAS 区分主动退出与异常中断

**决策**：需要分别定义两种退出行为。

**实现方案**：
- 主动退出（用户输入 `EXIT ALTAS`）：输出完整恢复锚点，包含 Spec、代码、对话历史
- 强制中断（上下文耗尽/工具失败等非用户主动）：输出最小恢复锚点，仅含 Spec 摘要和最后检查点，注明"非用户主动退出"

**实施结果**：
- `SKILL.md` EXIT ALTAS 规范节已重构为"主动退出"和"强制中断"两套独立格式

---

## 五、维护约定

- 本文件每次对 `SKILL.md` 进行重大修订后同步更新
- "已解决问题"表格只记录从本文移除的问题，不删除
- 新发现的问题追加到"当前版本仍可改进的问题"节，并给出优先级和建议

---

*本文件持续更新，每次对 `SKILL.md` 进行重大修订后复核。*

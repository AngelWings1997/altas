# SKILL Entry Review

## 背景

本文件记录对当前版本 `SKILL.md` 作为技能入口的复核结论。

此前几项大的入口问题已经基本收敛，包括：
- 入口过载
- frontmatter `description` 不够 discovery-first
- 入口与参考资料职责边界不清
- 规则优先级表述过于激进

因此，本次复核不再重复记录这些已解决项，只保留当前版本仍值得继续优化的问题。

## 本轮已继续收口的项

在上一轮复核之后，以下改进已完成：

1. 触发词词典已收敛为单一维护源
   - 已新增 `references/entry/aliases.md`
   - `SKILL.md`、`README.md`、`QUICKSTART.md`、`references/spec-driven-development/workflow-quickref.md` 已改为引用该词典
   - 词典已区分“全局触发词”与“模式内控制词”

2. 入口级依赖声明已补全
   - `SKILL.md` frontmatter `dependencies` 已显式纳入：
   - `reference-index.md`
   - `references/entry/aliases.md`

3. 参考路径写法已统一
   - `SKILL.md` 阶段门禁摘要中的简写路径已改为稳定的仓库相对路径

4. `reference-index.md` 已补上入口词典索引
   - 新增“入口参考”段
   - 已将 `references/entry/aliases.md` 纳入统一发现入口

## 当前版本仍可改进的问题

### 1. 入口中仍保留少量可继续下沉的治理细节

当前入口已经显著瘦身，但仍保留了两类偏“治理说明”而非“入口门禁”的内容：
- `常用产物` 表
- `来源` 表

这些内容本身有价值，但更适合放在：
- `reference-index.md`
- 单独的 `references/entry/...` 参考文件

问题在于：
- 入口仍承担了一部分“参考手册”和“方法说明”职责
- `常用产物` 与 `workflow-quickref.md`、`commands.md`、`conventions.md` 仍有交叉
- 当命名约定或来源说明发生变化时，入口仍然是潜在维护点

## 建议的继续优化方向

1. 继续压缩非门禁信息
   - 将 `常用产物` 与 `来源` 迁移到参考文件
   - 入口只保留“何时用、怎么分流、第一步做什么、去哪里继续读”

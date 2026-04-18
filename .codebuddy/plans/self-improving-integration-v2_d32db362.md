---
name: self-improving-integration-v2
overview: 基于深入分析，将 self-improving-agent 的全部能力（特别是自我进化核心能力）移植到 altas-workflow，补充 8 项缺失能力、强化 3 项部分实现能力、确保自动触发机制落地
todos:
  - id: enhance-self-improvement-skill
    content: 增强 references/self-improvement/SKILL.md：补充主动触发机制、Pattern-Key 去重实操、技能提取质量门禁、提取检测触发器、晋升映射补全为10种、Gitignore 策略、定期回顾对齐检查点、无 Hook 平台适配
    status: completed
  - id: modify-skill-entry
    content: 修改 SKILL.md：检查点契约增加 Review/Archive 自检、晋升映射补全为10种、首轮响应契约增加回顾 .learnings/
    status: completed
    dependencies:
      - enhance-self-improvement-skill
  - id: enhance-learnings-templates
    content: 增强 .learnings/ 三个模板：补充状态定义、区域标签快速参考、晋升快速参考、示例条目骨架
    status: completed
  - id: update-error-detector
    content: 更新 scripts/error-detector.sh：统一为中文 ALTAS 版本，多平台环境变量兼容
    status: completed
  - id: update-first-response
    content: 修改 references/entry/first-response.md：增加回顾 .learnings/ 相关条目步骤
    status: completed
  - id: update-agents-md
    content: 修改 /Users/litianyi/trae/altas/AGENTS.md：增加自我改进行为指令段落
    status: completed
---

## 产品概述

将 self-improving-agent 技能的**所有通用能力**完整移植到 altas-workflow，使其具备"记录→去重→晋升→提取→进化"的完整自我进化闭环。当用户纠正问题或提供新思路时，自动捕获并沉淀到 .learnings/ 日志，满足条件后晋升为工作流规则。

## 核心功能

- 补全 8 项缺失能力：Pattern-Key 去重实操、Gitignore 策略、技能提取质量门禁、提取检测触发器、无 Hook 平台适配、详细状态模板
- 强化主动触发：在检查点契约和 Review/Archive 阶段嵌入自检步骤，从"被动参考"变为"主动触发"
- 统一晋升映射：消除 SKILL.md(8种) 与 self-improvement/SKILL.md(10种) 的不一致
- 增强 .learnings/ 模板：从空模板变为含状态定义、区域标签、晋升快速参考的引导模板
- 首轮响应增加回顾步骤：新任务开始前回顾 .learnings/ 相关条目
- AGENTS.md 增加自我改进行为指令：跨会话持久提醒

## 不移植的能力

- OpenClaw 专用能力(#26 handler.js/handler.ts、#27 OpenClaw触发器)：altas 兼容平台不含 OpenClaw
- Simplify & Harden 外部技能集成(#8)：altas 不含该技能，但将其核心去重机制(Pattern-Key)融入自有流程

## 技术方案

### 核心策略

"增强现有、不重建"：altas-workflow 已有完整的自我进化框架(铁律#11、.learnings/、脚本、参考文档)，只需补全缺失环节、强化触发机制、统一数据格式，而非从零构建。

### 实施方法

**1. 增强 references/self-improvement/SKILL.md（核心改动）**

现有文件 277 行，已包含触发场景、记录格式、晋升规则、技能提取、定期回顾。需补充：

- **主动触发机制**：在"触发场景"后增加"主动触发"章节，定义 Agent 自检时机（任务完成后/错误发生时/用户纠正时/新任务开始前），与检查点契约对齐
- **Pattern-Key 去重实操指南**：从原版"Simplify & Harden Feed"中提取核心去重流程（搜索已有条目→匹配 Pattern-Key→更新 Recurrence-Count/Last-Seen→添加 See Also 链接），适配为 altas 原生机制，不依赖外部技能
- **技能提取质量门禁**：补充 6 项提取前验证清单（已测试、描述自包含、代码自包含、无硬编码、命名规范、来源记录）
- **提取检测触发器**：补充对话信号（"保存为技能"/"一直遇到"/"其他项目也能用"）和条目信号（多 See Also / 高优先级+已解决 / best_practice / 用户正面反馈）
- **晋升映射表补全**：补充"阶段门禁强化"和"别名补充"两行，与 self-improvement/SKILL.md 的 10 种类型统一
- **定期回顾对齐检查点**：在"定期回顾"章节增加与 altas 检查点流程的对齐说明（Review 阶段自检、Archive 阶段回顾）
- **无 Hook 平台适配**：增加 Cursor/Trae/Qoder 平台的替代方案（在 AGENTS.md/CLAUDE.md 中添加持久提醒，或手动触发）

**2. 修改 SKILL.md 主入口（关键触发点）**

- **检查点契约增加自检**：在"检查点契约"章节末尾增加一条："Review/Archive 阶段输出检查点时，必须自检是否有可捕获的学习（非显而易见的方案/错误/用户纠正），如有则记录到 .learnings/"
- **晋升映射表统一**：将 SKILL.md 中的 8 种晋升类型补全为 10 种，增加"阶段门禁强化→SKILL.md 阶段门禁"和"别名补充→references/entry/aliases.md"
- **首轮响应回顾**：在"首轮响应契约"中增加："大任务(M/L)开始前，应回顾 .learnings/ 中相关区域的过往学习"

**3. 增强 .learnings/ 三个模板文件**

从空模板变为含引导信息的模板：

- **LEARNINGS.md**：补充状态定义(pending/in_progress/resolved/wont_fix/promoted/promoted_to_skill)、区域标签快速参考(9个Area)、晋升快速参考(10种映射)、示例条目骨架
- **ERRORS.md**：补充状态定义、区域标签快速参考、示例条目骨架
- **FEATURE_REQUESTS.md**：补充状态定义、区域标签快速参考、示例条目骨架

**4. 更新 scripts/error-detector.sh**

当前版本存在不一致（部分输出英文），统一为中文 ALTAS 版本：

- 环境变量支持：`ALTAS_TOOL_OUTPUT` / `TRADE_TOOL_OUTPUT` / `CLAUDE_TOOL_OUTPUT`（多平台兼容）
- 输出标签：`<altas-error-detected>`（中文提示）
- 错误模式：保持现有 16 种

**5. 更新 references/entry/first-response.md**

在"已有明确任务时的最小字段"中增加："回顾 .learnings/ 相关条目（如有）"
在首轮响应固定模板中增加一个可选字段："### 相关学习（如有）"

**6. 更新 AGENTS.md**

在项目根 AGENTS.md 中增加"自我改进行为指令"章节：

- 记录时机（任务完成后自检、错误发生时、用户纠正时）
- 记录位置（.learnings/ 对应文件）
- 晋升意识（重复出现≥3次则考虑晋升）

**7. 补充 .gitignore 策略说明**

在 references/self-improvement/SKILL.md 中增加 Gitignore 选项章节，提供三种策略（本地私有/仓库共享/混合），建议使用混合策略（跟踪模板头，允许排除具体条目）

### 目录结构

```
altas-workflow/
├── SKILL.md                                    # [MODIFY] 检查点契约增加自检；晋升映射补全为10种；首轮响应增加回顾
├── reference-index.md                          # [MODIFY] 无需改动，已有完整自我进化索引
├── .learnings/
│   ├── LEARNINGS.md                            # [MODIFY] 增强模板：状态定义、区域标签、晋升快速参考、示例骨架
│   ├── ERRORS.md                               # [MODIFY] 增强模板：状态定义、区域标签、示例骨架
│   └── FEATURE_REQUESTS.md                     # [MODIFY] 增强模板：状态定义、区域标签、示例骨架
├── references/
│   ├── self-improvement/
│   │   └── SKILL.md                            # [MODIFY] 核心增强：主动触发、Pattern-Key去重、质量门禁、检测触发器、晋升映射补全、Gitignore策略、无Hook平台适配
│   └── entry/
│       └── first-response.md                   # [MODIFY] 增加回顾 .learnings/ 步骤
└── scripts/
    └── error-detector.sh                       # [MODIFY] 统一为中文ALTAS版本，多平台环境变量

/Users/litianyi/trae/altas/
└── AGENTS.md                                   # [MODIFY] 增加自我改进行为指令段落
```

### 实施注意事项

- **不改动已有晋升规则核心逻辑**：Recurrence-Count>=3 + 跨2+任务 + 30天窗口已足够合理
- **不引入 OpenClaw 专用机制**：handler.js/handler.ts 和 sessions_send/sessions_spawn 不适用于 altas 兼容平台
- **.learnings/ 模板控制体量**：每个模板文件增加约 30-50 行引导信息，不超过 80 行，避免上下文膨胀
- **error-detector.sh 多平台兼容**：环境变量读取顺序 ALTAS_TOOL_OUTPUT > TRAE_TOOL_OUTPUT > CLAUDE_TOOL_OUTPUT
- **AGENTS.md 最小改动**：仅增加 1 个章节（约 10 行），不改动已有 4 个章节
- **首轮响应模板向后兼容**：回顾 .learnings/ 为可选步骤，不影响现有流程
- **与检查点机制对齐**：自我改进的自检嵌入 Review/Archive 阶段的检查点输出中，而非独立时间驱动

## Skill

- **self-improving-agent**
- Purpose: 参考其核心机制（6种触发场景、3种日志格式、晋升规则、Pattern-Key去重、技能提取质量门禁、检测触发器、Gitignore策略）来补全 altas-workflow 的 8 项缺失能力
- Expected outcome: 将 self-improving-agent 的 Pattern-Key 去重实操、技能提取质量门禁(6项)、提取检测触发器(对话+条目信号)、Gitignore 三种策略、详细状态定义模板等缺失能力适配整合到 altas-workflow 中

## SubAgent

- **code-explorer**
- Purpose: 在实施阶段验证文件当前内容，确保修改精确到行，避免误改
- Expected outcome: 确认每个待修改文件的精确内容和修改位置，防止引入回归
---
name: self-improving-integration
overview: 将 self-improving-agent 技能的核心机制整合到 altas-workflow，使其具备自动记录学习/错误/功能请求并持续自我进化的能力
todos:
  - id: enhance-self-improvement-skill
    content: 增强 references/self-improvement/SKILL.md：补充主动触发机制、altas-workflow 晋升映射表、CodeBuddy/Trae Hook 配置、技能提取流程、循环检测实操、定期回顾对齐检查点
    status: in_progress
  - id: embed-trigger-in-skill-entry
    content: 修改 SKILL.md：在检查点契约中增加自我改进评估触发，在 Quick Navigation 增加自我改进条目
    status: pending
    dependencies:
      - enhance-self-improvement-skill
  - id: enhance-learnings-templates
    content: 增强 .learnings/ 三个模板文件：补充区域标签定义、状态流转说明、晋升快速参考
    status: pending
  - id: create-activator-scripts
    content: 新增 scripts/activator.sh 和 scripts/error-detector.sh：适配 CodeBuddy/Trae 平台的自动提醒和错误检测脚本
    status: completed
  - id: update-reference-index
    content: 修改 reference-index.md：在入口参考区增加自我改进索引条目
    status: pending
    dependencies:
      - enhance-self-improvement-skill
  - id: update-agents-md
    content: 修改 AGENTS.md：增加自我改进行为指令段落，作为跨会话持久提醒
    status: pending
---

## 产品概述

将 self-improving-agent 技能的核心能力整合到 altas-workflow 项目中，使其具备持续自我改进的能力，能在用户纠正问题或提供新思路时自动捕获并沉淀知识。

## 核心功能

- 在 SKILL.md 主入口中嵌入自我改进触发机制，使 Agent 在使用过程中自动识别并记录学习、错误、功能请求
- 增强 references/self-improvement/SKILL.md，补充 altas-workflow 专有的晋升目标映射、Hook 触发机制、自动提醒流程
- 在 reference-index.md 中增加自我改进索引条目，确保可发现性
- 在 .learnings/ 模板中适配 altas-workflow 的区域标签和晋升目标
- 在 AGENTS.md 中添加自我改进行为指令
- 新增 self-improvement 自动化脚本（activator、error-detector），适配 CodeBuddy 平台
- 确保 `.gitignore` 策略合理（跟踪模板，可选跟踪条目）

## 技术方案

### 核心策略

采用"增强现有、不重建"原则：altas-workflow 已有 `.learnings/` 目录和 `references/self-improvement/SKILL.md`，只需补充缺失的触发机制、晋升映射、自动化脚本和入口引用，而非从零构建。

### 实施方法

**1. 增强现有 references/self-improvement/SKILL.md**
现有文件（238行）已定义基本格式和晋升规则，但缺少以下关键内容（来源于 self-improving-agent SKILL.md 的能力）：

- CodeBuddy/Trae 平台的 Hook 触发机制（原技能只覆盖 Claude Code/Codex/Copilot/OpenClaw）
- 主动提醒机制（Agent 在每次任务后评估是否有可捕获的知识）
- 技能提取的详细流程和质量门禁
- altas-workflow 专有的晋升目标完整映射表（已有但不完整，需补充）
- 循环模式检测的实操指南（Pattern-Key 使用方式）
- 定期回顾的触发时机（与 altas-workflow 的检查点机制对齐）

**2. 在 SKILL.md 主入口中嵌入自我改进触发**
在 SKILL.md 的检查点契约或阶段门禁中增加一条：Agent 在任务完成后（特别是 Review/Archive 阶段），必须评估是否有可捕获的学习，如有则记录到 `.learnings/`。这是最关键的改动——让自我改进从"被动参考"变为"主动触发"。

**3. 增强 .learnings/ 模板**
现有三个文件仅为空模板（标题+分隔线），需补充：

- 区域标签定义（与 altas-workflow 的9个区域对齐）
- 状态流转说明
- 晋升目标映射的快速参考

**4. 新增自动化脚本**

- `scripts/activator.sh`：适配 CodeBuddy/Trae 平台，在会话开始时输出自我改进提醒（约50-100 tokens）
- `scripts/error-detector.sh`：检测命令执行失败，自动提示记录到 ERRORS.md

**5. 更新 reference-index.md**
在入口参考区域增加自我改进的索引条目，确保 Agent 在需要时能发现并加载该机制。

**6. 更新 AGENTS.md**
在项目级 AGENTS.md 中增加自我改进行为指令，作为跨会话的持久提醒。

### 晋升目标映射（altas-workflow 专有）

| 学习类型 | 晋升目标文件 | 晋升方式 |
| --- | --- | --- |
| 路由规则修正 | SKILL.md 路由速查表 | 增加行或修正路由 |
| 规模评估修正 | SKILL.md 规模评估表 | 修正信号或判断依据 |
| 铁律补充 | SKILL.md Hard Rules | 新增铁律行 |
| 阶段门禁强化 | SKILL.md 阶段门禁摘要 | 增加门禁条件 |
| 别名补充 | references/entry/aliases.md + SKILL.md trigger_keywords | 同步更新（运行 validate_aliases_sync.py） |
| 测试策略 | references/testing/test-strategy-template.md | 增加字段或约束 |
| 审查规则 | references/special-modes/review.md | 增加审查维度 |
| 调试策略 | references/superpowers/systematic-debugging/ | 新增或修改参考文件 |
| 工作流最佳实践 | 对应 references/ 子目录 | 增加文件或章节 |
| 防绕过规则 | references/entry/discipline-enforcing.md | 增加 Red Flag 或借口反驳 |
| 首轮响应修正 | references/entry/first-response.md | 修正模板或规则 |
| 检查点规则 | references/checkpoint-driven/checkpoints.md | 增加触发时机或约束 |
| 工具映射更新 | SKILL.md Entry Contract | 更新工具映射表 |


### 目录结构

```
altas-workflow/
├── SKILL.md                              # [MODIFY] 在检查点契约中增加自我改进触发；在 Quick Navigation 增加条目
├── AGENTS.md                             # [MODIFY] 增加自我改进行为指令段落
├── reference-index.md                    # [MODIFY] 在入口参考区增加自我改进索引
├── .learnings/
│   ├── LEARNINGS.md                      # [MODIFY] 增强模板：区域标签、状态流转、晋升快速参考
│   ├── ERRORS.md                         # [MODIFY] 增强模板：区域标签、状态流转
│   └── FEATURE_REQUESTS.md               # [MODIFY] 增强模板：区域标签、状态流转
├── references/
│   └── self-improvement/
│       └── SKILL.md                      # [MODIFY] 核心增强：主动触发机制、晋升映射、Hook配置、技能提取、循环检测、定期回顾
└── scripts/
    ├── activator.sh                      # [NEW] CodeBuddy/Trae 平台适配的会话开始提醒脚本
    └── error-detector.sh                 # [NEW] 命令失败自动检测脚本
```

### 实施注意事项

- **不改已有晋升规则的核心逻辑**：现有的 Recurrence-Count>=3 + 跨2+任务 + 30天窗口 晋升规则已足够合理，只需补充映射表
- **不引入 OpenClaw 专用机制**：altas-workflow 的 compatible_platforms 是 cursor/trae/claude/openai/qoder，不需要 OpenClaw 的 sessions_send/sessions_spawn 等工具
- **脚本轻量化**：activator.sh 控制在 ~50-100 tokens 输出，避免上下文膨胀
- **.gitignore 策略**：建议跟踪 .learnings/ 模板头（团队共享知识），但允许用户在 .gitignore 中排除具体条目
- **与检查点机制对齐**：自我改进的"定期回顾"触发时机应嵌入 altas-workflow 现有的检查点流程（Review/Archive 阶段），而非独立时间驱动

## Skill

- **self-improving-agent**
- Purpose: 参考其核心机制（触发场景、日志格式、晋升规则、Hook脚本、技能提取流程）来增强 altas-workflow 的自我改进能力
- Expected outcome: 将 self-improving-agent 的6个触发场景、3种日志格式、晋升机制、技能提取、循环检测等核心能力适配整合到 altas-workflow 中
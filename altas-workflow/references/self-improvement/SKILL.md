# Self-Improvement 参考文档

> ALTAS Workflow 自我进化机制：在使用中发现问题、纠正、新思路时自动记录，定期总结并晋升到工作流规则。
>
> **核心原则**：记录 → 去重 → 晋升 → 进化。每次任务完成后自动评估是否有可捕获的知识，而非等用户提醒。

## 触发机制

### 主动触发（Agent 自检 — 检查点契约强制）

| 时机 | 自检问题 | 触发方式 |
|------|----------|----------|
| 任务完成（Review/Archive 阶段） | 是否有非显而易见的解决方案？是否学到了项目特定模式？ | 检查点契约强制 |
| 错误发生时 | 错误是否非预期、需要调查、可能重复？ | Hook 自动检测 / Agent 识别 |
| 用户纠正时 | 用户说了"不对"、"应该是"、"搞错了"？ | Agent 检测纠正信号 |
| 新任务开始前 | 过往学习是否有相关条目？ | Agent 主动回顾 .learnings/ |

### 被动触发（信号检测）

| 场景 | 记录到 | ID 格式 | 检测关键词 |
|------|--------|----------|------------|
| 用户纠正 AI | LEARNINGS.md (correction) | LRN-YYYYMMDD-XXX | **中文**："不对"、"应该是..."、"你搞错了"、"这个不对"、"错了"、"不是这样"、"不对吧"、"搞错了"、"理解错了"、"想错了"、"你理解反了"；**英文**："No, that's not right...", "Actually...", "You're wrong about...", "That's outdated...", "Incorrect...", "Wrong...", "That's not it" |
| 命令执行失败/异常行为 | ERRORS.md | ERR-YYYYMMDD-XXX | 非零退出码、Exception、Traceback、超时、构建失败、测试失败（详见 error-detector.sh） |
| 用户请求当前不支持的能力 | FEATURE_REQUESTS.md | FEAT-YYYYMMDD-XXX | **中文**："能不能..."、"为什么不能..."、"可以...吗"、"有没有办法..."、"支持...吗"、"能不能加个功能"、"我希望..."、"要是能...就好了"；**英文**："Can you also...", "I wish you could...", "Is there a way to...", "Why can't you...", "It would be nice if..." |
| 发现文档过时/知识缺口 | LEARNINGS.md (knowledge_gap) | LRN-YYYYMMDD-XXX | 文档与实际行为不符、API 变更未更新、版本差异导致的行为变化 |
| 发现更优方案/最佳实践 | LEARNINGS.md (best_practice) | LRN-YYYYMMDD-XXX | 更简洁/更可靠/更高效的替代方案、性能优化发现、代码简化机会 |
| 用户说"记住这个"、"以后都这样" | LEARNINGS.md (user_explicit) | LRN-YYYYMMDD-XXX | **中文**："记住"、"以后都这样"、"保存下来"、"记下来"、"这个要记住"、"以后按这个来"、"把这个记下来"、"沉淀一下"；**英文**："Remember this", "Save this", "Keep this in mind", "Always do it this way" |
| 用户提供新思路/方案 | LEARNINGS.md (new_insight) | LRN-YYYYMMDD-XXX | **中文**："我觉得可以这样"、"有个想法"、"换个思路"、"要不试试"、"我有个主意"、"可以这样考虑"、"从另一个角度"、"或许可以"、"有个新方案"；**英文**："What if we...", "Have you considered...", "Another approach...", "I was thinking...", "Maybe we could...", "An idea:..." |
| 用户提供替代方案/建议 | LEARNINGS.md (alternative) | LRN-YYYYMMDD-XXX | **中文**："或者..."、"也可以..."、"不如..."、"还不如..."、"其实可以..."、"另一种方式是..."；**英文**："Alternatively...", "Or we could...", "Another option...", "Instead..." |
| 重复模式检测 | LEARNINGS.md (simplify_and_harden) | LRN-YYYYMMDD-XXX | Pattern-Key 去重后 Recurrence-Count 递增 |

### 高级信号检测（上下文感知）

以下信号需要结合对话上下文判断，不仅仅是关键词匹配：

| 信号类型 | 场景示例 | 记录类别 | 说明 |
|----------|----------|----------|------|
| **用户质疑推理过程** | "你为什么会这么想？"、"你的依据是什么？" | correction/knowledge_gap | 可能暴露了 Agent 的假设错误或知识缺口 |
| **用户补充遗漏信息** | "还有一点你没考虑到..."、"别忘了..." | new_insight/completion | 用户提供了 Agent 遗漏的关键信息 |
| **用户指出边界条件** | "但这种情况呢？"、"如果...会怎么样？" | edge_case/best_practice | 发现了未被覆盖的边缘情况 |
| **用户分享经验教训** | "上次我们就这样踩坑了..."、"之前遇到过..." | lesson_learned/warning | 来自实际经验的宝贵知识 |
| **用户提出架构建议** | "是不是应该用..."、"我觉得这里设计得不好" | architectural_improvement | 涉及系统设计的改进建议 |
| **用户提供领域知识** | "在这个行业里通常..."、"按照规范应该..." | domain_knowledge | 特定领域的专业知识或规范 |

## 快速参考

| 场景 | 记录到 | ID 格式 |
|------|--------|----------|
| 用户纠正 AI（"不对"、"应该是..."、"你搞错了"） | LEARNINGS.md (correction) | LRN-YYYYMMDD-XXX |
| 命令执行失败/异常行为 | ERRORS.md | ERR-YYYYMMDD-XXX |
| 用户请求当前不支持的能力 | FEATURE_REQUESTS.md | FEAT-YYYYMMDD-XXX |
| 发现文档过时/知识缺口 | LEARNINGS.md (knowledge_gap) | LRN-YYYYMMDD-XXX |
| 发现更优方案/最佳实践 | LEARNINGS.md (best_practice) | LRN-YYYYMMDD-XXX |
| 用户说"记住这个"、"以后都这样" | LEARNINGS.md (user_explicit) | LRN-YYYYMMDD-XXX |
| 重复模式检测 | LEARNINGS.md (simplify_and_harden) | LRN-YYYYMMDD-XXX |

## 记录格式

### Learning 条目

```markdown
## [LRN-YYYYMMDD-XXX] category

**Logged**: ISO-8601 timestamp
**Priority**: low | medium | high | critical
**Status**: pending
**Area**: workflow | routing | spec | execute | review | archive | testing | prd | config

### Summary
一句话描述学到了什么

### Details
完整上下文：发生了什么、哪里错了、正确的应该是什么

### Suggested Action
具体的改进动作

### Metadata
- Source: conversation | error | user_feedback | discovery | simplify-and-harden
- Related Files: path/to/file.ext
- Tags: tag1, tag2
- See Also: LRN-20250110-001 (如有相关条目)
- Pattern-Key: stable pattern key (可选，用于重复模式追踪)
- Recurrence-Count: 1 (可选)
- First-Seen: 2025-01-15 (可选)
- Last-Seen: 2025-01-15 (可选)

---
```

### Error 条目

```markdown
## [ERR-YYYYMMDD-XXX] skill_or_command

**Logged**: ISO-8601 timestamp
**Priority**: high
**Status**: pending
**Area**: workflow | routing | spec | execute | review | archive | testing | prd | config

### Summary
简短描述什么失败了

### Error
```
实际错误信息或输出
```

### Context
- 尝试的命令/操作
- 使用的参数
- 环境信息

### Suggested Fix
如果可识别，可能的解决方案

### Metadata
- Reproducible: yes | no | unknown
- Related Files: path/to/file.ext
- See Also: ERR-20250110-001 (如重复出现)

---
```

### Feature Request 条目

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name

**Logged**: ISO-8601 timestamp
**Priority**: medium
**Status**: pending
**Area**: workflow | routing | spec | execute | review | archive | testing | prd | config

### Requested Capability
用户想要做什么

### User Context
为什么需要，解决什么问题

### Complexity Estimate
simple | medium | complex

### Suggested Implementation
如何实现，可能扩展到哪些地方

### Metadata
- Frequency: first_time | recurring
- Related Features: existing_feature_name

---
```

## 晋升规则

当学习条目满足以下**全部**条件时，晋升到工作流规则：

1. **Recurrence-Count >= 3**（出现至少 3 次）
2. **跨至少 2 个不同任务**
3. **在 30 天窗口期内**

### 晋升目标

| 学习类型 | 晋升到 | 示例 |
|----------|--------|------|
| 路由规则修正 | SKILL.md 路由表 | "含'只看代码'的请求优先 MAP 模式" |
| 规模评估修正 | SKILL.md 规模表 | "涉及公共接口的变更至少 M 级" |
| 铁律补充 | SKILL.md Hard Rules | "修改测试前必须先跑现有测试" |
| 阶段门禁强化 | SKILL.md 阶段门禁 | "PLAN 阶段必须包含回滚策略" |
| 工具映射更新 | SKILL.md 工具映射 | "新平台 X 的编辑工具名为 Y" |
| 别名补充 | references/entry/aliases.md | "新增 '搞一下' 作为 FAST 别名" |
| 测试策略 | references/testing/test-strategy-template.md | "API 测试必须包含 4xx/5xx 场景" |
| 审查规则 | references/special-modes/review.md | "Go 代码必须检查 defer 资源释放" |
| 调试策略 | references/superpowers/systematic-debugging/ | "先查日志再猜原因" |
| 工作流最佳实践 | 对应 references/ 目录 | 通用模式/模板/脚本 |

### 晋升格式

在目标文件中添加简洁的预防规则（不是冗长的事故报告）：

```markdown
## 来自 LRN-YYYYMMDD-XXX 的规则

**规则**: 一句话规则
**原因**: 简短理由
**来源**: LRN-YYYYMMDD-XXX
```

### 晋升后更新

在原学习条目中添加：

```markdown
### Resolution
- **Resolved**: 2025-01-16T09:00:00Z
- **Promoted To**: SKILL.md#Hard-Rules
- **Notes**: 已晋升为铁律 #11
```

并将 Status 改为 `promoted`。

## Pattern-Key 去重实操

用于检测重复出现的问题/模式，通过去重键追踪并在满足条件后晋升到工作流规则。

### 去重流程

1. **发现潜在重复**：当记录新条目时，先搜索是否已有相似条目
   - `grep -n "Pattern-Key: <stable_key>" .learnings/LEARNINGS.md`
   - `grep -r "关键词" .learnings/`
2. **匹配 Pattern-Key**：使用 `<domain>.<specific_pattern>` 格式的稳定键（如 `routing.read_only_trigger`、`scale.public_interface_change`）
3. **已找到**：
   - 递增 `Recurrence-Count`
   - 更新 `Last-Seen` 为当前日期
   - 添加 `See Also` 链接到相关条目
   - 若 Recurrence-Count >= 2，提升 Priority
4. **未找到**：
   - 创建新的 `LRN-...` 条目
   - 设置 `Pattern-Key: <domain>.<specific_pattern>`
   - 设置 `Recurrence-Count: 1`、`First-Seen` 和 `Last-Seen`

### 去重键设计原则

- **稳定**：键名应描述模式本身，而非某次具体事件
- **层次化**：`<领域>.<具体模式>`（如 `workflow.skip_spec`、`execute.timeout_large_suite`）
- **可搜索**：使用 `grep -n "Pattern-Key:" .learnings/LEARNINGS.md` 即可列出所有键

### 晋升规则（与主 SKILL.md 自我进化契约一致）

当满足以下**全部**条件时，将重复模式晋升到工作流规则文件：

- `Recurrence-Count >= 3`
- 在至少 2 个不同任务中出现
- 在 30 天窗口期内发生

将晋升的规则写为**简短的预防规则**（编码前/编码时要做什么），而不是长篇的事故报告。

## 技能提取

当学习足够通用、可跨项目复用时，提取为独立 Skill：

### 提取条件（满足任一即可）

| 条件 | 描述 |
|------|------|
| **Recurring** | 有 2+ 个 See Also 链接到相似问题 |
| **Verified** | Status 为 resolved 且有工作方案 |
| **Non-obvious** | 需要实际调试/调查才能发现 |
| **Broadly applicable** | 不限于特定项目，跨代码库有用 |
| **User-flagged** | 用户说"保存为技能"或类似表达 |

### 提取流程

#### 自动提取（推荐）

使用提供的辅助脚本：

```bash
# 干跑模式（查看将要创建的内容）
./scripts/extract-skill.sh skill-name --dry-run

# 实际创建技能
./scripts/extract-skill.sh skill-name

# 指定输出目录
./scripts/extract-skill.sh skill-name --output-dir ./references/superpowers/
```

#### 手动提取

如果更喜欢手动创建：

1. 在 `references/superpowers/` 下创建新目录 `skill-name/`
2. 使用 `assets/SKILL-TEMPLATE.md` 格式创建 SKILL.md
3. 填写内容，确保自包含
4. 更新原学习条目的 Status 为 `promoted_to_skill`，添加 `Skill-Path`
5. 在 reference-index.md 中添加索引

### 技能模板结构

完整的 SKILL.md 应包含以下部分：

```markdown
---
name: skill-name-here
description: "简洁描述何时以及为什么使用此技能。包含触发条件。"
---

# Skill Name

[简要介绍，解释此技能解决的问题及其来源]

## Quick Reference

| Situation | Action |
|-----------|--------|
| [触发条件 1] | [操作 1] |
| [触发条件 2] | [操作 2] |

## Background

[为什么此知识重要。它防止了什么问题。原始学习的上下文。]

## Solution

### Step-by-Step

1. 第一步（代码或命令）
2. 第二步
3. 验证步骤

### Code Example

\`\`\`language
// 示例代码演示解决方案
\`\`\`

## Common Variations

- **变体 A**：描述及处理方式
- **变体 B**：描述及处理方式

## Gotchas

- 警告或常见错误 #1
- 警告或常见错误 #2

## Related

- 相关文档链接
- 相关技能链接

## Source

从学习条目提取。
- **Learning ID**: LRN-YYYYMMDD-XXX
- **Original Category**: correction | insight | knowledge_gap | best_practice
- **Extraction Date**: YYYY-MM-DD
```

### 提取检测触发器

注意这些信号表明学习应该成为技能：

**对话中：**
- "保存为技能"
- "我总是遇到这个问题"
- "这对其他项目也有用"
- "记住这个模式"

**在学习条目中：**
- 多个 `See Also` 链接（重复问题）
- 高优先级 + resolved 状态
- Category: `best_practice` 且广泛适用
- 用户反馈称赞解决方案

### 技能质量门槛

提取前**必须**逐项验证，全部通过方可提取：

- [ ] 方案已测试且有效
- [ ] 描述清晰，无需原始上下文即可理解
- [ ] 代码示例自包含，可独立运行
- [ ] 无项目特定的硬编码值（端口、路径、密钥等）
- [ ] 遵循技能命名规范（小写、连字符）
- [ ] 来源学习条目已记录（Source Learning ID）

## 辅助脚本

### 自动提醒钩子 (activator.sh)

在每次任务完成后提醒 Agent 评估是否需要记录学习：

| 脚本 | 触发时机 | 用途 |
|------|----------|------|
| `scripts/self-improvement-activator.sh` | UserPromptSubmit | 提醒评估学习捕获 |
| `scripts/error-detector.sh` | PostToolUse (Bash) | 检测命令错误 |
| `scripts/extract-skill.sh` | 手动运行 | 从学习条目提取技能 |

### 钩子配置

**Claude Code / Trae 设置** (`.claude/settings.json`)：

```json
{
  "hooks": {
    "UserPromptSubmit": [{
      "matcher": "",
      "hooks": [{
        "type": "command",
        "command": "./scripts/self-improvement-activator.sh"
      }]
    }],
    "PostToolUse": [{
      "matcher": "Bash",
      "hooks": [{
        "type": "command",
        "command": "./scripts/error-detector.sh"
      }]
    }]
  }
}
```

详细配置见 `references/hooks-setup.md`。

## 定期回顾

在以下时机回顾 `.learnings/`：

- 开始新的大任务前
- 完成一个功能后
- 在有过往学习的区域工作时
- 用户要求查看学习记录时

### 与 ALTAS 检查点流程对齐

| ALTAS 阶段 | 回顾动作 |
|------------|----------|
| **REVIEW**（M/L 必须做） | 输出检查点时，自检是否有可捕获的学习（非显而易见的方案/错误/用户纠正），如有则记录到 .learnings/ |
| **ARCHIVE**（L 必须） | 归档前回顾本任务产生的学习条目，评估是否有满足晋升条件的条目，如有则晋升并更新条目状态 |
| **新任务首轮响应** | M/L 规模任务开始前，回顾 .learnings/ 中相关区域的过往学习（`grep -l "Area**: <当前区域>" .learnings/*.md`） |

### 快速状态检查

```bash
# 统计待处理条目
grep -h "Status\*\*: pending" .learnings/*.md | wc -l

# 列出高优先级待处理条目
grep -B5 "Priority\*\*: high" .learnings/*.md | grep "^## \["

# 查找特定区域的条目
grep -l "Area\*\*: workflow" .learnings/*.md
```

### 回顾操作

- 解决已修复的条目
- 晋升适用的学习
- 链接相关条目
- 升级重复出现的问题

## ID 生成

格式：`TYPE-YYYYMMDD-XXX`
- TYPE: `LRN` (learning), `ERR` (error), `FEAT` (feature)
- YYYYMMDD: 当前日期
- XXX: 序号或随机 3 字符（如 `001`, `A7B`）

示例：`LRN-20250419-001`, `ERR-20250419-A3F`, `FEAT-20250419-002`

## 解析条目

当问题已修复时，更新条目：

1. 将 `**Status**: pending` 改为 `**Status**: resolved`
2. 在 Metadata 后添加 resolution 块：

```markdown
### Resolution
- **Resolved**: 2025-01-16T09:00:00Z
- **Commit/PR**: abc123 or #42
- **Notes**: 简述做了什么
```

其他状态值：
- `in_progress` - 正在处理中
- `wont_fix` - 决定不处理（在 Resolution notes 中添加原因）
- `promoted` - 已晋升到 SKILL.md, AGENTS.md, 或对应规则文件
- `promoted_to_skill` - 已提取为可复用技能

## 重复模式检测

如果记录的内容与现有条目相似：

1. **先搜索**：`grep -r "keyword" .learnings/`
2. **链接条目**：在 Metadata 中添加 `**See Also**: ERR-20250110-001`
3. **提升优先级**（如果问题持续重复）
4. **考虑系统性修复**：重复问题通常表示：
   - 缺少文档（→ 晋升到 SKILL.md 或 aliases.md）
   - 缺少自动化（→ 添加到 SKILL.md 工作流）
   - 架构问题（→ 创建技术债务条目）

## 优先级指南

| 优先级 | 使用场景 |
|--------|----------|
| `critical` | 阻塞核心功能、数据丢失风险、安全问题 |
| `high` | 重大影响、影响常见工作流、重复出现的问题 |
| `medium` | 中等影响、有变通方案 |
| `low` | 小不便、边缘情况、锦上添花 |

## 区域标签

| 区域 | 范围 |
|------|------|
| `workflow` | 工作流路由、阶段、门禁 |
| `routing` | 触发词识别、模式选择 |
| `spec` | Spec 模板、格式、内容 |
| `execute` | 代码实现、工具使用 |
| `review` | 审查规则、质量标准 |
| `archive` | 知识沉淀、归档 |
| `testing` | 测试策略、框架、用例 |
| `prd` | PRD 分析、需求理解 |
| `config` | 配置、环境、设置 |

## 最佳实践

1. **立即记录** — 上下文最新鲜时记录
2. **具体明确** — 未来 Agent 需要快速理解
3. **包含复现步骤** — 特别是错误
4. **链接相关文件** — 使修复更容易
5. **建议具体修复** — 不只是"调查"
6. **使用一致分类** — 支持过滤
7. **积极晋升** — 有疑问就添加到对应规则文件
8. **定期回顾** — 过时的学习失去价值

## Gitignore 选项

**本地保留学习**（每个开发者）：
```gitignore
.learnings/
```

**在仓库中跟踪学习**（团队共享）：
不要添加到 .gitignore - 学习变成共享知识。

**混合模式**（跟踪模板，忽略条目）：
```gitignore
.learnings/*.md
!.learnings/.gitkeep
```

## ALTAS 特定示例

### 示例 1：路由规则修正

```markdown
## [LRN-20250419-001] correction

**Logged**: 2025-04-19T10:30:00Z
**Priority**: high
**Status**: promoted
**Promoted To**: SKILL.md#路由速查表
**Area**: routing

### Summary
用户说"只看代码"时应优先路由到 MAP 模式而非默认 Coding 流

### Details
当用户输入包含"只看代码"、"看看代码"、"阅读代码"等表达时，
我之前默认路由到了标准 Coding 流并开始准备写代码。
用户纠正说这种情况下应该进入 MAP 模式，只做代码分析和梳理，
不应该修改任何文件。

### Suggested Action
在 aliases.md 中添加"只看代码"系列表达作为 MAP 模式的强触发词。
在路由冲突判定树中增加"只读需求"的优先级判断。

### Metadata
- Source: user_feedback
- Related Files: references/entry/aliases.md, SKILL.md
- Tags: routing, map, read-only, trigger-word
- Pattern-Key: routing.read_only_trigger
- Recurrence-Count: 3
- First-Seen: 2025-04-15
- Last-Seen: 2025-04-19

### Resolution
- **Resolved**: 2025-04-19T11:00:00Z
- **Promoted To**: SKILL.md#路由速查表, references/entry/aliases.md
- **Notes**: 已添加"只看代码"系列到 MAP 触发词列表
```

### 示例 2：规模评估修正

```markdown
## [LRN-20250419-002] best_practice

**Logged**: 2025-04-19T14:22:00Z
**Priority**: medium
**Status**: pending
**Area**: workflow

### Summary
涉及公共 API 接口变更的任务至少应评估为 M 级

### Details
尝试将一个 API 接口变更任务评估为 S 级（1-2 文件），
但该接口被 5 个下游模块依赖。变更后需要：
1. 更新接口定义
2. 通知所有调用方适配
3. 编写迁移文档
4. 执行兼容性测试

实际上这是一个 M 级任务。

### Suggested Action
规模评估时，除了文件数，还要考虑：
- 影响面（有多少模块依赖）
- 是否是公共接口
- 是否需要协调多个团队/模块
- 是否需要向后兼容

涉及公共接口的变更至少按 M 评估。

### Metadata
- Source: error
- Related Files: src/api/interface.ts
- Tags: scale-assessment, api, public-interface
- Pattern-Key: scale.public_interface_change
- Recurrence-Count: 2
- First-Seen: 2025-04-17
- Last-Seen: 2025-04-19
```

### 示例 3：从错误提取的学习

```markdown
## [ERR-20250419-A3F] command_execution

**Logged**: 2025-04-19T09:15:00Z
**Priority**: high
**Status**: resolved
**Area**: execute

### Summary
RunCommand 执行 npm test 时超时导致任务中断

### Error
```
Command 'npm test' timed out after 300000ms (5 minutes)
Exit code: null
```

### Context
- Command: `npm test -- --coverage`
- 项目有 200+ 个测试用例
- 在 CI 环境中运行
- 未配置测试并行执行

### Suggested Fix
1. 对于大型测试套件，先运行特定测试文件：`npm test -- --grep "description"`
2. 配置测试并行执行（如 jest --maxWorkers=4）
3. 在 PLAN 阶段的 Test Strategy 中明确测试执行策略

### Metadata
- Reproducible: yes (大型测试套件)
- Related Files: package.json, jest.config.js
- See Also: ERR-20250418-B2C, ERR-20250417-X1Y
- Tags: timeout, testing, npm, execution

### Resolution
- **Resolved**: 2025-04-19T10:30:00Z
- **Commit/PR**: N/A - process improvement
- **Notes**: 已在 SKILL.md 测试策略部分添加"大型测试套件执行建议"
```

### 示例 4：晋升为技能的学习

```markdown
## [LRN-20250418-001] best_practice

**Logged**: 2025-04-18T11:00:00Z
**Priority**: high
**Status**: promoted_to_skill
**Skill-Path**: references/superpowers/docker-m1-fixes
**Area**: config

### Summary
Docker 构建在 Apple Silicon 上因平台不匹配失败

### Details
在 M1/M2 Mac 上构建 Docker 镜像时失败，因为基础镜像没有 ARM64 变体。
这是影响很多开发者的常见问题。

### Suggested Action
构建命令添加 `--platform linux/amd64`，或在 Dockerfile 中使用
`FROM --platform=linux/amd64 python:3.11-slim`。

### Metadata
- Source: error
- Related Files: Dockerfile
- Tags: docker, arm64, m1, apple-silicon
- See Also: ERR-20250415-A3F, ERR-20250417-B2D
- Pattern-Key: docker.arm64_build
- Recurrence-Count: 4
- First-Seen: 2025-04-12
- Last-Seen: 2025-04-18
```

## 多平台支持

此技能在不同 AI 编码 Agent 上均可工作，具有特定平台的激活机制。

### Claude Code / Trae

**激活**：钩子（UserPromptSubmit, PostToolUse）
**设置**：`.claude/settings.json` 与钩子配置
**检测**：通过钩子脚本自动

### Cursor / Qoder

**激活**：钩子（与 Claude Code 相同模式）
**设置**：`.cursor/settings.json` 或等效配置文件
**检测**：通过钩子脚本自动

### OpenAI Codex

**激活**：钩子（相同模式）
**设置**：`.codex/settings.json` 与钩子配置
**检测**：通过钩子脚本自动

### 无 Hook 支持的平台（Copilot Chat 等）

**激活**：在项目级指令文件中添加持久提醒（无需钩子脚本）
**设置**：在 `AGENTS.md` 或 `.github/copilot-instructions.md` 中添加自我改进提醒段落
**检测**：Agent 在任务完成后主动自检

在指令文件中添加：
```markdown
## 自我改进提醒
任务完成后，自检是否有可捕获的学习。如有，记录到 `.learnings/` 对应文件。
```

快捷提示语（可在对话中使用）：
- "记录到 learnings"
- "从这个方案提取技能"
- "检查 .learnings/ 中是否有相关问题"

### Agent 无关指导

无论使用哪个 Agent，在以下情况应用自我改进：

1. **发现非显而易见的东西** - 解决方案不是立即可得的
2. **纠正自己** - 最初的方法是错的
3. **学习项目约定** - 发现未记录的模式
4. **遇到意外错误** - 特别是诊断困难的情况
5. **找到更好的方法** - 改进了原始解决方案

## 相关资源

- **主入口**：SKILL.md（自我进化契约章节）
- **别名词典**：references/entry/aliases.md
- **快速入门**：QUICKSTART.md
- **完整索引**：reference-index.md
- **示例**：references/self-improvement/references/examples.md
- **钩子配置**：references/self-improvement/references/hooks-setup.md

---

## TRAE IDE 快速操作指南

> 🎯 **面向 Agent 的快速参考卡片** - 在 TRAE IDE 中使用自我改进机制时的速查表

### 一键命令速查

| 操作 | 命令 | 说明 |
|------|------|------|
| **记录用户纠正** | 追加到 `.learnings/LEARNINGS.md` | category=`correction`, Priority=`high` |
| **记录错误** | 追加到 `.learnings/ERRORS.md` | 包含错误信息和上下文 |
| **记录功能请求** | 追加到 `.learnings/FEATURE_REQUESTS.md` | 描述用户需求和使用场景 |
| **记录新思路** | 追加到 `.learnings/LEARNINGS.md` | category=`new_insight` 或 `alternative` |
| **回顾学习** | `grep -l "Area**: <区域>" .learnings/*.md` | 查找相关区域的学习条目 |
| **统计状态** | `grep -h "Status\*\*: pending" .learnings/*.md \| wc -l` | 统计待处理条目数 |
| **提取技能** | `./scripts/extract-skill.sh <name>` | 从学习提取为可复用技能 |

### 30 秒快速记录模板

#### 用户纠正（最常见）

```markdown
## [LRN-$(date +%Y%m%d)-NNN] correction

**Logged**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Priority**: high
**Status**: pending
**Area**: <workflow|routing|spec|execute|review|...>

### Summary
<一句话：用户纠正了什么>

### Details
<完整上下文：我最初怎么想的，用户怎么说，正确的应该是什么>

### Suggested Action
<以后遇到类似情况应该怎么做>

### Metadata
- Source: user_feedback
- Related Files: <相关文件路径>
- Tags: <标签1>, <标签2>
- Pattern-Key: <领域>.<具体模式>  # 可选，用于去重追踪

---
```

#### 错误记录

```markdown
## [ERR-$(date +%Y%m%d)-XXX] <简短描述>

**Logged**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Priority**: <high|medium|low>
**Status**: pending
**Area**: <execute|config|testing|infra>

### Summary
<什么失败了>

### Error
```
<粘贴实际错误信息>
```

### Context
- Command: <执行的命令>
- Environment: <环境信息>

### Metadata
- Reproducible: <yes|no|unknown>
- Related Files: <相关文件>

---
```

#### 新思路/方案

```markdown
## [LRN-$(date +%Y%m%d)-NNN] new_insight

**Logged**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Priority**: medium
**Status**: pending
**Area**: <相关领域>

### Summary
<用户新方案的核心思想>

### Details
<用户的建议是什么，为什么有价值，适用于什么场景>

### Evaluation
- **是否采用**: <是/否/待定>
- **采用原因**: <如果采用了>
- **未采用原因**: <如果没采用，为什么记录下来>

### Metadata
- Source: user_suggestion
- Tags: <标签>

---
```

### 常见场景 Checklist

在以下场景时，**必须**考虑记录学习：

- [ ] 用户说了"不对"、"错了"、"不是这样"
- [ ] 命令执行失败且错误非显而易见
- [ ] 用户提供了我没想到的方案或角度
- [ ] 我发现了比当前实现更好的方法
- [ ] 文档与实际行为不符
- [ ] 遇到了需要调查才能解决的问题
- [ ] 用户说"记住这个"、"保存下来"
- [ ] 任务完成后回顾时发现可复用的模式

### 晋升快速检查

当 Recurrence-Count >= 2 时，开始准备晋升：

1. ✅ 确认 Pattern-Key 稳定且准确
2. ✅ 确认跨至少 2 个不同任务出现
3. ✅ 确认在 30 天窗口期内
4. ✅ 准备晋升内容（简洁规则，非长篇报告）
5. ✅ 选择正确的晋升目标文件
6. ✅ 更新原条目 Status 为 `promoted`
7. ✅ 在目标文件中添加来源引用

### 与 TodoWrite 配合使用

当需要记录学习时：

1. **创建任务**：
   ```
   TodoWrite: 添加任务 "记录学习 [LRN-YYYYMMDD-XXX] - 用户纠正：XXX"
   ```

2. **执行记录**：追加到对应的 .learnings/*.md 文件

3. **完成任务**：
   ```
   TodoWrite: 标记该任务为 completed
   ```

4. **如需晋升**：创建新任务 "晋升 LRN-XXX 到 SKILL.md"

### 故障排查

| 问题 | 可能原因 | 解决方案 |
|------|----------|----------|
| Hook 不触发 | `.claude/settings.json` 不存在或路径错误 | 检查文件是否存在，路径是否正确 |
| error-detector 无输出 | 环境变量未设置 | 脚本已支持 stdin 输入作为后备 |
| 记录格式不一致 | 未使用标准模板 | 使用本指南中的快速模板 |
| 找不到历史学习 | Area 标签不匹配 | 尝试 grep 关键词而非 Area |
| 晋升条件不满足 | Recurrence-Count 不足 | 继续积累，等待时机 |

### 最佳实践提醒

✅ **立即记录** - 上下文最新鲜时记录效果最好  
✅ **具体明确** - 未来 Agent 需要快速理解并应用  
✅ **包含复现步骤** - 特别是对于错误条目  
✅ **链接相关文件** - 使后续修复更容易  
✅ **建议具体修复** - 不只写"调查"，要给出方向  
✅ **使用一致分类** - 支持按类别过滤和统计  
✅ **积极晋升** - 有疑问就提升到对应规则文件  
✅ **定期回顾** - 过时的学习会失去价值  

❌ **不要拖延** - "稍后记录"通常等于"永远不会记录"  
❌ **不要争辩** - 用户纠正时立即接受并记录  
❌ **不要遗漏** - 即使是小改进也值得记录  
❌ **不要冗长** - 保持简洁，重点突出

# Self-Improvement 参考文档

> ALTAS Workflow 自我进化机制：记录 → 总结 → 晋升 → 进化。
> 核心原则：每次任务完成后自检，发现非显而易见的知识必须记录；满足条件的经验必须晋升到工作流规则。

## 触发信号

只需关注 3 类信号：

| 信号 | 动作 | 记录到 |
|------|------|--------|
| **用户纠正**（"不对"、"应该是"、"搞错了"） | 立即记录，不要争辩 | `.learnings/LEARNINGS.md` |
| **命令/操作失败**（非零退出码、异常、超时） | 记录错误上下文和解决方案 | `.learnings/ERRORS.md` |
| **新发现/更优方案**（用户思路、最佳实践、知识缺口） | 记录方案和适用场景 | `.learnings/LEARNINGS.md` |

其他信号（功能请求、文档过时等）按需记录到 `.learnings/FEATURE_REQUESTS.md`。

## 记录格式

### 最小记录格式（4 个必填字段）

```markdown
## [LRN-YYYYMMDD-XXX] category

**Summary**: 一句话描述学到了什么
**Category**: correction | best_practice | new_insight | knowledge_gap | user_explicit
**Action**: 以后遇到类似情况应该怎么做
**Source**: user_feedback | error | discovery | conversation

---

### 可选扩展字段（按需添加）

- **Details**: 完整上下文（发生了什么、哪里错了、正确的应该是什么）
- **Related Files**: path/to/file.ext
- **Tags**: tag1, tag2
- **See Also**: LRN-YYYYMMDD-XXX
```

### Error 条目

```markdown
## [ERR-YYYYMMDD-XXX] skill_or_command

**Summary**: 什么失败了
**Category**: command_failure | timeout | build_failure | test_failure
**Action**: 可能的解决方案
**Source**: error

**Error**:
\```
实际错误信息
\```

**Context**: 尝试的命令/操作、环境信息

---
```

### Feature Request 条目

```markdown
## [FEAT-YYYYMMDD-XXX] capability_name

**Summary**: 用户想要做什么
**Category**: missing_capability
**Action**: 如何实现，可能扩展到哪些地方
**Source**: user_request

---
```

## 晋升规则

当学习条目满足以下条件时，晋升到工作流规则：

- **重复出现 ≥3 次**（跨 ≥2 个不同任务）
- **在 30 天窗口期内**
- **晋升方式**：用户手动触发，或 Agent 在 REVIEW 阶段提议晋升

### 晋升目标

| 学习类型 | 晋升到 |
|----------|--------|
| 路由/触发词修正 | SKILL.md 路由表 或 `references/entry/aliases.md` |
| 规模评估修正 | SKILL.md 规模评估表 |
| 铁律/门禁补充 | SKILL.md Hard Rules 或阶段门禁 |
| 测试策略强化 | `references/testing/` 对应文件 |
| 审查规则强化 | `references/special-modes/review.md` |
| 调试策略强化 | `references/superpowers/systematic-debugging/` |
| 通用最佳实践 | 对应 `references/` 子目录 |

### 晋升格式

在目标文件中添加简洁的预防规则：

```markdown
## 来自 LRN-YYYYMMDD-XXX 的规则

**规则**: 一句话规则
**原因**: 简短理由
**来源**: LRN-YYYYMMDD-XXX
```

晋升后，在原学习条目中添加 `**Status**: promoted` 和 `**Promoted To**: 目标文件路径`。

## 技能提取

当学习足够通用（跨项目复用、非显而易见、已验证）时，提取为独立 Skill 到 `references/superpowers/` 或新建目录。

### 提取条件（满足任一即可）

- 有 2+ 个 See Also 链接到相似问题
- Status 为 resolved 且有工作方案
- 不限于特定项目，跨代码库有用
- 用户说"保存为技能"

### 提取流程

1. 在 `references/superpowers/` 下创建新目录 `skill-name/`
2. 使用 `assets/SKILL-TEMPLATE.md` 格式创建 SKILL.md
3. 填写内容，确保自包含
4. 更新原学习条目 Status 为 `promoted_to_skill`
5. 在 reference-index.md 中添加索引

也可使用脚本：`./scripts/extract-skill.sh skill-name`

## ID 生成

格式：`TYPE-YYYYMMDD-XXX`
- TYPE: `LRN` (learning), `ERR` (error), `FEAT` (feature)
- YYYYMMDD: 当前日期
- XXX: 序号（如 `001`）

## 定期回顾

| 时机 | 动作 |
|------|------|
| 开始新的大任务前 | 回顾 `.learnings/` 中相关区域的过往学习 |
| REVIEW 阶段（M/L 必须） | 自检是否有可捕获的学习 |
| ARCHIVE 阶段（L 必须） | 评估是否有满足晋升条件的条目 |

### 快速状态检查

```bash
grep -h "Status\*\*: pending" .learnings/*.md | wc -l
grep -B5 "Category\*\*: correction" .learnings/*.md | grep "^## \["
```

## 辅助脚本

| 脚本 | 触发时机 | 用途 |
|------|----------|------|
| `scripts/self-improvement-activator.sh` | UserPromptSubmit | 提醒评估学习捕获 |
| `scripts/error-detector.sh` | PostToolUse (Bash) | 检测命令错误 |
| `scripts/extract-skill.sh` | 手动运行 | 从学习条目提取技能 |

### 钩子配置（Claude Code / Trae）

```json
{
  "hooks": {
    "UserPromptSubmit": [{
      "matcher": "",
      "hooks": [{ "type": "command", "command": "./scripts/self-improvement-activator.sh" }]
    }],
    "PostToolUse": [{
      "matcher": "Bash",
      "hooks": [{ "type": "command", "command": "./scripts/error-detector.sh" }]
    }]
  }
}
```

详细配置见 `references/self-improvement/references/hooks-setup.md`。

## 多平台支持

| 平台 | 激活方式 | 设置 |
|------|---------|------|
| Claude Code / Trae | Hook 自动 | `.claude/settings.json` |
| Cursor / Qoder | Hook 自动 | `.cursor/settings.json` |
| OpenAI Codex | Hook 自动 | `.codex/settings.json` |
| 无 Hook 的平台 | 指令文件提醒 | `AGENTS.md` 中添加自我改进提醒段落 |

## 最佳实践

✅ 立即记录 — 上下文最新鲜时记录效果最好
✅ 具体明确 — 未来 Agent 需要快速理解并应用
✅ 建议具体修复 — 不只写"调查"，要给出方向
✅ 积极晋升 — 有疑问就提升到对应规则文件

❌ 不要拖延 — "稍后记录"通常等于"永远不会记录"
❌ 不要争辩 — 用户纠正时立即接受并记录
❌ 不要冗长 — 保持简洁，重点突出

## 相关资源

- **主入口**：SKILL.md（自我进化契约章节）
- **别名词典**：references/entry/aliases.md
- **快速入门**：QUICKSTART.md
- **完整索引**：reference-index.md
- **示例**：references/self-improvement/references/examples.md
- **钩子配置**：references/self-improvement/references/hooks-setup.md

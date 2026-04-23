# Code Review 参考索引

> **入口强制**：所有代码审查任务**必须**先通过 `receiving-code-review/SKILL.md` 进入。
> **完整流程**：`receiving-code-review` → 识别代码语言 → `code-review/python` 或 `code-review/go` → `implementation-verify`

## 目录说明

| 文件/目录 | 用途 |
|-----------|------|
| `go/` | Go 代码审查专项（静态分析、并发安全、性能审计、错误处理规范） |
| `python/` | Python 代码审查专项（类型安全、异步模式、错误处理、代码风格） |
| `code-reviewer.md` | 通用代码审查 Agent 模板（语言无关，适用于未被上述专项覆盖的场景） |

## 调用关系

```
用户请求代码审查
    ↓
receiving-code-review/SKILL.md（入口：验证反馈合理性、识别语言）
    ↓
语言识别
    ├─ Go  → code-review/go/SKILL.md
    └─ Python → code-review/python/SKILL.md
    ↓
implementation-verify/SKILL.md（实现与 Spec 一致性校验）
```

## 注意事项

- `code-reviewer.md` 是通用模板，与 `requesting-code-review/code-reviewer.md` 职责不同：
  - `code-review/code-reviewer.md`：通用审查 Agent 定义，用于未被 Go/Python 专项覆盖的场景
  - `requesting-code-review/code-reviewer.md`：配套 `requesting-code-review` 的审查 Agent 模板

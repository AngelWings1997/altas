# Entry Contract 详细规则

> 本文件从 `SKILL.md` 迁出，保持入口精简。需要完整工具映射或路由冲突判定时按需加载。

## 工具映射规则

### 核心原则

- **检索与分析**：必须使用宿主平台的原生检索/读取工具（例如 `SearchCodebase`, `Grep`, `Glob`, `Read`）进行代码探索，禁止猜测文件内容。
- **修改与落盘**：必须使用宿主平台的原生文件编辑工具（例如 `Write`, `Edit`, `SearchReplace`, `apply_patch` 或等价能力）进行代码与文档修改，严禁使用 `sed`/`awk`/`echo` 等 Shell 命令绕过原生工具写文件。
- **执行与验证**：使用 `RunCommand` 执行构建、测试或启动服务。
- **计划与跟踪**：复杂任务必须使用 `TodoWrite` 进行任务分解与状态跟踪。

### 平台工具映射表

若宿主平台工具名不同，按下表映射到等价能力执行：

| 能力 | Cursor / Trae / Qoder | Claude Code | OpenAI Codex |
|------|----------------------|-------------|-------------|
| 代码检索 | `SearchCodebase` / `Grep` | `Skill` (search) | 平台内置搜索 |
| 读取文件 | `Read` / `Glob` | `Read` / `Glob` | 平台内置读取 |
| 编辑文件 | `Edit` / `Write` | `Edit` / `Write` | 平台内置编辑 |
| 执行命令 | `Bash` / `RunCommand` | `Bash` | 平台内置终端 |
| 任务跟踪 | `TodoWrite` | `TodoWrite` | 文本 Checklist |

若上表未覆盖，读取 `references/superpowers/using-superpowers/SKILL.md` 及其 `references/superpowers/using-superpowers/references/copilot-tools.md`（Copilot CLI）/ `references/superpowers/using-superpowers/references/codex-tools.md`（Codex）获取完整映射。

## 只读纪律

- `MAP` / `PROJECT MAP` / `REVIEW` 相关 / `REVIEW SPEC` / `REVIEW EXECUTE` 默认是只读路由。
- `DEBUG` / `DOC` / `ARCHIVE` 分析阶段只读，产出阶段允许写文件。
- 只读任务完成分析、CodeMap 或报告后暂停，等待用户决定是否进入编码流。

## 能力降级

- 不支持 Subagent / 并行 Agent / Todo 面板时，自动降级为单会话 + 原子 Checklist + 常规检查点。
- 工具缺失不应阻塞主流程，但必须明确说明降级行为。

## 规则合并

- 本 Skill 负责工程工作流路由与门禁，不负责覆盖宿主平台的系统安全规则。
- 若与宿主平台规则、项目规则或安全约束冲突，优先遵守更严格、更保守的规则。

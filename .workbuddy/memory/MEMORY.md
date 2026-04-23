# 项目长期记忆

## ALTAS Workflow 项目

### 项目背景
- 路径：`/Users/litianyi/trae/altas/altas-workflow`
- 目标：构建具备自我进化能力的 Agent 工作流系统
- 当前版本：v4.11
- 用户偏好：proposal-first 模式，先呈现方案、等待确认后再执行文件修改

### 已知问题（待修复）

#### 高优先级（影响 AI Agent 正确加载或版本一致性）
1. `find-polluter.sh` 悬空引用（`root-cause-tracing.md:101,104`）
2. `skills/brainstorming/` 旧式路径（`brainstorming/SKILL.md:164`）
3. `skills/self-improvement/scripts/` 旧式路径（10 处，`hooks-setup.md`）
4. `../../altas-workflow/` 跨目录路径（5 处，`docs/` 下）
5. README.md MD 总数 149→141
6. README.md special-modes 计数 5→7
7. `first-response.md` 版本号 v4.8→v4.11

#### 中优先级
8. README.md 目录树多处统计数字不符（entry 5→7, prd-analysis 6→7, testing 18+→21, agents 22→14）
9. `references/code-review/` 下缺少 `README.md`
10. docs 方法论文档中示例引用需标注（`log_change.py`, `AI_CHANGELOG.md`, `docs/skills/SKILL.md`）

### 工作流约定
- 用户要求 proposal-first：任何文件修改前必须先呈现方案，等待用户确认
- 用户强调头脑风暴在 M/L 规模任务中必须严格执行
- 使用中文沟通

### 评审历史
- 2026-04-23：第四轮评审，评级 A，发现 6 项高优先级 + 6 项中优先级问题
- 2026-04-24：第五轮评审，评级 A-，确认上一轮 3 项已修复，6 项未修复，新增 5 项问题
- 2026-04-24：第六轮评审+修复，评级 A，发现 README.md 版本号标注错误（v4.8→v4.11），已修复，待修复问题清零

# ALTAS Workflow

> **融合三方优势 | 智能深度适配 | 渐进式披露 | 每步可反馈**

---

## 🎯 这是什么？

**ALTAS Workflow** 是一套综合性 AI 原生研发工作流规范，融合了 **SDD-RIPER**、**SDD-RIPER-Optimized (Checkpoint-Driven)** 与 **Superpowers** 三大优秀工作流的精华。

### 核心使命

致力于解决 AI 编程中的四大工程痛点：

| 痛点 | ALTAS 解法 |
|------|-----------|
| **上下文腐烂** | CodeMap 索引 + 渐进式披露，按需加载参考资料 |
| **审查瘫痪** | 4 级智能深度 (XS/S/M/L)，小任务不卡审批 |
| **代码不信任** | Spec 中心论 + 三轴评审，Spec is Truth |
| **难以维护** | Archive 知识沉淀 + TDD 铁律，完成即资产 |

---

## 📦 包含什么？

```
altas/
├── altas-workflow/         # 主协议目录
│   ├── SKILL.md          # ⭐ 核心系统提示词 (AI 读取)
│   ├── README.md         # ALTAS 详细说明
│   ├── QUICKSTART.md     # 场景化快速指南
│   ├── reference-index.md # 参考资料总索引
│   ├── protocols/        # 专用协议 (严格模式/双模型/文档专家)
│   ├── docs/             # 方法论文档 (4 篇)
│   ├── references/       # 按需加载的参考资料 (50+ 文件)
│   │   ├── spec-driven-development/  # Spec 驱动开发
│   │   ├── checkpoint-driven/        # Checkpoint 轻量模式
│   │   ├── superpowers/              # 超级能力 (TDD/Debug/Subagent)
│   │   └── agents/                   # Agent 定义
│   ├── skills/           # 独立 Skill 定义 (标准版/轻量版)
│   └── scripts/          # 自动化工具 (Archive 构建器)
```

---

## 🚀 如何快速使用？

### 30 秒安装

**方法 1**: 复制 `altas-workflow/SKILL.md` 内容到 AI 助手的 Custom Instructions

**方法 2**: 在 Cursor/Trae 中运行：
```bash
cp altas-workflow/SKILL.md .cursorrules
```

**方法 3**: 项目配置
```bash
mkdir -p mydocs/{codemap,context,specs,micro_specs,archive}
```

---

### 立即使用

**极速修改 (Size XS)**:
```
>> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5
```

**小任务 (Size S)**:
```
FAST: 为登录接口添加图形验证码
```

**标准开发 (Size M)**:
```
sdd_bootstrap: task=用户注册接口添加防刷功能，goal=安全性提升
```

**架构重构 (Size L)**:
```
DEEP: 重构认证模块拆分为独立微服务
```

**Bug 排查**:
```
DEBUG: log_path=./logs/error.log, issue=审批通过后未获得授权
```

**多项目协作**:
```
MULTI: task=前后端联动发布新功能
```

---

## 📚 核心命令

| 命令 | 用途 | 适用规模 |
|------|------|----------|
| `>>` / `FAST` | 快速通道，跳过 Research/Plan | XS/S |
| `sdd_bootstrap` | 启动 RIPER 流程 | M/L |
| `create_codemap` | 生成代码地图 | M/L |
| `MAP` / `PROJECT MAP` | 只读分析项目 | 所有 |
| `DEBUG` | 系统调试模式 | - |
| `MULTI` | 多项目协作 | L |
| `ARCHIVE` | 知识沉淀 | L |
| `DOC` | 文档专家模式 | - |
| `REVIEW SPEC` | 执行前评审 | M/L |
| `REVIEW EXECUTE` | 执行后三轴审查 | M/L |

---

## 🏗️ 工作流阶段

### Size M (标准) 流程
```
Research ──→ Plan ──→ Execute(TDD) ──→ Review ──→ Verification
    ↓            ↓           ↓            ↓            ↓
 Spec 初稿    任务清单    失败测试     三轴评审     验证证据
```

### Size L (深度) 流程
```
Research ──→ Innovate ──→ Plan ──→ Execute(TDD+Subagent) ──→ Review ──→ Archive
    ↓            ↓           ↓              ↓              ↓           ↓
 Spec 初稿    方案对比    任务清单    并行实现 + 两阶段审查   三轴评审   知识沉淀
```

---

## ⚡ 智能深度适配

| 规模 | 触发条件 | Spec 要求 | 工作流 | 典型场景 |
|------|----------|----------|--------|----------|
| **XS (极速)** | typo、配置值、<10 行 | 跳过，事后 1 行 summary | 直接执行→验证→summary | 改配置、修 typo、日志 |
| **S (快速)** | 1-2 文件，逻辑清晰 | micro-spec (1-3 句) | micro-spec→批准→执行→回写 | 加参数、简单功能 |
| **M (标准)** | 3-10 文件，模块内 | 轻量 Spec 落盘 | Research→Plan→Execute(TDD)→Review | 新增接口、模块重构 |
| **L (深度)** | 跨模块、>500 行、架构级 | 完整 Spec + Innovate + Archive | Research→Innovate→Plan→Execute→Subagent→Review→Archive | 架构拆分、跨团队改造 |

### 自动升降级

- 执行中发现复杂度超出预期 → AI 立即暂停，提议升级
- 用户随时可用 `[升级为 M]` / `[降级为 S]` 调整

---

## 🛡️ 质量铁律

| # | 铁律 | 含义 |
|---|------|------|
| 1 | **No Spec, No Code** | 未形成最小 Spec 前不写代码 (Size XS 豁免) |
| 2 | **No Approval, No Execute** | Plan 阶段人类不点头，绝不写代码 |
| 3 | **Spec is Truth** | Spec 与代码冲突时，代码是错的 |
| 4 | **Reverse Sync** | 执行中发现偏差→先更新 Spec→再修代码 |
| 5 | **Evidence First** | 完成由验证结果证明，非模型自宣布 |
| 6 | **No Root Cause, No Fix** | Bug 修复前必须有根因分析，禁止盲改 |
| 7 | **TDD Iron Law** | Size M/L: 无失败测试不写生产代码 |
| 8 | **Resume Ready** | 长任务暂停前在 Spec 中留恢复锚点 |

---

## 🎯 进度可视化系统

**每个步骤完成后**，AI 必须输出标准化检查点：

```markdown
### 进度 [Phase ▸ Step]
[已完成] ▸ **[当前]** ▸ [下一步] ▸ [后续...]

### 当前成果
- 刚完成了什么（具体产出）

### 预期产出
- 下一步将会产出什么

### 下一步操作
- **[继续/Approved]**: 同意，进入下一步
- **[修改]** + 意见：调整当前成果
- **[升级为 X]** / **[降级为 X]**: 调整规模
```

---

## 📖 详细文档

### 核心文档
- [ALTAS Workflow 详细说明](altas-workflow/README.md)
- [快速启动指南](altas-workflow/QUICKSTART.md)
- [参考资料总索引](altas-workflow/reference-index.md)

### 方法论文档
- [从传统编程转向大模型编程](altas-workflow/docs/从传统编程转向大模型编程.md)
- [AI 原生研发范式：从代码中心到文档驱动的演进](altas-workflow/docs/AI-原生研发范式 - 从代码中心到文档驱动的演进.md)
- [团队落地指南](altas-workflow/docs/团队落地指南.md)
- [如何快速从零开始落地大模型编程 -- 手把手教程](altas-workflow/docs/如何快速从零开始落地大模型编程%20--%20手把手教程.md)

### 专用协议
- [RIPER-5 严格模式](altas-workflow/protocols/RIPER-5.md)
- [双模型协作协议](altas-workflow/protocols/SDD-RIPER-DUAL-COOP.md)
- [文档专家协议](altas-workflow/protocols/RIPER-DOC.md)

### 技能包
- [SDD-RIPER-ONE 标准版](altas-workflow/references/agents/sdd-riper-one/SKILL.md)
- [SDD-RIPER-ONE Light 轻量版](altas-workflow/references/agents/sdd-riper-one-light/SKILL.md)

---

## 🤝 来源整合

| 来源 | 采纳的核心优势 |
|------|---------------|
| **SDD-RIPER** | Spec 中心论、RIPER 状态机、三轴 Review、Multi-Project 自动发现、Debug/Archive 协议 |
| **SDD-RIPER-Optimized** | Checkpoint-Driven 轻量模式、4 级任务深度 (zero/fast/standard/deep)、Done Contract、Resume Ready、Hot/Warm/Cold上下文装配 |
| **Superpowers** | TDD 铁律与反模式、系统化 Debug 四阶段法、Subagent 驱动 + 两阶段 Review、并行 Agent 派遣、验证优先铁律、Rationalization 预防表 |

---

## 🎓 典型使用场景

### 场景一：日常功能迭代 (Size M)
```
你输入：sdd_bootstrap: task=为用户注册接口添加图形验证码防刷功能，goal=安全性提升

AI 行为:
1. 自动评估规模 → Size M (Standard)
2. Research → 读取现有注册接口，发现没有图形库依赖 → 输出检查点
3. Plan → 列出 Checklist（引入库→改接口→加测试）→ 输出检查点等 [Approved]
4. Execute → TDD: 先写失败测试→实现逻辑→验证通过
5. Review → 三轴评审 → 确认通过
```

### 场景二：紧急修复线上配置 (Size XS)
```
你输入：>> 将 src/config.ts 中的 MAX_RETRIES 从 3 改为 5

AI 行为:
1. 识别为 Size XS (极速)
2. 直接修改代码→运行验证→1 行 summary
```

### 场景三：架构重构 (Size L)
```
你输入：DEEP: 重构认证模块拆分为独立微服务

AI 行为:
1. 识别为 Size L (深度)
2. create_codemap → 生成认证模块代码索引
3. Research → 梳理现状链路，标识风险
4. Innovate → 给出 3 种方案（服务化/模块化/网关层）对比
5. Plan → 原子 Checklist + Subagent 分配
6. Execute → TDD 驱动 + Subagent 并行实现 + 两阶段 Review
7. Review → 三轴评审 + Archive 沉淀
```

### 场景四：Bug 排查
```
你输入：DEBUG: log_path=./logs/error.log, issue=审批通过后未获得授权

AI 行为:
1. 进入 Debug 模式（只读分析）
2. 读取日志+Spec+CodeMap → 三角定位
3. 输出：症状/预期行为/根因候选/建议修复
4. 如需修复 → 进入 RIPER 流程或 FAST
```

### 场景五：多项目协作
```
你输入：MULTI: task=前后端联动发布功能

AI 行为:
1. 自动扫描 workdir → 发现 web-console + api-service
2. 输出 Project Registry 请确认
3. 生成双项目 codemap
4. Plan 按项目分组：api-service(Provider)→web-console(Consumer)
5. 执行按依赖顺序，记录 Contract Interfaces
```

---

## 📊 规模评估速查

| 信号 | 推荐规模 |
|------|----------|
| "改个 typo" | XS |
| "加个配置项" | XS |
| "改个按钮文案" | XS/S |
| "这个接口加个参数" | S |
| "给这个函数加错误处理" | S |
| "新增一个 CRUD 接口" | M |
| "重构这个模块" | M/L |
| "跨模块改数据模型" | L |
| "架构级重构" | L |
| "前后端联动" | L (MULTI) |

---

## 🔧 常见问题 (FAQ)

**Q: AI 一次性输出太多代码，跑完所有步骤怎么办？**

A: ALTAS 内置检查点机制，AI 完成一步后**必须**暂停等确认。如果 AI 暴走，回复："请停止，严格执行检查点机制，每次只推进一步。"

**Q: 为什么 AI 总是先写测试？太慢了。**

A: 这是 Evidence First + TDD 铁律。没有失败测试，AI 生成的代码可能没被执行过。如果任务极简，用 `>>` 触发 XS 模式跳过 TDD。

**Q: 如何中途干预 AI 的计划？**

A: 在任意检查点回复 `[修改] 请不要使用 Redis，改为内存缓存`，AI 会根据反馈调整 Plan 后重新请求 Approve。

**Q: mydocs/下太多 md 文件，要提交 Git 吗？**

A: 强烈建议提交。Spec 和 Archive 是项目的唯一真相源，防止上下文腐烂，帮助新人接手。

**Q: 如何选择 XS/S/M/L？**

A: ALTAS 会自动评估。你也可以强制指定：`>>`=XS, `FAST`=S, 默认=M, `DEEP`=L。执行中可随时 `[升级为 M]` 或 `[降级为 S]`。

**Q: 参考资料 (references/) 太多，AI 每次都要全部读取吗？**

A: 不需要。ALTAS 采用渐进式披露，只在命中场景时按需读取对应文件。SKILL.md 中的参考索引表明确了每个文件的调用时机。

---

## 版本

- **v4.0**: 2026-04-13 (ALTAS Workflow)
- **v1.0**: 2026-04-12 (SIGMA Workflow, 已废弃)

---

*Powered by the integration of SDD-RIPER, SDD-RIPER-Optimized (Checkpoint-Driven), and Superpowers.*

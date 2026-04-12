# Altas Workflow

> **融合三方优势 | 智能深度适配 | 渐进式披露 | 每步可反馈**

## 快速开始

### 🚀 极速启动命令

```bash
# 零Spec模式 - 直接执行（typo/配置/日志修改）
>> 修复登录页错别字

# 标准启动 - 描述任务
sdd_bootstrap: task=实现用户注册功能, goal=支持邮箱+验证码

# 深度启动 - 复杂任务
sdd_bootstrap: task=微服务拆分, mode=deep, projects=[api,web,admin]

# 代码理解
MAP: scope=认证模块, mode=feature
PROJECT MAP: scope=整个后端
```

## 三种深度模式

| 模式 | 触发 | 代码量 | 特点 |
|------|------|--------|------|
| **Zero** | `>>` 前缀 | <10行 | 直接执行→同步Spec |
| **Fast** | `FAST`/`快速` | <100行 | 最小Spec→执行→Review |
| **Standard** | 默认 | 100-1000行 | Research→Plan→Execute→Review |
| **Deep** | `deep`/`深度` | >1000行 | 完整流程+Innovate+Archive |

## 核心优势

### 1. 智能深度适配
自动评估项目大小，选择不同深度的工作流：
- 小改动用 Zero/Fast 模式，速度优先
- 中型功能用 Standard 模式，平衡速度和质量
- 复杂架构用 Deep 模式，质量优先

### 2. 每步执行后提供下一步提示
每个阶段完成都会输出：
```
💡 下一步选项:
[A] 回复 "继续" → ...
[B] 回复 "批准" → ...
[C] 回复 "修改" → ...
```

### 3. 渐进式披露
- 不一次性展示所有内容
- 按阶段逐步展开
- 按需加载信息

### 4. 快速启动示例

**示例1: 简单修改**
```
>> 把登录按钮颜色改成绿色
```
→ 极速完成

**示例2: 功能开发**
```
sdd_bootstrap: task=实现图片上传, goal=支持拖拽到OSS
```
→ 标准流程：Research → Plan → Execute → Review

**示例3: 复杂重构**
```
sdd_bootstrap: task=微服务拆分, mode=deep
```
→ 深度流程：Research → Innovate → Plan → Spec Review → Execute → Review → Archive

## 模式选择指南

| 评估维度 | Zero/Fast | Standard | Deep |
|----------|-----------|----------|------|
| 代码行数 | <50行 | 50-500行 | >500行 |
| 文件数 | 1-2个 | 3-10个 | >10个 |
| 模块跨越 | 单一 | 2-3个 | 多模块/跨项目 |
| 架构影响 | 无 | 局部 | 全局 |
| 预估时间 | <10分钟 | 10-60分钟 | >60分钟 |

## 铁律体系

| 铁律 | 含义 |
|------|------|
| **No Spec, No Code** | 未形成Spec不写代码（FAST模式除外） |
| **Spec is Truth** | Chat历史可衰减，Spec是持久化真相源 |
| **Checkpoint Gates** | 关键节点暂停等待确认 |
| **Evidence before Claims** | 验证在前，断言在后 |
| **No Fixes Without Root Cause** | 未找到根因不修复 |
| **TDD First** | 先写失败测试，再写实现 |

## 常用命令速查

| 命令 | 作用 |
|------|------|
| `>>` | Zero模式极速执行 |
| `FAST` | Fast模式快速执行 |
| `继续` | 执行下一步骤 |
| `全部` | 批量执行剩余步骤 |
| `批准` | 批准计划进入执行 |
| `MAP` | 生成代码地图 |
| `REVIEW SPEC` | 计划预审 |
| `REVIEW EXECUTE` | 执行后评审 |
| `ARCHIVE` | 知识沉淀 |
| `DEBUG` | 启动调试模式 |

## 文件结构

```
mydocs/
├── specs/                              # Spec文件
├── codemap/                            # 代码地图
├── context/                            # 需求汇总
├── archive/                            # 知识沉淀
└── micro_specs/                        # 微Spec
```

## 融合来源

- **SDD-RIPER**: Spec驱动、单一样本文件、Reverse Sync
- **Checkpoint-Driver**: 轻量级按需加载、短输出模式
- **Superpowers**: TDD、Evidence First、系统化Debug、Subagent驱动

---

**版本**: v2.0
**更新**: 2026-04-12

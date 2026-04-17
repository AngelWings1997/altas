# Protocol Selection Guide

## Which Protocol to Use?

| 场景 | 推荐协议 | 说明 |
|------|----------|------|
| **默认工作流** | SDD-RIPER-ONE (via SKILL.md) | 适用于大多数工程任务，自适应阶段切换 |
| **用户完全自主控制模式** | RIPER-5 | 每个模式切换需要用户显式信号（"ENTER RESEARCH MODE" 等），适用于用户希望逐阶段审批的场景 |
| **双模型协作**（强模型规划 + 弱模型执行） | SDD-RIPER-DUAL-COOP | 适用于 External Model（Architect）无法直接读取代码库，需要 Internal Model（Scout）收集上下文的场景 |
| **纯文档撰写** | RIPER-DOC | 文档结构化整理场景 |

## Relationship to ALTAS Workflow

- **ALTAS Workflow (SKILL.md)** is the unified entry point; it internally references SDD-RIPER-ONE as the primary protocol
- RIPER-5 is a **stricter subset** of SDD-RIPER-ONE (more conservative, user controls more)
- SDD-RIPER-DUAL-COOP is an **extension** of SDD-RIPER-ONE (adds dual-model trust boundary management)
- Unless the user explicitly requests a specific protocol, default to ALTAS Workflow → SDD-RIPER-ONE

## When to Switch Protocols Mid-Session

| From | To | Trigger |
|------|---|---------|
| SDD-RIPER-ONE | RIPER-5 | User says "I want to approve each phase manually" |
| SDD-RIPER-ONE | SDD-RIPER-DUAL-COOP | User activates dual-model mode with `SCOUT` and `ARCHITECT` roles |
| RIPER-5 | SDD-RIPER-ONE | User says "You can proceed autonomously" |

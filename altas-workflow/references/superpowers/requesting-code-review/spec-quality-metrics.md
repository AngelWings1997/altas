# Spec Quality Metrics

## Scoring Dimensions (0-5 per dimension)

| 维度 | 5 分标准 | 1 分标准 |
|------|----------|----------|
| **完整性** | Goal/In-Scope/Out-of-Scope/Facts/Signatures/Checklist 全部完整且无 TBD | 关键章节缺失或大量 TBD |
| **可验证性** | 每个 Acceptance 都有明确的验证方式（测试/运行命令/人工检查） | 验收标准模糊（如"应该能工作"） |
| **无歧义性** | 所有术语、接口签名、文件路径精确到行号 | 使用"类似 X"、"大概 Y"等模糊表述 |
| **可追溯性** | 每个 Checklist 项可追溯到具体 Requirements 条目 | Checklist 与 Requirements 无明确对应 |
| **风险覆盖** | 已识别风险均有缓解措施或回滚方案 | 未提及风险或风险未处理 |

## Go/No-Go Threshold

- **GO**: 所有维度 ≥ 3 分，且完整性 + 可验证性 ≥ 4 分
- **NO-GO**: 任一维度 < 2 分，或完整性 < 3 分
- **CONDITIONAL**: 其他情况，需用户确认是否带风险执行

## Usage

在 REVIEW SPEC 阶段（§3.5 / §4.5 Spec Review Notes）使用此评分表，输出各维度分数和 Go/No-Go 结论。

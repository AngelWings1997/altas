#!/bin/bash
# ALTAS Self-Improvement Activator Hook
# 在每次用户输入后提醒 Agent 评估是否需要记录学习

set -e

cat << 'EOF'
<altas-self-improvement>
任务完成后自检：
1. 是否有非显而易见的解决方案？
2. 是否有意外的行为/变通方案？
3. 是否学到了项目特定模式？
4. 是否有需要调试才能解决的错误？

如果是 → 记录到 .learnings/ 对应文件
如果高价值（重复出现、广泛适用）→ 考虑晋升到 SKILL.md 或提取为 Skill
</altas-self-improvement>
EOF

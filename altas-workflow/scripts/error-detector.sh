#!/bin/bash
# ALTAS Error Detector Hook
# 检测命令执行错误并提醒记录到 .learnings/ERRORS.md

set -e

OUTPUT="${ALTAS_TOOL_OUTPUT:-${CLAUDE_TOOL_OUTPUT:-}}"

ERROR_PATTERNS=(
    "error:" "Error:" "ERROR:"
    "failed" "FAILED"
    "command not found" "No such file"
    "Permission denied" "fatal:"
    "Exception" "Traceback"
    "ModuleNotFoundError" "SyntaxError" "TypeError"
    "exit code" "non-zero"
)

contains_error=false
for pattern in "${ERROR_PATTERNS[@]}"; do
    if [[ "$OUTPUT" == *"$pattern"* ]]; then
        contains_error=true
        break
    fi
done

if [ "$contains_error" = true ]; then
    cat << 'EOF'
<altas-error-detected>
检测到命令错误。如果：
- 错误是非预期的或非显而易见的
- 需要调查才能解决
- 可能在类似场景重复出现

→ 记录到 .learnings/ERRORS.md，格式: [ERR-YYYYMMDD-XXX]
</altas-error-detected>
EOF
fi

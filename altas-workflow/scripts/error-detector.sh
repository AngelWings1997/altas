#!/bin/bash
# ALTAS Self-Improvement Error Detector Hook
# Triggers on PostToolUse for RunCommand (TRAE/Claude Code) to detect command failures
# Supports multiple platform environment variables

set -e

# Check if tool output indicates an error
# Support TRAE / Claude Code / OpenAI Codex environment variables
# Use empty string as default (will check stdin next)
OUTPUT="${TRAE_TOOL_OUTPUT:-${CLAUDE_TOOL_OUTPUT:-${CODEX_TOOL_OUTPUT:-}}}"

# Validate OUTPUT is set (not just empty) before using it
if [ -z "${OUTPUT+x}" ]; then
    OUTPUT=""
fi

# If no env var, try stdin (some platforms pipe output to hook)
if [ -z "$OUTPUT" ] && [ ! -t 0 ]; then
    OUTPUT=$(cat)
fi

# Patterns indicating errors (case-insensitive matching)
ERROR_PATTERNS=(
    "error:"
    "Error:"
    "ERROR:"
    "failed"
    "FAILED"
    "Failure:"
    "FATAL:"
    "fatal:"
    "command not found"
    "No such file or directory"
    "Permission denied"
    "access denied"
    "Exception"
    "Traceback (most recent call last)"
    "npm ERR!"
    "yarn error"
    "pnpm error"
    "ModuleNotFoundError"
    "ImportError"
    "SyntaxError"
    "TypeError"
    "ValueError"
    "KeyError"
    "AttributeError"
    "exit code"
    "non-zero exit"
    "returned non-zero"
    "signal:"
    "killed"
    "timeout"
    "timed out"
    "connection refused"
    "connection reset"
    "no space left"
    "out of memory"
    "segmentation fault"
    "panic:"
    "build failed"
    "test failed"
    "compilation failed"
    "lint error"
    "type error"
    "cannot find module"
    "unable to resolve"
    "依赖安装失败"
    "构建失败"
    "测试失败"
    "编译错误"
    "类型错误"
    "超时"
    "内存不足"
    "权限不足"
)

# Check if output contains any error pattern
contains_error=false
matched_pattern=""

# Check if command had non-zero exit code (direct detection before pattern matching)
if [ "${EXIT_CODE:-0}" -ne 0 ] 2>/dev/null; then
    contains_error=true
    matched_pattern="non-zero exit code (exit code: ${EXIT_CODE})"
fi

for pattern in "${ERROR_PATTERNS[@]}"; do
    if [[ "$OUTPUT" == *"$pattern"* ]]; then
        contains_error=true
        matched_pattern="$pattern"
        break
    fi
done

# Only output reminder if error detected
if [ "$contains_error" = true ]; then
    cat << EOF
<altas-error-detected>
⚠️ **检测到命令错误**（匹配模式: ${matched_pattern}）

如符合以下条件，请记录到 .learnings/ERRORS.md：
✓ 错误非预期或非显而易见
✓ 需要调查才能解决
✓ 可能在类似上下文中重复出现
✓ 解决方案对未来会话有帮助

**快速记录格式**：
\`\`\`markdown
## [ERR-$(date +%Y%m%d)-XXX] command_name

**Logged**: $(date -u +"%Y-%m-%dT%H:%M:%SZ")
**Priority**: high | medium | low
**Status**: pending
**Area**: execute | config | testing | infra

### Summary
一句话描述什么失败了

### Error
\`\`\`
实际错误信息（粘贴此处）
\`\`\`

### Context
- 尝试的命令/操作
- 使用的参数
- 环境信息

### Suggested Fix
如果可识别，可能的解决方案

### Metadata
- Reproducible: yes | no | unknown
- Related Files: path/to/file.ext
\`\`\`

详细格式和示例见: references/self-improvement/SKILL.md
</altas-error-detected>
EOF
fi

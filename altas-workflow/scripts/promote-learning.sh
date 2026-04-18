#!/bin/bash
# ALTAS Learning Promotion Helper
# Promote a learning entry to a workflow rule file
# Usage: ./scripts/promote-learning.sh <learning-id> [--target <file>] [--dry-run]

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

LEARNINGS_DIR=".learnings"

usage() {
    cat << EOF
Usage: $(basename "$0") <learning-id> [options]

将学习条目晋升到工作流规则文件。

Arguments:
  learning-id        学习条目 ID（如 LRN-20250419-001）

Options:
  --target <file>    目标规则文件（默认自动推断）
  --dry-run          显示将要执行的操作而不实际修改
  -h, --help         显示帮助信息

Examples:
  $(basename "$0") LRN-20250419-001
  $(basename "$0") LRN-20250419-001 --target SKILL.md
  $(basename "$0") LRN-20250419-001 --dry-run

目标文件自动推断规则:
  - routing 相关 → references/entry/aliases.md 或 SKILL.md 路由表
  - scale/规模相关 → SKILL.md 规模评估表
  - workflow 相关 → SKILL.md Hard Rules 或阶段门禁
  - testing 相关 → references/testing/
  - execute/config 相关 → 对应 references/ 子目录
EOF
}

log_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

# Parse arguments
LEARNING_ID=""
TARGET_FILE=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --target)
            TARGET_FILE="$2"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        -*)
            log_error "未知选项: $1"
            usage
            exit 1
            ;;
        *)
            if [ -z "$LEARNING_ID" ]; then
                LEARNING_ID="$1"
            else
                log_error "意外的参数: $1"
                usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate learning ID
if [ -z "$LEARNING_ID" ]; then
    log_error "学习 ID 是必需的"
    usage
    exit 1
fi

if ! [[ "$LEARNING_ID" =~ ^\[(LRN|ERR|FEAT)-[0-9]{8}-[A-Za-z0-9]+\]$ ]]; then
    # Try adding brackets if missing
    if [[ "$LEARNING_ID" =~ ^(LRN|ERR|FEAT)-[0-9]{8}-[A-Za-z0-9]+$ ]]; then
        LEARNING_ID="[$LEARNING_ID]"
    else
        log_error "无效的学习 ID 格式。格式: [LRN-YYYYMMDD-XXX] 或 [ERR-YYYYMMDD-XXX] 或 [FEAT-YYYYMMDD-XXX]"
        exit 1
    fi
fi

log_info "查找学习条目: $LEARNING_ID"

# Find the learning entry
ENTRY_FILE=""
for file in "$LEARNINGS_DIR"/*.md; do
    [ -f "$file" ] || continue
    
    if grep -q "^${LEARNING_ID} " "$file"; then
        ENTRY_FILE="$file"
        break
    fi
done

if [ -z "$ENTRY_FILE" ]; then
    log_error "未找到学习条目: $LEARNING_ID"
    log_info "可用条目:"
    grep -h "^## \[" "$LEARNINGS_DIR"/*.md 2>/dev/null | head -n 10 || echo "  (无)"
    exit 1
fi

log_info "在 $ENTRY_FILE 中找到"

# Extract entry content
ENTRY_CONTENT=$(sed -n "/^${LEARNING_ID} /,/^---$/p" "$ENTRY_FILE")

# Extract key fields
SUMMARY=$(echo "$ENTRY_CONTENT" | grep "^### Summary" -A 1 | tail -n 1 | sed 's/^[[:space:]]*//')
CATEGORY=$(echo "$ENTRY_CONTENT" | head -n 1 | sed "s/^${LEARNING_ID} //" | awk '{print $1}')
AREA=$(echo "$ENTRY_CONTENT" | grep "^**Area**:" | sed 's/**Area**: *//')
PRIORITY=$(echo "$ENTRY_CONTENT" | grep "^**Priority**:" | sed 's/**Priority**: *//')
STATUS=$(echo "$ENTRY_CONTENT" | grep "^**Status**:" | sed 's/**Status**: *//')
PATTERN_KEY=$(echo "$ENTRY_CONTENT" | grep "^- Pattern-Key:" | sed 's/.*Pattern-Key: *//')
RECURRENCE_COUNT=$(echo "$ENTRY_CONTENT" | grep "^- Recurrence-Count:" | sed 's/.*Recurrence-Count: *//')
SUGGESTED_ACTION=$(echo "$ENTRY_CONTENT" | grep "^### Suggested Action" -A 10 | tail -n +2 | sed '/^### /d' | sed 's/^[[:space:]]*//')

echo ""
echo "=========================================="
echo "学习条目详情: $LEARNING_ID"
echo "=========================================="
echo ""
echo "类别 (Category):     $CATEGORY"
echo "区域 (Area):         $AREA"
echo "优先级 (Priority):   $PRIORITY"
echo "当前状态 (Status):   $STATUS"
echo "摘要 (Summary):      $SUMMARY"
if [ -n "$PATTERN_KEY" ]; then
    echo "模式键 (Pattern-Key): $PATTERN_KEY"
fi
if [ -n "$RECURRENCE_COUNT" ]; then
    echo "重复次数 (Recurrence): $RECURRENCE_COUNT"
fi
echo ""
echo "建议动作:"
echo "$SUGGESTED_ACTION" | head -n 5
echo ""

# Check promotion criteria
log_info "检查晋升条件..."

can_promote=true
warnings=()

if [ -n "$RECURRENCE_COUNT" ] && [ "$RECURRENCE_COUNT" -lt 3 ]; then
    warnings+=("⚠️  Recurrence-Count ($RECURRENCE_COUNT) < 3")
    can_promote=false
fi

if [ "$STATUS" = "promoted" ] || [ "$STATUS" = "promoted_to_skill" ]; then
    warnings+=("⚠️  已经晋升过（当前状态: $STATUS）")
    can_promote=false
fi

if [ ${#warnings[@]} -gt 0 ]; then
    echo "⚠️  晋升前警告:"
    for warning in "${warnings[@]}"; do
        echo "  $warning"
    done
    echo ""
    
    if [ "$can_promote" = false ] && [ "$DRY_RUN" = false ]; then
        read -p "是否仍要继续？(y/N) " confirm
        if [[ ! "$confirm" =~ ^[Yy]$ ]]; then
            log_info "取消晋升"
            exit 0
        fi
    fi
fi

# Determine target file if not specified
if [ -z "$TARGET_FILE" ]; then
    log_info "自动推断目标文件..."
    
    case "${AREA,,}" in
        routing)
            if echo "$SUMMARY" | grep -qi "触发词\|别名\|trigger\|alias"; then
                TARGET_FILE="references/entry/aliases.md"
            else
                TARGET_FILE="SKILL.md"
            fi
            ;;
        workflow)
            TARGET_FILE="SKILL.md"
            ;;
        spec)
            TARGET_FILE="references/spec-driven-development/"
            ;;
        execute)
            TARGET_FILE="references/superpowers/executing-plans/SKILL.md"
            ;;
        review)
            TARGET_FILE="references/special-modes/review.md"
            ;;
        testing)
            TARGET_FILE="references/testing/test-strategy-template.md"
            ;;
        config|infra)
            TARGET_FILE="SKILL.md"
            ;;
        *)
            TARGET_FILE="SKILL.md"
            ;;
    esac
    
    log_info "推荐目标: $TARGET_FILE"
fi

# Prepare promotion content
echo ""
echo "=========================================="
echo "晋升内容预览"
echo "=========================================="
echo ""

PROMOTION_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

cat << EOF
## 来自 $LEARNING_ID 的规则

**规则**: $SUMMARY
**原因**: 从实际经验中提取，已重复出现 ${RECURRENCE_COUNT:-多次}
**来源**: $LEARNING_ID
**日期**: $PROMOTION_DATE

### 详细说明

$SUGGESTED_ACTION

---

**原条目元数据**:
- Category: $CATEGORY
- Area: $AREA
- Pattern-Key: ${PATTERN_KEY:-未设置}
- Recurrence-Count: ${RECURRENCE_COUNT:-未追踪}
EOF

echo ""

if [ "$DRY_RUN" = true ]; then
    log_info "干跑模式 - 不会进行任何修改"
    echo ""
    echo "下一步操作:"
    echo "  1. 审查上述晋升内容"
    echo "  2. 运行不带 --dry-run 的命令以实际执行:"
    echo "     ./scripts/promote-learning.sh $LEARNING_ID --target $TARGET_FILE"
    exit 0
fi

# Confirm promotion
read -p "确认将此内容添加到 $TARGET_FILE 吗？(y/N) " confirm_final

if [[ ! "$confirm_final" =~ ^[Yy]$ ]]; then
    log_info "取消晋升"
    exit 0
fi

# Perform promotion
log_info "正在晋升到 $TARGET_FILE..."

# Create backup comment in the target file
PROMOTION_BLOCK="

<!-- Promoted from $LEARNING_ID on $PROMOTION_DATE -->
## 来自 $LEARNING_ID 的规则

**规则**: $SUMMARY
**原因**: 从实际经验中提取，已重复出现 ${RECURRENCE_COUNT:-多次}
**来源**: $LEARNING_ID
**日期**: $PROMOTION_DATE

$SUGGESTED_ACTION
<!-- End of promotion from $LEARNING_ID -->
"

# Append to target file
echo "$PROMOTION_BLOCK" >> "$TARGET_FILE"

log_info "✅ 已添加到 $TARGET_FILE"

# Update original entry status
log_info "更新原始条目状态..."

if command -v sed &>/dev/null; then
    # Use sed to update status (simple approach)
    TEMP_FILE=$(mktemp)
    sed "s|^\\(\\*\\*Status\\*\\*: \\).*\$|\\1promoted|" "$ENTRY_FILE" > "$TEMP_FILE" && mv "$TEMP_FILE" "$ENTRY_FILE"
    
    # Add promoted metadata
    cat >> "$ENTRY_FILE" << EOF

### Resolution
- **Resolved**: $PROMOTION_DATE
- **Promoted To**: $TARGET_FILE
- **Notes**: 已晋升为工作流规则
EOF
    
    log_info "✅ 已更新 $LEARNING_ID 状态为 'promoted'"
else
    log_warn "无法自动更新原始条目，请手动更新:"
    echo "  1. 将 Status 改为 'promoted'"
    echo "  2. 添加 Resolution 块，包含 Promoted To: $TARGET_FILE"
fi

echo ""
log_info "🎉 晋升完成！"
echo ""
echo "后续步骤:"
echo "  1. 审查 $TARGET_FILE 中新增的内容"
echo "  2. 如需要，调整措辞或位置"
echo "  3. 在下次任务中验证规则的实用性"

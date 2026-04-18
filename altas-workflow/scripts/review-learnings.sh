#!/bin/bash
# ALTAS Learnings Review Script
# Interactive review of learning entries for promotion or resolution
# Usage: ./scripts/review-learnings.sh [--area <area>] [--status <status>] [--type <type>]

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
Usage: $(basename "$0") [options]

交互式回顾 .learnings/ 中的条目，评估是否需要晋升或解决。

Options:
  --area <area>      按区域过滤 (workflow, routing, spec, execute, review, ...)
  --status <status>  按状态过滤 (pending, in_progress, resolved, promoted)
  --type <type>      按类型过滤 (LRN, ERR, FEAT)
  --high-only        仅显示高优先级条目
  --stats            仅显示统计信息，不进入交互模式
  -h, --help         显示帮助信息

Examples:
  $(basename "$0") --area execute --status pending
  $(basename "$0") --type LRN --high-only
  $(basename "$0") --stats
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
AREA=""
STATUS=""
TYPE=""
HIGH_ONLY=false
STATS_ONLY=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --area)
            AREA="$2"
            shift 2
            ;;
        --status)
            STATUS="$2"
            shift 2
            ;;
        --type)
            TYPE="$2"
            shift 2
            ;;
        --high-only)
            HIGH_ONLY=true
            shift
            ;;
        --stats)
            STATS_ONLY=true
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            log_error "未知选项: $1"
            usage
            exit 1
            ;;
    esac
done

# Check if learnings directory exists
if [ ! -d "$LEARNINGS_DIR" ]; then
    log_error "学习目录不存在: $LEARNINGS_DIR"
    log_info "请先创建学习目录: mkdir -p $LEARNINGS_DIR"
    exit 1
fi

# Function to get stats
get_stats() {
    local total_pending=0
    total_in_progress=0
    total_resolved=0
    total_promoted=0
    
    for file in "$LEARNINGS_DIR"/*.md; do
        [ -f "$file" ] || continue
        
        pending=$(grep -c "Status\*\*: pending" "$file" 2>/dev/null || echo 0)
        in_progress=$(grep -c "Status\*\*: in_progress" "$file" 2>/dev/null || echo 0)
        resolved=$(grep -c "Status\*\*: resolved" "$file" 2>/dev/null || echo 0)
        promoted=$(grep -c "Status\*\*: promoted" "$file" 2>/dev/null || echo 0)
        
        total_pending=$((total_pending + pending))
        total_in_progress=$((total_in_progress + in_progress))
        total_resolved=$((total_resolved + resolved))
        total_promoted=$((total_promoted + promoted))
    done
    
    echo "=== 学习统计 ==="
    echo "待处理 (Pending):     $total_pending"
    echo "进行中 (In Progress):  $total_in_progress"
    echo "已解决 (Resolved):     $total_resolved"
    echo "已晋升 (Promoted):     $total_promoted"
    echo "总计:                  $((total_pending + total_in_progress + total_resolved + total_promoted))"
}

# If stats only mode, show and exit
if [ "$STATS_ONLY" = true ]; then
    get_stats
    exit 0
fi

# Build grep pattern
GREP_PATTERN=""
if [ -n "$AREA" ]; then
    GREP_PATTERN="Area\\*\\*: $AREA"
fi
if [ -n "$STATUS" ]; then
    if [ -n "$GREP_PATTERN" ]; then
        GREP_PATTERN="$GREP_PATTERN|Status\\*\\*: $STATUS"
    else
        GREP_PATTERN="Status\\*\\*: $STATUS"
    fi
fi
if [ -n "$HIGH_ONLY" ] && [ "$HIGH_ONLY" = true ]; then
    if [ -n "$GREP_PATTERN" ]; then
        GREP_PATTERN="$GREP_PATTERN|Priority\\*\\*: high|Priority\\*\\*: critical"
    else
        GREP_PATTERN="Priority\\*\\*: high|Priority\\*\\*: critical"
    fi
fi

# Find entries
log_info "搜索学习条目..."
echo ""

entries=()

for file in "$LEARNINGS_DIR"/*.md; do
    [ -f "$file" ] || continue
    
    # Filter by type if specified
    if [ -n "$TYPE" ]; then
        case "$TYPE" in
            LRN)
                [[ "$(basename "$file")" != "LEARNINGS.md" ]] && continue
                ;;
            ERR)
                [[ "$(basename "$file")" != "ERRORS.md" ]] && continue
                ;;
            FEAT)
                [[ "$(basename "$file")" != "FEATURE_REQUESTS.md" ]] && continue
                ;;
        esac
    fi
    
    # Find entry headers
    while IFS= read -r line; do
        if [[ "$line" =~ ^##\ \[(LRN|ERR|FEAT)-[0-9]{8}-[A-Za-z0-9]+\] ]]; then
            entry_id="${BASH_REMATCH[0]}"
            
            # Apply filters
            if [ -n "$GREP_PATTERN" ]; then
                # Get entry content (until next ## or end of file)
                entry_content=$(sed -n "/^${entry_id$/,/^## /p" "$file" | head -n -1)
                
                if ! echo "$entry_content" | grep -qiE "$GREP_PATTERN"; then
                    continue
                fi
            fi
            
            entries+=("$entry_id|$file")
        fi
    done < "$file"
done

if [ ${#entries[@]} -eq 0 ]; then
    log_warn "未找到匹配的学习条目"
    get_stats
    exit 0
fi

log_info "找到 ${#entries[@]} 个匹配的条目"
echo ""

# Display summary first
get_stats
echo ""
echo "--- 匹配的条目 ---"

index=0
for entry in "${entries[@]}"; do
    IFS='|' read -r entry_id file <<< "$entry"
    
    # Extract summary
    summary=$(sed -n "/^${entry_id$/,/^### Summary/p" "$file" | grep "^### Summary" -A 1 | tail -n 1 | sed 's/^[[:space:]]*//')
    
    # Extract status
    status=$(sed -n "/^${entry_id$/,/^### /p" "$file" | grep "Status\\*\\*:" | head -n 1 | sed 's/.*: *//')
    
    # Extract priority
    priority=$(sed -n "/^${entry_id$/,/^### /p" "$file" | grep "Priority\\*\\*:" | head -n 1 | sed 's/.*: *//')
    
    printf "[%2d] %-35s | %-12s | %s\n" "$((index+1))" "$entry_id" "$priority" "$summary"
    
    index=$((index+1))
done

echo ""
echo "输入编号查看详情，q 退出，s 显示统计"

# Interactive loop
while true; do
    read -p "> " choice
    
    case "$choice" in
        q|Q|quit|exit)
            log_info "退出回顾"
            exit 0
            ;;
        s|S|stats)
            echo ""
            get_stats
            echo ""
            ;;
        [0-9]*)
            if [ "$choice" -ge 1 ] && [ "$choice" -le ${#entries[@]} ]; then
                idx=$((choice - 1))
                IFS='|' read -r entry_id file <<< "${entries[$idx]}"
                
                echo ""
                echo "=========================================="
                echo "$entry_id"
                echo "=========================================="
                echo ""
                
                # Show full entry
                sed -n "/^${entry_id$/,/^---$/p" "$file"
                
                echo ""
                echo "--- 操作选项 ---"
                echo "  r - 标记为 resolved"
                echo "  p - 准备晋升"
                echo "  i - 标记为 in_progress"
                echo "  b - 返回列表"
                echo "  q - 退出"
                
                read -p "操作> " action
                
                case "$action" in
                    r|R)
                        log_info "标记 $entry_id 为 resolved"
                        # In real implementation, would update the file
                        echo "⚠️  请手动更新文件中的 Status 字段为 'resolved' 并添加 Resolution 块"
                        ;;
                    p|P)
                        log_info "准备晋升 $entry_id"
                        echo "📋 晋升检查清单:"
                        echo "  ✅ Recurrence-Count >= 3?"
                        echo "  ✅ 跨 >= 2 个不同任务?"
                        echo "  ✅ 在 30 天窗口期内?"
                        echo ""
                        echo "使用 ./scripts/promote-learning.sh $entry_id 完成晋升"
                        ;;
                    i|I)
                        log_info "标记 $entry_id 为 in_progress"
                        echo "⚠️  请手动更新文件中的 Status 字段为 'in_progress'"
                        ;;
                    b|B|back)
                        # Return to list
                        ;;
                    q|Q)
                        exit 0
                        ;;
                    *)
                        log_warn "未知操作"
                        ;;
                esac
            else
                log_error "无效编号: $choice"
            fi
            ;;
        *)
            log_warn "无效输入。输入编号、q 或 s"
            ;;
    esac
done

#!/bin/bash
# ALTAS Skill Extraction Helper
# 从学习条目创建新的技能
# Usage: ./scripts/extract-skill.sh <skill-name> [--dry-run] [--output-dir ./path]

set -e

# Configuration - 默认输出到 references/superpowers/
SKILLS_DIR="./references/superpowers"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

usage() {
    cat << EOF
Usage: $(basename "$0") <skill-name> [options]

从学习条目创建新的 ALTAS 技能。

Arguments:
  skill-name     技能名称（小写，空格用连字符）

Options:
  --dry-run      显示将要创建的内容而不实际创建文件
  --output-dir   当前路径下的相对输出目录（默认：./references/superpowers）
  -h, --help     显示帮助信息

Examples:
  $(basename "$0") docker-m1-fixes
  $(basename "$0") api-timeout-patterns --dry-run
  $(basename "$0") pnpm-setup --output-dir ./references/custom

技能将创建在: \$SKILLS_DIR/<skill-name>/
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
SKILL_NAME=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case $1 in
        --dry-run)
            DRY_RUN=true
            shift
            ;;
        --output-dir)
            if [ -z "${2:-}" ] || [[ "${2:-}" == -* ]]; then
                log_error "--output-dir 需要一个相对路径参数"
                usage
                exit 1
            fi
            SKILLS_DIR="$2"
            shift 2
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
            if [ -z "$SKILL_NAME" ]; then
                SKILL_NAME="$1"
            else
                log_error "意外的参数: $1"
                usage
                exit 1
            fi
            shift
            ;;
    esac
done

# Validate skill name
if [ -z "$SKILL_NAME" ]; then
    log_error "技能名称是必需的"
    usage
    exit 1
fi

# Validate skill name format (lowercase, hyphens, no spaces)
if ! [[ "$SKILL_NAME" =~ ^[a-z0-9]+(-[a-z0-9]+)*$ ]]; then
    log_error "无效的技能名称格式。只使用小写字母、数字和连字符。"
    log_error "示例: 'docker-fixes', 'api-patterns', 'pnpm-setup'"
    exit 1
fi

# Validate output path to avoid writes outside current workspace.
if [[ "$SKILLS_DIR" = /* ]]; then
    log_error "输出目录必须是当前目录下的相对路径。"
    exit 1
fi

if [[ "$SKILLS_DIR" =~ (^|/)\.\.(/|$) ]]; then
    log_error "输出目录不能包含 '..' 路径段。"
    exit 1
fi

SKILLS_DIR="${SKILLS_DIR#./}"
SKILLS_DIR="./$SKILLS_DIR"

SKILL_PATH="$SKILLS_DIR/$SKILL_NAME"

# Check if skill already exists
if [ -d "$SKILL_PATH" ] && [ "$DRY_RUN" = false ]; then
    log_error "技能已存在: $SKILL_PATH"
    log_error "使用不同的名称或先删除现有技能。"
    exit 1
fi

# Dry run output
if [ "$DRY_RUN" = true ]; then
    log_info "干跑模式 - 将会创建:"
    echo "  $SKILL_PATH/"
    echo "  $SKILL_PATH/SKILL.md"
    echo ""
    echo "模板内容将是:"
    echo "---"
    cat << TEMPLATE
name: $SKILL_NAME
description: "[TODO: 添加此功能的简洁描述以及何时使用]"
---

# $(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

[TODO: 简要介绍说明技能的用途]

## Quick Reference

| Situation | Action |
|-----------|--------|
| [触发条件] | [操作] |

## Background

[为什么此知识重要。它防止了什么问题。原始学习的上下文。]

## Solution

### Step-by-Step

1. 第一步（代码或命令）
2. 第二步
3. 验证步骤

### Code Example

\`\`\`language
// 示例代码演示解决方案
\`\`\`

## Common Variations

- **变体 A**：描述及处理方式
- **变体 B**：描述及处理方式

## Gotchas

- 警告或常见错误 #1
- 警告或常见错误 #2

## Related

- 相关文档链接
- 相关技能链接

## Source Learning

此技能从学习条目提取。
- **Learning ID**: [TODO: 添加原始学习 ID]
- **Original Category**: correction | insight | knowledge_gap | best_practice
- **Extraction Date**: $(date +%Y-%m-%d)
TEMPLATE
    echo "---"
    exit 0
fi

# Create skill directory structure
log_info "创建技能: $SKILL_NAME"

mkdir -p "$SKILL_PATH"

# Create SKILL.md from template (Chinese version for ALTAS)
cat > "$SKILL_PATH/SKILL.md" << TEMPLATE
---
name: $SKILL_NAME
description: "[TODO: 添加此功能的简洁描述以及何时使用]"
---

# $(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

[TODO: 简要介绍说明技能的用途]

## Quick Reference

| Situation | Action |
|-----------|--------|
| [触发条件] | [操作] |

## Background

[为什么此知识重要。它防止了什么问题。原始学习的上下文。]

## Solution

### Step-by-Step

1. 第一步（代码或命令）
2. 第二步
3. 验证步骤

### Code Example

\`\`\`language
// 示例代码演示解决方案
\`\`\`

## Common Variations

- **变体 A**：描述及处理方式
- **变体 B**：描述及处理方式

## Gotchas

- 警告或常见错误 #1
- 警告或常见错误 #2

## Related

- 相关文档链接
- 相关技能链接

## Source Learning

此技能从学习条目提取。
- **Learning ID**: [TODO: 添加原始学习 ID]
- **Original Category**: correction | insight | knowledge_gap | best_practice
- **Extraction Date**: $(date +%Y-%m-%d)
TEMPLATE

log_info "已创建: $SKILL_PATH/SKILL.md"

# Suggest next steps
echo ""
log_info "技能骨架创建成功！"
echo ""
echo "下一步:"
echo "  1. 编辑 $SKILL_PATH/SKILL.md"
echo "  2. 用你的学习内容填写 TODO 部分"
echo "  3. 如有详细文档，添加 references/ 文件夹"
echo "  4. 如有可执行代码，添加 scripts/ 文件夹"
echo "  5. 更新原始学习条目，添加:"
echo "     **Status**: promoted_to_skill"
echo "     **Skill-Path**: $SKILL_PATH"
echo "  6. 在 reference-index.md 中添加索引（如适用）"

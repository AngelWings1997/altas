#!/usr/bin/env python3
"""
validate_aliases_sync.py

验证 SKILL.md frontmatter trigger_keywords 与 aliases.md 全局触发词词典的同步状态。
运行方式: python scripts/validate_aliases_sync.py
"""

import re
import sys
from pathlib import Path

ROOT = Path(__file__).parent.parent
SKILL_PATH = ROOT / "SKILL.md"
ALIASES_PATH = ROOT / "references" / "entry" / "aliases.md"


def extract_trigger_keywords(skill_path: Path) -> set[str]:
    content = skill_path.read_text()
    match = re.search(r'trigger_keywords:\s*\[(.*?)\]', content, re.DOTALL)
    if not match:
        raise ValueError("无法在 SKILL.md 中找到 trigger_keywords")
    keywords_str = match.group(1)
    keywords = re.findall(r'"([^"]+)"', keywords_str)
    return set(keywords)


def extract_aliases_keywords(aliases_path: Path) -> set[str]:
    content = aliases_path.read_text()
    keywords = set()

    in_global_section = False
    for line in content.splitlines():
        if line.startswith("## 全局触发词词典"):
            in_global_section = True
            continue
        if line.startswith("## ") and in_global_section:
            break
        if not in_global_section or not line.strip():
            continue

        parts = line.split("|")
        if len(parts) < 3:
            continue

        mode = parts[1].strip()
        primary = parts[2].strip()
        aliases_raw = parts[3].strip() if len(parts) > 3 else ""

        if not mode or mode.startswith("-") or mode.startswith("模式"):
            continue

        if re.match(r'^[\s\|\-:]+$', line):
            continue

        def strip_backticks(s: str) -> str:
            return s.strip().strip('`').strip()

        def split_aliases(cell: str) -> list[str]:
            result = []
            for part in cell.replace('/', '、').split('、'):
                part = strip_backticks(part)
                if part and part not in ("无", "支持别名", ""):
                    result.append(part)
            return result

        if primary and primary not in ("主触发词", ""):
            keywords.add(strip_backticks(primary))

        if aliases_raw and aliases_raw not in ("支持别名", ""):
            for alias in split_aliases(aliases_raw):
                keywords.add(alias)

    return keywords


def main():
    try:
        skill_kw = extract_trigger_keywords(SKILL_PATH)
        aliases_kw = extract_aliases_keywords(ALIASES_PATH)

        missing_in_skill = aliases_kw - skill_kw
        extra_in_skill = skill_kw - aliases_kw

        print(f"SKILL.md trigger_keywords 数量: {len(skill_kw)}")
        print(f"aliases.md 全局触发词数量:     {len(aliases_kw)}")
        print()

        if missing_in_skill:
            print("❌ SKILL.md 缺少以下关键字（aliases.md 有但 SKILL.md 没有）:")
            for kw in sorted(missing_in_skill):
                print(f"   - {kw}")
            print()

        if extra_in_skill:
            print("⚠️  SKILL.md 多余以下关键字（SKILL.md 有但 aliases.md 没有）:")
            for kw in sorted(extra_in_skill):
                print(f"   - {kw}")
            print()

        if missing_in_skill:
            print("同步失败：存在缺失关键字")
            sys.exit(1)
        elif extra_in_skill:
            print("⚠️  同步警告：存在多余关键字（建议清理）")
            sys.exit(0)
        else:
            print("✅ 同步检查通过：SKILL.md 与 aliases.md 完全一致")
            sys.exit(0)

    except Exception as e:
        print(f"错误: {e}")
        sys.exit(2)


if __name__ == "__main__":
    main()

#!/usr/bin/env python3
"""
ALTAS Workflow Scaffold Generator

Scans project structure and generates initial mydocs/ skeleton:
- mydocs/specs/<task>.md (from spec-template.md)
- mydocs/codemap/ (empty, ready for CodeMap generation)
- mydocs/context/ (empty, ready for Context Bundle)
- mydocs/archive/ (empty, ready for Archive)

Usage:
  python scripts/scaffold.py [task_name] [--template full|lite]
"""

import os
import sys
import argparse
from pathlib import Path

PROJECT_TYPES = {
    "package.json": "Node.js/TypeScript",
    "pom.xml": "Java/Maven",
    "build.gradle": "Java/Gradle",
    "go.mod": "Go",
    "Cargo.toml": "Rust",
    "requirements.txt": "Python",
    "setup.py": "Python",
    "pyproject.toml": "Python",
    "Gemfile": "Ruby",
    "composer.json": "PHP",
}

SPECS_DIR = "specs"
CODEMAP_DIR = "codemap"
CONTEXT_DIR = "context"
ARCHIVE_DIR = "archive"


def detect_project_type(root_dir: str) -> str:
    """Detect project type by scanning for build files."""
    for filename, ptype in PROJECT_TYPES.items():
        if os.path.exists(os.path.join(root_dir, filename)):
            return ptype
    return "Unknown"


def get_template_content(template_type: str, task_name: str, project_type: str) -> str:
    """Generate spec content based on template type."""
    timestamp = "YYYY-MM-DD"
    
    if template_type == "lite":
        return f"""---
title: "{task_name}"
status: DRAFT
date: {timestamp}
scale: M
---

# {task_name}

## 1. Requirements

### 1.1 Goal
<!-- What problem are we solving? Who benefits? -->

### 1.2 In-Scope
- 

### 1.3 Out-of-Scope
- 

### 1.4 Context Sources
- Codebase: {root_dir}
- Project Type: {project_type}

## 2. Plan

### 2.1 Checklist
- [ ] 1. 

### 2.2 Test Strategy
- **Test Framework**: 
- **Run Command**: 
- **Test Scope**: Unit / Integration / E2E
- **Test Priority**: P0 / P1 / P2
"""
    else:
        return f"""---
title: "{task_name}"
status: DRAFT
date: {timestamp}
scale: M
type: feature
version: 1.0
---

# {task_name}

## 1. Requirements

### 1.1 Goal
<!-- What problem are we solving? Who benefits? -->

### 1.2 In-Scope
- 

### 1.3 Out-of-Scope
- 

### 1.4 Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2

### 1.5 Context Sources
- Codebase: {root_dir}
- Project Type: {project_type}
- Related Docs: 
- Domain Knowledge: 

## 2. Research Findings
- 事实与约束: ...
- 风险与不确定项: ...

## 2.2 Scale Re-assessment (if changed from initial assessment)
- Initial Assessment: M
- Re-assessed: 
- Reason: 
- Impact: 

## 2.1 Next Actions
- 下一步动作 1 ...

## 3. Design (M/L only)

### 3.1 Architecture Overview
- 

### 3.2 Technical Decisions
| Decision | Options | Chosen | Rationale |
|---|---|---|---|
| ... | ... | ... | ... |

### 3.3 Risk Assessment
| Risk | Probability | Impact | Mitigation |
|---|---|---|---|
| ... | ... | ... | ... |

### 3.4 Dependency Changes
| Dependency | Change | Impact | Migration Plan |
|---|---|---|---|
| ... | ... | ... | ... |

### 3.5 Alternative Approaches Considered
- 

## 4. Plan

### 4.1 File Changes
| File | Action | Rationale |
|---|---|---|
| ... | Create/Modify/Delete | ... |

### 4.2 Key Signatures
```
// function signature or type definition
```

### 4.3 Implementation Checklist
- [ ] 1. ...
- [ ] 2. ...
- [ ] 3. ...

### 4.4 Test Strategy (M/L required, S optional)

- **Test Framework**: 
- **Run Command**: 
- **Test Scope**:
  - [ ] Unit tests: 
  - [ ] Integration tests: 
  - [ ] E2E tests: 
- **Test Priority**:
  - P0 (must): 
  - P1 (should): 
  - P2 (could): 
- **Mock Strategy**: 
- **Existing Test Impact**: 

### 4.5 Spec Review Notes (Optional Advisory, Pre-Execute)
- Spec Review Matrix:
| Check | Verdict | Evidence |
|---|---|---|
| Requirement clarity & acceptance | | |
| Plan executability | | |
| Risk / rollback readiness | | |
| Cross-project contract completeness | | |
- Readiness Verdict: GO/NO-GO (Advisory)
- Risks & Suggestions: ...

## 5. Execute Log
- [ ] Step 1: ...

## 6. Change Log
| Version | Date | Author | Changes |
|---|---|---|---|
| 1.0 | {timestamp} | AI | Initial draft |
"""


def create_scaffold(root_dir: str, task_name: str, template_type: str):
    """Create the mydocs/ scaffold structure."""
    mydocs_dir = os.path.join(root_dir, "mydocs")
    
    dirs = [
        os.path.join(mydocs_dir, SPECS_DIR),
        os.path.join(mydocs_dir, CODEMAP_DIR),
        os.path.join(mydocs_dir, CONTEXT_DIR),
        os.path.join(mydocs_dir, ARCHIVE_DIR),
    ]
    
    for d in dirs:
        os.makedirs(d, exist_ok=True)
        print(f"  Created: {d}/")
    
    project_type = detect_project_type(root_dir)
    spec_file = os.path.join(mydocs_dir, SPECS_DIR, f"{task_name}.md")
    
    if os.path.exists(spec_file):
        print(f"  Spec file already exists: {spec_file}")
        return
    
    content = get_template_content(template_type, task_name, project_type)
    with open(spec_file, "w") as f:
        f.write(content)
    print(f"  Created: {spec_file}")
    
    print(f"\n  Project Type Detected: {project_type}")


def main():
    parser = argparse.ArgumentParser(description="ALTAS Workflow Scaffold Generator")
    parser.add_argument("task_name", nargs="?", default="new-feature", help="Task name for the spec file")
    parser.add_argument("--template", choices=["full", "lite"], default="full", help="Spec template type")
    parser.add_argument("--root", default=".", help="Project root directory (default: current directory)")
    
    args = parser.parse_args()
    root_dir = os.path.abspath(args.root)
    
    if not os.path.isdir(root_dir):
        print(f"Error: {root_dir} is not a valid directory")
        sys.exit(1)
    
    print(f"ALTAS Workflow Scaffold Generator")
    print(f"Project Root: {root_dir}")
    print(f"Task Name: {args.task_name}")
    print(f"Template: {args.template}")
    print()
    
    create_scaffold(root_dir, args.task_name, args.template)
    
    print(f"\nScaffold generated successfully!")
    print(f"\nNext steps:")
    print(f"  1. Edit mydocs/specs/{args.task_name}.md to fill in requirements")
    print(f"  2. Generate codemap in mydocs/codemap/")
    print(f"  3. Add context files to mydocs/context/")
    print(f"  4. Start ALTAS Workflow with the spec")


if __name__ == "__main__":
    main()

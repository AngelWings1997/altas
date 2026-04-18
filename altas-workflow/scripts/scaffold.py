#!/usr/bin/env python3
"""
ALTAS Workflow Scaffold Generator

Generates project scaffolds for ALTAS Workflow:
- spec (default): mydocs/ skeleton with spec template
- test: tests/ skeleton with pytest infrastructure
- all: both spec and test scaffolds

Usage:
  python scripts/scaffold.py [task_name] [--type spec|test|all] [--template full|lite]
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

CONFTEST_PY = '''\
import pytest

def pytest_configure(config):
    config.addinivalue_line("markers", "slow: marks tests as slow")
    config.addinivalue_line("markers", "integration: marks integration tests")
    config.addinivalue_line("markers", "e2e: marks end-to-end tests")
    config.addinivalue_line("markers", "flaky: known flaky tests (reruns enabled)")

@pytest.fixture(scope="session")
def anyio_backend():
    return "asyncio"
'''

FACTORIES_PY = '''\
import factory
from faker import Faker

fake = Faker()
'''

API_CONFTEST_PY = '''\
import pytest

@pytest.fixture
def api_client():
    from fastapi.testclient import TestClient
    from main import app
    return TestClient(app)

@pytest.fixture
def auth_headers():
    return {"Authorization": "Bearer test-token"}
'''

DB_CONFTEST_PY = '''\
import pytest
from sqlalchemy.orm import sessionmaker

# TODO: 将 `your_project.database` 替换为实际项目的数据库模块路径
# 例如: `from app.db import engine` 或 `from myapp.database import engine`
DATABASE_MODULE = "your_project.database"

@pytest.fixture(scope="function")
def db_session():
    import importlib
    db_module = importlib.import_module(DATABASE_MODULE)
    engine = db_module.engine
    connection = engine.connect()
    transaction = connection.begin()
    session = sessionmaker(bind=connection)()
    yield session
    session.close()
    transaction.rollback()
    connection.close()
'''

PYTEST_CONFIG_TOML = '''\
[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --tb=short --strict-markers"
markers = [
    "slow: marks tests as slow (deselect with '-m \\"not slow\\"')",
    "integration: marks integration tests",
    "e2e: marks end-to-end tests",
    "flaky: known flaky tests (reruns enabled)",
]
norecursedirs = ["*.egg", ".git", "venv", "__pycache__"]
filterwarnings = ["error", "ignore::DeprecationWarning"]
log_cli = true
log_cli_level = "WARNING"
'''

INIT_PY = ""


def detect_project_type(root_dir: str) -> str:
    for filename, ptype in PROJECT_TYPES.items():
        if os.path.exists(os.path.join(root_dir, filename)):
            return ptype
    return "Unknown"


def _write_file(path: str, content: str):
    if os.path.exists(path):
        print(f"  Already exists: {path}")
        return
    with open(path, "w") as f:
        f.write(content)
    print(f"  Created: {path}")


def get_template_content(template_type: str, task_name: str, project_type: str) -> str:
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


def create_spec_scaffold(root_dir: str, task_name: str, template_type: str):
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
    else:
        content = get_template_content(template_type, task_name, project_type)
        with open(spec_file, "w") as f:
            f.write(content)
        print(f"  Created: {spec_file}")
    
    print(f"  Project Type Detected: {project_type}")


def create_test_scaffold(root_dir: str):
    tests_dir = os.path.join(root_dir, "tests")
    
    dirs = [
        tests_dir,
        os.path.join(tests_dir, "unit"),
        os.path.join(tests_dir, "integration"),
        os.path.join(tests_dir, "api"),
        os.path.join(tests_dir, "e2e"),
    ]
    
    for d in dirs:
        os.makedirs(d, exist_ok=True)
        print(f"  Created: {d}/")
    
    _write_file(os.path.join(tests_dir, "__init__.py"), INIT_PY)
    _write_file(os.path.join(tests_dir, "conftest.py"), CONFTEST_PY)
    _write_file(os.path.join(tests_dir, "factories.py"), FACTORIES_PY)
    _write_file(os.path.join(tests_dir, "unit", "__init__.py"), INIT_PY)
    _write_file(os.path.join(tests_dir, "integration", "__init__.py"), INIT_PY)
    _write_file(os.path.join(tests_dir, "integration", "conftest.py"), DB_CONFTEST_PY)
    _write_file(os.path.join(tests_dir, "api", "__init__.py"), INIT_PY)
    _write_file(os.path.join(tests_dir, "api", "conftest.py"), API_CONFTEST_PY)
    _write_file(os.path.join(tests_dir, "e2e", "__init__.py"), INIT_PY)
    
    pyproject = os.path.join(root_dir, "pyproject.toml")
    if os.path.exists(pyproject):
        with open(pyproject, "r") as f:
            content = f.read()
        if "[tool.pytest.ini_options]" not in content:
            with open(pyproject, "a") as f:
                f.write("\n" + PYTEST_CONFIG_TOML)
            print(f"  Appended pytest config to: {pyproject}")
        else:
            print(f"  pytest config already in: {pyproject}")
    else:
        _write_file(pyproject, PYTEST_CONFIG_TOML)


def main():
    parser = argparse.ArgumentParser(description="ALTAS Workflow Scaffold Generator")
    parser.add_argument("task_name", nargs="?", default="new-feature", help="Task name for the spec file")
    parser.add_argument("--type", choices=["spec", "test", "all"], default="spec", help="Scaffold type: spec (mydocs/), test (tests/), or all")
    parser.add_argument("--template", choices=["full", "lite"], default="full", help="Spec template type")
    parser.add_argument("--root", default=".", help="Project root directory (default: current directory)")
    
    args = parser.parse_args()
    root_dir = os.path.abspath(args.root)
    
    if not os.path.isdir(root_dir):
        print(f"Error: {root_dir} is not a valid directory")
        sys.exit(1)
    
    print(f"ALTAS Workflow Scaffold Generator")
    print(f"Project Root: {root_dir}")
    print(f"Scaffold Type: {args.type}")
    if args.type in ("spec", "all"):
        print(f"Task Name: {args.task_name}")
        print(f"Template: {args.template}")
    print()
    
    if args.type in ("spec", "all"):
        print("Generating spec scaffold...")
        create_spec_scaffold(root_dir, args.task_name, args.template)
        print()
    
    if args.type in ("test", "all"):
        print("Generating test scaffold...")
        create_test_scaffold(root_dir)
        print()
    
    print("Scaffold generated successfully!")
    print()
    print("Next steps:")
    if args.type in ("spec", "all"):
        print(f"  1. Edit mydocs/specs/{args.task_name}.md to fill in requirements")
        print(f"  2. Generate codemap in mydocs/codemap/")
        print(f"  3. Add context files to mydocs/context/")
    if args.type in ("test", "all"):
        print(f"  - Edit tests/conftest.py to add project-specific fixtures")
        print(f"  - Edit tests/factories.py to define test data factories")
        print(f"  - Edit tests/api/conftest.py to configure API client")
        print(f"  - Edit tests/integration/conftest.py to configure database")
        print(f"  - Run: pytest --collect-only to verify test discovery")


if __name__ == "__main__":
    main()

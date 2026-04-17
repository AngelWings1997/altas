"""Shared pytest bootstrap template.

Copy into `tests/conftest.py` and adjust project-specific imports, markers,
and environment variables.
"""

from __future__ import annotations

import os
from collections.abc import Iterator

import pytest


def pytest_configure(config: pytest.Config) -> None:
    """Register common markers so CI can filter test layers consistently."""
    config.addinivalue_line("markers", "unit: fast isolated unit tests")
    config.addinivalue_line("markers", "integration: tests with real dependencies")
    config.addinivalue_line("markers", "contract: tests that validate API contracts")
    config.addinivalue_line("markers", "slow: tests with higher runtime cost")


@pytest.fixture(scope="session")
def api_base_url() -> str:
    """Centralize API base URL so local and CI runs use one entry point."""
    return os.getenv("TEST_API_BASE_URL", "http://localhost:8000")


@pytest.fixture(scope="session")
def default_timeout() -> float:
    return float(os.getenv("TEST_HTTP_TIMEOUT", "10"))


@pytest.fixture
def test_run_metadata() -> dict[str, str]:
    """Expose run metadata for logging, report enrichment, or trace headers."""
    return {
        "env": os.getenv("TEST_ENV", "local"),
        "build_id": os.getenv("CI_BUILD_ID", "manual"),
    }


@pytest.fixture(autouse=True)
def reset_environment(monkeypatch: pytest.MonkeyPatch) -> Iterator[None]:
    """Set deterministic defaults that keep tests independent."""
    monkeypatch.setenv("APP_ENV", "test")
    monkeypatch.setenv("TZ", "UTC")
    yield

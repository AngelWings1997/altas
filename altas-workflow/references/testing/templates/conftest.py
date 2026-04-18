"""Shared pytest bootstrap template.

Copy into `tests/conftest.py` and adjust project-specific imports, markers,
and environment variables.
"""

from __future__ import annotations

import os
from collections.abc import Iterator

import pytest


def pytest_configure(config: pytest.Config) -> None:
    config.addinivalue_line("markers", "unit: fast isolated unit tests")
    config.addinivalue_line("markers", "integration: tests with real dependencies")
    config.addinivalue_line("markers", "contract: tests that validate API contracts")
    config.addinivalue_line("markers", "slow: tests with higher runtime cost")
    config.addinivalue_line("markers", "e2e: end-to-end tests")
    config.addinivalue_line("markers", "flaky: known flaky tests (reruns enabled)")


@pytest.fixture(scope="session")
def api_base_url() -> str:
    return os.getenv("TEST_API_BASE_URL", "http://localhost:8000")


@pytest.fixture(scope="session")
def default_timeout() -> float:
    return float(os.getenv("TEST_HTTP_TIMEOUT", "10"))


@pytest.fixture
def test_run_metadata() -> dict[str, str]:
    return {
        "env": os.getenv("TEST_ENV", "local"),
        "build_id": os.getenv("CI_BUILD_ID", "manual"),
    }


@pytest.fixture(autouse=True)
def reset_environment(monkeypatch: pytest.MonkeyPatch) -> Iterator[None]:
    monkeypatch.setenv("APP_ENV", "test")
    monkeypatch.setenv("TZ", "UTC")
    yield


@pytest.fixture(autouse=True)
def _seed_random(faker):
    faker.seed_instance(42)


@pytest.fixture
def env_vars(monkeypatch: pytest.MonkeyPatch):
    def _set(**kwargs):
        for key, value in kwargs.items():
            monkeypatch.setenv(key, str(value))
    return _set


@pytest.fixture
def tmp_data_dir(tmp_path):
    data_dir = tmp_path / "test_data"
    data_dir.mkdir()
    return data_dir

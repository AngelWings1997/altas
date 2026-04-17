"""Reusable API client fixture template.

Copy into `tests/api/conftest.py` or merge into `tests/conftest.py`.
"""

from __future__ import annotations

from collections.abc import Iterator

import pytest
import requests


class APIClient:
    """Thin wrapper that keeps tests readable and centralizes defaults."""

    def __init__(self, base_url: str, timeout: float = 10) -> None:
        self.base_url = base_url.rstrip("/")
        self.timeout = timeout
        self.session = requests.Session()
        self.session.headers.update(
            {
                "Accept": "application/json",
                "Content-Type": "application/json",
            }
        )

    def request(self, method: str, path: str, **kwargs: object) -> requests.Response:
        return self.session.request(
            method=method,
            url=f"{self.base_url}{path}",
            timeout=self.timeout,
            **kwargs,
        )

    def get(self, path: str, **kwargs: object) -> requests.Response:
        return self.request("GET", path, **kwargs)

    def post(self, path: str, **kwargs: object) -> requests.Response:
        return self.request("POST", path, **kwargs)

    def put(self, path: str, **kwargs: object) -> requests.Response:
        return self.request("PUT", path, **kwargs)

    def delete(self, path: str, **kwargs: object) -> requests.Response:
        return self.request("DELETE", path, **kwargs)

    def close(self) -> None:
        self.session.close()


@pytest.fixture
def api_client(api_base_url: str, default_timeout: float) -> Iterator[APIClient]:
    client = APIClient(base_url=api_base_url, timeout=default_timeout)
    yield client
    client.close()

"""Authentication fixture template for API tests."""

from __future__ import annotations

import os

import pytest


@pytest.fixture
def auth_credentials() -> dict[str, str]:
    """Use dedicated test credentials; avoid reusing real accounts."""
    return {
        "username": os.getenv("TEST_USERNAME", "test-user"),
        "password": os.getenv("TEST_PASSWORD", "test-password"),
    }


@pytest.fixture
def access_token(api_client, auth_credentials: dict[str, str]) -> str:
    """Replace endpoint and response parsing with project conventions."""
    response = api_client.post("/api/auth/login", json=auth_credentials)
    assert response.status_code == 200, response.text
    body = response.json()
    return body["access_token"]


@pytest.fixture
def auth_headers(access_token: str) -> dict[str, str]:
    return {"Authorization": f"Bearer {access_token}"}


@pytest.fixture
def authenticated_api_client(api_client, auth_headers: dict[str, str]):
    api_client.session.headers.update(auth_headers)
    return api_client


@pytest.fixture
def admin_auth_headers(api_client) -> dict[str, str]:
    """Optional fixture for permission / role matrix tests."""
    response = api_client.post(
        "/api/auth/login",
        json={
            "username": os.getenv("TEST_ADMIN_USERNAME", "admin-user"),
            "password": os.getenv("TEST_ADMIN_PASSWORD", "admin-password"),
        },
    )
    assert response.status_code == 200, response.text
    return {"Authorization": f"Bearer {response.json()['access_token']}"}

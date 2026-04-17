"""SQLAlchemy rollback fixture template for integration tests."""

from __future__ import annotations

from collections.abc import Iterator

import pytest
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker


TEST_DATABASE_URL = "postgresql://test:test@localhost/test_db"


@pytest.fixture(scope="session")
def db_engine():
    """Replace URL and metadata bootstrap with project-specific settings."""
    engine = create_engine(TEST_DATABASE_URL)
    yield engine
    engine.dispose()


@pytest.fixture
def db_session(db_engine) -> Iterator[Session]:
    """Wrap each test in a transaction so cleanup stays deterministic."""
    connection = db_engine.connect()
    transaction = connection.begin()
    session_factory = sessionmaker(bind=connection, autoflush=False, autocommit=False)
    session = session_factory()

    try:
        yield session
    finally:
        session.close()
        transaction.rollback()
        connection.close()


@pytest.fixture
def override_db_dependency(monkeypatch: pytest.MonkeyPatch, db_session: Session) -> None:
    """Patch framework dependency injection to point at the rollback session."""
    monkeypatch.setattr("app.dependencies.get_db_session", lambda: db_session)

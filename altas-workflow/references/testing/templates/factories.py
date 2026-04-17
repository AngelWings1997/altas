"""factory_boy + Faker template for test data creation.

Install:
    pip install factory-boy faker
"""

from __future__ import annotations

import factory
from faker import Faker


fake = Faker("en_US")


class UserFactory(factory.DictFactory):
    """Simple payload factory for API and service tests."""

    username = factory.LazyFunction(lambda: fake.user_name())
    email = factory.LazyAttribute(lambda obj: f"{obj['username']}@example.com")
    password = factory.LazyFunction(lambda: fake.password(length=16))
    role = "user"


class AdminUserFactory(UserFactory):
    role = "admin"


class OrderPayloadFactory(factory.DictFactory):
    """Example request payload for order API tests."""

    external_id = factory.LazyFunction(lambda: fake.uuid4())
    currency = "USD"
    amount = factory.LazyFunction(lambda: round(fake.pydecimal(left_digits=3, right_digits=2, positive=True), 2))
    items = factory.LazyFunction(
        lambda: [
            {
                "sku": fake.bothify(text="SKU-####"),
                "quantity": 1,
                "price": 19.99,
            }
        ]
    )


def make_invalid_email_payload() -> dict[str, str]:
    payload = UserFactory()
    payload["email"] = "not-an-email"
    return payload

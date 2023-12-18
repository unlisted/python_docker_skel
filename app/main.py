from random import randrange
from typing import Generator
from collections import namedtuple

Payment = namedtuple('Payment', ['id', 'amount'])


def gen_random_payment(n: int) -> Generator[Payment, None, None]:
    for __main__ in range(n):
        yield Payment(
            id=f"payment_{randrange(1000)}",
            amount=randrange(100, 1000, 5)
        )

if __name__ == "__main__":
    for payment in gen_random_payment(10):
        print(payment)
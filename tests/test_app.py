from app.main import gen_random_payment


def test_gen_random_payment():
    payments = list(gen_random_payment(10))
    assert len(payments) == 10
    assert all(isinstance(payment.id, str) for payment in payments)
    assert all(isinstance(payment.amount, int) for payment in payments)
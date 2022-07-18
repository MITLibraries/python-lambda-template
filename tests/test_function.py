from lambdas.my_function import lambda_handler


def test_my_function():
    assert lambda_handler({}, {}) == "You have successfully called this lambda!"

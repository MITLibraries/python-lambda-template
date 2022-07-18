import json
import logging

logger = logging.getLogger(__name__)
logger.setLevel(logging.DEBUG)


def lambda_handler(event: dict, context: object) -> str:  # noqa
    logger.debug(json.dumps(event))
    return "You have successfully called this lambda!"

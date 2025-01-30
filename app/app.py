import logging
import sys
from argparse import ArgumentParser

from src.sample_modules.calculators import Calculator

logging.basicConfig(level=logging.INFO)


def get_arg_parser() -> ArgumentParser:
    """Return an argumentparser which requires two magic numbers to add."""
    argparser = ArgumentParser()

    argparser.add_argument(
        "--a",
        metavar="a",
        type=int,
        required=True,
        help="first magic int to add",
    )

    argparser.add_argument(
        "--b",
        metavar="b",
        type=int,
        required=True,
        help="second magic int to add",
    )

    return argparser


def main():
    logger = logging.getLogger(__name__)
    logger.setLevel(logging.INFO)

    parser = get_arg_parser()
    args = parser.parse_args(args=None if sys.argv[1:] else ["--help"])
    res = Calculator.add(args.a, args.b)
    logger.info(f"Result of adding {args.a} and {args.b} is {res}")


if __name__ == "__main__":
    main()

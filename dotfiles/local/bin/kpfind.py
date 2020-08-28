import argparse
import sys

from pykeepass import PyKeePass


def panic(exn: Exception) -> None:
    print(exn, file=sys.stderr)
    exit(1)


def open_db(name: str) -> PyKeePass:
    password = sys.stdin.read()
    try:
        return PyKeePass(name, password=password)
    except Exception as exn:
        panic(exn)


def find(db: PyKeePass, title: str) -> str:
    entry = db.find_entries(title=title, first=True)
    if entry is None:
        print(f"Entry not found: {title}", file=sys.stderr)
        exit(1)
    return entry.password


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="kpfind")
    parser.add_argument("database")
    parser.add_argument("title")

    args = parser.parse_args()

    db = open_db(args.database)
    password = find(db, args.title)
    print(password)

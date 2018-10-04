import argparse
import os
import sys


HOME = os.environ.get("HOME")
assert HOME
HERE = os.path.join(os.path.dirname(os.path.abspath(__file__)), "dotfiles")


class Link:
    def __init__(self, source, target):
        self.source = source
        self.target = target

    def __str__(self):
        return f"ln -s {self.source} {self.target}"

    def execute(self):
        raise NotImplementedError()


class Ignore:
    def __init__(self, file):
        self.file = file

    def __str__(self):
        return f"Ignoring {self.file}"

    def execute(self):
        pass


class Error:
    def __init__(self, file):
        self.file = file

    def __str__(self):
        return f"There is a problem with: {self.file}"

    def execute(self):
        print(str(self), file=sys.stderr)


def build_cmd_list(location, cmds):
    real_location = location if location else "."
    for filename in os.listdir(real_location):
        # Avoid hidden files like `.git`
        if filename.startswith("."):
            continue
        file = os.path.join(location, filename)
        source = os.path.join(HERE, file)
        target = os.path.join(HOME, "." + file)

        if not os.path.exists(target):
            cmds.append(Link(source, target))
        elif os.path.islink(target):
            cmds.append(Ignore(file))
        elif os.path.isdir(target) and os.path.isdir(file):
            build_cmd_list(file, cmds)
        else:
            cmds.append(Error(file))


parser = argparse.ArgumentParser()
parser.add_argument("--dry-run", action="store_const", const=True)


if __name__ == "__main__":
    config = parser.parse_args()
    os.chdir("dotfiles")
    commands = []
    build_cmd_list("", commands)
    if config.dry_run:
        for cmd in commands:
            print(cmd)
    else:
        raise NotImplementedError()

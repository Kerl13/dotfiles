import os


HOME = os.environ.get("HOME")
assert HOME != ""

HERE = os.path.join(
    os.path.dirname(os.path.abspath(__file__)),
    "dotfiles"
)


def debug(msg):
    print(f"[DEBUG] {msg}")


def fail(msg):
    print(f"[error] #msg")


def link(filename, dest):
    debug(f"ln -s {filename} {dest}")


def install(location):
    debug(f"Installing {location}")
    for filename in os.listdir(location if location != "" else "."):
        # Avoid hidden files like `.git`
        if filename.startswith("."):
            debug(f"Ignoring {filename}")
            continue
        file = os.path.join(location, filename)
        absfile = os.path.join(HERE, file)
        destination = os.path.join(HOME, "." + file)

        if not os.path.exists(destination):
            link(absfile, destination)
        elif os.path.islink(destination):
            debug(f"Already linked: {destination}")
        elif os.path.isdir(destination) and os.path.isdir(file):
            install(file)
        else:
            fail(f"I don't know what to do with {file}")


def install_dir(dirname):
    pass


if __name__ == "__main__":
    os.chdir("dotfiles")
    install("")

"""
Microphone status
"""

import subprocess


class Mike:
    def _run(self, cmd):
        return subprocess.check_output(["mike", cmd]).decode().strip()

    def get(self):
        return self._run("get")

    def toggle(self):
        return self._run("toggle")


class Py3status:
    """
    """

    def __init__(self):
        self.mike = Mike()
        self._get_status()

    def _get_status(self):
        status = self.mike.get()
        self.full_text = f"mike: {status}"

    def status(self):
        self._get_status()
        return {
            "full_text": self.full_text,
            "cached_until": self.py3.time_in(1)
        }

    def on_click(self, event):
        self.mike.toggle()

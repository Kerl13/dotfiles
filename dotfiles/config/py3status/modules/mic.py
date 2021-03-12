"""
Microphone status
"""

import subprocess


class Mic:
    def _run(self, cmd):
        return subprocess.check_output(["mic", cmd]).decode().strip()

    def get(self):
        return self._run("get")

    def toggle(self):
        return self._run("toggle")


class Py3status:
    """
    """

    def __init__(self):
        self.mic = Mic()
        self._get_status()

    def _get_status(self):
        status = self.mic.get()
        self.full_text = f"mic: {status}"

    def status(self):
        self._get_status()
        return {
            "full_text": self.full_text,
            "cached_until": self.py3.time_in(1)
        }

    def on_click(self, event):
        self.mic.toggle()

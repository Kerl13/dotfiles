"""
Interface to my custom X keyboard switcher.
"""

import subprocess


class XKBSwitch:
    def _run(self, cmd):
        return subprocess.check_output(["xkbswitch", cmd]).decode().strip()

    def get(self):
        return self._run("get")

    def toggle(self):
        return self._run("toggle")


class Py3status:
    """
    """

    def __init__(self):
        self.xkbs = XKBSwitch()
        self._get_layout()

    def _get_layout(self):
        layout = self.xkbs.get()
        self.full_text = f": {layout}"

    def click_info(self):
        return {
            "full_text": self.full_text,
            "cached_until": self.py3.time_in(3)
        }

    def on_click(self, event):
        self.xkbs.toggle()
        self._get_layout()

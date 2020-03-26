import re
import subprocess


class XRandR:
    def __init__(self, lines=None):
        display_re = r"""(?P<name>\S+)\s
        (?P<connected>disconnected|connected)\s
        (?P<primary>primary\s)?
        (?P<width>\d+)x(?P<height>\d+)"""

        if lines is None:
            lines = subprocess.check_output(["xrandr"], text=True).splitlines()

        self.displays = []
        for line in lines:
            res = re.match(display_re, line, re.VERBOSE)
            if res:
                res = res.groupdict()

                width = int(res["width"])
                height = int(res["height"])

                [height, width] = sorted((width, height))

                self.displays.append(
                    {
                        **res,
                        "connected": res["connected"] == "connected",
                        "primary": res["primary"] is not None,
                        "width": width,
                        "height": height,
                    }
                )

        # sort by largest display (pixel count)
        self.displays.sort(key=lambda d: d["width"] * d["height"], reverse=True)

    def __str__(self):
        return "\n".join(repr(d) for d in self.displays)

    def __iter__(self):
        return self.displays.__iter__()

    @property
    def connected(self):
        return [d for d in self.displays if d["connected"]]

    @property
    def disconnected(self):
        return [d for d in self.displays if not d["connected"]]

    @property
    def primary(self):
        for d in self.connected:
            if d["primary"]:
                return d

    @property
    def secondary(self):
        return [d for d in self.connected if not d["primary"]]

    def dim(self, x, y):
        return f"{x}x{y}"

    def xrandr_display(
        self,
        vertical=False,
        rotate=None,
        x_offset=0,
        y_offset=0,
        primary=False,
        **kwargs,
    ):
        dimensions = self.dim(kwargs["width"], kwargs["height"])

        pos = self.dim(x_offset, y_offset)

        if rotate is None:
            rotate = "normal"

        pri = "--primary" if primary else ""

        return f'--output {kwargs["name"]} {pri} --mode {dimensions} --pos {pos} --rotate {rotate}'

    def cmd(self, displays_with_kwargs):
        "returns the xrandr command for the given displays"
        disp_strings = []
        x_offset = 0
        for disp in displays_with_kwargs:
            disp_strings.append(self.xrandr_display(**disp, x_offset=x_offset))
            x_offset += disp["height"] if disp.get("vertical") else disp["width"]

        return f'xrandr {" ".join(disp_strings)}'


def init_displays(randr):
    disps = [randr.primary]

    # handle secondary vertical screen on desktop
    if randr.primary["width"] >= 3440 and randr.secondary:
        # NOTE: mutliple secondary displays are not implemented!
        disps = [
            {**randr.secondary[0], "vertical": True, "rotate": "left"},
            {**randr.primary, "y_offset": 258},
        ]

    return randr.cmd(disps)
    # XRandR()


# os.system(init_displays(randr))

XRANDR_MONITORS = {}
ULTRAWIDE_NAME = None
VERTICAL_NAME = None


def mon_name(name):
    if "." in name:
        return f"%{name}"
    return name


### COMPUTE CONSTANTS ###

for mon in XRandR():
    XRANDR_MONITORS[mon["name"]] = mon

    if mon["width"] >= 3440:
        ULTRAWIDE_NAME = mon_name(mon["name"])
    if mon["width"] < mon["height"]:
        VERTICAL_NAME = mon_name(mon["name"])

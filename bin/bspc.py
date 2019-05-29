import json
from subprocess import check_output, run

BAR_HEIGHT = 30


def _resize_to_aspect_ratio(width, height, aspect):
    current_aspect = width / float(height)

    # crop left and right edges:
    if current_aspect > aspect:
        return int(aspect * height), height
    # crop top and bottom:
    else:
        return width, int(width / aspect)


def config(*args):
    args = [str(a) for a in ["bspc", "config", *args]]
    return run(args)


def node(*args):
    args = [str(a) for a in ["bspc", "node", *args]]
    return run(args)


def query(*args):
    args = [str(a) for a in ["bspc", "query", *args]]
    return check_output(args).decode("ascii").splitlines()


def tree(*args):
    args = [str(a) for a in ["bspc", "query", "--tree", *args]]
    return json.loads(check_output(args).decode("ascii"))


def monitor_geometry():
    geometry = tree("--monitor", "focused")["rectangle"]
    return {
        "w": geometry["width"],
        "h": geometry["height"],
        "x": geometry["x"],
        "y": geometry["y"],
    }


def window_geometry():
    t = tree("--node", "focused")
    is_floating = t["client"]["state"] == "floating"
    geometry = t["client"]["floatingRectangle" if is_floating else "tiledRectangle"]

    return {
        "w": geometry["width"],
        "h": geometry["height"],
        "x": geometry["x"],
        "y": geometry["y"],
    }


def resize_window(target_w, target_h):
    """
    target_w or target_h is a percentage of monitor width if expressed as a float
    NOTE: window is constrained to an aspect ratio of 16:9
    """
    mon = monitor_geometry()
    win = window_geometry()

    if isinstance(target_w, float):
        target_w = int(target_w * mon["w"])
    if isinstance(target_h, float):
        target_h = int(target_h * mon["h"])

    # force landscape
    if target_w < target_h:
        target_w, target_h = target_h, target_w

    target_w, target_h = _resize_to_aspect_ratio(target_w, target_h, 16.0 / 9)

    # set the width of pip window
    node("--resize", "bottom_right", target_w - win["w"], target_h - win["h"])


def move_window_to_corner(loc=None, *, pad_x=0, pad_y=0):
    mon = monitor_geometry()
    win = window_geometry()

    if loc is None or loc == "center":
        loc = "center-center"
    vert, hori = loc.split("-")

    if hori == "left":
        dx = mon["x"] - win["x"]
    elif hori == "center":
        dx = mon["x"] + mon["w"] / 2 - win["w"] / 2 - win["x"]
        pad_x = 0
    elif hori == "right":
        dx = mon["x"] + mon["w"] - win["w"] - win["x"]
        pad_x = -pad_x

    if vert == "top":
        dy = mon["y"] - win["y"]
        pad_y = BAR_HEIGHT + pad_y
    elif vert == "center":
        dy = mon["y"] + mon["h"] / 2 - win["h"] / 2 - win["y"]
        pad_y = BAR_HEIGHT
    elif vert == "bottom":
        dy = mon["y"] + mon["h"] - win["h"] - win["y"]
        pad_y = -pad_y

    node("--move", int(dx + pad_x), int(dy + pad_y))

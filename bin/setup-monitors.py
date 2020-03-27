from bspc import cmd, XRandR, ENVIRONMENT
import bspc


def xrandr_cmd(randr):
    # handle secondary vertical screen on desktop
    if ENVIRONMENT == "desktop":
        # TODO: handle multiple secondary displays?
        disps = [
            {**randr.secondary[0], "vertical": True, "rotate": "left"},
            {**randr.primary, "y_offset": 258},
        ]
    else:
        disps = [randr.primary]

    # piece together and run the xrandr command
    disp_args = ["xrandr"]
    x_offset = 0
    for disp in disps:
        disp_args.extend(randr.xrandr_display_args(**disp, x_offset=x_offset))
        x_offset += disp["height"] if disp.get("vertical") else disp["width"]

    print(disp_args)
    # cmd(disp_args)


def bspwm_desktops(randr, debug=False):
    mon_names = [randr.primary["bspwm_name"]] + [
        m["bspwm_name"] for m in randr.secondary
    ]
    desktop_names = list(range(1, 1 + 10))

    # distribute the desktops across multiple secondaries
    quot, rem = divmod(len(desktop_names), len(mon_names))
    cnt = 0
    for idx, n in enumerate(range(quot)):
        if idx + 1 <= rem:
            desk_args = desktop_names[cnt : cnt + quot + 1]
            cnt += quot + 1
        else:
            desk_args = desktop_names[cnt : cnt + quot]
            cnt += quot

        bspc.cmd(["bspc", "monitor", mon_names[idx], "-d", *desk_args], debug=debug)


def bspwm_padding():
    bar_height = 30

    if ENVIRONMENT == "desktop":
        window_gap = 15
        padding = 15
    else:
        window_gap = 8
        padding = 8

    bspc.config("window_gap", window_gap)
    bspc.config("top_padding", padding + bar_height)
    bspc.config("left_padding", padding)
    bspc.config("right_padding", padding)
    bspc.config("bottom_padding", padding)


if __name__ == "__main__":
    randr = XRandR()

    # run xrandr to setup the monitors
    xrandr_cmd(randr)

    # setup window borders
    bspwm_padding()

    # setup desktops
    bspwm_desktops(randr, debug=True)

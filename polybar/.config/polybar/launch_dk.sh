#!/usr/bin/env sh

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

# launch polybar for all monitors
if xrandr | grep "eDP1 connected"; then
    polybar laptop &
else
    polybar primary_dk &
    polybar secondary_dk &

    if xrandr | grep "HDMI-0 connected"; then
        polybar tertiary_dk &
    fi
fi

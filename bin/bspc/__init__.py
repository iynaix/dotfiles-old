import sys

from .bspc import *
from .xrandr import XRandR, XRANDR_MONITORS, ULTRAWIDE_NAME, VERTICAL_NAME
from .utils import p, rget


# capture and print all errors for easier debugging
def log_exception(exctype, value, tb):
    p("=======ERROR=======")
    p("Type:", exctype)
    p("Value:", value)
    p("Traceback:", tb)
    p("===================")


sys.excepthook = log_exception

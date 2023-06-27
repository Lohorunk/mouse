# Package

version     = "2.1"
author      = "hiikion"
description = "Programmatic control of the mouse"
license     = "MPL2.0"

# Deps

requires "nim >= 0.10.0"

when defined(windows):
    requires "winim"

when defined(linux):
    requires "x11"
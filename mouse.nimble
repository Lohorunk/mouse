# Package

version     = "2.0"
author      = "hiikion"
description = "Mouse interactions in nim"
license     = "MPL2.0"

# Deps

requires "nim >= 0.10.0"

when defined(windows):
    requires "winim >= 3.8.0"
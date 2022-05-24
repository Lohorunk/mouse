# Package

version     = "1.1"
author      = "hiikion"
description = "Mouse interactions in nim"
license     = "MPL2.0"

# Deps

requires "nim >= 0.10.0"

when defined(windows):
    requires "winim >= 3.8.0"

when defined(linux):
    import distros

    before install:
        foreignDep "xdo"

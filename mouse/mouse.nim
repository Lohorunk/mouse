import os


type
    Vec2D* = tuple
        x: int
        y: int

proc lerp*(start: Vec2D, `end`: Vec2D, dist: float): Vec2D =
    var
        x = (1.0 - dist) * float(start.x) + dist * float(`end`.x)
        y = (1.0 - dist) * float(start.y) + dist * float(`end`.y)

    return (int(x), int(y))

proc calcRelative*(curent: Vec2D, dest: Vec2D): Vec2D = 
    var x,y = 0

    if curent.x > dest.x:
        var x = curent.x - dest.x
    elif curent.x < dest.x:
        var x = dest.x - curent.x
    elif curent.x == dest.x:
        var x = 0
    
    if curent.y > dest.y:
        var y = curent.y - dest.y
    elif curent.y < dest.y:
        var y = dest.y - curent.y
    elif curent.y == dest.y:
        var y = 0

    return (x, y)


when defined(windows):
    import winim/lean

    type 
        ButtonTuple = tuple
            Press: int
            Release: int

    const
        Left*: ButtonTuple = (MOUSEEVENTF_LEFTDOWN, MOUSEEVENTF_LEFTUP)
        Right*: ButtonTuple = (MOUSEEVENTF_RIGHTDOWN, MOUSEEVENTF_RIGHTUP)
        Midle*: ButtonTuple = (MOUSEEVENTF_MIDDLEDOWN, MOUSEEVENTF_MIDDLEUP)
        X*: ButtonTuple = (MOUSEEVENTF_XDOWN, MOUSEEVENTF_XUP)

        Horizontal*: int = MOUSEEVENTF_HWHEEL
        Vertical*: int = MOUSEEVENTF_WHEEL

        Relative*: string = "relative"
        Absolute*: string = "absolute"




    proc click*(button: ButtonTuple, x = 0, y = 0) =
        mouse_event(DWORD(button.Press), DWORD(x), DWORD(y), 0, 0)
        mouse_event(DWORD(button.Release), DWORD(x), DWORD(y), 0, 0)

    proc press*(button: ButtonTuple, x = 0, y = 0) =
        mouse_event(DWORD(button.Press), DWORD(x), DWORD(y), 0, 0)

    proc release*(button: ButtonTuple, x = 0, y = 0) =
        mouse_event(DWORD(button.Release), DWORD(x), DWORD(y), 0, 0)

    proc move*(x: int32, y: int32, `type` = Relative) =
        if `type` == "relative":
            mouse_event(0x1, DWORD(x), DWORD(y), 0, 0)
        elif `type` == "absolute":
            SetCursorPos(x, y)

    proc smoothMove*(x: int, y: int, smoothingStep: float, `sleep` = 3, `type` = Absolute) = 
        var currPos: Point
        GetCursorPos(currPos)

        if `type` == "relative":
            var x,y = calcRelative((int(currPos.x), int(currPos.y)), (x,y))

        var i = 0.0
        while i < 1.0:
            var vec = lerp((int(currPos.x), int(currPos.y)), (x, y), i)
            debugEcho vec

            SetCursorPos(int32(vec.x), int32(vec.y))

            sleep(`sleep`)
            i += smoothingStep

    proc scroll*(amount: int, orientation = Vertical, globalDelta = 120) =
        var finalAmount: int = amount * globalDelta
        mouse_event(DWORD(orientation), 0, 0, DWORD(finalAmount), 0)

    proc isPressed*(button: int32): bool =
        return bool(GetAsyncKeyState(button))

    proc getPos*: Point =
        var pos: Point
        GetCursorPos(pos)

        return pos

when defined(linux):
    import strutils


    proc validateButton(button: string or int): string = # bad code, probably will rewrite later
        if button.type == string:
            try:
                case parseInt(button):
                    of 1 or 2 or 3:
                        return button
                    else:
                        return "invalid"
            except:
                case lower(button):
                    of "left":
                        return 1
                    of "right":
                        return 2
                    of "middle":
                        return 3
                    else:
                        return "invalid"

        elif button.type == int:
            case button:
                of 1 or 2 or 3:
                     return button
                else:
                    return "invalid"

        else:
            return "invalid"




    template click*(button: string or int): string =
        var button = validateButton(button)
        fmt"xdo button_press -k {button};xdo button_release -k {button};"

    template press*(button: string or int): string =
        var button = validateButton(button)
        fmt"xdo button_press -k {button}"

    template release*(button: string or int): string =
        var button = validateButton(button)
        fmt"xdo button_release -k {button}"
    
    template move*(x,y: string or int): string =
        fmt"xdo pointer_motion -x {x} -y {y};"

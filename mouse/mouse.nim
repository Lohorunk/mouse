import std/[os, strutils, strformat]

type
    Vec2D* = tuple
        x: int
        y: int
    
    MouseButton* = enum
        Left, Right, Middle
    
    PositionKind* = enum
        Relative, Absolute
    
    ScrollOrientation* = enum
        Horizontal, Vertical

proc lerp*(start: Vec2D, finish: Vec2D, dist: float): Vec2D =
    var
        x = (1.0 - dist) * float(start.x) + dist * float(finish.x)
        y = (1.0 - dist) * float(start.y) + dist * float(finish.y)

    return (int(x), int(y))

proc calcRelative*(cur: Vec2D, dest: Vec2D): Vec2D = 
    var
        x, y: int

    if cur.x > dest.x:
        x = cur.x - dest.x
    elif cur.x < dest.x:
        x = dest.x - cur.x
    elif cur.x == dest.x:
        x = 0
    
    if cur.y > dest.y:
        y = cur.y - dest.y
    elif cur.y < dest.y:
        y = dest.y - cur.y
    elif cur.y == dest.y:
        y = 0

    return (x, y)


when defined(windows):
    import winim/lean

    type 
        ButtonTuple = tuple
            Press: int
            Release: int

    const
        MouseButtonToEvent: array[MouseButton, ButtonTuple] = [
            Left: (MOUSEEVENTF_LEFTDOWN, MOUSEEVENTF_LEFTUP),
            Right: (MOUSEEVENTF_RIGHTDOWN, MOUSEEVENTF_RIGHTUP),
            Middle: (MOUSEEVENTF_MIDDLEDOWN, MOUSEEVENTF_MIDDLEUP)
        ]
        X*: ButtonTuple = (MOUSEEVENTF_XDOWN, MOUSEEVENTF_XUP)

        ScrollOrientationToEvent = [
            Horizontal: MOUSEEVENTF_HWHEEL,
            Vertical: MOUSEEVENTF_WHEEL
        ]



    proc click*(button: MouseButton, x = 0, y = 0) =
        mouse_event(DWORD(MouseButtonToEvent[button].Press), DWORD(x), DWORD(y), 0, 0)
        mouse_event(DWORD(MouseButtonToEvent[button].Release), DWORD(x), DWORD(y), 0, 0)

    proc press*(button: MouseButton, x = 0, y = 0) =
        mouse_event(DWORD(MouseButtonToEvent[button].Press), DWORD(x), DWORD(y), 0, 0)

    proc release*(button: MouseButton, x = 0, y = 0) =
        mouse_event(DWORD(MouseButtonToEvent[button].Release), DWORD(x), DWORD(y), 0, 0)

    proc move*(x, y: int, typ = Relative) =
        case typ
        of Relative:
            mouse_event(0x1, DWORD(x), DWORD(y), 0, 0)
        of Absolute:
            SetCursorPos(int32 x, int32 y)

    proc smoothMove*(x: int, y: int, smoothingStep: float, sleep = 3, typ = Absolute) = 
        var currPos: Point
        GetCursorPos(currPos)

        var
            x = x
            y = y
        if typ == Relative:
            (x, y) = calcRelative((int(currPos.x), int(currPos.y)), (x,y))

        var i = 0.0
        while i < 1.0:
            var vec = lerp((int(currPos.x), int(currPos.y)), (x, y), i)

            SetCursorPos(int32(vec.x), int32(vec.y))

            sleep(sleep)
            i += smoothingStep

    proc scroll*(amount: int, orientation = Vertical, globalDelta = 120) =
        var finalAmount: int = amount * globalDelta
        mouse_event(DWORD(ScrollOrientationToEvent[orientation]), 0, 0, DWORD(finalAmount), 0)

    proc isPressed*(button: int32): bool =
        bool(GetAsyncKeyState(button))

    proc getPos*: Point =
        discard GetCursorPos(result)

when defined(linux):
    proc buttonToXdotool(button: MouseButton): string =
        $(int(button) + 1)

    proc click*(button: MouseButton) =
        var button = buttonToXdotool(button)
        let cmd = fmt"xdo button_press -k {button};xdo button_release -k {button};"
        discard execShellCmd(cmd) # todo: handle xdo errors

    proc press*(button: MouseButton) =
        var button = buttonToXdotool(button)
        discard execShellCmd fmt"xdo button_press -k {button}"

    proc release*(button: MouseButton) =
        var button = buttonToXdotool(button)
        discard execShellCmd fmt"xdo button_release -k {button}"
    
    proc move*(x, y: int) =
        discard execShellCmd fmt"xdo pointer_motion -x {x} -y {y};"

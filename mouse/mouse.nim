import std/os

type
    Vec2D* = tuple
        x: int
        y: int
    
    MouseButton* = enum
        Left, Right, Middle
    
    PositionKind* = enum
        Relative, Absolute
    
    ScrollDirection* = enum
        Up, Down

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


    proc click*(button: MouseButton, x = 0, y = 0) =
        mouse_event(DWORD(MouseButtonToEvent[button].Press), DWORD(x), DWORD(y), 0, 0)
        mouse_event(DWORD(MouseButtonToEvent[button].Release), DWORD(x), DWORD(y), 0, 0)

    proc press*(button: MouseButton, x = 0, y = 0) =
        mouse_event(DWORD(MouseButtonToEvent[button].Press), DWORD(x), DWORD(y), 0, 0)

    proc release*(button: MouseButton, x = 0, y = 0) =
        mouse_event(DWORD(MouseButtonToEvent[button].Release), DWORD(x), DWORD(y), 0, 0)

    proc move*(x, y: int, `type` = Relative) =
        case `type`
        of Relative:
            mouse_event(0x1, DWORD(x), DWORD(y), 0, 0)
        of Absolute:
            SetCursorPos(int32 x, int32 y)

    proc smoothMove*(x: int, y: int, smoothingStep: float = 0.001, sleep = 1, `type` = Absolute) = 
        var currPos: Point
        GetCursorPos(currPos)

        var
            x = x
            y = y
        if `type` == Relative:
            (x, y) = calcRelative((int(currPos.x), int(currPos.y)), (x,y))

        var i = 0.0
        while i < 1.0:
            var vec = lerp((int(currPos.x), int(currPos.y)), (x, y), i)

            SetCursorPos(int32(vec.x), int32(vec.y))

            sleep(sleep)
            i += smoothingStep

    proc scroll*(amount: int, direction: ScrollDirection) =
        var finalAmount: int = amount * 120
        if direction == Down:
            finalAmount = -finalAmount

        mouse_event(DWORD(MOUSEEVENTF_WHEEL), 0, 0, DWORD(finalAmount), 0)

    proc getPos*: Point =
        discard GetCursorPos(result)

when defined(linux):
    import x11/[xlib, xtst, x]

    type Point = tuple
        x: int
        y: int

    proc convertButton(button: MouseButton): cuint =
        cuint(int(button) + 1)

    proc click*(button: MouseButton) =
        let display = XOpenDisplay(nil)

        discard XTestFakeButtonEvent(display, convertButton(button), XBool(true), 0)
        discard XTestFakeButtonEvent(display, convertButton(button), XBool(false), 0)

        discard XFlush(display)
        discard XCloseDisplay(display)

    proc press*(button: MouseButton) =
        let display = XOpenDisplay(nil)

        discard XTestFakeButtonEvent(display, convertButton(button), XBool(true), 0)

        discard XFlush(display)
        discard XCloseDisplay(display)

    proc release*(button: MouseButton) =
        let display = XOpenDisplay(nil)

        discard XTestFakeButtonEvent(display, convertButton(button), XBool(false), 0)

        discard XFlush(display)
        discard XCloseDisplay(display)
    
    proc move*(x, y: int, `type` = Relative) =
        let
            display = XOpenDisplay(nil)
            screenRoot = RootWindow(display, 0)

        case `type`:
        of Absolute:
            discard XWarpPointer(display, 0, screenRoot, 0,0,0,0, cint(x),cint(y))
        of Relative:
            discard XTestFakeRelativeMotionEvent(display, cint(x), cint(y), 0)
        
        discard XFlush(display)
        discard XCloseDisplay(display)

    proc getPos*: Point =
        let 
            display = XOpenDisplay(nil)
            screenRoot = XRootWindow(display, 0)
        var 
            qRoot, qChild: Window
            x, y, qChildX, qChildY: cint
            qMask: cuint

        discard XQueryPointer(display, screenRoot, qRoot.addr, qChild.addr, x.addr, y.addr, qChildX.addr, qChildY.addr, qMask.addr)
        discard XCloseDisplay(display)
        result.x = int(x.cfloat)
        result.y = int(y.cfloat)

    proc scroll*(amount: int, direction: ScrollDirection) =
        let display = XOpenDisplay(nil)
        var eventInt: int

        if direction == Up: 
            eventInt = 4
        else:
            eventInt = 5

        for i in countup(1, amount):
            discard XTestFakeButtonEvent(display, cuint(eventInt), XBool(true), 0)

        discard XFlush(display)
        discard XCloseDisplay(display)
    
    proc smoothMove*(x: int, y: int, smoothingStep: float = 0.001, sleep = 1, `type` = Absolute) =  
        var currPos: Point = getPos()

        var
            x = x
            y = y
        if `type` == Relative:
            (x, y) = calcRelative((int(currPos.x), int(currPos.y)), (x,y))

        var i = 0.0
        while i < 1.0:
            var vec = lerp((int(currPos.x), int(currPos.y)), (x, y), i)

            move(vec.x, vec.y, Absolute)

            sleep(sleep)
            i += smoothingStep
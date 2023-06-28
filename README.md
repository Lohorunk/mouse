# mouse

This library allows you to programmatically control the mouse.

```
nimble install mouse
```

# Suported platforms


| Platform | Support | Implementation |
| ---------- | --------- | ---------------- |
| Windows  | full    | WINAPI         |
| Linux    | full    | X11            |
| Macos    | none    | none           |

# Docs

## procs

### click
```nim
click(button: MouseButton)
```
Clicks the given mouse button.

### press
```nim
press(button: MouseButton)
```
Presses the given mouse button.

### release
```nim
release(button: MouseButton)
```
Releases the given mouse button.

### move
```nim
move(x, y: int, `type` = Relative)
```
Moves the mouse pointer to the location given in `x` `y`.


`Relative` moves the mouse relative to the current mouse position.

For exmaple calling `move(0, 100)` will move the pointer 100 pixels up.


`Absolute` moves the mouse to absolute coordinates on the screen.

So calling `move(0, 100, Absolute)` will move the pointer to the pixel in the position `(0, 100)`.

### smoothMove
```nim
smoothMove(x: int, y: int,
    smoothingStep: float = 0.005,
    sleep = 3,
    `type` = Absolute
)
```
Moves the mouse pointer in a smooth human like way, to the location given in `x` `y`.

### scroll
```nim
scroll(amount: int, direction: ScrollDirection)
```
Scrolls the mouse wheel the `amount` of notches in the given direction.

### getPos
```nim
getPos(): Point
```
Gets the pointer position on the screen.

## types

```nim
MouseButton = enum
    Left, Right, Middle
  
PositionKind = enum
    Relative, Absolute
  
ScrollDirection = enum
    Up, Down

Point = tuple
    x: int
    y: int
```
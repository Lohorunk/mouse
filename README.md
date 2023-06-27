# mouse

This library allows you to programmatically control the mouse. 
```
nimble install mouse
```

# Suported platforms
| Platform  | Support  | Implementation |
| ------------ | ------------ | ------------ |
|  Windows  |  full  |  WINAPI  |
|  Linux  |  full  |  X11  |
|  Mac  |  none |  none  |

# Cheat Sheet
```nim
click(button: MouseButton, x = 0, y = 0)
press(button: MouseButton, x = 0, y = 0)
release(button: MouseButton, x = 0, y = 0)
move(x, y: int, `type` = Relative)
smoothMove(x: int, y: int, smoothingStep: float = 0.001, sleep = 1, `type` = Absolute)
scroll(amount: int, direction: ScrollDirection)

getPos() # -> Point
```
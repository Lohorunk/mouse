# mouse

[![](https://raw.githubusercontent.com/hiikion/mouse/main/assets/made-with-nim.svg)](https://raw.githubusercontent.com/hiikion/mouse/main/assets/made-with-nim.svg)

This library allows you to programmatically control the mouse. 
## Installing
```
nimble install mouse
```
## Suported platforms
| Platform  | Is supported  |
| ------------ | ------------ |
|  Windows  |  🟢  |
|  Linux  |  🟢  |
|  Mac  |  🔴 |

## Examples
### Universal
```nim
import mouse

click(Left) 
press(Left)
release(Left)
move(30, 30)
```
### Windows-only
```nim
import mouse
import winim/lean # needed for isPressed function (virtual key codes)


smoothMove(30, 30, 0.01)
scroll(5)

while true:
    var pressed = isPressed(VK_LBUTTON)
    var position = getPos()
    
    echo fmt"is pressed: {pressed}, position: {position}"
```

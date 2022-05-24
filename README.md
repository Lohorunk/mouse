# mouse

[![](https://raw.githubusercontent.com/hiikion/mouse/main/assets/made-with-nim.svg)](https://raw.githubusercontent.com/hiikion/mouse/main/assets/made-with-nim.svg)

package for interacting with the mouse 
## installing
> nimble install mouse

## suported platforms
| Platform  | Is suported  |
| ------------ | ------------ |
|  Windows  |  🟢  |
|  Linux  |  🟢  |
|  Mac  |  🔴 |

## examples
### universal
```nim
import mouse

# On linux the button needs to bee a string
click(Left) 
press(Left)
realese(Left)
move(30, 30)
```
### windows only
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

# mouse

[![](https://raw.githubusercontent.com/hiikion/mouse/main/assets/made-with-nim.svg)](https://raw.githubusercontent.com/hiikion/mouse/main/assets/made-with-nim.svg)

This library allows you to programmatically control the mouse. 
## Installing
```
nimble install mouse
```

### installing deps on linux <br>
arch: `sudo pacman -S xdotool` <br>
ubuntu/debian: `apt-get install xdotool` <br>
fedora: `dnf install xdotool` <br>
openSUSE `zypper install xdotool` <br>
other: `brew install xdotool` <br>

### installing dependencies for macos <br>
`brew install xdotool` <br>

## Suported platforms
| Platform  | Is supported  |
| ------------ | ------------ |
|  Windows  |  🟢  |
|  Linux  |  🟢  |
|  Mac  |  🟢 |

## Examples
### Universal
```nim
import mouse

click(Left) 
press(Left)
release(Left)
move(30, 30)

while true:
    var position = getPos()
    
    echo fmt"position: {position}"
```
### Windows-only
```nim
import mouse

scroll(5)
```

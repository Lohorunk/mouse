# mouse

[![](https://raw.githubusercontent.com/hiikion/mouse/main/assets/made-with-nim.svg)](https://raw.githubusercontent.com/hiikion/mouse/main/assets/made-with-nim.svg)

This library allows you to programmatically control the mouse. 
## Installing
```
nimble install mouse
```

### installing deps on linux
arch: `sudo pacman -S xdotool`
ubuntu/debian: `apt-get install xdotool`
fedora: `dnf install xdotool`
openSUSE `zypper install xdotool`
other: `brew install xdotool`

### installing dependencies for macos
`brew install xdotool`

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

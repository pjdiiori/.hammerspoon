# My lua 🔨🥄 config

What's [hammerspoon?](https://www.hammerspoon.org/) A cool way to program automation for MacOS, in lua.

This config contains mostly hotkey mappings to do cool stuff like:
- window management
  - send windows to adjacent monitors
  - split windows left, right, up, or down
  - size a window to a grid
  - send a window to an adjacent "space"
- Launch various apps
  - iTerm
  - Stickies
- Paste zoom link wherever, whenever (sounds silly but the one I use most probably)
  - add a file called `env.lua` in the same directory as your `init.lua`, and define your `ZOOM_LINK` (or any other "environment variable"):
    ```lua
    ZOOM_LINK="your zoom link"
    ```
- Also includes auto-reload of the cofig "on save", as well as hotkey to manually reload.

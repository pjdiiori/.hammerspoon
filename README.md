# My lua 🔨🥄 config

What's [hammerspoon?](https://www.hammerspoon.org/) A cool way to program automation for MacOS, in lua.

In this config:
- window management
  - send windows to adjacent monitors
  - split windows left, right, up, or down
  - size a window to a grid
  - send a window to an adjacent "space"
- Launch various apps
  - iTerm
  - Stickies
  - Chrome
- Paste zoom link wherever, whenever (sounds silly but the one I use most probably)
  - add a file called `env.lua` in the same directory as your `init.lua`, and define your `ZOOM_LINK` (or any other "environment variable"):
    ```lua
    ZOOM_LINK="your zoom link"
    ```
- Type passive-aggressive sounding comments with `MockingTyper()` (it toggles capslock on and off every half-second) - `Cmd + option + control + 'P'`
- Convert a selected Epoch timestamp to human readable date and time string. - `Cmd + option + control + 'T'`
- instantly search etherscan for a selected Ethereum address or transaction hash. - `Cmd + option + control + 'E'`
- TextClipboardHistory Spoon for management of clipboard (copypasta) management.
- Also includes auto-reload of the cofig "on save", as well as hotkey to manually reload.
- Open help menu to browse and select all hotkeys - `Cmd + option + control + 'H'`

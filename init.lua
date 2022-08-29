require('env')

Hs = hs
Hs.application.enableSpotlightForNameSearches(true)
-- screen & grid config
Screens = Hs.screen.allScreens()
Dimensions = Hs.geometry(nil, nil, 2, 2)
ZeroMargins = Hs.geometry(0, 0)

for _,screen in pairs(Screens) do
  Hs.grid.setGrid(Dimensions, screen).setMargins(ZeroMargins)
end

-- globals
Spaces = Hs.spaces.spacesForScreen()
CmdAltCtrl = { "cmd", "alt", "ctrl" }
CmdAltCtrlShift = { "cmd", "alt", "ctrl", "shift" }
--

-- HOTKEY MAPPINGS
-- reload config
Hs.hotkey.bind(CmdAltCtrl, "R", function() Hs.reload() end)

-- show grid
Hs.hotkey.bind(CmdAltCtrl, "G", function() Hs.grid.show() end)

-- move window to left of screen
Hs.hotkey.bind(CmdAltCtrl, "[", function()
  SplitWindow(Hs.window.focusedWindow(), "left")
end)
-- move window to right of screen
Hs.hotkey.bind(CmdAltCtrl, "]", function()
  SplitWindow(Hs.window.focusedWindow(), "right")
end)
-- move window to top of screen
Hs.hotkey.bind(CmdAltCtrl, "=", function()
  SplitWindow(Hs.window.focusedWindow(), "up")
end)
-- move window to bottom of screen
Hs.hotkey.bind(CmdAltCtrl, "'", function()
  SplitWindow(Hs.window.focusedWindow(), "down")
end)

-- split chrome and code
Hs.hotkey.bind(CmdAltCtrl, "C", function()
  local code = Hs.window("VS Code")
  local chrome = Hs.window("Chrome")
  SplitWindow(code, "left")
  SplitWindow(chrome, "right")
  print(code, chrome)
end)

-- send window to monitor on the left
Hs.hotkey.bind(CmdAltCtrl, "left", function()
  local window = Hs.window.focusedWindow()
  window:moveOneScreenWest(false, true)
end)
-- send window to monitor on the right
Hs.hotkey.bind(CmdAltCtrl, "right", function()
  local window = Hs.window.focusedWindow()
  window:moveOneScreenEast(false, true)
end)
-- send window to space on the left
Hs.hotkey.bind(CmdAltCtrlShift, "L", function()
  SendToSpace("left")
end)
-- send window to space on the right
Hs.hotkey.bind(CmdAltCtrlShift, "R", function()
  SendToSpace("right")
end)
-- maximize window
Hs.hotkey.bind(CmdAltCtrl, "space", function()
  local window = Hs.window.focusedWindow()
  window:maximize()
end)
-- launch iTerm
Hs.hotkey.bind(CmdAltCtrl, "\\", function() LaunchApp("iTerm", "New Window") end)
-- launch Stickies
Hs.hotkey.bind(CmdAltCtrl, "S", function() LaunchApp("Stickies", "New Note") end)
-- paste zoom link
Hs.hotkey.bind(CmdAltCtrl, "Z", function()
  Hs.eventtap.keyStrokes(ZOOM_LNK)
end)

function SplitWindow(window, dir)
  local places = {
    left = Hs.layout.left50,
    right = Hs.layout.right50,
    -- horizontal, vertical, width, height
    up = Hs.geometry.unitrect(0, 0, 1, 0.5),
    down = Hs.geometry.unitrect(0, 0.5, 1, 0.5),
  }
  window:moveToUnit(places[dir])
end

function LaunchApp(appName, action)
  local app = Hs.application.find(appName)
  print(app)
  if app == nil then
    local openedApp = Hs.application.open(appName, 5)
    print(openedApp)
    openedApp:selectMenuItem(action)
    print("launching " .. appName)
  else
    print("opening new " .. appName .. " window")
    app:selectMenuItem(action)
    app:setFrontmost()
  end
end

function SendToSpace(direction)
  local currentSpace = Hs.spaces.activeSpaceOnScreen()
  local window = Hs.window.focusedWindow()
  local adjacentSpaces = {
    "left",
    "right"
  }
  for index,space in pairs(Spaces) do
    if space == currentSpace then
      adjacentSpaces["left"] = Spaces[index - 1]
      adjacentSpaces["right"] = Spaces[index + 1]
    end
  end
  Hs.spaces.moveWindowToSpace(window, adjacentSpaces[direction])
end

function PrintKeystrokes(table, key)
  local values = ""
  for k, v in pairs(table) do
    values = values .. v .. " "
  end
  return values .. " + " .. key
end

local function reloadConfig(files)
  local doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    Hs.reload()
    print("Config reloaded")
    Hs.alert.show("Config reloaded")
  end
end

-- auto reload
AutoReload = Hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

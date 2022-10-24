require('env')
Hs = hs

-- SPOONS CONFIG
TextClipboardHistory = Hs.loadSpoon("TextClipboardHistory")
TextClipboardHistory.frequency = 1
TextClipboardHistory.menubar_title = "\u{1f4be}"
TextClipboardHistory:start()
--

Hs.application.enableSpotlightForNameSearches(true)

-- screen & grid config
Screens = Hs.screen.allScreens()
Dimensions = Hs.geometry(nil, nil, 2, 2)
ZeroMargins = Hs.geometry(0, 0)

for _, screen in pairs(Screens) do
  Hs.grid.setGrid(Dimensions, screen).setMargins(ZeroMargins)
end

-- globals
Spaces = Hs.spaces.spacesForScreen()
CmdAltCtrl = { "cmd", "alt", "ctrl" }
CmdAltCtrlShift = { "cmd", "alt", "ctrl", "shift" }
--

-------------------------------------------------------
------------------- HOTKEY MAPPINGS -------------------
-------------------------------------------------------
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
Hs.hotkey.bind(CmdAltCtrl, ",", function()
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
-- launch Chrome
Hs.hotkey.bind(CmdAltCtrl, "C", function() LaunchApp("Chrome", "New Window") end)
-- move Chrome tab to new window and split windows
Hs.hotkey.bind(CmdAltCtrl, ".", function()
  local chrome = Hs.application.get("Google Chrome")
  ChromeSplitTab(chrome)
end)
-- paste zoom link
Hs.hotkey.bind(CmdAltCtrl, "Z", function()
  Hs.eventtap.keyStrokes(ZOOM_LNK)
end)
-- paste user id
Hs.hotkey.bind(CmdAltCtrl, "N", function()
  Hs.eventtap.keyStrokes(USER_ID)
end)
-- ConvertEpochTimestamp from clipboard
Hs.hotkey.bind(CmdAltCtrl, "T", function()
  local timestamp = GrabSelectedText()
  ConvertEpochTimestamp(timestamp)
end)
-- lookup txn or address hash on etherscan.io
Hs.hotkey.bind(CmdAltCtrl, "E", function()
  -- Hs.alert(PrintKeystrokes(CmdAltCtrl, "E"))
  local hash = GrabSelectedText()
  EtherscanLookup(hash);
end)

-- turn on mockingtyper
Toggle = false
Hs.hotkey.bind(CmdAltCtrl, "P", function()
  MockingTyper()
end)
-------------------------------------------------------
----------------- END HOTKEY MAPPINGS -----------------
-------------------------------------------------------

function MockingTyper()
  Toggle = not Toggle
  if not Toggle then
    Hs.hid.capslock.set(false)
  else
    Hs.timer.doWhile(function() return Toggle end, Hs.hid.capslock.toggle, 0.3)
  end
end

function ChromeSplitTab(chrome)
  chrome:selectMenuItem("Move Tab to New Window")
  local windowlist = chrome:allWindows()
  SplitWindow(windowlist[1], "left")
  SplitWindow(windowlist[2], "right")
end

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
  for index, space in pairs(Spaces) do
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

local function sanitizeTimestamp(timestamp)
  return string.gsub(timestamp, ",", "")
end

function ConvertEpochTimestamp(timestamp)
  timestamp = sanitizeTimestamp(timestamp)
  local length = string.len(timestamp)
  local dateTime
  if length < 10 then
    print("invalid epoch timestamp")
    return
  elseif length > 10 then
    print("epoch in miliseconds")
    dateTime = os.date(nil, tonumber(timestamp) / 1000)
  else
    print("epoch in seconds")
    dateTime = os.date(nil, tonumber(timestamp))
  end
  -- Hs.pasteboard.setContents(dateTime)
  Hs.dialog.alert(700, 250, function() end, dateTime, "Epoch Timestamp: " .. timestamp, "ok", nil, "informational")
  Hs.application.get("Hammerspoon"):setFrontmost()
end

function EtherscanLookup(hash)
  local baseUrl = "https://etherscan.io"
  local url = baseUrl .. IsAddressOrTxn(hash) .. hash
  Hs.urlevent.openURL(url)
end

function IsHash(text)
  local s, e = string.find(text, "0x");
  return s == 1 and e == 2
end

function IsAddressOrTxn(hash)
  local length = string.len(hash)
  if length == 66 then
    return "/tx/"
  elseif length == 42 then
    return "/address/"
  else
    return false
  end
end

function GrabSelectedText()
  Hs.eventtap.keyStroke({ "cmd" }, "c");
  return Hs.pasteboard.getContents();
end

-- receive text from "send to hammerspoon"
Hs.textDroppedToDockIconCallback = function(text)
  if IsHash(text) and IsAddressOrTxn(text) then
    EtherscanLookup(text)
  elseif tonumber(text) ~= nil then
    ConvertEpochTimestamp(text)
  else
    print("received non-integer or non-hash")
  end
end


-- auto reload
AutoReload = Hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

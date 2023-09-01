require('env')
require('HotkeyMappings')

-- SPOONS CONFIG
TextClipboardHistory = hs.loadSpoon("TextClipboardHistory")
TextClipboardHistory.frequency = 1
TextClipboardHistory.menubar_title = "\u{1f4be}"
TextClipboardHistory:start()
--

hs.application.enableSpotlightForNameSearches(true)

-- screen & grid config
Screens = hs.screen.allScreens()
Dimensions = hs.geometry(nil, nil, 2, 2)
ZeroMargins = hs.geometry(0, 0)

for _, screen in pairs(Screens) do
  hs.grid.setGrid(Dimensions, screen).setMargins(ZeroMargins)
end

-- globals
Spaces = hs.spaces.spacesForScreen()
--

-------------------------------------------------------
------------------- HOTKEY MAPPINGS -------------------
-------------------------------------------------------
MockingTyperToggle = false

BindResizers()
-- Bind hotkeys for all mappings in HotkeyMappings
BindHotkeys()
-------------------------------------------------------
----------------- END HOTKEY MAPPINGS -----------------
-------------------------------------------------------

function Resize(numberKey)
  local number = tonumber(numberKey)
  local window = hs.window.focusedWindow()
  -- horizontal, vertical, width, height
  window:moveToUnit(hs.geometry.unitrect(1 / number, 1 / number, number * 0.1, number * 0.1))
  print(window:size())
end

function FirestoreUser()
  local id = GrabSelectedText()
  local url = "https://console.firebase.google.com/project/gilded-dev/firestore/data/~2Fusers~2F" .. id

  hs.urlevent.openURL(url)
end

function HotkeyHelpMenu()
  local body = ''
  for _, mapping in pairs(HotkeyMappings) do
    body = body .. "\n" .. (mapping.name .. ": " .. "'" .. mapping.key .. "'")
  end
  -- hs.dialog.alert(700, 250, function() end, dateTime, "Epoch Timestamp: " .. timestamp, "ok", nil, "informational")
  hs.dialog.alert(700, 250, function() end, "Hotkey Mappings: ", body, "ok", nil, "informational")
end

function MockingTyper()
  MockingTyperToggle = not MockingTyperToggle
  if not MockingTyperToggle then
    hs.hid.capslock.set(false)
  else
    hs.timer.doWhile(function() return MockingTyperToggle end, hs.hid.capslock.toggle, 0.3)
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
    left = hs.layout.left50,
    right = hs.layout.right50,
    -- horizontal, vertical, width, height
    up = hs.geometry.unitrect(0, 0, 1, 0.5),
    down = hs.geometry.unitrect(0, 0.5, 1, 0.5),
  }
  window:moveToUnit(places[dir])
end

function LaunchApp(appName, action)
  local app = hs.application.find(appName)
  print(app)
  if app == nil then
    local openedApp = hs.application.open(appName, 5)
    print(openedApp)
    openedApp:selectMenuItem(action)
    print("launching " .. appName)
  else
    print("opening new " .. appName .. " window")
    app:selectMenuItem(action)
    if appName == "Stickies" then
      app:setFrontmost()
    end
  end
end

function SendToSpace(direction)
  local currentSpace = hs.spaces.activeSpaceOnScreen()
  local window = hs.window.focusedWindow()
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
  hs.spaces.moveWindowToSpace(window, adjacentSpaces[direction])
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
    hs.reload()
    print("Config reloaded")
    hs.alert.show("Config reloaded")
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
    dateTime = os.date(nil, tonumber(timestamp) / 1000) -- gotta round this off because its prob returning a decimal
  else
    print("epoch in seconds")
    dateTime = os.date(nil, tonumber(timestamp))
  end
  -- hs.pasteboard.setContents(dateTime)
  hs.dialog.alert(700, 250, function() end, dateTime, "Epoch Timestamp: " .. timestamp, "ok", nil, "informational")
  hs.application.get("Hammerspoon"):setFrontmost()
end

function EtherscanLookup(hash)
  local baseUrl = "https://etherscan.io"
  local url = baseUrl .. IsAddressOrTxn(hash) .. hash
  hs.urlevent.openURL(url)
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
  hs.eventtap.keyStroke({ "cmd" }, "c");
  return hs.pasteboard.getContents();
end

-- receive text from "send to hammerspoon"
hs.textDroppedToDockIconCallback = function(text)
  if IsHash(text) and IsAddressOrTxn(text) then
    EtherscanLookup(text)
  elseif tonumber(text) ~= nil then
    ConvertEpochTimestamp(text)
  else
    print("received non-integer or non-hash")
  end
end


-- auto reload
AutoReload = hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

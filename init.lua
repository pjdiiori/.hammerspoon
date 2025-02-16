require('env')
require('HotkeyMappings')

-- SPOONS CONFIG
TextClipboardHistory = hs.loadSpoon("TextClipboardHistory")
TextClipboardHistory.frequency = 1
TextClipboardHistory.menubar_title = "\u{1f4be}"
TextClipboardHistory.paste_on_select = true
TextClipboardHistory:start()
--

hs.application.enableSpotlightForNameSearches(true)

-- screen & grid config
Screens = hs.screen.allScreens()

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
  window:moveToUnit(hs.geometry.unitrect(1 / number, 0, number * 0.1, number * 0.1))
  print(window:size())
end

local function mapChoices(hotkeys)
  table.sort(hotkeys, function(a, b) return a.name < b.name end)
  local choices = {}
  for i, hk in ipairs(hotkeys) do
    local choice = {
      ["text"] = hk.name,
      ["subText"] = hk.key and table.concat(hk.modifier, ", ") .. " '" .. hk.key .. "'",
      index = i
    }
    table.insert(choices, i, choice)
  end
  return choices
end

function HotkeyHelpMenu()
  hs.chooser.new(function(choice) if choice ~= nil then HotkeyMappings[choice.index].callback() end end)
      :choices(mapChoices(HotkeyMappings))
      :show()
end

function MockingTyper()
  MockingTyperToggle = not MockingTyperToggle
  if not MockingTyperToggle then
    hs.hid.capslock.set(false)
  else
    hs.timer.doWhile(function() return MockingTyperToggle end, hs.hid.capslock.toggle, 0.3)
  end
end

function ChromeSplitTab()
  local chrome = hs.application.get("Google Chrome")
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

-- args = {appName:string, action:string, opts:table of menu options}
function LaunchApp(args)
  local app = hs.application.find(args.appName)
  if app == nil then
    hs.application.open(args.appName)
    hs.timer.doAfter(1, function()
      LaunchApp(args)
    end)
    print("openeing app:")
  else
    print(app)
    -- app:setFrontmost()
    app:selectMenuItem(args.action)
    if args.opts then
      for i, opt in ipairs(args.opts) do
        print("selecting " .. table.concat(opt, ", "))
        app:selectMenuItem(opt)
      end
    end
  end
end

function RandomStickyColor()
  local colors = { "Blue", "Green", "Pink", "Purple", "Gray" }
  return colors[math.random(#colors)]
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

function PrintTable(table)
  local values = ""
  for k, v in pairs(table) do
    values = values .. "  " .. k .. " = " .. v .. ", \n"
  end
  print("\n{\n" .. values .. "}")
end

function PromptSetGrid()
  hs.focus()
  local choice, size = hs.dialog.textPrompt("Set grid dimensions", "Enter a number", "", "OK", "Cancel")
  if choice == "OK" then
    local grid_size = tonumber(string.match(size, "%d"))
    SetGrid(Screens, hs.geometry(nil, nil, grid_size, grid_size), hs.geometry(0, 0))
  end
end

function SetGrid(screens, dimensions, margins)
  for _, screen in pairs(screens) do
    hs.grid.setGrid(dimensions, screen).setMargins(margins)
  end
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

function RearrangeScreenLayout(data)
  -- productID of USB Hub
  if data["productID"] == 2069 then
    -- move vscode to first space of external monitor when plugged in
    if data["eventType"] == "added" then
      local vscode = hs.window("VS Code")
      hs.timer.doAfter(1, function()
        vscode:moveOneScreenEast(false, true):maximize()
      end)
    end
    -- move vscode to second to last space when external monitor is unplugged
    if data["eventType"] == "removed" then
      local spaces = hs.spaces.spacesForScreen()
      local vscode = hs.window("VS Code")
      hs.spaces.moveWindowToSpace(vscode, spaces[#spaces - 1])
      vscode:maximize()
    end
  end
end

function ScreenCallback()
  print("screen event")
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
SetGrid(Screens, hs.geometry(nil, nil, 2, 2), hs.geometry(0, 0))

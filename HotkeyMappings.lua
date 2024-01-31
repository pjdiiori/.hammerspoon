CmdAltCtrl = { "cmd", "alt", "ctrl" }
CmdAltCtrlShift = { "cmd", "alt", "ctrl", "shift" }

function BindResizers()
  for _, numberKey in pairs({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }) do
    local resizer = {
      name = "Resize " .. numberKey .. "0%",
      modifier = CmdAltCtrl,
      key = numberKey,
      callback = function() Resize(numberKey) end
    }
    table.insert(HotkeyMappings, resizer)
  end
end

function BindHotkeys()
  for _, mapping in pairs(HotkeyMappings) do
    if mapping.name == "Open Clipboard History" then
      hs.dockicon.hide() -- must call this for the chooser to display over full-screen windows
      TextClipboardHistory:bindHotkeys({ toggle_clipboard = { mapping.modifier, mapping.key } })
      hs.dockicon.show()
    elseif mapping.key ~= nil then
      hs.hotkey.bind(mapping.modifier, mapping.key, mapping.callback)
    end
  end
end

HotkeyMappings = {
  { name = "Reload Hammerspon Config", modifier = CmdAltCtrl, key = "R", callback = function() hs.reload() end },
  { name = "Display Window Grid",      modifier = CmdAltCtrl, key = "G", callback = function() hs.grid.show() end },
  {
    name = "Split Window Left",
    modifier = CmdAltCtrl,
    key = "[",
    callback = function() SplitWindow(hs.window.focusedWindow(), "left") end
  },
  {
    name = "Split Window Right",
    modifier = CmdAltCtrl,
    key = "]",
    callback = function() SplitWindow(hs.window.focusedWindow(), "right") end
  },
  {
    name = "Split Window Up",
    modifier = CmdAltCtrl,
    key = "=",
    callback = function() SplitWindow(hs.window.focusedWindow(), "up") end
  },
  {
    name = "Split Window Down",
    modifier = CmdAltCtrl,
    key = "'",
    callback = function() SplitWindow(hs.window.focusedWindow(), "down") end
  },
  {
    -- needs work, also, I don't use very often
    name = "Split Chrome and VSCode",
    modifier = CmdAltCtrl,
    key = ",",
    callback = function()
      local code = hs.window("VS Code")
      local chrome = hs.window("Chrome")
      SplitWindow(code, "left")
      SplitWindow(chrome, "right")
      print(code, chrome)
    end
  },
  {
    name = "Send Window to Left Monitor",
    modifier = CmdAltCtrl,
    key = "left",
    callback = function()
      local window = hs.window.focusedWindow()
      window:moveOneScreenWest(false, true)
    end
  },
  {
    name = "Send Window to Right Monitor",
    modifier = CmdAltCtrl,
    key = "right",
    callback = function()
      local window = hs.window.focusedWindow()
      window:moveOneScreenEast(false, true)
    end
  },
  {
    name = "Maximize Window",
    modifier = CmdAltCtrl,
    key = "space",
    callback = function()
      local window = hs.window.focusedWindow()
      window:maximize()
    end
  },
  {
    name = "Send Window to Left Adjacent Space",
    modifier = CmdAltCtrlShift,
    key = "L",
    callback = function() SendToSpace("left") end
  },
  {
    name = "Send Window to Right Adjacent Space",
    modifier = CmdAltCtrlShift,
    key = "R",
    callback = function() SendToSpace("right") end
  },
  {
    name = "Open iTerm2",
    modifier = CmdAltCtrl,
    key = "\\",
    callback = function() LaunchApp({ appName = "iTerm", action = "New Window" }) end
  },
  {
    name = "Open New Stickies Note",
    modifier = CmdAltCtrl,
    key = "S",
    callback = function()
      LaunchApp(
        {
          appName = "Stickies",
          action = "New Note",
          opts = {
            { "Color", RandomStickyColor() },
            { "Edit",  "Spelling and Grammar", "Check Spelling While Typing" },
            { "Edit",  "Spelling and Grammar", "Correct Spelling Automatically" }
          }
        })
    end
  },
  {
    name = "Open New Chrome Window",
    modifier = CmdAltCtrl,
    key = "C",
    callback = function() LaunchApp({ appName = "Google Chrome", action = "New Window" }) end
  },
  {
    name = "Open New Chrome Window Personal Profile",
    modifier = CmdAltCtrlShift,
    key = "C",
    callback = function() LaunchApp({ appName = "Google Chrome", action = { "Profiles", "PJ" } }) end
  },
  {
    name = "Split Chrome Tab With Window",
    modifier = CmdAltCtrl,
    key = ".",
    callback = function() ChromeSplitTab() end
  },
  {
    name = "Paste Zoom Link",
    modifier = CmdAltCtrl,
    key = "Z",
    callback = function() hs.eventtap.keyStrokes(ZOOM_LINK) end
  },
  {
    name = "Paste user ID",
    modifier = CmdAltCtrl,
    key = "N",
    callback = function() hs.eventtap.keyStrokes(USER_ID) end
  },
  {
    name = "Convert Epoch Timestamp",
    modifier = CmdAltCtrl,
    key = "T",
    callback = function()
      local timestamp = GrabSelectedText()
      ConvertEpochTimestamp(timestamp)
    end
  },
  {
    name = "Lookup Etherum Address or Txn",
    modifier = CmdAltCtrl,
    key = "E",
    callback = function()
      local hash = GrabSelectedText()
      EtherscanLookup(hash);
    end
  },
  {
    name = "mocKinGTypER",
    modifier = CmdAltCtrl,
    key = "P",
    callback = function() MockingTyper() end
  },
  {
    name = "Open Clipboard History",
    modifier = CmdAltCtrl,
    key = "V"
  },
  {
    name = "Clear Last Clipboard Item",
    modifier = CmdAltCtrl,
    key = "forwarddelete",
    callback = function() TextClipboardHistory:clearLastItem() end
  },
  {
    name = "Hotkey Help Menu",
    modifier = CmdAltCtrl,
    key = "H",
    callback = function() HotkeyHelpMenu() end
  },
  {
    name = "Flip Table",
    modifier = CmdAltCtrl,
    key = "pageup",
    callback = function() hs.eventtap.keyStrokes("(╯°□°)╯︵ ┻━┻") end
  },
  {
    name = "Unflip Table",
    modifier = CmdAltCtrl,
    key = "pagedown",
    callback = function() hs.eventtap.keyStrokes("┬─┬ノ( º _ ºノ)") end
  },
  {
    name = "Shrug",
    modifier = CmdAltCtrlShift,
    key = "S",
    callback = function() hs.eventtap.keyStrokes("¯\\__(ツ)__/¯") end
  },
  {
    name = "Set Brightness to 100%",
    modifier = CmdAltCtrl,
    key = "0",
    callback = function() hs.brightness.set(100) end
  },
  {
    name = "Lowercase Selected Text",
    modifier = CmdAltCtrl,
    key = "down",
    callback = function()
      hs.eventtap.keyStrokes(string.lower(GrabSelectedText()))
    end
  },
  {
    name = "Uppercase Selected Text",
    modifier = CmdAltCtrl,
    key = "up",
    callback = function()
      hs.eventtap.keyStrokes(string.upper(GrabSelectedText()))
    end
  },
  {
    name = "Set Grid",
    modifier = nil,
    key = nil,
    callback = function() PromptSetGrid() end
  }
}

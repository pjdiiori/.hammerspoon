CmdAltCtrl = { "cmd", "alt", "ctrl" }
CmdAltCtrlShift = { "cmd", "alt", "ctrl", "shift" }

function BindHotkeys()
  for _, mapping in pairs(HotkeyMappings) do
    if mapping.name == "Open Clipboard History" then
      TextClipboardHistory:bindHotkeys({ toggle_clipboard = { mapping.modifier, mapping.key } })
    else
      Hs.hotkey.bind(mapping.modifier, mapping.key, mapping.callback)
    end
  end
end

HotkeyMappings = {
  reload = { name = "Reload Hammerspon Config", modifier = CmdAltCtrl, key = "R", callback = function() Hs.reload() end },
  grid = { name = "Display Window Grid", modifier = CmdAltCtrl, key = "G", callback = function() Hs.grid.show() end },
  splitLeft = {
    name = "Split Window Left",
    modifier = CmdAltCtrl,
    key = "[",
    callback = function() SplitWindow(Hs.window.focusedWindow(), "left") end
  },
  splitRight = {
    name = "Split Window Right",
    modifier = CmdAltCtrl,
    key = "]",
    callback = function() SplitWindow(Hs.window.focusedWindow(), "right") end
  },
  splitUp = {
    name = "Split Window Up",
    modifier = CmdAltCtrl,
    key = "=",
    callback = function() SplitWindow(Hs.window.focusedWindow(), "up") end
  },
  splitDown = {
    name = "Split Window Down",
    modifier = CmdAltCtrl,
    key = "'",
    callback = function() SplitWindow(Hs.window.focusedWindow(), "down") end
  },
  splitChromeCode = {
    -- needs work, also, I don't use very often
    name = "Split Chrome and VSCode",
    modifier = CmdAltCtrl,
    key = ",",
    callback = function()
      local code = Hs.window("VS Code")
      local chrome = Hs.window("Chrome")
      SplitWindow(code, "left")
      SplitWindow(chrome, "right")
      print(code, chrome)
    end
  },
  sendToLeftMonitor = {
    name = "Send Window to Left Monitor",
    modifier = CmdAltCtrl,
    key = "left",
    callback = function()
      local window = Hs.window.focusedWindow()
      window:moveOneScreenWest(false, true)
    end
  },
  sendToRightMonitor = {
    name = "Send Window to Right Monitor",
    modifier = CmdAltCtrl,
    key = "right",
    callback = function()
      local window = Hs.window.focusedWindow()
      window:moveOneScreenEast(false, true)
    end
  },
  maximize = {
    name = "Maximize Window",
    modifier = CmdAltCtrl,
    key = "space",
    callback = function()
      local window = Hs.window.focusedWindow()
      window:maximize()
    end
  },
  resize70 = {
    name = "Resize Window to 70%",
    modifier = CmdAltCtrl,
    key = "7",
    callback = function()
      local window = Hs.window.focusedWindow()
      -- horizontal, vertical, width, height
      window:moveToUnit(Hs.geometry.unitrect(1 / 7, 1 / 7, 0.7, 0.7))
      print(window:size())
    end
  },
  sendToLeftSpace = {
    name = "Send Window to Left Adjacent Space",
    modifier = CmdAltCtrlShift,
    key = "L",
    callback = function() SendToSpace("left") end
  },
  sendToRightSpace = {
    name = "Send Window to Right Adjacent Space",
    modifier = CmdAltCtrlShift,
    key = "R",
    callback = function() SendToSpace("right") end
  },
  iTerm = {
    name = "Open iTerm2",
    modifier = CmdAltCtrl,
    key = "\\",
    callback = function() LaunchApp("iTerm", "New Window") end
  },
  stickies = {
    name = "Open New Stickies Note",
    modifier = CmdAltCtrl,
    key = "S",
    callback = function() LaunchApp("Stickies", "New Note") end
  },
  chrome = {
    name = "Open New Chrome Window",
    modifier = CmdAltCtrl,
    key = "C",
    callback = function() LaunchApp("Chrome", "New Window") end
  },
  splitChromeTabs = {
    name = "Split Chrome Tab With Window",
    modifier = CmdAltCtrl,
    key = ".",
    callback = function()
      local chrome = Hs.application.get("Google Chrome")
      ChromeSplitTab(chrome)
    end
  },
  pasteZoomLink = {
    name = "Paste Zoom Link",
    modifier = CmdAltCtrl,
    key = "Z",
    callback = function() Hs.eventtap.keyStrokes(ZOOM_LINK) end
  },
  pasteUserId = {
    name = "Paste user ID",
    modifier = CmdAltCtrl,
    key = "N",
    callback = function() Hs.eventtap.keyStrokes(USER_ID) end
  },
  epochTimestamp = {
    name = "Convert Epoch Timestamp",
    modifier = CmdAltCtrl,
    key = "T",
    callback = function()
      local timestamp = GrabSelectedText()
      ConvertEpochTimestamp(timestamp)
    end
  },
  etherscanLookup = {
    name = "Lookup Etherum Address or Txn",
    modifier = CmdAltCtrl,
    key = "E",
    callback = function()
      local hash = GrabSelectedText()
      EtherscanLookup(hash);
    end
  },
  mockingTyper = {
    name = "mocKinGTypER",
    modifier = CmdAltCtrl,
    key = "P",
    callback = function() MockingTyper() end
  },
  clipboard = {
    name = "Open Clipboard History",
    modifier = CmdAltCtrl,
    key = "V"
  },
  clearLastClipboardItem = {
    name = "Clear Last Clipboard Item",
    modifier = CmdAltCtrl,
    key = "forwarddelete",
    callback = function() TextClipboardHistory:clearLastItem() end
  },
  hotkeyHelpMenu = {
    name = "Hotkey Help Menu",
    modifier = CmdAltCtrl,
    key = "H",
    callback = function() HotkeyHelpMenu() end
  }
}

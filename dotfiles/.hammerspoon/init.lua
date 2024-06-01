-- [[ Stackline for yabai stack layout ]]
stackline = require "stackline"
stackline:init({
  paths = {
    yabai = "/run/current-system/sw/bin/yabai"
  }
})


-- [[ Automatically switch the input method to SCIM if the app is in the scimApps list ]]
local scimApps = {
  WeChat=true,
  Logseq=true
}
local transitionApps = {
  "Spotlight",
  "Raycast",
  "Alfred",
  "uTools"
}
local lastIME = nil
local function switchIME(appName, eventType)
  if eventType == hs.window.filter.windowCreated then
    -- windowCreated maybe triggered multiple times, we only store on the first time
    if lastIME == nil then
      lastIME = hs.keycodes.currentSourceID()
    end
  elseif eventType == hs.window.filter.windowDestroyed then
    -- restore last input method and reset lastIME
    if lastIME ~= hs.keycodes.currentSourceID() and lastIME ~= nil then
      hs.keycodes.currentSourceID(lastIME)
    end
    lastIME = nil
  end

  -- switch input method
  if eventType == hs.application.watcher.activated or eventType == hs.window.filter.windowCreated then
    if scimApps[appName] then
      local method = "com.apple.inputmethod.SCIM.WBX"
      if hs.keycodes.currentSourceID() ~= method then
        hs.keycodes.currentSourceID(method)
      end
    else
      local method = "com.apple.keylayout.ABC"
      if hs.keycodes.currentSourceID() ~= method then
        hs.keycodes.currentSourceID(method)
      end
    end
  end
end
-- refer to subscribers and avoid garbage collection
Subscribers = {}
table.insert(Subscribers, hs.application.watcher.new(switchIME):start())
-- transition apps do not trigger the activated event, so we handle windowCreated instead.
for _, appName in ipairs(transitionApps) do
  table.insert(
    Subscribers,
    hs.window.filter.new(appName)
      :subscribe(hs.window.filter.windowCreated, function() switchIME(appName, hs.window.filter.windowCreated) end)
      :subscribe(hs.window.filter.windowDestroyed, function() switchIME(appName, hs.window.filter.windowDestroyed) end)
  )
end


-- [[ Moving cursor to corners ]]
local function moveCursor(corner)
  local frame = hs.mouse.getCurrentScreen():fullFrame()
  local corners = {
    topLeft = hs.geometry.point(frame.x + 5, frame.y + 5),
    topRight = hs.geometry.point(frame.x + frame.w - 5, frame.y + 5),
    bottomLeft = hs.geometry.point(frame.x + 5, frame.y + frame.h - 5),
    bottomRight = hs.geometry.point(frame.x + frame.w - 5, frame.y + frame.h - 5)
  }
  hs.mouse.absolutePosition(corners[corner])
end

hs.hotkey.bind({"cmd", "ctrl", "alt", "shift"}, "1", function() moveCursor("topLeft") end)
hs.hotkey.bind({"cmd", "ctrl", "alt", "shift"}, "2", function() moveCursor("topRight") end)
hs.hotkey.bind({"cmd", "ctrl", "alt", "shift"}, "3", function() moveCursor("bottomLeft") end)
hs.hotkey.bind({"cmd", "ctrl", "alt", "shift"}, "4", function() moveCursor("bottomRight") end)

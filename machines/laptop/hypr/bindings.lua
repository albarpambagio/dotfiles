-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

-- Monitor scale (recalculates positions to keep layout correct)
o.bind("SUPER + EQUAL", "Scale up", "~/.local/bin/omarchy-monitor-scale up")
o.bind("SUPER + MINUS", "Scale down", "~/.local/bin/omarchy-monitor-scale down")

-- Per-monitor workspace cycling (stays on current monitor)
hl.unbind("SUPER + TAB")
hl.unbind("SUPER + SHIFT + TAB")
o.bind("SUPER + TAB", "Next workspace (this monitor)", hl.dsp.focus({ workspace = "m+1" }))
o.bind("SUPER + SHIFT + TAB", "Previous workspace (this monitor)", hl.dsp.focus({ workspace = "m-1" }))

-- Hyprexpo: workspace overview toggle
hl.bind("SUPER + G", function() hl.plugin.hyprexpo.expo("toggle") end, { description = "Workspace overview" })

-- Per-monitor SUPER+1-9: script detects focused monitor and routes to correct range
-- HDMI-A-1 (left):  1-10
-- eDP-1 (right):    11-20
local number_keys = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }
for i, nk in ipairs(number_keys) do
  local ws = (i - 1) % 10 + 1
  hl.unbind("SUPER + code:" .. tostring(i + 9))
  o.bind("SUPER + " .. nk, "Workspace " .. ws .. " (this monitor)", "omarchy-workspace-switch " .. ws)
  hl.unbind("SUPER + SHIFT + code:" .. tostring(i + 9))
  o.bind("SUPER + SHIFT + " .. nk, "Move to workspace " .. ws .. " (this monitor)", "omarchy-workspace-switch move " .. ws)
end

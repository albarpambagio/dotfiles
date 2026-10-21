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

-- Omarchy binds SUPER+CTRL+TAB to the global `previous` workspace, which can
-- jump to the other monitor. hl.get_last_workspace is per-monitor.
-- hl.dsp.focus() returns a descriptor, so it needs hl.dispatch() to run.
hl.unbind("SUPER + CTRL + TAB")
o.bind("SUPER + CTRL + TAB", "Former workspace (this monitor)", function()
  local last = hl.get_last_workspace(hl.get_active_monitor().name)
  if last then hl.dispatch(hl.dsp.focus({ workspace = last.name })) end
end)

-- Omarchy binds ALT+TAB twice (tiling.lua cycle_next + bring_to_top on the same
-- key), so each press both cycles and raises. Unbind drops both; rebind cycle.
hl.unbind("ALT + TAB")
o.bind("ALT + TAB", "Focus on next window", hl.dsp.window.cycle_next())
hl.unbind("ALT + SHIFT + TAB")
o.bind("ALT + SHIFT + TAB", "Focus on previous window", hl.dsp.window.cycle_next({ next = false }))

-- Hyprexpo: workspace overview toggle. Omarchy also binds SUPER+G to window
-- grouping, so unbind first and relocate grouping to the free SUPER+CTRL+G.
hl.unbind("SUPER + G")
o.bind("SUPER + G", "Workspace overview", function() hl.plugin.hyprexpo.expo("toggle") end)
o.bind("SUPER + CTRL + G", "Toggle window grouping", hl.dsp.group.toggle())

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
  -- Omarchy's SUPER+SHIFT+ALT+code:NN never registers (no digit binds exist at
  -- any modmask but 64/65), so rebind with symbol digits instead.
  hl.unbind("SUPER + SHIFT + ALT + code:" .. tostring(i + 9))
  o.bind("SUPER + SHIFT + ALT + " .. nk, "Send to workspace " .. ws .. " (this monitor), stay put", "omarchy-workspace-switch silent " .. ws)
end

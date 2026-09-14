-- Middle-button autoscroll (Windows-style drag-to-scroll)
-- Plugin: https://github.com/estebanhiram/hypr-autoscroll
-- Build: make -C ~/.local/src/hypr-autoscroll clean all test

local plugin_path = os.getenv("HOME") .. "/.local/src/hypr-autoscroll/build/hypr-autoscroll.so"

-- Load plugin now (for hyprctl reload) and on fresh boot
hl.plugin.load(plugin_path)
hl.on("hyprland.start", function()
  hl.plugin.load(plugin_path)
end)

-- Plugin config: start with middle button normal, press shortcut to enable
hl.config({
  plugin = {
    hypr_autoscroll = {
      enabled = true,
      direct_activation = false,
      dead_zone = 12.0,
      sensitivity = 4.0,
      acceleration = 1.075,
      max_speed = 1500.0,
      horizontal = true,
      vertical = true,
    },
  },
})

-- Toggle shortcut: SUPER + A
o.bind("SUPER + A", "Toggle middle-button autoscroll", "hyprctl hypr-autoscroll toggle")

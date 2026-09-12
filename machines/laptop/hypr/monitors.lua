local omarchy_gdk_scale = 2
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0",  scale = 1.25 })
hl.monitor({ output = "eDP-1",    mode = "1920x1080@60", position = "1536x0", scale = 1.6 })

-- HDMI-A-1 (left): workspaces 1-10
for i = 1, 10 do
  hl.workspace_rule({ workspace = tostring(i), monitor = "HDMI-A-1" })
end

-- eDP-1 (right/laptop): workspaces 11-20
for i = 11, 20 do
  hl.workspace_rule({ workspace = tostring(i), monitor = "eDP-1" })
end

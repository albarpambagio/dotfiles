local omarchy_gdk_scale = 2
hl.env("GDK_SCALE", tostring(omarchy_gdk_scale))

hl.monitor({ output = "HDMI-A-1", mode = "1920x1080@60", position = "0x0",  scale = 1.25 })
hl.monitor({ output = "eDP-1",    mode = "1920x1080@60", position = "1536x0", scale = 1.6 })

-- Workspace blocks are owned by Omarchy (monitor-workspaces.lua), which gives
-- the laptop panel 1-10 and each other monitor the next block of ten. Pinning
-- workspaces to a connector here fights that: a rule sends every new workspace
-- to the named monitor, so focusing workspace 5 on eDP-1 would jump to
-- HDMI-A-1. The assignment lives in ~/.local/state/omarchy/monitor-workspaces
-- and is keyed by monitor identity, so it also survives docks and replugs.
--
-- omarchy-workspace-switch reads that file to route SUPER+1-0.

-- Extra autostart processes.
o.launch_on_start("hypr-persist")

-- Load autoscroll plugin (SUPER+A toggle)
require("hypr.autoscroll")

-- Load hyprpm plugins (hyprexpo)
o.launch_on_start("hyprpm reload")

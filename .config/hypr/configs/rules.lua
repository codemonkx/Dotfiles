-- Window and Workspace Rules
-- See https://wiki.hypr.land/Configuring/Window-Rules/

-- Float rules for standard tools and utility dialogs
hl.window_rule({
    match = { class = "org.gnome.Nautilus", title = ".*Properties.*" },
    float = true,
})

hl.window_rule({
    match = { class = "nm-connection-editor" },
    float = true,
})

hl.window_rule({
    match = { class = "blueman-manager" },
    float = true,
})

hl.window_rule({
    match = { class = "org.pulseaudio.pavucontrol" },
    float = true,
})

hl.window_rule({
    match = { title = ".*Preferences.*" },
    float = true,
})

hl.window_rule({
    match = { title = ".*Confirm.*" },
    float = true,
})

-- Smart gaps: hide borders and rounding when a window is fullscreen or alone on workspace
hl.window_rule({
    name = "smart-gaps-wtv1",
    match = { float = false, workspace = "w[tv1]" },
    border_size = 0,
})

hl.window_rule({
    name = "smart-gaps-f1",
    match = { float = false, workspace = "f[1]" },
    border_size = 0,
})

-- Force Zen Browser to be fully opaque to prevent wallpaper bleed-through (e.g. when watching videos)
hl.window_rule({
    match = { class = "^[zZ]en.*$" },
    opaque = true,
})

-- Global blur rules for layer shell UI components
hl.layer_rule({ match = { namespace = "waybar" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "rofi" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "swaync-control-center" }, blur = true, ignore_alpha = 0.1 })
hl.layer_rule({ match = { namespace = "swaync-notification-window" }, blur = true, ignore_alpha = 0.1 })


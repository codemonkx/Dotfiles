-- Look and Feel Configuration
-- Sets gaps, rounding, opacity, blur, shadows, border colors, and animations
-- See https://wiki.hypr.land/Configuring/Variables/

hl.config({
    general = {
        gaps_in  = 3,
        gaps_out = 12,
        border_size = 2,

        -- Dynamic theme border colors
        col = {
            active_border   = require("configs.colors").active_border,
            inactive_border = require("configs.colors").inactive_border,
        },

        resize_on_border = true,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding       = 14,            -- Glassmorphic rounded corners
        rounding_power = 2.0,           -- Standard circle rounding

        active_opacity   = 1.0,
        inactive_opacity = 0.9,         -- Layering effect for background apps

        blur = {
            enabled   = true,
            size      = 8,              -- Higher blur size for premium glassmorphism
            passes    = 3,              -- More passes makes blur look smooth and professional
            vibrancy  = 0.1696,
            noise     = 0.0117,
        },

        shadow = {
            enabled      = true,
            range        = 22,          -- Softer, wider premium shadow glow
            render_power = 4,
            color        = 0x66000000,  -- Prominent dark shadow for high contrast
        },
    },

    dwindle = {
        preserve_split = true,
    },

    input = {
        kb_layout = "us",
        follow_mouse = 1,
        touchpad = {
            natural_scroll = true,
        },
        sensitivity = 0, -- -1.0 - 1.0, 0 means no modification.
    },

    gestures = {
        workspace_swipe_min_speed_to_force = 1000000,
        workspace_swipe_distance = 120,
        workspace_swipe_cancel_ratio = 0.3,
    },

    -- Trackpad gestures (new API since Hyprland 0.51)
    -- 3-finger horizontal swipe to switch workspaces
    -- NOTE: workspace_swipe / workspace_swipe_fingers / workspace_swipe_invert /
    -- workspace_swipe_min_speed_to_force / workspace_swipe_cancel_ratio were removed.
    -- Use hl.gesture instead.

    misc = {
        force_default_wallpaper = 0,     -- Set to 0 or 1 to disable standard default wallpapers
        disable_hyprland_logo = true,    -- Disables the default Hyprland mascot logo screen
    },
})

-- 3-finger horizontal swipe to switch workspaces (natural/inverted direction)
hl.gesture({
    fingers = 3,
    direction = "horizontal",
    action = "workspace",
})

-- Animation curves
-- See https://wiki.hypr.land/Configuring/Animations/
hl.curve("easeOutQuint",   { type = "bezier", points = { {0.23, 1},    {0.32, 1}    } })
hl.curve("easeInOutCubic", { type = "bezier", points = { {0.65, 0.05}, {0.36, 1}    } })
hl.curve("macOSEase",      { type = "bezier", points = { {0.25, 1},    {0.50, 1}    } })
hl.curve("macOSSpring",    { type = "bezier", points = { {0.15, 1.15}, {0.45, 1.0}  } })
hl.curve("smoothLinear",   { type = "bezier", points = { {1.0, 1.0},   {1.0, 1.0}   } })

-- Configure animations for windows and workspaces (macOS-style smooth sliders)
hl.animation({
    leaf = "windows",
    enabled = true,
    speed = 6,
    bezier = "macOSSpring",
    style = "slide",
})

hl.animation({
    leaf = "windowsIn",
    enabled = true,
    speed = 5,
    bezier = "macOSSpring",
    style = "slide",
})

hl.animation({
    leaf = "windowsOut",
    enabled = true,
    speed = 5,
    bezier = "macOSEase",
    style = "slide",
})

hl.animation({
    leaf = "windowsMove",
    enabled = true,
    speed = 6,
    bezier = "macOSSpring",
})

hl.animation({
    leaf = "fade",
    enabled = true,
    speed = 5,
    bezier = "macOSEase",
})

hl.animation({
    leaf = "workspaces",
    enabled = true,
    speed = 6,
    bezier = "easeOutQuint",
    style = "slide",
})

hl.animation({
    leaf = "border",
    enabled = true,
    speed = 10,
    bezier = "macOSEase",
})

hl.animation({
    leaf = "borderangle",
    enabled = true,
    speed = 20,
    bezier = "smoothLinear",
    style = "loop",
})

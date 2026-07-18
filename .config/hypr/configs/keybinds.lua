-- Keybindings and Gestures Configuration
-- See https://wiki.hypr.land/Configuring/Binds/

local mainMod = "SUPER"

-- Applications Binds
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("kitty"))
hl.bind(mainMod .. " + space", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd("nautilus"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("zen-browser"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("codium"))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("kitty micro"))
hl.bind("CTRL + SHIFT + Escape", hl.dsp.exec_cmd("flatpak run io.missioncenter.MissionCenter"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("wdisplays"))
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("hyprmod"))

-- Window Management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + V", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Move Focus with Arrow keys
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Swap window position left <-> right (and up <-> down)
hl.bind(mainMod .. " + SHIFT + left", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + right", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + up", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + down", hl.dsp.window.move({ direction = "down" }))

-- Switch workspaces 1-10
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Scroll through existing workspaces
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "+1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "-1" }))



-- Volume and Media Control (via SwayOSD client)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("swayosd-client --output-volume raise"))
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("swayosd-client --output-volume lower"))
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("swayosd-client --output-volume mute-toggle"))

-- Brightness Control (via SwayOSD client)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("swayosd-client --brightness raise"))
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("swayosd-client --brightness lower"))

-- Calculator key shortcut
hl.bind("XF86Calculator", hl.dsp.exec_cmd("gnome-calculator"))

-- Screen Lock
hl.bind(mainMod .. " + L", hl.dsp.exec_cmd("hyprlock"))

-- Screenshot (Select region -> edit/save via swappy)
hl.bind(mainMod .. " + SHIFT + S", hl.dsp.exec_cmd("grim -g \"$(slurp)\" - | swappy -f -"))

-- Clipboard History GUI (Rofi selector)
hl.bind(mainMod .. " + SHIFT + V", hl.dsp.exec_cmd("cliphist list | rofi -dmenu -p 'Clipboard' | cliphist decode | wl-copy"))

-- Wallpaper Selector GUI (Rofi selector)
hl.bind(mainMod .. " + SHIFT + W", hl.dsp.exec_cmd("bash ~/.config/hypr/scripts/wallpaper.sh --select"))

-- Power Menu GUI (Rofi selector)
hl.bind(mainMod .. " + Escape", hl.dsp.exec_cmd("bash ~/.config/rofi/powermenu/type-4/powermenu.sh"))



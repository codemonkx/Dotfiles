-- Autostart Applications and Services
-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

hl.on("hyprland.start", function () 
    -- Start status bar, notification daemon, and wallpaper daemon
    hl.exec_cmd("waybar &")
    hl.exec_cmd("swaync &")
    hl.exec_cmd("swww-daemon &")

    -- Start clipboard history daemon
    hl.exec_cmd("wl-paste --type text --watch cliphist store &")
    hl.exec_cmd("wl-paste --type image --watch cliphist store &")

    -- Start Polkit authentication agent, system tray applets, and SwayOSD server
    hl.exec_cmd("/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &")
    hl.exec_cmd("nm-applet --indicator &")
    hl.exec_cmd("blueman-applet &")
    hl.exec_cmd("swayosd-server &")

    -- Start Hyprland event listener for real-time Waybar workspace updates
    hl.exec_cmd("python3 ~/.config/waybar/scripts/hypr_listener.py &")

    -- Set the default wallpaper using the custom wallpaper script
    hl.exec_cmd("sleep 1 && ~/.config/hypr/scripts/wallpaper.sh --init &")
end)

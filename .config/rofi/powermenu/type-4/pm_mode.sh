#!/usr/bin/env bash
echo "ROFI_RETV=$ROFI_RETV, arg1='$1'" >> /tmp/rofi.log
# Rofi script mode for the power menu (rofi 2.x).
case "$ROFI_RETV" in
    0)
        echo -en "  Lock\0info\x1flock\n"
        echo -en "  Suspend\0info\x1fsuspend\n"
        echo -en "  Logout\0info\x1flogout\n"
        echo -en "  Reboot\0info\x1freboot\n"
        echo -en "  Shutdown\0info\x1fshutdown\n"
        ;;
    1)
        case "$1" in
            *Lock*|*lock*)       setsid hyprlock >/dev/null 2>&1 & ;;
            *Suspend*|*suspend*) setsid systemctl suspend >/dev/null 2>&1 & ;;
            *Logout*|*logout*)   
                echo "Matched Logout case!" >> /tmp/rofi.log
                hyprctl dispatch exit >> /tmp/rofi.log 2>&1 &
                ;;
            *Reboot*|*reboot*)   setsid systemctl reboot >/dev/null 2>&1 & ;;
            *Shutdown*|*shutdown*) setsid systemctl poweroff >/dev/null 2>&1 & ;;
        esac
        ;;
esac

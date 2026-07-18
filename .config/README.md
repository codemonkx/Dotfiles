# Midnight Obsidian - Premium Arch Linux Hyprland Dotfiles

A custom, premium tiling desktop environment setup designed with a glassmorphic look, a dark Obsidian color palette, and fluid macOS-style smooth animations.

![Midnight Obsidian Theme](https://raw.githubusercontent.com/codemonkx/Dotfiles/main/Wallpaper/Space.jpg)

## 🌟 Key Features

* **macOS-Style Smooth Animations:** Windows slide cleanly into view, and workspaces slide horizontally across screen edges with natural spring and ease-out curves.
* **Touchpad Workspace Gestures:** Swiping three fingers horizontally (left/right) slides workspaces smoothly, tracking your finger movements with macOS-like responsiveness.
* **Volume & Brightness OSD:** Custom integration with **SwayOSD** showing sleek, centered HUD overlays when adjusting screen brightness or volume.
* **Interactive Wallpaper Selector:** Press `SUPER + SHIFT + W` to search and select wallpapers inside a Rofi GUI. Applying a wallpaper triggers `swww` transitions, saves your choice across reboots, and syncs your SDDM lock screen background image.
* **Obsidian Zsh Prompt:** Shell prompt customized using the custom Starship engine, combined with `zsh-autosuggestions` and `zsh-syntax-highlighting`.
* **Glassmorphic Status Bar:** Floating Waybar containing resource indicators (CPU, RAM), a media player block, Bluetooth/Network applets, and system notifications.

---

## 🛠️ App Stack

* **Window Manager:** Hyprland (Lua-based configuration)
* **Status Bar:** Waybar (Floating Glassmorphic style)
* **Application Launcher:** Rofi Wayland
* **Notification Daemon:** SwayNC
* **Lock Screen:** Hyprlock (Glass-blurred screen snapshots)
* **Display/Login Manager:** SDDM (custom Windows 7 retro-modern theme)
* **Terminal Emulator:** Kitty (Obsidian theme profile)
* **Shell Prompt:** Zsh + Starship Prompt
* **File Manager:** GNOME Nautilus
* **OSD Daemon:** SwayOSD
* **Display Manager (GUI):** wdisplays
* **System Backups (GUI/CLI):** Timeshift
* **Settings Manager (GUI):** HyprMod
* **Calculator (GUI):** GNOME Calculator

---

## ⌨️ Essential Keybindings

| Keybinding | Action |
|---|---|
| `SUPER + T` | Open Kitty Terminal |
| `SUPER_L` (Left Super) | Open Rofi App Launcher |
| `SUPER + E` | Open Nautilus File Manager |
| `SUPER + W` | Launch Zen Web Browser |
| `SUPER + C` | Open VSCodium Editor |
| `SUPER + N` | Open GNOME Text Editor (Notepad) |
| `SUPER + Q` | Close Active Window |
| `SUPER + V` | Toggle Floating Mode |
| `SUPER + F` | Toggle Fullscreen Mode |
| `SUPER + L` | Lock Screen (Hyprlock) |
| `SUPER + Escape` | Open Rofi Power Menu |
| `SUPER + SHIFT + S` | Take Region Screenshot (Edit/Save via Swappy) |
| `SUPER + SHIFT + V` | Clipboard History Menu (Rofi Selector) |
| `SUPER + SHIFT + W` | Interactive Wallpaper Selector Menu |
| `SUPER + B` | Toggle SwayNC Notification Center Sidebar |
| `SUPER + P` | Open wdisplays (Display Layout Settings) |
| `SUPER + M` | Open HyprMod (Graphical Settings Manager) |
| `XF86AudioVolume` Keys | Adjust Volume (Interactive OSD) |
| `XF86MonBrightness` Keys | Adjust Brightness (Interactive OSD) |
| `XF86Calculator` Key | Launch GNOME Calculator |

---

## 🚀 How to Install

Starting on a clean Arch Linux installation:

1. **Install Git and clone this repository:**
   ```bash
   sudo pacman -S --needed git
   git clone https://github.com/codemonkx/Dotfiles.git ~/Hyprland
   ```

2. **Run the installer script:**
   ```bash
   cd ~/Hyprland
   chmod +x install.sh
   ./install.sh
   ```

3. **Reboot your machine:**
   ```bash
   sudo reboot
   ```

---

## 🎨 Theme Consistency Setup

The installer script **pre-configures your GTK themes, icon preferences, and dark mode variables automatically** during the setup process. This means your file manager (Nautilus), PDF viewer, and system dialogs will match your Obsidian dark theme out of the box!

### GTK Themes Utility
If you want to manually change your GTK theme, cursor styles, or icon sets in the future:
1. Open the application launcher (`SUPER_L`) and launch **`nwg-look`**.
2. Select your desired GTK theme, cursor, or icon set, and click **Apply** in the bottom right corner.
3. GTK and Qt configurations will stay synced automatically.

### 2. Flatpak Applications
If you install applications using Flatpak, they cannot see your local themes by default. Run these overrides to allow them access:
```bash
flatpak override --user --filesystem=$HOME/.themes
flatpak override --user --filesystem=$HOME/.icons
```

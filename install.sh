#!/usr/bin/env bash
# Midnight Obsidian - Automatic Setup Script for Arch Linux
# Designed to be run from the root of the cloned repository

set -e

# Resolve script root directory
SCRIPT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

echo "=== Midnight Obsidian Installation Script ==="
echo "This script will install all required packages and set up your configuration files."

# 1. Update and install pacman dependencies
echo "Installing required packages via pacman..."
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm \
    hyprland \
    kitty \
    waybar \
    rofi-wayland \
    swaync \
    swww \
    cliphist \
    wl-clipboard \
    pavucontrol \
    polkit-gnome \
    hyprlock \
    grim \
    slurp \
    swappy \
    networkmanager \
    network-manager-applet \
    bluez \
    blueman \
    brightnessctl \
    pamixer \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    nautilus \
    pipewire \
    pipewire-pulse \
    pipewire-alsa \
    wireplumber \
    xorg-xwayland \
    sddm \
    nwg-look \
    neofetch \
    swayosd \
    arc-gtk-theme \
    papirus-icon-theme \
    unzip \
    p7zip \
    file-roller \
    nm-connection-editor \
    ttf-jetbrains-mono-nerd \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji \
    inter-font \
    ttf-font-awesome \
    zsh \
    zsh-syntax-highlighting \
    zsh-autosuggestions \
    starship \
    qt6-declarative \
    qt6-5compat \
    qt6-svg \
    qt6-multimedia \
    qt6-multimedia-ffmpeg \
    gst-plugins-base \
    gst-plugins-good \
    gst-plugins-bad \
    gst-plugins-ugly \
    mpv \
    imv \
    evince \
    gnome-text-editor \
    wdisplays \
    timeshift \
    gnome-calculator

# 2. Install yay AUR Helper
if ! command -v yay &> /dev/null; then
    echo "Installing yay AUR Helper..."
    git clone https://aur.archlinux.org/yay-bin.git /tmp/yay-bin
    cd /tmp/yay-bin && makepkg -si --noconfirm
    rm -rf /tmp/yay-bin
    cd "$SCRIPT_DIR"
fi

# 3. Install AUR Packages
echo "Installing AUR packages..."
yay -S --noconfirm zen-browser-bin vscodium-bin mission-center hyprmod

# 4. Configure Graphics Drivers (NVIDIA Auto-Detection)
echo ""
echo "=== Graphics Driver Auto-Detection ==="
if lspci | grep -qi nvidia; then
    echo "NVIDIA Graphics Card detected!"
    echo "Installing NVIDIA drivers and Wayland compatibility layers..."
    sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils egl-wayland

    echo "Configuring kernel modesetting for NVIDIA..."
    sudo mkdir -p /etc/modprobe.d
    echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf

    echo "Creating custom NVIDIA environment configuration for Hyprland..."
    mkdir -p "$SCRIPT_DIR/.config/hypr/configs"
    cat <<EOF > "$SCRIPT_DIR/.config/hypr/configs/nvidia.lua"
-- Custom NVIDIA Configuration
-- Loaded only on dGPU systems to protect hardware acceleration on other systems

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
EOF
else
    echo "No NVIDIA GPU detected (Intel/AMD mode). Skipping NVIDIA driver setup."
    # Clean up file if it exists
    if [ -f "$SCRIPT_DIR/.config/hypr/configs/nvidia.lua" ]; then
        rm -f "$SCRIPT_DIR/.config/hypr/configs/nvidia.lua"
    fi
fi

# 5. Setup Configuration Directories (Symbolic Links + Safety Backups)
echo "Setting up configuration files..."
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

# Helper function to create symlinks with backups
link_config() {
    local source_path="$1"
    local dest_path="$2"

    if [ -e "$source_path" ]; then
        # If destination exists and is not a symlink, back it up
        if [ -e "$dest_path" ] && [ ! -L "$dest_path" ]; then
            echo "Backing up existing config: $dest_path -> ${dest_path}.bak"
            mv "$dest_path" "${dest_path}.bak"
        fi
        
        # Remove any existing symlink or file
        rm -f "$dest_path"
        
        # Create parent directory if needed
        mkdir -p "$(dirname "$dest_path")"
        
        # Create symbolic link
        echo "Linking: $source_path -> $dest_path"
        ln -sf "$source_path" "$dest_path"
    fi
}

# Link config directories
for dir in hypr kitty waybar rofi swaync neofetch Wallpaper cava; do
    link_config "$SCRIPT_DIR/.config/$dir" "$CONFIG_DIR/$dir"
done

# Link assets directory (contains PFP and showcase media)
link_config "$SCRIPT_DIR/assets" "$HOME/assets"

# Link VSCodium settings
link_config "$SCRIPT_DIR/.config/VSCodium/User/settings.json" "$CONFIG_DIR/VSCodium/User/settings.json"
link_config "$SCRIPT_DIR/.config/VSCodium/User/keybindings.json" "$CONFIG_DIR/VSCodium/User/keybindings.json"

# Link global files
link_config "$SCRIPT_DIR/.zshrc" "$HOME/.zshrc"
link_config "$SCRIPT_DIR/.bashrc" "$HOME/.bashrc"
link_config "$SCRIPT_DIR/.config/starship.toml" "$CONFIG_DIR/starship.toml"
link_config "$SCRIPT_DIR/.config/mimeapps.list" "$CONFIG_DIR/mimeapps.list"

# Ensure powermenu script is executable
if [ -f "$CONFIG_DIR/rofi/powermenu/type-4/powermenu.sh" ]; then
    chmod +x "$CONFIG_DIR/rofi/powermenu/type-4/powermenu.sh"
fi

# Ensure wallpaper selection script is executable
if [ -f "$CONFIG_DIR/hypr/scripts/wallpaper.sh" ]; then
    chmod +x "$CONFIG_DIR/hypr/scripts/wallpaper.sh"
fi

# 6. Configure SDDM Theme (Windows 7 Theme)
echo "Configuring SDDM Theme..."
sudo mkdir -p /etc/sddm.conf.d
sudo mkdir -p /usr/share/sddm/themes

# Copy the bundled Windows 7 theme
if [ -d "$SCRIPT_DIR/.config/sddm/windows_7" ]; then
    echo "Installing Windows 7 SDDM theme..."
    sudo cp -r "$SCRIPT_DIR/.config/sddm/windows_7" /usr/share/sddm/themes/
fi

echo -e "[Theme]\nCurrent=windows_7" | sudo tee /etc/sddm.conf.d/theme.conf

# Set default application associations
echo "Configuring default applications..."
xdg-mime default mpv.desktop video/mp4 video/x-matroska video/webm video/avi video/quicktime
xdg-mime default imv.desktop image/jpeg image/png image/gif image/webp image/bmp image/svg+xml
xdg-mime default org.gnome.Evince.desktop application/pdf

# 7. Enable Essential System Services
echo "Enabling system services..."
sudo systemctl enable NetworkManager.service
sudo systemctl enable bluetooth.service
sudo systemctl enable sddm.service
sudo systemctl enable swayosd-libinput-backend.service

# 8. Change Default Shell to Zsh
echo "Changing default shell to Zsh..."
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    sudo chsh -s /usr/bin/zsh "$USER" || echo "Please run 'chsh -s /usr/bin/zsh' manually to change your shell."
fi

# 9. Pre-configure GTK Themes & Dark Mode Preference
echo "Pre-configuring GTK themes and dark mode preferences..."
mkdir -p "$CONFIG_DIR/gtk-3.0" "$CONFIG_DIR/gtk-4.0"

cat <<EOF > "$CONFIG_DIR/gtk-3.0/settings.ini"
[Settings]
gtk-theme-name=Arc-Dark
gtk-icon-theme-name=Papirus-Dark
gtk-font-name=Inter 11
gtk-cursor-theme-name=Adwaita
gtk-cursor-theme-size=24
gtk-application-prefer-dark-theme=1
EOF

cp "$CONFIG_DIR/gtk-3.0/settings.ini" "$CONFIG_DIR/gtk-4.0/settings.ini"

# Set color-scheme preference via gsettings
if command -v gsettings &> /dev/null; then
    gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark' || true
    gsettings set org.gnome.desktop.interface gtk-theme 'Arc-Dark' || true
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark' || true
fi

echo "=== Installation Completed Successfully! ==="
echo ""
echo "A display manager (SDDM) has been enabled. Please reboot your system now."
echo "After rebooting, you will be greeted by the login screen where you can start your new Hyprland session."

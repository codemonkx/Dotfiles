#!/usr/bin/env bash
# Midnight Obsidian - Automatic Setup Script for Arch Linux
# Designed to be run from the root of the cloned repository

set -e

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
    # Go back to script directory
    cd - >/dev/null
fi

# 3. Install AUR Packages
echo "Installing AUR packages..."
yay -S --noconfirm zen-browser-bin vscodium-bin mission-center hyprmod

# 4. Configure Graphics Drivers (NVIDIA/iGPU)
echo ""
echo "=== Graphics Driver Selection ==="
read -p "Do you want to install NVIDIA graphics drivers for this machine? (y/N): " install_nvidia
if [[ "$install_nvidia" =~ ^[Yy]$ ]]; then
    echo "Installing NVIDIA drivers and Wayland compatibility layers..."
    sudo pacman -S --needed --noconfirm linux-headers nvidia-dkms nvidia-utils lib32-nvidia-utils egl-wayland

    echo "Configuring kernel modesetting for NVIDIA..."
    sudo mkdir -p /etc/modprobe.d
    echo "options nvidia_drm modeset=1" | sudo tee /etc/modprobe.d/nvidia.conf

    echo "Creating custom NVIDIA environment configuration for Hyprland..."
    mkdir -p "hypr/configs"
    cat <<EOF > "hypr/configs/nvidia.lua"
-- Custom NVIDIA Configuration
-- Loaded only on dGPU systems to protect hardware acceleration on other systems

hl.env("LIBVA_DRIVER_NAME", "nvidia")
hl.env("GBM_BACKEND", "nvidia-drm")
hl.env("__GLX_VENDOR_LIBRARY_NAME", "nvidia")
EOF
else
    echo "Skipping NVIDIA driver setup (Intel/AMD iGPU mode)."
    # Clean up local file if it exists in the workspace
    if [ -f "hypr/configs/nvidia.lua" ]; then
        rm -f "hypr/configs/nvidia.lua"
    fi
fi

# 5. Setup Configuration Directories
echo "Setting up configuration files..."
CONFIG_DIR="$HOME/.config"
mkdir -p "$CONFIG_DIR"

# Copy directories to ~/.config
for dir in hypr kitty waybar rofi swaync neofetch Wallpaper cava sddm; do
    if [ -d ".config/$dir" ]; then
        echo "Copying .config/$dir to $CONFIG_DIR..."
        rm -rf "$CONFIG_DIR/$dir"
        cp -r ".config/$dir" "$CONFIG_DIR/"
    fi
done

# Ensure powermenu script is executable
if [ -f "$CONFIG_DIR/rofi/powermenu/type-4/powermenu.sh" ]; then
    chmod +x "$CONFIG_DIR/rofi/powermenu/type-4/powermenu.sh"
fi

# Ensure wallpaper selection script is executable
if [ -f "$CONFIG_DIR/hypr/scripts/wallpaper.sh" ]; then
    chmod +x "$CONFIG_DIR/hypr/scripts/wallpaper.sh"
fi

# Copy .zshrc if it exists in the repo
if [ -f ".zshrc" ]; then
    echo "Copying Zsh configuration..."
    cp .zshrc "$HOME/.zshrc"
fi

# Copy .bashrc if it exists in the repo
if [ -f ".bashrc" ]; then
    echo "Copying Bash configuration..."
    cp .bashrc "$HOME/.bashrc"
fi

# Copy starship.toml if it exists in the repo
if [ -f ".config/starship.toml" ]; then
    echo "Copying Starship prompt configuration..."
    cp .config/starship.toml "$CONFIG_DIR/starship.toml"
fi

# Copy mimeapps.list if it exists in the repo
if [ -f ".config/mimeapps.list" ]; then
    echo "Copying default apps associations..."
    cp .config/mimeapps.list "$CONFIG_DIR/mimeapps.list"
fi

# 6. Configure SDDM Theme (Windows 7 from qylock)
echo "Configuring SDDM Theme..."
sudo mkdir -p /etc/sddm.conf.d
sudo mkdir -p /usr/share/sddm/themes

# Copy the bundled Windows 7 theme
if [ -d "$CONFIG_DIR/sddm/windows_7" ]; then
    echo "Installing Windows 7 SDDM theme..."
    sudo cp -r "$CONFIG_DIR/sddm/windows_7" /usr/share/sddm/themes/
fi

echo -e "[Theme]\nCurrent=windows_7" | sudo tee /etc/sddm.conf.d/theme.conf

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

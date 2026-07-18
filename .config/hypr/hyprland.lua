-- Midnight Obsidian Custom Hyprland Configuration (v0.55+ Lua API)
-- Main entrypoint loading modular configuration parts

require("configs.env")
require("configs.monitors")
require("configs.look")
require("configs.keybinds")
require("configs.rules")
require("configs.startup")

-- Load NVIDIA configuration if it exists (written dynamically by the installer)
pcall(require, "configs.nvidia")

-- HyprMod managed settings
require("hyprland-gui")

# Regolith Desktop Environment (i3-gaps + GNOME integration)
# Alternative to desktop.nix - Equivalent of: roles/sys/regolith

{ config, pkgs, ... }: {

  # i3-gaps window manager (Regolith is based on this)
  services.xserver.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;
    extraPackages = with pkgs; [
      # Regolith-style components
      rofi              # Application launcher
      i3status-rust     # Status bar (modern alternative to i3status)
      polybar          # Alternative status bar
      picom            # Compositor
      feh              # Wallpaper setter
      arandr           # Display configuration
      pactl            # Audio control
      
      # Additional utilities
      xss-lock         # Screen locker integration
      flameshot        # Screenshots
      dunst            # Notifications
    ];
  };

  # Additional applications for Regolith-style workflow
  environment.systemPackages = with pkgs; [
    # Regolith-specific tools (browsers/vscode already in desktop.nix)
    rofi                 # App launcher
    i3lock-color        # Screen locker
    brightnessctl       # Brightness control
    playerctl           # Media control
    
    # Terminal emulators for tiling WM
    alacritty           # GPU-accelerated terminal
    kitty               # Another modern terminal
    
    # System monitoring for i3bar
    htop
    iotop
    nethogs
  ];

  # Additional fonts for better i3 experience
  fonts.packages = with pkgs; [
    font-awesome
    material-design-icons
    jetbrains-mono
  ];
}
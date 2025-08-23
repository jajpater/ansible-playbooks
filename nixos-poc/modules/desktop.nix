# Desktop Environment and Applications
# Equivalent of: roles/sys/* (browsers, desktop apps)

{ config, pkgs, ... }: {

  # X11 and desktop environment
  services.xserver = {
    enable = true;
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
    
    # Keyboard layout
    layout = "us";
    xkbVariant = "";
  };

  # Desktop applications (equivalent of your sys roles)
  environment.systemPackages = with pkgs; [
    # Browsers (from your roles/sys/)
    google-chrome
    firefox
    brave
    
    # Development tools
    vscode
    
    # System utilities
    gnome.gnome-tweaks
    gnome.dconf-editor
    
    # File management
    nautilus
    
    # Graphics and media
    gimp
    
    # Office
    libreoffice
    
    # Networking
    networkmanagerapplet
    
    # Archive tools
    file-roller
    
    # Terminal
    gnome.gnome-terminal
  ];

  # GNOME services
  services.gnome = {
    core-developer-tools.enable = true;
    gnome-keyring.enable = true;
  };

  # XDG desktop portal for screensharing etc.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];
  };
}
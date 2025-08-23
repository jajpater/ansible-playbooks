# NixOS PoC - System Configuration
# Equivalent of: ansible-playbook root.yml -K

{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix  # Auto-generated during install
    
    # Desktop environments (both available at login):
    ./modules/desktop.nix          # GNOME
    ./modules/regolith.nix         # Regolith-style (i3-gaps + GNOME apps)
    
    ./modules/development.nix
  ];

  # Boot configuration
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos-workstation";
  networking.networkmanager.enable = true;

  # Locale and timezone
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Users
  users.users.jajpater = {
    isNormalUser = true;
    description = "jajpater";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    shell = pkgs.zsh;
  };

  # System packages (equivalent of base/apt_basics)
  environment.systemPackages = with pkgs; [
    # Core utilities
    curl
    wget
    unzip
    zip
    git
    vim
    
    # Build essentials
    gcc
    gnumake
    pkg-config
    
    # Development
    python3
    nodejs
    
    # System utilities
    htop
    tree
    ripgrep
    fd
    bat
    jq
    
    # Fonts (from your apt_basics)
    cascadia-code
    dejavu_fonts
    powerline-fonts
    
    # Media and graphics
    vlc
    flameshot
    
    # Office and productivity
    pandoc
    
    # Spell checking (Dutch support like your setup)
    aspell
    aspellDicts.nl
    aspellDicts.en
    hunspell
    hunspellDicts.nl_nl
    hunspellDicts.en_us
  ];

  # Fonts configuration
  fonts.packages = with pkgs; [
    cascadia-code
    dejavu_fonts
    powerline-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    font-awesome
  ];

  # Services
  services.openssh.enable = true;
  services.printing.enable = true;
  
  # Sound
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Experimental features for flakes
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  
  # Allow unfree packages (for some proprietary software)
  nixpkgs.config.allowUnfree = true;

  # System version
  system.stateVersion = "23.11";
}
# Development Tools and Languages
# Equivalent of: various tools/* roles

{ config, pkgs, ... }: {

  # Development packages
  environment.systemPackages = with pkgs; [
    # Version control
    git
    gh  # GitHub CLI
    
    # Languages and runtimes (from your roles)
    # Java (for LanguageTool)
    openjdk11
    
    # Rust (equivalent of tools/rust role)
    rustc
    cargo
    rustfmt
    clippy
    
    # Go (equivalent of tools/go role)
    go
    
    # Node.js and npm (equivalent of tools/npm role)
    nodejs
    npm
    
    # Python
    python3
    python3Packages.pip
    python3Packages.virtualenv
    
    # Build tools
    cmake
    gnumake
    gcc
    clang
    pkg-config
    
    # Text processing (like your setup)
    pandoc
    texlive.combined.scheme-full
    
    # OCR (from your apt_basics)
    tesseract
    
    # Development utilities
    docker
    docker-compose
    
    # Shell and terminal tools (equivalent of various tool roles)
    zsh
    oh-my-zsh
    fzf
    ripgrep
    fd
    bat
    eza  # Modern ls replacement
    zoxide  # Smart cd
    
    # Neovim (equivalent of tools/neovim role)
    neovim
    
    # Modern CLI tools that match your current setup
    curl
    wget
    jq
    yq
    tree
    htop
    btop
    
    # Archive and compression
    unzip
    zip
    p7zip
    
    # Network tools
    nmap
    socat
    
    # File synchronization (like your rclone/restic)
    rclone
    restic
    rsync
  ];

  # Docker service
  virtualisation.docker = {
    enable = true;
    rootless = {
      enable = true;
      setSocketVariable = true;
    };
  };

  # Development shells and environments
  environment.shellAliases = {
    # Git shortcuts
    g = "git";
    gs = "git status";
    ga = "git add";
    gc = "git commit";
    gp = "git push";
    
    # Modern alternatives
    ls = "eza";
    cat = "bat";
    grep = "rg";
    find = "fd";
    
    # Development shortcuts
    v = "nvim";
    vim = "nvim";
    
    # Docker shortcuts
    d = "docker";
    dc = "docker-compose";
  };

  # Programs configuration
  programs = {
    zsh.enable = true;
    git.enable = true;
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
    };
  };
}
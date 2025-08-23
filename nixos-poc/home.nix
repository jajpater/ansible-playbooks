# Home Manager Configuration
# Equivalent of: ansible-playbook user.yml (user-level tools and dotfiles)

{ config, pkgs, ... }: {
  
  # Home Manager version
  home.stateVersion = "23.11";
  
  # User packages (equivalent of user.yml roles)
  home.packages = with pkgs; [
    # Note-taking and writing tools
    languagetool  # Grammar checker (equivalent of tools/languagetool role)
    zk           # Note-taking tool (equivalent of tools/zk role)
    
    # Claude Code (equivalent of tools/claude-code role)
    # Note: This might need to be installed via npm in a shell
    
    # Development tools
    atuin  # Shell history (equivalent of tools/atuin)
    
    # Modern CLI replacements
    gdu    # Disk usage analyzer (equivalent of tools/gdu)
    
    # File management and utilities
    ranger  # Terminal file manager
    
    # Fonts (Source Code Pro equivalent)
    source-code-pro
    
    # Additional user-level tools
    wakatime-cli
    
    # Package managers and tools
    guix  # GNU Guix package manager (equivalent of tools/guix)
    
    # Clipboard manager (equivalent of tools/greenclip)
    greenclip
    
    # Image and document processing
    # ScanTailor equivalent would need custom packaging
    
    # Communication and productivity
    # (Add specific tools as needed)
    
    # Spacemacs / Emacs (equivalent of tools/spacemacs)
    emacs
    
    # Shell enhancements
    starship  # Modern shell prompt
  ];
  
  # Programs configuration (dotfiles equivalent)
  programs = {
    # Zsh configuration (equivalent of shell config in your roles)
    zsh = {
      enable = true;
      enableCompletion = true;
      enableAutosuggestions = true;
      syntaxHighlighting.enable = true;
      
      # Aliases (equivalent of infra/shell-aliases role)
      shellAliases = {
        # LanguageTool shortcuts
        lt = "languagetool";
        lt-gui = "languagetool-gui";
        lt-server = "languagetool-server";
        
        # zk note-taking shortcuts (equivalent of tools/zk aliases)
        zkn = "zk new --title";
        zkl = "zk list";
        zke = "zk edit --interactive";
        zkf = "zk list --interactive";
        zkd = "cd ~/Documents/Aantekeningen/zk-default-notebook";
        
        # Clipboard manager (equivalent of tools/greenclip)
        clip = "greenclip print";
        clip-clear = "greenclip clear";
        
        # Development shortcuts
        ll = "eza -la";
        la = "eza -la";
        tree = "eza --tree";
        
        # Modern alternatives
        # cat = "bat";
        # grep = "rg";
        # find = "fd";
        # du = "gdu";
        
        # Git shortcuts
        g = "git";
        gs = "git status";
        ga = "git add";
        gc = "git commit";
        gp = "git push";
        gl = "git log --oneline";
        
        # Navigation
        ".." = "cd ..";
        "..." = "cd ../..";
        "...." = "cd ../../..";
      };
      
      # Oh My Zsh equivalent
      oh-my-zsh = {
        enable = true;
        plugins = [
          "git"
          "docker"
          "rust"
          "node"
          "python"
          "kubectl"
        ];
        theme = "robbyrussell";
      };
    };
    
    # Git configuration (equivalent of global git config)
    git = {
      enable = true;
      userName = "jajpater";
      userEmail = "your-email@example.com";  # Update this
      
      extraConfig = {
        init.defaultBranch = "main";
        core.editor = "nvim";
        pull.rebase = false;
        push.autoSetupRemote = true;
      };
    };
    
    # Starship prompt (modern shell prompt)
    starship = {
      enable = true;
      settings = {
        add_newline = false;
        format = "$all$character";
        character = {
          success_symbol = "[➜](bold green)";
          error_symbol = "[➜](bold red)";
        };
      };
    };
    
    # Atuin (shell history)
    atuin = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        auto_sync = false;  # Set to true if you want cloud sync
        update_check = false;
      };
    };
    
    # FZF (fuzzy finder)
    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f";
      defaultOptions = [
        "--height 40%"
        "--border"
        "--layout=reverse"
      ];
    };
    
    # Zoxide (smart cd)
    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };
    
    # Bat (better cat)
    bat = {
      enable = true;
      config = {
        theme = "TwoDark";
        pager = "less -FR";
      };
    };
    
    # Neovim configuration (basic equivalent of tools/neovim role)
    neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;
      
      # Basic plugins (expand as needed)
      plugins = with pkgs.vimPlugins; [
        vim-sensible
        vim-airline
        vim-airline-themes
        nerdtree
        fzf-vim
      ];
      
      # Basic configuration
      extraConfig = ''
        set number
        set relativenumber
        set tabstop=2
        set shiftwidth=2
        set expandtab
        set smartindent
        set nowrap
        set smartcase
        set noswapfile
        set nobackup
        set undodir=~/.vim/undodir
        set undofile
        set incsearch
        set scrolloff=8
        set colorcolumn=80
        
        " Set leader key
        let mapleader = " "
        
        " Basic key mappings
        nnoremap <leader>pv :Ex<CR>
        nnoremap <leader>ff :Files<CR>
        nnoremap <leader>fg :Rg<CR>
      '';
    };
  };
  
  # XDG configuration (equivalent of your XDG compliance)
  xdg = {
    enable = true;
    
    # LanguageTool configuration (equivalent of your languagetool templates)
    configFile = {
      "languagetool/server.properties".text = ''
        port=8081
        public=false
        allow-origin=*
        maxTextLength=50000
        maxCheckTimeMillis=60000
      '';
      
      "languagetool/gui.properties".text = ''
        # LanguageTool GUI configuration
        language=en-US
        motherTongue=nl
        autoDetect=true
      '';
      
      # zk configuration (equivalent of tools/zk templates)
      "zk/config.toml".text = ''
        # zk configuration file
        # Documentation: https://zk-org.github.io/zk/config/
        
        # Default notebook settings
        [notebook]
        dir = "~/Documents/Aantekeningen/zk-default-notebook"
        
        # Note creation rules
        [note]
        language = "nl"
        default-title = "Untitled"
        filename = "{{id}}-{{slug title}}"
        extension = "md"
        template = "default.md"
        id-charset = "alphanum"
        id-length = 4
        id-case = "lower"
        
        # External tools configuration
        [tool]
        editor = "vim"
        shell = "zsh"
        pager = "less -FIRX"
        fzf-preview = "bat -p --color always {1}"
        
        # Note formatting settings
        [format]
        markdown.hashtags = true
        markdown.colon-tags = true
        markdown.multiword-tags = false
        
        # Custom note groups
        [group.daily]
        paths = ["dagboek"]
        note.filename = "{{id}}-dagboek.md"
        note.template = "daily.md"
        
        [group.weekly]
        paths = ["wekelijks"]
        note.filename = "{{id}}-week.md"
        note.template = "weekly.md"
        
        [group.project]
        paths = ["projecten"]
        note.template = "project.md"
        
        # Named filters for common searches
        [filter]
        recents = "--sort created- --created-after 'last two weeks'"
        journal = "--sort created- dagboek"
        unlinked = "--orphan --no-input"
        
        # Command aliases
        [alias]
        ls = "zk list $@"
        n = "zk new --title $@"
        e = "zk edit --interactive $@"
        f = "zk list --interactive $@"
        recent = "zk list --sort created- --created-after 'last two weeks'"
        daily = "zk new --group daily"
        weekly = "zk new --group weekly"
      '';
    };
    
    # Desktop entries (equivalent of desktop file creation in roles)
    desktopEntries = {
      languagetool = {
        name = "LanguageTool";
        comment = "Grammar and style checker for multiple languages";
        exec = "languagetool-gui";
        icon = "languagetool";
        terminal = false;
        categories = [ "Office" "Education" ];
        mimeType = [ "text/plain" "application/rtf" ];
      };
    };
  };
  
  # Environment variables (equivalent of shell profile exports)
  home.sessionVariables = {
    EDITOR = "nvim";
    BROWSER = "google-chrome-stable";
    
    # LanguageTool environment (equivalent of your templates)
    LANGUAGETOOL_CONFIG = "${config.xdg.configHome}/languagetool";
    LANGUAGETOOL_CACHE = "${config.xdg.cacheHome}/languagetool";
    LANGUAGETOOL_DATA = "${config.xdg.dataHome}/languagetool";
    
    # zk note-taking environment (equivalent of zk role exports)
    ZK_CONFIG = "${config.xdg.configHome}/zk";
    ZK_DATA = "${config.xdg.dataHome}/zk";
    ZK_NOTEBOOK_DIR = "~/Documents/Aantekeningen/zk-default-notebook";
    
    # Development environment
    GOPATH = "${config.xdg.dataHome}/go";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
  };
  
  # Services (equivalent of systemd services in your setup)
  services = {
    # Clipboard manager (equivalent of tools/greenclip autostart)
    greenclip = {
      enable = true;
    };
    
    # Backup service (equivalent of your restic/rclone setup)
    # This would need custom configuration based on your backup strategy
  };
}

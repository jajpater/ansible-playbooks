# NixOS Proof of Concept

This PoC demonstrates how your current Ansible playbooks could be translated to NixOS configuration.

## 🎯 **What this PoC covers**

### System-level (configuration.nix)
- ✅ **Base packages** (equivalent of `base/apt_basics`)
- ✅ **Desktop environment** (equivalent of `sys/*` roles)
- ✅ **Development tools** (equivalent of system-level tool installations)
- ✅ **Java ecosystem** (for LanguageTool)
- ✅ **Fonts and localization** (Dutch support like your setup)

### User-level (home.nix)
- ✅ **LanguageTool** (equivalent of `tools/languagetool` role)
- ✅ **zk note-taking** (equivalent of `tools/zk` role)
- ✅ **Shell configuration** (equivalent of `infra/shell-aliases`)
- ✅ **Modern CLI tools** (fzf, zoxide, atuin, etc.)
- ✅ **Neovim configuration** (equivalent of `tools/neovim` role)
- ✅ **XDG compliance** (proper config/cache/data directories)
- ✅ **Desktop integration** (desktop files, environment variables)

## 🚀 **How to test this PoC**

### Option 1: Virtual Machine (Safest)
```bash
# Download NixOS ISO
wget https://channels.nixos.org/nixos-23.11/latest-nixos-minimal-x86_64-linux.iso

# Create VM with 4GB RAM, 20GB disk
# Install NixOS with default configuration
# Then replace /etc/nixos/ with this PoC
```

### Option 2: NixOS Container (Quick test)
```bash
# On any Linux system with Nix installed
sudo nix-shell -p nixos-rebuild
sudo nixos-container create nixos-poc --flake .#nixos-workstation
sudo nixos-container start nixos-poc
sudo nixos-container root-login nixos-poc
```

### Option 3: Live USB (Non-destructive)
```bash
# Boot from NixOS USB
# Copy this config to /tmp/
# Run: nixos-rebuild switch --flake /tmp/nixos-poc#nixos-workstation
```

## 📊 **Direct comparisons**

| Ansible Approach | NixOS Equivalent | Advantage |
|-------------------|------------------|-----------|
| `ansible-playbook root.yml -K` | `nixos-rebuild switch` | Atomic updates, rollback |
| `ansible-playbook user.yml` | `home-manager switch` | Declarative dotfiles |
| `roles/tools/languagetool/` | `pkgs.languagetool` | Built-in package |
| `roles/tools/zk/` | `pkgs.zk` | No template complexity |
| Manual package management | Automatic dependency resolution | No conflicts |
| `--check` dry run | `nixos-rebuild dry-activate` | Better preview |

## 🔧 **Customization**

### Add your packages
```nix
# In configuration.nix or home.nix
environment.systemPackages = with pkgs; [
  your-package-here
];
```

### Configure services
```nix
# Example: Enable Docker
virtualisation.docker.enable = true;
```

### Add dotfiles
```nix
# In home.nix
xdg.configFile."app/config.conf".source = ./dotfiles/app-config.conf;
```

## 🎨 **What's different from your Ansible setup**

### Better
- ✅ **Atomic updates** - No more broken upgrades
- ✅ **Rollbacks** - Any generation can be restored
- ✅ **Reproducibility** - Same config = identical system
- ✅ **No dependency conflicts** - Multiple versions coexist
- ✅ **Declarative** - Entire system in version control

### Learning curve
- 📚 **Nix language** - Functional configuration language
- 📚 **Different mindset** - What vs How
- 📚 **Package search** - `nix search` instead of `apt search`

## 🚀 **Migration strategy**

### Phase 1: Core system (Week 1)
```nix
# Basic NixOS installation with essential packages
# Equivalent of: base/apt_basics + core sys/ roles
```

### Phase 2: Development environment (Week 2)
```nix
# Add all development tools and languages
# Equivalent of: tools/rust, tools/go, tools/neovim, etc.
```

### Phase 3: User environment (Week 3)
```nix
# Home Manager configuration with dotfiles
# Equivalent of: user.yml + shell configurations
```

### Phase 4: Specialized tools (Week 4+)
```nix
# Custom packages for tools not in nixpkgs
# Equivalent of: complex roles like scantailor-advanced
```

## 🤔 **Try it out**

1. **Boot NixOS live USB**
2. **Copy this config to `/tmp/nixos-poc/`**
3. **Run: `nixos-rebuild switch --flake /tmp/nixos-poc#nixos-workstation`**
4. **Experience the magic** ✨

The system will be **exactly** as configured, every time!

## 📈 **Next steps**

If you like what you see:
1. **Install NixOS** alongside Ubuntu (dual boot)
2. **Migrate tools gradually** (start with simple ones)
3. **Keep Ansible** as backup during transition
4. **Evaluate** after 2-4 weeks of daily use

Want to dive deeper? The NixOS manual is excellent: https://nixos.org/manual/nixos/stable/
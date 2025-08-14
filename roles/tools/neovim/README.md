# Neovim Installation Role

This Ansible role installs and maintains the latest Neovim from GitHub releases on Debian/Ubuntu systems, ensuring you always have access to the most recent features and improvements.

## Features

- **Always Latest**: Installs from official GitHub releases, not outdated distribution packages
- **System Installation**: Installs to `/usr/local` for system-wide availability
- **Smart Updates**: Only downloads/installs when version changes or forced
- **Shell Integration**: Optional vi/vim aliases for seamless transition
- **Desktop Entry**: Creates application launcher for GUI environments
- **Configuration Support**: Optional basic configuration initialization

## Requirements

- Ubuntu/Debian-based system with apt package manager
- Internet connection for downloading releases
- Sudo privileges (role requires `become: true` for system installation)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Installation method: 'github' (recommended for latest) or 'package' (from distro)
neovim_install_method: "github"

# Version to install (use 'latest' for most recent release)
neovim_version: "latest"

# Installation directory for Neovim binary and supporting files (system-wide)
neovim_install_dir: "/usr/local"

# Whether to update Neovim if already installed
neovim_force_update: false

# Whether to create a desktop entry
neovim_create_desktop_entry: true

# Whether to set up alternatives for 'vi' and 'vim' commands
neovim_setup_alternatives: true

# XDG-compliant Neovim configuration directory
neovim_config_dir: "{{ ansible_env.HOME }}/.config/nvim"

# Whether to initialize basic configuration
neovim_init_config: false
```

## Usage

### Basic Installation

Add the role to your playbook (requires sudo privileges):

```yaml
- role: tools/neovim
  tags: [neovim]
```

### Force Update

To always install the latest version, even if already installed:

```yaml
- role: tools/neovim
  vars:
    neovim_force_update: true
  tags: [neovim]
```

### With Basic Configuration

Install with a basic init.lua configuration:

```yaml
- role: tools/neovim
  vars:
    neovim_init_config: true
  tags: [neovim]
```

### Minimal Installation

Install without desktop entry and shell aliases:

```yaml
- role: tools/neovim
  vars:
    neovim_create_desktop_entry: false
    neovim_setup_alternatives: false
  tags: [neovim]
```

### Specific Version

Install a specific Neovim version:

```yaml
- role: tools/neovim
  vars:
    neovim_version: "v0.11.3"
  tags: [neovim]
```

## What This Role Does

1. **Dependency Check**: Verifies required system packages (curl, wget, tar, xz-utils)
2. **Release Detection**: Gets latest or specified version from GitHub API
3. **Version Comparison**: Checks if update is needed
4. **Download**: Downloads official Linux x86_64 tarball
5. **Installation**: Extracts to `/usr/local/{bin,lib,share}/`
6. **Configuration**: Creates config directory and optional basic configuration
7. **Integration**: Sets up desktop entry and shell aliases (if enabled)
8. **Verification**: Confirms successful installation

## Installation Structure

After installation:

```
/usr/local/
├── bin/nvim              # Neovim binary
├── lib/nvim/             # Runtime libraries
└── share/nvim/           # Runtime files, help, etc.

~/.config/nvim/           # Configuration directory
└── init.lua              # Main configuration file (if created)

/usr/share/applications/
└── nvim.desktop          # Desktop entry (if created)
```

## Environment Variables

The role installs to system-standard paths:
- `/usr/local/bin/nvim` - The executable (automatically in PATH)
- `~/.config/nvim/` - Configuration directory (XDG standard, per-user)

## Post-Installation

After installation:

1. **Verify**: `nvim --version`
2. **Configure**: Edit `~/.config/nvim/init.lua` for custom configuration
3. **Package Manager**: Consider installing a plugin manager like [lazy.nvim](https://github.com/folke/lazy.nvim)
4. **GUI Frontends**: Install Neovide or FVim for enhanced GUI experience

## Neovim Configuration

The role optionally creates a basic `init.lua` with sensible defaults:
- Line numbers (absolute and relative)
- Proper indentation (2 spaces)
- System clipboard integration
- Smart indenting

## Common Commands

After installation:
```bash
# Check version
nvim --version

# Edit a file
nvim file.txt

# Edit current directory
nvim .

# Check health
nvim +checkhealth

# Update plugins (if using plugin manager)
nvim +PlugUpdate
```

## Integration with GUI Frontends

This role installs the core Neovim engine. For GUI experiences:

- **Neovide**: Modern Rust-based GUI (install with `tools/neovide` role)
- **FVim**: Cross-platform .NET GUI (install with `tools/fvim` role)
- **Neovim-Qt**: Qt-based GUI (available in repositories)

## Example Playbook

```yaml
- name: Install Latest Neovim
  hosts: localhost
  connection: local
  gather_facts: true
  become: true   # Required: needs sudo for system installation

  roles:
    - role: tools/neovim
      vars:
        neovim_force_update: false
        neovim_init_config: true
        neovim_setup_alternatives: true
      tags: [neovim]
```

## Troubleshooting

**Command not found**: `/usr/local/bin` should be automatically in PATH
**Permission denied**: Role requires `sudo` access for system installation
**Old version**: Use `neovim_force_update: true` to reinstall
**Dependencies missing**: Install with `sudo apt install curl wget tar xz-utils`

## Benefits Over Distribution Packages

- Always latest stable version
- Faster bug fixes and new features
- No waiting for distribution maintainers
- Consistent experience across Ubuntu versions
- Easy to update when new releases come out

## License

Same as the parent playbook repository.

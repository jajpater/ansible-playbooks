# FVim GUI Role

This Ansible role installs and maintains FVim, a cross-platform .NET/Avalonia-based GUI client for Neovim, from GitHub releases on Debian/Ubuntu systems.

## Features

- **Cross-Platform**: Built on .NET Core with Avalonia UI framework
- **System Integration**: Uses Debian packages for proper system integration
- **Ligature Support**: Advanced font rendering with ligature support
- **High Performance**: Smooth scrolling and rendering
- **Configuration**: JSON-based configuration system

## Requirements

- Ubuntu/Debian-based system
- Neovim must be installed first (use `tools/neovim` role)
- Internet connection for downloading releases
- GUI environment (X11 or Wayland)
- .NET runtime dependencies (handled by .deb package)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Version to install (use 'latest' for most recent release)
fvim_version: "latest"

# Installation method: 'deb' (Debian package)
fvim_install_method: "deb"

# Whether to update FVim if already installed
fvim_force_update: false

# Default Neovim binary for FVim to use
fvim_nvim_path: "{{ ansible_env.HOME }}/.local/bin/nvim"

# Whether to initialize basic FVim configuration
fvim_init_config: false
```

## Usage

### Basic Installation

Add the role to your playbook (requires Neovim and sudo access):

```yaml
- role: tools/fvim
  tags: [fvim]
```

### Force Update

To always install the latest version:

```yaml
- role: tools/fvim
  vars:
    fvim_force_update: true
  tags: [fvim]
```

### With Configuration

Install with basic FVim configuration:

```yaml
- role: tools/fvim
  vars:
    fvim_init_config: true
  tags: [fvim]
```

### Complete Neovim + FVim Setup

```yaml
roles:
  - role: tools/neovim
    tags: [neovim]
  - role: tools/fvim
    vars:
      fvim_init_config: true
    tags: [fvim]
```

## What This Role Does

1. **Dependency Check**: Verifies required system libraries (.NET runtime deps)
2. **Neovim Check**: Ensures Neovim is available
3. **Release Detection**: Gets latest or specified version from GitHub
4. **Architecture Detection**: Selects appropriate .deb package (amd64/arm64)
5. **Download**: Downloads Debian package
6. **Installation**: Installs using dpkg (requires sudo)
7. **Configuration**: Optional FVim-specific settings
8. **Verification**: Confirms successful installation

## Installation Method

FVim uses **system-wide installation** via Debian packages because:
- Better integration with desktop environment
- Proper dependency management for .NET runtime
- Standard application registration
- Cleaner uninstallation process

**Note**: This requires `sudo` privileges, unlike user-level tools.

## FVim Configuration

The role can create a `config.json` file with:
- Font family and size settings
- UI transparency
- IME (Input Method Editor) support
- Debug settings

Configuration location: `~/.config/fvim/config.json`

## Common Commands

After installation:
```bash
# Launch FVim
fvim

# Edit a file
fvim file.txt

# Edit current directory  
fvim .

# See all options
fvim --help

# Check version
fvim --version
```

## FVim Features

- **Smooth Rendering**: High-performance text rendering
- **Ligature Support**: Programming font ligatures and advanced typography
- **Cross-Platform**: Same experience across Linux, Windows, macOS
- **IME Support**: Full input method editor support for international keyboards
- **Transparency**: Adjustable window transparency
- **Modern UI**: Built with modern .NET/Avalonia framework

## Integration with Neovim

FVim works with your existing Neovim configuration:

1. Uses your existing Neovim installation and config
2. Supports all Neovim features and plugins
3. Can be configured via FVim-specific JSON config
4. Maintains compatibility with terminal-based workflow

Example configuration additions for FVim in your Neovim config:
```lua
-- FVim-specific settings (if needed)
if vim.g.fvim_loaded then
  -- FVim-specific keybindings or settings can go here
  vim.opt.guifont = "Fira Code:h12"
end
```

## Architecture Support

The role automatically detects your system architecture:
- **x86_64** → selects `amd64` .deb package
- **aarch64** → selects `arm64` .deb package

## Example Playbook

```yaml
- name: Install Neovim with FVim GUI
  hosts: localhost
  connection: local  
  gather_facts: true
  become: false  # Role handles sudo internally

  roles:
    - role: tools/neovim
      tags: [neovim]
      
    - role: tools/fvim
      vars:
        fvim_init_config: true
      tags: [fvim]
```

## Troubleshooting

**Permission denied**: The role needs sudo access for installing .deb packages
**Neovim not found**: Install Neovim first with `tools/neovim` role  
**Dependencies missing**: The .deb package should handle .NET dependencies automatically
**Wrong architecture**: Check that your system architecture is supported
**Package conflicts**: Use `sudo apt-get install -f` to fix dependency issues

## Comparison with Other Neovim GUIs

| Feature | FVim | Neovide | Neovim-Qt |
|---------|------|---------|-----------|
| Installation | System (.deb) | User (AppImage) | System (apt) |
| Performance | High | Very High | Medium |
| Ligatures | Yes | Yes | Limited |
| Transparency | Yes | Yes | No |
| Cross-platform | Yes | Yes | Yes |
| Dependencies | .NET | None | Qt |

## Advanced Configuration

FVim can be extensively configured via `~/.config/fvim/config.json`:

```json
{
  "font": {
    "family": "Fira Code",
    "size": 12,
    "weight": "normal"
  },
  "ui": {
    "transparency": 0.95,
    "useIme": true,
    "debug": false
  },
  "editor": {
    "smoothScrolling": true,
    "ligatures": true
  }
}
```

## Uninstallation

To remove FVim:
```bash
sudo apt remove fvim
```

## License

Same as the parent playbook repository.

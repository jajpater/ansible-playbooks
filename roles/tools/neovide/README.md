# Neovide GUI Role

This Ansible role installs and maintains Neovide, a modern Rust-based GUI client for Neovim, from GitHub releases on Debian/Ubuntu systems.

## Features

- **Latest Releases**: Installs from official GitHub releases
- **Multiple Methods**: AppImage (portable) or tarball (extract to bin)
- **User Installation**: Installs to `~/.local` for user-level access
- **Smart Updates**: Only downloads/installs when version changes
- **Desktop Integration**: Creates application launcher
- **Configuration Support**: Optional Neovide-specific configuration

## Requirements

- Ubuntu/Debian-based system
- Neovim must be installed first (use `tools/neovim` role)
- Internet connection for downloading releases
- GUI environment (X11 or Wayland)
- Required system libraries (see dependencies check in role)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Version to install (use 'latest' for most recent release)
neovide_version: "latest"

# Installation method: 'appimage' (portable) or 'tarball' (extract to bin)
neovide_install_method: "appimage"

# Installation directory for Neovide
neovide_install_dir: "{{ ansible_env.HOME }}/.local"

# Whether to update Neovide if already installed
neovide_force_update: false

# Whether to create desktop entry
neovide_create_desktop_entry: true

# Default Neovim binary for Neovide to use
neovide_nvim_path: "{{ ansible_env.HOME }}/.local/bin/nvim"

# Whether to initialize basic Neovide configuration
neovide_init_config: false
```

## Usage

### Basic Installation

Add the role to your playbook (requires Neovim to be installed first):

```yaml
- role: tools/neovide
  tags: [neovide]
```

### Force Update

To always install the latest version:

```yaml
- role: tools/neovide
  vars:
    neovide_force_update: true
  tags: [neovide]
```

### Using Tarball Instead of AppImage

```yaml
- role: tools/neovide
  vars:
    neovide_install_method: "tarball"
  tags: [neovide]
```

### With Configuration

Install with basic Neovide configuration:

```yaml
- role: tools/neovide
  vars:
    neovide_init_config: true
  tags: [neovide]
```

### Complete Neovim + Neovide Setup

```yaml
roles:
  - role: tools/neovim
    tags: [neovim]
  - role: tools/neovide
    vars:
      neovide_init_config: true
    tags: [neovide]
```

## What This Role Does

1. **Dependency Check**: Verifies required system libraries
2. **Neovim Check**: Ensures Neovim is available
3. **Release Detection**: Gets latest or specified version from GitHub
4. **Download**: Downloads AppImage or tarball
5. **Installation**: Places binary in `~/.local/bin/`
6. **Desktop Entry**: Creates application launcher
7. **Configuration**: Optional Neovide-specific settings
8. **Verification**: Confirms successful installation

## Installation Methods

### AppImage (Default)
- **Pros**: Portable, self-contained, easy to update
- **Cons**: Larger file size, might have some desktop integration quirks
- **Best for**: Users who want latest features with minimal system impact

### Tarball  
- **Pros**: Smaller size, better system integration
- **Cons**: Requires extracting and managing files
- **Best for**: Users who prefer traditional binary installation

## Neovide Configuration

The role can optionally create a Neovide-specific configuration with:
- Transparency settings
- Cursor animations and effects
- Font configuration  
- Performance settings (refresh rates)
- Key mappings (F11 for fullscreen)

## Common Commands

After installation:
```bash
# Launch Neovide
neovide

# Edit a file  
neovide file.txt

# Edit current directory
neovide .

# See all options
neovide --help

# Check version
neovide --version
```

## Neovide Features

- **Smooth Scrolling**: Buttery smooth scrolling experience
- **Cursor Effects**: Animated cursor with trails and effects
- **Ligature Support**: Programming font ligatures
- **Transparency**: Adjustable window transparency
- **Fullscreen**: F11 toggles fullscreen mode
- **Font Scaling**: Ctrl+Shift+= and Ctrl+- to adjust font size
- **High DPI**: Excellent support for high DPI displays

## Integration with Neovim

Neovide works seamlessly with your existing Neovim configuration. You can:

1. Use all your existing plugins and configurations
2. Add Neovide-specific settings using `vim.g.neovide` checks
3. Configure GUI-specific fonts, transparency, and effects
4. Use the same key bindings and commands

Example Neovim configuration for Neovide:
```lua
if vim.g.neovide then
  vim.g.neovide_transparency = 0.9
  vim.g.neovide_cursor_animation_length = 0.13
  vim.opt.guifont = "Fira Code:h12"
  
  -- Key mapping for fullscreen
  vim.keymap.set("n", "<F11>", function()
    vim.g.neovide_fullscreen = not vim.g.neovide_fullscreen
  end)
end
```

## Example Playbook

```yaml
- name: Install Neovim with Neovide GUI
  hosts: localhost
  connection: local
  gather_facts: true
  become: false

  roles:
    - role: tools/neovim
      tags: [neovim]
      
    - role: tools/neovide
      vars:
        neovide_init_config: true
        neovide_install_method: "appimage"
      tags: [neovide]
```

## Troubleshooting

**Neovim not found**: Install Neovim first with `tools/neovim` role
**AppImage won't run**: Check if FUSE is available: `sudo apt install fuse`
**Graphics issues**: Ensure you have proper GPU drivers installed
**Font issues**: Install your preferred programming fonts
**Desktop entry not working**: Check `~/.local/share/applications/neovide.desktop`

## Advantages Over Other GUIs

- **Performance**: Written in Rust, extremely fast
- **Modern**: Uses modern rendering techniques
- **Active Development**: Regularly updated with new features
- **Native Feel**: Doesn't feel like a terminal application
- **Customizable**: Extensive configuration options

## License

Same as the parent playbook repository.

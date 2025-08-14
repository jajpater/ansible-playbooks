# nvim-qt - Qt GUI for Neovim

This Ansible role builds and installs nvim-qt from source, ensuring it uses your existing Neovim installation (e.g., from GitHub releases) rather than installing a conflicting version from apt.

## Features

- **Automatic dependency installation**: Installs Qt development packages automatically
- **Source-based installation**: Builds nvim-qt from source to avoid apt conflicts
- **Uses existing Neovim**: Links against your GitHub-installed Neovim
- **Desktop integration**: Creates application menu entry
- **Version management**: Downloads latest or specific nvim-qt versions
- **Clean build process**: Manages dependencies and build environment
- **System-wide installation**: Installs to `/usr/local` for all users

## Why Build from Source?

The apt package `neovim-qt` would install its own neovim dependency, creating version conflicts with your GitHub-installed Neovim. This role:

- ✅ Uses your existing Neovim installation
- ✅ Avoids version conflicts
- ✅ Ensures compatibility with latest Neovim features
- ✅ Maintains your existing Neovim configuration

## Requirements

- Existing Neovim installation (system-wide from GitHub releases)
- Ubuntu 20.04+ or Debian 10+
- sudo access (for installing Qt development packages)
- Build tools (automatically installed)

### System Dependencies

The role automatically installs these via apt:
- `git`, `cmake`, `build-essential`
- `qtbase5-dev`, `qttools5-dev`, `qttools5-dev-tools`
- `libqt5svg5-dev`, `pkg-config`

## Role Variables

### Basic Configuration

```yaml
# nvim-qt version ('latest' or specific tag like 'v0.2.18')
nvim_qt_version: "latest"

# Installation directory (system-wide)
nvim_qt_install_dir: "/usr/local"

# Path to your Neovim executable (system-wide)
nvim_qt_nvim_path: "/usr/local/bin/nvim"

# Force rebuild even if installed
nvim_qt_force_rebuild: false
```

### Build Configuration

```yaml
# Build type (Release, Debug, RelWithDebInfo)
nvim_qt_build_type: "Release"

# Build directory (temporary)
nvim_qt_build_dir: "/tmp/nvim-qt-build"
```

### Desktop Integration

```yaml
# Create desktop entry
nvim_qt_create_desktop_entry: true

# Desktop entry details
nvim_qt_desktop_entry:
  name: "Neovim Qt"
  comment: "Qt GUI for Neovim"
  categories: "TextEditor;Development;IDE;"
```

## Dependencies

This role requires an existing Neovim installation. It's designed to work with:
- Neovim installed from GitHub releases (recommended)
- Any user-local Neovim installation

## Example Playbooks

### Basic Usage

```yaml
- hosts: localhost
  roles:
    - tools/nvim-qt
```

### Custom Configuration

```yaml
- hosts: localhost
  roles:
    - role: tools/nvim-qt
      vars:
        nvim_qt_version: "v0.2.18"
        nvim_qt_nvim_path: "/usr/local/bin/nvim"
```

### With Neovim Installation

```yaml
- hosts: localhost
  roles:
    - tools/neovim  # Install Neovim first
    - tools/nvim-qt  # Then install Qt GUI
```

### Development Build

```yaml
- hosts: localhost
  roles:
    - role: tools/nvim-qt
      vars:
        nvim_qt_build_type: "Debug"
        nvim_qt_force_rebuild: true
```

## Usage After Installation

After running the role:

1. **GUI Launch**:
   - Search for "Neovim Qt" in your application menu
   - Or run: `nvim-qt` from command line

2. **Command Line Usage**:
   ```bash
   nvim-qt [file...]           # Open files
   nvim-qt --maximized        # Start maximized
   nvim-qt --fullscreen       # Start fullscreen
   ```

3. **Configuration**:
   - Uses your existing Neovim configuration
   - Set GUI font: `:set guifont=JetBrains\ Mono:h12`
   - Access preferences via Edit → Preferences

## Build Process

The role performs these steps:

1. **Dependency Check**: Verifies Neovim is available
2. **System Packages**: Automatically installs Qt development tools via apt
3. **Source Download**: Clones nvim-qt from GitHub
4. **Configure**: Runs cmake with proper Neovim path
5. **Build**: Compiles using all available CPU cores
6. **Install**: Installs system-wide to `/usr/local`
7. **Integration**: Creates desktop entry for all users

## File Locations

- **Binary**: `/usr/local/bin/nvim-qt`
- **Desktop Entry**: `/usr/share/applications/nvim-qt.desktop`
- **Build Cache**: `/tmp/nvim-qt-build/` (temporary)

## Tags

Available tags for selective execution:

- `nvim-qt`: All nvim-qt tasks
- `dependencies`: Dependency checks and installation
- `build`: Source build process
- `desktop`: Desktop integration
- `path`: PATH configuration
- `verify`: Installation verification

Example usage:
```bash
ansible-playbook playbook.yml --tags "nvim-qt,desktop"
```

## Troubleshooting

### Build Failures

If the build fails:

1. **Check dependencies**: Ensure all Qt packages are installed
2. **Clean rebuild**: Set `nvim_qt_force_rebuild: true`
3. **Check Neovim**: Verify your Neovim installation works
4. **Build logs**: Check the build directory for detailed logs

### Runtime Issues

If nvim-qt doesn't start:

1. **Verify Neovim**: `nvim --version` should work
2. **Check PATH**: Ensure `~/.local/bin` is in PATH
3. **Run from terminal**: `nvim-qt --help` for debug info
4. **Font issues**: Try `:set guifont=*` to open font selector

### Version Conflicts

If you have apt-installed neovim:

1. **Remove apt version**: `sudo apt remove neovim`
2. **Use GitHub Neovim**: Install from releases
3. **Update nvim_qt_nvim_path**: Point to correct binary

## Configuration Examples

### GUI Font Configuration

Add to your Neovim config:

```lua
-- For nvim-qt
if vim.g.GuiLoaded then
  vim.opt.guifont = "JetBrains Mono:h12"
  vim.g.GuiTabline = 0  -- Disable GUI tabline
  vim.g.GuiPopupmenu = 0  -- Disable GUI popup menu
end
```

### Custom Keybindings

```lua
-- nvim-qt specific keybindings
if vim.g.GuiLoaded then
  vim.keymap.set('n', '<C-+>', ':GuiFont! +1<CR>')
  vim.keymap.set('n', '<C-->', ':GuiFont! -1<CR>')
end
```

## License

MIT

## Author Information

System Administrator

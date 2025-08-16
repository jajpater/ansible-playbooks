# ScanTailor Role

This Ansible role installs ScanTailor as an AppImage for document scanning post-processing at the user level in an XDG-compliant manner.

## Requirements

- Internet connection for downloading the AppImage
- `~/.local/bin` in PATH for easy command-line access (optional)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# ScanTailor AppImage download URL
scantailor_appimage_url: "https://github.com/probonopd/scantailor/releases/download/continuous/ScanTailor-d3f8580-x86_64.AppImage"

# AppImage filename
scantailor_appimage_name: "ScanTailor-d3f8580-x86_64.AppImage"

# Symlink name for easy access
scantailor_binary_name: "scantailor"

# XDG compliant installation paths
scantailor_install_dir: "{{ ansible_env.HOME }}/.local/bin"
scantailor_desktop_dir: "{{ ansible_env.HOME }}/.local/share/applications"
scantailor_icon_dir: "{{ ansible_env.HOME }}/.local/share/icons"

# Desktop integration options
scantailor_create_desktop_entry: true
scantailor_create_symlink: true
```

## Usage

Include this role in your playbook:

```yaml
- role: tools/scantailor
  tags: [scantailor, scanner, documents]
```

## What This Role Does

1. Creates XDG-compliant directories (`~/.local/bin`, `~/.local/share/applications`, etc.)
2. Downloads the ScanTailor AppImage to `~/.local/bin`
3. Creates a symlink for easy command-line access
4. Extracts icon and creates a desktop entry for GUI integration
5. Updates the desktop database

## Post-Installation

After installation you can use ScanTailor:

- **Command line**: `scantailor` (if `~/.local/bin` is in PATH)
- **Direct path**: `~/.local/bin/scantailor`  
- **Desktop**: Look for "ScanTailor" in your application menu

## Comparison with Build-from-Source

**Advantages of AppImage approach:**
- No compilation time (instant installation)
- No build dependencies required
- XDG-compliant user-level installation
- Easy to remove (just delete the AppImage)
- Consistent across different systems

**Advantages of build-from-source:**
- Latest features and bug fixes
- Can choose specific variants (advanced/experimental/deviant)
- Better integration with system libraries
- Smaller disk footprint

## Tags

- `scantailor`
- `scanner`
- `documents`

## Dependencies

None.
# Calibre Role

An Ansible role to install and manage [Calibre](https://calibre-ebook.com/) e-book management software using the official binary installer.

## Description

This role installs Calibre using the official binary installer from https://calibre-ebook.com/download_linux. It provides options for both system-wide and isolated user installations, follows the recommended installation method, and includes proper prerequisite handling.

## Features

- **Official Installation Method**: Uses the recommended binary installer from Calibre's official website
- **Multiple Installation Modes**: Support for system-wide or isolated user installations  
- **Version Management**: Install latest version or specify a particular version
- **Update Control**: Configurable update behavior (auto, always, never, force)
- **Prerequisite Handling**: Automatically installs required packages
- **Verification**: Post-installation verification with detailed status reporting
- **Certificate Handling**: Option to skip certificate validation if needed

## Requirements

### System Requirements
- GLIBC 2.34 or higher
- libstdc++.so.6.0.30 (from gcc 11.4.0) or higher
- X11 or Wayland display server (for GUI usage)

### Ansible Requirements
- Ansible 2.9 or higher
- Target system with internet connectivity

## Role Variables

### Version and Update Control
```yaml
calibre_version: "latest"              # Version to install ("latest" or specific version like "7.20.0")
calibre_update_mode: "auto"            # Update behavior: auto, always, never, force
```

### Installation Paths
```yaml
calibre_install_dir: "/opt"                              # System installation directory
calibre_isolated_install: false                         # Enable isolated installation mode
calibre_isolated_install_dir: "{{ ansible_env.HOME }}/calibre-bin"  # Isolated install path
```

### Download and Installation
```yaml
calibre_download_timeout: 600          # Download timeout in seconds
calibre_installer_url: "https://download.calibre-ebook.com/linux-installer.sh"
calibre_no_check_certificate: false    # Skip SSL certificate validation
```

### Prerequisites and Verification
```yaml
calibre_prerequisites:                 # Required packages
  - xdg-utils
  - wget
  - xz-utils
  - python3

calibre_verify_installation: true      # Verify installation after completion
```

## Installation Modes

### System Installation (Default)
Installs Calibre system-wide to `/opt/calibre` (or specified directory):
```yaml
calibre_isolated_install: false
calibre_install_dir: "/opt"
```

### Isolated Installation
Installs Calibre to user directory without requiring root privileges:
```yaml
calibre_isolated_install: true
calibre_isolated_install_dir: "{{ ansible_env.HOME }}/calibre-bin"
```

## Example Playbooks

### Basic Installation
```yaml
---
- hosts: all
  roles:
    - role: tools/calibre
```

### Install Specific Version (System)
```yaml
---
- hosts: all
  roles:
    - role: tools/calibre
      vars:
        calibre_version: "7.20.0"
        calibre_update_mode: "force"
```

### Isolated Installation
```yaml
---
- hosts: all
  roles:
    - role: tools/calibre
      vars:
        calibre_isolated_install: true
        calibre_isolated_install_dir: "~/Applications/calibre"
```

### Custom Installation Directory
```yaml
---
- hosts: all
  roles:
    - role: tools/calibre
      vars:
        calibre_install_dir: "/usr/local"
```

### Handle Certificate Issues
```yaml
---
- hosts: all
  roles:
    - role: tools/calibre
      vars:
        calibre_no_check_certificate: true
```

## Update Modes

- `auto`: Update only if version differs from target (default)
- `always`: Always run installation/update process
- `never`: Skip installation if already present
- `force`: Force reinstallation regardless of current state

## Post-Installation Usage

### System Installation
After system installation, Calibre binaries are located at:
- Main application: `{{ calibre_install_dir }}/calibre/calibre`
- Command-line tools: `{{ calibre_install_dir }}/calibre/`

The installer typically creates symlinks in `/usr/bin`, but if not available in PATH:
```bash
sudo ln -s /opt/calibre/calibre /usr/local/bin/calibre
sudo ln -s /opt/calibre/ebook-convert /usr/local/bin/ebook-convert
```

### Isolated Installation
For isolated installations:
```bash
# Run Calibre
~/calibre-bin/calibre

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$HOME/calibre-bin:$PATH"
```

## Common Commands

- `calibre` - Launch the main GUI application
- `ebook-convert` - Convert between e-book formats
- `calibredb` - Command-line library management
- `ebook-viewer` - Standalone e-book viewer

## Troubleshooting

### Wayland Issues
If running on Wayland and calibre fails to start:
```bash
QT_QPA_PLATFORM=xcb calibre
```

### Missing Libraries
If you encounter missing library errors, ensure your system has:
- X11-XCB libraries (libxcb-cursor0, libxcb-xinerama0)
- OpenGL packages (libegl1, libopengl0) for headless servers

### Uninstallation
To uninstall Calibre:
```bash
# System installation
sudo calibre-uninstall

# Or manually remove directory
sudo rm -rf /opt/calibre

# Isolated installation
rm -rf ~/calibre-bin
```

## Dependencies

This role has no dependencies on other Ansible roles.

## License

MIT

## Author Information

Created by System Administrator for automated Calibre e-book management software deployment.

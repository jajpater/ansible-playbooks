# Ansible Role: tools/rbw

This role installs and configures [rbw](https://github.com/doy/rbw) (unofficial Bitwarden CLI) and [rofi-rbw](https://github.com/fdw/rofi-rbw) (Rofi frontend for Bitwarden) on Ubuntu/Debian systems in a user-level, XDG-compliant manner.

## Features

- **User-level installation**: Installs both tools in user space following XDG Base Directory specification
- **Rust integration**: Leverages existing Rust/Cargo installation (works with `tools/rust` role)
- **Dependency management**: Checks for required system packages and provides helpful error messages
- **Update management**: Supports various update strategies (auto, always, never, force)
- **Configuration templating**: Optional configuration file generation for both tools
- **Verification**: Comprehensive installation verification and status reporting
- **Idempotent**: Safe to run multiple times, only performs necessary updates

## Requirements

### System Dependencies
The following packages should be installed (role will check and warn if missing):
- `pinentry-curses` or `pinentry-gnome3` (required for rbw password prompts)
- `rofi` (required for rofi-rbw frontend)
- `pipx` (for installing rofi-rbw in isolated environment)
- `build-essential`, `curl` (for cargo compilation)

### Rust Installation
- Rust/Cargo must be available (recommended: use `tools/rust` role first)
- Role expects Cargo at `~/.local/share/cargo/bin/cargo` (XDG-compliant)

## Role Variables

### XDG Paths
```yaml
rbw_xdg_data_home: "{{ ansible_env.HOME }}/.local/share"
rbw_xdg_config_home: "{{ ansible_env.HOME }}/.config"
rbw_xdg_bin_home: "{{ ansible_env.HOME }}/.local/bin"
```

### Installation Control
```yaml
rbw_update_mode: "auto"          # auto, always, never, force
rbw_auto_update: true            # Enable automatic updates when mode is 'auto'
rofi_rbw_update_mode: "auto"     # auto, always, never, force  
rofi_rbw_auto_update: true       # Enable automatic updates when mode is 'auto'
rbw_verify_installation: true    # Run verification after installation
rbw_require_pinentry: true       # Fail if no pinentry found
```

### Configuration Management
```yaml
rbw_create_initial_config: false      # Create initial rbw config file
rofi_rbw_create_config: false         # Create initial rofi-rbw config file
```

### rbw Configuration (when `rbw_create_initial_config: true`)
```yaml
rbw_config:
  email: "your-email@example.com"     # Your Bitwarden email
  base_url: "https://api.bitwarden.com/"
  identity_url: "https://identity.bitwarden.com/"
  ui_url: "https://vault.bitwarden.com/"
  notifications_url: "https://notifications.bitwarden.com/"
  lock_timeout: 3600                   # Lock timeout in seconds
  sync_interval: 3600                  # Auto-sync interval in seconds
  pinentry: "pinentry"                 # Pinentry command
```

### rofi-rbw Configuration (when `rofi_rbw_create_config: true`)
```yaml
rofi_rbw_config:
  action: "type"                       # type, copy, print
  target: "password"                   # password, username, totp
  prompt: "rbw"                        # Rofi prompt text
  rofi_args: ""                        # Additional rofi arguments
  clear_after: 10                      # Clear clipboard after N seconds
  no_symbols: false                    # Disable symbol characters
  keybindings:                         # Custom keybindings
    type_all: "kb-custom-1"
    type_user: "kb-custom-2"
    type_pass: "kb-custom-3"
    copy_all: "kb-custom-4"
    copy_user: "kb-custom-5"
    copy_pass: "kb-custom-6"
```

## Usage

### Basic Usage
```yaml
# In your user.yml playbook
- hosts: localhost
  roles:
    - tools/rust      # Install Rust first (recommended)
    - tools/rbw       # Install rbw and rofi-rbw
```

### With Configuration
```yaml
- hosts: localhost
  roles:
    - tools/rust
    - role: tools/rbw
      vars:
        rbw_create_initial_config: true
        rbw_config:
          email: "your-email@example.com"
        rofi_rbw_create_config: true
        rofi_rbw_config:
          action: "copy"
          clear_after: 5
```

### Force Updates
```yaml
- hosts: localhost
  roles:
    - role: tools/rbw
      vars:
        rbw_update_mode: "force"
        rofi_rbw_update_mode: "force"
```

## Post-Installation Setup

After successful installation, you'll need to configure rbw with your Bitwarden account:

```bash
# Configure your email
rbw config set email your-email@example.com

# Login to Bitwarden
rbw login

# Sync your vault
rbw sync

# Test rbw
rbw list

# Test rofi-rbw (requires rofi to be running)
rofi-rbw
```

## Directory Structure

The role follows XDG Base Directory specification:

```
~/.local/share/cargo/bin/rbw          # rbw binary
~/.local/bin/rofi-rbw                 # rofi-rbw script
~/.config/rbw/config.json             # rbw configuration
~/.config/rofi-rbw/rc                 # rofi-rbw configuration
```

## Update Modes

- **`auto`**: Update only when `*_auto_update` is true (default behavior)
- **`always`**: Always attempt to update on every run
- **`never`**: Never update, only install if not present
- **`force`**: Force reinstallation even if already installed

## Tags

The role supports the following tags for selective execution:
- `rbw` - All rbw-related tasks
- `rofi-rbw` - All rofi-rbw-related tasks
- `dependencies` - Dependency checking tasks
- `install` - Installation tasks
- `config` - Configuration tasks
- `verify` - Verification tasks

### Examples
```bash
# Install only rbw
ansible-playbook user.yml --tags "rbw"

# Only check dependencies
ansible-playbook user.yml --tags "dependencies"

# Install and verify
ansible-playbook user.yml --tags "install,verify"
```

## Integration with Window Managers

### i3/sway
Add to your config:
```
bindsym $mod+p exec rofi-rbw
```

### GNOME/KDE
Set a custom keyboard shortcut to execute `rofi-rbw`

## Troubleshooting

### Common Issues

**1. "No pinentry program found"**
```bash
sudo apt install pinentry-curses pinentry-gnome3
```

**2. "Cargo not found"**
Run the `tools/rust` role first to install Rust properly.

**3. "rofi not found"**
```bash
sudo apt install rofi
```

**4. "Permission denied" errors**
Ensure you're running the user playbook as a regular user, not with `become: true`.

### Manual Verification
```bash
# Check installations
rbw --version
pipx list | grep rofi-rbw
rofi-rbw --help

# Check paths
echo $PATH | grep -E "(cargo|\.local)"
ls -la ~/.local/share/cargo/bin/rbw
ls -la ~/.local/bin/rofi-rbw
```

## Dependencies

- Python 3.9+
- Rust/Cargo (install via `tools/rust` role)
- System packages: pinentry, rofi, pipx, build-essential, curl

## Compatibility

- Ubuntu 20.04 (Focal) and newer  
- Debian 11 (Bullseye) and newer
- Ansible 2.9+

## Security Considerations

- rbw stores encrypted vault data locally
- Configuration files contain server URLs but no credentials
- pinentry handles password input securely
- Both tools run in user space without elevated privileges

## License

MIT License

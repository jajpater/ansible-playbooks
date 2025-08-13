# Deskflow System Role

This role installs Deskflow, a modern desktop launcher and productivity tool, by downloading and installing packages from GitHub releases. Supports both deb package and Flatpak installation methods.

## Description

Deskflow is a streamlined, open-source desktop launcher that provides quick access to applications, files, bookmarks, notes, shell commands, and clipboard history. It offers a minimal and efficient interface designed for power users.

## Requirements

- Ubuntu/Debian system
- Internet connection to download packages
- sudo privileges for package installation

## Role Variables

Available variables are listed below, along with default values:

```yaml
# Deskflow version to install ('latest' or specific version like '1.23.0')
deskflow_version: latest

# Package state (present, latest, absent)
deskflow_package_state: present

# Installation method ('deb' or 'flatpak')
deskflow_install_method: deb

# Update package cache before installation  
deskflow_update_cache: yes

# Flatpak-specific settings
deskflow_flatpak_remote: flathub
deskflow_flatpak_app_id: org.deskflow.Deskflow
```

## Dependencies

None.

## Example Playbook

### Basic Installation

```yaml
- hosts: all
  become: yes
  roles:
    - role: sys/deskflow
```

### Install Specific Version

```yaml
- hosts: all
  become: yes
  roles:
    - role: sys/deskflow
      vars:
        deskflow_version: "1.23.0"
```

### Install Latest Version

```yaml
- hosts: all
  become: yes
  roles:
    - role: sys/deskflow
      vars:
        deskflow_version: latest
        deskflow_package_state: present
```

### Install via Flatpak

```yaml
- hosts: all
  become: yes
  roles:
    - role: sys/deskflow
      vars:
        deskflow_install_method: flatpak
```

### Remove Deskflow

```yaml
- hosts: all
  become: yes
  roles:
    - role: sys/deskflow
      vars:
        deskflow_package_state: absent
```

## Usage

After installation, you can:

1. Launch Deskflow from your application menu
2. Use the command line: `deskflow`
3. Set up keyboard shortcuts to launch Deskflow quickly

## Architecture Support

The role automatically detects your system architecture and downloads the appropriate package:
- x86_64 (amd64) systems
- aarch64 (arm64) systems

## Ubuntu Version Compatibility

The role automatically selects the appropriate package based on your Ubuntu version:
- Ubuntu 25.04+ (Plucky): Uses Ubuntu-specific packages
- Earlier versions: Uses Debian Trixie packages (compatible)

## Handlers

The role includes handlers that:
- Verify the installation by checking the version
- Display installation status
- Optionally check systemd service status (if applicable)

## Troubleshooting

### Installation Issues

If the installation fails:

1. Check internet connectivity
2. Verify the version exists on GitHub releases
3. Ensure sufficient disk space
4. Check system logs: `sudo journalctl -xe`

### Version Not Found

If a specific version isn't found:
- Check available versions at: https://github.com/deskflow/deskflow/releases
- Use `latest` to get the most recent version
- Verify the version format (without 'v' prefix)

### Architecture Issues

If you get architecture-related errors:
- The role supports x86_64 and aarch64
- Check your architecture with: `dpkg --print-architecture`
- Verify packages exist for your architecture

### Dependency Issues

If you encounter dependency conflicts (like `libportal1 >= 0.8.0`):
- Try using the Flatpak installation method instead:
  ```yaml
  deskflow_install_method: flatpak
  ```
- Flatpak packages are self-contained and avoid system dependency conflicts
- For deb packages, ensure your Ubuntu version matches the package requirements

## Testing

To test the role:

```bash
# Test installation
ansible-playbook -i inventory root.yml --tags deskflow --check

# Run installation
ansible-playbook -i inventory root.yml --tags deskflow

# Test removal
ansible-playbook -i inventory root.yml --tags deskflow -e "deskflow_package_state=absent"
```

## License

This role is part of the ansible-playbooks project and follows the same licensing.

## Author Information

Created as part of the system roles collection for automated software installation and management.

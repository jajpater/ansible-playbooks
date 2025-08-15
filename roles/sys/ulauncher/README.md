# Ulauncher Role

This Ansible role installs Ulauncher, an application launcher for Linux with fuzzy search capabilities.

## Description

Ulauncher is a fast application launcher that provides:
- Fuzzy search for applications
- Customizable shortcuts and extensions  
- Custom color themes
- Fast directory browsing
- Web search integration

## Requirements

- Ubuntu/Debian-based system
- Root privileges (role should be run with `become: true`)

## Role Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `ulauncher_package_state` | `present` | Desired state of the ulauncher package (`present`, `absent`, `latest`) |
| `ulauncher_ensure_latest` | `false` | Whether to ensure the latest version is always installed |

## Dependencies

None.

## Example Playbook

```yaml
- name: Install Ulauncher
  hosts: localhost
  become: true
  roles:
    - role: sys/ulauncher
      ulauncher_package_state: present
      ulauncher_ensure_latest: false
```

## Installation Method

This role installs Ulauncher using the official Ubuntu PPA:
- Adds the `ppa:agornostal/ulauncher` repository
- Installs the `ulauncher` package via apt

## Usage

After installation, Ulauncher can be started from the applications menu or by running:
```bash
ulauncher
```

To set up Ulauncher to start automatically, you can add it to your desktop environment's startup applications.

## License

Same as the parent playbook.

## Author Information

Created as part of the ansible-playbooks system setup collection.

# Warp Terminal Role

This Ansible role installs and maintains Warp terminal on Debian/Ubuntu systems.

## Requirements

- Ubuntu/Debian-based system with apt package manager
- Root privileges (role should be run with `become: true`)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Default state for the Warp package (present, latest, absent)
warp_package_state: present

# Set to true to always ensure the latest version is installed
warp_ensure_latest: false

# Warp terminal repository configuration
warp_repo_url: "https://releases.warp.dev/linux/deb"
warp_gpg_key_url: "https://releases.warp.dev/linux/keys/warp.asc"
```

## Usage

### Basic Installation

Add the role to your playbook:

```yaml
- role: sys/warp
  tags: [warp]
```

### Always Keep Updated

To ensure Warp is always updated to the latest version:

```yaml
- role: sys/warp
  vars:
    warp_ensure_latest: true
  tags: [warp]
```

### Install Latest Version Initially

```yaml
- role: sys/warp
  vars:
    warp_package_state: latest
  tags: [warp]
```

### Remove Warp

```yaml
- role: sys/warp
  vars:
    warp_package_state: absent
  tags: [warp]
```

## What This Role Does

1. Creates the necessary keyring directory (`/etc/apt/keyrings`)
2. Downloads the Warp GPG signing key
3. Converts the key to binary format for apt
4. Adds the Warp apt repository
5. Updates the apt cache
6. Installs or updates the `warp-terminal` package
7. Verifies the installation by checking the version

## Tags

- `warp` - Run all warp-related tasks

## Example Playbook

```yaml
- name: Install Warp Terminal
  hosts: localhost
  connection: local
  gather_facts: true
  become: true

  roles:
    - role: sys/warp
      tags: [warp]
```

## License

Same as the parent playbook repository.

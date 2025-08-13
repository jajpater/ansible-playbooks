# Brave Browser Role

This Ansible role installs and maintains Brave browser on Debian/Ubuntu systems.

## Requirements

- Ubuntu/Debian-based system with apt package manager
- Root privileges (role should be run with `become: true`)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Default state for the Brave package (present, latest, absent)
brave_package_state: present

# Set to true to always ensure the latest version is installed
brave_ensure_latest: false

# Brave browser repository configuration
brave_repo_url: "https://brave-browser-apt-release.s3.brave.com/"
brave_gpg_key_url: "https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg"
```

## Usage

### Basic Installation

Add the role to your playbook:

```yaml
- role: sys/brave
  tags: [brave]
```

### Always Keep Updated

To ensure Brave is always updated to the latest version:

```yaml
- role: sys/brave
  vars:
    brave_ensure_latest: true
  tags: [brave]
```

### Install Latest Version Initially

```yaml
- role: sys/brave
  vars:
    brave_package_state: latest
  tags: [brave]
```

### Remove Brave

```yaml
- role: sys/brave
  vars:
    brave_package_state: absent
  tags: [brave]
```

## What This Role Does

1. Installs curl (required for downloading the GPG key)
2. Creates the necessary keyring directory (`/etc/apt/keyrings`)
3. Downloads the Brave GPG signing key
4. Adds the Brave apt repository
5. Updates the apt cache
6. Installs or updates the `brave-browser` package
7. Verifies the installation by checking the version

## Tags

- `brave` - Run all brave-related tasks

## Example Playbook

```yaml
- name: Install Brave Browser
  hosts: localhost
  connection: local
  gather_facts: true
  become: true

  roles:
    - role: sys/brave
      tags: [brave]
```

## License

Same as the parent playbook repository.

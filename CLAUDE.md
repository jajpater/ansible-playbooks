# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is an Ansible automation repository for setting up Ubuntu/Linux systems with development tools and applications. The playbooks are split into two main execution contexts:

- **`root.yml`** - System-wide installations requiring sudo (browsers, system packages, APT repositories)
- **`user.yml`** - User-level tools installed to `$HOME/.local` (CLI tools, fonts, dotfiles)

## Core Commands

### Basic Execution
```bash
# Navigate to the repository root
cd ~/System/ansible-playbooks

# Check what would be changed (dry run)
ansible-playbook user.yml --check
ansible-playbook root.yml -K --check

# Execute playbooks
ansible-playbook user.yml
ansible-playbook root.yml -K
```

### Tag-based Execution
```bash
# List available tags
ansible-playbook user.yml --list-tags
ansible-playbook root.yml --list-tags

# Install specific tools
ansible-playbook user.yml --tags fzf,zoxide
ansible-playbook root.yml -K --tags chrome,vscode
```

### Development Commands
```bash
# Syntax validation
ansible-playbook user.yml --syntax-check
ansible-playbook root.yml --syntax-check

# Verbose output for debugging
ansible-playbook user.yml -vv

# Test specific roles
ansible-playbook test-scantailor-advanced.yml
```

## Architecture & Structure

### Configuration Files
- **`ansible.cfg`** - Optimized for localhost execution with YAML callbacks and performance settings
- **`inventory`** - Simple localhost configuration (`ansible_connection=local`)
- **`group_vars/all.yml`** - Global variables including GitHub token lookup and ScanTailor options

### Role Organization
- **`base/`** - Fundamental system setup (apt packages)
- **`sys/`** - System applications requiring root (browsers, desktop environments)
- **`tools/`** - Development tools and CLI utilities (user-installable)
- **`infra/`** - Infrastructure components (shell aliases, systemd timers)
- **`helpers/`** - Reusable role components

### Installation Patterns

**GitHub Release Pattern** (via `helpers/github_install`):
- Automatically fetches latest releases from GitHub
- Installs to `~/.local/opt/<tool>/<version>`
- Creates symlinks in `~/.local/bin`
- Handles both archives and single binaries
- Includes version pruning

**Compilation Pattern** (e.g., grb):
- Clones source to `~/.local/src`
- Builds using make/cmake
- Installs to `~/.local/bin`

**APT/Package Manager Pattern**:
- System packages via apt
- PPAs for non-standard repositories
- Snap packages where appropriate

### Key Variables
- **`github_token`** - Configured via environment variable or `~/.config/ansible/env` file to avoid rate limiting
- **`scantailor_*`** - Controls ScanTailor installation variants and shell aliases
- **`user_home`** - Resolves to `{{ ansible_env.HOME }}`
- **`user_bin`** - Points to `{{ ansible_env.HOME }}/.local/bin`

## Development Guidelines

### Adding New Tools
1. Create role under appropriate category (`tools/`, `sys/`, etc.)
2. Use consistent naming: role directory = tool name
3. Add meaningful tags for selective execution
4. Prefer `helpers/github_install` for GitHub-hosted tools
5. Install user tools to `~/.local/bin` or `~/.local/opt`
6. Include verification tasks when possible

### Role Structure Standards
```
roles/category/toolname/
├── tasks/main.yml      # Primary installation logic
├── vars/main.yml       # Tool-specific variables (optional)
├── defaults/main.yml   # Default configuration (optional)
├── templates/          # Configuration templates (optional)
└── README.md          # Tool documentation (optional)
```

### Idempotency Requirements
- Use `creates:` parameter for command/shell tasks
- Implement proper state checking before downloads
- Use `update: false` for git clones unless updates needed
- Include `changed_when: false` for verification tasks

### Testing Approach
- Individual test playbooks for complex roles (e.g., `test-scantailor-advanced.yml`)
- Always run `--check` before real execution
- Use `--syntax-check` for validation
- Test both installation and reinstallation scenarios

## Environment Setup

### Prerequisites
```bash
sudo apt install ansible
ansible-galaxy collection install -r collections/requirements.yml  # if needed
```

### PATH Configuration
Ensure `~/.local/bin` is in PATH by adding to shell configuration:
```bash
export PATH="$HOME/.local/bin:$PATH"
```

### GitHub Token Setup
To avoid API rate limiting:
```bash
mkdir -p ~/.config/ansible
echo "GITHUB_TOKEN=your_token_here" > ~/.config/ansible/env
```

## Common Patterns

### Conditional Installation
```yaml
- role: tools/scantailor-advanced
  when: scantailor_install_compiled
```

### GitHub Installation Example
```yaml
- name: Install tool via GitHub
  include_role:
    name: helpers/github_install
  vars:
    name: "toolname"
    repo: "author/repo"
    asset_regex: "linux.*amd64.*tar.gz$"
    bin_relpath: "bin/toolname"
```

### XDG Directory Setup
```yaml
- name: Ensure XDG directories
  file:
    path: "{{ item }}"
    state: directory
    mode: "0755"
  loop:
    - "{{ user_bin }}"
    - "{{ user_home }}/.local/share"
    - "{{ user_home }}/.config"
```

## Troubleshooting

### APT Lock Issues
APT operations may fail if GUI package managers are running. Close Software Updater or wait for automatic updates to complete.

### Rate Limiting
GitHub API rate limits can cause failures. Configure GitHub token as described above.

### Missing Commands
If installed tools aren't found, verify `~/.local/bin` is in PATH and restart shell.

### Permission Issues
System roles require `-K` flag for sudo password. User roles should never need sudo.
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

### Tool Installation Methods
This repository supports multiple installation strategies:

**Method 1: Hybrid (Default)**
```bash
# Intelligently selects Guix vs individual roles per tool
ansible-playbook user.yml --tags guix-tools,rust,rbw
```

**Method 2: Pure Guix**
```bash
# Uses Guix for all supported tools
# Set tool_installation_method: 'guix' in group_vars/all.yml
ansible-playbook user.yml --tags guix-tools
```

**Method 3: Individual Roles**  
```bash
# Uses traditional individual roles for each tool
# Set tool_installation_method: 'individual' in group_vars/all.yml
ansible-playbook user.yml --tags fzf,zoxide,rust,greenclip,rbw
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

### Playbook Architecture
- **`user.yml`** - User-space installations with conditional tool routing
- **`root.yml`** - System-wide installations requiring sudo privileges
- **`test-*.yml`** - Individual role testing playbooks
- **Conditional Execution** - Roles include `when:` conditions for hybrid mode:
  ```yaml
  when: >
    tool_installation_method == 'individual' or
    (tool_installation_method == 'hybrid' and 
     tool_installation_config.TOOL.method == 'individual')
  ```

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
- **`tool_installation_method`** - Choose 'guix', 'individual', or 'hybrid' (default: 'hybrid')
- **`tool_installation_config`** - Per-tool method selection in hybrid mode
- **`guix_installation_method`** - Choose 'system' (APT), 'user' (latest), or 'hybrid' (default)
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

### GitHub Installation Helper
The `helpers/github_install` role provides standardized GitHub release installation:

```yaml
- name: Install tool via GitHub
  include_role:
    name: helpers/github_install
  vars:
    name: "toolname"                    # Binary name in ~/.local/bin
    repo: "author/repo"                 # GitHub repository
    asset_regex: "linux.*amd64.*tar.gz$"  # Asset selection regex
    bin_relpath: "bin/toolname"         # Path within archive to binary
    # Optional parameters:
    install_dir: "custom/path"          # Override default ~/.local/opt/<name>
    skip_symlink: false                 # Skip creating ~/.local/bin symlink
    extra_unarchive_opts: ["--strip-components=1"]  # Additional tar options
```

**Key Features:**
- Automatic version detection and latest release fetching
- GitHub token support to avoid rate limiting
- Automatic version pruning (keeps only current version)  
- Handles both archives and single binaries
- Creates versioned installations in `~/.local/opt/<tool>/<version>`

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

## Tool Installation Architecture

### Hybrid Installation Strategy
The repository uses a sophisticated hybrid approach for tool installation that can be configured via `tool_installation_method` in `group_vars/all.yml`:

- **`guix`** - All tools via GNU Guix package manager
- **`individual`** - All tools via dedicated Ansible roles  
- **`hybrid`** (default) - Per-tool selection based on complexity and configuration needs

### Per-Tool Configuration (Hybrid Mode)
Tools with complex configurations use individual roles, while simple binaries use Guix:

```yaml
tool_installation_config:
  # Complex tools → individual roles
  zoxide: { method: "individual", reason: "Shell integration and profile management" }
  rust: { method: "individual", reason: "XDG compliance, cargo config" }
  rbw: { method: "individual", reason: "Bitwarden config, rofi integration" }
  
  # Simple tools → Guix
  fzf: { method: "guix", reason: "Simple binary, no config needed" }
  mu: { method: "guix", reason: "Avoid compilation issues" }
```

### Guix Integration Benefits
- **Rollback capability** - `guix package --roll-back`
- **Reproducible environments** - Functional package management
- **No compilation** - Pre-built binaries for complex tools like `mu`
- **Version isolation** - Multiple versions can coexist

## Troubleshooting

### APT Lock Issues
APT operations may fail if GUI package managers are running. Close Software Updater or wait for automatic updates to complete.

### Rate Limiting
GitHub API rate limits can cause failures. Configure GitHub token as described above.

### Missing Commands
If installed tools aren't found, verify `~/.local/bin` is in PATH and restart shell.

### Permission Issues
System roles require `-K` flag for sudo password. User roles should never need sudo.

## Testing & Debugging

### Individual Role Testing
```bash
# Test specific roles in isolation
ansible-playbook test-scantailor-advanced.yml
ansible-playbook test-claude-code.yml

# Test with increased verbosity
ansible-playbook user.yml --tags fzf -vv
```

### Tag Discovery
```bash
# List all available tags
ansible-playbook user.yml --list-tags
ansible-playbook root.yml --list-tags

# Find tags in codebase
grep -r "tags:" roles/ --include="*.yml" | grep -v "# tags"
```

### Configuration Validation
```bash
# Validate playbook syntax
ansible-playbook user.yml --syntax-check
ansible-playbook root.yml --syntax-check

# Check variables and facts
ansible localhost -m setup | grep ansible_env
```
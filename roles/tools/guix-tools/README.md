# Guix Tools Role

This role installs multiple development and CLI tools via the Guix package manager, replacing several individual Ansible roles with a centralized Guix-based installation approach.

## Requirements

- Guix package manager must be installed (use the `tools/guix` role first)
- User-level installation (no sudo required)
- XDG Base Directory Specification compliance

## Replaced Roles

This role replaces the following individual Ansible roles:

| Tool | Old Role | Description | Tags |
|------|----------|-------------|------|
| fzf | `tools/fzf` | Command-line fuzzy finder | `fzf`, `fuzzy-finder`, `search` |
| zoxide | `tools/zoxide` | Smarter cd command with frecency | `zoxide`, `cd`, `navigation` |
| rust | `tools/rust` | Rust programming language & toolchain | `rust`, `programming`, `cargo` |
| greenclip | `tools/greenclip` | Simple clipboard manager for X11 | `greenclip`, `clipboard`, `x11` |
| rbw | `tools/rbw` | Unofficial Bitwarden CLI client | `rbw`, `bitwarden`, `password-manager` |

## Tools Installed

### Development Tools
- **fzf**: Command-line fuzzy finder for files, command history, processes, etc.
- **ripgrep**: Fast line-oriented search tool (grep alternative)
- **rust**: Complete Rust toolchain including rustc, cargo, and standard library

### System Utilities
- **zoxide**: Smart cd replacement that learns your habits and jumps to frequently used directories
- **greenclip**: Lightweight clipboard manager for X11 sessions
- **rbw**: Command-line client for Bitwarden password manager

## Variables

### Default Configuration

```yaml
# Guix profile location
guix_tools_profile: "{{ ansible_env.HOME }}/.guix-profile"

# Whether to install development packages
guix_tools_install_dev: false

# Whether to verify installations
guix_tools_verify: true
```

### Optional Development Packages

```yaml
# Additional development packages (when guix_tools_install_dev: true)
guix_tools_dev_packages:
  - "git"
  - "emacs"
  - "make"
  - "gcc-toolchain"
```

## Usage

### Basic Installation

```bash
# Install Guix first, then the tools
ansible-playbook -i inventory user.yml --tags guix,guix-tools

# Install only the tools (if Guix is already installed)
ansible-playbook -i inventory user.yml --tags guix-tools
```

### With Development Packages

```yaml
# In your playbook or group_vars:
guix_tools_install_dev: true
```

Then run:
```bash
ansible-playbook -i inventory user.yml --tags guix-tools
```

## Verification

The role automatically verifies installations by running version commands for each tool. Results are displayed in the Ansible output.

## Dependencies

1. **tools/guix**: Must be run first to install the Guix package manager
2. **tools/guile**: Required by Guix for some advanced features (optional)

## Reverting to Individual Roles

If you prefer to use the original individual roles instead:

1. Comment out the `tools/guix-tools` role in `user.yml`
2. Uncomment the individual roles:
   ```yaml
   # Uncomment to use individual roles:
   - role: tools/fzf
     tags: [fzf]
   - role: tools/zoxide  
     tags: [zoxide]
   - role: tools/rust
     tags: [rust]
   - role: tools/greenclip
     tags: [greenclip]  
   - role: tools/rbw
     tags: [rbw, bitwarden, password-manager]
   ```

## Benefits of Guix Installation

- **No sudo required**: All tools install to user profile
- **Atomic transactions**: Install/remove operations are atomic
- **Rollback capability**: Can rollback to previous generations
- **Reproducible**: Exact same versions across systems
- **Isolated**: No conflicts with system packages
- **Functional**: Multiple versions can coexist

## Troubleshooting

### Guix Not Found
Error: `Guix is not installed`
Solution: Run the guix role first: `ansible-playbook -i inventory user.yml --tags guix`

### Tool Not Found After Installation
Issue: Installed tools not found in PATH
Solution: Source Guix profile or restart shell:
```bash
source ~/.guix-profile/etc/profile
```

### Installation Fails
Issue: Guix package installation fails
Solution: Update Guix channels:
```bash
export GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
guix pull
```
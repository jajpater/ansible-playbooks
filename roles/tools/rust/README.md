# Rust Development Environment Role

This Ansible role installs and maintains Rust in an XDG Base Directory Specification compliant way on Debian/Ubuntu systems.

## Features

- **XDG Base Directory Compliant**: Uses proper XDG paths instead of cluttering home directory
- **Migration Support**: Automatically migrates existing `~/.cargo` and `~/.rustup` installations
- **Shell Integration**: Updates shell profiles with proper environment variables
- **Component Management**: Installs additional Rust components (rustfmt, clippy, etc.)
- **Configuration Management**: Provides optimized cargo configuration
- **Update Support**: Can update existing Rust installations

## XDG Directory Structure

Instead of the default locations, this role uses:
- `~/.local/share/cargo` (instead of `~/.cargo`)
- `~/.local/share/rustup` (instead of `~/.rustup`) 
- `~/.config/cargo/config.toml` (for cargo configuration)
- `~/.local/bin/` (for binaries - already in most PATHs)

## Requirements

- Ubuntu/Debian-based system with apt package manager
- User privileges (role should NOT be run with `become: true` for user installation)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# XDG Base Directory Specification compliant paths
rust_cargo_home: "{{ ansible_env.HOME }}/.local/share/cargo"
rust_rustup_home: "{{ ansible_env.HOME }}/.local/share/rustup"

# Default Rust toolchain to install
rust_default_toolchain: "stable"

# Whether to update shell profiles with environment variables
rust_update_shell_profiles: true

# Shell profile files to update
rust_shell_profiles:
  - "{{ ansible_env.HOME }}/.bashrc"
  - "{{ ansible_env.HOME }}/.zshrc"

# Whether to update Rust toolchain during role execution
rust_update_toolchain: false

# Additional Rust components to install
rust_components:
  - "rustfmt"
  - "clippy" 
  - "rust-src"

# Optional cargo packages to install
rust_cargo_packages: []
  # Examples:
  # - "bp"              # Better paste - clipboard tool
  # - "fd-find"         # Modern 'find' replacement
  # - "ripgrep"         # Fast text search
  # - "bat"             # Cat with syntax highlighting
  # - "exa"             # Modern 'ls' replacement

# Cargo configuration settings (see defaults/main.yml for full structure)
rust_cargo_config: {...}
```

## Usage

### Basic Installation

Add the role to your playbook (run as user, not root):

```yaml
- role: tools/rust
  tags: [rust]
```

### Install with Updates

To ensure Rust is updated during installation:

```yaml
- role: tools/rust
  vars:
    rust_update_toolchain: true
  tags: [rust]
```

### Custom Toolchain

Install a specific Rust toolchain:

```yaml
- role: tools/rust
  vars:
    rust_default_toolchain: "1.70.0"
  tags: [rust]
```

### Minimal Installation

Install without extra components:

```yaml
- role: tools/rust
  vars:
    rust_components: []
  tags: [rust]
```

### Skip Shell Profile Updates

If you manage your shell configuration elsewhere:

```yaml
- role: tools/rust
  vars:
    rust_update_shell_profiles: false
  tags: [rust]
```

### Install Cargo Packages

Install useful Rust command-line tools via cargo:

```yaml
- role: tools/rust
  vars:
    rust_cargo_packages:
      - "bp"           # Better paste - clipboard tool
      - "fd-find"     # Modern 'find' replacement
      - "ripgrep"     # Fast text search
      - "bat"         # Cat with syntax highlighting
      - "exa"         # Modern 'ls' replacement
  tags: [rust]
```

## What This Role Does

1. **Installs Dependencies**: curl, build-essential
2. **Creates XDG Directories**: Ensures proper directory structure
3. **Migration**: Moves existing non-XDG Rust installations if found
4. **Downloads Rustup**: Gets the official rustup installer
5. **Installs Rust**: Installs with XDG-compliant paths
6. **Configures Cargo**: Sets up optimized cargo configuration
7. **Shell Integration**: Adds environment variables to shell profiles
8. **Component Installation**: Installs additional Rust components
9. **Verification**: Verifies installation works correctly

## Environment Variables Set

The role configures these environment variables in your shell:

```bash
export CARGO_HOME="$HOME/.local/share/cargo"
export RUSTUP_HOME="$HOME/.local/share/rustup" 
export PATH="$HOME/.local/share/cargo/bin:$PATH"
```

## Post-Installation

After installation:

1. **Restart your shell** or run `source ~/.bashrc` (or `~/.zshrc`)
2. **Verify installation**: `rustc --version && cargo --version`
3. **Your binaries** installed via `cargo install` will be in `~/.local/bin/`

## Migration from Traditional Installation

If you have an existing traditional Rust installation, this role will:
1. Detect existing `~/.cargo` and `~/.rustup` directories
2. Move them to XDG-compliant locations
3. Update configuration to work with new paths

## Cargo Configuration

The role provides optimized cargo configuration including:
- Sparse registry for faster downloads (Rust 1.68+)
- Parallel build jobs
- Network retry configuration
- Release profile optimizations (LTO enabled)

## Common Commands

After installation, use Rust as normal:
```bash
# Install a crate globally
cargo install ripgrep

# Update Rust toolchain
rustup update

# Add a toolchain
rustup toolchain install nightly

# Format code
cargo fmt

# Run clippy
cargo clippy
```

## Example Playbook

```yaml
- name: Install Rust Development Environment
  hosts: localhost
  connection: local
  gather_facts: true
  become: false  # Important: run as user, not root

  roles:
    - role: tools/rust
      vars:
        rust_update_toolchain: true
      tags: [rust]
```

## Troubleshooting

**Environment not loaded**: Restart your shell or source your profile
**Permission issues**: Make sure you're not running with `become: true`
**Path issues**: Ensure `~/.local/bin` is in your PATH

## License

Same as the parent playbook repository.

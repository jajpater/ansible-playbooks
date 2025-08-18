# Tool Installation Methods

This repository supports **three different approaches** for installing development tools. You can choose the method that best fits your needs and preferences.

## Quick Switch

Edit `group_vars/all.yml` and change the `tool_installation_method`:

```yaml
# Choose your installation method
tool_installation_method: "hybrid"      # Per-tool configuration (default)
# tool_installation_method: "guix"      # Use Guix for all tools
# tool_installation_method: "individual" # Use individual Ansible roles for all tools
```

## Method 1: Hybrid Mode (Recommended - New Default)

**Status**: Default method as of 2025-08-18

The hybrid mode intelligently chooses the best installation method for each tool based on configuration complexity:

### Default Configuration
```yaml
tool_installation_method: "hybrid"

# Per-tool configuration (customizable)
tool_installation_config:
  # Complex tools → individual roles (extensive configuration)
  zoxide:
    method: "individual"    # Shell integration + profile management
  rust: 
    method: "individual"    # XDG compliance + cargo config + components
  rbw:
    method: "individual"    # Bitwarden config + rofi integration
    
  # Simple tools → Guix (minimal configuration)
  fzf:
    method: "guix"         # Just binary installation
  greenclip:
    method: "guix"         # Just binary installation  
  mu:
    method: "guix"         # Avoid compilation issues
```

### Customizing Per-Tool Configuration
You can override any tool's installation method:

```yaml
# Example: Use individual role for fzf instead of Guix
tool_installation_config:
  fzf:
    method: "individual"   # Override default
    reason: "Need custom configuration"
    
  # Add new tool configuration
  new_tool:
    method: "guix"
    reason: "Simple installation preferred"
```

### Installation
```bash
# Install with hybrid mode (uses per-tool config)
ansible-playbook -i inventory user.yml --tags guix-tools,fzf,zoxide,rust,rbw

# Or install everything
ansible-playbook -i inventory user.yml
```

## Method 2: Pure Guix Mode

**Status**: Available for users who prefer unified package management

### Advantages
- ✅ **User-level installation** - No sudo required
- ✅ **Atomic transactions** - Install/remove operations are atomic
- ✅ **Rollback capability** - Can rollback to previous package generations  
- ✅ **Reproducible environments** - Exact same versions across systems
- ✅ **Functional package management** - Multiple versions can coexist
- ✅ **XDG Base Directory compliant** - Uses `~/.config`, `~/.cache`, `~/.local`
- ✅ **Centralized management** - One role manages multiple tools
- ✅ **32,000+ packages available** - Extensive ecosystem

### Tools Available via Guix
- **fzf** - Command-line fuzzy finder
- **zoxide** - Smart cd replacement with frecency algorithm
- **ripgrep** - Fast grep alternative in Rust
- **rust** - Complete Rust toolchain (rustc, cargo, std library)
- **greenclip** - Simple clipboard manager for X11
- **rbw** - Unofficial Bitwarden command line client
- **mu** - Email indexing and search tool

### Installation
```bash
# Install complete Guix ecosystem
ansible-playbook -i inventory user.yml --tags guile,guix,guix-tools

# Or just the tools (if Guix already installed)
ansible-playbook -i inventory user.yml --tags guix-tools
```

### Directory Structure
```
~/.guix-profile/         # Guix profile with all tools
~/.guix-home/            # Guix Home configuration
~/.config/guix/          # Guix configuration files
~/.cache/guix/           # Guix cache data
~/.local/share/guix/     # Guix data files
```

## Method 3: Pure Individual Roles Mode

**Status**: Available for users who need maximum control over each tool

### Advantages  
- ✅ **Fine-grained control** - Configure each tool independently
- ✅ **Mixed installation sources** - Some tools from GitHub, others from package managers
- ✅ **Familiar Ansible patterns** - Traditional role-based approach
- ✅ **Custom configurations** - Detailed per-tool configuration options
- ✅ **No dependencies** - Each tool installs independently

### Disadvantages
- ❌ **More maintenance** - Multiple roles to maintain
- ❌ **Inconsistent environments** - Different versions across systems possible
- ❌ **No atomic transactions** - Partial failures possible
- ❌ **No rollback** - Can't easily revert changes

### Available Individual Roles
- `tools/fzf` - Installs fzf fuzzy finder via GitHub releases  
- `tools/zoxide` - Installs zoxide via GitHub releases
- `tools/rust` - Installs Rust via rustup.rs
- `tools/greenclip` - Installs greenclip via GitHub releases
- `tools/rbw` - Installs rbw via GitHub releases or cargo

### Installation
```bash
# First switch to individual mode
# Edit group_vars/all.yml: tool_installation_method: "individual"

# Then install tools
ansible-playbook -i inventory user.yml --tags fzf,zoxide,rust,greenclip,rbw
```

## Switching Between Methods

### To Hybrid Mode (Recommended)
```yaml
# In group_vars/all.yml
tool_installation_method: "hybrid"

# Optionally customize per-tool configuration:
tool_installation_config:
  your_tool:
    method: "guix"  # or "individual"
    reason: "Your reason here"
```

### To Pure Guix Mode
```yaml
# In group_vars/all.yml  
tool_installation_method: "guix"
```

### To Pure Individual Mode
```yaml
# In group_vars/all.yml
tool_installation_method: "individual"
```

### Cleaning Up After Switching

**From Individual to Guix/Hybrid**: Tools in `~/.local/bin` are automatically shadowed by Guix versions (no cleanup needed)

**From Guix to Individual**: Remove Guix tools if desired:
```bash
export GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
guix remove fzf greenclip mu  # Remove tools that will use individual roles
```

## Comparison Table

| Feature | Hybrid Mode | Pure Guix | Pure Individual |
|---------|-------------|-----------|-----------------|
| **Sudo Required** | ❌ No | ❌ No | ❌ No |
| **Atomic Operations** | ⚠️ Partial | ✅ Yes | ❌ No |
| **Rollback Support** | ⚠️ Partial | ✅ Yes | ❌ No |
| **Reproducible** | ✅ Yes | ✅ Yes | ⚠️ Partial |
| **Configuration Complexity** | 🟢 Optimal | 🟢 Simple | 🔴 Complex |
| **Maintenance Overhead** | 🟡 Medium | 🟢 Low | 🔴 High |
| **Custom Configurations** | ✅ Best of both | 🟡 Limited | ✅ Extensive |
| **Package Versions** | 🟢 Mixed/Optimal | 🟢 Curated | 🟡 Latest/Mixed |
| **Flexibility** | ✅ Maximum | 🟡 Limited | ✅ High |
| **Learning Curve** | 🟡 Medium | 🟡 Scheme/Guix | 🟢 Ansible only |

## Recommendations

### Choose Hybrid Mode If: ⭐ (Recommended)
- You want the **best of both worlds**
- You prefer **intelligent defaults** based on tool complexity
- You want **flexibility** to override per tool
- You're **pragmatic** about tool installation methods
- You want **minimal configuration** with maximum control

### Choose Pure Guix Mode If:
- You want **unified package management** for all tools
- **Reproducible environments** are critical
- You prefer **functional package management**
- You're comfortable with **minimal configuration**
- You want to embrace the **Scheme/Lisp ecosystem**

### Choose Pure Individual Mode If:
- You need **maximum control** over every tool
- You prefer **traditional Ansible workflows**
- You want to **mix different installation sources**
- **Extensive per-tool configuration** is essential
- You're **already invested** in individual role configurations

## Support

All three methods are fully supported and tested. The **hybrid mode is the recommended default** as it provides intelligent tool-specific choices while maintaining maximum flexibility.

You can switch between methods at any time by changing the configuration variable and re-running the playbook. The hybrid mode allows per-tool overrides, so you can fine-tune the installation method for each tool based on your specific needs.
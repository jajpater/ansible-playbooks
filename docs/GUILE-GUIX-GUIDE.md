# Guile & Guix Guide for Newcomers 🚀

This guide explains how Guile, Guix, and tools like `mu` are automatically installed and managed by these Ansible playbooks. Perfect for beginners who want to understand what's happening under the hood.

## Table of Contents
- [What are Guile and Guix?](#what-are-guile-and-guix)
- [How the Playbooks Handle Installation](#how-the-playbooks-handle-installation)
- [Directory Structure & Files](#directory-structure--files)
- [Using Guix for Programming](#using-guix-for-programming)
- [Using Guix for Installing Binaries](#using-guix-for-installing-binaries)
- [Troubleshooting & Common Issues](#troubleshooting--common-issues)

## What are Guile and Guix?

### 🐍 Guile
**GNU Guile** is a programming language (a variant of Scheme/Lisp) and also serves as an extension language for other applications. Think of it as:
- A programming language you can use to write scripts
- The foundation that Guix is built on
- A powerful tool for automation and configuration

### 📦 Guix
**GNU Guix** is a package manager (like `apt` or `snap`) with superpowers:
- **Functional package management**: Every package installation is reproducible
- **Per-user installations**: Install packages without affecting other users
- **Rollbacks**: Easily undo package installations
- **No dependency hell**: Packages don't conflict with each other
- **Source-based**: Can build packages from source or use pre-built binaries

## How the Playbooks Handle Installation

### 🔧 Automatic Problem Detection & Resolution

The playbooks automatically detect and resolve common Guile/Guix issues:

#### **Problem: TLS/Guile Module Conflicts**
The playbooks check for the infamous "make-session" error that occurs when custom Guile installations conflict with system Guile.

```yaml
# The playbook automatically tests for this error:
- name: Test Guix functionality for TLS issues
  shell: |
    {{ guix_binary }} install --dry-run hello 2>&1 | grep -q "make-session"
  register: guix_tls_test
  failed_when: false
```

**What it fixes:**
- Removes conflicting custom Guile installations
- Sets proper environment variables (`GUILE_LOAD_PATH`, `GUILE_EXTENSION_PATH`)
- Creates wrapper scripts to ensure Guix subprocesses work correctly

#### **Problem: Missing Guix Installation**
```yaml
# Automatically detects available Guix installations:
- name: Check if system Guix is available (APT)
  command: /usr/bin/guix --version
  
- name: Check if user Guix is available (compiled)
  command: ~/.guix-profile/bin/guix --version
```

**What it does:**
- Prefers user-compiled Guix if available
- Falls back to system APT Guix
- Fails gracefully with helpful error messages if none found

### 🎯 Tool Installation Strategy

The playbooks use a hybrid approach for tool installation:

```yaml
# Some tools via Guix (simple binary tools):
guix_tools_to_install:
  - fzf      # Fuzzy finder
  - greenclip # Clipboard manager  
  - mu       # Email indexer

# Some tools via individual roles (complex configuration):
tool_installation_config:
  rust: 
    method: individual  # Needs XDG compliance, cargo config
  rbw:
    method: individual  # Needs Bitwarden server config
```

## Directory Structure & Files

### 📁 Key Directories

```
~/
├── .guix-profile/              # User's Guix profile (symlink)
│   ├── bin/                    # Guix-installed binaries
│   ├── share/                  # Shared data (docs, etc.)
│   └── etc/profile             # Environment setup script
│
├── .local/
│   ├── bin/                    # User binaries (non-Guix)
│   ├── share/
│   │   └── mu/                 # mu email database
│   └── state/guix/             # Guix internal state
│
├── .config/
│   ├── guix/                   # Guix configuration
│   └── ansible/                # Ansible configuration
│
└── .cache/guix/                # Guix download cache
```

### 🔗 Important Symlinks

```bash
# Your Guix profile is a symlink:
~/.guix-profile -> /var/guix/profiles/per-user/jajpater/guix-profile

# This points to the actual generation:
/var/guix/profiles/per-user/jajpater/guix-profile -> guix-profile-1-link

# Generations are versioned:
/var/guix/profiles/per-user/jajpater/
├── guix-profile-1-link -> /gnu/store/hash-profile
├── guix-profile-2-link -> /gnu/store/hash-profile  
└── guix-profile -> guix-profile-2-link  # Current
```

### 📄 Configuration Files

#### **Shell Configuration (`~/.zshrc`)**
The playbook automatically adds:
```bash
# BEGIN ANSIBLE MANAGED BLOCK - Guix Environment
export GUIX_PROFILE="/home/jajpater/.guix-profile"
if [ -f "$GUIX_PROFILE/etc/profile" ]; then
    . "$GUIX_PROFILE/etc/profile"
fi
# END ANSIBLE MANAGED BLOCK - Guix Environment
```

#### **Spacemacs Configuration (`~/.spacemacs`)**
For mu4e email integration:
```elisp
;; Automatically updated by playbook:
mu4e-installation-path "/home/jajpater/.guix-profile/share/emacs/site-lisp/mu4e/"
mu4e-mu-home "/home/jajpater/.local/share/mu"
```

## Using Guix for Programming

### 🐍 Guile Programming

#### **Basic Guile Script**
```scheme
#!/usr/bin/env guile
!#

(use-modules (ice-9 format))

(define (greet name)
  (format #t "Hello, ~a!~%" name))

(greet "World")
```

#### **Running Guile Programs**
```bash
# Interactive REPL
guile

# Run a script
guile my-script.scm

# One-liner
guile -c '(display "Hello from Guile!\n")'
```

#### **Package Definition Example**
Create your own package definitions:
```scheme
;; my-package.scm
(use-modules (guix packages)
             (guix download)
             (guix build-system gnu))

(package
  (name "my-tool")
  (version "1.0")
  (source (origin
            (method url-fetch)
            (uri "https://example.com/my-tool-1.0.tar.gz")
            (sha256 (base32 "..."))))
  (build-system gnu-build-system)
  (synopsis "My custom tool")
  (description "A custom tool for doing things.")
  (license license:gpl3+))
```

### 📦 Advanced Guix Development

#### **Creating Development Environments**
```bash
# Temporary development shell with specific packages
guix shell gcc gdb make

# Environment for Python development
guix shell python python-pytest python-numpy

# Environment with specific package versions
guix shell gcc@10 python@3.9
```

#### **Using Guix for Reproducible Research**
```bash
# Create a manifest file
cat > manifest.scm << EOF
(specifications->manifest
  '("python"
    "python-numpy"
    "python-matplotlib"
    "r"
    "r-ggplot2"))
EOF

# Use the environment
guix shell -m manifest.scm
```

## Using Guix for Installing Binaries

### 📥 Basic Package Management

#### **Search for Packages**
```bash
# Search by name
guix search firefox

# Search by description
guix search "text editor"

# Show package details
guix show emacs
```

#### **Install Packages**
```bash
# Install a single package
guix install firefox

# Install multiple packages
guix install emacs git firefox

# Install specific version
guix install emacs@28.2
```

#### **Manage Installed Packages**
```bash
# List installed packages
guix package --list-installed

# Remove packages
guix remove firefox

# Upgrade all packages
guix upgrade

# Upgrade specific package
guix upgrade emacs
```

### 🔄 Profile Management

#### **Generations (Rollback System)**
```bash
# List all generations
guix package --list-generations

# Rollback to previous generation
guix package --roll-back

# Switch to specific generation
guix package --switch-generation=5

# Delete old generations
guix package --delete-generations=2w  # Older than 2 weeks
```

#### **Multiple Profiles**
```bash
# Create development profile
guix package -p ~/dev-profile -i gcc gdb make

# Use development profile
export GUIX_PROFILE="$HOME/dev-profile"
. "$GUIX_PROFILE/etc/profile"

# Install to specific profile
guix install -p ~/gaming-profile steam
```

### 🛠️ Advanced Usage

#### **Building from Source**
```bash
# Force building from source
guix install --no-substitutes emacs

# Keep failed build for debugging
guix install --keep-failed some-package
```

#### **Local Package Development**
```bash
# Install from local definition
guix install -f my-package.scm

# Development with local checkout
guix install -e '(load "my-package.scm")'
```

## Troubleshooting & Common Issues

### 🐛 Common Problems

#### **"command not found" after installing**
```bash
# Problem: Guix profile not in PATH
# Solution: Source the profile
export GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"

# Or restart your shell
exec $SHELL
```

#### **"make-session" errors**
```bash
# Problem: Guile/TLS module conflicts
# Solution: Re-run the guix-tools playbook
ansible-playbook user.yml --tags=guix-tools

# Manual fix if needed:
export GUILE_LOAD_PATH="/usr/share/guile/3.0:/usr/share/guile/site/3.0"
export GUILE_EXTENSION_PATH="/usr/lib/x86_64-linux-gnu/guile/3.0/extensions"
```

#### **Slow package installation**
```bash
# Problem: Building from source instead of using substitutes
# Solution: Enable substitute servers
echo 'https://ci.guix.gnu.org https://bordeaux.guix.gnu.org' | \
  sudo tee -a /etc/guix/acl
```

#### **Disk space issues**
```bash
# Clean up old generations
guix package --delete-generations=1m

# Run garbage collection
guix gc

# Aggressive cleanup (free up to 5GB)
guix gc --free-space=5G
```

### 🔧 Maintenance Commands

#### **Regular Maintenance**
```bash
# Update package definitions
guix pull

# Upgrade all packages
guix upgrade

# Clean up old stuff
guix package --delete-generations=2w
guix gc --free-space=1G
```

#### **System Health Check**
```bash
# Verify store integrity
sudo guix system verify

# Check for problems
guix lint some-package

# Refresh package metadata
guix refresh
```

### 📋 Quick Reference

#### **Essential Commands**
| Command | Purpose |
|---------|---------|
| `guix search <term>` | Search for packages |
| `guix install <pkg>` | Install package |
| `guix remove <pkg>` | Remove package |
| `guix upgrade` | Upgrade all packages |
| `guix package --list-installed` | List installed packages |
| `guix package --roll-back` | Undo last change |
| `guix pull` | Update Guix itself |
| `guix gc` | Clean up unused packages |

#### **Environment Commands**
| Command | Purpose |
|---------|---------|
| `guix shell <pkg>` | Temporary environment |
| `guix shell -f manifest.scm` | Environment from manifest |
| `guix package -p ~/profile -i <pkg>` | Install to specific profile |

#### **Development Commands**
| Command | Purpose |
|---------|---------|
| `guix install -f package.scm` | Install from local definition |
| `guix lint <pkg>` | Check package quality |
| `guix refresh <pkg>` | Check for updates |
| `guix show <pkg>` | Show package details |

## Getting Help

- **Official Documentation**: https://guix.gnu.org/manual/
- **Community**: #guix on libera.chat IRC
- **Mailing Lists**: help-guix@gnu.org
- **Cookbook**: https://guix.gnu.org/cookbook/

---

**Note**: This guide covers the setup as managed by the Ansible playbooks. For manual installation or advanced configuration, refer to the official Guix documentation.

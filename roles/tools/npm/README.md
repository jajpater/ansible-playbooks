# npm - XDG-Compliant Installation Role

This Ansible role installs Node.js and npm in an XDG Base Directory Specification compliant manner, organizing configuration files, cache, and data directories according to XDG standards.

## Features

- **XDG-compliant**: Follows XDG Base Directory Specification
- **Latest Node.js LTS**: Automatically installs the latest LTS release
- **User-local installation**: Installs to `~/.local` without requiring sudo
- **Configurable**: Highly customizable with sensible defaults
- **Global package support**: Manages global npm packages in XDG-compliant locations
- **Shell integration**: Automatically configures PATH in common shell files (including XDG-compliant zsh)

## XDG Directory Structure

The role organizes npm files according to XDG standards:

- **Config**: `~/.config/npm/` - npm configuration files
- **Cache**: `~/.cache/npm/` - npm cache files
- **Data**: `~/.local/share/npm/` - global packages and binaries
- **Binaries**: `~/.local/bin/` - Node.js and npm executables

## Requirements

- Ansible 2.10+
- Ubuntu 20.04+ or Debian 10+
- Internet connection for downloading Node.js releases
- System packages: `curl`, `wget`, `tar`, `xz-utils`, `python3`

## Role Variables

### Installation Settings

```yaml
# Installation method (currently only 'nodejs' supported)
npm_install_method: "nodejs"

# Node.js version to install ('latest' for most recent LTS)
nodejs_version: "latest"

# Installation directory for binaries
npm_install_dir: "{{ ansible_env.HOME }}/.local"

# Force update even if already installed
npm_force_update: false
```

### XDG-Compliant Directories

```yaml
# Configuration directory
npm_config_dir: "{{ ansible_env.HOME }}/.config/npm"

# Cache directory
npm_cache_dir: "{{ ansible_env.HOME }}/.cache/npm"

# Data directory for global packages
npm_data_dir: "{{ ansible_env.HOME }}/.local/share/npm"

# Global packages installation directory
npm_global_dir: "{{ npm_data_dir }}/lib/node_modules"

# Global binaries directory
npm_global_bin_dir: "{{ npm_data_dir }}/bin"
```

### Configuration Settings

```yaml
# Whether to create XDG directories
npm_create_xdg_dirs: true

# Whether to setup shell PATH
npm_setup_path: true

# npm registry URL
npm_registry: "https://registry.npmjs.org/"

# Global packages to install
npm_global_packages:
  - name: "typescript"
    version: "latest"
  - name: "@vue/cli"
    version: "latest"
```

## Dependencies

None.

## Example Playbook

### Basic Usage

```yaml
- hosts: localhost
  roles:
    - tools/npm
```

### Custom Configuration

```yaml
- hosts: localhost
  roles:
    - role: tools/npm
      vars:
        nodejs_version: "v18.17.0"
        npm_global_packages:
          - name: "typescript"
            version: "latest"
          - name: "@angular/cli"
            version: "latest"
          - name: "eslint"
            version: "latest"
```

### Development Setup

```yaml
- hosts: localhost
  roles:
    - role: tools/npm
      vars:
        npm_force_update: true
        npm_global_packages:
          - name: "nodemon"
          - name: "jest"
          - name: "prettier"
          - name: "eslint"
          - name: "@typescript-eslint/cli"
```

## Usage After Installation

After running the role:

1. **Restart your shell** or source your profile:
   ```bash
   source ~/.profile
   ```

2. **Verify installation**:
   ```bash
   node --version
   npm --version
   ```

3. **Install global packages**:
   ```bash
   npm install -g package-name
   ```

4. **Check global packages**:
   ```bash
   npm list -g --depth=0
   ```

## XDG Compliance Details

This role implements XDG Base Directory Specification compliance:

- **$XDG_CONFIG_HOME** (`~/.config/npm/`): Configuration files
- **$XDG_CACHE_HOME** (`~/.cache/npm/`): Cache data
- **$XDG_DATA_HOME** (`~/.local/share/npm/`): Application data
- **User binaries** (`~/.local/bin/`): Executable files

The npm configuration is automatically set to use these directories, ensuring clean separation of different types of files.

## Tags

Available tags for selective execution:

- `npm`: All npm-related tasks
- `nodejs`: Node.js installation tasks
- `xdg`: XDG directory creation
- `config`: Configuration file generation
- `path`: PATH setup in shell files
- `packages`: Global package installation
- `verify`: Installation verification
- `dependencies`: System dependency checks

Example usage:
```bash
ansible-playbook playbook.yml --tags "npm,config"
```

## Troubleshooting

### Permission Issues

If you encounter permission errors, ensure the role is run as the user who will use npm, not as root.

### PATH Not Updated

If npm commands are not found after installation:

1. Restart your terminal
2. Or manually source your profile: `source ~/.profile`
3. Check PATH includes npm directories: `echo $PATH`

### Global Packages Not Found

Ensure the global binary directory is in your PATH:
```bash
export PATH="~/.local/share/npm/bin:$PATH"
```

## License

MIT

## Author Information

System Administrator

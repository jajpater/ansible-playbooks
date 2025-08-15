# Ansible Role: GitHub Script

This role installs and manages scripts from GitHub repositories. It provides a flexible way to download and install shell scripts, command-line tools, and other executable files from GitHub.

## Features

- ✅ **Direct Downloads**: Download scripts from direct URLs or GitHub repositories
- ✅ **Version Management**: Support for latest releases or specific versions
- ✅ **Update Control**: Configurable update behavior (auto, always, never, force)
- ✅ **User Installation**: Installs in user's local bin directory (`~/.local/bin`)
- ✅ **Dependency Checking**: Optional dependency validation
- ✅ **Python Dependencies**: Smart Python package installation via pipx (with pip fallback)
- ✅ **Post-Install Commands**: Run custom commands after installation
- ✅ **Predefined Configs**: Built-in configurations for popular scripts
- ✅ **Verification**: Validates successful installation

## Requirements

- Ansible 2.9 or higher
- Internet connection for downloading scripts
- `curl` or `wget` for downloads (handled automatically)

## Role Variables

### Basic Configuration
```yaml
github_script_repo: ""                    # GitHub repo (e.g. "soimort/translate-shell")
github_script_name: ""                    # Script name (e.g. "trans")  
github_script_url: ""                     # Optional: Direct download URL
github_script_version: "latest"           # Version to install
```

### Installation Settings
```yaml
github_script_install_dir: "{{ ansible_env.HOME }}/.local/bin"
github_script_download_dir: "/tmp"
github_script_mode: "0755"                # File permissions
```

### Update Management
```yaml
github_script_update_mode: "auto"         # auto, always, never, force
github_script_force_update: false
```

### Advanced Options
```yaml
github_script_dependencies: []            # List of system packages to check
github_script_python_dependencies: []     # List of Python packages to install via pip
github_script_post_install_commands: []   # Commands to run after install
github_script_verify_installation: true   # Verify installation
```

### Predefined Configurations
```yaml
github_script_config: ""                  # Use predefined config (e.g. "translate-shell")
```

## Predefined Configurations

### Translate Shell
```yaml
github_script_config: "translate-shell"
```
This automatically configures:
- Repository: `soimort/translate-shell`
- Script name: `trans`
- Direct URL: `https://git.io/trans`
- System Dependencies: `curl`, `gawk`, `python3`, `pip3`
- Python Dependencies: `googletrans==4.0.0rc1`, `requests`, `beautifulsoup4`, `lxml`

### vimv - Terminal File Rename Utility
```yaml
github_script_config: "vimv"
```
This automatically configures:
- Repository: `thameera/vimv`
- Script name: `vimv`
- Direct URL: `https://raw.githubusercontent.com/thameera/vimv/master/vimv`
- System Dependencies: `vim`
- Post-install: Provides usage instructions and verification

## Usage Examples

### Basic Usage - Translate Shell
```yaml
- hosts: localhost
  roles:
    - role: tools/github_script
      vars:
        github_script_config: "translate-shell"
```

### Custom Script from Repository
```yaml
- hosts: localhost
  roles:
    - role: tools/github_script
      vars:
        github_script_repo: "user/repo"
        github_script_name: "script-name"
        github_script_dependencies: ["curl"]
```

### Direct URL Download
```yaml
- hosts: localhost
  roles:
    - role: tools/github_script
      vars:
        github_script_name: "my-script"
        github_script_url: "https://example.com/script.sh"
        github_script_post_install_commands:
          - "{{ github_script_install_dir }}/my-script --version"
```

### Multiple Scripts
```yaml
- hosts: localhost
  tasks:
    - name: Install translate-shell
      include_role:
        name: tools/github_script
      vars:
        github_script_config: "translate-shell"

    - name: Install custom script
      include_role:
        name: tools/github_script
      vars:
        github_script_repo: "custom/script"
        github_script_name: "custom-tool"
```

## Update Modes

- **`auto`** (default): Update only if a newer version is available
- **`always`**: Always download and install, even if same version
- **`never`**: Skip installation if any version is already present  
- **`force`**: Force reinstall regardless of current version

## Post-Installation

After installation, scripts will be available at `~/.local/bin/script-name`.

### For Translate Shell:
```bash
# Basic translation
trans "Hello, World"

# Translate to specific language
trans :fr "Hello, World" 

# Interactive mode
trans -shell -brief

# Show version
trans --version
```

## Adding New Predefined Configurations

To add a new predefined configuration, edit `defaults/main.yml`:

```yaml
github_script_configs:
  my-script:
    repo: "user/repository"
    name: "script-name"
    url: "https://direct-url.com/script"         # Optional
    dependencies: ["curl", "jq"]                 # Optional: System packages
    python_dependencies: ["requests", "bs4"]     # Optional: Python packages
    post_install_commands:                       # Optional
      - "{{ github_script_install_dir }}/script-name --version"
```

## Error Handling

The role includes comprehensive error handling:
- Validates required variables
- Checks for missing dependencies (warnings only)
- Verifies download success
- Validates installation
- Provides detailed error messages

## File Structure

```
roles/tools/github_script/
├── defaults/main.yml       # Default variables and predefined configs
├── tasks/main.yml         # Main installation logic
├── handlers/main.yml      # Installation handlers
├── meta/main.yml         # Role metadata
└── README.md             # This documentation
```

## Python Dependencies Strategy

The role uses a smart approach for installing Python dependencies:

1. **pipx First**: Attempts to install packages using pipx for isolated environments
2. **pip Fallback**: Falls back to `pip --user` for packages that fail with pipx
3. **Direct pip**: Uses `pip --user` directly if pipx is unavailable

This ensures maximum compatibility while preferring isolated installations where possible.

### Benefits:
- **Isolated Environments**: pipx creates separate virtual environments
- **No Conflicts**: Prevents dependency conflicts between packages
- **Fallback Support**: Ensures installation even if pipx fails
- **User-Level**: No system-wide changes or sudo required

## Troubleshooting

**Download fails**: Check internet connection and URL validity
**Permission denied**: Verify `github_script_mode` is set correctly
**Command not found**: Ensure `~/.local/bin` is in your PATH
**Dependencies missing**: Install required packages manually
**Python package fails**: Check the installation summary for pipx/pip status

## License

MIT

## Author Information

This role was created as part of a comprehensive system management toolkit for Ubuntu/Debian systems, designed to handle various GitHub-hosted scripts and tools.

# Ansible Role: gdu

This role installs and manages [gdu](https://github.com/dundee/gdu) - a fast disk usage analyzer with console interface written in Go.

## Features

- ✅ **Latest Release**: Automatically fetches and installs the latest version from GitHub
- ✅ **Version Pinning**: Support for installing specific versions
- ✅ **Update Management**: Configurable update behavior (auto, always, never, force)
- ✅ **User Installation**: Installs in user's local bin directory (`~/.local/bin`)
- ✅ **Multiple Binary Types**: Choose between static, regular, or extended builds
- ✅ **Verification**: Validates successful installation
- ✅ **Cleanup**: Removes temporary download files after installation

## Requirements

- Ansible 2.9 or higher
- Internet connection for downloading releases
- `curl` and `jq` for API queries (handled automatically)

## Role Variables

### Version Management
```yaml
gdu_version: "latest"              # Version to install ("latest" or specific like "v5.31.0")
gdu_update_mode: "auto"            # Update behavior: auto, always, never, force
```

### Installation Paths
```yaml
gdu_install_dir: "{{ ansible_env.HOME }}/.local/bin"  # Installation directory
gdu_download_dir: "/tmp"           # Temporary download location
```

### Binary Configuration
```yaml
gdu_binary_type: "static"          # Binary type: static, regular, or x (extended features)
gdu_arch: "amd64"                  # Architecture (amd64, arm64, etc.)
gdu_platform: "linux"             # Platform (linux, darwin, windows)
```

### Advanced Options
```yaml
gdu_repo: "dundee/gdu"             # GitHub repository
gdu_download_timeout: 300          # Download timeout in seconds
gdu_verify_installation: true      # Verify installation after completion
```

## Update Modes

- **`auto`** (default): Update only if a newer version is available
- **`always`**: Always download and install, even if the same version
- **`never`**: Skip installation if any version is already present
- **`force`**: Force reinstall regardless of current version

## Binary Types

- **`static`** (default): Statically linked binary with no external dependencies
- **`regular`**: Standard dynamically linked binary
- **`x`**: Extended build with additional features

## Dependencies

None. This role handles all necessary dependencies internally.

## Example Playbook

### Basic Usage
```yaml
- hosts: localhost
  roles:
    - tools/gdu
```

### Custom Configuration
```yaml
- hosts: localhost
  roles:
    - role: tools/gdu
      vars:
        gdu_version: "v5.30.0"           # Pin to specific version
        gdu_update_mode: "always"        # Always reinstall
        gdu_binary_type: "x"            # Use extended build
```

### Multiple Configurations
```yaml
- hosts: localhost
  tasks:
    - name: Install latest gdu
      include_role:
        name: tools/gdu
      vars:
        gdu_version: "latest"
        gdu_update_mode: "auto"

    - name: Install specific version for testing
      include_role:
        name: tools/gdu
      vars:
        gdu_version: "v5.29.0"
        gdu_install_dir: "{{ ansible_env.HOME }}/test-bin"
        gdu_update_mode: "force"
```

## Usage Examples

After installation, gdu will be available at `~/.local/bin/gdu`:

### Basic disk usage analysis
```bash
# Analyze current directory
gdu

# Analyze specific directory
gdu /var/log

# Show version
gdu --version
```

### Advanced usage
```bash
# Show all devices
gdu -d

# Skip hidden files
gdu --no-hidden

# Show progress
gdu --show-progress

# Export to JSON
gdu --output-file=report.json
```

## Verification

The role automatically verifies the installation by:
1. Checking if the binary exists at the expected location
2. Running `gdu --version` to confirm it's executable
3. Displaying installation details

Manual verification:
```bash
# Check installation
ls -la ~/.local/bin/gdu

# Test functionality
~/.local/bin/gdu --version
~/.local/bin/gdu --help
```

## File Structure

```
roles/tools/gdu/
├── defaults/main.yml       # Default variables
├── tasks/main.yml         # Main installation tasks
├── handlers/main.yml      # Installation handlers
├── meta/main.yml         # Role metadata
└── README.md             # This documentation
```

## Architecture Support

This role currently supports:
- **Linux amd64** (default)
- **Linux arm64** (set `gdu_arch: "arm64"`)

Other architectures available upstream can be configured via the `gdu_arch` variable.

## License

MIT

## Author Information

This role was created as part of a comprehensive system management toolkit for Ubuntu/Debian systems.

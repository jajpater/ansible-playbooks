# Go - XDG-Compliant Installation Role

This Ansible role installs the Go programming language in an XDG Base Directory Specification compliant manner, organizing the SDK, workspace, cache, and configuration files according to XDG standards.

## Features

- **XDG-compliant**: Follows XDG Base Directory Specification
- **Latest Go version**: Automatically installs the latest stable release
- **User-local installation**: Installs to `~/.local/share` without requiring sudo
- **Proper Go environment**: Sets up GOROOT, GOPATH, GOCACHE, etc.
- **Workspace creation**: Creates standard Go workspace structure
- **Package management**: Can install global Go packages
- **Shell integration**: Configures environment in shell files (including XDG-compliant zsh)

## XDG Directory Structure

The role organizes Go files according to XDG standards:

- **SDK**: `~/.local/share/go/` - Go SDK installation
- **Workspace**: `~/.local/share/go-workspace/` - Go workspace (GOPATH)
- **Cache**: `~/.cache/go/` - Build and test cache
- **Module Cache**: `~/.cache/go/mod/` - Downloaded modules
- **Config**: `~/.config/go/` - Go configuration files
- **User Binaries**: `~/.local/share/go-workspace/bin/` - Installed Go packages

## Requirements

- Ansible 2.10+
- Ubuntu 20.04+ or Debian 10+
- Internet connection for downloading Go releases
- System packages: `curl`, `wget`, `tar`, `git`

## Role Variables

### Installation Settings

```yaml
# Go version to install ('latest' for most recent stable)
go_version: "latest"

# Installation directory for Go SDK
go_install_dir: "{{ ansible_env.HOME }}/.local/share/go"

# Force update even if already installed
go_force_update: false
```

### XDG-Compliant Directories

```yaml
# Go SDK root directory
go_root: "{{ go_install_dir }}"

# Go workspace directory (GOPATH)
go_path: "{{ ansible_env.HOME }}/.local/share/go-workspace"

# Build cache directory
go_cache: "{{ ansible_env.HOME }}/.cache/go"

# Module cache directory  
go_modcache: "{{ ansible_env.HOME }}/.cache/go/mod"

# Configuration directory
go_config_dir: "{{ ansible_env.HOME }}/.config/go"

# User binary directory for installed packages
go_user_bin_dir: "{{ go_path }}/bin"
```

### Configuration Settings

```yaml
# Whether to create XDG directories
go_create_xdg_dirs: true

# Whether to setup shell PATH and environment
go_setup_path: true

# Whether to create Go workspace structure
go_create_workspace: true

# Global Go packages to install
go_packages:
  - "golang.org/x/tools/cmd/goimports"
  - "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
```

### Environment Variables

The role sets up these Go environment variables:

```yaml
go_env_vars:
  GOROOT: "{{ go_root }}"
  GOPATH: "{{ go_path }}"
  GOCACHE: "{{ go_cache }}"
  GOMODCACHE: "{{ go_modcache }}"
  GOBIN: "{{ go_user_bin_dir }}"
  GO111MODULE: "on"
  GOPROXY: "https://proxy.golang.org,direct"
  GOSUMDB: "sum.golang.org"
```

## Dependencies

None.

## Example Playbooks

### Basic Usage

```yaml
- hosts: localhost
  roles:
    - tools/go
```

### Custom Configuration

```yaml
- hosts: localhost
  roles:
    - role: tools/go
      vars:
        go_version: "go1.21.5"
        go_packages:
          - "golang.org/x/tools/cmd/goimports"
          - "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
          - "github.com/air-verse/air@latest"
```

### Development Setup

```yaml
- hosts: localhost
  roles:
    - role: tools/go
      vars:
        go_force_update: true
        go_packages:
          - "golang.org/x/tools/cmd/goimports"
          - "golang.org/x/tools/cmd/godoc"
          - "github.com/golangci/golangci-lint/cmd/golangci-lint@latest"
          - "github.com/air-verse/air@latest"
          - "github.com/swaggo/swag/cmd/swag@latest"
```

## Usage After Installation

After running the role:

1. **Restart your shell** or source your profile:
   ```bash
   source ~/.profile
   ```

2. **Verify installation**:
   ```bash
   go version
   go env
   ```

3. **Create a new project**:
   ```bash
   mkdir myproject && cd myproject
   go mod init myproject
   ```

4. **Install packages globally**:
   ```bash
   go install package@latest
   ```

5. **Build and run**:
   ```bash
   go build
   go run main.go
   ```

## XDG Compliance Details

This role implements XDG Base Directory Specification compliance:

- **$XDG_DATA_HOME** (`~/.local/share/go/`): Go SDK and workspace
- **$XDG_CACHE_HOME** (`~/.cache/go/`): Build cache and modules
- **$XDG_CONFIG_HOME** (`~/.config/go/`): Configuration files

The Go environment is automatically configured to use these directories, ensuring clean separation of different types of files.

## Go Environment

The role sets up a complete Go development environment with:

- **GOROOT**: Points to the Go SDK installation
- **GOPATH**: Traditional workspace (still used for global installs)
- **Module mode**: Enabled by default (GO111MODULE=on)
- **Proxy**: Uses official Go module proxy
- **Cache**: Proper cache directories for builds and modules

## Tags

Available tags for selective execution:

- `go`: All Go-related tasks
- `dependencies`: System dependency checks
- `xdg`: XDG directory creation
- `path`: Environment and PATH setup
- `workspace`: Go workspace creation
- `packages`: Global package installation
- `verify`: Installation verification

Example usage:
```bash
ansible-playbook playbook.yml --tags "go,packages"
```

## Troubleshooting

### Permission Issues

If you encounter permission errors, ensure the role is run as the user who will use Go, not as root.

### PATH Not Updated

If Go commands are not found after installation:

1. Restart your terminal
2. Or manually source your profile: `source ~/.profile`
3. Check PATH includes Go directories: `echo $PATH`

### Module Issues

If you have module-related issues:

1. Check Go environment: `go env`
2. Verify module cache: `ls ~/.cache/go/mod`
3. Clear module cache if needed: `go clean -modcache`

### Workspace Issues

For traditional GOPATH workflow:

1. Verify workspace structure: `ls ~/.local/share/go-workspace`
2. Check GOPATH: `go env GOPATH`
3. Ensure projects are in `$GOPATH/src/`

## License

MIT

## Author Information

System Administrator

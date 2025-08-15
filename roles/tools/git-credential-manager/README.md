# Git Credential Manager Ansible Role

This role installs and configures [Git Credential Manager (GCM)](https://github.com/git-ecosystem/git-credential-manager/), a secure Git credential helper that provides multi-factor authentication support for GitHub, GitLab, Azure DevOps, Bitbucket, and other popular Git hosting services.

## Features

- **Automatic version detection and installation**: Downloads and installs the latest version or a specific version
- **Multi-platform support**: Works on Ubuntu and Debian systems
- **Multiple Git hosting providers**: Pre-configured for GitHub, GitLab, Azure DevOps, and Bitbucket
- **Configurable credential storage**: Support for secretservice, gpg, cache, or plaintext backends
- **GUI and browser-based authentication**: Supports both GUI prompts and browser OAuth flows
- **Comprehensive validation**: Verifies installation and provides detailed feedback

## Requirements

- **Operating System**: Ubuntu 20.04+, Debian 10+ 
- **Ansible**: 2.10+
- **Dependencies**: Git, curl, ca-certificates (automatically installed if `gcm_install_required_packages` is true)
- **Internet connection**: Required for downloading GCM packages

## Role Variables

### Core Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `gcm_version` | `"latest"` | Version to install (`"latest"` or specific version like `"v2.6.1"`) |
| `gcm_force_update` | `false` | Whether to force update if already installed |
| `gcm_configure_git` | `true` | Whether to configure Git to use GCM as credential helper |
| `gcm_git_config_scope` | `"global"` | Git configuration scope (`system`, `global`, or `local`) |

### Provider Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `gcm_configure_providers` | `true` | Whether to configure provider-specific settings |
| `gcm_providers.github.enabled` | `true` | Enable GitHub support |
| `gcm_providers.gitlab.enabled` | `true` | Enable GitLab support |
| `gcm_providers.azure_devops.enabled` | `true` | Enable Azure DevOps support |
| `gcm_providers.bitbucket.enabled` | `true` | Enable Bitbucket support |

### GCM Configuration

| Variable | Default | Description |
|----------|---------|-------------|
| `gcm_config.credential_store` | `"secretservice"` | Credential storage backend |
| `gcm_config.gui_prompt` | `true` | Use GUI prompts when available |
| `gcm_config.use_system_browser` | `true` | Use system browser for OAuth flows |
| `gcm_config.autodetect_timeout` | `30` | Timeout for credential helper autodetection |

### Installation Options

| Variable | Default | Description |
|----------|---------|-------------|
| `gcm_install_required_packages` | `true` | Install required system packages |
| `gcm_validate_installation` | `true` | Validate installation after completion |

## Example Playbook

### Basic Installation

```yaml
- hosts: localhost
  roles:
    - tools/git-credential-manager
```

### Custom Configuration

```yaml
- hosts: localhost
  roles:
    - tools/git-credential-manager
  vars:
    gcm_version: "v2.6.1"
    gcm_config:
      credential_store: "gpg"
      gui_prompt: false
      use_system_browser: true
    gcm_providers:
      github:
        enabled: true
      gitlab:
        enabled: true
      azure_devops:
        enabled: false
      bitbucket:
        enabled: false
```

### Advanced Configuration with Proxy

```yaml
- hosts: localhost
  roles:
    - tools/git-credential-manager
  vars:
    gcm_config:
      credential_store: "secretservice"
      http_proxy: "http://proxy.example.com:8080"
      https_proxy: "https://proxy.example.com:8080"
      trace: false
```

## Usage

After installation, GCM will automatically handle authentication for supported Git hosting services:

1. **First-time setup**: When you clone/push to a repository, GCM will prompt for authentication
2. **Browser authentication**: For OAuth flows, your default browser will open
3. **GUI prompts**: If available, GUI prompts will be used for username/password
4. **Credential storage**: Credentials are securely stored using the configured backend

### Useful Commands

```bash
# Check GCM version
git-credential-manager --version

# View Git credential configuration  
git config --list | grep credential

# Reconfigure GCM
git credential-manager configure

# Remove GCM configuration
git credential-manager unconfigure

# List stored credentials
git credential-manager list
```

## Credential Storage Backends

| Backend | Description | Requirements |
|---------|-------------|--------------|
| `secretservice` | Linux Secret Service API | libsecret, gnome-keyring |
| `gpg` | GNU Privacy Guard | gpg |
| `cache` | Git's built-in cache | None (temporary storage) |
| `plaintext` | Plain text files | None (not recommended) |

## Supported Git Hosting Services

- **GitHub** (github.com)
- **GitLab** (gitlab.com, *.gitlab.io)
- **Azure DevOps** (dev.azure.com, *.visualstudio.com)
- **Bitbucket** (bitbucket.org)

## Troubleshooting

### Common Issues

1. **GCM not found**: Ensure `/usr/local/bin` is in your PATH
2. **Authentication failures**: Check `git config --get credential.helper`
3. **GUI prompts not working**: Ensure you have a desktop environment
4. **Browser not opening**: Check your default browser configuration

### Debug Mode

Enable tracing for detailed logs:

```bash
git config --global credential.trace true
```

### Reset Configuration

If you encounter issues, reset GCM configuration:

```bash
git credential-manager unconfigure
git config --global --unset credential.helper
```

Then re-run the playbook.

## License

This role is provided under the same license as the ansible-playbooks repository.

## Author Information

Created by System Administrator for secure Git credential management automation.

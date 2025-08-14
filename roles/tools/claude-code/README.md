# Claude Code - Anthropic AI Coding Assistant Role

This Ansible role installs and configures Anthropic's Claude Code, an AI-powered coding assistant that helps build features, debug issues, and write code from natural language descriptions.

## Features

- **Automated installation**: Installs Claude Code via npm with proper dependency management
- **XDG-compliant**: Uses XDG Base Directory Specification for configuration
- **Shell integration**: Configures PATH and creates useful aliases
- **Desktop integration**: Creates desktop entry for easy access
- **Authentication ready**: Sets up configuration directory for API keys
- **Dependency management**: Automatically installs npm if needed

## Requirements

- Ansible 2.10+
- Ubuntu 20.04+ or Debian 10+
- Internet connection for npm package installation
- npm (automatically installed via dependency role)
- Anthropic API key (for authentication after installation)

## Role Variables

### Installation Settings

```yaml
# Claude Code npm package information
claude_code_package: "@anthropic-ai/claude-code"
claude_code_version: "latest"

# Force reinstall if already present
claude_code_force_install: false
```

### Path Configuration

```yaml
# npm binary location (from npm role)
claude_code_npm_bin: "{{ ansible_env.HOME }}/.local/bin/npm"

# Global npm packages directory (XDG-compliant)
claude_code_global_bin_dir: "{{ ansible_env.HOME }}/.local/share/npm/bin"

# XDG-compliant configuration directory
claude_code_config_dir: "{{ ansible_env.HOME }}/.config/claude-code"
```

### Optional Features

```yaml
# Whether to create desktop entry
claude_code_create_desktop_entry: true

# Whether to setup shell aliases
claude_code_setup_aliases: true

# Whether to install npm dependency automatically
claude_code_install_npm_dependency: true
```

## Dependencies

- **tools/npm**: Automatically installed unless disabled

## Example Playbooks

### Basic Installation

```yaml
- hosts: localhost
  roles:
    - tools/claude-code
```

### Install Both npm and Claude Code

```yaml
- hosts: localhost
  roles:
    - tools/npm
    - tools/claude-code
```

### Custom Configuration

```yaml
- hosts: localhost
  roles:
    - role: tools/claude-code
      vars:
        claude_code_force_install: true
        claude_code_setup_aliases: false
        claude_code_create_desktop_entry: false
```

## Post-Installation Setup

After running the role, you'll need to authenticate Claude Code:

1. **Get your API key** from [Anthropic Console](https://console.anthropic.com/)

2. **Restart your shell** or source your profile:
   ```bash
   source ~/.profile
   ```

3. **Authenticate Claude Code**:
   ```bash
   claude auth
   ```
   Enter your API key when prompted.

4. **Start using Claude Code**:
   ```bash
   cd your-project
   claude
   ```

## Usage Examples

### Basic Usage
```bash
# Navigate to your project
cd my-awesome-project

# Start Claude Code interactive session
claude

# Or run specific commands
claude --help
claude --version
```

### What Claude Code Can Do
- **Build features from descriptions**: Tell Claude what you want in plain English
- **Debug and fix issues**: Describe bugs or paste error messages
- **Code review and optimization**: Get suggestions for improvements
- **Documentation generation**: Create docs from your code
- **Testing assistance**: Help write and improve tests

## File Locations

The role organizes files according to XDG standards:

- **Binary**: `~/.local/share/npm/bin/claude`
- **Config**: `~/.config/claude-code/`
- **Desktop entry**: `~/.local/share/applications/claude-code.desktop`
- **Shell configuration**: Added to `.bashrc`, `.zshrc`, `.profile`

## Tags

Available tags for selective execution:

- `claude-code`: All Claude Code tasks
- `dependencies`: Dependency checks
- `install`: Installation tasks
- `config`: Configuration setup
- `path`: PATH configuration
- `aliases`: Shell alias setup
- `desktop`: Desktop entry creation
- `verify`: Installation verification

Example usage:
```bash
ansible-playbook playbook.yml --tags "claude-code,config"
```

## Troubleshooting

### Claude Command Not Found

If `claude` command is not found after installation:

1. **Check PATH**: Ensure the global bin directory is in PATH
   ```bash
   echo $PATH | grep -o ~/.local/share/npm/bin
   ```

2. **Reload shell configuration**:
   ```bash
   source ~/.profile
   # or restart your terminal
   ```

3. **Verify installation**:
   ```bash
   ls -la ~/.local/share/npm/bin/claude
   ```

### Authentication Issues

If you have trouble with API key authentication:

1. **Check config directory**:
   ```bash
   ls -la ~/.config/claude-code/
   ```

2. **Re-authenticate**:
   ```bash
   claude auth
   ```

3. **Verify API key**: Ensure your API key is valid at [Anthropic Console](https://console.anthropic.com/)

### npm Not Found

If npm is not available:

1. **Install npm role first**:
   ```yaml
   - hosts: localhost
     roles:
       - tools/npm
       - tools/claude-code
   ```

2. **Check npm installation**:
   ```bash
   ~/.local/bin/npm --version
   ```

## Security Notes

- API keys are stored securely in the user's config directory with restricted permissions (0700)
- The role follows XDG standards for proper file organization
- No sensitive data is logged during execution

## License

MIT

## Author Information

System Administrator

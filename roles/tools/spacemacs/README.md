# Spacemacs Role

This Ansible role installs and configures Spacemacs, a community-driven Emacs configuration.

## Requirements

- Emacs (will be installed automatically if not present)
- Git (for cloning the Spacemacs repository)

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Spacemacs repository URL
spacemacs_repo_url: "https://github.com/syl20bnr/spacemacs"

# Spacemacs branch to install
spacemacs_branch: "develop"

# Spacemacs configuration template
spacemacs_config_template: "spacemacs.j2"
```

## Usage

Include this role in your playbook:

```yaml
- role: tools/spacemacs
  tags: [spacemacs, emacs, editor]
```

## What This Role Does

1. Checks if Emacs is installed (installs it if missing)
2. Backs up any existing `.emacs.d` directory
3. Clones the Spacemacs repository to `~/.emacs.d`
4. Sets proper permissions
5. Creates a basic `.spacemacs` configuration file

## Post-Installation

After installation:

1. Run `emacs` to start Spacemacs
2. On first startup, Spacemacs will automatically install packages
3. Edit `~/.spacemacs` to customize your configuration

## Tags

- `spacemacs`
- `emacs` 
- `editor`

## Dependencies

None.
# Ansible System Setup - Beginner's Guide 🚀

This guide is for absolute beginners who want to use these Ansible playbooks to set up their Ubuntu/Linux system. You'll learn exactly what commands to type in the terminal!

## What This Does

These playbooks automatically install and configure software on your system. Think of it as a "recipe" that sets up your computer exactly how you want it, every time.

**Two main categories:**
- **System-wide stuff** (needs admin password): browsers, system packages, etc.
- **User stuff** (no admin needed): tools in your home folder, fonts, etc.

## Prerequisites - What You Need First

### 1. Install Ansible

Open your terminal and run these commands one by one:

```bash
# Update your system
sudo apt update

# Install Ansible
sudo apt install ansible

# Check if it worked (should show version number)
ansible --version
```

### 2. Install Required Collections (Optional)

```bash
# Navigate to the playbook directory
cd ~/System/ansible-playbooks

# Install additional Ansible collections
ansible-galaxy collection install -r collections/requirements.yml
```

### 3. Set Up Your PATH (Important!)

Many tools will be installed to `~/.local/bin`. Add this to your PATH so you can use them:

```bash
# Open your shell config file
nano ~/.zshrc

# Add this line at the end (use arrow keys to navigate, then type):
export PATH="$HOME/.local/bin:$PATH"

# Save and exit: Ctrl+X, then Y, then Enter

# Reload your shell config
source ~/.zshrc
```

## Basic Commands - What to Type

### Navigate to the Playbook Directory

Always start here:
```bash
cd ~/System/ansible-playbooks
```

### Check What Would Happen (Dry Run)

**Before running anything**, see what would change:

```bash
# See what system changes would be made
ansible-playbook root.yml -K --check

# See what user changes would be made  
ansible-playbook user.yml --check
```

### Install Everything

**System-wide installation** (will ask for your password):
```bash
ansible-playbook root.yml -K
```
*The `-K` means "ask for password" (sudo password)*

**User tools installation** (no password needed):
```bash
ansible-playbook user.yml
```

### Install Specific Tools Only

Instead of installing everything, you can install just what you need:

**System tools** (with admin password):
```bash
# Install Google Chrome only
ansible-playbook root.yml -K --tags chrome

# Install basic system packages only
ansible-playbook root.yml -K --tags apt_basics

# Install multiple things
ansible-playbook root.yml -K --tags chrome,regolith
```

**User tools** (no password):
```bash
# Install greenclip (clipboard manager)
ansible-playbook user.yml --tags greenclip

# Install fonts
ansible-playbook user.yml --tags source-code-pro

# Install development tools
ansible-playbook user.yml --tags fzf,zoxide,typst

# Install everything development-related
ansible-playbook user.yml --tags fzf,zoxide,typst,grb,texlive
```

## Available Tools & Tags

### System Tools (need `-K` for password)
- `apt_basics` - Essential system packages
- `chrome` - Google Chrome browser
- `regolith` - Regolith desktop environment
- `duplicati` - Backup software
- `snap` - Snap packages

### User Tools (no password needed)
- `source-code-pro` - Source Code Pro font
- `greenclip` - Clipboard manager
- `zoxide` - Smart cd command
- `fzf` - Fuzzy file finder
- `typst` - Document preparation system
- `grb` - Git repository browser
- `texlive` - LaTeX system
- `guix-tools` - GNU Guix package manager and tools (includes `mu`, `fzf`, `greenclip`)

### Special Package Managers

#### Guix Tools (`--tags guix-tools`)
This playbook automatically sets up GNU Guix (a functional package manager) and installs tools like `mu` (email indexer), `fzf`, and `greenclip` through Guix instead of individual installation methods.

**📚 For detailed information about Guix, see:** [`docs/GUILE-GUIX-GUIDE.md`](docs/GUILE-GUIX-GUIDE.md)

## Step-by-Step First Run

1. **Open terminal** (Ctrl+Alt+T)

2. **Go to the right place:**
   ```bash
   cd ~/System/ansible-playbooks
   ```

3. **See what would happen first:**
   ```bash
   ansible-playbook user.yml --check
   ```

4. **If it looks good, run it for real:**
   ```bash
   ansible-playbook user.yml
   ```

5. **For system stuff (careful - this changes system-wide things):**
   ```bash
   # Check first
   ansible-playbook root.yml -K --check
   
   # If you're happy with what it would do:
   ansible-playbook root.yml -K
   ```

## Common Problems & Solutions

### "Command not found" after installation
**Problem:** Installed a tool but can't use it  
**Solution:** Make sure `~/.local/bin` is in your PATH (see step 3 above), then restart your terminal

### "Permission denied"
**Problem:** Can't run system playbook  
**Solution:** Make sure you use `-K` flag and enter your password when asked

### "Connection refused" or rate limiting
**Problem:** Too many GitHub downloads  
**Solution:** Set up a GitHub token:
```bash
# Create config directory
mkdir -p ~/.config/ansible

# Create environment file
echo "GITHUB_TOKEN=your_github_token_here" > ~/.config/ansible/env
```

### Playbook fails partway through
**Solution:** Just run it again - Ansible is smart and will skip what's already done

## Useful Commands Reference

```bash
# Navigate to playbooks
cd ~/System/ansible-playbooks

# List all available tags
grep -r "tags:" . --include="*.yml"

# Dry run everything
ansible-playbook user.yml --check
ansible-playbook root.yml -K --check

# Install everything  
ansible-playbook user.yml
ansible-playbook root.yml -K

# Install specific tools
ansible-playbook user.yml --tags greenclip,fzf
ansible-playbook root.yml -K --tags chrome

# Update just one tool
ansible-playbook user.yml --tags zoxide

# Run with more detailed output
ansible-playbook user.yml -v
```

## What Each Command Flag Means

- `-K` = Ask for sudo password (needed for system changes)
- `--check` = Dry run (show what would happen, don't actually do it)
- `--tags` = Only run specific parts
- `-v` = Verbose (more detailed output)
- `-vv` = Even more verbose
- `-vvv` = Maximum verbosity (for debugging)

## Need Help?

1. **Always try `--check` first** to see what would happen
2. **Read the error messages** - they usually tell you what's wrong
3. **Check if you're in the right directory**: `~/System/ansible-playbooks`
4. **Make sure you have the right permissions** - use `-K` for system changes

## Safety Tips

- ✅ **Always run `--check` first** before making real changes
- ✅ **Start with user tools** - they're safer than system tools
- ✅ **Install one tool at a time** when learning (`--tags toolname`)
- ⚠️ **Be careful with root.yml** - it makes system-wide changes
- ⚠️ **Don't run random playbooks** you don't understand

Happy automating! 🎉

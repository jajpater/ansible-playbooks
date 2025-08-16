# ScanTailor Advanced Role

This Ansible role builds and installs ScanTailor from the ImageProcessing-ElectronicPublications (IPEP) variants from source. These are enhanced forks with improved features and UI.

## Supported Variants

- **advanced** (default) - Most popular fork with UI/feature improvements
- **experimental** - Experimental features and algorithms  
- **deviant** - Alternative implementation approach
- **universal** - Universal compatibility version

## Requirements

- Debian/Ubuntu system with build tools
- Sudo privileges (installs system-wide to `/usr/local`)
- Internet connection for downloading source and dependencies

## Role Variables

Available variables are listed below, along with default values (see `defaults/main.yml`):

```yaml
# Which IPEP variant to install
scantailor_ipep_variant: "advanced"   # advanced | experimental | deviant | universal

# Repository settings
scantailor_ipep_repo_base: "https://gitea.com/ImageProcessing-ElectronicPublications"
scantailor_ipep_version: "master"

# Build configuration
scantailor_build_type: "Release"
scantailor_prefix: "/usr/local"

# Directories
scantailor_src_root: "/usr/local/src"
scantailor_src_dir: "{{ scantailor_src_root }}/scantailor-{{ scantailor_ipep_variant }}"
scantailor_build_dir: "{{ scantailor_src_dir }}/build"

# Additional packages (per OS if needed)
scantailor_extra_packages: []

# Build parallelization
scantailor_build_jobs: "{{ ansible_facts.processor_vcpus | default(2) }}"

# Force rebuild even if already installed
scantailor_force_rebuild: false
```

## Usage

Include this role in your playbook:

```yaml
- role: tools/scantailor-advanced
  vars:
    scantailor_ipep_variant: "advanced"  # or experimental, deviant, universal
  tags: [scantailor-advanced, scanner, build]
```

## What This Role Does

1. Updates package cache and installs build dependencies (Qt5, Boost, TIFF/PNG/JPEG, etc.)
2. Clones the selected IPEP variant repository
3. Configures build with CMake
4. Compiles with all available CPU cores
5. Installs to `/usr/local` (system-wide)
6. Updates ldconfig for library linking
7. Verifies successful installation

## Post-Installation

After installation:

- **Command line**: `scantailor-advanced` (or variant name)
- **Full path**: `/usr/local/bin/scantailor-advanced`
- The binary name depends on the variant chosen

## Comparison with AppImage Version

**Advantages of compiled version:**
- Latest features and bug fixes from active development
- Better system integration
- Can choose specific variants (advanced/experimental/deviant/universal)
- Optimized for your specific system

**Advantages of AppImage version:**
- No compilation time (instant installation)
- No build dependencies required  
- User-level installation (no sudo needed)
- Easier to remove

## Multiple Versions

You can have both the AppImage (user-level) and compiled (system-level) versions installed:

- AppImage: `~/.local/bin/scantailor` (user)
- Compiled: `/usr/local/bin/scantailor-advanced` (system)

This allows you to choose which version to use based on your needs.

## Uninstall

To remove the compiled version:

```bash
# Remove binaries and libraries (careful!)
sudo xargs rm -v < /usr/local/src/scantailor-advanced/build/install_manifest.txt

# Remove source directory
sudo rm -rf /usr/local/src/scantailor-advanced
```

## Tags

- `scantailor-advanced`
- `scanner`
- `build`

## Dependencies

None.
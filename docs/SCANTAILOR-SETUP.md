# ScanTailor Installation Opties

Dit document legt uit hoe je kunt kiezen tussen verschillende ScanTailor versies en hoe het kiezen werkt.

## 🎛️ Installatie Configuratie

In `group_vars/all.yml` kun je instellen welke versies je wilt:

```yaml
# ScanTailor installation options
scantailor_install_appimage: true      # User-level AppImage version
scantailor_install_compiled: true      # System-level compiled version

# Compiled version variant (when scantailor_install_compiled is true)
scantailor_compiled_variant: "advanced"  # advanced | experimental | deviant | universal

# Auto-create shell aliases when both versions are installed
scantailor_auto_aliases: true
```

## 📋 Installatie Scenario's

### Scenario 1: Alleen AppImage (Standaard)
```yaml
scantailor_install_appimage: true
scantailor_install_compiled: false
```

**Installeren:**
```bash
ansible-playbook user.yml --tags scantailor
```

**Gebruiken:**
```bash
~/.local/bin/scantailor document.png
scantailor document.png  # Als ~/.local/bin in PATH
```

### Scenario 2: Alleen Compiled Version
```yaml
scantailor_install_appimage: false
scantailor_install_compiled: true
scantailor_compiled_variant: "advanced"
```

**Installeren:**
```bash
sudo ansible-playbook root.yml --tags scantailor-advanced
```

**Gebruiken:**
```bash
/usr/local/bin/scantailor-advanced document.png
scantailor-advanced document.png  # Als /usr/local/bin in PATH
```

### Scenario 3: Beide Versies (Met Auto-Aliases)
```yaml
scantailor_install_appimage: true
scantailor_install_compiled: true
scantailor_compiled_variant: "advanced"
scantailor_auto_aliases: true
```

**Installeren:**
```bash
# Eerst AppImage (user-level)
ansible-playbook user.yml --tags scantailor

# Daarna compiled version (system-level) 
sudo ansible-playbook root.yml --tags scantailor-advanced

# Shell aliases worden automatisch aangemaakt
ansible-playbook user.yml --tags shell-aliases
```

## 🚀 Gebruik Met Beide Versies Geïnstalleerd

Als beide versies geïnstalleerd zijn en `scantailor_auto_aliases: true`, krijg je automatisch deze aliases:

### Direct Aliases
```bash
# Korte aliases
st-app document.png          # AppImage versie
st-advanced document.png     # Compiled versie

# Volledige aliases  
scantailor-app document.png      # AppImage versie
scantailor-advanced document.png # Compiled versie
```

### Smart Function
```bash
# Interactief kiezen
scantailor document.png
# Output:
# Which ScanTailor version?
# 1) AppImage (user-level)  
# 2) Advanced (compiled)
# Choice (1/2): 2

# Direct specificeren
scantailor app document.png      # Gebruikt AppImage
scantailor advanced document.png # Gebruikt compiled

# Hulp weergeven
scantailor
# Toont alle beschikbare opties
```

## 📁 Bestanden Locaties

### AppImage Versie (User-level)
```
~/.local/bin/ScanTailor-d3f8580-x86_64.AppImage  # Echte AppImage
~/.local/bin/scantailor                          # Symlink
~/.local/share/applications/scantailor.desktop   # Desktop entry
```

### Compiled Versie (System-level)
```
/usr/local/bin/scantailor-advanced               # Binary
/usr/local/src/scantailor-advanced/              # Source code
```

### Aliases (Als beide geïnstalleerd)
```
~/.config/ansible/shell_aliases                  # Aliases bestand
~/.bashrc                                        # Source command toegevoegd
~/.zshrc                                         # Source command toegevoegd (indien bestaat)
```

## 🔧 Handmatig Kiezen Zonder Aliases

Als je geen aliases wilt, kun je altijd handmatig kiezen:

```bash
# Volledige paden gebruiken
~/.local/bin/scantailor document.png             # AppImage
/usr/local/bin/scantailor-advanced document.png # Compiled

# Check welke versies geïnstalleerd zijn
ls -la ~/.local/bin/scantailor*
ls -la /usr/local/bin/scantailor*

# Check welke wordt gebruikt door PATH
which scantailor
type scantailor
```

## 🎯 Aanbevolen Workflow

1. **Voor beginners**: Start met alleen AppImage (`scantailor_install_compiled: false`)
2. **Voor power users**: Installeer beide en gebruik aliases voor makkelijk schakelen  
3. **Voor development**: Gebruik compiled version voor nieuwste features

## 🛠️ Troubleshooting

### Aliases werken niet
```bash
# Check of aliases bestand bestaat
ls -la ~/.config/ansible/shell_aliases

# Handmatig laden
source ~/.config/ansible/shell_aliases

# Check of source regel in shell RC staat
grep "shell_aliases" ~/.bashrc ~/.zshrc
```

### Verkeerde versie wordt gebruikt
```bash
# Check PATH volgorde
echo $PATH

# Gebruik volledige paden om zeker te zijn
~/.local/bin/scantailor         # AppImage
/usr/local/bin/scantailor-advanced  # Compiled
```

### Compiled version bouwen mislukt
```bash
# Check dependencies
sudo apt update
sudo apt install build-essential cmake qtbase5-dev

# Rebuild forceren
sudo ansible-playbook root.yml --tags scantailor-advanced -e scantailor_force_rebuild=true
```
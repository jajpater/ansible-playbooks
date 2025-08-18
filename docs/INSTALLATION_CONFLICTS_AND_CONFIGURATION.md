# Installation Conflicts and Configuration Comparison

## 🔄 Conflicten tussen Guix en bestaande installaties

### PATH Prioriteit en Overschrijving

**Kort antwoord**: Guix overschrijft **NIET** automatisch bestaande installaties. Het plaatst zijn binaries **vóór** in je PATH, waardoor ze voorrang krijgen.

### Hoe PATH Priority werkt

```bash
# Typische PATH met Guix:
PATH="$HOME/.guix-profile/bin:$HOME/.local/bin:$PATH"
     ^^^^^^^^^^^^^^^^^^^^^^^^^
     Guix binaries krijgen voorrang
```

**Wat gebeurt er?**
1. **Bestaande tools blijven bestaan** in `~/.local/bin` 
2. **Guix tools worden gevonden eerst** omdat `~/.guix-profile/bin` vóór staat
3. **Geen data verlies** - oude installaties blijven intact

### Voorbeeldscenario

```bash
# Vóór Guix installatie:
$ which fzf
/home/user/.local/bin/fzf

# Na Guix installatie:
$ which fzf  
/home/user/.guix-profile/bin/fzf

# Oude fzf is nog steeds aanwezig:
$ /home/user/.local/bin/fzf --version
# (werkt nog steeds)
```

### Is het verwijderen van oude installaties nodig?

**Nee, niet per se**, maar het heeft voordelen:

**✅ Voordelen van opruimen:**
- Bespaart schijfruimte
- Voorkomt verwarring over welke versie actief is
- Cleaner systeem

**❌ Risico's van niet opruimen:**
- Minimale schijfruimte verspilling
- Potentiële verwarring bij troubleshooting
- Oude configuratie files kunnen conflicteren

### Aanbevolen aanpak

**Optie 1: Geleidelijke migratie (Veilig)**
```bash
# Installeer Guix tools eerst
ansible-playbook -i inventory user.yml --tags guix-tools

# Test dat alles werkt
fzf --version
zoxide --version

# Verwijder oude installaties indien gewenst
rm ~/.local/bin/{fzf,zoxide,rg,rustc,cargo,greenclip,rbw}
```

**Optie 2: Direct overschrijven (Sneller)**
```bash
# Guix tools installeren - oude tools worden automatisch "overschaduwd"
ansible-playbook -i inventory user.yml --tags guix-tools
```

## ⚙️ Configuratie Complexiteit Vergelijking

Na analyse van de individuele roles blijkt dat sommige tools **wel degelijk** uitgebreide configuratie hebben:

### 🔧 Tool Configuratie Detail-analyse

#### **fzf** - Minimale configuratie
```yaml
# Individuele role: Alleen basis installatie
asset_regex: "linux_amd64\\.tar\\.gz$"
bin_relpath: "fzf"

# Guix: Nog minder configuratie
packages: ["fzf"]
```
**Verdict**: Gelijkwaardig - beide minimaal

#### **zoxide** - Lichte configuratie
```yaml
# Individuele role:
zoxide_write_profile_snippet: false  # Optionele shell init
arch_tag: "{{ ansible_architecture }}"
extra_unarchive_opts: ["--strip-components=1"]

# Guix: Geen extra configuratie
packages: ["zoxide"]
```
**Verdict**: Individual role heeft **meer controle** over shell integratie

#### **greenclip** - Minimale configuratie
```yaml
# Individuele role: Alleen basis installatie
asset_regex: "^greenclip$"

# Guix: Identiek
packages: ["greenclip"]
```
**Verdict**: Gelijkwaardig

#### **rust** - **ZEER uitgebreide configuratie** 🎯
```yaml
# Individuele role (161 regels code):
rust_cargo_home: "{{ ansible_env.HOME }}/.local/share/cargo"
rust_rustup_home: "{{ ansible_env.HOME }}/.local/share/rustup"
rust_default_toolchain: "stable"
rust_update_shell_profiles: true
rust_shell_profiles: [".bashrc", ".zshrc"]
rust_components: ["rustfmt", "clippy", "rust-src"]
rust_cargo_packages: []  # Installeer extra cargo tools
rust_cargo_config:       # Cargo performance optimizatie
  registries:
    crates-io:
      protocol: "sparse"
  build:
    jobs: 0
    lto: true
# + XDG paths migratie
# + Package dependency checking  
# + Environment variable management
# + Shell profile updates
# + Toolchain updates
# + Component management

# Guix: Basis installatie
packages: ["rust"]
```
**Verdict**: Individual role heeft **veel meer controle** en XDG compliance

#### **rbw** - **Uitgebreide configuratie** 🎯
```yaml
# Individuele role (64 configuratie variabelen):
rbw_config_dir: "{{ rbw_xdg_config_home }}/rbw"
rbw_update_mode: "auto"
rbw_auto_update: true
rbw_verify_installation: true
rbw_require_pinentry: true
rbw_create_initial_config: false

# Bitwarden configuratie:
rbw_config:
  email: ""
  base_url: "https://api.bitwarden.com/"
  identity_url: "https://identity.bitwarden.com/"
  lock_timeout: 3600
  sync_interval: 3600
  pinentry: "pinentry"

# rofi-rbw integratie:
rofi_rbw_config:
  action: "type"
  target: "password"
  keybindings:
    type_all: "kb-custom-1"
    # ... veel meer keybindings

# Guix: Basis installatie
packages: ["rbw"]
```
**Verdict**: Individual role heeft **veel meer configuratie** mogelijkheden

## 📊 Configuratie Vergelijking Samenvatting

| Tool | Individual Role Complexity | Guix Complexity | Winner |
|------|----------------------------|-----------------|--------|
| **fzf** | 🟢 Minimaal (11 regels) | 🟢 Minimaal | 🤝 Gelijk |
| **zoxide** | 🟡 Licht (33 regels) | 🟢 Minimaal | 🏆 Individual |
| **greenclip** | 🟢 Minimaal (10 regels) | 🟢 Minimaal | 🤝 Gelijk |  
| **rust** | 🔴 Zeer complex (161 regels) | 🟢 Minimaal | 🏆 Individual |
| **rbw** | 🔴 Complex (64+ vars) | 🟢 Minimaal | 🏆 Individual |

## 🎯 **Conclusie**: Ja, je had gelijk!

De complexiteit is inderdaad **veel groter** dan in eerste instantie leek:

### **Rust role** heeft:
- XDG Base Directory compliance
- Automatische migratie van bestaande installaties
- Shell profile management
- Cargo configuratie optimizaties
- Component management (rustfmt, clippy, rust-src)
- Performance tweaks (LTO, sparse registry)

### **rbw role** heeft:
- Complete Bitwarden server configuratie
- rofi integration met keybindings
- XDG compliance
- Auto-update mechanismen
- Security configuraties

## 💡 Herziene Aanbeveling

**Voor basis gebruik**: Guix mode is perfect
**Voor advanced configuratie**: Individual mode biedt veel meer controle

### Hybride aanpak mogelijk:
```yaml
# In group_vars/all.yml
tool_installation_method: "guix"  # Voor meeste tools

# Maar override specifieke tools:
rust_use_individual_role: true   # Voor complexe Rust setup
rbw_use_individual_role: true    # Voor uitgebreide Bitwarden config
```

Dit zou een toekomstige enhancement kunnen zijn - per-tool keuze in plaats van alles-of-niets.

## 🔧 Praktische Stappen

### Migratie van Individual naar Guix:
1. **Backup configuraties** van Rust en rbw
2. **Test Guix versies** om te zien of ze voldoen
3. **Behoud individual roles** voor tools die je intensief configureert
4. **Gebruik Guix** voor eenvoudige tools (fzf, greenclip)

### PATH Cleanup (optioneel):
```bash
# Check wat er overschreven wordt:
which -a fzf zoxide rust rustc cargo rbw greenclip

# Remove oude binaries indien gewenst:
rm ~/.local/bin/{fzf,zoxide,rustc,cargo,rbw,greenclip}
```
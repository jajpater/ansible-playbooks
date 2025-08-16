# Sudo Setup voor Ansible Playbooks

Dit document legt uit hoe je sudo rechten kunt configureren voor het draaien van system-level Ansible playbooks.

## 🔐 Huidige Situatie

Je bent al in de `sudo` groep, maar Ansible heeft een wachtwoord nodig voor sudo operaties. Dit is normaal en veilig.

```bash
$ groups
jajpater adm cdrom sudo dip plugdev users lpadmin
```

## 🚀 Aanbevolen Opties (Van Veilig naar Gemakkelijk)

### **Optie 1: Sudo met Password Prompt (Meest Veilig)**

```bash
# Voor system-level installaties
ansible-playbook root.yml --tags scantailor-advanced --ask-become-pass

# Korte versie
ansible-playbook root.yml --tags scantailor-advanced -K
```

**Voordelen:**
- ✅ Maximale veiligheid
- ✅ Controle over elke sudo operatie
- ✅ Standaard beveiligde setup

**Nadelen:**
- ❌ Moet wachtwoord invoeren bij elke run

### **Optie 2: Sudo Credentials Cachen (Balans)**

```bash
# Cache sudo voor 15 minuten
sudo -v

# Dan binnen 15 minuten Ansible draaien (geen extra prompt)
ansible-playbook root.yml --tags scantailor-advanced
```

**Voordelen:**
- ✅ Geen herhaalde wachtwoord prompts
- ✅ Automatisch vervalt na timeout
- ✅ Relatief veilig

**Nadelen:**
- ❌ Moet elke 15 minuten opnieuw

### **Optie 3: NOPASSWD voor Ansible Operaties (Gemakkelijk)**

```bash
# Specifiek voor Ansible commands
echo "$USER ALL=(ALL) NOPASSWD: /usr/bin/apt-get, /usr/bin/make, /usr/bin/cmake, /usr/bin/git" | sudo tee /etc/sudoers.d/ansible-$USER

# Of algemeen NOPASSWD (minder veilig)
echo "$USER ALL=(ALL) NOPASSWD: ALL" | sudo tee /etc/sudoers.d/$USER
```

**Voordelen:**
- ✅ Geen wachtwoord prompts
- ✅ Werkt automatisch
- ✅ Persistent

**Nadelen:**
- ❌ Minder veilig
- ❌ Permanent (tot handmatig verwijderd)

### **Optie 4: Claude als Root Starten (Development)**

```bash
# Start Claude met root rechten
sudo claude-code

# Dan heeft Claude direct alle rechten
ansible-playbook root.yml --tags scantailor-advanced
```

**Voordelen:**
- ✅ Geen sudo prompts
- ✅ Complete controle
- ✅ Ideaal voor development/testing

**Nadelen:**
- ❌ Claude draait als root (security implicaties)
- ❌ Niet ideaal voor productie

## 🎯 Mijn Aanbeveling

**Voor normale gebruikspatronen**: **Optie 2** (Sudo cachen)

```bash
# Eenmalig per sessie
sudo -v

# Dan gewoon Ansible draaien
ansible-playbook root.yml --tags scantailor-advanced
ansible-playbook user.yml --tags scantailor
ansible-playbook user.yml --tags shell-aliases
```

**Voor development/testing**: **Optie 4** (Claude als root)

```bash
# Terminal 1: Start Claude als root
sudo claude-code

# Dan alle commands werken direct
```

## 🛠️ Complete Installatie Workflow

### **Met Sudo Caching (Aanbevolen)**

```bash
# 1. Cache sudo credentials
sudo -v

# 2. Installeer beide ScanTailor versies
ansible-playbook user.yml --tags scantailor
ansible-playbook root.yml --tags scantailor-advanced  

# 3. Setup shell aliases (als beide geïnstalleerd)
ansible-playbook user.yml --tags shell-aliases

# 4. Test de installatie
st-app --version     # AppImage versie
st-advanced --version # Compiled versie
scantailor           # Smart chooser
```

### **Met Password Prompts**

```bash
# Installeer user-level (geen sudo nodig)
ansible-playbook user.yml --tags scantailor

# Installeer system-level (vraagt sudo wachtwoord)
ansible-playbook root.yml --tags scantailor-advanced -K

# Setup aliases (geen sudo nodig)
ansible-playbook user.yml --tags shell-aliases
```

## 🔒 Veiligheid Overwegingen

### **Veilig**
- Optie 1: Password prompts
- Optie 2: Sudo caching (15 min timeout)

### **Minder Veilig**
- Optie 3: NOPASSWD sudo (permanent)
- Optie 4: Claude als root (session-based)

### **Best Practices**
1. Gebruik Optie 1 of 2 voor dagelijks gebruik
2. Gebruik Optie 4 alleen voor development/testing
3. Vermijd Optie 3 tenzij je de security implications begrijpt
4. Check regelmatig: `sudo -l` om je sudo rechten te zien

## 🧪 Testing

```bash
# Test sudo access
sudo -l

# Test Ansible zonder sudo (should work)
ansible-playbook user.yml --tags scantailor --check

# Test Ansible met sudo (needs password/caching)
ansible-playbook root.yml --tags scantailor-advanced --check -K
```

## 🚨 Troubleshooting

### "sudo: a password is required"
```bash
# Oplossing 1: Use password prompt
ansible-playbook root.yml -K

# Oplossing 2: Cache credentials first
sudo -v
ansible-playbook root.yml
```

### "sudo: no tty present"
```bash
# Start Claude in een echte terminal, niet via IDE
# Of gebruik -K flag
```

### Sudo timeout issues
```bash
# Verleng sudo timeout (tijdelijk)
sudo visudo
# Voeg toe: Defaults timestamp_timeout=60

# Of cache opnieuw
sudo -v
```

## 💡 Pro Tips

1. **Combo approach**: Cache sudo, dan meerdere playbooks draaien
2. **Selective runs**: Gebruik tags om alleen wat je nodig hebt te installeren
3. **Test first**: Gebruik `--check` om te zien wat er zou gebeuren
4. **Monitor progress**: Gebruik `-v` voor verbose output bij problemen

```bash
# Pro workflow
sudo -v                                      # Cache sudo
ansible-playbook user.yml --tags scantailor  # User stuff first
ansible-playbook root.yml --tags scantailor-advanced -v  # Root stuff with verbose
ansible-playbook user.yml --tags shell-aliases  # Cleanup/config
```
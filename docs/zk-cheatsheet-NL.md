# zk Cheatsheet - Nederlands

## 🚀 Snelstart

```bash
# Installeren
ansible-playbook user.yml --tags zk

# Naar notebook navigeren
zkd
cd ~/Documenten/Aantekeningen/zk-default-notebook

# Eerste notitie maken
zkn "Mijn eerste notitie"
```

---

## 📝 Nieuwe Notities

| Commando | Beschrijving |
|----------|-------------|
| `zkn "Titel"` | Nieuwe notitie met titel |
| `zk new --title "Titel"` | Volledige syntax |
| `zk new --group daily` | Dagboek notitie |
| `zk new --group weekly` | Wekelijkse notitie |
| `zk new --group project --title "Project"` | Project notitie |
| `zk new --tag urgent "Dringende taak"` | Notitie met tag |

---

## 📋 Notities Bekijken

| Commando | Beschrijving |
|----------|-------------|
| `zkl` | Alle notities tonen |
| `zk list` | Volledige syntax |
| `zkf` | Interactieve notitie selectie |
| `zk list --interactive` | Volledige interactieve modus |
| `zk list --limit 10` | Toon alleen 10 notities |
| `zk list --sort created-` | Sorteer op aanmaakdatum (nieuwste eerst) |
| `zk list --sort modified-` | Sorteer op wijzigingsdatum |

---

## ✏️ Notities Bewerken

| Commando | Beschrijving |
|----------|-------------|
| `zke` | Interactief notitie bewerken |
| `zk edit --interactive` | Volledige syntax |
| `zk edit "notitie-bestand.md"` | Specifieke notitie bewerken |
| `zk edit --match title "Titel"` | Bewerk op basis van titel |

---

## 🔍 Zoeken en Filteren

### Basis Zoeken
| Commando | Beschrijving |
|----------|-------------|
| `zk list "zoekterm"` | Zoek in alle notities |
| `zk list --match title "woord"` | Zoek alleen in titels |
| `zk list --match-strategy exact "exacte titel"` | Exacte match |

### Datum Filters
| Commando | Beschrijving |
|----------|-------------|
| `zk list --created-after today` | Vandaag aangemaakt |
| `zk list --created-after yesterday` | Sinds gisteren |
| `zk list --created-after "last week"` | Afgelopen week |
| `zk list --modified-after "2 days ago"` | Gewijzigd laatste 2 dagen |

### Tag Filters
| Commando | Beschrijving |
|----------|-------------|
| `zk list --tag project` | Alle notities met #project |
| `zk list --tag project --tag urgent` | Meerdere tags |
| `zk list --exclude-tag draft` | Sluit #draft uit |

---

## 🔗 Links en Relaties

| Commando | Beschrijving |
|----------|-------------|
| `zk list --linked` | Notities met links |
| `zk list --orphan` | Wezen (geen links) |
| `zk list --link-to "titel"` | Wat linkt naar deze notitie |
| `zk list --no-input` | Notities zonder input links |

---

## 📊 Statistieken en Overzichten

| Commando | Beschrijving |
|----------|-------------|
| `zk list --format "{{title}}"` | Alleen titels |
| `zk list --format "{{path}}"` | Alleen bestandspaden |
| `zk list --format "{{tags}}"` | Alleen tags |
| `zk list --format "json"` | JSON uitvoer |
| `zk list --format "{{title}} ({{word-count}} woorden)"` | Custom formaat |

---

## 🏷️ Template Groepen

| Groep | Beschrijving | Template Bestand |
|-------|-------------|-----------------|
| `daily` | Dagboek notities | `daily.md` |
| `weekly` | Wekelijkse overzichten | `weekly.md` |
| `project` | Project planning | `project.md` |
| `default` | Standaard notitie | `default.md` |

**Gebruik:** `zk new --group [groep] --title "Titel"`

---

## 🎯 Handige Aliases (Ingebouwd)

| Alias | Equivalent | Beschrijving |
|-------|-----------|-------------|
| `zkn` | `zk new --title` | Nieuwe notitie |
| `zkl` | `zk list` | Lijst notities |
| `zke` | `zk edit --interactive` | Bewerk interactief |
| `zkf` | `zk list --interactive` | Zoek interactief |
| `zkd` | `cd ~/Documenten/...` | Ga naar notebook |

---

## ⚙️ Configuratie

### Config Locaties
```bash
# Globale config
~/.config/zk/config.toml

# Notebook config  
~/Documenten/Aantekeningen/zk-default-notebook/.zk/config.toml

# Templates
~/Documenten/Aantekeningen/zk-default-notebook/.zk/templates/
```

### Config Shortcuts
| Commando | Beschrijving |
|----------|-------------|
| `zk config` | Toon huidige configuratie |
| `zk init [pad]` | Initialiseer nieuwe notebook |

---

## 📝 Markdown Syntax in Notities

### Links
```markdown
# Interne links
[[andere-notitie]]
[Link tekst](andere-notitie.md)

# Externe links  
[Google](https://google.com)

# Tags
#project #urgent #2024
```

### Template Variabelen
```markdown
# In templates (.zk/templates/*.md)
{{title}}                    # Notitie titel
{{format-date now}}          # Huidige datum
{{format-date now '%Y-%m-%d'}} # Custom datum formaat
{{id}}                       # Unieke ID
{{slug title}}               # URL-vriendelijke titel
```

---

## 🔧 Geavanceerde Commando's

### Combineren van Filters
```bash
# Recente project notities
zk list --tag project --created-after "last month" --sort created-

# Dringende taken van deze week
zk list --tag urgent --created-after "last week" --format "{{title}}"

# Lange notities zoeken
zk list --match-strategy word-count ">500"
```

### Custom Formats
```bash
# Notitie overzicht
zk list --format "📝 {{title}} ({{word-count}} woorden, {{format-date created '%d-%m-%Y'}})"

# Tag overzicht
zk list --format "{{tags}}" | tr ' ' '\n' | sort | uniq -c | sort -nr
```

---

## 🚨 Problemen Oplossen

| Probleem | Oplossing |
|----------|-----------|
| `zk` commando niet gevonden | `source ~/.bashrc` of herstart terminal |
| Geen notities gevonden | Controleer of je in de juiste directory bent (`zkd`) |
| Template werkt niet | Controleer `.zk/templates/` directory |
| Editor opent niet | Controleer `EDITOR` omgevingsvariabele |

### Debug Commando's
```bash
# Controleer installatie
zk --version
which zk

# Controleer configuratie
zk config

# Controleer notebook
ls -la .zk/

# Herindex notebook
zk index --force
```

---

## 💡 Pro Tips

### 1. Efficiënte Workflow
```bash
# Dagelijkse routine
zkd && zk new --group daily

# Wekelijkse review
zkd && zk list --created-after "last week" --sort created-

# Project status
zk list --tag project --format "{{title}} - {{format-date modified '%d-%m'}}"
```

### 2. Batch Operaties
```bash
# Alle project notities bewerken
zk list --tag project --format "{{path}}" | xargs -I {} $EDITOR {}

# Export naar PDF (met pandoc)
zk list --format "{{path}}" | head -10 | xargs -I {} pandoc {} -o {}.pdf
```

### 3. Integratie met Git
```bash
# In je notebook directory
alias zkbackup='git add . && git commit -m "Backup $(date +%Y-%m-%d)"'
alias zkpush='zkbackup && git push'
```

---

## 📚 Snelle Referentie - Format Strings

| Variabele | Beschrijving | Voorbeeld |
|-----------|-------------|-----------|
| `{{title}}` | Notitie titel | "Mijn Notitie" |
| `{{path}}` | Bestandspad | "2024-01-15-1abc-mijn-notitie.md" |
| `{{id}}` | Unieke ID | "1abc" |
| `{{tags}}` | Alle tags | "#project #urgent" |
| `{{created}}` | Aanmaakdatum | "2024-01-15T10:30:00" |
| `{{modified}}` | Wijzigingsdatum | "2024-01-15T15:45:00" |
| `{{word-count}}` | Aantal woorden | "245" |
| `{{format-date created '%d-%m-%Y'}}` | Custom datum | "15-01-2024" |

---

## 🎨 Custom Aliases Toevoegen

Voeg toe aan je `~/.bashrc` of `~/.config/zsh/.zshrc`:

```bash
# Snelle taken
alias todo='zkn "TODO: $(date +%Y-%m-%d)" --tag todo'
alias meeting='zkn "Meeting $(date +%Y-%m-%d)" --tag meeting'

# Zoek shortcuts  
alias zkrecent='zk list --sort created- --limit 5'
alias zktodo='zk list --tag todo'
alias zktoday='zk list --created-after today'

# Project management
alias zkproject='zk list --tag project --format "{{title}} ({{format-date modified '%d-%m'}})"'
```

---

*💾 Save dit cheatsheet als bookmark - je zult het vaak nodig hebben!*

**Meer info:** `docs/README-zk-NL.md` voor uitgebreide documentatie
# zk - Slimme Notitietoepassing

## Inleiding

zk is een krachtige, op de command-line gebaseerde notitietoepassing die gebruik maakt van gewone tekst (markdown) bestanden. Het is ontworpen voor mensen die van eenvoud houden maar toch geavanceerde functionaliteiten willen zoals backlinking, templates, en krachtige zoekfuncties.

## Belangrijkste Voordelen

- 🔗 **Automatische backlinking** - Vindt automatisch verbindingen tussen je notities
- 📝 **Markdown ondersteuning** - Gebruik je favoriete markdown editor
- 🎯 **Template systeem** - Consistente notitiestructuur
- 🔍 **Krachtige zoekmachine** - Vind snel wat je zoekt
- 💻 **Command-line interface** - Snel en efficiënt werken
- 🔧 **Aanpasbaar** - Configureer alles naar je wensen
- 📱 **Editor integratie** - Werkt met vim, nvim, VSCode, enz.

## Installatie

Via deze Ansible role:

```bash
# Installeer zk
ansible-playbook user.yml --tags zk

# Of via de hybride methode
ansible-playbook user.yml --tags guix-tools,zk
```

## Basisgebruik

### Je Eerste Notitie

```bash
# Navigeer naar je notebook
zkd

# Maak een nieuwe notitie
zkn "Mijn eerste notitie"

# Of gebruik de volledige commando
zk new --title "Mijn eerste notitie"
```

### Notities Bekijken en Bewerken

```bash
# Toon alle notities
zkl

# Interactieve notitieselectie
zkf

# Bewerk notities interactief
zke

# Of zoek en bewerk direct
zk edit --interactive
```

### Zoeken in Notities

```bash
# Zoek in alle notities
zk list "zoekterm"

# Zoek in titels
zk list --match-strategy=exact "exacte titel"

# Recente notities
zk list --sort created- --created-after "last week"

# Notities van vandaag
zk list --created-after today
```

## Geavanceerd Gebruik

### Werken met Tags

```bash
# Notities met specifieke tag
zk list --tag project

# Meerdere tags
zk list --tag project --tag urgent

# Alle tags bekijken
zk list --format "{{tags}}" | sort | uniq
```

### Backlinking

zk vindt automatisch verbindingen tussen notities:

```bash
# Toon backlinks voor een notitie
zk list --link-to "notitie-titel"

# Toon alle gelinkte notities
zk list --linked

# Vind wezen (orphaned notities)
zk list --orphan
```

### Templates Gebruiken

```bash
# Nieuwe notitie met template
zk new --group daily

# Project notitie
zk new --group project --title "Nieuw Project"

# Weekoverzicht
zk new --group weekly
```

## Configuratie

### Notebook Structuur

Je standaard notebook bevindt zich in:
```
~/Documents/Aantekeningen/zk-default-notebook/
├── .zk/
│   ├── config.toml          # Notebook configuratie
│   └── templates/           # Je templates
│       ├── default.md
│       ├── daily.md
│       ├── weekly.md
│       └── project.md
└── [je notities hier]
```

### Configuratie Bestand

Het hoofdconfiguratiebestand staat in `~/.config/zk/config.toml`:

```toml
# Standaard notebook
[notebook]
dir = "~/Documents/Aantekeningen/zk-default-notebook"

# Notitie instellingen
[note]
language = "nl"
default-title = "Untitled"
filename = "{{format-date now}}-{{id}}-{{slug title}}"
extension = "md"

# Externe tools
[tool]
editor = "vim"
shell = "zsh"
pager = "less -FIRX"
```

### Eigene Templates Maken

Maak nieuwe templates in `.zk/templates/`:

```markdown
# {{title}}

**Aangemaakt:** {{format-date now}}

## Onderwerp

## Hoofdpunten

- 

## Actie items

- [ ] 

## Tags

#

## Gerelateerde notities
```

## Werkstromen

### Dagelijks Journaal

```bash
# Dagelijkse notitie aanmaken
zk new --group daily

# Of met alias
zkn daily
```

### Project Management

```bash
# Nieuw project
zk new --group project --title "Website Redesign"

# Project notities zoeken
zk list --tag project

# Project status updaten
zk edit --interactive --tag project
```

### Kennisbase Opbouwen

```bash
# Nieuwe kennis notitie
zkn "Linux Commando's"

# Voeg links toe in de tekst:
# [[andere-notitie]] of [Link tekst](andere-notitie.md)

# Vind gerelateerde notities
zk list --link-to "Linux Commando's"
```

### Onderzoek en Studie

```bash
# Onderzoek notitie
zkn "Quantum Computing Basics"

# Voeg bronnen toe in je notitie:
# ## Bronnen
# - [Artikel titel](url)
# - [[gerelateerde-notitie]]

# Zoek alle onderzoek notities
zk list --tag onderzoek
```

## Tips en Tricks

### 1. Consistente Naming

- Gebruik duidelijke, beschrijvende titels
- Houd titels kort maar informatief
- Gebruik dezelfde taal (Nederlands) door je hele notebook

### 2. Effectief Taggen

```markdown
# Gebruik specifieke tags
#linux #commandline #tutorial

# In plaats van algemene tags
#computers #stuff
```

### 3. Backlinking Strategieën

```markdown
# Directe links
Zie ook [[andere-notitie]] voor meer informatie.

# Context links
Voor meer details over [Git workflows](git-workflows.md).

# Tag-based linking
Alle #project gerelateerde notities.
```

### 4. Template Best Practices

- Houd templates simpel en flexibel
- Gebruik Nederlandse veldnamen
- Voeg standaard secties toe die je vaak gebruikt
- Gebruik checkboxes voor actionable items

### 5. Zoeken en Filteren

```bash
# Combineer filters voor krachtig zoeken
zk list --tag project --created-after "last month" --match title

# Gebruik reguliere expressies
zk list --match-strategy=re "^Project"

# Sorteer resultaten
zk list --sort modified- --limit 10
```

### 6. Editor Integratie

Voor Vim/Neovim gebruikers:
```vim
" Voeg deze toe aan je .vimrc
nnoremap <leader>zn :!zk new --title "<C-R>=input('Title: ')<CR>"<CR>
nnoremap <leader>zl :!zk list --interactive<CR>
```

## Problemen Oplossen

### Notities Niet Gevonden

```bash
# Controleer je huidige locatie
pwd

# Navigeer naar je notebook
zkd

# Controleer notebook configuratie
zk config
```

### Template Problemen

```bash
# Controleer beschikbare templates
ls ~/.local/share/zk-default-notebook/.zk/templates/

# Test template syntax
zk new --group daily --dry-run
```

### Zoeken Werkt Niet

```bash
# Rebuild de index
zk index --force

# Controleer of notities de juiste extensie hebben (.md)
ls *.md
```

## Geavanceerde Functies

### LSP Server

Voor editor integratie (autocomplete, jump to definition):

```bash
# Start LSP server
zk lsp

# Configureer je editor om te verbinden met localhost:2017
```

### Alias en Scripts

Voeg deze toe aan je `.bashrc` of `.zshrc`:

```bash
# Snelle notitie met huidige datum
alias today='zk new --group daily'

# Zoek en open in één commando
function zko() {
    local note=$(zk list --format "{{path}}" --interactive)
    [[ -n "$note" ]] && $EDITOR "$note"
}

# Nieuwe notitie met tag
function zknt() {
    local tag="$1"
    shift
    zk new --title "$*" --tag "$tag"
}
```

### Export en Backup

```bash
# Backup je volledige notebook
tar -czf "notebook-backup-$(date +%Y%m%d).tar.gz" ~/Documents/Aantekeningen/

# Export naar andere formaten (met pandoc)
zk list --format "{{path}}" | xargs -I {} pandoc {} -o {}.pdf
```

## Integratie met Andere Tools

### Met Git

```bash
# Initialiseer git in je notebook
cd ~/Documents/Aantekeningen/zk-default-notebook
git init
git add .
git commit -m "Initial notebook setup"

# Dagelijkse backup
alias zkbackup='cd ~/Documents/Aantekeningen/zk-default-notebook && git add . && git commit -m "Daily backup $(date)"'
```

### Met fzf

```bash
# Fuzzy search door notities
alias zkf='zk list --format "{{title}} {{path}}" | fzf | cut -d" " -f2- | xargs $EDITOR'
```

### Met Rofi

```bash
# Rofi launcher voor notities
alias zkr='zk list --format "{{title}}" | rofi -dmenu -p "Notitie:" | xargs -I {} zk edit --interactive --match-strategy=exact "{}"'
```

## Meer Informatie

- **Officiële Website:** https://zk-org.github.io/zk/
- **GitHub Repository:** https://github.com/zk-org/zk
- **Configuratie Documentatie:** https://zk-org.github.io/zk/config/
- **Template Documentatie:** https://zk-org.github.io/zk/template/

## Nederlandse Community

Voor vragen en tips in het Nederlands:
- Gebruik de GitHub Discussions op het hoofdproject
- Deel je Nederlandse templates en workflows
- Draag bij aan Nederlandse documentatie vertalingen
# Guile & Guix Gids voor Beginners 🚀

Deze gids legt uit wat Guile en Guix zijn en hoe je ze kunt gebruiken. Perfect voor mensen die nog nooit van deze tools hebben gehoord!

## Inhoud
- [Wat zijn Guile en Guix?](#wat-zijn-guile-en-guix)
- [Waarom zou je ze willen gebruiken?](#waarom-zou-je-ze-willen-gebruiken)
- [Hoe installeer je programma's?](#hoe-installeer-je-programmas)
- [Basale commando's](#basale-commandos)
- [Wat als er iets misgaat?](#wat-als-er-iets-misgaat)

## Wat zijn Guile en Guix?

### 🐍 Guile (spreek uit: "gail")
**GNU Guile** is een programmeertaal. Je hoeft er niks mee te doen als je alleen maar programma's wilt installeren.

- Het is de programmeertaal waarin Guix is geschreven
- Je kunt er scripts mee schrijven (zoals Python of Bash)
- Het is gebaseerd op Scheme (een variant van Lisp)

**Voor beginners: je hoeft Guile niet te leren om Guix te gebruiken!**

### 📦 Guix (spreek uit: "geeks")
**GNU Guix** is een pakketbeheerder, net zoals `apt` op Ubuntu of de App Store op je telefoon. Maar dan veel slimmer:

- **Veilig**: Als je een programma installeert, kan het andere programma's niet kapotmaken
- **Ongedaan maken**: Je kunt altijd terug naar hoe het eerst was
- **Per gebruiker**: Jij kunt andere programma's hebben dan andere gebruikers
- **Geen conflicten**: Programma's bijten elkaar niet
- **Reproduceerbaar**: Exact dezelfde software op elke computer

**Simpel gezegd: Guix is een super-slimme manier om programma's te installeren.**

## Waarom zou je ze willen gebruiken?

### 🎯 Voordelen van Guix

**Voor gewone gebruikers:**
- Je kunt altijd ongedaan maken wat je hebt geïnstalleerd
- Geen "dependency hell" (conflicterende programma's)
- Je hoeft nooit je hele systeem opnieuw te installeren
- Programma's werken altijd, ook jaren later

**Voor ontwikkelaars:**
- Exact dezelfde ontwikkelomgeving op elke computer
- Gemakkelijk wisselen tussen verschillende versies van tools
- Geen virtuele machines nodig voor isolatie

### 🤔 Nadelen (eerlijk zijn)
- Leercurve: het werkt anders dan `apt` of `snap`
- Minder pakketten beschikbaar dan Ubuntu repos
- Kan soms langzamer zijn
- Meer diskruimte nodig

## Hoe zijn Guile en Guix georganiseerd op dit systeem?

### 🏗️ De Setup van deze Ansible Playbooks

Dit Ansible systeem installeert Guile en Guix op een **hybride manier** - een combinatie van system-wide en user-level installaties. Laten we dit uitleggen:

#### **System-wide (Root niveau)** - Voor alle gebruikers
```
📁 System-wide installaties (door root.yml):
├── /opt/guile-3.0.10/              # Gecompileerde Guile (nieuwste versie)
│   ├── bin/guile                   # Guile executable
│   └── lib/                        # Guile libraries
│
├── /usr/local/bin/guix             # Guix hoofdcommando (symlink)
├── /gnu/store/                     # Guix package store (alle packages)
├── /var/guix/                      # Guix systeem data
│   └── profiles/per-user/root/     # Root's Guix profiel
│
└── /etc/profile.d/                 # Environment setup voor alle users
    ├── guile.sh                    # Guile paths
    └── guix.sh                     # Guix paths
```

#### **User-level (Gebruiker niveau)** - Voor jouw account
```
📁 ~/.guix-profile/                 # Jouw Guix packages (symlink)
├── bin/                           # Binaries die jij hebt geïnstalleerd
├── share/                         # Data (docs, icons, etc.)
└── etc/profile                    # Environment setup script

📁 ~/.local/                       # Gebruiker data
├── bin/                          # User binaries (niet-Guix)
├── share/mu/                     # mu email database
└── state/guix/                   # Guix gebruiker state

📁 ~/.config/guix/                 # Guix configuratie
📁 ~/.cache/guix/                  # Download cache
```

### 🤔 Waarom deze hybride aanpak?

**System-wide installatie voordelen:**
- ✅ Eén Guix daemon voor alle gebruikers (efficiënter)
- ✅ Gedeelde package store (bespaart diskruimte)
- ✅ Stabiele basis installatie
- ✅ Systemd service voor automatisch starten

**User-level installatie voordelen:**
- ✅ Elke gebruiker kan eigen packages installeren
- ✅ Geen sudo nodig voor package management
- ✅ Isolatie tussen gebruikers
- ✅ Makkelijk te verwijderen (gewoon home directory)

### 🔗 Hoe werkt de integratie?

1. **Guile (system-wide)**: Nieuwste versie (3.0.10) gecompileerd in `/opt/guile-3.0.10/`
2. **Guix daemon (system-wide)**: Draait als systemd service voor alle gebruikers
3. **Guix packages (user-level)**: Elke gebruiker heeft eigen profiel in `~/.guix-profile/`

**Environment variables** worden automatisch ingesteld:
```bash
# Voor Guile (system-wide)
export PATH="/opt/guile-3.0.10/bin:$PATH"
export GUILE_LOAD_PATH="/opt/guile-3.0.10/share/guile/3.0.10"

# Voor Guix (user-level)
export GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
```

### 📋 Is dit de beste manier?

**Voor dit systeem: JA!** 

**Waarom deze setup ideaal is:**

✅ **Stabiliteit**: System-wide Guile en daemon zijn stabiel  
✅ **Flexibiliteit**: Users kunnen eigen packages installeren  
✅ **Prestaties**: Gedeelde store, geen duplicatie  
✅ **Onderhoud**: Automatisch via systemd service  
✅ **Veiligheid**: Users kunnen system niet kapotmaken  

**Alternatieven en waarom ze minder goed zijn:**

❌ **Volledig system-wide**: Users hebben sudo nodig voor packages  
❌ **Volledig user-level**: Elke user heeft eigen daemon (inefficient)  
❌ **APT packages**: Oude versies, geen rollback mogelijkheid  

### 🔍 Hoe controleer je de setup?

```bash
# Controleer Guile (system-wide)
which guile                    # Moet /opt/guile-3.0.10/bin/guile zijn
guile --version               # Moet 3.0.10 zijn

# Controleer Guix (system-wide daemon)
systemctl status guix-daemon  # Moet active (running) zijn
which guix                    # Moet /usr/local/bin/guix zijn

# Controleer jouw user profiel
ls -la ~/.guix-profile        # Moet symlink zijn naar /var/guix/profiles/...
guix package --list-installed # Laat jouw packages zien
```

## Hoe installeer je programma's?

### 🚀 Super simpel: alleen een commando nodig

```bash
# Installeer Firefox
guix install firefox

# Installeer meerdere programma's tegelijk
guix install firefox git emacs

# Zoek naar een programma
guix search "text editor"
```

**Dat is het! Geen sudo, geen ingewikkelde configuratie.**

### 📋 Wat er gebeurt achter de schermen

1. Guix downloadt het programma (of bouwt het)
2. Het zet het in een speciale map (`~/.guix-profile`)
3. Het maakt een snelkoppeling zodat je het kunt gebruiken
4. Het onthouddt wat je hebt gedaan (voor ongedaan maken)

### 🎭 Profielen: meerdere "setjes" programma's

Je kunt verschillende "profielen" maken - denk aan verschillende setjes programma's:

```bash
# Maak een profiel voor werk
guix package -p ~/werk-profiel -i libreoffice firefox thunderbird

# Maak een profiel voor gaming  
guix package -p ~/gaming-profiel -i steam discord

# Wissel naar werk-profiel
export GUIX_PROFILE="$HOME/werk-profiel"
. "$GUIX_PROFILE/etc/profile"
```

## Basale commando's

### 🔍 Zoeken en informatie

```bash
# Zoek naar Firefox
guix search firefox

# Zoek naar "tekst editor"
guix search "text editor"

# Bekijk details van een programma
guix show firefox

# Zie wat je hebt geïnstalleerd
guix package --list-installed
```

### 📥 Installeren en verwijderen

```bash
# Installeer een programma
guix install firefox

# Installeer meerdere programma's
guix install firefox git emacs

# Verwijder een programma
guix remove firefox

# Update alle programma's
guix upgrade

# Update alleen Firefox
guix upgrade firefox
```

### 🔄 Ongedaan maken (super handig!)

```bash
# Zie je "geschiedenis" van installaties
guix package --list-generations

# Ga terug naar de vorige versie
guix package --roll-back

# Ga naar een specifieke versie (bijvoorbeeld nummer 5)
guix package --switch-generation=5

# Verwijder oude versies (ouder dan 2 weken)
guix package --delete-generations=2w
```

### 🧹 Opruimen

```bash
# Ruim oude spullen op
guix gc

# Maak minimaal 1GB vrij
guix gc --free-space=1G

# Update Guix zelf
guix pull
```

## Wat als er iets misgaat?

### 😵 "command not found" na installatie

**Probleem:** Je hebt iets geïnstalleerd maar het werkt niet.

**Oplossing:** Start je terminal opnieuw of typ:
```bash
export GUIX_PROFILE="$HOME/.guix-profile"
. "$GUIX_PROFILE/etc/profile"
```

### 🐌 Installatie duurt heel lang

**Probleem:** Guix bouwt alles vanaf de broncode.

**Oplossing:** Meestal wordt het automatisch opgelost. Anders:
```bash
# De Ansible playbooks regelen dit normaal automatisch
ansible-playbook user.yml --tags guix-tools
```

### 💾 Geen diskruimte meer

**Probleem:** Guix bewaart alles, dus het kan vol raken.

**Oplossing:** Ruim regelmatig op:
```bash
# Verwijder alles ouder dan 1 maand
guix package --delete-generations=1m

# Ruim op
guix gc

# Maak 5GB vrij
guix gc --free-space=5G
```

### 🔧 Rare foutmeldingen over "make-session"

**Probleem:** Er zijn conflicten tussen verschillende Guile versies.

**Wat er gebeurt:** De system-wide Guile (3.0.10 in `/opt/guile-3.0.10/`) kan conflicteren met oudere system Guile versies of APT packages.

**Oplossing:** Laat de Ansible playbooks het automatisch oplossen:
```bash
ansible-playbook user.yml --tags guix-tools
```

**Handmatige fix (als de playbook niet werkt):**
```bash
# Check welke Guile versies er zijn
which -a guile
dpkg -l | grep guile

# Zorg dat de juiste versie gebruikt wordt
export PATH="/opt/guile-3.0.10/bin:$PATH"
export GUILE_LOAD_PATH="/opt/guile-3.0.10/share/guile/3.0"
```

### 🚨 Guix daemon problemen

**Probleem:** Guix werkt niet, daemon is gestopt.

**Oplossing:**
```bash
# Check daemon status
sudo systemctl status guix-daemon

# Restart als nodig
sudo systemctl restart guix-daemon

# Check of het werkt
guix --version
```

### 🗂️ Profile/symlink problemen

**Probleem:** `~/.guix-profile` werkt niet goed.

**Oplossing:**
```bash
# Check de symlink
ls -la ~/.guix-profile

# Herstel de symlink (automatisch door playbook)
ansible-playbook user.yml --tags guix-tools

# Of handmatig:
rm ~/.guix-profile
ln -sf /var/guix/profiles/per-user/$(whoami)/guix-profile ~/.guix-profile
```

## Tips voor dagelijks gebruik

### ✅ Goede gewoontes

1. **Regelmatig updaten:**
   ```bash
   guix pull    # Update Guix zelf
   guix upgrade # Update alle programma's
   ```

2. **Regelmatig opruimen:**
   ```bash
   guix package --delete-generations=2w
   guix gc --free-space=1G
   ```

3. **Voor je iets groot installeert, check eerst:**
   ```bash
   guix install --dry-run grote-applicatie
   ```

### 🎯 Handige trucs

1. **Tijdelijke omgeving (super handig voor testen):**
   ```bash
   # Start shell met Python en NumPy
   guix shell python python-numpy
   
   # Verlaat de shell en alles is weer weg
   exit
   ```

2. **Exacte versie installeren:**
   ```bash
   guix install python@3.9
   ```

3. **Zie wat er zou veranderen:**
   ```bash
   guix upgrade --dry-run
   ```

## Cheatsheet: belangrijkste commando's

| Commando | Wat het doet |
|----------|--------------|
| `guix search <term>` | Zoek naar programma's |
| `guix install <prog>` | Installeer programma |
| `guix remove <prog>` | Verwijder programma |
| `guix upgrade` | Update alle programma's |
| `guix package --list-installed` | Laat zien wat je hebt |
| `guix package --roll-back` | Ongedaan maken |
| `guix pull` | Update Guix zelf |
| `guix gc` | Ruim op |
| `guix shell <prog>` | Tijdelijke omgeving |

## Hulp krijgen

- **Nederlandse Ubuntu community**: https://ubuntu-nl.org/
- **Officiele documentatie** (Engels): https://guix.gnu.org/manual/
- **IRC chat**: #guix op libera.chat
- **Email**: help-guix@gnu.org

## Waarom deze hybride setup zo goed is

### 🎯 Specifieke voordelen van dit Ansible systeem

**Voor beginners:**
- ✅ **Automatische setup**: Je hoeft niks handmatig te configureren
- ✅ **Werkt meteen**: Alles is al goed ingesteld na `ansible-playbook`
- ✅ **Geen sudo voor packages**: Installeer wat je wilt zonder admin rechten
- ✅ **Stabiele basis**: System delen kunnen niet kapot door user acties

**Voor gevorderden:**
- ✅ **Nieuwste Guile**: Versie 3.0.10 gecompileerd voor optimale prestaties
- ✅ **Efficiënte daemon**: Eén guix-daemon voor alle users
- ✅ **Gedeelde store**: `/gnu/store` wordt gedeeld, bespaart GB's ruimte
- ✅ **XDG compliant**: Alles op de juiste plek volgens standards

**Vergelijking met andere setups:**

| Setup | Voordelen | Nadelen |
|-------|-----------|---------|
| **Deze hybride** | ✅ Efficiënt ✅ Flexibel ✅ Stabiel | ⚠️ Complexer |
| **Volledig APT** | ✅ Simpel | ❌ Oude versies ❌ Geen rollback |
| **Volledig user** | ✅ Geen root nodig | ❌ Inefficiënt ❌ Elke user eigen daemon |
| **Volledig system** | ✅ Eén configuratie | ❌ Sudo nodig ❌ Minder flexibel |

### 🔧 Hoe de Ansible playbooks dit regelen

**Tijdens `ansible-playbook root.yml`:**
1. Compileert Guile 3.0.10 naar `/opt/guile-3.0.10/`
2. Installeert Guix system-wide naar `/usr/local/bin/guix`
3. Maakt 10 build users (`guixbuilder1` t/m `guixbuilder10`)
4. Start guix-daemon als systemd service
5. Configureert environment variables in `/etc/profile.d/`

**Tijdens `ansible-playbook user.yml --tags guix-tools`:**
1. Maakt user Guix profiel aan
2. Configureert shell environment (zsh/bash)
3. Installeert gewenste tools via Guix
4. Test of alles werkt en lost conflicten op
5. Configureert tool-specifieke settings (bijv. mu4e voor Spacemacs)

## Samenvatting

**Guix in één zin:** Een slimme manier om programma's te installeren die altijd ongedaan te maken is.

**Deze hybride setup in één zin:** Het beste van beide werelden - stabiele system basis met flexibele user packages.

**Waarom het cool is:**
- ✅ Altijd ongedaan te maken
- ✅ Geen conflicten tussen programma's  
- ✅ Werkt voor elke gebruiker apart
- ✅ Exact reproduceerbaar

**Hoe je het gebruikt:**
1. `guix search` om te zoeken
2. `guix install` om te installeren  
3. `guix remove` om te verwijderen
4. `guix package --roll-back` als je spijt hebt

**Als er problemen zijn:**
- Herstart je terminal
- Draai `ansible-playbook user.yml --tags guix-tools`
- Ruim op met `guix gc`

**En vergeet niet:** de Ansible playbooks in deze repository doen het meeste werk automatisch voor je! 🎉

---

*Deze gids is onderdeel van de Ansible automation playbooks. Voor automatische installatie gebruik je gewoon: `ansible-playbook user.yml --tags guix-tools`*
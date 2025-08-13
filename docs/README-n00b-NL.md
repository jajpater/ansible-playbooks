# Ansible-systeemopzet – Beginnersgids 🚀

Deze gids is voor absolute beginners die deze Ansible-playbooks willen gebruiken om hun Ubuntu/Linux‑systeem in te richten.

## Wat dit doet

Deze playbooks installeren en configureren automatisch software op je systeem. Zie het als een “recept” dat je computer elke keer precies zo instelt als jij wilt.

**Twee hoofdcategorieën:**
- **Systeembreed** (admin/sudo-wachtwoord nodig): browsers, systeem­pakketten, enz.
- **Gebruikersniveau** (geen admin nodig): tools in je home-map, lettertypen, enz.

## Vereisten – Dit heb je eerst nodig

### 1. Ansible installeren

Open je terminal en voer deze commando’s één voor één uit:

```bash
# Werk je systeem bij
sudo apt update

# Installeer Ansible
sudo apt install ansible

# Controleer of het gelukt is (moet een versienummer tonen)
ansible --version
```

### 2. Vereiste collecties installeren (optioneel)

```bash
# Ga naar de playbook-map
cd ~/System/ansible-playbooks

# Installeer extra Ansible-collecties
ansible-galaxy collection install -r collections/requirements.yml
```

### 3. Je PATH instellen (belangrijk!)

Veel tools worden geïnstalleerd in `~/.local/bin`. Voeg dit toe aan je PATH zodat je ze kunt gebruiken:

```bash
# Open je shellconfiguratie
nano ~/.zshrc

# Voeg deze regel onderaan toe:
export PATH="$HOME/.local/bin:$PATH"

# Opslaan en afsluiten: Ctrl+X, dan Y, dan Enter

# Herlaad je shellconfiguratie
source ~/.zshrc
```

## Basiscommando’s – Wat je moet typen

### Ga naar de playbook‑map

Begin altijd hier:
```bash
cd ~/System/ansible-playbooks
```

### Controleer wat er zou gebeuren (dry‑run)

Bekijk vóór je iets uitvoert welke wijzigingen zouden plaatsvinden:

```bash
# Bekijk welke systeemwijzigingen zouden worden gedaan
ansible-playbook root.yml -K --check

# Bekijk welke gebruikerswijzigingen zouden worden gedaan
ansible-playbook user.yml --check
```

### Alles installeren

**Systeembrede installatie** (vraagt om je wachtwoord):
```bash
ansible-playbook root.yml -K
```
*De `-K` betekent: “vraag om sudo‑wachtwoord”.*

**Gebruikerstools installeren** (geen wachtwoord nodig):
```bash
ansible-playbook user.yml
```

### Alleen specifieke tools installeren

In plaats van alles te installeren, kun je ook precies kiezen wat je nodig hebt:

**Systeemtools** (met beheerderswachtwoord):
```bash
# Alleen Google Chrome installeren
ansible-playbook root.yml -K --tags chrome

# Alleen basis-systeempakketten installeren
ansible-playbook root.yml -K --tags apt_basics

# Meerdere onderdelen tegelijk
ansible-playbook root.yml -K --tags chrome,regolith
```

**Gebruikerstools** (geen wachtwoord nodig):
```bash
# greenclip (clipboardmanager) installeren
ansible-playbook user.yml --tags greenclip

# Lettertypen installeren
ansible-playbook user.yml --tags source-code-pro

# Ontwikkeltools installeren
ansible-playbook user.yml --tags fzf,zoxide,typst

# Alles wat met development te maken heeft
ansible-playbook user.yml --tags fzf,zoxide,typst,grb,texlive
```

## Beschikbare tools & tags

### Systeemtools (voor `-K` is een wachtwoord nodig)
- `apt_basics` – Essentiële systeempakketten
- `chrome` – Google Chrome-browser
- `regolith` – Regolith-desktopomgeving
- `duplicati` – Back-upsoftware
- `snap` – Snap-pakketten

### Gebruikerstools (geen wachtwoord nodig)
- `source-code-pro` – Source Code Pro-lettertype
- `greenclip` – Clipboardmanager
- `zoxide` – Slim `cd`‑commando
- `fzf` – “Fuzzy” bestandzoeker
- `typst` – Documentpreparatiesysteem
- `grb` – Git‑repository‑browser
- `texlive` – LaTeX‑systeem

## Eerste keer uitvoeren – stap voor stap

1. **Open de terminal** (Ctrl+Alt+T).

2. **Ga naar de juiste map:**
   ```bash
   cd ~/System/ansible-playbooks
   ```

3. **Kijk eerst wat er zou gebeuren:**
   ```bash
   ansible-playbook user.yml --check
   ```

4. **Als dat er goed uitziet, voer dan echt uit:**
   ```bash
   ansible-playbook user.yml
   ```

5. **Voor systeemonderdelen (let op – dit verandert dingen systeembreed):**
   ```bash
   # Eerst een check
   ansible-playbook root.yml -K --check
   
   # Tevreden met de voorgenomen wijzigingen?
   ansible-playbook root.yml -K
   ```

## Veelvoorkomende problemen & oplossingen

### “command not found” na installatie
**Probleem:** Een tool geïnstalleerd maar je kunt hem niet gebruiken.  
**Oplossing:** Zorg dat `~/.local/bin` in je PATH staat (zie stap 3 hierboven) en start je terminal opnieuw.

### “Permission denied”
**Probleem:** Het systeem‑playbook kan niet draaien.  
**Oplossing:** Gebruik de `-K`‑vlag en voer je wachtwoord in wanneer daarom wordt gevraagd.

### “Connection refused” of rate limiting
**Probleem:** Te veel GitHub‑downloads in korte tijd.  
**Oplossing:** Stel een GitHub‑token in:
```bash
# Maak de configmap
mkdir -p ~/.config/ansible

# Maak het omgevingsbestand
echo "GITHUB_TOKEN=your_github_token_here" > ~/.config/ansible/env
```

### Playbook stopt halverwege
**Oplossing:** Voer het simpelweg opnieuw uit – Ansible is slim en slaat onderdelen over die al gedaan zijn.

## Handige commandoreferentie

```bash
# Ga naar de playbooks
cd ~/System/ansible-playbooks

# Alle beschikbare tags tonen
grep -r "tags:" . --include="*.yml"

# Dry‑run van alles
ansible-playbook user.yml --check
ansible-playbook root.yml -K --check

# Alles installeren
ansible-playbook user.yml
ansible-playbook root.yml -K

# Specifieke tools installeren
ansible-playbook user.yml --tags greenclip,fzf
ansible-playbook root.yml -K --tags chrome

# Alleen één tool updaten
ansible-playbook user.yml --tags zoxide

# Met meer output draaien
ansible-playbook user.yml -v
```

## Betekenis van de belangrijkste flags

- `-K` = Vraag om sudo‑wachtwoord (nodig voor systeemwijzigingen)
- `--check` = Dry‑run (laat zien wat er gebeurt, voert niets uit)
- `--tags` = Alleen specifieke onderdelen uitvoeren
- `-v` = “Verbose” (meer gedetailleerde output)
- `-vv` = Nog meer details
- `-vvv` = Maximum aan details (voor debuggen)

## Hulp nodig?

1. **Draai altijd eerst `--check`** om te zien wat er gaat gebeuren.  
2. **Lees de foutmeldingen** – vaak staat daar precies wat er misgaat.  
3. **Controleer of je in de juiste map staat**: `~/System/ansible-playbooks`.
4. **Controleer je rechten** – gebruik `-K` voor systeemtaken.

## Veiligheidstips

- ✅ **Draai altijd eerst `--check`** voordat je echte wijzigingen doorvoert.  
- ✅ **Begin met gebruikerstools** – die zijn veiliger dan systeemtools.  
- ✅ **Installeer één tool tegelijk** als je nog aan het leren bent (`--tags toolnaam`).  
- ⚠️ **Wees voorzichtig met `root.yml`** – dit voert systeembrede wijzigingen uit.  
- ⚠️ **Draai geen willekeurige playbooks** die je niet begrijpt.

Veel plezier met automatiseren! 🎉

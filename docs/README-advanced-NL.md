# README-advanced.md — Ansible systeemopzet (n00b‑uitleg, advanced inhoud) 🚀

Deze handleiding is “advanced” qua **inhoud**, maar legt alles uit op **n00b‑niveau**. Je leert _wat_ je nodig hebt, _waarom_ en _hoe_ je het uitvoert — stap voor stap.

> **Voor wie?** Voor iedereen die met deze playbooks zijn Ubuntu/Linux‑systeem wil inrichten en begrijpen wat er onder de motorkap gebeurt.
>
> **Voorwaarden**: Je hebt Ansible geïnstalleerd (`sudo apt install ansible`) en je werkt in een terminal. Basis Linux‑kennis is voldoende.

---

## Inhoud

1. [Snelstart (samenvatting)](#snelstart-samenvatting)  
2. [Repository‑structuur en basisbestanden](#repository-structuur-en-basisbestanden)  
3. [Wat is een INI‑bestand? (en wat doet `inventory.ini`?)](#wat-is-een-ini-bestand-en-wat-doet-inventoryini)  
4. [Inventory & localhost versus remote hosts](#inventory--localhost-versus-remote-hosts)  
5. [Variabelen & overrides (group_vars, host_vars, `-e`)](#variabelen--overrides-group_vars-host_vars--e)  
6. [Ansible Vault voor secrets](#ansible-vault-voor-secrets)  
7. [Handige `ansible.cfg` (quality‑of‑life)](#handige-ansiblecfg-quality-of-life)  
8. [Tags ontdekken en taken bekijken (zonder uit te voeren)](#tags-ontdekken-en-taken-bekijken-zonder-uit-te-voeren)  
9. [Idempotentie & interactieve installers vermijden](#idempotentie--interactieve-installers-vermijden)  
10. [Platformscope & aannames](#platformscope--aannames)  
11. [Beveiliging & integriteit (checksums, signatures)](#beveiliging--integriteit-checksums-signatures)  
12. [Troubleshooting (veelvoorkomende problemen)](#troubleshooting-veelvoorkomende-problemen)  
13. [Upgrades & onderhoud (versies, rollen, collecties)](#upgrades--onderhoud-versies-rollen-collecties)  
14. [Uninstall & rollback (iets ongedaan maken)](#uninstall--rollback-iets-ongedaan-maken)  
15. [Kwaliteit & tests (`--syntax-check`, `ansible-lint`, Molecule)](#kwaliteit--tests---syntax-check-ansible-lint-molecule)  
16. [Logging & uitvoer](#logging--uitvoer)  
17. [Performance‑tips](#performance-tips)  
18. [Commandoreferentie (uitgebreid)](#commandoreferentie-uitgebreid)  
19. [Appendix A — Voorbeeldbestanden (copy‑paste)](#appendix-a--voorbeeldbestanden-copy-paste)  

---

## Snelstart (samenvatting)

```bash
# Ga naar je repo (pas het pad eventueel aan)
cd "$HOME/System/ansible-playbooks"

# Kijk eerst wat er zou gebeuren (dry-run)
ansible-playbook user.yml --check
ansible-playbook root.yml -K --check  # -K = vraag om sudo-wachtwoord

# Voer daarna echt uit
ansible-playbook user.yml
ansible-playbook root.yml -K
```

Gebruik tags om slechts een deel te draaien:
```bash
ansible-playbook user.yml --list-tags
ansible-playbook user.yml --tags fzf,zoxide
```

---

## Repository‑structuur en basisbestanden

Een logische indeling voorkomt chaos. **Voorbeeld:**

```
ansible-playbooks/
├── ansible.cfg
├── inventory.ini
├── group_vars/
│   └── all.yml
├── host_vars/
│   └── myserver.yml        # optioneel (per host)
├── collections/
│   └── requirements.yml    # optioneel (Ansible Galaxy)
├── roles/                   # optioneel (eigen rollen)
├── files/                   # optioneel (bestanden die je kopieert)
├── templates/               # optioneel (Jinja2 templates)
├── user.yml                 # playbook voor gebruikersniveau
└── root.yml                 # playbook voor systeembreed (sudo nodig)
```

**Wat is wat?**
- **`ansible.cfg`**: centrale instellingen voor Ansible (outputstijl, inventory‑locatie, performance‑tweaks).
- **`inventory.ini`**: lijst van machines/hosts waarop je speelt (inclusief `localhost`).
- **`group_vars/`**: variabelen per groep (bijv. `all.yml` voor alles).
- **`host_vars/`**: variabelen per specifieke host.
- **`files/`** en **`templates/`**: dingen die je wilt kopiëren of genereren op een host.
- **`user.yml`** en **`root.yml`**: de playbooks die je draait.

---

## Wat is een INI‑bestand? (en wat doet `inventory.ini`?)

**INI** is een simpel **tekstformaat** met *secties* en *sleutel=waarde* regels. Voorbeeld:

```ini
[sectienaam]
sleutel=waarde
```

**`inventory.ini`** zegt tegen Ansible: _“op welke host(s) moet ik draaien?”_ en _“hoe verbind ik?”_.

- **Secties** (tussen `[]`) heten in Ansible **hostgroepen**.
- Binnen de sectie zet je **hosts** (bijv. `localhost`, of `server1.mijnnetwerk`).
- Je kunt per host **variabelen** meegeven (rechts van de hostnaam).

Voorbeeld **localhost** (draai alles op je eigen machine, zonder SSH):

```ini
[local]
localhost ansible_connection=local
```

Voorbeeld **remote via SSH** met key:

```ini
[servers]
server1 ansible_host=203.0.113.10 ansible_user=ubuntu
server2 ansible_host=203.0.113.11 ansible_user=ubuntu
```

> **Kort:** `inventory.ini` is je **telefoonboek** voor Ansible. `ansible_connection=local` betekent: “gebruik deze computer zelf, geen SSH”.

---

## Inventory & localhost versus remote hosts

- **Alleen lokaal** draaien:
  ```bash
  ansible-playbook user.yml --limit localhost
  ```

- **Remote host(s)** draaien (vereist SSH‑toegang):
  1) Zorg voor toegang: `ssh ubuntu@203.0.113.10` moet werken (idealiter met key).  
  2) Definieer hosts in `inventory.ini` (zie voorbeeld hierboven).  
  3) Run:
     ```bash
     ansible-playbook root.yml -K --limit server1
     ```

- **Wachtwoord i.p.v. key** (niet aanbevolen, maar kan): `--ask-pass` toevoegen.

---

## Variabelen & overrides (group_vars, host_vars, `-e`)

Ansible‑variabelen maken je playbooks **configureerbaar**.

- **Globale variabelen**: `group_vars/all.yml` (voor alle hosts).
- **Per groep**: `group_vars/servers.yml`
- **Per host**: `host_vars/server1.yml`
- **Runtime override**: `-e key=value` op de CLI (tijdelijk, voor die run).

**Voorbeeld (group_vars/all.yml):**
```yaml
user_home: "{{ lookup('env','HOME') }}"
local_bin: "{{ user_home }}/.local/bin"
install_typst_version: "latest"   # of "1.20.0" voor pinnen
```

**Runtime override:**
```bash
ansible-playbook user.yml -e install_typst_version=1.20.0
```

---

## Ansible Vault voor secrets

Bewaar geheime waardes (tokens, wachtwoorden) **versleuteld** in Git met **Vault**.

**Basishandelingen:**
```bash
# Nieuw versleuteld bestand
ansible-vault create group_vars/all.vault.yml

# Bestaand versleuteld bestand bewerken
ansible-vault edit group_vars/all.vault.yml

# Playbook draaien en om vault-wachtwoord vragen
ansible-playbook root.yml -K --ask-vault-pass
```

**Gebruik in playbooks:**
```yaml
# group_vars/all.vault.yml (inhoud is versleuteld)
github_token: "ghp_xxx..."

# ergens in een taak
env:
  GITHUB_TOKEN: "{{ github_token }}"
```

> **Tip:** commit **nooit** platte wachtwoorden. Vault houdt geheimen versleuteld in je repo.

---

## Handige `ansible.cfg` (quality‑of‑life)

Zet dit in de **repo‑root** als `ansible.cfg`:

```ini
[defaults]
inventory = inventory.ini
stdout_callback = yaml
callbacks_enabled = timer,profile_tasks
interpreter_python = auto_silent
retry_files_enabled = False
pipelining = True
forks = 10

[privilege_escalation]
become = True
```

**Wat betekent dit?**
- `inventory` — waar je inventory staat (zodat je niet steeds `-i` hoeft).
- `stdout_callback=yaml` — nette, leesbare output.
- `callbacks_enabled=timer,profile_tasks` — laat zien hoe lang taken duren.
- `interpreter_python=auto_silent` — minder gezeur over Python‑pad.
- `retry_files_enabled=False` — geen *.retry bestandjes meer.
- `pipelining=True` — sneller via SSH (let op: kan `requiretty` breken op sommige systemen).
- `forks=10` — parallelisme (aantal hosts tegelijk).
- `[privilege_escalation]` — standaard `become` (sudo) toestaan als playbook het vraagt.

---

## Tags ontdekken en taken bekijken (zonder uit te voeren)

Voordat je iets draait, kun je **zien wat er zou gebeuren**:

```bash
ansible-playbook user.yml --list-tags
ansible-playbook user.yml --list-tasks
ansible-playbook user.yml --check
```

- `--list-tags` — welke **tags** zijn beschikbaar?
- `--list-tasks` — welke **taken** zitten erin?
- `--check` — **dry‑run** (geen wijzigingen).

> **Beter dan `grep`**, omdat dit Ansible’s eigen parser gebruikt.

---

## Idempotentie & interactieve installers vermijden

**Idempotent** betekent: een playbook steeds opnieuw draaien levert **geen onnodige changes** op.

**Hulpmiddelen voor idempotentie:**
- Gebruik `creates:` of `removes:` (bij `command`/`shell`) om te voorkomen dat iets telkens draait.
- Zet `changed_when: false` als een taak geen echte wijziging is.
- Bij downloads: gebruik **checksums** en **bestandschecks**.

**Voorbeeld (git‑installer die niet opnieuw moet draaien):**
```yaml
- name: Installeer fzf via git (idempotent)
  git:
    repo: "https://github.com/junegunn/fzf.git"
    dest: "{{ user_home }}/.fzf"
    depth: 1
    update: no
  tags: [fzf]

- name: Run fzf install script non-interactive (eenmalig)
  command: "{{ user_home }}/.fzf/install --all"
  args:
    creates: "{{ user_home }}/.fzf/bin/fzf"
  tags: [fzf]
```

---

## Platformscope & aannames

- Getest/bedoeld voor **Ubuntu** (bij voorkeur **LTS**). Andere distro’s kunnen werken, maar pakketnamen/PPAs verschillen.
- **Zsh** is **niet verplicht**, maar sommige voorbeelden refereren aan `~/.zshrc`. Gebruik anders je shells config.
- Paden gebruiken **`$HOME`** i.p.v. harde `/home/naam` paden.
- Waar mogelijk: **XDG**‑conforme locaties (`~/.config`, `~/.local/bin`, etc.).

---

## Beveiliging & integriteit (checksums, signatures)

Bij `get_url`/`unarchive` is het goed om bestanden te **verifiëren**.

**Checksum‑voorbeeld:**
```yaml
- name: Download typst tarball met checksum
  get_url:
    url: "https://example.org/typst-1.20.0.tar.gz"
    dest: "{{ user_home }}/Downloads/typst-1.20.0.tar.gz"
    checksum: "sha256:3b5d1e...deaf"  # echte sha256 hier invullen
  tags: [typst]
```

**GPG‑signatures** (geavanceerd): verifieer release‑signatures voordat je installeert. Dit vereist extra tooling (gpg‑sleutels importeren, `gpg --verify`). Benoem dit in je security‑beleid als je het nodig hebt.

---

## Troubleshooting (veelvoorkomende problemen)

- **Apt‑lock/dpkg errors**  
  Oorzaak: ander proces (‘Software Updater’) gebruikt APT.  
  Oplossing: wacht even of sluit GUI‑updater; eventueel:
  ```bash
  sudo fuser -v /var/lib/dpkg/lock-frontend
  sudo dpkg --configure -a
  sudo apt -f install
  ```

- **Python‑interpreter melding**  
  Zet in `ansible.cfg`: `interpreter_python = auto_silent`.

- **Snap/PPA hick‑ups**  
  Herhaal `apt update`, controleer PPA‑sleutels, of pin versies.

- **Netwerk/proxy**  
  Stel `http_proxy/https_proxy` in je environment of in Ansible‐vars.

- **“command not found” na installatie**  
  Zorg dat `~/.local/bin` in je PATH staat en open een nieuwe shell.

- **Rate limiting (GitHub)**  
  Gebruik **Vault** om een `github_token` te zetten en exporteer het als env var in je taak.

---

## Upgrades & onderhoud (versies, rollen, collecties)

- **Versies pinnen / updaten**  
  Gebruik een variabele (bijv. `install_typst_version`) en zet die op `"latest"` of op een specifiek nummer.

- **Ansible‑collecties**  
  In `collections/requirements.yml` vastleggen en installeren/updaten met:
  ```bash
  ansible-galaxy collection install -r collections/requirements.yml
  ansible-galaxy collection install -r collections/requirements.yml --upgrade
  ```

- **Rollen**  
  Eigen rollen in `roles/` voor hergebruik; of extern via Galaxy.

- **TeX Live**  
  Als je `tlmgr` gebruikt: houd rekening met distro‑versies vs. upstream TeX Live. Documenteer je keuze en updatepad.

---

## Uninstall & rollback (iets ongedaan maken)

**Volledig automatisch rollbacken** kan niet altijd. Maar je kunt veel **gericht verwijderen**:

```yaml
- name: Verwijder pakket
  apt:
    name: google-chrome-stable
    state: absent
  become: yes

- name: Verwijder PPA
  apt_repository:
    repo: "ppa:regolith-linux/release"
    state: absent
  become: yes

- name: Verwijder bestand/map
  file:
    path: "{{ user_home }}/.local/bin/grb"
    state: absent
```

> **Tip:** maak een `cleanup.yml` waarin je precies definieert wat weg moet per tool.

---

## Kwaliteit & tests (`--syntax-check`, `ansible-lint`, Molecule)

- **Snel checken op syntaxfouten:**
  ```bash
  ansible-playbook user.yml --syntax-check
  ```

- **Stijl/kwaliteit:**
  ```bash
  ansible-lint .
  ```

- **Molecule** (geavanceerd, voor rollen): lokale/CI‑tests draaien in containers of VMs. Handig wanneer je eigen `roles/` maakt.

---

## Logging & uitvoer

- **Verbosity:** `-v`, `-vv`, `-vvv` voor meer details.
- **Timer/profile:** via `ansible.cfg` zie je taak‑timings.
- **Logbestand:** zet een pad met environment‑variabele:
  ```bash
  export ANSIBLE_LOG_PATH="$HOME/ansible.log"
  ansible-playbook user.yml
  ```

> Let op: log kan gevoelige gegevens bevatten. Ruim op of log selectief.

---

## Performance‑tips

- **`forks`** hoger zetten als je veel hosts hebt (niet zinvol op 1 host).
- **`pipelining=true`** in `ansible.cfg` versnelt SSH.
- **`gather_facts`** uitzetten in plays die het niet nodig hebben:
  ```yaml
  - hosts: all
    gather_facts: false
    tasks: ...
  ```
- **`--check` beperkingen**: downloads/PPAs kunnen in check‑mode niet altijd correct simuleren. Vertrouw de output, maar test ook een echte run.
- **Cache**: facts caching kan schelen bij grote inventories (geavanceerd).

---

## Commandoreferentie (uitgebreid)

```bash
# Naar de repo
cd "$HOME/System/ansible-playbooks"

# Inventaris en taken bekijken
ansible-playbook user.yml --list-tags
ansible-playbook user.yml --list-tasks

# Dry-run
ansible-playbook user.yml --check
ansible-playbook root.yml -K --check

# Uitvoeren (gebruiker / systeem)
ansible-playbook user.yml
ansible-playbook root.yml -K

# Alleen localhost
ansible-playbook user.yml --limit localhost

# Variabele override (eenmalig)
ansible-playbook user.yml -e install_typst_version=1.20.0

# Verbose / log
export ANSIBLE_LOG_PATH="$HOME/ansible.log"
ansible-playbook user.yml -vv

# Syntax / lint
ansible-playbook user.yml --syntax-check
ansible-lint .

# Vault
ansible-vault create group_vars/all.vault.yml
ansible-playbook root.yml -K --ask-vault-pass
```

---

## Appendix A — Voorbeeldbestanden (copy‑paste)

### `ansible.cfg`
```ini
[defaults]
inventory = inventory.ini
stdout_callback = yaml
callbacks_enabled = timer,profile_tasks
interpreter_python = auto_silent
retry_files_enabled = False
pipelining = True
forks = 10

[privilege_escalation]
become = True
```

### `inventory.ini`
```ini
[local]
localhost ansible_connection=local

# Voorbeeld van remote servers (SSH keys aanbevolen)
[servers]
server1 ansible_host=203.0.113.10 ansible_user=ubuntu
server2 ansible_host=203.0.113.11 ansible_user=ubuntu
```

### `group_vars/all.yml`
```yaml
user_home: "{{ lookup('env','HOME') }}"
local_bin: "{{ user_home }}/.local/bin"
install_typst_version: "latest"
github_token: "{{ lookup('env', 'GITHUB_TOKEN') | default('', true) }}"
```

### `collections/requirements.yml` (optioneel)
```yaml
---
collections:
  - name: community.general
  - name: ansible.posix
```

### `user.yml` (schets)
```yaml
---
- name: User-level tools
  hosts: local
  gather_facts: false

  vars:
    user_home: "{{ lookup('env','HOME') }}"
    local_bin: "{{ user_home }}/.local/bin"

  tasks:
    - name: Zorg dat ~/.local/bin bestaat
      file:
        path: "{{ local_bin }}"
        state: directory
        mode: "0755"

    - name: Installeer fzf via git (idempotent)
      git:
        repo: "https://github.com/junegunn/fzf.git"
        dest: "{{ user_home }}/.fzf"
        depth: 1
        update: no
      tags: [fzf]

    - name: Run fzf install script non-interactive (eenmalig)
      command: "{{ user_home }}/.fzf/install --all"
      args:
        creates: "{{ user_home }}/.fzf/bin/fzf"
      tags: [fzf]
```

### `root.yml` (schets)
```yaml
---
- name: System-level tools
  hosts: local
  become: true
  gather_facts: true

  tasks:
    - name: Zorg dat apt cache up-to-date is
      apt:
        update_cache: yes
        cache_valid_time: 3600

    - name: Installeer basispakketten
      apt:
        name:
          - curl
          - git
          - build-essential
        state: present
      tags: [apt_basics]

    - name: Verwijder voorbeeldpakket (uninstall demo)
      apt:
        name: google-chrome-stable
        state: absent
      tags: [cleanup]
```

### Voorbeeld: download met checksum (Typst)
```yaml
- name: Download typst tarball met checksum
  get_url:
    url: "https://example.org/typst-{{ install_typst_version }}.tar.gz"
    dest: "{{ user_home }}/Downloads/typst-{{ install_typst_version }}.tar.gz"
    checksum: "sha256:VUL_HIER_DE_ECHTE_SHA256_IN"
  when: install_typst_version != "latest"
  tags: [typst]
```

---

## Tot slot

- Draai **altijd eerst** met `--check` op **localhost**.  
- Gebruik **Vault** voor geheimen.  
- Documenteer je keuzes (versies, PPAs, paden) in `group_vars/all.yml`.  
- Houd het **simpel**, maak daarna pas **rollen** en geavanceerde logica.

Veel succes en plezier met automatiseren! 🎯

# Ansible System Setup (split: root vs user)

Dit project splitst je setup in twee **entrypoints**:
- `root.yml` → alles wat **root** vereist (apt, repos, systemd, /usr/local, etc.).
- `user.yml` → alles dat in **$HOME** staat (dotfiles, tools in `~/.local/bin`, fonts, etc.).

Elke tool of domein heeft een **eigen rol**. Je kunt zo **per programma updaten** via tags, bv.:
```bash
ansible-playbook user.yml -t greenclip
ansible-playbook user.yml -t source-code-pro,grb
ansible-playbook root.yml -t apt_basics
```

## Vereisten
1. Ansible >= 2.14
2. Collections installeren (optioneel, als je er later extra gebruikt):
```bash
ansible-galaxy collection install -r collections/requirements.yml
```

> Tip: Voeg `~/.local/bin` toe aan je PATH in je shell-config.
> Voor Zsh bv. in `~/.zshrc`:
> ```sh
> export PATH="$HOME/.local/bin:$PATH"
> ```

## Gebruik
- **Volledige root-setup:**
```bash
ansible-playbook root.yml -K
```
- **Volledige user-setup:**
```bash
ansible-playbook user.yml
```
- **Alleen bepaalde tools updaten (tags):**
```bash
ansible-playbook user.yml -t greenclip
```

## Nieuwe tool toevoegen
Maak een nieuwe rol onder `roles/tools/<naam>`, bijvoorbeeld:
```
roles/tools/naam/tasks/main.yml
```
Geef de rol **tags** (bv. `[naam]`) en installeer bij voorkeur in `~/.local/opt/<naam>/<versie>` met een symlink naar `~/.local/bin/<naam>`.
Gebruik de helper-rol **`helpers/github_install`** om automatisch de **laatste GitHub-release** te installeren:

```yaml
# roles/tools/fzf/tasks/main.yml
- name: Install naam (GitHub latest)
  include_role:
    name: helpers/github_install
  vars:
    name: "naam"
    repo: "developer/naam"
    asset_regex: "linux.*amd64.*tar.gz$"
    bin_relpath: "naam"
  tags: [naam]
```

> Stel desgewenst `github_token` in (bv. via `--extra-vars` of `group_vars/all.yml`) om GitHub rate limits te vermijden.

## Structuur
```
ansible_project/
  root.yml
  user.yml
  README.md
  ansible.cfg
  collections/
    requirements.yml
  roles/
    base/apt_basics/
      tasks/main.yml
      vars/main.yml
    sys/google_chrome/
      tasks/main.yml
    helpers/github_install/
      tasks/main.yml
      README.md
    tools/source_code_pro/
      tasks/main.yml
    tools/greenclip/
      tasks/main.yml
    tools/grb/
      tasks/main.yml
      vars/main.yml
```

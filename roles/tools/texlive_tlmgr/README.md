# tools/texlive_tlmgr

Installeert **TeX Live** in **user scope** via de upstream `install-tl` installer (zonder GUI) en beheert updates met `tlmgr`.
Geen `apt`-packages → je blijft up-to-date.

## Wat doet deze rol?
- Detecteert **automatisch** het TeX Live **jaar** via `release-texlive.txt` op CTAN (tenzij je `tl_year` zelf zet).
- Downloadt `install-tl-unx.tar.gz` van CTAN en draait een **batch install** op basis van een profiel.
- Installeert in XDG: `~/.local/share/texlive/<jaar>`. (configureerbaar) met gewenste **scheme** (bv. `scheme-small`, `scheme-medium`, `scheme-full`).
- (Optioneel) Schrijft een shell snippet met PATH-exports.
- Maakt/refresh't een symlink `~/.local/share/texlive/current` → `<jaar>`.
- Schrijft een PATH-snippet die naar `.../current/bin/<arch>` wijst (stabiel, geen jaarlijkse edits).
- Stelt `tlmgr`-repository in op `mirror.ctan.org` en draait `tlmgr update --self --all`.
- (Optioneel) Installeert extra collections/pakketten met `tlmgr install`.

## Vereisten
- `perl`, `tar`, `xz` beschikbaar (vaak standaard aanwezig; anders via je root-play installeren, bv. `xz-utils`).
- Netwerktoegang naar CTAN.
- `gather_facts: true` in je play (voor `ansible_architecture` en jaar).

## Variabelen (defaults)
Zie `vars/main.yml` voor alle opties. De belangrijkste:

# Verdere variabelen
```yaml
tl_year: "{{ ansible_date_time.year }}"
texlive_scheme: "scheme-medium"   # bv. scheme-small|scheme-medium|scheme-full
texlive_write_profile_snippet: true
```

# Waar komt TeX Live te staan
- `TEXDIR`: `~/.local/share/texlive/<jaar>`
- `TEXMFLOCAL`: `~/.local/share/texlive/texmf-local`
- `TEXMFVAR`: `~/.local/state/texlive/<jaar>/texmf-var`
- `TEXMFCONFIG`: `~/.config/texlive/<jaar>/texmf-config`
- `TEXMFHOME`: `~/.local/share/texmf`


Met een symlink: ~/.local/share/texlive/current → ~/.local/share/texlive/<jaar>


# Extra's
texlive_collections: []           # bv. ['collection-langdutch','collection-latexextra']
texlive_packages: []              # losse pakketten
tlmgr_repo: "https://mirror.ctan.org/systems/texlive/tlnet"

# Updates
```
texlive_update_after_install: true
```

## Gebruik (voorbeeld in `user.yml`)
```yaml
- role: tools/texlive_tlmgr
  tags: [texlive, tlmgr]
  vars:
    texlive_scheme: "scheme-small"
    texlive_collections:
      - collection-latexextra
    texlive_packages:
      - latexmk
```

Na installatie:
```bash
~/.local/share/texlive/<jaar>/bin/<arch>/tlmgr update --self --all
```


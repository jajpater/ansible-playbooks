# helpers/github_install

Herbruikbare rol om de **laatste GitHub release** van een tool te installeren in de HOME-directory, versie-geïsoleerd.

## Variabelen
- `name` (str): Logische naam (en symlinknaam) van de tool.
- `repo` (str): `owner/repo` op GitHub.
- `asset_regex` (str): Regex om het juiste asset uit de release te kiezen.
- `bin_relpath` (str): Relatief pad naar de binaire in de uitgepakte map. Voor een losse binary gebruik je gewoon de bestandsnaam (bv. `greenclip`).

Optioneel:
- `install_dir` (str): Root installatiedir (default: `~/.local/opt/{{ name }}`).
- `extra_unarchive_opts` (list): Extra opties voor unarchive.

Je kunt een `github_token` meegeven (via `--extra-vars` of `group_vars/all.yml`) om rate-limits te voorkomen.

# tools/wakatime_cli

Installeert **wakatime-cli** (user-scope) vanaf GitHub Releases en zet optioneel een compat-symlink `wakatime` → `wakatime-cli`.  
Schrijft `~/.wakatime.cfg` **alleen** als die nog niet bestaat en er een API key beschikbaar is. 
In principe wordt de API key door chezmoi en rbw (alternatieve bitwarden cli) in .wakatime.cfg gezet via een template.

## Variabelen
```yaml
wakatime_compat_symlink: true
wakatime_config_path: "~/.wakatime.cfg"
wakatime_api_key: ""
```

## Gebruik
In `user.yml`:
```yaml
- role: tools/wakatime_cli
  tags: [wakatime]
```

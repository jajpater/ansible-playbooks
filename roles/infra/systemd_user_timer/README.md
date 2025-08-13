# infra/systemd_user_timer

User-scope systemd **service + timer** om periodiek je Ansible **user-playbook** met gekozen tags te draaien (zonder root).

Zie `vars/main.yml` voor defaults en het voorbeeld in je `user.yml`:
```yaml
- role: infra/systemd_user_timer
  tags: [timers]
```

Handig:
- `systemctl --user list-timers --all`
- `journalctl --user -u ansible-tools-update.service -n 200`
- `systemctl --user start ansible-tools-update.service`

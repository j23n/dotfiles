# Backup systemd user services

Restic-based backup using two repositories: a local machine and offsite storage.

## How it works

Each backup service (local: hourly, offsite: daily):
1. Unlocks the restic repo
2. Backs up `$HOME`
3. Writes a success timestamp to `~/.local/share/backup-timestamps/`
4. Runs `restic forget --prune` to apply the retention policy

On failure, `backup-notify@.service` fires and sends a desktop notification with the last journal output and the time of the last successful backup.

A weekly integrity check (`restic check`) runs for both repos.

## Configuration files

| File | Purpose |
|------|---------|
| `~/.config/restic/local-backup.conf` | Env vars for the local repo (`RESTIC_REPOSITORY`, `RESTIC_PASSWORD_FILE`, `RETENTION_*`) |
| `~/.config/restic/offsite-backup.conf` | Same for the offsite repo |
| `~/.config/restic/exclude.txt` | Paths excluded from backup |
| `~/.ssh/config` | SSH host entries for both backup targets |

## Installation

```bash
# Copy service files
cp backup-*.service backup-*.timer backup-notify@.service ~/.config/systemd/user/

# Install the notification script
install -Dm755 backup-notify ~/.local/bin/backup-notify

# Make SSH_AUTH_SOCK available to user services (if using gpg-agent for SSH)
echo "SSH_AUTH_SOCK=$(gpgconf --list-dirs agent-ssh-socket)" \
    > ~/.config/environment.d/ssh-auth-sock.conf

# Reload and enable timers
systemctl --user daemon-reload
systemctl --user enable --now \
    backup-local.timer \
    backup-offsite.timer \
    backup-local-check.timer \
    backup-offsite-check.timer
```

# Radicle Guide

Radicle is a peer-to-peer, decentralized code collaboration stack built on Git. No central server — repos are replicated across nodes via a gossip protocol. Written in Rust (codename: Heartwood).

## Key Concepts

- **RID** — Repository ID (`rad:z3gqc...`), globally unique, stable
- **DID** — Decentralized Identifier (`did:key:z6Mk...`), Ed25519-based, per-device
- **NID** — Node ID, the Ed25519 public key of a node
- **Delegates** — Users with governance authority (merge patches, manage access)
- **Patches** — Radicle's equivalent of Pull Requests, stored as Git objects (COBs)
- **COBs** — Collaborative Objects (issues, patches) stored as Git commit DAGs with CRDT-like consistency
- **Stored copy** — Bare repo managed by node at `~/.radicle/storage/`
- **Working copy** — Your normal editable git checkout
- **Seeds** — Always-on nodes that replicate repos for availability

## Installation

```bash
curl -sSLf https://radicle.xyz/install | sh
```
Requires: Git 2.34.0+, OpenSSH 9.1+, ssh-agent running.

## Setup

```bash
rad auth              # Create identity (Ed25519 key pair)
rad node start        # Start background daemon
rad self              # Show identity details
```

## Core CLI Commands

### Repository
| Command | Description |
|---|---|
| `rad init` | Init current git repo as Radicle project |
| `rad init --private` | Init as private repo |
| `rad clone rad:<RID>` | Clone from network |
| `rad ls` | List repos |
| `rad .` | Show current repo's RID |
| `rad seed rad:<RID>` | Seed (replicate) a repo |
| `rad sync` | Sync with network |
| `rad sync --fetch` | Force fetch latest |
| `rad publish` | Convert private to public |

### Patches (PRs)
| Command | Description |
|---|---|
| `git push rad HEAD:refs/patches` | Open a new patch |
| `git push rad -o patch.draft HEAD:refs/patches` | Open as draft |
| `git push rad` | Update existing patch |
| `git push rad --force` | Update after amending commits |
| `git push rad -o patch.message="..."` | Add comment with update |
| `rad patch` | List open patches |
| `rad patch show <ID>` | Show patch details |
| `rad patch diff <ID>` | View diff without checkout |
| `rad patch checkout <ID>` | Checkout for review |
| `rad patch --merged` | List merged patches |

### Issues
| Command | Description |
|---|---|
| `rad issue open --title "..." --description "..."` | Create issue |
| `rad issue` | List issues |
| `rad issue show <ID>` | Show issue details |
| `rad issue comment <ID> --message "..."` | Comment |
| `rad issue state --closed <ID>` | Close issue |

### Node
| Command | Description |
|---|---|
| `rad node start` | Start daemon |
| `rad node stop` | Stop daemon |
| `rad node status` | Check status |
| `rad node config edit` | Edit config |

### Identity & Remotes
| Command | Description |
|---|---|
| `rad self` | Show identity |
| `rad remote add <DID> --name <n>` | Add peer remote |
| `rad follow <DID>` | Follow a peer |
| `rad id update --allow <DID>` | Grant private repo access |

## Common Workflows

### Push changes
```bash
git add . && git commit -m "changes"
git push rad main
```

### Create a patch (PR)
```bash
git checkout -b feature
# ... make commits ...
git push rad HEAD:refs/patches
# Editor opens: first line = title, then blank line, then description
```

### Merge a patch (as delegate)
```bash
rad patch checkout <patch-id>
# review/test
git checkout main
git merge patch/<patch-id>
git push rad main
# Radicle auto-detects the merge
```

### Private repos
```bash
rad init --private
rad id update --allow <collaborator-DID>    # grant access
rad id update --allow <seed-node-DID>       # let seed host it
```

## Key Differences from GitHub

| GitHub | Radicle |
|---|---|
| Push to `origin` | Push to `rad` remote (local stored copy, then gossiped) |
| PRs via web UI | Patches via `git push rad HEAD:refs/patches` |
| Merge button | Local `git merge` + `git push rad main` |
| Platform identity | Cryptographic key pair (DID) |
| Always available | Depends on at least one seeder being online |
| Issues in DB | Issues as Git objects (work offline) |
| CI built-in | CI broker + adapters (Woodpecker, GitHub Actions, local) |
| Web UI for everything | CLI primary, Desktop app for GUI, web is read-only |

## Config

File: `~/.radicle/config.json` (or `$RAD_HOME/config.json`)

```json
{
  "node": {
    "alias": "my-node",
    "listen": ["0.0.0.0:8776"],
    "externalAddresses": ["host.example.com:8776"],
    "seedingPolicy": {"default": "block", "scope": "all"}
  }
}
```

## Important Gotchas

1. **ssh-agent required** — All operations need your key loaded in ssh-agent
2. **Node must be running** for any network operation (`rad node start`)
3. **Each device = separate identity** — No multi-device sharing yet
4. **Back up `~/.radicle/keys/`** — Lose key = lose identity forever
5. **Private repos not encrypted** — Privacy via selective replication only
6. **Force push for amended patches** — `git push rad --force`
7. **Web UI is read-only** — Use CLI or Desktop app for interaction
8. **NAT traversal limited** — Nodes behind NAT rely on seed nodes
9. **No built-in GitHub mirroring** — Manual dual-remote setup needed
10. **Per-line review comments** only in Desktop app, not CLI

## References

- https://radicle.xyz/guides/user
- https://radicle.xyz/guides/protocol
- https://radicle.xyz/guides/seeder
- https://radicle.xyz/faq

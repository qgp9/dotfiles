# dotfiles

[![Written with GitHub Copilot](https://img.shields.io/badge/Written%20with-GitHub%20Copilot-blue?logo=githubcopilot&logoColor=white)](https://github.com/features/copilot)

Personal dotfiles managed with [yadm](https://yadm.io).

## Installation

```bash
# Install yadm (if not already installed)
# macOS
brew install yadm

# Debian/Ubuntu
apt install yadm

# Clone the dotfiles into your home directory
yadm clone https://github.com/qgp9/dotfiles

# Install tmux plugins after cloning
bash ~/.config/tmux/tmux-plug.sh install tmux-plugins/tmux-sensible
bash ~/.config/tmux/tmux-plug.sh install jabirali/tmux-tilish
```

> **Note:** yadm clones the repository and checks out files directly into `$HOME`, so each file lands at its proper location (e.g. `~/.config/tmux/tmux.conf`).

---

## What's Included

| Path | Description |
|------|-------------|
| `.config/tmux/tmux.conf` | Inner tmux layer config (prefix `C-a`) |
| `.config/tmux/tmux_base.conf` | Outer/base tmux layer config (prefix `C-q`) |
| `.config/tmux/common.conf` | Shared settings for both layers |
| `.config/tmux/tmux-plug.sh` | Minimal tmux plugin manager |
| `.config/btop/btop.conf` | [btop](https://github.com/aristocratos/btop) system monitor config |
| `.config/htop/htoprc` | [htop](https://htop.dev) system monitor config |
| `bin/tbase` | Script to launch the outer (base) tmux session |

---

## tmux: 2-Layer Setup

Two nested tmux sessions run simultaneously — an outer **BASE** layer and an inner **WING** layer — providing visual separation and independent prefixes.

```
┌─── BASE (tbase / C-q prefix) ──────────────────────────────────┐
│ status: dark grey bg │ [BASE ▸ host:session]                    │
│                                                                   │
│  ┌─── WING (tmux / C-a prefix) ──────────────────────────────┐  │
│  │ status: black bg  │ [WING ▸ host:session]                   │  │
│  │                                                              │  │
│  │   (your actual work happens here)                           │  │
│  └──────────────────────────────────────────────────────────────┘  │
└─────────────────────────────────────────────────────────────────────┘
```

### Starting Sessions

```bash
# Start the outer BASE session
tbase

# Start the inner WING session (inside base, or standalone)
tmux
```

The `tbase` script is a thin wrapper:

```bash
exec tmux -L base -f ~/.config/tmux/tmux_base.conf "$@"
```

It uses a separate server socket (`-L base`) so the two layers never share a server.

---

## Key Bindings

### Shared (both layers)

| Key | Action |
|-----|--------|
| `prefix + m` | Toggle mouse mode on/off |
| `prefix + s` | Toggle synchronize-panes (broadcast to all panes) |
| `prefix + h/j/k/l` | Navigate panes (vim-style) |
| `prefix + H/J/K/L` | Resize panes (repeatable) |
| `prefix + Space` | Next window |
| `prefix + BSpace` | Previous window |
| `prefix + "` | Split pane horizontally (keeps current path) |
| `prefix + %` | Split pane vertically (keeps current path) |
| `prefix + c` | New window (keeps current path) |
| `prefix + A` | Rename current window |
| `prefix + r` | Reload config |

### Copy Mode (vi)

| Key | Action |
|-----|--------|
| `v` | Begin visual selection |
| `y` | Copy selection (or enter line-copy mode) |
| `yy` | Copy current line |
| `Escape` | Exit copy mode |

Copies are forwarded to the system clipboard via **OSC52**, which works over SSH.

### Inner Layer (WING — prefix `C-a`)

| Key | Action |
|-----|--------|
| `prefix + a` | Send prefix to nested tmux |
| `C-a C-a` | Switch to last window |
| `Alt+Enter` | Split bottom-right pane horizontally |
| `Alt+1..9` | Switch workspace (tmux-tilish) |

### Outer Layer (BASE — prefix `C-q`)

| Key | Action |
|-----|--------|
| `prefix + q` | Send prefix to nested base |
| `C-q C-q` | Switch to last window |

---

## tmux-plug

A minimal plugin manager included at `~/.config/tmux/tmux-plug.sh`.

```bash
# Install plugins
bash ~/.config/tmux/tmux-plug.sh install tmux-plugins/tmux-sensible
bash ~/.config/tmux/tmux-plug.sh install jabirali/tmux-tilish

# Update all plugins
bash ~/.config/tmux/tmux-plug.sh update

# List installed plugins
bash ~/.config/tmux/tmux-plug.sh list

# Remove a plugin
bash ~/.config/tmux/tmux-plug.sh remove tmux-sensible
```

Plugins are stored in `~/.config/tmux/plugins/`. The inner `tmux.conf` sources all installed plugins at the end with:

```
run 'bash ~/.config/tmux/tmux-plug.sh source-all'
```

Currently configured plugins:

| Plugin | Purpose |
|--------|---------|
| [tmux-plugins/tmux-sensible](https://github.com/tmux-plugins/tmux-sensible) | Sensible default settings |
| [jabirali/tmux-tilish](https://github.com/jabirali/tmux-tilish) | i3wm-style tiling with `Alt+Number` workspaces |

---

## System Monitors

- **btop** — primary monitor (`btop`). Configured with CPU/memory/network graphs, process tree, and 2-second update interval.
- **htop** — fallback monitor (`htop`). Configured with CPU/memory/swap columns, sorted by CPU usage.

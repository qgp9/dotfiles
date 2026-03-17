#!/usr/bin/env bash
# tmux-plug — minimal tmux plugin manager
# Usage: tmux-plug <install|update|remove|list> [repo_or_name]

set -euo pipefail

PLUGIN_DIR="${TMUX_PLUGIN_DIR:-$HOME/.config/tmux/plugins}"
TMUX_CONF="${TMUX_CONF:-$HOME/.config/tmux/tmux.conf}"

_die()  { echo "error: $*" >&2; exit 1; }
_info() { [[ -n "${TMUX_PLUG_VERBOSE:-}" ]] && echo "==> $*" || true; }

# ── helpers ────────────────────────────────────────────────────────────────

# "user/repo" or full https URL  →  (url, dir_name)
_parse_repo() {
    local spec="$1"
    local url name
    if [[ "$spec" == https://* || "$spec" == git@* ]]; then
        url="$spec"
        name="${spec##*/}"
        name="${name%.git}"
    elif [[ "$spec" == */* ]]; then
        url="https://github.com/${spec%.git}.git"
        name="${spec##*/}"
    else
        _die "specify repo as 'user/repo', full URL, or use 'remove/list' with a plugin name"
    fi
    echo "$url" "$name"
}

# Source every *.tmux run-shell script found in a plugin dir
_source_plugin() {
    local dir="$1"
    local script rc
    while IFS= read -r -d '' script; do
        _info "run-shell: $script"
        bash "$script" && continue
        rc=$?
        echo "warn: $script exited $rc" >&2
    done < <(find "$dir" -maxdepth 2 -name "*.tmux" -type f -print0) || true
}

# ── commands ───────────────────────────────────────────────────────────────

cmd_install() {
    [[ $# -ge 1 ]] || _die "usage: tmux-plug install <user/repo> [user/repo ...]"
    mkdir -p "$PLUGIN_DIR"
    local spec url name dest
    for spec in "$@"; do
        read -r url name < <(_parse_repo "$spec")
        dest="$PLUGIN_DIR/$name"
        if [[ -d "$dest/.git" ]]; then
            _info "$name already installed — run 'update' to refresh"
            continue
        fi
        _info "installing $name from $url"
        git clone --depth=1 "$url" "$dest"
        _source_plugin "$dest"
        _info "$name installed"
    done
}

cmd_update() {
    local targets=()
    if [[ $# -eq 0 ]]; then
        while IFS= read -r -d '' d; do
            [[ -d "$d/.git" ]] && targets+=("$d")
        done < <(find "$PLUGIN_DIR" -mindepth 1 -maxdepth 1 -type d -print0 2>/dev/null)
        [[ ${#targets[@]} -gt 0 ]] || { _info "no plugins installed"; return; }
    else
        for name in "$@"; do
            local d="$PLUGIN_DIR/$name"
            [[ -d "$d/.git" ]] || _die "$name not found in $PLUGIN_DIR"
            targets+=("$d")
        done
    fi

    local d
    for d in "${targets[@]}"; do
        local name="${d##*/}"
        _info "updating $name"
        git -C "$d" pull --ff-only --depth=1
        _source_plugin "$d"
        _info "$name updated"
    done
}

cmd_remove() {
    [[ $# -ge 1 ]] || _die "usage: tmux-plug remove <name> [name ...]"
    local name dest
    for name in "$@"; do
        dest="$PLUGIN_DIR/$name"
        [[ -d "$dest" ]] || _die "$name not found in $PLUGIN_DIR"
        rm -rf "$dest"
        _info "$name removed"
    done
}

cmd_list() {
    [[ -d "$PLUGIN_DIR" ]] || { _info "plugin dir not found: $PLUGIN_DIR"; return; }
    local found=0
    local d name remote
    while IFS= read -r -d '' d; do
        name="${d##*/}"
        if [[ -d "$d/.git" ]]; then
            remote=$(git -C "$d" remote get-url origin 2>/dev/null || echo "(unknown)")
            printf "  %-30s  %s\n" "$name" "$remote"
            found=1
        fi
    done < <(find "$PLUGIN_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
    [[ $found -eq 1 ]] || _info "no plugins installed"
}

# run-shell wrapper: call from tmux.conf instead of 'run-shell "plugin/plugin.tmux"'
#   run-shell "~/.config/tmux/plugins/tmux-plug source tmux-sensible"
cmd_source() {
    [[ $# -ge 1 ]] || _die "usage: tmux-plug source <name> [name ...]"
    local name dest
    for name in "$@"; do
        dest="$PLUGIN_DIR/$name"
        [[ -d "$dest" ]] || { echo "warn: $name not installed, skipping" >&2; continue; }
        _source_plugin "$dest"
    done
}

# Source all installed plugins (put at the end of tmux.conf)
#   run-shell "~/.config/tmux/plugins/tmux-plug source-all"
cmd_source_all() {
    [[ -d "$PLUGIN_DIR" ]] || return 0
    local d
    while IFS= read -r -d '' d; do
        [[ -d "$d/.git" ]] && _source_plugin "$d"
    done < <(find "$PLUGIN_DIR" -mindepth 1 -maxdepth 1 -type d -print0 | sort -z)
    return 0
}

# ── dispatch ───────────────────────────────────────────────────────────────

CMD="${1:-}"; shift || true
case "$CMD" in
    install)    cmd_install    "$@" ;;
    update)     cmd_update     "$@" ;;
    remove)     cmd_remove     "$@" ;;
    list)       cmd_list ;;
    source)     cmd_source     "$@" ;;
    source-all) cmd_source_all ;;
    *) cat >&2 <<'EOF'
tmux-plug — minimal tmux plugin manager

Commands:
  install   <user/repo> [...]   clone & source plugins
  update    [name ...]          git pull (all if no args)
  remove    <name> [...]        delete plugin directory
  list                          show installed plugins
  source    <name> [...]        run *.tmux scripts for named plugins
  source-all                    run *.tmux scripts for all plugins

tmux.conf integration:
  run-shell "~/.config/tmux/plugins/tmux-plug source-all"
EOF
    exit 1 ;;
esac

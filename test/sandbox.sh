#!/bin/sh
# Test these dotfiles against a throwaway HOME. Never touches your real
# environment: HOME and all XDG dirs are redirected into a temp directory, and
# package-install scripts are skipped.
#
#   test/sandbox.sh          # preview: config + managed set + diff (writes nothing)
#   test/sandbox.sh apply    # apply into the sandbox HOME (scripts skipped)
#   KEEP=1 test/sandbox.sh   # keep the sandbox dir afterwards for inspection
#
# Run it on whichever OS you want to check (macOS, Linux, or WSL); the gating
# is evaluated for that OS.
set -eu

REPO=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
MODE=${1:-diff}

D=$(mktemp -d)
SBHOME="$D/home"; mkdir -p "$SBHOME"
CFGDIR="$D/cfg"; CFG="$CFGDIR/chezmoi/chezmoi.toml"

# Locate chezmoi, or fetch it into the sandbox so nothing global is installed.
if command -v chezmoi >/dev/null 2>&1; then
    CM=$(command -v chezmoi)
elif [ -x "$HOME/.local/bin/chezmoi" ]; then
    CM="$HOME/.local/bin/chezmoi"
else
    echo "Fetching chezmoi into sandbox..."
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$D/bin" >/dev/null
    CM="$D/bin/chezmoi"
fi

cm() {
    env HOME="$SBHOME" \
        XDG_CONFIG_HOME="$CFGDIR" XDG_DATA_HOME="$D/data" XDG_CACHE_HOME="$D/cache" \
        "$CM" "$@"
}

printf 'sandbox : %s\nchezmoi : %s\nsource  : %s\n\n' "$D" "$CM" "$REPO"

cm init --source "$REPO" --promptDefaults

# Pin sourceDir so later commands resolve the repo without --source.
tmp="$CFG.tmp"; { printf 'sourceDir = "%s"\n' "$REPO"; cat "$CFG"; } > "$tmp" && mv "$tmp" "$CFG"

echo "=== config data ==="; sed -n '/\[data\]/,$p' "$CFG"; echo
echo "=== managed targets (post-gating) ==="; cm managed; echo

case "$MODE" in
    diff)
        echo "=== diff against empty sandbox (nothing written) ==="
        cm diff || true
        ;;
    apply)
        echo "=== apply into sandbox (package scripts skipped) ==="
        cm apply --exclude=scripts
        echo "--- resulting tree ---"
        find "$SBHOME" -maxdepth 3 | sed "s#$SBHOME#~#" | sort
        ;;
    *) echo "usage: $0 [diff|apply]" >&2; exit 2 ;;
esac

echo
echo "=== package script that WOULD run on this OS (previewed, not executed) ==="
cm execute-template < "$REPO/home/run_once_before_10-install-packages.sh.tmpl" 2>/dev/null | grep -v '^$' | head -40 || true

if [ "${KEEP:-0}" = "1" ]; then
    printf '\nkept sandbox: %s\n' "$D"
else
    rm -rf "$D"
fi

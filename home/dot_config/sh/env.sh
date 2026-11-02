# Environment shared by bash and zsh: PATH, editor, tool settings. fish can't
# read this, so config.fish keeps its own copy; keep the two in sync.
#
# Sourced by ~/.bash_profile, ~/.bashrc and ~/.zshrc, so it runs more than once
# per shell and again in nested shells. Everything here must be idempotent.

# Drop repeated PATH entries, keeping the first. Directories below are added to
# the front unconditionally and deduped once at the end, so re-adding one moves
# it forward and PATH stays the same when this runs again. This also removes
# duplicates from macOS path_helper or rustup's ~/.zshenv. Parsed by hand
# because zsh doesn't word-split $PATH; works in bash 3.2 (macOS) too.
__path_dedup() {
	local rest="$PATH:" dir out=":"
	while [[ -n $rest ]]; do
		dir=${rest%%:*}
		rest=${rest#*:}
		[[ -z $dir || $out == *":$dir:"* ]] || out="$out$dir:"
	done
	out=${out#:}
	PATH=${out%:}
}

# Homebrew sets MANPATH, HOMEBREW_PREFIX and friends. Skip it once it's been
# run, e.g. in a shell started from another shell.
if [[ -z ${HOMEBREW_PREFIX-} ]]; then
	if [[ -x /opt/homebrew/bin/brew ]]; then
		eval "$(/opt/homebrew/bin/brew shellenv)"
	elif [[ -x /usr/local/bin/brew ]]; then
		eval "$(/usr/local/bin/brew shellenv)"
	fi
fi
# Re-add its bin dirs every time: in a zsh login shell, path_helper moves the
# system dirs ahead of them even when HOMEBREW_PREFIX was inherited.
if [[ -n ${HOMEBREW_PREFIX-} ]]; then
	PATH="$HOMEBREW_PREFIX/bin:$HOMEBREW_PREFIX/sbin:$PATH"
fi

# Same order as fish ends up with: the last one added comes first.
PATH="$HOME/.local/bin:$PATH"
PATH="$HOME/.cargo/bin:$PATH"
PATH="$HOME/.bin:$PATH"
# Scripts from the nixpulvis.com repo (e.g. scribe), on machines that have it.
# The code directory is ~/Code on some machines and ~/code on others.
for __dir in "$HOME/Code" "$HOME/code"; do
	if [[ -d $__dir/nixpulvis.com/bin ]]; then
		PATH="$__dir/nixpulvis.com/bin:$PATH"
		break
	fi
done
unset __dir
PATH="/usr/local/bin:$PATH"
PATH="$HOME/.rbenv/bin:$PATH"
__path_dedup
export PATH

export EDITOR=nvim
export VISUAL=nvim
export PIPX_HOME="$HOME/.local/pipx"

# Rust src from the active toolchain. Asking rustc is slow, so nested shells
# reuse the inherited value.
if [[ -z ${RUST_SRC_PATH-} ]] && command -v rustc >/dev/null 2>&1; then
	export RUST_SRC_PATH="$(rustc --print sysroot)/lib/rustlib/src/rust/library"
fi

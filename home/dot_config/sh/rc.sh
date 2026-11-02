# Interactive setup shared by bash and zsh: aliases, fzf, rbenv, git prompt
# helpers, greeting. fish can't read this, so config.fish keeps its own copy;
# keep the two in sync. Sourced by ~/.bashrc and ~/.zshrc after env.sh. Each
# shell's own rc builds its prompt from the helpers here.

if [[ -n ${ZSH_VERSION-} ]]; then __sh=zsh; else __sh=bash; fi

# Update dotfiles, always regenerating the per-machine config from its template
# so it never goes stale (reuses saved answers, so no re-prompt). Plain
# `chezmoi apply` is still backstopped by the config drift-check banner.
alias czup='chezmoi update --init'

# List with eza where it's installed. Same flags as config.fish; see the notes
# there. Without eza, l/ll/la match fish's ls versions and there's no lt/lat.
if command -v eza >/dev/null 2>&1; then
	__eza_long='eza -l --git --time-style=long-iso -g --smart-group --classify=auto'
	alias l="$__eza_long"
	alias ll="$__eza_long"
	alias la="$__eza_long -a"
	alias lt="$__eza_long --tree"
	alias lat="$__eza_long -a --tree"
	unset __eza_long
else
	alias l='ls -l'
	alias ll='ls -lh'
	alias la='ls -lAh'
fi

# fzf key bindings: ctrl-r history, ctrl-t file paths, alt-c cd. Same settings
# as config.fish; see the notes there. `fzf --bash`/`--zsh` needs fzf 0.48+,
# so older versions are skipped instead of failing. It also adds fuzzy
# completion: type ** then Tab (vim **, cd src/**, kill **, ssh **). bash 3.2
# (macOS) can't hook every command, so there ** works only after fzf's list of
# common ones (cat, vim, git, ls, cd, ...; not echo).
if command -v fzf >/dev/null 2>&1; then
	if __fzf_init=$(fzf --$__sh 2>/dev/null); then
		eval "$__fzf_init"
	fi
	unset __fzf_init
	# Selected line text in bright blue. fzf's default (color 254) is one of
	# the indexes our Alacritty palette sets to #FF0000.
	export FZF_DEFAULT_OPTS='--color=fg+:12'
	if command -v fd >/dev/null 2>&1; then
		export FZF_DEFAULT_COMMAND='fd --type f --hidden --exclude .git'
		export FZF_CTRL_T_COMMAND='fd --hidden --exclude .git'
		export FZF_ALT_C_COMMAND='fd --type d --hidden --exclude .git'
		# ** completion lists. $1 is the directory typed before the **.
		_fzf_compgen_path() { fd --hidden --exclude .git . "$1"; }
		_fzf_compgen_dir() { fd --type d --hidden --exclude .git . "$1"; }
	fi
	if command -v bat >/dev/null 2>&1 && command -v eza >/dev/null 2>&1; then
		export FZF_CTRL_T_OPTS="--preview 'test -d {} && eza --tree --level=2 --color=always {} || bat --color=always --style=numbers --line-range=:200 {}'"
		export FZF_ALT_C_OPTS="--preview 'eza --tree --level=2 --color=always {}'"
	fi
fi

if command -v rbenv >/dev/null 2>&1; then
	eval "$(rbenv init - $__sh)"
fi
unset __sh

if command -v ssh-agent >/dev/null 2>&1 && [[ -z ${SSH_AUTH_SOCK-} ]]; then
	eval "$(ssh-agent -s)" >/dev/null
fi

# Remap caps lock to escape on a Linux console.
# See also .config/sway/config input "type:keyboard".
if command -v setxkbmap >/dev/null 2>&1 && [[ ${XDG_SESSION_TYPE-} == tty ]]; then
	setxkbmap -option caps:escape
fi

# Load __git_ps1. Its location varies by platform.
if ! type __git_ps1 >/dev/null 2>&1; then
	if [[ ${OSTYPE-} == msys ]]; then
		# Git Bash: git-prompt.sh ships alongside git's own install. Git for
		# Windows' /etc/profile.d/git-prompt.sh normally loads it with its
		# default prompt; since we replace that prompt, load it ourselves.
		__git_completion="$(git --exec-path 2>/dev/null)"
		__git_completion="${__git_completion%/libexec/git-core}"
		__git_completion="${__git_completion%/lib/git-core}"
		__git_completion="$__git_completion/share/git/completion"
		[[ -f $__git_completion/git-completion.bash ]] && . "$__git_completion/git-completion.bash" 2>/dev/null
		[[ -f $__git_completion/git-prompt.sh ]] && . "$__git_completion/git-prompt.sh"
		unset __git_completion
	else
		for __f in \
			/usr/share/git/completion/git-prompt.sh \
			/usr/lib/git-core/git-sh-prompt \
			/usr/share/git-core/contrib/completion/git-prompt.sh \
			/opt/homebrew/etc/bash_completion.d/git-prompt.sh \
			/usr/local/etc/bash_completion.d/git-prompt.sh \
			/Library/Developer/CommandLineTools/usr/share/git-core/git-prompt.sh
		do
			[[ -f $__f ]] && { . "$__f"; break; }
		done
		unset __f
	fi
fi

# No git-prompt.sh found: fall back to a prompt without the git segment.
if ! type __git_ps1 >/dev/null 2>&1; then
	__git_ps1() { PS1="$1$2"; }
fi

# Match the fish dotfiles git settings.
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWCOLORHINTS=1

# fish prompt_pwd: shorten every path component except the last to one char.
# The ~ comes from a variable because a literal one in the replacement keeps
# its backslash or gets expanded, depending on the shell and version.
__prompt_pwd() {
	local tilde='~'
	local p="${PWD/#$HOME/$tilde}"
	printf '%s' "$p" | sed -e 's|\([^/]\)[^/]*/|\1/|g'
}

# fish_greeting.
command -v fortune >/dev/null 2>&1 && fortune
echo "><_> tick... tock..."

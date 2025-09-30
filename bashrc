# .bashrc

###########################
#  Essential Shell Stuff  #
###########################

export PATH="$HOME/.local/bin:$PATH"
set +h
[[ $- == *i* ]] && bind -f ~/.inputrc

shopt -s histappend
HISTCONTROL=ignoreboth
HISTSIZE=32768
HISTFILESIZE="${HISTSIZE}"

if [[ ! -v BASH_COMPLETION_VERSINFO && -f /usr/share/bash-completion/bash_completion ]]; then
  source /usr/share/bash-completion/bash_completion
fi

export SUDO_EDITOR="$EDITOR"
export BAT_THEME=ansi

force_color_prompt=yes
color_prompt=yes

if command -v mise &> /dev/null; then
  eval "$(mise activate bash)"
fi

if command -v starship &> /dev/null; then
  eval "$(starship init bash)"
fi

if command -v zoxide &> /dev/null; then
  eval "$(zoxide init bash)"
fi

if command -v fzf &> /dev/null; then
  if [[ -f /usr/share/fzf/completion.bash ]]; then
    source /usr/share/fzf/completion.bash
  fi
  if [[ -f /usr/share/fzf/key-bindings.bash ]]; then
    source /usr/share/fzf/key-bindings.bash
  fi
fi

###########################
#  Filesystem Navigation  #
###########################

alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias cd="zd"
zd() {
  if [ $# -eq 0 ]; then
    builtin cd ~ && return
  elif [ -d "$1" ]; then
    builtin cd "$1"
  else
    z "$@" && printf "\U000F17A9 " && pwd || echo "Error: Directory not found"
  fi
}
open() {
  xdg-open "$@" >/dev/null 2>&1 &
}

alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../../'
alias docs="cd ~/Documents"
alias dl="cd ~/Downloads"

repo() {
    local SRC_DIRECTORY="${1:-$HOME/src}"
    local repo=$(
        find "${SRC_DIRECTORY}" \
            -mindepth 1 \
            -maxdepth 3 \
            -type d \
            -exec test -d "{}/.git" \; -print \
        | sed "s|${SRC_DIRECTORY}/||" \
        | fzf \
            --preview "([ -f $SRC_DIRECTORY/{}/README.md ] && bat --style=plain --color=always $SRC_DIRECTORY/{}/README.md || echo 'No README'; echo; git -C $SRC_DIRECTORY/{} status --short --branch)" \
            --preview-window=up:60%) \
        || return
    cd "${SRC_DIRECTORY}/$repo" || { echo "Failed to cd"; return; }
}

###########################
#      Miscellaneous      #
###########################

compress() { tar -czf "${1%/}.tar.gz" "${1%/}"; }
alias decompress="tar -xzf"


source ~/.local/share/omarchy/default/bash/rc

alias docs="cd ~/Documents"

repo() {
    local SRC_DIRECTORY="${1-$HOME/src}"
    local repo=$(find "${SRC_DIRECTORY}" -mindepth 3 -maxdepth 3 -type d \
    | sed "s|${SRC_DIRECTORY}/||" \
    | fzf \
        --preview "([ -f $SRC_DIRECTORY/{}/README.md ] && bat --style=plain --color=always $SRC_DIRECTORY/{}/README.md || echo 'No README'; echo; git -C $SRC_DIRECTORY/{} status --short --branch)" \
        --preview-window=up:60%) \
    || return
    cd "${SRC_DIRECTORY}/$repo" || { echo "Failed to cd"; return; } 
}

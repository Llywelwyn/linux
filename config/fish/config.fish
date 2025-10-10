# config.fish

###########################
#  Essential Shell Stuff  #
###########################

set -Ux PATH $HOME/.local/bin $PATH
set -Ux PATH $HOME/.cargo/bin $PATH

if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

if type -q fzf
    if test -f /usr/share/fzf/completion.fish
        source /usr/share/fzf/completion.fish
    end
    if test -f /usr/share/fzf/key-bindings.fish
        source /usr/share/fzf/key-bindings.fish
    end
end

set -Ux BAT_THEME ansi

###########################
#  Filesystem Navigation  #
###########################

alias ls='eza -lh --group-directories-first --icons=auto'
alias lsa='ls -a'
alias lt='eza --tree --level=2 --long --icons --git'
alias lta='lt -a'
alias ff="fzf --preview 'bat --style=numbers --color=always {}'"
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../../'

function cd
    if test (count $argv) -eq 0
        builtin cd ~
    else if test -d $argv[1]
        builtin cd $argv[1]
    else
        z $argv
        and printf "\U000F17A9 "
        pwd
        or echo "Error: Directory not found"
    end
end

function open
    xdg-open $argv >/dev/null 2>&1 &
end

if test -f "$HOME/.config/user-dirs.fish"
    source "$HOME/.config/user-dirs.fish"
end

alias dcim="cd ~/dcim"
alias docs="cd $XDG_DOCUMENTS_DIR; or cd ~/Documents"
alias notes="cd $XDG_DOCUMENTS_DIR/lib; or cd ~/Documents/lib; ls"
alias dl="cd $XDG_DOWNLOAD_DIR; or cd ~/Downloads"
alias dt="cd $XDG_DESKTOP_DIR; or cd ~/Desktop"
alias music="cd $XDG_MUSIC_DIR; or cd ~/Music"
alias pics="cd $XDG_PICTURES_DIR; or cd ~/Pictures"
alias vids="cd $XDG_VIDEOS_DIR; or cd ~/Videos"

function repo
    if test (count $argv) -ge 1
        set SRC_DIRECTORY $argv[1]
    else
        set SRC_DIRECTORY $HOME/src
    end
    set repo (find $SRC_DIRECTORY -mindepth 1 -maxdepth 3 -type d -exec test -d "{}/.git" \; -print \
        | fzf --preview "([ -f {}/README.md ] && bat --style=plain --color=always {}/README.md || echo 'No README'; echo; git -C {} status --short --branch)" --preview-window=up:60%)
    or return
    cd $repo
end

###########################
#      Miscellaneous      #
###########################

function compress
    tar -czf "$argv[1].tar.gz" "$argv[1]"
end
alias decompress="tar -xzf"

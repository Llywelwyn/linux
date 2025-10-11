set -x PATH $HOME/.local/bin $PATH
set -x PATH $HOME/.cargo/bin $PATH

if type -q starship
    starship init fish | source
end

if type -q zoxide
    zoxide init fish | source
end

set -x BAT_THEME ansi

if test -f "$HOME/.config/fish/user-dirs.fish"
    source "$HOME/.config/fish/user-dirs.fish"
end

if test -d "$HOME/.config/fish/"
    alias fishconf="cd $HOME/.config/fish"
end

alias dcim="cd ~/dcim"
alias docs="cd $XDG_DOCUMENTS_DIR; or cd ~/Documents"
alias notes="cd $XDG_DOCUMENTS_DIR/lib; or cd ~/Documents/lib; ls"
alias dl="cd $XDG_DOWNLOAD_DIR; or cd ~/Downloads"
alias dt="cd $XDG_DESKTOP_DIR; or cd ~/Desktop"
alias music="cd $XDG_MUSIC_DIR; or cd ~/Music"
alias pics="cd $XDG_PICTURES_DIR; or cd ~/Pictures"
alias vids="cd $XDG_VIDEOS_DIR; or cd ~/Videos"

abbr -a -- .. 'cd ..'
abbr -a -- ... 'cd ../..'
abbr -a -- .... 'cd ../../..'
abbr -a -- ..... 'cd ../../../..'

function last_history_item
    echo $history[1]
end
abbr -a !! --position anywhere --function last_history_item

function ls --wraps='eza -lh --group-directories-first --icons=auto --git' --description 'alias ls=eza -lh --group-directories-first --icons=auto --git'
    eza -lh --group-directories-first --icons=auto --git $argv
end

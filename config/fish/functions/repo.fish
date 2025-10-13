function repo
    if test (count $argv) -ge 1
        set SRC_DIRECTORY $argv[1]
    else
        set SRC_DIRECTORY $HOME/src
    end
    set repo (find $SRC_DIRECTORY -mindepth 1 -maxdepth 3 -type d -exec test -d "{}/.git" \; -print \
        | fzf --preview "bash -c '[ -f {}/README.md ] && bat --style=plain --color=always {}/README.md || echo \"No README\"; echo; git -C {} status --short --branch'" --preview-window=up:60%)
    or return
    cd $repo
end

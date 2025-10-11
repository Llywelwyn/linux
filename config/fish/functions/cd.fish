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

function dcim
    if test -d $XDG_DCIM_DIR
        cd $XDG_DCIM_DIR
    else if test -d ~/dcim
        cd ~/dcim
    else
        echo "no dcim dir found"
    end
end

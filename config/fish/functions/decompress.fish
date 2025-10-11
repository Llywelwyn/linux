function decompress --wraps='tar -xzf' --description 'alias decompress=tar -xzf'
    tar -xzf $argv
end

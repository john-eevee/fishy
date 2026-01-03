function extract --description "Expand archive formats, passing extra args to the tool"
    set -l file $argv[1]

    # Capture all remaining arguments to pass to the extractor
    set -l opts $argv[2..-1]

    if test -f "$file"
        switch "$file"
            case '*.tar.bz2'
                # tar supports trailing options (e.g. -C /path)
                tar xjf "$file" $opts
            case '*.tar.gz'
                tar xzf "$file" $opts
            case '*.bz2'
                # bunzip2 usually works on file in place, opts might be --force etc
                bunzip2 "$file" $opts
            case '*.rar'
                unrar x "$file" $opts
            case '*.gz'
                gunzip "$file" $opts
            case '*.tar'
                tar xf "$file" $opts
            case '*.tbz2'
                tar xjf "$file" $opts
            case '*.tgz'
                tar xzf "$file" $opts
            case '*.zip'
                # unzip uses -d for destination
                unzip "$file" $opts
            case '*.Z'
                uncompress "$file" $opts
            case '*.7z'
                7z x "$file" $opts
            case '*.xz'
                unxz "$file" $opts
            case '*'
                echo "'$file' cannot be extracted via extract()"
                return 1
        end
    else
        echo "'$file' is not a valid file"
        return 1
    end
end

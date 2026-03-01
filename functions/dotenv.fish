# Load environment variables from a .env-style file into the current fish session.
# Usage: dotenv [file]
# Defaults to .env in the current directory.
function dotenv --description 'Load env vars from .env or specified file'
    # default file
    set -l file '.env'
    if test (count $argv) -ge 1
        set file $argv[1]
    end

    if not test -f $file
        printf 'dotenv: file not found: %s\n' $file >&2
        return 1
    end

    set -l loaded 0

    # Read file line-by-line
    while read -l line
        # trim whitespace
        set -l line (string trim -- $line)

        # skip empty lines and full-line comments
        if test -z "$line"
            continue
        end
        if string match -q -r '^\s*#' -- $line
            continue
        end

        # support 'export KEY=VALUE'
        set -l line (string replace -r '^\s*export\s+' '' -- $line)

        # split on first '=' into key and value
        set -l parts (string split -m 1 '=' -- $line)
        if test (count $parts) -lt 2
            continue
        end

        set -l key (string trim -- $parts[1])
        set -l val (string trim -- $parts[2])

        # validate key looks like an env var name
        if not string match -q -r '^[A-Za-z_][A-Za-z0-9_]*$' -- $key
            continue
        end

        # handle quoted and unquoted values
        if test (string length -- $val) -gt 1
            set -l first (string sub -s 1 -l 1 -- $val)
            set -l last (string sub -s -1 -- $val)
            if test "$first" = '"' -a "$last" = '"'
                # remove surrounding double-quotes and expand escapes
                set -l raw (string sub -s 2 -l (math (string length -- $val) - 2) -- $val)
                set -l val (printf '%b' -- $raw)
            else if test "$first" = "'" -a "$last" = "'"
                # remove surrounding single-quotes (no escape processing)
                set -l val (string sub -s 2 -l (math (string length -- $val) - 2) -- $val)
            else
                # unquoted: strip inline comment after # and trim
                set -l val_parts (string split -m 1 '#' -- $val)
                set -l val (string trim -- $val_parts[1])
            end
        else if test (string length -- $val) -eq 1
            # single char value that is a bare quote -> treat as empty
            set -l first (string sub -s 1 -l 1 -- $val)
            if test "$first" = '"' -o "$first" = "'"
                set -l val ''
            end
        end

        # export to global environment for the session
        set -gx -- $key $val
        set -l loaded (math $loaded + 1)
    end < $file

    printf 'Loaded %d variables from %s\n' $loaded $file
end

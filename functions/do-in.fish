# Run a command in a different directory and return to the original directory.
# Usage: do-in DIR -- COMMAND [ARGS...]
# Example: do-in /data/path/example -- foobar arg1 arg2
function do-in --description 'Run a command in another directory and return'
    # Require at least a directory and a command
    if test (count $argv) -eq 0
        echo 'Usage: do-in DIR -- COMMAND [ARGS...]'
        return 2
    end

    # The first argument is the target directory
    set -l dir $argv[1]
    set -e argv[1]

    # If a '--' separator is present immediately after the dir, remove it
    if test (count $argv) -gt 0 -a "$argv[1]" = '--'
        set -e argv[1]
    end

    if test (count $argv) -eq 0
        echo 'do-in: missing command' >&2
        echo 'Usage: do-in DIR -- COMMAND [ARGS...]' >&2
        return 2
    end

    if not test -d "$dir"
        echo "No such directory" >&2
        return 1
    end

    # Change directory, run the command and preserve its exit status
    pushd "$dir" > /dev/null
    # Execute the command with its arguments preserving each argv element
    command $argv
    set -l rc $status
    popd > /dev/null
    return $rc
end

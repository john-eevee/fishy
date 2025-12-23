function watcher --description "Watch paths and execute command on file changes"
    # Parse command-line arguments by splitting at '--'
    if not set -l separator_index (contains -i -- "--" $argv)
        log -l error "Missing '--' separator."
        echo "Usage: watcher [flags] <paths> -- <command>"
        return 1
    end

    # Split argv into two parts: flags/paths and command
    set -l cmd $argv[(math $separator_index + 1)..-1]
    set -l paths_argv
    test $separator_index -gt 1 && set paths_argv $argv[1..(math $separator_index - 1)]

    # Parse flags and paths
    set -l argv $paths_argv
    argparse h/help c/clear r/restart z/oneshot d/dirs -- $argv || return 1

    if set -q _flag_help
        echo "Usage: watcher [options] <paths>... -- <command>"
        echo ""
        echo "Options:"
        echo "  -c, --clear    Clear the screen before executing the command"
        echo "  -r, --restart  Kill and restart a long-running process (e.g., servers)"
        echo "  -z, --oneshot  Execute once on the first change, then exit"
        echo "  -d, --dirs     Watch for directory updates (file add/delete) only"
        echo "  -h, --help     Show this help message"
        echo ""
        echo "Features:"
        echo "  • Uses 'fd' to respect .gitignore automatically."
        echo "  • Pass '/_' in your command to reference the changed file."
        echo ""
        echo "Examples:"
        echo "  watcher lib/ -- mix test"
        echo "  watcher lib/ main.ex -- mix format /_"
        echo "  watcher -r lib/ -- mix phx.server"
        return 0
    end

    # Verify required commands exist
    if not type -q fd || not type -q entr
        log -l error "Required commands 'fd' and 'entr' not found."
        return 1
    end

    # Validate inputs
    set -l paths $argv
    test -z "$paths" && set paths "."
    test -z "$cmd" && log -l error "No command provided after '--'" && return 1

    # Build entr options from flags
    set -l entr_opts
    set -q _flag_clear && set -a entr_opts -c
    set -q _flag_restart && set -a entr_opts -r
    set -q _flag_oneshot && set -a entr_opts -z
    set -q _flag_dirs && set -a entr_opts -d

    # Execute watcher
    log -l debug "Watching: $paths"
    log -l debug "Command: $cmd"

    # Stream files from paths into entr
    begin
        for p in $paths
            if test -d "$p"
                fd . "$p" --type f
            else test -f "$p" && echo "$p"
            end
        end | entr $entr_opts -- $cmd
    end
end

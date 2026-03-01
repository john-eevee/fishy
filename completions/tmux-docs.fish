# Completions for tmux-docs command

function __tmux_docs_list_files
    set -l docs_dir ~/.config/tmux/docs
    if test -d "$docs_dir"
        find "$docs_dir" -maxdepth 1 -type f \( -name "*.md" -o -name "*.txt" -o -name "*.conf" \) -printf '%f\n' | sort
    end
end

# Main command completions - list doc files
complete -c tmux-docs -f -a "(__tmux_docs_list_files)" -d "View documentation file"

# Special commands
complete -c tmux-docs -f -a "search" -d "Search documentation"
complete -c tmux-docs -f -a "help" -d "Show help menu"

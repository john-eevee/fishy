function extract_all --description "Batch extract all archives in a directory"
    set -l target_dir $argv[1]

    # Default to current directory if no argument provided
    if test -z "$target_dir"
        set target_dir "."
    end

    # 1. Validation
    if not test -d "$target_dir"
        log -l error "Directory '$target_dir' not found."
        return 1
    end

    if not functions -q extract
        log -l error "Function 'extract' is missing. Please add it first."
        return 1
    end

    # 2. Define extensions to hunt for
    # These correspond to the switch cases in your 'extract' function
    set -l exts tar bz2 rar gz zip Z tbz2 tgz 7z xz

    # Build the fd arguments dynamically (-e zip -e rar ...)
    set -l fd_args
    for ext in $exts
        set -a fd_args -e $ext
    end

    log_info "Hunting for archives in '$target_dir'..."

    # 3. Execution Loop
    set -l count 0

    # We use fd to find all files matching the extensions
    for archive in (fd $fd_args . "$target_dir" --type f)
        set count (math $count + 1)

        log_info "Extracting: $archive"

        # We call the wrapper.
        # Note: Most extraction tools (tar, unzip) extract to the Current Working Directory (CWD).
        # If you want them to extract inside the target folder, we should cd there briefly?
        # For now, this behaves like running 'extract' manually on each file.
        extract "$archive"

        if test $status -eq 0
            log_success "Extracted $archive"
        else
            log -l error "Failed to extract $archive"
        end
    end

    if test $count -eq 0
        log_warn "No archives found in $target_dir."
    else
        echo ""
        log_success "Batch operation complete. Processed $count files."
    end
end

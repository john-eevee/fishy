function merge --description "Merge N files content into a destination file"
    # Initialize variables
    set -l source_files
    set -l dest_file ""
    set -l parsing_dest 0

    # Parse arguments
    for arg in $argv
        if test "$arg" = "-d"
            set parsing_dest 1
            continue
        end

        if test $parsing_dest -eq 1
            set dest_file $arg
            set parsing_dest 0
            continue
        end

        set -a source_files $arg
    end

    # Validate inputs
    if test -z "$dest_file"
        echo "Error: Destination file not specified. Use -d <destination_file>"
        return 1
    end

    if test (count $source_files) -eq 0
        echo "Error: No source files specified"
        return 1
    end

    # Check if source files exist
    for file in $source_files
        if not test -f "$file"
            echo "Error: Source file '$file' does not exist"
            return 1
        end
    end

    # Create or truncate the destination file
    echo -n "" > "$dest_file"

    # Merge files content
    for file in $source_files
        cat "$file" >> "$dest_file"
    end

    echo "Successfully merged" (count $source_files) "file(s) into '$dest_file'"
    return 0
end

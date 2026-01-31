function create --description "Create files or directories with automatic parent directory creation and brace expansion support"
    if test (count $argv) -eq 0
        echo "Usage: create <path>"
        echo ""
        echo "Creates files or directories:"
        echo "  - Paths ending with '/' are created as directories"
        echo "  - Other paths are created as files"
        echo "  - Parent directories are created automatically"
        echo "  - Supports brace expansion: /path/{a,b,c}/file.txt"
        echo ""
        echo "Examples:"
        echo "  create /tmp/mydir/           # Creates a directory"
        echo "  create /tmp/myfile.txt       # Creates a file"
        echo "  create /path/{a,b,c}/file.js # Creates file.js in dirs a, b, and c"
        return 0
    end
    
    # Process each argument (in case of brace expansion)
    for item in $argv
        # Check if the path ends with /
        if string match -q "*/" $item
            # It's a directory
            if not test -d $item
                mkdir -p $item
                if test $status -eq 0
                    echo "✓ Created directory: $item"
                else
                    echo "✗ Failed to create directory: $item"
                    return 1
                end
            else
                echo "⚠ Directory already exists: $item"
            end
        else
            # It's a file
            # Get the parent directory
            set -l parent (dirname $item)
            
            # Create parent directories if they don't exist (skip if parent is current dir)
            if test "$parent" != "."; and not test -d $parent
                mkdir -p $parent
                if test $status -ne 0
                    echo "✗ Failed to create parent directories for: $item"
                    return 1
                end
            end
            
            # Create the file if it doesn't exist
            if test -f $item
                echo "⚠ File already exists: $item"
            else if test -d $item
                echo "✗ Error: A directory with this name already exists: $item"
                return 1
            else
                touch $item
                if test $status -eq 0
                    echo "✓ Created file: $item"
                else
                    echo "✗ Failed to create file: $item"
                    return 1
                end
            end
        end
    end
    
    return 0
end

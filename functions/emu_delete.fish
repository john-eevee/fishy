function emu_delete --description "Delete an Android emulator"
    if test (count $argv) -eq 0
        echo "Usage: emu_delete <emulator_name>"
        echo ""
        echo "Available emulators:"
        emu_list
        return 1
    end
    
    set -l emu_name $argv[1]
    
    if not command -v avdmanager &>/dev/null
        echo "Error: avdmanager not found. Ensure Android SDK is installed."
        return 1
    end
    
    echo "Deleting emulator: $emu_name"
    read -l -P "Are you sure? (y/n) " confirm
    
    if test "$confirm" != "y"
        echo "Cancelled."
        return 0
    end
    
    avdmanager delete avd -n "$emu_name"
    
    if test $status -eq 0
        echo "✓ Emulator '$emu_name' deleted successfully!"
    else
        echo "✗ Failed to delete emulator."
        return 1
    end
end

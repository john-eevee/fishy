function emu_start --description "Start an Android emulator"
    if test (count $argv) -eq 0
        echo "Usage: emu_start <emulator_name> [--no-window] [--wipe-data]"
        echo ""
        echo "Available emulators:"
        emu_list
        return 1
    end
    
    set -l emu_name $argv[1]
    set -l extra_args ""
    
    if contains -- "--no-window" $argv
        set extra_args "$extra_args -no-window"
    end
    
    if contains -- "--wipe-data" $argv
        set extra_args "$extra_args -wipe-data"
    end
    
    if not command -v emulator &>/dev/null
        echo "Error: Android emulator not found."
        return 1
    end
    
    echo "Starting emulator: $emu_name"
    emulator -avd $emu_name $extra_args &
    
    echo "Emulator starting... (PID: $!)"
    sleep 3
    echo "Monitor at: ~/.android/avd/$emu_name.avd/emulator-pid"
end

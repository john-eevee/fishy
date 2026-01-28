function emu_start --description "Start an Android emulator"
    if test (count $argv) -eq 0
        echo "Usage: emu_start <emulator_name> [--no-window] [--wipe-data] [--cold-boot]"
        echo ""
        echo "Available emulators:"
        emu_list
        return 1
    end
    
    set -l emu_name ""
    set -l extra_args
    
    for arg in $argv
        if string match -q -- '--*' $arg
            if test $arg = "--no-window"
                set extra_args $extra_args -no-window
            else if test $arg = "--wipe-data"
                set extra_args $extra_args -wipe-data
            else if test $arg = "--cold-boot"
                set extra_args $extra_args -no-snapshot-load
            end
        else
            set emu_name $arg
        end
    end
    
    if test -z $emu_name
        echo "Error: Emulator name not provided"
        return 1
    end
    
    if not command -v emulator &>/dev/null
        echo "Error: Android emulator not found."
        return 1
    end
    
    echo "Starting emulator: $emu_name"
    emulator -avd $emu_name $extra_args &
    set -l pid (jobs -p)
    
    echo "Emulator starting... (PID: $pid)"
    sleep 3
    echo "Monitor at: ~/.android/avd/$emu_name.avd/emulator-pid"
end

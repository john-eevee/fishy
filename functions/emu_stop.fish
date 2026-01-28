function emu_stop --description "Stop running Android emulators"
    set -l stopped 0
    
    if test (count $argv) -gt 0
        set -l emu_name $argv[1]
        echo "Stopping emulator: $emu_name"
        adb -s $emu_name emu kill
        set stopped 1
    else
        echo "Stopping all running emulators..."
        for device in (adb devices | grep "emulator-" | awk '{print $1}')
            echo "  Stopping $device..."
            adb -s $device emu kill
            set stopped 1
        end
    end
    
    if test $stopped -eq 0
        echo "No running emulators found."
        return 1
    end
    
    echo "Emulator(s) stopped."
end

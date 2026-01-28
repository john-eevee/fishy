function emu_status --description "Check status of Android emulators"
    if not command -v adb &>/dev/null
        echo "Error: adb not found. Ensure Android SDK is installed."
        return 1
    end
    
    set -l devices (adb devices | grep -E "emulator-|device" | grep -v "^List")
    
    if test -z "$devices"
        echo "No devices/emulators connected."
        return 0
    end
    
    echo "Connected Devices/Emulators:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "$devices" | while read -l device status rest
        if test -n "$device"
            if string match -q "emulator-*" "$device"
                set -l api (adb -s $device shell getprop ro.build.version.release 2>/dev/null)
                set -l model (adb -s $device shell getprop ro.product.model 2>/dev/null)
                printf "  %-20s [%-10s] API: %-3s Model: %s\n" "$device" "$status" "$api" "$model"
            else
                printf "  %-20s [%-10s]\n" "$device" "$status"
            end
        end
    end
end

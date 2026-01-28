function emu_list --description "List all available Android emulators"
    if not command -v emulator &>/dev/null
        echo "Error: Android emulator not found. Ensure Android SDK is installed and ANDROID_HOME is set."
        return 1
    end
    
    set -l avd_path "$HOME/.android/avd"
    if not test -d "$avd_path"
        echo "No emulators found."
        return 0
    end
    
    echo "Available Android Emulators:"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    for avd_dir in "$avd_path"/*.avd
        if test -d "$avd_dir"
            set -l name (basename "$avd_dir" .avd)
            set -l config_file "$avd_dir/config.ini"
            
            if test -f "$config_file"
                set -l api (grep "^image.sysdir.1=" "$config_file" 2>/dev/null | sed 's/.*system-images\/android-//' | cut -d'/' -f1)
                echo "  • $name (API: $api)"
            else
                echo "  • $name"
            end
        end
    end
end

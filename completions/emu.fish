# Completion for emu command

# Helper function to list available emulators
function __fish_emu_list_names
    set -l avd_path "$HOME/.android/avd"
    if test -d "$avd_path"
        for avd_dir in "$avd_path"/*.avd
            if test -d "$avd_dir"
                basename "$avd_dir" .avd
            end
        end
    end
end

# Helper function to list running emulators
function __fish_emu_list_running
    if command -v adb &>/dev/null
        adb devices 2>/dev/null | grep "emulator-" | awk '{print $1}'
    end
end

# Main command completions
complete -c emu -f
complete -c emu -n "__fish_use_subcommand_from_list" -a "list" -d "List all available emulators"
complete -c emu -n "__fish_use_subcommand_from_list" -a "start" -d "Start an emulator"
complete -c emu -n "__fish_use_subcommand_from_list" -a "stop" -d "Stop emulator(s)"
complete -c emu -n "__fish_use_subcommand_from_list" -a "status" -d "Show connected devices and emulators"
complete -c emu -n "__fish_use_subcommand_from_list" -a "create" -d "Create a new emulator"
complete -c emu -n "__fish_use_subcommand_from_list" -a "delete" -d "Delete an emulator"

# Start command - emulator names
complete -c emu -n "__fish_seen_subcommand_from start" -a "(__fish_emu_list_names)" -f
complete -c emu -n "__fish_seen_subcommand_from start" -l "no-window" -d "Start without GUI window"
complete -c emu -n "__fish_seen_subcommand_from start" -l "wipe-data" -d "Wipe user data"

# Stop command - running emulator names
complete -c emu -n "__fish_seen_subcommand_from stop" -a "(__fish_emu_list_running)" -f

# Delete command - emulator names
complete -c emu -n "__fish_seen_subcommand_from delete" -a "(__fish_emu_list_names)" -f

# Create command - API levels and image types
complete -c emu -n "__fish_seen_subcommand_from create" -a "30 31 32 33 34 35" -d "API Level"
complete -c emu -n "__fish_seen_subcommand_from create; and __fish_seen_subcommand_from create; and test (count (commandline -opc | grep -v '^emu$' | grep -v '^create$')) -eq 3" -a "default google_apis google_apis_playstore" -d "System Image Type"

function emu --description "Main Android emulator management command"
    if test (count $argv) -eq 0
        echo "Android Emulator Manager"
        echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
        echo ""
        echo "Usage: emu <command> [options]"
        echo ""
        echo "Commands:"
        echo "  list              List all available emulators"
        echo "  start <name>      Start an emulator (options: --no-window, --wipe-data)"
        echo "  stop [name]       Stop emulator(s)"
        echo "  status            Show connected devices and emulators"
        echo "  create <name> <api> [type]  Create a new emulator"
        echo "  delete <name>     Delete an emulator"
        echo ""
        return 0
    end
    
    set -l cmd $argv[1]
    set -l args $argv[2..-1]
    
    switch $cmd
        case "list"
            emu_list $args
        case "start"
            emu_start $args
        case "stop"
            emu_stop $args
        case "status"
            emu_status $args
        case "create"
            emu_create $args
        case "delete"
            emu_delete $args
        case "*"
            echo "Unknown command: $cmd"
            emu
            return 1
    end
end

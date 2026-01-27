function z --description 'Launcher for Zed with Niri resize fix'
    # 1. Launch Zed with all passed arguments in the background
    command zed $argv &

    # 2. Run the Niri fix in a background block so the shell stays snappy
    begin
        # Give Zed a moment to map the window
        sleep 0.6

        # Get the window ID (checking for both common app_ids)
        set -l zed_id (niri msg --json windows | jq -r '.[] | select(.app_id == "dev.zed.Zed" or .app_id == "Zed") | .id' | head -n 1)

        if test -n "$zed_id"
            # Nudge the window size to wake up the renderer
            niri msg action set-window-width --id "$zed_id" "+1"
            sleep 0.1
            niri msg action set-window-width --id "$zed_id" "-1"
        end
    end &

    # Disown the background jobs so they don't print "job ended" messages
    disown
end

function wez_split
    # Split the initial window horizontally
    # The --percent 30 flag creates the bottom pane at 30% height
    set bottom_pane (wezterm cli split-pane --bottom --percent 30)

    # Move focus back to the top pane to perform the vertical split
    # Since we just created a pane, the original is the first one
    set top_pane (wezterm cli list-panes --format json | jq -r '.[0].pane_id')

    # Split the top pane vertically
    # --percent 20 creates the right-hand pane at 20% width
    set right_pane (wezterm cli split-pane --pane-id $top_pane --right --percent 20)

    # Start opencode in the 20% (right) pane
    echo "opencode" | wezterm cli send-text --pane-id $right_pane --no-paste

    # Start nvim in the 80% (left/top) pane
    echo "nvim" | wezterm cli send-text --pane-id $top_pane --no-paste
end

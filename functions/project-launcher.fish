function project-launcher --description "Launch a project in a predefined layout"

  set TARGET_DIR (find ~/code -mindepth 1 -maxdepth 1 -type d | fzf --prompt="Select Project > " --height=40% --layout=reverse --border=rounded)

  if test -z "$TARGET_DIR"
      exit 0
  end

  set LAYOUT (printf "1. Dev Layout (Left 80 / Right 20)\n2. Dual Project (2x2 Grid)" | fzf --prompt="Select Layout > " --height=40% --layout=reverse --border=rounded)

  if test -z "$LAYOUT"
      exit 0
  end

  switch "$LAYOUT"
      case "1*"
          hyprctl dispatch exec "kitty --working-directory \"$TARGET_DIR\" --title Neovim -e nvim"
          sleep 0.4
          hyprctl dispatch exec "kitty --working-directory \"$TARGET_DIR\" --title OpenCode"
          sleep 0.4
          hyprctl dispatch splitratio exact 0.8
          hyprctl dispatch exec "kitty --working-directory \"$TARGET_DIR\" --title TaskRunner"
          sleep 0.4
          hyprctl dispatch splitratio exact 0.8
      case "2*"
          hyprctl dispatch exec "kitty --working-directory \"$TARGET_DIR\" --title Proj1-Main"
          sleep 0.4
          hyprctl dispatch exec "kitty --working-directory \"$TARGET_DIR\" --title Proj2-Main"
          sleep 0.4
          hyprctl dispatch movefocus l
          sleep 0.2
          hyprctl dispatch exec "kitty --working-directory \"$TARGET_DIR\" --title Proj1-Tasks"
          sleep 0.4
          hyprctl dispatch splitratio exact 0.8
          hyprctl dispatch
  end
end

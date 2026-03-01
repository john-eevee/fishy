function fish-greet
   # Define Catppuccin Mocha colors using strict hex codes
    set -l mauve (set_color cba6f7)
    set -l pink (set_color f5c2e7)
    set -l reset (set_color normal)

    # Define the exact array of custom phrases
    set -l phrases "welcome home nyaster          $mauve │" "i'm excited be of service     $mauve │" "tell me what to do nyaster    $mauve │"
    
    # Select a completely random phrase from the array
    set -l selected_phrase (random choice $phrases)

    # Print the aesthetic open-ended border and the random text
    echo ""
    echo "$mauve ╭─────────────────────────────────╮"
    echo "$mauve │ $pink $selected_phrase"           
    if test $argv[1]
      echo "$mauve │ $pink $argv[1] $mauve │"
    end
    echo "$mauve ╰─────────────────────────────────╯"
    echo "$reset"
  end

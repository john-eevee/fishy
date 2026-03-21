set -U fish_greeting
if status is-login
  fish-greet ""
  if test (tty) = /dev/tty1
    start-hyprland
  end
  return 0
end
set -l __startup_time (date +%s%3N)
mise activate fish | source

set -gx ANDROID_HOME $HOME/Android/Sdk

if test -d $ANDROID_HOME
    fish_add_path $ANDROID_HOME/cmdline-tools/latest/bin
    fish_add_path $ANDROID_HOME/platform-tools
    fish_add_path $ANDROID_HOME/emulator
    fish_add_path $ANDROID_HOME/tools
    fish_add_path $ANDROID_HOME/tools/bin
end

set -l mise_java_path (mise where java 2>/dev/null)

if test -n "$mise_java_path"
    set -gx JAVA_HOME $mise_java_path
else
    set -l system_java (readlink -f (which java) 2>/dev/null)
    if test -n "$system_java"
        set -gx JAVA_HOME (dirname (dirname $system_java))
    end
end

set -gx PROJECT_DIRS $HOME/Projects $HOME/Work $HOME/Code \
    $HOME/projects $HOME/work $HOME/code
set -gx EDITOR nvim

fish_add_path $HOME/.local/bin


if test -f $HOME/.config/fish/.env
  source $HOME/.config/fish/.env
end

if status is-interactive
    starship init fish | source
    set -l duration (math "($(date +%s%3N) - $__startup_time) / 1000")
    fish-greet "i took $duration ms to get ready!"
    return 0
end


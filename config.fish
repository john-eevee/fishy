if status is-interactive
    # Remove the default login greeting
    set -g fish_greeting ""
end

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
set -gx EDITOR zed

fish_add_path $HOME/.local/bin

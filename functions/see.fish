function see --description "A wrapper around eza and bat to smart show contents"

  if not count $argv > /dev/null
    eza -la $PWD
    return 0
  end

  set -l path $argv[1]

  if not test -e $path
    echo 'invalid path'
    return 1
  end
  if test -f $path
    bat $path
    return 0
  end

  if test -d $path
    eza -la $path
    return 0
  end
end

function see --description "A wrapper around eza and bat to smart show contents"

  if not count $argv > /dev/null
    echo 'missing path'
    return 1
  end

  set -l path $argv[1]

  if not test -e $path
    echo 'invalid path'
    return 1
  end
  if test -f $path
    bat $path
  end

  if test -d $path
    eza $path
  end
end

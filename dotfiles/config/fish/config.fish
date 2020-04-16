# Start X at login
if status is-login
    if test -z "$DISPLAY"
        if test (whoami) = cata
            startx -- -keeptty; exec /bin/true
        else if test $XDG_VTNR = 1
            startx -- -keeptty
        end
    end
end

# OPAM configuration
if test -e $HOME/.opam
    eval (opam env | grep -v 'set -gx PATH ')
    eval (opam env | grep 'set -gx PATH ' | sed 's/://')
end

# Autojump
if command -v autojump 2>&1 >/dev/null
    source /usr/share/autojump/autojump.fish
end

# Context-dependent definition of ls
if test -n "$DISPLAY"
  function ls --description 'alias ls=lsd'
    lsd  $argv;
  end
end

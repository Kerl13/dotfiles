# Start X at login
if status is-login
    if test -z "$DISPLAY"
        if test (whoami) = cata
            startx -- -keeptty; exec /bin/true
        else if test "_$XDG_VTNR" = "_1"
            startx -- -keeptty
        end
    end
end

# OPAM configuration
if test -e $HOME/.opam
    eval (opam env | grep -v 'set -gx PATH ')
    eval (opam env | grep 'set -gx PATH ' | sed 's/://')
    export C_INCLUDE_PATH=(ocamlc -where)
end

# Context-dependent definition of ls
if test -n "$DISPLAY"
  function ls --description 'alias ls=lsd'
    lsd  $argv;
  end
end

# https://github.com/pypa/pip/issues/7883
set -gx PYTHON_KEYRING_BACKEND keyring.backends.null.Keyring

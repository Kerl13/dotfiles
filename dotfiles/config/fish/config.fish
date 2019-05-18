# Start X at login
if status is-login
    if test -z "$DISPLAY"
        if test (whoami) = cata
            startx -- -keeptty; exec /bin/true
        else if $XDG_VTNR
            startx -- -keeptty
        end
    end
end

# OPAM configuration
eval (opam env | grep -v MANPATH) >/dev/null 2>&1 || true

# Add $HOME/.local/bin to PATH
set -gx PATH "$HOME/.local/bin" $PATH
set -gx VISUAL vim
set -gx EDITOR vim
set -gx LESSHISTFILE '-'
set -U fish_greeting ''

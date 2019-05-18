# Start X at login
if status is-login
    if test -z "$DISPLAY"
        if test (whoami) = cata
            startx -- -keeptty; exit
        else if $XDG_VTNR
            startx -- -keeptty
        end
    end
end

# OPAM configuration
eval (opam env | grep -v MANPATH)

# Add $HOME/.local/bin to PATH
set -gx PATH "$HOME/.local/bin" $PATH
set -gx VISUAL vim
set -gx EDITOR vim
set -gx LESSHISTFILE '-'
set -U fish_greeting ''

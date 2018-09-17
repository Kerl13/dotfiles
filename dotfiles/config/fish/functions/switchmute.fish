function switchmute
    switch (amixer get Master | egrep 'Playback.*?\[o' | egrep -o '\[o.+\]')
    case "[on]"
        amixer sset Master mute
    case '*'
        amixer sset Master unmute
        amixer sset Headphone unmute
        amixer sset Speaker unmute
    end
end

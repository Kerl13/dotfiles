#!/bin/sh

set -euC

if [ "_$(command -v wifi)" = "_" ]; then
    exit 0
fi

status="$(wifi | sed 's/^.*= \([a-z]*\).*/\1/')"
color="#FF0000"
if [ "$status" = "on" ]; then
    color="#00FF00"
fi

echo "wifi: $status"
echo "$color"

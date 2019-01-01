#!/bin/sh

set -euC


status="$(wifi | sed 's/^.*= \([a-z]*\).*/\1/')"
color="#FF0000"
if [ "$status" = "on" ]; then
    color="#00FF00"
fi

echo "wifi: $status"
echo "$color"

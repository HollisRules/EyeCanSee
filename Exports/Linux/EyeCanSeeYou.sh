#!/bin/sh
echo -ne '\033c\033]0;EyeCanSeeYou\a'
base_path="$(dirname "$(realpath "$0")")"
"$base_path/EyeCanSeeYou.x86_64" "$@"

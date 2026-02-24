#!/usr/bin/env bash

# Copyright (c) 2023-2024 mylinuxforwork
# Source: https://github.com/mylinuxforwork/dotfiles
# License: GNU GPL v3.0

# Modified by: carllongj carllongj@gmail.com
# Date: 2026-02-23
# Description: 本文件在原作者逻辑基础上进行了以下调整：
#   1. [修改点一：修改脚本解释器入口以适配NixOS]

#    __ __              _    ____   
#   / // /_ _____  ____(_)__/ / /__ 
#  / _  / // / _ \/ __/ / _  / / -_)
# /_//_/\_, / .__/_/ /_/\_,_/_/\__/ 
#      /___/_/                      
# 

SERVICE="hypridle"

print_status() {
    if pgrep -x "$SERVICE" >/dev/null ; then
        echo '{"text": "RUNNING", "class": "active", "tooltip": "Screen locking active\nLeft: Deactivate\nRight: Lock Screen"}'
    else
        echo '{"text": "NOT RUNNING", "class": "notactive", "tooltip": "Screen locking deactivated\nLeft: Activate\nRight: Lock Screen"}'
    fi
}

case "$1" in
    status)
        # Add a tiny delay to avoid race condition on startup
        sleep 0.2
        print_status
        ;;
    toggle)
        if pgrep -x "$SERVICE" >/dev/null ; then
            killall "$SERVICE"
        else
            "$SERVICE" &
        fi
        # Give it a moment to start/stop before checking again
        sleep 0.2
        print_status
        ;;
    *)
        echo "Usage: $0 {status|toggle}"
        exit 1
        ;;
esac

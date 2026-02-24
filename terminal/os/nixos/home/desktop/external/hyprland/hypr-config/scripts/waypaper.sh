#!/usr/bin/env bash
# Copyright (c) 2023-2024 mylinuxforwork
# Source: https://github.com/mylinuxforwork/dotfiles
# License: GNU GPL v3.0

# Modified by: carllongj carllongj@gmail.com
# Date: 2026-02-23
# Description: 本文件在原作者逻辑基础上进行了以下调整：
#   1. [修改点一：修改命令可执行文件检测方式以适配 NixOS]

if command -v waypaper  > /dev/null 2>&1; then
    waypaper $1 &
elif [ -f /usr/bin/waypaper ]; then
    echo ":: Launching waybar in /usr/bin"
    /usr/bin/waypaper $1 &
elif [ -f $HOME/.local/bin/waypaper ]; then
    echo ":: Launching waybar in $HOME/.local/bin"
    $HOME/.local/bin/waypaper $1 &
else
    echo ":: waypaper not found"
fi

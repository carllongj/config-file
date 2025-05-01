#!/bin/bash

# 获取当前光标位置函数
get_cursor_row() {
  IFS=';' read -sdR -p $'\033[6n' _ROW _COL
  echo "${_ROW#*[}"
}

# 获取初始光标行号
INITIAL_ROW=$(get_cursor_row)

# 预留3行空间（用于两个进度条和状态信息）
echo -e "\n\n\n"

# 计算进度条行号（初始行号 + 1, +2, +3）
PROGRESS_ROW1=$((INITIAL_ROW + 1))
PROGRESS_ROW2=$((INITIAL_ROW + 2))
STATUS_ROW=$((INITIAL_ROW + 3))

# 示例：更新进度条
for i in {1..100}; do
  # 更新第一个进度条（行号：INITIAL_ROW +1）
  echo -ne "\033[${PROGRESS_ROW1};1HProgress 1: [\033[1;32m${i}%\033[0m] \033[K"

  # 更新第二个进度条（行号：INITIAL_ROW +2）
  j=$((i * 2))
  if [[ $j -le 100 ]]; then
    echo -ne "\033[${PROGRESS_ROW2};1HProgress 2: [\033[1;34m${j}%\033[0m] \033[K"
  fi

  # 在状态行显示额外信息（行号：INITIAL_ROW +3）
  echo -ne "\033[${STATUS_ROW};1HStatus: Iteration ${i} \033[K"

  sleep 0.1
done

# 完成后在状态行下方输出完成信息
echo -e "\033[$((STATUS_ROW + 1));1H\033[1;32mDone!\033[0m"

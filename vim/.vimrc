" 设置代码源文件的文件注释
function SetComment()
  call setline(1,"/**")
  call append(line(".") , " *   Copyright (C) ".strftime("%Y")." All rights reserved.")
  call append(line(".") + 1, " *")
  call append(line(".") + 2, " *   Author        : carllongj")
  call append(line(".") + 3, " *   Email         : carllongj@gmail.com")
  call append(line(".") + 4, " *   Date          : ".strftime("%Y年%m月%d日"))
  call append(line(".") + 5, " *   Description   :")
  call append(line(".") + 6, " */")
endfunction

" java 文件则增加设置一个类名称
function SetClassName()
  call cursor(9,0)
  " 设置了前面的注释行,则需要将注释行的下一行设置为空行,这行若不设置,无法设置第10行内容
  call append(line("."),"")
  " 增加对应的标识类
  call append(line(".") + 1,"public class ".expand("%:r")." {")
  call append(line(".") + 2 ,"  public static void main(String[] args) {")
  call append(line(".") + 3, "")
  call append(line(".") + 4 ,"  }" )
  call append(line(".") + 5 ,"}" )
endfunction

"添加 python 注释
function SetPythonComment()
  call setline(1 , "#!/usr/bin/env python3")
  call setline(2 , "# -*- coding: utf-8 -*-")
  call setline(3 ,"# @Author        : carllongj")
  call setline(4 ,"# @Email         : carllongj@gmail.com")
  call setline(5 ,"# @Date          : ".strftime("%Y年%m月%d日"))
  call setline(6 ,"# @Description   : ")
endfunction

" Bash的注释
function SetBashComment()
  call setline(1 , "#!/bin/bash")
  call setline(2 ,"# @Author        : carllongj")
  call setline(3 ,"# @Email         : carllongj@gmail.com")
  call setline(4 ,"# @Date          : ".strftime("%Y年%m月%d日"))
  call setline(5 ,"# @Description   : ")
endfunction

function CompileRun()
  if &filetype == 'python'
    " 保存当前文件并执行
    exec "w | !python3 %"
  elseif &filetype == 'java'
    " 执行 java 的编译
    exec "w | !javac %"
    exec "!java %:r"
  endif
endfunction

function SetAbbreviate()
  if &filetype == 'java'
    " java 开发环境配置
    " 部分缩写的快捷键
    inoreabbre sout System.out.println();
    inoreabbre souf System.out.printf();
    inoreabbre psvm public static void main(){<LF><Tab><Tab>}
  endif
endfunction

" 帮助函数说明,使用 :call Ch() 来获取帮助
function Ch()
  echo "快捷键说明\n"
  echo "   F2       设置或者取消行号"
  echo "   F3       设置或者取消软换行"
  echo "   F5       编译以及运行当前脚本文件"
  echo "Shift + p   设置为粘贴模式(注释不会影响其换行内容),再执行插入命令"
  echo "快捷键说明(END)\n"
endfunction

" 关闭兼容 vi 模式
set nocompatible
" 开启语法高亮,一般都是默认开启
syntax on

" 开启文件检测
filetyp on

" 开启根据文件类型自动适配插件,如tab格式转换等
filetype plugin on

" 开启根据文件类型的自动适配智能缩进
filetype indent on

" 注册添加注释事件
autocmd BufNewFile *.java,*.js,*.c,*.cpp exec ":call SetComment()"
" 执行完成注释添加函数后,在新增类的声明以及main方法之前将光标移动到行尾
autocmd BufNewFile * normal G
autocmd BufNewFile *.java exec ":call SetClassName()"
autocmd BufNewFile *.py exec ":call SetPythonComment()"
autocmd BufNewFile *.sh exec ":call SetBashComment()"
" 定义所有的缩写格式
autocmd FileType * exec ":call SetAbbreviate()"

" 将光标定位到末尾
autocmd BufNewFile * normal G

" 快捷键设置
" 设置显示行号
nnoremap <silent> <F2> :set invnu<CR>
" 设置软换行
nnoremap <silent> <F3> :set invwrap<CR>
" 执行编译运行 python 与 java
nnoremap <silent> <F5> :call CompileRun()<CR>
" 设置进入粘贴模式
nnoremap <silent> <S-p> :set paste<CR>
" 删除当前的空行
nnoremap <silent> <S-e> :g/^$/d<CR>

" 属性配置
set encoding=utf-8
set tabstop=2
set shiftwidth=2
" 将tab键转换成空格
set expandtab

colorscheme gruvbox
" colorscheme gotham256
" unlet g:gruvbox_contrast
set bg=dark
" 显示输入的命令
set showcmd
set hlsearch
set smartindent


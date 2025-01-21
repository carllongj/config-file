Set-Alias qemu qemu-system-i386.exe
# Chocolatey profile
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}

# 导入终端显示图标
# 需要安装字体(Nerd Font),下载 Cascadia Code NF
# 需要执行 Install-Module -Name Terminal-Icons -Repository PSGallery
Import-Module -Name Terminal-Icons
# 需要安装 oh-my-posh
oh-my-posh init pwsh --config 'C:\Users\carllongj\AppData\Local\Programs\oh-my-posh\themes\night-owl.omp.json' | Invoke-Expression

# 需要安装 PSReadLine,执行 Install-Module PSReadLine -Force
Set-PSReadLineOption -PredictionSource History

Set-PSReadlineKeyHandler -Key Tab -Function Complete # 设置 Tab 键补全
Set-PSReadlineKeyHandler -Key "Ctrl+u" -Function DeleteLine # 清空当前行内容
Set-PSReadlineKeyHandler -Key "Ctrl+k" -Function ForwardDeleteLine # 删除当前光标所在位置到结尾的内容
Set-PSReadlineKeyHandler -Key "Ctrl+a" -Function BeginningOfLine # 将光标移动到行首
Set-PSReadlineKeyHandler -Key "Ctrl+e" -Function EndOfLine # 将光标移动到行尾
Set-PSReadlineKeyHandler -Key "Ctrl+w" -Function BackwardDeleteWord # 删除光标所在位置到前一个单词开头
Set-PSReadLineKeyHandler -Key "ctrl+d" -Function MenuComplete # 设置 Ctrl+d 为菜单补全和 Intellisense
Set-PSReadLineKeyHandler -Key "Ctrl+z" -Function Undo # 设置 Ctrl+z 为撤销
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward # 设置向上键为后向搜索历史记录
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward # 设置向下键为前向搜索历史纪录


# 拷贝文件
function copyTo($path,$target='~') {
    scp -i 'D:\carl\ssh\id_rsa' $path carllongj@n2.org:$target
}

# 复制文件
function copyFrom($path,$target='.'){
    scp -i 'D:\carl\ssh\id_rsa' carllongj@n2.org:$path $target
}

Set-Alias cpt copyTo
Set-Alias cpf copyFrom
# 设置输出编码
$OutputEncoding = [console]::InputEncoding = [console]::OutputEncoding = New-Object System.Text.UTF8Encoding

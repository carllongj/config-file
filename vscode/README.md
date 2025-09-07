### keybindings.json
* 该文件用以保存常用的快捷键设置,快捷键使用了部分`IDEA`的快捷键设定.
* 对于 `keybindings.json` 的方式,建议使用用户的全局配置方式,而不是使用项目配置方式.
  即在 `.vscode` 目录下写入该文件.
* 导入方式,此种方式是写入到用户配置中.
  1. 打开 `vscode` 命令面板,可通过如下快捷键打开.
    ```bash
      # 打开命令搜索面板
      ctrl + shift + p
    ```
  2. 打开键盘绑定快捷键设置,在命令面板中输入以下内容以检索到指定内容.
    ```bash
      # 键入搜索以下内容
      Preferences: Open Keyboard Shortcuts (JSON)
    ```
  3. 在新打开的`JSON`文件面板内容粘贴 [快捷键](./keybindings.json) 文件内容.
* 复制方式,此种方式也是写入到用户全局配置,将[快捷键](./keybindings.json) 复制到
  以下目录即可.
  ```bash
     # Linux
     ~/.config/Code/User/

     # Windows
     %APPDATA%\Code\User\
  ```

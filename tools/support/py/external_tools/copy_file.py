from typing import AnyStr

from external_tools import CommandHandler


class CpCommandHandler(CommandHandler):

    @property
    def command_name(self) -> AnyStr:
        return "cp"

    def register(self, sub_parser) -> None:
        cp = sub_parser.add_parser(self.command_name, help="拷贝文件", aliases=["copy"])
        cp.add_argument("-r", "--recursive", action="store_true",
                        required=False, help="递归的拷贝目录")
        cp.add_argument(dest="from", help="拷贝的源文件或者目录")
        cp.add_argument(dest="to", help="拷贝到的目标文件或者目录")

    def call(self, namespace) -> None:
        pass

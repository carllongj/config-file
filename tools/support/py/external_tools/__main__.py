import argparse
import os
from pathlib import *
from typing import Dict, AnyStr

import rtoml

from external_tools import *


# 增加文件拷贝的命令行内容
# def __add_copy_handler(sub_parsers) -> None:
#     cp = sub_parsers.add_parser("cp", help="拷贝文件", aliases=["copy"])
#     cp.add_argument("-r", "--recursive", action="store_true",
#                     required=False, help="递归的拷贝目录")
#     cp.add_argument(dest="from", help="拷贝的源文件或者目录")
#     cp.add_argument(dest="to", help="拷贝到的目标文件或者目录")


# def __add_replace_handler(sub_parser) -> None:
#     re_sub = sub_parser.add_parser("re", help="替换文件内容处理", aliases=["replace"])
#     re_sub.add_argument("-e", "--environment", dest="env",
#                         choices=["local", "test"], required=False,
#                         default="dev", help="指定当前 spring.profiles.active 的值,它将替换指定的内容")
#
#     re_sub.add_argument(dest="path", help="需要替换内容的文件路径")


# 后续实现
def __add_default_handler(root_parser: argparse.ArgumentParser) -> None:
    pass


# 获取配置环境变量的设置
def __get_config_path_from_env() -> Path:
    key = "EXT_TOOLS_CONFIG_PATH"
    path_string = os.getenv(key)
    if path_string:
        return Path(path_string)
    else:
        default_path = "~/.config/ext_tools/config.toml"
        configPath = Path(default_path)
        return configPath


# 获取配置类信息
def __get_config() -> ExtConfig:
    # 获取配置的文件路径地址
    config_path = __get_config_path_from_env()

    # 若当前指定的配置路径是一个文件并且存在
    if config_path.is_file() and config_path.exists():
        config_data = rtoml.load(config_path)
        return ExtConfig(disable_default=config_data["disable_default_handlers"],
                         scan_path=config_data["handler_scan_path"])

    # 返回默认的配置类
    return ExtConfig.default_config()


# 获取所有的处理器类
def __get_all_handlers(config: ExtConfig) -> Dict[AnyStr, CommandHandler]:
    pass


def handle():
    # 获取配置类
    config = __get_config()

    # 创建命令行工具
    root_parser = argparse.ArgumentParser("external_tools")

    # 使用子命令解析的方式来处理
    # 必须要指定 dest ,否则不能获取到 是哪一个子命令解析器的命令
    sub_parser = root_parser.add_subparsers(dest="sub_parser_name", title="子命令列表", help="增加子命令处理列表")

    # 获取所有的处理器检查其是否合法并准备进行迭代
    handlers = __get_all_handlers(config)

    # 注册所有处理器实现的命令行参数接口
    for handler in handlers.values():
        handler.register(sub_parser)

    # 针对每一个子命令都增加处理方式
    # 增加拷贝文件的命令行处理
    # __add_copy_handler(sub_parser)

    # 增加替换文件内容操作
    # __add_replace_handler(sub_parser)

    # 解析当前的所有参数,并且获取其内容
    namespace = root_parser.parse_args()

    # 查找到对应的处理器,并且调用其执行方法,并且传入参数
    handlers[namespace.sub_parser_name].call(namespace)


if __name__ == '__main__':
    handle()

"""
   此模块用于基于 JetBrains IDEA 系列开发者工具提供的 external_tools 的扩展.
   它旨在复用同一套代码框架,通过命令的方式简化调用,而不用写更多的脚本文件
"""
from abc import ABCMeta, abstractmethod, abstractproperty
from typing import *

__all__ = [
    "CommandHandler",
    "ExtConfig"
]


class CommandHandler(metaclass=ABCMeta):
    """
     用于注册当前脚本文件到命令行工具中类它遵循以下逻辑

     所有的提供子命令的文件必须要实现该类,它会调用指定目录下的所有文件
     并且传递子命令处理,需要文件去实现 register 函数来注册命令到命令行工具中.

     并且会根据命令行工具匹配到的子命令,从而来调用 call 函数

    """

    @property
    @abstractmethod
    def command_name(self) -> AnyStr:
        pass

    # 定义注册的命令行参数
    @abstractmethod
    def register(self, sub_parser) -> None:
        pass

    # 当处理的命令为当前的子命令时,调用该函数
    @abstractmethod
    def call(self, namespace) -> None:
        pass


class ExtConfig(object):
    # 默认构造函数
    def __init__(self, disable_default: bool = False, scan_path: List[AnyStr] = None):
        self.__disable_default = disable_default
        self.__scan_path = []
        self.__scan_path.extend(scan_path)

    # 增加扫描的路径
    def add_scan_path(self, scan_path: AnyStr):
        if scan_path:
            self.__scan_path.append(scan_path)

    @staticmethod
    def default_config():
        return ExtConfig()

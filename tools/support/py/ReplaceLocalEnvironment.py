#
# 调用时需要传入指定的文件绝对路径
# IDEA 运行时添加一个 External Tool
#    Program 填入命令的执行路径
#    D:\carl\work\script\src\main\groovy\ReplaceLocalEnvironment.py
#    Arguments 填入 <test/local> $ModuleFileDir$
#    运行的 Configuration 中 增加一个 before launch task,选择该 Tool即可
#
# 此工具的主要是通过修改编译之后 classpath 下的配置文件,达到不去修改原始配置文件
#   而是通过修改编译生成后的文件(此文件随时可以删除)来修改配置.
#

import re
import sys
from io import StringIO
from pathlib import *
from typing import List, Dict, Any, AnyStr

from ruamel.yaml import YAML

build_path = 'target/classes'

devFileList = ["bootstrap.yml", "<other-file>"]
test_service = r"<ip:port>"
local_service = "<ip:port>"


def add_yaml_config_property(data: Dict, key: AnyStr, value: Any) -> None:
    # 使用 . 作为 key的层级分隔符
    keys = key.split(".")
    for index, item in enumerate(keys):
        # 可以插入最终的 value 了
        if index == len(keys) - 1:
            if item not in data:
                data[item] = value
            else:
                origin_value = data[item]
                if origin_value is list:
                    if value is list:
                        origin_value.extend(value)
                    else:
                        # value 视为元素加入
                        origin_value.append(value)

                elif not origin_value:
                    data[item] = value
                else:
                    raise Exception("Unsupported operation")
            # 继续往下查找 key 层级
        else:
            # key 中不存在该值
            if item not in data:
                data[item] = {}

        data = data[item]


class ReplaceContext(object):
    def __init__(self, environment: str, path: Path) -> None:
        self.__environment = environment
        self.__path = path
        self.__compile_path = path.joinpath(build_path)

    def get_module_name(self) -> str:
        return self.__path.name[self.__path.name.rfind('-') + 1:]

    def handle(self) -> None:
        self.__private_handle()

    def __private_handle(self) -> None:
        for f in devFileList:
            replace_file_path = Path(self.__compile_path).joinpath(f)
            if replace_file_path.exists() and replace_file_path.is_file():
                origin_text = replace_file_path.open(
                    'r', encoding="utf-8").read()
                if f.endswith("yml") or f.endswith("yaml"):
                    text = self.__add_yaml_config(origin_text)
                elif self.__environment == 'local':
                    # 若是本地环境变量则需要进行替换 nacos 配置
                    text = re.sub(
                        test_service, local_service, origin_text)
                else:
                    # 不作任何修改
                    text = origin_text

                replace_file_path.unlink()
                replace_file_path.open(
                    "w", encoding="utf-8").write(text)

    # 添加默认的一些 nacos 配置信息
    def __add_yaml_config(self, content: AnyStr) -> str:
        yaml = YAML()
        stream = StringIO(content)
        data = yaml.load(stream)
        # 用以解决多网卡下注册 nacos 的IP地址不正确的问题
        add_yaml_config_property(data, "spring.cloud.inetutils.preferred-networks",
                                 [r"^192.168.0.*", r"^192.168.222.*"])
        # 添加 SQL 日志打印
        add_yaml_config_property(
            data, f"logging.level.org.carl.{self.get_module_name()}.mapper", "DEBUG")

        # 若是本地环境变量,需要替换掉 nacos config 的服务配置
        if self.__environment == 'local':
            nacos_config = data["spring"]["cloud"]["nacos"]["config"]
            nacos_config["server-addr"] = "<ip:port>"
            nacos_config["namespace"] = "<namespace>"

        stream.seek(0)
        yaml.dump(data, stream)
        updated_content = stream.getvalue()
        stream.close()
        return updated_content


def parser_context(args: List[str]) -> ReplaceContext:
    if not args:
        raise Exception("未指定参数替换路径")
    environment = args[0]
    src_path = Path(args[1]).joinpath(*args[2:])
    return ReplaceContext(environment, src_path)


if __name__ == "__main__":
    # sys.argv[0] is current file path
    context = parser_context(sys.argv[1:])
    context.handle()

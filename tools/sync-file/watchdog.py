import os
import time
import rtoml

from watchdog.events import *
from watchdog.observers import *
from pathlib import *

CONFIG_FILE = 'config.toml'


def judgePath(eventPath: str, config) -> tuple[str]:
    path_mapping_list = config['path_list']
    for item in path_mapping_list:
        if eventPath.startswith(item['src_path']):
            return item['src_path'], item['dest_path']


def parseConfig(config_path: str) -> dict:
    config_data = rtoml.load(Path(config_path))
    config = config_data['sync']
    return config


def parseOptions(rsync_config) -> str:
    options = "-av"
    if 'with_quiet' in rsync_config and rsync_config['with_quiet']:
        options += "q"
    return options


def checkRsyncEnv(config) -> None:
    exec_path = Path(config['rsync_path'])
    if not exec_path.exists():
        raise FileNotFoundError("rsync can not be found")


class Handler(FileSystemEventHandler):
    def __init__(self, config) -> None:
        super().__init__()
        self.rsync_config = config['rsync']
        self.config = config

    def on_any_event(self, event):
        src_path, dest_path = judgePath(event.src_path, self.config)
        cmd = f"{self.rsync_config['rsync_path']} {parseOptions(self.rsync_config)} {src_path} {dest_path}"
        os.system(cmd)


if __name__ == '__main__':
    try:
        config = parseConfig(CONFIG_FILE)
        checkRsyncEnv(config['rsync'])
    except Exception as e:
        raise e
    handler = Handler(config)
    observer = Observer()
    path_mapping_list = config['path_list']
    for item in path_mapping_list:
        observer.schedule(handler, item['src_path'], recursive=True)

    observer.start()

    try:
        while True:
            time.sleep(1)
    except (KeyboardInterrupt, IOError) as e:
        observer.stop()
    observer.join()

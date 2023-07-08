#!/bin/bash
# define variable
DEFAULT_PORT=13044
TARGET_DIR=target

function log_error() {
    echo -e " $(date '+%Y-%m-%d %T')  \033[31m   [ERROR]   :   $* \033[0m"
}

function usage(){
    echo "./runJar.sh <directory>"
}

DEBUG_MODULE=$1
if [[ -z ${DEBUG_MODULE} ]]
    then
        log_error "DEBUG_MODULE not specific"
        usage
        exit 1
fi

cd ${DEBUG_MODULE}
module_name=${DEBUG_MODULE%/*}

jarFile=$(ls ${TARGET_DIR} |grep -i ${module_name}|grep -v original)
java -agentlib:jdwp=transport=dt_socket,address=${DEFAULT_PORT},suspend=n,server=y \
    -jar ${TARGET_DIR}/${jarFile} --spring.profiles.active=dev
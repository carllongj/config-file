#!/bin/bash

set -e
RECORD_FILE_PATH=/home/carllongj/.cache/battery
RECORD_FILE_FORMAT=batter_monitory_
# MAIL_TO=<email here>

function log_warning(){
    echo -e " $(date '+%Y-%m-%d %T')  \033[33m      [WARN] :   $* \033[0m"
}

function log_error(){
    echo -e " $(date '+%Y-%m-%d %T')  \033[31m     [ERROR] :   $* \033[0m"
}

function get_capacity_by_upower(){

    if ! command -v upower &> /dev/null ;then
        log_warning "command [upower] not found."
        return 5
    fi

    capacity=$(upower -i "$(upower -e |grep -i bat)"|grep -i percent|awk '{print $2}'|sed 's/%//')
    code=$?
    if [[ ${code} -eq 0 ]];then
        echo "${capacity}"
        return 0
    fi
    return 5
}

function get_capacity_by_power_supply() {
    if [[ -f /sys/class/power_supply/BAT1/capacity ]];then
        cat /sys/class/power_supply/BAT1/capacity
        return 0
    fi
    return 5
}

# 该函数用以检测电脑当前的电量
function get_battery_capacity(){
    capacity=$(get_capacity_by_upower)
    exit_code=$?

    if [[ ${exit_code} -eq 5 ]];then
      capacity=$(get_capacity_by_power_supply)
      exit_code=$?
    fi

    if [[ ${exit_code} -eq 5 ]];then
        log_error "battery capacity cannot be obtain"
        exit 1
    fi
    echo "${capacity}"
}

function pre_handle(){
    if [[ ! -d ${RECORD_FILE_PATH} ]];then
        mkdir -p ${RECORD_FILE_PATH}
    fi
}

function message_to(){
    # 获取当前的电量.
    capacity=$1
    # 创建文件标识任务已经完成.
    touch "${RECORD_FILE_PATH}/${RECORD_FILE_FORMAT}$(date '+%Y%m%d')"
    # 终端发送通知.
    wall "Battery Capacity Warnning ${capacity} - $(date '+%Y%m%d %T')"
    # 发送邮件通知.
    echo -e "Subject: Battery Capacity Warnning\n\n ${capacity}% of the current battery is left on $(date '+%Y%m%d %T')" \
        | msmtp -a 163 "${MAIL_TO}"
}

function battery_monitor(){
    # 预处理任务,建立监控目录
    pre_handle
    today_file=${RECORD_FILE_PATH}/${RECORD_FILE_FORMAT}$(date '+%Y%m%d')
    if [[ -f ${today_file} ]];then
        exit 0
    fi

    capacity=$(get_battery_capacity)
    if [[ ${capacity} -ne 100 ]];then
        message_to "${capacity}"
    fi
}

battery_monitor

#!/bin/bash

function log_error(){
    echo -e " $(date '+%Y-%m-%d %T')  \033[31m     [ERROR] :   $* \033[0m"
}

function log_success(){
    echo -e " $(date '+%Y-%m-%d %T')  \033[32m   [SUCCESS] :   $* \033[0m"
}

function log_warning(){
    echo -e " $(date '+%Y-%m-%d %T')  \033[33m      [WARN] :   $* \033[0m"
}

function log_normal(){
    echo -e " $(date '+%Y-%m-%d %T')               :   $* \033[0m"
}
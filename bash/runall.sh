#!/bin/bash

_projects_ignore=("." ".." ".idea" "logs")
rootPath=$(pwd)

function log_error() {
  echo -e " $(date '+%Y-%m-%d %T')  \033[31m   [ERROR]   :   $* \033[0m"
}

function log_success() {
  echo -e " $(date '+%Y-%m-%d %T')  \033[32m   [SUCCESS] :   $* \033[0m"
}

function log_warning() {
  echo -e " $(date '+%Y-%m-%d %T')  \033[33m   [WARN]    :   $* \033[0m"
}

function log_normal() {
  echo -e " $(date '+%Y-%m-%d %T')               :   $* \033[0m"
}

# check is in
function isIn() {
  local module=$1
  for ignore in ${_projects_ignore[@]}; do
    if [[ ${ignore} == ${module} ]]; then
      return 0
    fi
  done
  return 1
}

function executeCmd() {
  local module=$1
  shift
  log_normal "start to execute command [$*] in module [${module}]"
  eval $*
  local returnValue=$(echo $?)
  if [[ ! ${returnValue} -eq 0 ]]; then
    log_error "module [${module}] execute command [$*] error"
  fi
}

cd ${rootPath}

for file in $(ls); do
  isIn ${file}
  isIgnore=$(echo $?)
  if [[ ${isIgnore} -eq 1 ]] && [[ -d ${file} ]]; then
    cd ${file}
    echo ""
    log_success "change directory [${file}]"
    executeCmd ${file} $*
    echo ""
    cd ${rootPath}
  fi
done

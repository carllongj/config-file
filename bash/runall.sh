#!/bin/bash

_projects_ignore=("." ".." ".idea" "logs")
rootPath=$(pwd)
enable_summary=1
enable_command_check=1

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

function isInArray() {
  local module=$1
  shift
  local read_array=$@
  for ignore in ${read_array[@]};do
    if [[ ${ignore} == ${module} ]];then
      return 0
    fi
  done
  return 1
}

function doExecuteCmd() {
  local module=$1
  shift
  log_normal "start to execute command [$*] in module [${module}]"
  eval $*
  local returnValue=$(echo $?)
  if [[ ! ${returnValue} -eq 0 ]]; then
    log_error "module [${module}] execute command [$*] error"
    return 1
  fi
  return 0
}


error_module=()
external_ignore=()
declare -i count=0

function push_external_ignore_module() {
  local module_name=$1
  module_name=${module_name%/*}
  isInArray ${module_name} ${external_ignore}
  isExternalIgnore=$(echo $?)
  if [[ ${isExternalIgnore} -eq 1 ]];then
    external_ignore[count]=${module_name}
    let count++
  fi
}

function executeSummary(){
  if [[ ${enable_summary} -eq 1 ]] && [[ ${#error_module[@]} -gt 0 ]];then
    echo "--------------summary-----------------"
    for (( i = 0; i < ${#error_module[@]}; i++ )); do
      log_error ${error_module[i]}
    done
  fi
}

function command_check() {
  $(command -v $1 > /dev/null 2>&1)
  canExecute=$(echo $?)
  if [[ ! ${canExecute} -eq 0 ]];then
    log_error "[$1] is not a command,[$*] can not execute"
    exit 1
  fi
}

function executeCmd() {
  cd ${rootPath}
  if [[ ${enable_command_check} -eq 1 ]] ;then
    command_check $*
  fi
  for file in $(ls); do
    isInArray ${file} ${_projects_ignore[@]}
    local isIgnore=$(echo $?)
    if [[ ${isIgnore} -eq 1 ]] && [[ -d ${file} ]]; then
      isInArray ${file} ${external_ignore[@]}
      local ext_ignore=$(echo $?)
      if [[ ${ext_ignore} -eq 1 ]];then
        cd ${file}
        echo ""
        log_success "change directory [${file}]"
        doExecuteCmd ${file} $*
        returnValue=$(echo $?)
        if [[ ${enable_summary} -eq 1 ]] && [[ ! ${returnValue} -eq 0 ]];then
            error_module+=("module [${file}] execute [$*] error")
        fi
        echo ""
        cd ${rootPath}
      else
        log_success "module ${file} is ignored"
      fi
    fi
  done
  executeSummary
}

# parse command options
while getopts 'e:sc' OPT;do
  case ${OPT} in
    e)
      push_external_ignore_module ${OPTARG}
      ;;
    s)
      # disable_summary
      enable_summary=0
      ;;
    c)
      # disable command check
      enable_command_check=0
      ;;
  esac
done

# skip command options
shift $((OPTIND - 1))
executeCmd $*

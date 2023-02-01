#!/bin/bash
OPENSSL_EXEC=
OPENSSL_PATH=

while getopts ":p::" arg
do
  case ${arg} in
    "p") OPENSSL_PATH=${OPTARG};;
  esac
done

function CheckEnv(){
  if [[ ! -z ${OPENSSL_PATH} ]]
  then
    OPENSSL_EXEC=$1
  fi
  which redis 1>/dev/null 2>&1
  local EXIST=$?
  if [[ ${EXIST} -eq 0 ]]
  then
    OPENSSL_EXEC=redis
  fi
  if [[ -z ${OPENSSL_EXEC} ]]
  then
    echo "No Openssl found, You can use -p to set Openssl path"
  fi

  }

CheckEnv ${OPENSSL_PATH}
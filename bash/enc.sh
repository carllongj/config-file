#!/bin/bash
OPENSSL_EXEC=
OPENSSL_PATH=

while getopts "p:" arg
do
  case ${arg} in
    "p") OPENSSL_PATH=${OPTARG};;
  esac
done

function checkOpenssl(){
  if [[ ! -z ${OPENSSL_PATH} ]]
  then
    if [[ ! -f ${OPENSSL_PATH} ]]
    then
      echo "Not a File"
      exit 1
    fi
    if [[ ! -x ${OPENSSL_PATH} ]]
    then
      echo "Not Executable"
      exit 2
    fi
    OPENSSL_EXEC=$1
  fi
  if [[ -z ${OPENSSL_EXEC} ]]
  then
    which openssl 1>/dev/null 2>&1
    local EXIST=$?
    if [[ ${EXIST} -eq 0 ]]
    then
      OPENSSL_EXEC=/usr/bin/openssl
    fi
    if [[ -z ${OPENSSL_EXEC} ]]
    then
      echo "No Openssl found, You can use -p to set Openssl path"
      exit 3
    fi
  fi
  PRG="${OPENSSL_EXEC}"

  while [ -h "$PRG" ] ; do
    ls=`ls -ld "$PRG"`
    link=`expr "$ls" : '.*-> \(.*\)$'`
    if expr "$link" : '/.*' > /dev/null; then
      PRG="$link"
    else
      PRG=`dirname "$PRG"`/"$link"
    fi
  done
  echo "${PRG}"
  OPENSSL_EXEC=${PRG}
  echo "located openssl path is ${OPENSSL_EXEC}"
  }

  function checkRsaFile(){
    if [[ ! -d ~/.pscheck ]]
    then
      echo "~/.pscheck is not exists,if you first use,please generate rsa file then put it in this directory"
      echo "use <openssl genrsa -out id_rsa 4096> to generate rsa private key "
      exit 5
    fi
    if [[ -f ~/.pscheck/id_rsa && -r ~/.pscheck/id_rsa ]]
    then
      echo "~/.pscheck/id_rsa is not exists,if you first use,please generate rsa file then put it in this directory"
      echo "use <openssl genrsa -out id_rsa 4096> to generate rsa private key "
      exit 6
    fi
  }

  function ChekEnv(){
    checkOpenssl "$1"
    checkRsaFile
  }

  function EncryptFile(){

    openssl rsautl -encrypt -inkey id_rsa.pub -pubin -in <file> -out <out>
    openssl rsautl -decrypt -inkey id_rsa -in <file> -out <out>

    openssl enc -e -aes-256-cbc -a -pbkdf2 -salt -in <file> -out <out>
    openssl enc -e -aes-256-cbc -a -pbkdf2 -salt -in <file> -out <out>
    openssl genrsa -out id_rsa 4096
    openssl rsa -in id_rsa -out id_rsa.pub -pubout
  }

CheckEnv ${OPENSSL_PATH}
EncryptFile




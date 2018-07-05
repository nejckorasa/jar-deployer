#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
usage="usage: $(basename "$0") [-h] [-r] [-s] [-t] -n name
  options:
    -n name       Name of JAR (including .jar extension)
    -r restart    Restart jar once deployed
    -t target     Set target, for instance demo1
    -s SSH target Set SSH target, for instance -s usr@my_host -t /home/usr/remote/dir/path
    -h [help]
"
set -e

TARGET_DIR_VAL=""
SSH_VAL=""
RESTART=0

# Read input params

while getopts ht:s:n:r option
do
 case "${option}" in
 h) echo "$usage"
    exit
    ;;
 t) TARGET_ENV=${OPTARG}
    echo " 🎯🎯 Target is [ $TARGET_ENV ] 🎯🎯 "
    ;;
 r) echo " Restart is enabled "
    RESTART=1
    ;;
 s) SSH_VAL=${OPTARG}
    echo " 🎯🎯 SSH target is [ $SSH_VAL ] 🎯🎯 "
    ;;
 n) FILE_NAME=${OPTARG}
    echo " JAR file name is [ $FILE_NAME ] "
    ;;
 esac
done

if [ -z ${TARGET_ENV+x} ];
then
  echo "target [ -t ] needs to be set"
  exit 1
fi

if [ -z ${FILE_NAME+x} ];
then
  echo "JAR file name [ -n ] needs to be set"
  exit 1
fi

# Predefined targets
# Option to add predefined targets: SSH target + target DIR
# See above example for "my_specific_host"

if [ "$TARGET_ENV" == "my_specific_host" ]; then

	 TARGET_DIR_VAL="/home/usr/remote/dir/path"
	 SSH_VAL="ispek@my_specific_host"

else

  TARGET_DIR_VAL=${TARGET_ENV}
  if [ -z ${SSH_VAL} ];
  then
    echo "target [ -s ] needs to be set if target is unknown"
    exit 1
  fi
fi

# Deploy

echo " ⚙️⚙️  Deploying $FILE_NAME to [ $SSH_VAL:$TARGET_DIR_VAL ] ⚙️⚙️ "

scp ${DIR}/${FILE_NAME} "$SSH_VAL":${TARGET_DIR_VAL}

if [ ${RESTART} == 0 ]; then
  echo " 🎉🎉🎉🎉 Done 🎉🎉🎉🎉 "
  exit 0
fi

# Restart

echo " ⚙️⚙️ Restarting $FILE_NAME ⚙️️⚙️ "

ssh "$SSH_VAL" "cd ${TARGET_DIR_VAL} ; bash" << EOF

  ./${FILE_NAME} restart
EOF

echo " 🎉🎉🎉🎉 Done 🎉🎉🎉🎉 "
exit 0

#!/bin/bash
set -e
ROOT=$(dirname $(readlink -f "$0"))

BUILDROOT_PATH=${ROOT}/buildroot
BUILDROOT_EXT_CONFIG_PATH=${ROOT}/configs
CONFIG_MERGE_TOOL=${ROOT}/merge-config.sh
OUTPUT=${ROOT}/output
EXTERNAL=${ROOT}
CONFIG=merged_defconfig
CONTAINER_CONFIGS=$(cd ${ROOT}/configs && ls *_defconfig|grep -v merged)
CONFIG_LIST=

# Clone official buildroot project from env variables
if [ ! -e ${BUILDROOT_PATH} ]; then
  echo "Clone official buildroot project."
  git clone -b ${BUILDROOT_TAG} ${BUILDROOT_GIT_URL}
fi

if [ $# -eq 0 ]; then
  echo "Build source code of all containers"
  for container in ${CONTAINER_CONFIGS[@]}
  do
    CONFIG_LIST+="${BUILDROOT_EXT_CONFIG_PATH}/${container} "
  done
fi

${CONFIG_MERGE_TOOL} -m -O ${ROOT} ${CONFIG_LIST}
mv -v ${ROOT}/.config ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}

/usr/bin/make -C ${BUILDROOT_PATH} O=${OUTPUT} BR2_EXTERNAL=${EXTERNAL} ${CONFIG}
/usr/bin/make -C ${BUILDROOT_PATH} O=${OUTPUT} $@

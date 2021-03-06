#!/bin/bash
set -e
ROOT=$(dirname $(readlink -f "$0"))

BUILDROOT_PATH=${ROOT}/buildroot
BUILDROOT_EXT_CONFIG_PATH=${ROOT}/minic-container/configs
CONFIG_MERGE_TOOL=${ROOT}/merge-config.sh
OUTPUT=${ROOT}/minic-container/output
EXTERNAL=${ROOT}/minic-container/
CONFIG=merged_defconfig
CONTAINER_CONFIGS=$(cd ${ROOT}/minic-container/configs && ls *_defconfig|grep -v merged|grep -v template)
CONFIG_LIST=

POST_BUILD_SCRIPTS=
ROOTFS_OVERLAYS=
POST_FAKEROOT_SCRIPT=
POST_IMAGE_SCRIPTS=

# Clone official buildroot project from env variables
if [ ! -e ${BUILDROOT_PATH} ]; then
  echo "Clone official buildroot project."
  git clone -b ${BUILDROOT_TAG} ${BUILDROOT_GIT_URL}
fi

if [ $# -ne 0 ] && [ ! -f "${BUILDROOT_EXT_CONFIG_PATH}/$@_defconfig" ]; then
  echo "${BUILDROOT_EXT_CONFIG_PATH}/$@_defconfig not found"
  exit 1

fi

if [ $# -eq 0 ]; then
  echo "Build source code of all containers"
  for container in ${CONTAINER_CONFIGS[@]}
  do
    CONFIG_LIST+="${BUILDROOT_EXT_CONFIG_PATH}/${container} "
    POST_BUILD_SCRIPTS+="$(grep BR2_ROOTFS_POST_BUILD_SCRIPT ${BUILDROOT_EXT_CONFIG_PATH}/${container} 2>/dev/null | sed 's/BR2_ROOTFS_POST_BUILD_SCRIPT=\"\(.*\)\"/\1 /')"
    ROOTFS_OVERLAYS+="$(grep BR2_ROOTFS_OVERLAY ${BUILDROOT_EXT_CONFIG_PATH}/${container} 2>/dev/null | sed 's/BR2_ROOTFS_OVERLAY=\"\(.*\)\"/\1 /')"
    POST_FAKEROOT_SCRIPTS+="$(grep BR2_ROOTFS_POST_FAKEROOT_SCRIPT ${BUILDROOT_EXT_CONFIG_PATH}/${container} 2>/dev/null | sed 's/BR2_ROOTFS_POST_FAKEROOT_SCRIPT=\"\(.*\)\"/\1 /')"
    POST_IMAGE_SCRIPTS+="$(grep BR2_ROOTFS_POST_IMAGE_SCRIPT ${BUILDROOT_EXT_CONFIG_PATH}/${container} 2>/dev/null | sed 's/BR2_ROOTFS_POST_IMAGE_SCRIPT=\"\(.*\)\"/\1 /')"
  done
  ${CONFIG_MERGE_TOOL} -m -O ${ROOT} ${CONFIG_LIST}
  mv -v ${ROOT}/.config ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}

  # Merge all BR2_ROOTFS_POST_BUILD_SCRIPT
  sed -i '/BR2_ROOTFS_POST_BUILD_SCRIPT/d' ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}
  echo "BR2_ROOTFS_POST_BUILD_SCRIPT=\"${POST_BUILD_SCRIPTS}\"" >> ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}

  # Merge all BR2_ROOTFS_OVERLAY
  sed -i '/BR2_ROOTFS_OVERLAY/d' ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}
  echo "BR2_ROOTFS_OVERLAY=\"${ROOTFS_OVERLAYS}\"" >> ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}

  # Merge all BR2_ROOTFS_POST_FAKEROOT_SCRIPT
  sed -i '/BR2_ROOTFS_POST_FAKEROOT_SCRIPT/d' ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}
  echo "BR2_ROOTFS_POST_FAKEROOT_SCRIPT=\"${POST_FAKEROOT_SCRIPTS}\"" >> ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}

  # Merge all BR2_ROOTFS_POST_IMAGE_SCRIPT
  sed -i '/BR2_ROOTFS_POST_IMAGE_SCRIPT/d' ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}
  echo "BR2_ROOTFS_POST_IMAGE_SCRIPT=\"${POST_IMAGE_SCRIPTS}\"" >> ${BUILDROOT_EXT_CONFIG_PATH}/${CONFIG}

  /usr/bin/make -C ${BUILDROOT_PATH} O=${OUTPUT} BR2_EXTERNAL=${EXTERNAL} ${CONFIG}
else
  /usr/bin/make -C ${BUILDROOT_PATH} O=${OUTPUT} BR2_EXTERNAL=${EXTERNAL} $@_defconfig
fi

/usr/bin/make -C ${BUILDROOT_PATH} O=${OUTPUT}

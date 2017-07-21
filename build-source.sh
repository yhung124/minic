#!/bin/bash
ROOT=$(dirname $(readlink -f "$0"))
source ${ROOT}/config.sh

if ! docker images | grep ${MINIC_BUILDER_IMAGE} | grep ${MINIC_BUILDER_IMAGE_TAG} > /dev/null; then
  docker build -t ${MINIC_BUILDER_IMAGE}:${MINIC_BUILDER_IMAGE_TAG} .
fi

docker run -it -v ${ROOT}/build-home:/home/build -v ${ROOT}/containers:/home/build/containers ${MINIC_BUILDER_IMAGE}:${MINIC_BUILDER_IMAGE_TAG} /home/build/make.sh

#!/bin/bash
set -e

command -v docker > /dev/null 2>&1 || { echo "Command not found: docker"; exit 1; }
source ../base.sh
source ./prj.sh

# Prepare a fake base image
cp -v ../Dockerfile .
docker build -t ${FAKE_IMG} .

# Remove unused line in Dockerfile
sed -i.back "/COPY dist/d" ${ORIG_PRJ}/${ORIG_DOCKERFILE}

# Start to build original image
pushd . > /dev/null 2>&1
cd ${ORIG_PRJ}
docker build -t ${REGISTRY}/${ORIG_IMG}:${TAG} -f ./${ORIG_DOCKERFILE} .
docker build -t ${REGISTRY}/${ORIG_IMG}:${CDX_TAG} -f ./${ORIG_DOCKERFILE} .
popd > /dev/null 2>&1

echo "Generate ${REGISTRY}/${ORIG_IMG}:${TAG} done"
echo "Generate ${REGISTRY}/${ORIG_IMG}:${CDX_TAG} done"

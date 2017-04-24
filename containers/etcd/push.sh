#!/bin/bash
set -e
command -v docker > /dev/null 2>&1 || { echo "Command not found: docker"; exit 1; }

source $(dirname ${BASH_SOURCE[0]})/../base.sh
source $(dirname ${BASH_SOURCE[0]})/prj.sh

echo -e "Start to push ${ORIG_IMG}\n"

docker push ${REGISTRY}/${ORIG_IMG}:${TAG}
docker push ${REGISTRY}/${ORIG_IMG}:${CDX_TAG}

echo -e "Push ${REGISTRY}/${ORIG_IMG}:${TAG} done\n"

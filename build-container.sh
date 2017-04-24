#!/bin/bash
set -e
ROOT=$(dirname $(readlink -f "$0"))
command -v docker > /dev/null 2>&1 || { echo "Command not found: docker"; exit 1; }

ALL_CONTAINERS=$(cd containers && ls -d */)
for con in ${ALL_CONTAINERS}; do
  echo -e "\nStart to build container image: ${con//\//} \n"
  pushd . >/dev/null 2>&1
  cd ${ROOT}/containers/${con}
  ./build.sh
  popd >/dev/null 2>&1
  echo -e "Build container image ${con//\//} done\n"
done

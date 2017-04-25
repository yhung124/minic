#!/bin/bash
set -e
ROOT=$(dirname $(readlink -f "$0"))
source ${ROOT}/config.sh

ALL_CONTAINERS=$(cd ${ROOT}/containers && ls -d */)
for con in ${ALL_CONTAINERS}; do
  echo -e "\nStart to push container image: ${con//\//} \n"
  pushd . >/dev/null 2>&1
  cd ${ROOT}/containers/${con}
  ./push.sh
  popd >/dev/null 2>&1
  echo -e "Build container image ${con//\//} done\n"
done

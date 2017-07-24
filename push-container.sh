#!/bin/bash
set -e
ROOT=$(dirname $(readlink -f "$0"))

if [ ! -d "${ROOT}/minic-container" ]; then
  echo "Where is minic-container folder?"
  echo "git clone GIT_URL_OF_MINIC_CONTAINER plz"
  echo "ex: git clone https://github.com/yhung124/minic-container.git"
  exit 1

fi
if [ $# -ne 0 ]; then
  if [ ! -d "${ROOT}/minic-container/containers/$@" ]; then
    echo "${ROOT}/minic-container/containers/$@ not found"
    exit 1

  fi

  echo -e "\nStart to push container image: $@\n"
  pushd . >/dev/null 2>&1
  cd ${ROOT}/minic-container/containers/$@
  ./push.sh
  popd >/dev/null 2>&1

else
  ALL_CONTAINERS=$(cd ${ROOT}/minic-container/containers && ls -d */)
  for con in ${ALL_CONTAINERS}; do
    echo -e "\nStart to push container image: ${con//\//} \n"
    cd ${ROOT}/minic-container/containers/${con}
    ./push.sh
    popd >/dev/null 2>&1
    echo -e "Push container image ${con//\//} done\n"
  done
fi

echo "Done"

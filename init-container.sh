#!/bin/bash
set -e
ROOT=$(dirname $(readlink -f "$0"))

if [ ! -d "${ROOT}/minic-container" ]; then
  echo "Where is minic-container folder?"
  echo "git clone GIT_URL_OF_MINIC_CONTAINER plz"
  echo "ex: git clone https://github.com/yhung124/minic-container.git"
  exit 1

fi

echo "Start to initialize all projects"
pushd . > /dev/null 2>&1
if [ $# -ne 0 ]; then
  if [ ! -d "${ROOT}/minic-container/containers/$@" ]; then
    echo "${ROOT}/minic-container/containers/$@ not found"
    exit 1

  fi
  cd ${ROOT}/minic-container/containers/$@

else
  cd ${ROOT}/minic-container/

fi

git submodule init .
time git submodule update .

popd > /dev/null 2>&1
echo "Done"""

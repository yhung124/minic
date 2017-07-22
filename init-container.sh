#!/bin/bash
set -e
ROOT=$(dirname $(readlink -f "$0"))

echo "Start to initialize all projects"
pushd . > /dev/null 2>&1
cd ${ROOT}/minic-container
git submodule init
time git submodule update
echo "Done"""
popd > /dev/null 2>&1


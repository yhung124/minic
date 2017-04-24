#!/bin/bash
set -e

echo "Start to initialize all projects"
git submodule init
time git submodule update
echo "Done"""

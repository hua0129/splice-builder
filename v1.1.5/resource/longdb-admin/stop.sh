#!/bin/sh

script_abs=$(readlink -f "$0")
script_dir=$(dirname $script_abs)

cd $script_dir

./run.sh stop



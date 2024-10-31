#!/bin/bash

set -xe

SCRIPT_DIR="$(dirname $0)"

mpirun -N 8 -bind-to none -display-map \
       -x GPU_AFFINITY='0:1:2:3:4:5:6:7' \
       -x MEM_AFFINITY='1:1:0:0:3:3:2:2' \
       -x CPU_AFFINITY='24-35:36-47:0-11:12-23:72-83:84-95:48-59:60-71' \
       $SCRIPT_DIR/mpibind.sh uname -r

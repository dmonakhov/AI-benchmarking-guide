#!/bin/bash

#virtualenv env
source env/bin/activate
# FIXUP for nvjitlink package
export LD_LIBRARY_PATH=:$VIRTUAL_ENV/lib/python3.10/site-packages/nvidia/nvjitlink/lib:$LD_LIBRARY_PATH

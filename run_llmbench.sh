#!/bin/bash

docker stop $(docker ps -q)
set -x

CUR_LOG=results/run.$(date +%y-%m-%d--%H-%M-%S)
mkdir -p $CUR_LOG

echo "$*" >> $CUR_LOG/run_cmd.txt
ec2metadata > $CUR_LOG/ec2metadata.txt
cp config.json $CUR_LOG/
python3 -u runner.py  2>&1 | tee $CUR_LOG/log.log
ret=${PIPESTATUS[0]}
echo "$ret" >> $CUR_LOG/status.txt
mv Outputs $CUR_LOG/Outputs

echo "DONE log: $CUR_LOG status: $ret"
exit $ret

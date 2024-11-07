#!/bin/bash

set -xeuo pipefail

# cat Benchmarks/tensorrt-llm-12.4.0-devel-ubuntu22.04.tar.zst | mpirun -N 1 -hostfile ~/.ssh/mpi_hosts.txt bash -c "mpicat | zstdcat | docker load"

git bundle create cur-bundle origin/main..HEAD
tar c cur-bundle | mpirun -N 1 -hostfile ~/.ssh/mpi_hosts-2.txt bash -c 'mpicat | tar xv; git bundle unbundle cur-bundle'
mpirun -N 1 -hostfile ~/.ssh/mpi_hosts-2.txt git reset --hard $(git rev-parse HEAD)

git log --oneline origin/main..HEAD

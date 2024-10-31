#!/usr/bin/env bash

#set -ueo pipefail

## Defaults
: "${CUDA_VISIBLE_DEVICES:=""}"


fail() {
  local msg=$*
  echo -e "FAIL: ${msg}"
  exit 1
}
 
read_gpu_affinity_map() {
    local affinity_list=$1
    readarray -t GPU_AFFINITY_MAP <<<"$(tr ':' '\n'<<<"$affinity_list")"
}
read_mem_affinity_map() {
    local affinity_list=$1
    readarray -t MEM_AFFINITY_MAP <<<"$(tr ':' '\n'<<<"$affinity_list")"
}

read_cpu_affinity_map() {
    local affinity_list=$1
    readarray -t CPU_AFFINITY_MAP <<<"$(tr ':' '\n'<<<"$affinity_list")"
}


read_rank() {
  # Global rank
  if [ -n "${OMPI_COMM_WORLD_RANK}" ]; then
    RANK=${OMPI_COMM_WORLD_RANK}
  elif [ -n "${PMIX_RANK}" ]; then
    RANK=${PMIX_RANK}
  elif [ -n "${PMI_RANK}" ]; then
    RANK=${PMI_RANK}
  elif [ -n "${SLURM_PROCID}" ]; then
    RANK=${SLURM_PROCID}
  else
    fail "Could not determine global rank"
  fi

  # Same for node local rank
  if [ -n "${OMPI_COMM_WORLD_LOCAL_RANK}" ]; then
    LOCAL_RANK=${OMPI_COMM_WORLD_LOCAL_RANK}
  elif [ -n "${SLURM_LOCALID}" ]; then
    LOCAL_RANK=${SLURM_LOCALID}
  elif [ -n "${MPI_LOCALRANKID}" ]; then
    LOCAL_RANK=${MPI_LOCALRANKID}
  else
    fail "Could not determine local rank"
  fi
}

read_rank

if [[ -n "${GPU_AFFINITY}" ]]; then
  read_gpu_affinity_map $GPU_AFFINITY
  GPU=${GPU_AFFINITY_MAP[$LOCAL_RANK]}
  # FIXME, add map for trainium devices
  export CUDA_VISIBLE_DEVICES=${GPU}
fi

if [[ -n "${MEM_AFFINITY}" ]]; then
  read_mem_affinity_map $MEM_AFFINITY
  MEM=${MEM_AFFINITY_MAP[$LOCAL_RANK]}
  MEMBIND="--membind=${MEM}"
fi

if [[ -n "${CPU_AFFINITY}" ]]; then
  read_cpu_affinity_map $CPU_AFFINITY
  CPU=${CPU_AFFINITY_MAP[$LOCAL_RANK]}
  CPUBIND="--physcpubind=${CPU}"
fi

if [ -n "${MEMBIND}" ] || [ -n "${CPUBIND}" ]; then
  NUMCMD="numactl "
fi

echo "rank:[$RANK/$LOCAL_RANK] gpu:${CUDA_VISIBLE_DEVICES} ${NUMCMD} ${CPUBIND} ${MEMBIND} $@"
${NUMCMD} ${CPUBIND} ${MEMBIND} $@

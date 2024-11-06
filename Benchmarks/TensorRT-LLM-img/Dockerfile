# syntax=docker/dockerfile:1

ARG IMAGE_BASE=nvidia/cuda:12.1.0-devel-ubuntu22.04
FROM ${IMAGE_BASE}

ARG BDIR=/tmp/bld
ARG PYTHON_VER=3.10

# Install common deps
RUN  apt-get update -y && \
     DEBIAN_FRONTEND=noninteractive apt-get install -y \
            python${PYTHON_VER} \
	    python3-pip \
	    openmpi-bin libopenmpi-dev git \
	    git-lfs && \
	    python3 -m pip install pipenv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* \
       /usr/share/doc /usr/share/doc-base \
       /usr/share/man /usr/share/locale /usr/share/zoneinfo

# Install TensorRT-LLM repo
ARG TENSORT_RT_COMMIT=b0880169d0fb8cd0363049d91aa548e58a41be07 # tag=0.14.0
RUN mkdir /workspace && \
     git clone https://github.com/NVIDIA/TensorRT-LLM.git /workspace/TensorRT-LLM  && \
     cd /workspace/TensorRT-LLM && \
     git reset --hard $TENSORT_RT_COMMIT
COPY setup_model_env.sh /workspace/TensorRT-LLM/

# Install dependencies for each model to separate directory to prevent conflicts
ARG MODEL_LIST="llama"
# Install dependencies for each model to pipenv directory to prevent conflicts
# Pipenv usage example:
# cd env/llama; pipenv run python3 -c "import torch; print(torch.__version__)"
RUN cd  /workspace/TensorRT-LLM && \
    ./setup_model_env.sh "${MODEL_LIST}"

ENV PIPENV_VENV_IN_PROJECT=1
WORKDIR  /workspace/TensorRT-LLM
LABEL org.opencontainers.image.authors="monakhov@amazon.com"
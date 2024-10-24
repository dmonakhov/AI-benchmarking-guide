IMAGE_BASE_NAME ?= cuda
IMAGE_NAME ?= tensorrt-llm
IMAGE_BASE_REPO=nvidia/
IMAGE_BASE_TAG  ?= 12.4.0-devel-ubuntu22.04

# podman:// or dockerd://
CT_RUNTIME ?= dockerd://
EXPORT_PATH ?= ..
ZSTD_COMPRESS_OPTIONS ?= --ultra -12

TAG_LLAMA=${IMAGE_BASE_TAG}-llama
TAG_PHI=${IMAGE_BASE_TAG}-phi

MPI_HOSTFILE ?= ~/.ssh/mpi_hosts.txt


fetch:
	docker pull "${IMAGE_BASE_REPO}${IMAGE_BASE_NAME}:${IMAGE_BASE_TAG}"

build-vanilla: build-llama build-phi

build-llama:
	docker build --network=host --progress plain --rm \
		--tag "${IMAGE_NAME}:${TAG_LLAMA}" \
		--build-arg IMAGE_BASE="${IMAGE_BASE_REPO}${IMAGE_BASE_NAME}:${IMAGE_BASE_TAG}" \
		--build-arg MODEL_TYPE="llama" \
		-f Dockerfile.vanilla .
build-phi:
	docker build --network=host --progress plain --rm \
		--tag "${IMAGE_NAME}:${TAG_PHI}" \
		--build-arg IMAGE_BASE="${IMAGE_BASE_REPO}${IMAGE_BASE_NAME}:${IMAGE_BASE_TAG}" \
		--build-arg MODEL_TYPE="phi" \
		-f Dockerfile.vanilla .


tar-img-vanilla:
	docker save \
		"${IMAGE_BASE_REPO}${IMAGE_BASE_NAME}:${IMAGE_BASE_TAG}" \
		"${IMAGE_NAME}:${TAG_LLAMA}" \
		"${IMAGE_NAME}:${TAG_PHI}"| \
		zstdmt ${ZSTD_COMPRESS_OPTIONS} -v -f -o ${EXPORT_PATH}/${IMAGE_NAME}-${TAG_LLAMA}.tar.zst

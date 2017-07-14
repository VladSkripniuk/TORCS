#!/bin/sh

IMAGE_NAME=torcs
NVIDIA_DRIVER=NVIDIA-Linux-x86_64-375.66.run  # path to nvidia driver

cp ${NVIDIA_DRIVER} NVIDIA-DRIVER.run

# git clone hangs inside Dockerfile https://github.com/moby/moby/issues/1474

sudo docker build -t ${IMAGE_NAME} .

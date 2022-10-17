#!/usr/bin/env bash

sudo docker run \
    -it --rm \
    -v /home/hua/academic-budget-bert/:/24h_bert \
    --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864  \
    nvcr.io/nvidia/pytorch:22.04-py3

# but I am not able to install DinkyTrain (which pulls torch from pip and uninstalls nvidia's custom built torch ...)
# both torch are 1.12 :(


# 2022-10-16, Ubuntu, GPU, docker, nvidia docker

## install docker-ce, docker-ce-cli, nvidia-docker. 
* https://docs.nvidia.com/ai-enterprise/deployment-guide/dg-docker.html

* test `docker run --gpus all -it --rm nvcr.io/nvidia/pytorch:xx.xx-py3`
## add myself into docker group

#do not need, already have docker group
#~sudo groupadd docker~

sudo usermod -aG docker $USER

## test nvidia pytorch NCC container
* it normally contains apex, and other good stuff

> The PyTorch NGC Container is optimized for GPU acceleration, and contains a validated set of libraries that enable and optimize GPU performance. This container also contains software for accelerating ETL (DALI, RAPIDS), Training (cuDNN, NCCL), and Inference (TensorRT) workloads.

* my driver is 510.85 (prioperty) with cuda 11.6 (latest pytorch can support) and works out box,
* this corresponding to nvidia ngc container pytorch-22.04
    * test(don't do it actually) `docker run --gpus all -it --rm nvcr.io/nvidia/pytorch:22.04-py3`
    * recommended: `docker run --gpus all --ipc=host --ulimit memlock=-1 --ulimit stack=67108864  -it --rm nvcr.io/nvidia/pytorch:22.04-py3`

    * ngc pytorch-22.04 has ubuntu 20.04, python 3.8, cuda 11.6, pytorch 1.12
    * see release page: https://docs.nvidia.com/deeplearning/frameworks/pytorch-release-notes/index.html 

# deepspeed
* `sudo docker pull deepspeed/deepspeed`
    * it is python 3.6, torch 1.2


ARG REPOSITORY="docker.io"
FROM ubuntu:20.04

# set up timezone and location
RUN apt update && apt install -y tzdata && ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# install python3.9, curl and OpenCV libraries
RUN apt update && apt install -y python3 python3-pip software-properties-common curl ffmpeg libsm6 libxext6
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update && apt install -y python3.9 python3.9-dev && rm /usr/bin/python3 && ln -s /usr/bin/python3.9 /usr/bin/python3 && pip3 install --upgrade pip
ENV OPENCV_IO_ENABLE_JASPER "true"

# install secure torch and its dependencies
RUN DEBIAN_FRONTEND=noninteractive apt install -y --force-yes mpich intel-mkl
ADD "wheels/torch-1.11.0a0+git137096a-cp39-cp39-linux_x86_64.whl" .
RUN pip3 install torch-1.11.0a0+git137096a-cp39-cp39-linux_x86_64.whl
ADD "wheels/torchvision-0.12.0a0+9b5a3fe-cp39-cp39-linux_x86_64.whl" .
RUN pip3 install torchvision-0.12.0a0+9b5a3fe-cp39-cp39-linux_x86_64.whl

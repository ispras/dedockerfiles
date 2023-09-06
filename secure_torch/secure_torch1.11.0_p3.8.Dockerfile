FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y curl wget git software-properties-common build-essential gcc-multilib g++-multilib unzip \
    python-dev python3-pip mpich libpng-dev libjpeg-dev libjpeg-turbo8 libjpeg-turbo8-dev libpng16-16 libpng-tools libpng-dev

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y --force-yes intel-mkl

# Add clang repositories
RUN wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -
RUN add-apt-repository -y ppa:ubuntu-toolchain-r/test
RUN add-apt-repository 'deb http://apt.llvm.org/focal/ llvm-toolchain-focal-14 main'

RUN apt update && apt install -y clang-14 && ln -s /usr/bin/clang-14 /usr/bin/clang && ln -s /usr/bin/clang++-14 /usr/bin/clang++

RUN curl -L -O https://github.com/Kitware/CMake/releases/download/v3.22.1/cmake-3.22.1-linux-x86_64.sh && \
    mkdir /cmake && \
    bash cmake-3.22.1-linux-x86_64.sh --prefix=/cmake --exclude-subdir --skip-license && \
    ln -s /cmake/bin/cmake /bin/cmake && \
    rm cmake-3.22.1-linux-x86_64.sh

RUN wget https://github.com/ninja-build/ninja/releases/download/v1.10.2/ninja-linux.zip && unzip ninja-linux.zip && mv ninja /usr/bin && rm ninja-linux.zip

RUN pip3 install --upgrade pip

# Install deps
RUN pip3 install astunparse numpy ninja pyyaml mkl mkl-include setuptools cmake cffi typing_extensions

# Get PyTorch secure-v1.11.0 (you need folder with source)
ADD pytorch-v1.11.0/pytorch /pytorch
RUN cd /pytorch && git submodule update --init --recursive --jobs 0

# Build and install pytorch
WORKDIR /pytorch
RUN python3 setup.py bdist_wheel
RUN pip3 install dist/torch-1.11.0a0+git137096a-cp38-cp38-linux_x86_64.whl

# Build and install torchvision
WORKDIR /
RUN git clone https://github.com/pytorch/vision.git torchvision && cd /torchvision && git checkout v0.12.0
WORKDIR /torchvision
RUN python3 setup.py build && python3 setup.py bdist_wheel

# Build and install torchdata 
WORKDIR /
RUN git clone https://github.com/pytorch/data.git torchdata && cd /torchdata && git checkout v0.3.0 && git submodule update --init --recursive
WORKDIR /torchdata
RUN python3 setup.py bdist_wheel

# Build and install torchtext
WORKDIR /
RUN git clone https://github.com/pytorch/text.git torchtext && cd /torchtext && git checkout v0.12.0 && git submodule update --init --recursive
WORKDIR /torchtext
RUN python3 setup.py bdist_wheel

WORKDIR /
RUN pip3 install torchvision/dist/torchvision-0.12.0a0+9b5a3fe-cp38-cp38-linux_x86_64.whl
RUN pip3 install torchdata/dist/torchdata-0.3.0a0+fbf097d-py3-none-any.whl
RUN pip3 install torchtext/dist/torchtext-0.12.0a0+d7a34d6-cp38-cp38-linux_x86_64.whl

ENTRYPOINT sleep 300 && echo "end"

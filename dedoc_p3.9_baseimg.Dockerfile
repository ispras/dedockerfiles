ARG REPOSITORY="docker.io"
FROM ubuntu:20.04

# set up timezone and location
RUN apt update && apt install -y tzdata && ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# install system libraries and packages
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --no-install-recommends -y automake binutils-dev build-essential ca-certificates clang curl \
    default-jre djvulibre-bin ffmpeg g++ g++-multilib gcc-multilib git intel-mkl java-common libcairo2 libffi-dev libgdk-pixbuf2.0-0 libglib2.0-dev \
    libjpeg-dev libleptonica-dev libpango-1.0-0 libpango1.0-dev libpangocairo-1.0-0 libpng-dev libreoffice libreoffice-java-common libsm6 libtesseract-dev \
    libtool libxext6 make mpich pkg-config poppler-utils pstotext python3 python3-pip shared-mime-info software-properties-common swig unrar unrtf unzip \
    wget zlib1g-dev && apt clean autoclean && apt autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

# install tesseract 5.0.0-beta
RUN add-apt-repository -y ppa:alex-p/tesseract-ocr-devel && apt update --allow-releaseinfo-change && apt install -y tesseract-ocr tesseract-ocr-rus && \
    git clone --depth 1 --branch 5.0.0-beta-20210916 https://github.com/tesseract-ocr/tesseract/ && \
    cd tesseract && ./autogen.sh && ./configure && make && make install && ldconfig && cd .. && rm -rf tesseract
ENV TESSDATA_PREFIX /usr/share/tesseract-ocr/5/tessdata/

# install python3.9 instead of python3.6
RUN add-apt-repository ppa:deadsnakes/ppa && apt update && apt install -y python3.9 python3.9-dev && \
    rm /usr/bin/python3 && ln -s /usr/bin/python3.9 /usr/bin/python3 && pip3 install --no-cache-dir --upgrade pip && \
    apt clean autoclean && apt autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
ENV OPENCV_IO_ENABLE_JASPER "true"

# install doctr
# ATTENTION: don't change an order of pip's package install here, otherwise you get conflicts
# RUN pip install setuptools==60.10.0 cffi==1.15.0
# RUN pip install python-doctr==0.5.1
# We decided to stop using Doctr. If you need it, uncomment two lines above and comment one line below to make docker image with Doctr.

RUN pip install --no-cache-dir pyclipper==1.3.0.post4 shapely==2.0.1 Pillow==9.2.0

# install secure torch
RUN pip3 install --no-cache-dir https://github.com/ispras/dedockerfiles/raw/master/wheels/torch-1.11.0a0+git137096a-cp39-cp39-linux_x86_64.whl && \
    pip3 install --no-cache-dir https://github.com/ispras/dedockerfiles/raw/master/wheels/torchvision-0.12.0a0%2B9b5a3fe-cp39-cp39-linux_x86_64.whl

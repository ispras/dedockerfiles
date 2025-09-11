ARG REPOSITORY="docker.io"
FROM ubuntu:22.04

# set up timezone and location
RUN apt update && apt install -y tzdata && ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime && dpkg-reconfigure -f noninteractive tzdata

# install system libraries and packages
RUN apt update && DEBIAN_FRONTEND=noninteractive apt install --fix-missing --no-install-recommends -y automake binutils-dev build-essential ca-certificates clang curl \
    default-jre djvulibre-bin ffmpeg g++ g++-multilib gcc-multilib git intel-mkl java-common libcairo2 libffi-dev libgdk-pixbuf2.0-0 libglib2.0-dev \
    libjpeg-dev libleptonica-dev libpango-1.0-0 libpango1.0-dev libpangocairo-1.0-0 libpng-dev libreoffice libreoffice-java-common libsm6 libtesseract-dev \
    libtool libxext6 make mpich pkg-config poppler-utils pstotext python3 python3-pip shared-mime-info software-properties-common swig unrar unrtf unzip \
    wget zlib1g-dev python3-setuptools && apt clean autoclean && apt autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/

# install tesseract 5.0.0-beta
RUN apt install -y gpg-agent
RUN add-apt-repository -y ppa:alex-p/tesseract-ocr-devel && apt update --allow-releaseinfo-change && apt install -y tesseract-ocr tesseract-ocr-rus && \
    git clone --depth 1 --branch 5.0.0-beta-20210916 https://github.com/tesseract-ocr/tesseract/ && \
    cd tesseract && ./autogen.sh && ./configure && make && make install && ldconfig && cd .. && rm -rf tesseract
ENV TESSDATA_PREFIX /usr/share/tesseract-ocr/5/tessdata/

# install python3.10
RUN add-apt-repository ppa:deadsnakes/ppa && apt update && apt install -y python3.10 python3.10-dev && \
    rm /usr/bin/python3 && ln -s /usr/bin/python3.10 /usr/bin/python3 && pip3 install --no-cache-dir --upgrade pip && \
    apt clean autoclean && apt autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/
ENV OPENCV_IO_ENABLE_JASPER "true"

# install secure torch
RUN pip3 install --no-cache-dir torch==1.11.0 torchvision==0.12.0
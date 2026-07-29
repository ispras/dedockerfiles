FROM python:3.10-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
    default-jre-headless ca-certificates curl tzdata libmagic1 unzip unrar-free unrtf zlib1g-dev libreoffice djvulibre-bin \
    ffmpeg libsm6 libxext6 tesseract-ocr poppler-utils fontforge && \
    ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

ENV OPENCV_IO_ENABLE_JASPER=true

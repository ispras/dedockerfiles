FROM python:3.10-slim

ENV DEBIAN_FRONTEND=noninteractive

# add sources.list for unrar installation
RUN echo "deb http://deb.debian.org/debian trixie non-free" > /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    default-jre-headless ca-certificates curl tzdata libmagic1 unzip unrar unrtf zlib1g-dev libreoffice djvulibre-bin \
    ffmpeg libsm6 libxext6 tesseract-ocr poppler-utils fontforge ghostscript && \
    ln -fs /usr/share/zoneinfo/Europe/Moscow /etc/localtime && \
    dpkg-reconfigure -f noninteractive tzdata && \
    apt-get clean autoclean && apt-get autoremove --yes && rm -rf /var/lib/{apt,dpkg,cache,log}/ /tmp/* /var/tmp/*

ENV OPENCV_IO_ENABLE_JASPER=true

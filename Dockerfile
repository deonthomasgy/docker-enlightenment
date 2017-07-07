#
# EFL - Docker Builder
#

FROM ubuntu:16.04

MAINTAINER Deon Thomas <deon.thomas.gy@gmail.com>

RUN apt-get update \
    && apt-get install automake autopoint build-essential ccache check \
    doxygen faenza-icon-theme git imagemagick libasound2-dev libblkid-dev \
    libbluetooth-dev libbullet-dev libcogl-dev libfontconfig1-dev \
    libfreetype6-dev libfribidi-dev libgif-dev libgstreamer1.0-dev \
    libgstreamer-plugins-base1.0-dev libharfbuzz-dev libibus-1.0-dev \
    libiconv-hook-dev libjpeg-dev libblkid-dev libluajit-5.1-dev \
    liblz4-dev libmount-dev libopenjpeg-dev libpam0g-dev \
    libpoppler-cpp-dev libpoppler-dev libpoppler-private-dev \
    libproxy-dev libpulse-dev libraw-dev librsvg2-dev libscim-dev \
    libsndfile1-dev libspectre-dev libssl-dev libsystemd-dev \
    libtiff5-dev libtool libudev-dev libudisks2-dev libunibreak-dev \
    libvlc-dev libwebp-dev libxcb-keysyms1-dev libxcursor-dev \
    libxine2-dev libxinerama-dev libxkbfile-dev libxrandr-dev \
    libxss-dev libxtst-dev linux-tools-common texlive-base \
    unity-greeter-badges valgrind xserver-xephyr -y --no-install-recommends



RUN mkdir /e_src
WORKDIR /e_src

#Clone Repo

ENV EFL_BRANCH=v1.19.1
RUN git clone --depth=1 --branch $EFL_BRANCH git://git.enlightenment.org/core/efl.git


ENV ENLIGHTENMENT_BRANCH=v0.21.8
RUN git clone --depth=1 --branch $ENLIGHTENMENT_BRANCH git://git.enlightenment.org/core/enlightenment.git


#Build EFL & Enlightenment
ENV LD_LIBRARY_PATH=/opt/e/lib
ENV PKG_CONFIG_PATH=/opt/e/lib/pkgconfig/


RUN mkdir /opt/e

# some commands
ENV AUTOGEN="./autogen.sh --prefix=/opt/e"
ENV MAKE="make"
ENV INSTALL="make install"
ENV E_DIRS="/e_src/efl /e_src/enlightenment"

RUN for DIR in $E_DIRS; do cd $DIR; $AUTOGEN && $MAKE && $INSTALL; done

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
CMD ["tail", "-f", "/entrypoint.sh"]

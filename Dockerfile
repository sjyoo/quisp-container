FROM ubuntu:20.04

ENV DEBIAN_FRONTEND "noninteractive"
# the following install gcc 11 with openmpi, so that mpi4py version 3.1.4 by pip install mpi4py
# If you want gcc=9.3 and mpi4py 4.1, then you can simply list gcc version but mpi4py need to be recompiled or conda installed
RUN apt-get update \
    && apt-get install -y \
        git \
        vim \
        curl \
        build-essential \
        clang \
        lld \
        gdb \
        bison \
        flex \
        perl \
        python3 \
        python3-pip \
        qtbase5-dev \
        qtchooser \
        qt5-qmake \
        qtbase5-dev-tools \
        libqt5opengl5-dev \
        libxml2-dev \
        zlib1g-dev \
        doxygen \
        graphviz \
        libwebkit2gtk-4.0-37 \
        gcc \
        gfortran \
        gnuplot \
        openmpi-doc \
        openmpi-bin \
	python3-pip \
	pkg-config \
        libopenmpi-dev \
        openssl \
        libssl-dev \
        libreadline-dev \
        ncurses-dev \
        bzip2 \
	fftw3-dev \
        zlib1g-dev \
        libbz2-dev \
        libffi-dev \
        libopenblas-dev \
        liblapack-dev \
        libsqlite3-dev \
        liblzma-dev \
        libpng-dev \
	libblas-dev \
	liblapack-dev \
        libfreetype6-dev

ENV PYTHONIOENCODING "utf-8"
RUN python3 -m pip install --user --upgrade numpy pandas matplotlib scipy seaborn posix_ipc

RUN apt-get install -y openscenegraph-plugin-osgearth libosgearth-dev
RUN apt-get install -y --reinstall xdg-utils wget

ENV OMPI_MCA_btl_vader_single_copy_mechanism "none"
ENV OMPI_ALLOW_RUN_AS_ROOT 1
ENV OMPI_ALLOW_RUN_AS_ROOT_CONFIRM 1

WORKDIR /usr/local

RUN wget https://github.com/omnetpp/omnetpp/releases/download/omnetpp-6.0.1/omnetpp-6.0.1-linux-x86_64.tgz \
    && tar xvfz omnetpp-6.0.1-linux-x86_64.tgz \
    && rm omnetpp-6.0.1-linux-x86_64.tgz

WORKDIR /usr/local/omnetpp-6.0.1

# to ensue libQt5Core.so.5 in so library finding
RUN strip --remove-section=.note.ABI-tag /usr/lib/x86_64-linux-gnu/libQt5Core.so.5

# Now compile omnetpp
RUN cd /usr/local/omnetpp-6.0.1 \
    && . ./setenv \
    && cp configure.user.dist configure.user  \
    && ./configure \
    && make 

WORKDIR /work

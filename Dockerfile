FROM ubuntu:14.04.4
MAINTAINER Raymond, yhung124@gmail.com

ENV BUILDROOT_GIT_URL="https://github.com/buildroot/buildroot.git"
ENV BUILDROOT_TAG="2017.02.1"

# Install essential packages
COPY script/sources.list /etc/apt/sources.list

RUN apt-get update && \
    apt-get install -y vim git g++ make gawk libncurses5-dev wget python unzip bc patch rsync gcc-multilib libssl-dev graphviz python-matplotlib ack-grep && \
    rm -rf /var/lib/apt/lists/*
RUN adduser --disabled-password --gecos "" -shell /bin/bash --home /home/build --uid 500 build && \
    usermod -a -G sudo build && \
    echo "build ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers && \
    mkdir -p /home/build/bin

RUN chown -R build:build /home/build/ && locale-gen en_US.UTF-8

USER build
ENV HOME /home/build
ENV PATH "$PATH:$HOME/bin:/usr/sbin"
WORKDIR /home/build

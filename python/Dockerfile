FROM ubuntu:16.04

RUN apt-get update && apt-get --force-yes -y install wget vim build-essential ca-certificates unzip zlib1g-dev ccache less  erlang-nox autoconf


ARG SRC_VERSION
ARG PKG_VERSION
ARG SSLV=1.0.1o
ARG SQLITE=amalgamation-3071700

WORKDIR /root

RUN wget https://www.python.org/ftp/python/${SRC_VERSION}/Python-${SRC_VERSION}.tgz -O Python-${SRC_VERSION}.tgz
RUN wget http://www.sqlite.org/2013/sqlite-${SQLITE}.zip
RUN wget https://www.openssl.org/source/openssl-${SSLV}.tar.gz
RUN wget ftp://sourceware.org/pub/libffi/libffi-3.2.1.tar.gz


ARG ARCH=amd64

ADD tools/env.sh /root/env.sh
ADD tools/crosscompile-setup.sh /root/crosscompile-setup.sh
RUN /root/crosscompile-setup.sh

ADD python/compile-ssl.sh /root/
RUN /root/compile-ssl.sh

ADD python/compile-sqlite.sh /root/
RUN /root/compile-sqlite.sh

ADD python/compile-python.sh /root/
RUN /root/compile-python.sh

ADD python/prepare_python.sh /root/
ADD python/python-requirements.txt /root/
ADD tools/fpm.erl /root/
ADD tools/sha1.erl /root/
ADD tools/gpg.asc /root/

RUN gpg --import /root/gpg.asc

ARG SIGNER_NAME="Somebody"
ARG SIGNER_EMAIL="somebody@domain.com"

RUN /root/prepare_python.sh

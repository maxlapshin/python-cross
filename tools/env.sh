#!/bin/bash


DISTR=debian

if [ $DISTR = debian ]; then
  HOST_TYPE=`dpkg-architecture -qDEB_HOST_GNU_TYPE`
fi
export STRIP=strip

if [ $DISTR = debian -a "$HOST_TYPE" = x86_64-linux-gnu ]; then
  if [ -z "$ARCH" ]; then
    ARCH=amd64
  elif [ "$ARCH" = "armhf" ]; then
    export CROSSCOMPILE=armhf
    if [ ! "$1" = "simple" ]; then
      export CROSSPREFIX=arm-linux-gnueabihf
      export CC="$CROSSPREFIX-gcc"
      export AR="$CROSSPREFIX-ar"
      export LD="$CROSSPREFIX-ld"
      export LD="$CROSSPREFIX-ld"
      export RANLIB="$CROSSPREFIX-ranlib"
      export STRIP="$CROSSPREFIX-strip"
      export CROSSCONFFLAGS="--host=$CROSSPREFIX --build=x86_64-linux-gnu"
    fi
  elif [ "$ARCH" = "arm64" ]; then
    export CROSSCOMPILE=arm64
    if [ ! "$1" = "simple" ]; then
      export CROSSPREFIX=aarch64-linux-gnu
      export CC="$CROSSPREFIX-gcc"
      export AR="$CROSSPREFIX-ar"
      export LD="$CROSSPREFIX-ld"
      export RANLIB="$CROSSPREFIX-ranlib"
      export STRIP="$CROSSPREFIX-strip"
      export CROSSCONFFLAGS="--host=$CROSSPREFIX --build=x86_64-linux-gnu"
    fi
  fi
elif [ $DISTR = debian -a "$HOST_TYPE" = arm-linux-gnueabihf ]; then
  echo "fallback"
  ARCH=armhf
elif [ $DISTR = debian -a "$HOST_TYPE" =  aarch64-linux-gnu ]; then
  ARCH=arm64
fi


#!/bin/bash

cd /root
. ./env.sh



if [ ! -z "$CROSSCOMPILE" ]; then
  apt -y install crossbuild-essential-$CROSSCOMPILE libssl-dev
fi


if [ ! -z "$CROSSCOMPILE" ]; then
  
  tar xf ncurses-6.0.tar.gz
  cd ncurses-6.0
  CPPFLAGS="-P" ./configure $CROSSCONFFLAGS --prefix=/root/arm --without-ada --without-cxx \
  --without-cxx-binding --without-manpages --without-progs --without-tests  \
  --disable-db-install --without-curses-h --without-static --with-shared  --without-debug \
  --enable-overwrite --with-termlib
  make -j 6
  make install
  CROSSCFLAGS="$CROSSCFLAGS -I/root/arm/include"
  CROSSLDFLAGS="$CROSSLDFLAGS -L/root/arm/lib"
  cd ..
fi


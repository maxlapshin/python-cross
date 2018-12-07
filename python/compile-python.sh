#!/bin/sh


set -e

if [ ! "$ARCH" = amd64 -a "`dpkg-architecture -qDEB_HOST_GNU_TYPE`" = "x86_64-linux-gnu" ] ; then
  rm -rf Python-${SRC_VERSION}-host
  rm -rf Python-${SRC_VERSION}
  tar zxf Python-${SRC_VERSION}.tgz
  mv Python-${SRC_VERSION} Python-${SRC_VERSION}-host
  cd Python-${SRC_VERSION}-host
  ./configure --prefix=/opt/flussonic-build
  make python Parser/pgen
  make install
  cd ..
  export PATH=/opt/flussonic-build/bin:$PATH
fi

. /root/env.sh

if [ ! -z "$CROSSCOMPILE" ]; then
  PYCONFFLAGS="$CROSSCONFFLAGS ac_cv_file__dev_ptmx=no ac_cv_file__dev_ptc=no ac_cv_have_long_long_format=yes"
  PYCROSSMAKE="HOSTPYTHON=/opt/flussonic-build/bin/python HOSTPGEN=/opt/flussonic-build/Parser/pgen \
CROSS-COMPILE=aarch64-linux-gnu- CROSS_COMPILE_TARGET=yes CROSSPYTHONPATH=/opt/flussonic-build/"
fi

rm -rf Python-${SRC_VERSION}
tar zxf Python-${SRC_VERSION}.tgz
# patch -p0 --ignore-whitespace < python-cross.patch

cd Python-${SRC_VERSION}
# autoconf
sed -i.bak 's|/usr/contrib/ssl/include/|/opt/flussonic/include|' setup.py
sed -i.bak 's|/usr/contrib/ssl/lib/|/opt/flussonic/lib|' setup.py

sed -i.bak "s|/usr/include/sqlite3|/root/sqlite-${SQLITE}/include|" setup.py

export LD_LIBRARY_PATH=/opt/flussonic/lib
export LD_RUN_PATH
CFLAGS="-I/opt/flussonic/include" LDFLAGS="-L/opt/flussonic/lib -Wl,-rpath,/opt/flussonic/lib" \
  ./configure $PYCONFFLAGS --prefix=/opt/flussonic --disable-ipv6
make -j5 $PYCROSSMAKE

rm -rf /opt/flussonic/*
make install



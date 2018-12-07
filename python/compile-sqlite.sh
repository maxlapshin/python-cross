#!/bin/sh


. /root/env.sh

rm -rf cd sqlite-${SQLITE}
unzip sqlite-${SQLITE}.zip

if [ -z "$AR" ]; then
  AR=ar
fi

cd sqlite-${SQLITE}
gcc sqlite3.c -fPIC -c -o sqlite3.o
$AR rvs libsqlite3.a sqlite3.o
mkdir include lib
cp sqlite3.h include
mv libsqlite3.a lib
cd ..



if [ ! -f /opt/libffi/lib/libffi.a ]; then
  tar xvf libffi-3.2.1.tar.gz
  cd libffi-3.2.1
  ./configure $CROSSCONFFLAGS --prefix=/opt/libffi
  make
  make install
fi

cp -v /opt/libffi/lib/libffi.so.6* /opt/tmplib/
cp -v /opt/libffi/lib/libffi.so.6* /opt/flussonic/lib/

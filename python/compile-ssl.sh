#!/bin/sh

. /root/env.sh

SSL_ARCH=linux-x86_64

if [ "$ARCH" = amd64 ]; then
    SSL_ARCH=linux-x86_64
elif [ "$ARCH" = armhf ]; then
    SSL_ARCH=linux-armv4
elif [ "$ARCH" = arm64 ]; then
    SSL_ARCH=linux-generic64
    # в более новых версиях есть linux-aarch64
elif [ "$ARCH" = e2k ] ; then
    SSL_ARCH="linux-generic64"
    # CROSSCFLAGS="-I/opt/mcst/crossfs-3.0-rc9.e2k-2c+.3.14/usr/include"
    # CROSSLDFLAGS="-L/opt/mcst/crossfs-3.0-rc9.e2k-2c+.3.14/usr/lib64"
    CC=`which lcc`
    LD=`which lcc`
    # CC="/opt/mcst/lcc-1.20.17.e2k-2c+.3.14/bin/lcc"
    # LD="/opt/mcst/lcc-1.20.17.e2k-2c+.3.14/bin/lcc"
    # EXTRAOPTS=""
    # EXTRAOPTS="--host=e2k --build=e2k"
    E2K=y
fi

cd /root


rm -rf openssl-${SSLV}/
tar zxf openssl-${SSLV}.tar.gz
cd openssl-${SSLV}/
if [ ! -z "$CROSSPREFIX" ]; then
  SSLCROSSFLAGS="--cross-compile-prefix=${CROSSPREFIX}-"
  unset CC; export CC
  unset LD; export LD
fi
./Configure ${SSL_ARCH} --prefix=/opt/flussonic $SSLCROSSFLAGS shared -fPIC
make
make install_sw
rm /opt/flussonic/lib/libcrypto.a /opt/flussonic/lib/libssl.a
$STRIP /opt/flussonic/lib/libcrypto.so.* /opt/flussonic/lib/libssl.so.* /opt/flussonic/bin/openssl
# rm -rf /opt/flussonic/ssl
rm -rf /opt/flussonic/lib/engines



mkdir -p /opt/tmplib
cp -f /opt/flussonic/lib/libssl.so* /opt/tmplib
cp -f /opt/flussonic/lib/libcrypto.so* /opt/tmplib

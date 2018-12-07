#!/bin/bash

. /root/env.sh

set -e
set -x




OUTDIR=/output
mkdir -p $OUTDIR


# PYTHON=./bin/python

# if [ ! -z "$CROSSCOMPILE" ]; then
#     PYTHON=/opt/flussonic-build/bin/python
# fi



# apt-get -y install libssl-dev
# на armhf в libssl.so из пакета libssl1.0.0 нету SSLv2_method => не работает ssl в питоне:
# >>> import ssl
# ImportError: /opt/flussonic/lib/python2.7/lib-dynload/_ssl.so: undefined symbol: SSLv2_method

export LD_LIBRARY_PATH=/opt/tmplib

cd /opt/flussonic

wget --no-check-certificate https://bootstrap.pypa.io/get-pip.py
./bin/python get-pip.py

cp /root/python-requirements.txt .

env \
    CFLAGS="-I/root/sqlite-${SQLITE}/include -I/opt/libffi/lib/libffi-3.2.1/include" \
    LDFLAGS="-L/root/sqlite-${SQLITE}/lib -L/opt/libffi/lib" \
    ./bin/pip install -r python-requirements.txt

cd /opt/flussonic
$STRIP bin/python2.7
rm -f lib/libpython2.7.a
rm -rf share include

rm -rf pkgconfig/*ssl* pkgconfig/*crypto* lib/*crypto* lib/*ssl*

cd lib/python2.7
rm -rf test unittest lib-tk idlelib

mkdir encbkp
cp encodings/cp866.pyc encodings/cp1251.pyc encodings/iso8859_5.pyc encbkp
rm -rf encodings/cp* encodings/euc* encodings/mac* encodings/hp* encodings/koi* encodings/palm* encodings/iso*
mv encbkp/* encodings/
rmdir encbkp

rm -rf ctypes/macholi

rm -rf */test */tests

find . -name '*.py' -delete
find . -name '*.pyo' -delete

rm config/libpython2.7.a
cd ../..

rm -rf lib/python2.7/site-packages/wtforms/locale

PY_ARCH=amd64
# if [ -n "`uname -a |grep arm`" ] ; then
#   PY_ARCH=armhf
# fi

tar zcvf $OUTDIR/python_${PY_ARCH}_${SRC_VERSION}.tgz bin/ lib




cd /
/root/fpm.erl -f -t deb -n flussonic-python -v "${PKG_VERSION}" -m "${SIGNER_NAME} <${SIGNER_EMAIL}>" --vendor '"Erlyvideo, LLC"' -a ${PY_ARCH} --category net --provides flussonic-python_${SRC_VERSION}  opt/flussonic
/root/fpm.erl -f -t rpm -n flussonic-python -v "${PKG_VERSION}" -m "${SIGNER_NAME} <${SIGNER_EMAIL}>" --vendor "Erlyvideo, LLC" -a ${PY_ARCH} --gpg ${SIGNER_EMAIL} --provides "flussonic-python = ${PKG_VERSION}-1" --category Server/Video opt/flussonic

mv *.deb output/
mv *.rpm output

/root/sha1.erl output/*.deb output/*.rpm


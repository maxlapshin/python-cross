#!/bin/sh

USERID="Somebody <somebody@domain.com>"
KEYFILE=tools/gpg.asc

# Использовал версию gpg (GnuPG) 2.1.18

# В случае ошибки "gpg: agent_genkey failed: No such file or directory" надо перезапустить gpg-agent:
# killall gpg-agent


set -e
# set -x

umask 077
export GNUPGHOME=`pwd`/tmp/gnupghome
mkdir -p tmp
rm -rf $GNUPGHOME
mkdir $GNUPGHOME
# DEBUG="--debug-level 9 --debug-all -v"
DEBUG=
gpg $DEBUG --batch --passphrase '' --quick-generate-key "$USERID" default default never
gpg --export-secret-keys -a '<somebody@domain.com>' > ${KEYFILE}.tmp
mv ${KEYFILE}.tmp ${KEYFILE}
ls -l ${KEYFILE}

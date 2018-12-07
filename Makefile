
SELF_DIR := $(dir $(lastword $(MAKEFILE_LIST)))
SRC_VERSION_python := 2.7.13
PKG_VERSION_python := 18.11


deps: deps_amd64 deps_armhf deps_arm64


# По умолчанию собираем amd64
ifeq (,$(ARCH))
  ARCH = amd64
endif


MODULES = python


.PHONY: $(MODULES) deps deps_amd64 deps_armhf deps_arm64


$(MODULES):
	@[ "${ARCH}" != "" ] || (echo "Need to specify make ARCH=amd64 $@" && exit 4 )
	cd ${SELF_DIR} && (tar zc tools $@) | docker build -t build-$@-${ARCH}:${PKG_VERSION_$@} --build-arg PKG_VERSION=${PKG_VERSION_$@} --build-arg SRC_VERSION=${SRC_VERSION_$@} --build-arg ARCH=${ARCH} $($@_ARGS) -f $@/Dockerfile -
	CONTAINER=$$(docker create build-$@-${ARCH}:${PKG_VERSION_$@}); \
	docker cp $${CONTAINER}:/output/ . ;\
	docker rm -f $${CONTAINER}




deps_amd64: 
	make ARCH=amd64 python

deps_armhf: 
	make ARCH=armhf python

deps_arm64: 
	make ARCH=arm64 python


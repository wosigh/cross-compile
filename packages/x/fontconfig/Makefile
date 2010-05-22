NAME = fontconfig
VERSION = 2.8.0

DEPENDS = common/libxml2 common/freetype

SRC_BZ2 = http://cgit.freedesktop.org/fontconfig/snapshot/${NAME}-${VERSION}.tar.bz2

include ../../../support/download.mk

.PHONY: unpack
unpack: build/.unpacked

build/.unpacked: ${DL_DIR}/${NAME}-${VERSION}.tar.bz2
	rm -rf build
	mkdir -p build
	tar -C build -j -x -f $<
	mv build/${NAME}-${VERSION} build/src
	touch $@

include ../../../support/staging.mk

stage:: build

include ../../../support/cross-compile.mk

build: build/armv7.built

build/%.built: build/.unpacked
	rm -f $@
	( cd build/src ; ${SB2} \
	./autogen.sh \
		--prefix=${INSTALL_PREFIX} --sysconfdir=/usr/local/share \
		--host=i386 --build=arm --with-arch=arm \
	)	
	#XXX the libtool which ships with fontconfig generates wierd errors
	# Using the one from scratchbox works fine right now
	( cd build/src ; ${SB2} cp \`which libtool\` .)
	( cd build/src ; ${SB2} make)
	( cd build/src ; ${SB2} make install)
	touch $@

clobber::
	rm -rf build
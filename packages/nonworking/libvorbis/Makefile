NAME = libvorbis
VERSION = 1.2.3
DEPENDS = media/libogg

SRC_TGZ = http://downloads.xiph.org/releases/vorbis/${NAME}-${VERSION}.tar.gz

include ../../../support/download.mk

.PHONY: unpack
unpack: build/.unpacked

build/.unpacked: ${DL_DIR}/${NAME}-${VERSION}.tar.gz
	rm -rf build
	mkdir -p build
	tar -C build -x -f $<
	mv build/${NAME}-${VERSION} build/src
	touch $@

include ../../../support/staging.mk

include ../../../support/cross-compile.mk

stage-local:: build/${ARCH}.built

build/%.built: build/.unpacked
	rm -f $@
	mkdir -p build/$*
	cp -R build/src/* build/$*
	( cd build/$* ; LDFLAGS="-Wl,-rpath,/usr/local/lib -L/usr/local/lib" ${SB2} ./configure )
	( cd build/$* ; ${SB2} $(MAKE) && ${SB2} make install )
	touch $@

clobber::
	rm -rf build

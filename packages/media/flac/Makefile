NAME = flac
VERSION = 1.2.1
DEPENDS = common/glib-2.0 media/libogg

SRC_TGZ = http://downloads.sourceforge.net/project/${NAME}/${NAME}-src/${NAME}-${VERSION}-src/${NAME}-${VERSION}.tar.gz

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
	( cd build/$* ; ${SB2} LDFLAGS=\"-L${INSTALL_PREFIX}/lib -Wl,-rpath=${INSTALL_PREFIX}/lib\" ./configure \
		--prefix=${INSTALL_PREFIX} \
		--disable-xmms-plugin \
    )
	( cd build/$* ; ${SB2} $(MAKE) && ${SB2} make install )
	touch $@

clobber::
	rm -rf build

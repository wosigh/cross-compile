NAME = gtk+
VERSION = 2.12.11

DEPENDS = x/pango \
		  x/libx11 \
		  x/libice \
		  x/libsm \
		  x/libXext \
		  x/libXrender \
		  x/libXrandr \
		  common/glib-2.0

SRC_BZ2 = http://ftp.acc.umu.se/pub/gnome/sources/gtk+/2.12/${NAME}-${VERSION}.tar.bz2

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

stage-local:: build

include ../../../support/cross-compile.mk

build: build/${ARCH}.built

build/%.built: build/.unpacked
	rm -f $@
	mkdir -p build/$*
	cp -R build/src/* build/$*
	( cd build/$* ; ${SB2} \
	LDFLAGS=\"-L/usr/local/lib -Wl,-rpath-link,/usr/local/lib -Wl,-rpath,/usr/local/lib\" \
	./configure \
		--prefix=${INSTALL_PREFIX} \
		--without-libtiff \
		--without-libjpeg \
		--disable-cups \
	)	
	( cd build/$* ; ${SB2} $(MAKE))
	( cd build/$* ; ${SB2} $(MAKE) install)
	touch $@

clobber::
	rm -rf build

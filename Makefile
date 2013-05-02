PACKAGE=helloword

PREFIX:=/usr/local
EPREFIX:=$(PREFIX)/bin
ARCH=$(shell dpkg-architecture -qDEB_BUILD_ARCH)
MAJOR=0
MINOR=1
BUILD=1
VERSION=$(MAJOR).$(MINOR).$(BUILD)-1

all: $(PACKAGE)

install: $(PACKAGE)
	install $(PACKAGE) $(EPREFIX)

package: $(PACKAGE)
	rm -Rf .pkg
	mkdir -p .pkg
	fakeroot cp -R debian-src/* .pkg
	fakeroot cp -R debian .pkg/DEBIAN
	find .pkg -name ".svn" -exec rm -Rf "{}" \; 2> /dev/null; exit 0
	fakeroot install $(PACKAGE) .pkg/usr/bin
	fakeroot sed "s/ARCH/$(ARCH)/g" debian/control | sed "s/VERSION/$(VERSION)/g" > .pkg/DEBIAN/control
	fakeroot dpkg-deb -b .pkg $(PACKAGE)_$(VERSION)_$(ARCH).deb
	rm -Rf .pkg

distclean:
	rm -Rf .pkg *.deb

.PHONY: all clean install package distclean

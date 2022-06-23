# mux - window multiplexer
# See LICENSE file for copyright and license details.

include config.mk

SRC = drw.c mux.c util.c
OBJ = ${SRC:.c=.o}

all: options mux

options:
	@echo mux build options:
	@echo "CFLAGS   = ${CFLAGS}"
	@echo "LDFLAGS  = ${LDFLAGS}"
	@echo "CC       = ${CC}"

.c.o:
	${CC} -c ${CFLAGS} $<

${OBJ}: config.h config.mk

config.h:
	cp config.def.h $@

mux: ${OBJ}
	${CC} -o $@ ${OBJ} ${LDFLAGS}

clean:
	rm -f mux ${OBJ} mux-${VERSION}.tar.gz

dist: clean
	mkdir -p mux-${VERSION}
	cp -R LICENSE Makefile README config.def.h config.mk\
		mux.1 drw.h util.h ${SRC} mux.png transient.c mux-${VERSION}
	tar -cf mux-${VERSION}.tar mux-${VERSION}
	gzip mux-${VERSION}.tar
	rm -rf mux-${VERSION}

install: all
	mkdir -p ${DESTDIR}${PREFIX}/bin
	cp -f mux ${DESTDIR}${PREFIX}/bin
	chmod 755 ${DESTDIR}${PREFIX}/bin/mux
	mkdir -p ${DESTDIR}${MANPREFIX}/man1
	sed "s/VERSION/${VERSION}/g" < mux.1 > ${DESTDIR}${MANPREFIX}/man1/mux.1
	chmod 644 ${DESTDIR}${MANPREFIX}/man1/mux.1

uninstall:
	rm -f ${DESTDIR}${PREFIX}/bin/mux\
		${DESTDIR}${MANPREFIX}/man1/mux.1

.PHONY: all options clean dist install uninstall

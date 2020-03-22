XORG_DIR=${DESTDIR}/etc/X11/xorg.conf.d

all:

install:
	mkdir -p ${DESTDIR}/usr/bin
	cp gswitch ${DESTDIR}/usr/bin/gswitch
	chmod +x ${DESTDIR}/usr/bin/gswitch
	mkdir -p ${DESTDIR}/usr/share/gswitch
	cp xorg.conf.egpu ${DESTDIR}/usr/share/gswitch/xorg.conf.egpu
	mkdir -p ${DESTDIR}/etc/systemd/system
	cp gswitch.service ${DESTDIR}/etc/systemd/system/gswitch.service

	if [ -e ${XORG_DIR}/20-intel.conf ]; then \
		cat ${XORG_DIR}/20-intel.conf > ${XORG_DIR}/xorg.conf.internal; \
		mv ${XORG_DIR}/20-intel.conf ${XORG_DIR}/20-intel.conf.bak; \
	fi
	if [ -e ${XORG_DIR}/xorg.conf ]; then \
		cat ${XORG_DIR}/xorg.conf >> ${XORG_DIR}/xorg.conf.internal; \
		mv ${XORG_DIR}/xorg.conf ${XORG_DIR}/xorg.conf.bak; \
	fi
	if [ -e ${XORG_DIR}/xorg.conf.internal ]; then \
		ln -s ${XORG_DIR}/xorg.conf.internal ${XORG_DIR}/xorg.conf; \
	fi

	systemctl daemon-reload


uninstall:
	rm -f ${DESTDIR}/etc/systemd/system/gswitch.service
	rm -f ${XORG_DIR}/xorg.conf.egpu
	rm -rf ${DESTDIR}/usr/share/gswitch
	rm -f ${DESTDIR}/usr/bin/gswitch

	rm -f ${XORG_DIR}/xorg.conf
	if [ -e ${XORG_DIR}/20-intel.conf.bak ]; then \
		mv ${XORG_DIR}/20-intel.conf.bak ${XORG_DIR}/20-intel.conf; \
	fi
	if [ -e ${XORG_DIR}/xorg.conf.bak ]; then \
		mv ${XORG_DIR}/xorg.conf.bak ${XORG_DIR}/xorg.conf; \
	fi
	rm -f ${XORG_DIR}/xorg.conf.internal

	systemctl daemon-reload

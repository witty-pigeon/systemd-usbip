sbindir=/usr/sbin
sysconfdir=/etc
unitdir=$(sysconfdir)/systemd/system

UNITS = \
	usbipd.service \
	usbip-device@.service

SCRIPTS = \
	configure-usbip-device.sh \
	remove-usbip-device.sh

all:

install: install-scripts install-units
	mkdir -p $(DESTDIR)$(sysconfdir)/usbip-devices

install-scripts: $(SCRIPTS)
	mkdir -p $(DESTDIR)$(sbindir)
	for s in $(SCRIPTS); do \
		install -m 755 $$s $(DESTDIR)$(sbindir)/$${s%.sh}; \
	done

install-units: $(UNITS)
	mkdir -p $(DESTDIR)$(unitdir)
	for u in $(UNITS); do \
		install -m 600 $$u $(DESTDIR)$(unitdir); \
	done

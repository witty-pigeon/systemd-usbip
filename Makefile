sbindir=/usr/sbin
sysconfdir=/etc
unitdir=$(sysconfdir)/systemd/system

UNITS = \
	server/usbipd.service \
	server/usbip-device@.service \
	client/usbip-import@.service

SCRIPTS = \
	server/configure-usbip-device.sh \
	server/remove-usbip-device.sh \
	client/attach-usbip-device.sh \
	client/detach-usbip-device.sh

all:

install: install-scripts install-units
	mkdir -p $(DESTDIR)$(sysconfdir)/usbip-devices

install-scripts: $(SCRIPTS)
	mkdir -p $(DESTDIR)$(sbindir)
	for s in $(SCRIPTS); do \
		script_filename=$$(basename $$s); \
		install -m 755 $$s $(DESTDIR)$(sbindir)/$${script_filename%.sh}; \
	done

install-units: $(UNITS)
	mkdir -p $(DESTDIR)$(unitdir)
	for u in $(UNITS); do \
		install -m 600 $$u $(DESTDIR)$(unitdir); \
	done

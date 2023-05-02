# Systemd unit for automounting usb devices over usbip

This is shamelessly ripped from [larsks sysetemd-usb-gadget][https://github.com/larsks/systemd-usb-gadget]

## Installation

To install the systemd unit, run `make install` in the source
directory, which will place the support scripts into `/sbin` and the
systemd unit into `/etc/systemd/system`.

## Server Configuration

Create one or files in `/etc/usbip-devices` named `<device_name>.conf`.
These files **must** contain the following configuration keys:


- `USB_IDVENDOR` -- Vendor ID.
- `USB_IDPRODUCT` -- Product ID.

For example, to share a device with vendor:product 03f0:8607, create a file
called /etc/usbip_devices/mouse.conf

    USB_IDVENDOR=03f0
    USB_IDPRODUCT=8607

To enable the device at boot, run:

    systemctl enable usbip-device@mouse

To share the device immediately:

    systemctl start usbip-device@mouse

To stop sharing it:

    systemctl stop usbip-device@mouse


## Client Configuration

Client part is configured very similar to server one, with a few additions:

* files in `/etc/usbip-devices` must be named `<device_name>.import.conf`
* besides `USB_IDVENDOR` and `USB_IDPRODUCT` there should also be `HOST` key, identifying hostname or IP address of the server that shares USB device

Example:
```
USB_IDVENDOR=03f0
USB_IDPRODUCT=8607
HOST=192.168.1.54
```

To enable attaching to remote device at boot, run:

```
systemctl enable usbip-import@mouse
```

To attach device:

```
systemctl start usbip-import@mouse
```

To detach device:

```
systemctl stop usbip-import@mouse
```
#!/bin/bash -e
WATCH_FILE=/var/run/usbip-device-$1
BUS_ID=$(/usr/sbin/usbip list -p -l | grep -i "#usbid=${USB_IDVENDOR}:${USB_IDPRODUCT}#" | cut '-d#' -f1)
[[ -z "$BUS_ID" ]] || /usr/sbin/usbip unbind --$BUS_ID
rm "${WATCH_FILE}"

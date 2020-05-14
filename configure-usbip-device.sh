#!/bin/bash -e
BUS_ID=`/usr/bin/usbip list -p -l | grep -i "#usbid=${USB_IDVENDOR}:${USB_IDPRODUCT}#" | cut '-d#' -f1`
[[ -z "$BUS_ID" ]] || /usr/bin/usbip bind --$BUS_ID


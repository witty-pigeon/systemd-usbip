#!/bin/bash -e
DEVICE_NAME=$1
WATCH_FILE=/var/run/usbip-device-${DEVICE_NAME}
PORT_ID=$(usbip port | awk -F'[ /]+' '/^Port/ { printf $2 } /\(.+:.+\)$/ {printf $NF"#"} /usbip:/ { print $NF}' | grep "${USB_IDVENDOR}:${USB_IDPRODUCT}" | cut -d: -f1)
[[ -z "${PORT_ID}" ]] || /usr/bin/usbip detach -p "${PORT_ID}"

rm "${WATCH_FILE}"

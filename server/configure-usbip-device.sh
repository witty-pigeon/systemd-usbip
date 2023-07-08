#!/usr/bin/env bash
set -exuo pipefail
DEVICE_NAME=$1
WATCH_FILE=/var/run/usbip-device-${DEVICE_NAME}
USB_DEVICE_ID=${USB_IDVENDOR}:${USB_IDPRODUCT}
BUS_ID=$(/usr/sbin/usbip list -p -l | grep -i "#usbid=${USB_DEVICE_ID}#" | cut '-d#' -f1)
if [ -z "$BUS_ID" ]; then
	echo "missing device ${DEVICE_NAME}(${USB_DEVICE_ID})"
	exit 1
fi
/usr/sbin/usbip bind --${BUS_ID}
echo "device ${DEVICE_NAME} attached"

touch "${WATCH_FILE}"
while [ -f "${WATCH_FILE}" ]; do
	# check if the device is still exported
	if /usr/sbin/usbip list -p -r localhost | grep -q "${USB_DEVICE_ID}"; then
		sleep 1
	else
		echo "Lost device $DEVICE_NAME(${USB_DEVICE_ID})"
		rm "${WATCH_FILE}"
		exit 1
	fi
done

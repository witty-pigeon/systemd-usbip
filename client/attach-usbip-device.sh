#!/usr/bin/env bash
set -exuo pipefail

DEVICE_NAME=$1
WATCH_FILE=/var/run/usbip-device-${DEVICE_NAME}
USB_DEVICE_ID=${USB_IDVENDOR}:${USB_IDPRODUCT}
BUS_ID=$(usbip list -r "${HOST}" | grep "${USB_DEVICE_ID}" | cut -d: -f 1 | xargs)
if [ -z "${BUS_ID}" ]; then
	echo "missing device ${DEVICE_NAME}(${USB_DEVICE_ID})"
	exit 1
fi

/usr/bin/usbip attach -r "${HOST}" -b "${BUS_ID}"
echo "device ${DEVICE_NAME} attached"
touch "${WATCH_FILE}"

while [ -f "${WATCH_FILE}" ]; do
	# check if the device is still exported from the remote
	if /usr/sbin/usbip list -r "${HOST}" | grep -q "${USB_DEVICE_ID}"; then
        # check if the device is still correctly attached
        if /usr/sbin/usbip port | grep -q "${USB_DEVICE_ID}"; then
            sleep 1
        else
            echo "Lost local binding of $DEVICE_NAME(${USB_DEVICE_ID})"
            rm "${WATCH_FILE}"
            exit 1
        fi
	else
		echo "Lost $DEVICE_NAME(${USB_DEVICE_ID}) on the remote host ${HOST}"
		rm "${WATCH_FILE}"
		exit 1
	fi
done

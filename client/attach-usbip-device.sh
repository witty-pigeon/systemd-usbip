#!/bin/bash -e
BUS_ID=`usbip list -r ${HOST}|grep ${USB_IDVENDOR}:${USB_IDPRODUCT}|cut -d\: -f 1|xargs`
[[ -z "$BUS_ID" ]] || /usr/bin/usbip attach -r ${HOST} -b $BUS_ID

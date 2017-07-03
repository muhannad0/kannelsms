#!/bin/bash
MODEM_STORAGE="12d1:14fe"
MODEM_MODEM="12d1:1506"

# 0 = storage, 1= modem
MODEM_MODE=0


set_modem_mode () {
	while [ $MODEM_MODE -eq 0 ]
	do
		echo -n "Setting modem mode... "
		/usr/sbin/usb_modeswitch -s 5 -c /etc/usb_modeswitch.d/12d1\:14fe >/dev/null 2>&1
		lsusb | grep --quiet "$MODEM_MODEM"
		if [ $? -eq 0 ]; then
			MODEM_MODE=1
			echo "OK"
		else
			echo "FAILED"
		fi
	done
}

check_modem_mode () {
	echo -n "Checking modem presence... "

	lsusb | grep --quiet "$MODEM_STORAGE"

	if [ $? -eq 0 ]; then
		MODEM_MODE=0
		echo "OK: modem in mass storage mode"
		set_modem_mode
	else
		lsusb | grep --quiet "$MODEM_MODEM"
		if [ $? -eq 0 ]; then
			MODEM_MODE=1
			echo "OK: modem in modem mode"
			exit 1
		else
			echo "ERROR: modem not found"
			exit 1
		fi
	fi
}

check_modem_mode

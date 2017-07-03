# Kannel SMS Using Huawei USB 4G Modem

Config files and steps needed to make a Huawei 4G modem work with kannel to send/receive SMS.

## Getting Started

This setup was done on a RaspberryPi 3 running Raspbian GNU/Linux 8 (jessie) with Huawei E3372 4G Modem. You may have to adjust configuration based on OS and type of modem used. I assume you have some knowledge on how kannel works and using it to send SMS.

### Install Required Packages

Always update & upgrade first to be relevant

```
sudo apt-get update && sudo apt-get upgrade -y
```

Make sure you have usb-modeswitch

```
sudo apt-get install usb-modeswitch
```

### Copy the configuration files to the required locations


#### 12d1:14fe

```
/etc/usb_modeswitch.d/12d1:14fe
```


#### modem-switch.sh
```
/home/pi/modem-switch.sh
```

You can run script manually to check if modem switch happens to be sure.

Run *lsusb* command
Output would be shown as:

from storage mode

```
ID 12d1:14fe Huawei Technologies Co., Ltd.
```

to modem mode

```
ID 12d1:1506 Huawei Technologies Co., Ltd. E398 LTE/UMTS/GSM Modem/Networkcard
```



#### modem-switch.service

```
/lib/systemd/system/modem-switch.service
```

Set permissions

```
sudo chmod 644 /lib/systemd/system/modem-switch.service
```

Enable service to start on reboot

```
sudo systemctl daemon-reload
sudo systemctl enable sample.service
```

## Installing Kannel

### Install Packages

```
sudo apt-get install kannel -y
sudo mkdir -p /var/log/kannel /var/run/kannel /var/spool/kannel/store
sudo chown -R kannel /var/run/kannel /var/spool/kannel/store
sudo chown -R kannel:adm /var/log/kannel
sudo usermod -a -G dialout kannel
```

Stop the service until we get the config setup right.

```
sudo service kannel stop
```

Set kannel to start SMSbox instead of WAPbox

```
sudo sed -i 's/#START_SMSBOX/START_SMSBOX/' /etc/default/kannel
```

Create a backup of original config and replace with provided config.

kannel.conf

```
sudo cp /etc/kannel/kannel.conf /etc/kannel/kannel.conf.dist

/etc/kannel/kannel.conf
```

Startup kannel

```
sudo service kannel start
```

Check if kannel is running

## Acknowledgement
* For modem switching guide [NVDCStuff Blog](http://nvdcstuff.blogspot.com/2015/04/huawei-e3372-in-linux-raspberry-pi.html)
* Anton Raharja for the kannel integration guide [playSMS Documentation](https://help.playsms.org/en/installation/gateway/kannel/kannel_installation_on_ubuntu.html)
* DexterIndustries for the systemd startup guide [DexterIndustries](https://www.dexterindustries.com/howto/run-a-program-on-your-raspberry-pi-at-startup/)
#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
sudo -i # root shell
sudo cp ./hooks/root-ro /etc/initramfs-tools/hooks/root-ro
sudo cp ./scripts/root-ro /etc/initramfs-tools/scripts/init-bottom/root-ro
chmod +x /etc/initramfs-tools/hooks/root-ro
chmod +x /etc/initramfs-tools/scripts/init-bottom/root-ro
# Update the initrd file
update-initramfs -u
if ! grep -q "INITRD /boot/initrd.img" /boot/extlinux/extlinux.conf; then sed -i "s/INITRD \/boot\/initrd/INITRD \/boot\/initrd.img/" /boot/extlinux/extlinux.conf; fi
sudo cp ./scripts/reboot-ro /root/reboot-ro
sudo cp ./scripts/reboot-rw /root/reboot-rw
chmod +x /root/reboot-ro
chmod +x /root/reboot-rw



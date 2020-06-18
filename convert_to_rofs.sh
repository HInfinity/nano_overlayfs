#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

echo -e "\e[47m \e[32m Copy hooks"
echo -e "\e[49m \e[39m .."
echo overlay >> /etc/initramfs-tools/modules
cp ./hooks/root-ro /etc/initramfs-tools/hooks/root-ro
cp ./scripts/root-ro /etc/initramfs-tools/scripts/init-bottom/root-ro
echo -e "\e[47m \e[32m Mod hooks"
echo -e "\e[49m \e[39m .."
chmod +x /etc/initramfs-tools/hooks/root-ro
chmod +x /etc/initramfs-tools/scripts/init-bottom/root-ro
# Update the initrd file
echo -e "\e[47m \e[32m Update FS"
echo -e "\e[49m \e[39m .."
update-initramfs -u
if ! grep -q "INITRD /boot/initrd.img" /boot/extlinux/extlinux.conf; then sed -i "s/INITRD \/boot\/initrd/INITRD \/boot\/initrd.img/" /boot/extlinux/extlinux.conf; fi
echo -e "\e[47m \e[32m Convenience scripts"
echo -e "\e[49m \e[39m .."
cp ./scripts/reboot-ro /root/reboot-ro
cp ./scripts/reboot-rw /root/reboot-rw
chmod +x /root/reboot-ro
chmod +x /root/reboot-rw
echo -e "\e[47m \e[32m ROFS install complete. use sudo reboot-ro to start in read only mode"



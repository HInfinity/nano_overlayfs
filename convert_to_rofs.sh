#!/bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

local_dir=$(readlink -e ${BASH_SOURCE%/*})

echo -e "\e[47m \e[32m Copy hooks"
echo -e "\e[49m \e[39m .."
echo overlay >> /etc/initramfs-tools/modules
#cp ./hooks/root-ro /etc/initramfs-tools/hooks/root-ro
cp ${local_dir}/hooks/root-ro /etc/initramfs-tools/hooks/root-ro
#cp ${local_dir}/scripts/root-ro /etc/initramfs-tools/scripts/init-bottom/root-ro
cp ${local_dir}/scripts/root-ro /etc/initramfs-tools/scripts/init-bottom/root-ro
echo -e "\e[47m \e[32m Mod hooks"
echo -e "\e[49m \e[39m .."
chmod +x /etc/initramfs-tools/hooks/root-ro
chmod +x /etc/initramfs-tools/scripts/init-bottom/root-ro
# Update the initrd file
echo -e "\e[47m \e[32m Update FS"
echo -e "\e[49m \e[39m .."
update-initramfs -u
mkinitramfs -o /boot/initrd
#if ! grep -q "INITRD /boot/initrd.img" /boot/extlinux/extlinux.conf; then sed -i "s/INITRD \/boot\/initrd/INITRD \/boot\/initrd.img/" /boot/extlinux/extlinux.conf; fi
#[[ -f /boot/extlinux/extlinux.conf ]] && grep -Eq "root-ro-driver=overlay" /boot/extlinux/extlinux.conf || sed -e 's/\(^[[:space:]]\+APPEND[[:space:]]\+[[:alnum:][:punct:]]\+[[:space:]]\+\)\(.*\)/\1root-ro-driver=overlay \2/g' /boot/extlinux/extlinux.conf -i
#grep -Eq "root-ro-driver=overlay" /boot/extlinux/extlinux.conf || { echo -e "extlinux.conf update \e[31mfailed\e[0m";false;} && dpkg-reconfigure nvidia-l4t-bootloader
echo -e "\e[47m \e[32m Convenience scripts"
echo -e "\e[49m \e[39m .."
#cp ./scripts/reboot-ro /root/reboot-ro
cp ${local_dir}/scripts/reboot-ro /root/reboot-ro
#cp ./scripts/reboot-rw /root/reboot-rw
cp ${local_dir}/scripts/reboot-rw /root/reboot-rw
chmod +x /root/reboot-ro
chmod +x /root/reboot-rw
# some safeties
#touch /disable-root-ro
#sed -e 's/\(^[[:space:]]\+[[:punct:]]Assistance[[:punct:]]\+[[:space:]]\+\)0\([[:punct:]]\)/\11\2/g' /usr/bin/nodestream/configs/menu.json -i
#echo disabled overlay and enabled mesh, just in case
echo -e "\e[47m \e[32m ROFS install complete. use sudo reboot-ro to start in read only mode"

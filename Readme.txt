# Trevor uploaded Ho script update files.
Added convert_to_rfs.sh updated by Ho for Xavier. 
Added install.sh but this is not part of the nano_overlay - was unable to find where to upload this to in Git so may need to be moved later.


# ORIGINAL PLAY BY PLAY
Modified by Jaron Warburton for automatic install



sudo -i # root shell

# Change a few things in /etc/initramfs-tools so that overlayfs is used on startup to mount a ready-only root
echo overlay >> /etc/initramfs-tools/modules
wget https://raw.githubusercontent.com/JasperE84/root-ro/master/etc/initramfs-tools/hooks/root-ro -O /etc/initramfs-tools/hooks/root-ro
wget https://raw.githubusercontent.com/JasperE84/root-ro/master/etc/initramfs-tools/scripts/init-bottom/root-ro -O /etc/initramfs-tools/scripts/init-bottom/root-ro
chmod +x /etc/initramfs-tools/hooks/root-ro
chmod +x /etc/initramfs-tools/scripts/init-bottom/root-ro

# Update the initrd file
update-initramfs -u

# Now, the file /boot/initrd.img-4.9.140-tegra contains the above modifications.
# There is also the symbolic link in /boot/initrd.img pointing to it, but this doesn't
# actually get loaded on startup. By default /boot/initrd (without extension) is loaded.
# So change /boot/extlinux/extlinux.conf so that it actually gets loaded:
# Search for `INITRD /boot/initrd` and replace it with `INITRD /boot/initrd.img`:
if ! grep -q "INITRD /boot/initrd.img" /boot/extlinux/extlinux.conf; then sed -i "s/INITRD \/boot\/initrd/INITRD \/boot\/initrd.img/" /boot/extlinux/extlinux.conf; fi

# Before rebooting, also add the helper scripts from JasperE84/root-ro:
wget https://raw.githubusercontent.com/JasperE84/root-ro/master/reboot-to-readonly-mode.sh -O /root/reboot-ro
wget https://raw.githubusercontent.com/JasperE84/root-ro/master/reboot-to-writable-mode.sh -O /root/reboot-rw
chmod +x /root/reboot-ro
chmod +x /root/reboot-rw

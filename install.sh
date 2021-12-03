#! /bin/bash
if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi
cd /
sudo apt-get clean
if [[ -e /mnt/root-ro ]];
then

echo "YOU ARE IN READ ONLY MODE"
exit 
fi

echo -e "\e[43m \e[38m VERSION 1.3Pro"


cd /usr/bin/nodestream
sudo ./install


touch elock.fl
chmod a+rw elock.fl

touch alock.fl
chmod a+rw alock.fl

touch lock.fl
chmod a+rw lock.fl



sudo cp /binaries/hihid/MiniMenuPro /usr/bin/nodestream
chmod a-x ./MiniMenuPro
sudo chmod a+r ./menuassets -R
sudo chmod a+rw /usr/bin/nodestream/configs/econfig.hin	
sudo chmod a+rw elock.fl
sudo rm -rf /usr/bin/harvest/Documents/
sudo chown harvest elock.fl
sudo chmod a+rw alock.fl
sudo chmod a+r alock.ps
sudo chown harvest alock.fl
sudo chmod a+rw lock.fl
sudo chmod a+r lock.ps
sudo chown harvest lock.fl
sudo chmod a+rx /usr/bin/nodestream/run.sh
sudo chmod a+rx /usr/bin/nodestream/kill.sh

#sudo rm /home/harvest/.config/autostart/hihid.desktop  #keep - will launch if there is a display

touch mycron
echo '@reboot sleep 35 && /bin/bash -lc "/usr/bin/nodestream/auto.sh"' >> mycron
echo  '* * * * * sleep 35 && /bin/bash  -lc "/usr/bin/nodestream/auto.sh"'>> mycron
sudo crontab mycron
rm mycron




echo -e "\e[42m \e[38m  Install mesh central ? " 
echo -e "\e[49m \e[39m .."
read mecnt
if [[ $mecnt == "y" || $mecnt == "Y" || $mecnt == "Yes" || $mecnt == "YES" || $mecnt == "yes" ]];
then   
cd /binaries
(wget "https://avrlive.com:8230/meshagents?script=1" --no-check-certificate -O ./meshinstall.sh || wget "https://avrlive.com:8230/meshagents?script=1" --no-proxy --no-check-certificate -O ./meshinstall.sh) && chmod 755 ./meshinstall.sh && sudo ./meshinstall.sh https://avrlive.com:8230 'Rbw51A@CD2Etl46l2unb9H8Qbzk9OUFFS8nlBU0kEbYPQtoSNf8EqbhfsWsyX6GJ' 
systemctl disable meshagent
else 
echo -e "\e[42m \e[38m  Skipping mesh central install"
echo -e "\e[49m \e[39m .."
fi


sudo cp /binaries/scripts/00-set /etc/dconf/db/local.d
sudo cp /binaries/scripts/rc.local /etc/
sudo chmod a+x  /etc/rc.local
sudo chmod a+rx /usr/bin/nodestream/MiniMenuPro
dconf update
cd /binaries
echo -e "\e[42m \e[38m  FINALISE"
echo -e "\e[49m \e[39m .."
sudo mv /usr/share/applications/org.gnome.tweaks.desktop   /usr/share/applications/org.gnome.tweaks.desktop.bak
sudo rm -r -f /home/hisupport
sudo chmod a+rx /usr/bin/nodestream/nodisplay.sh 
sudo cp /usr/bin/nodestream/display.sh /usr/bin/nodestream/autoInstall
sudo chmod a+rx /usr/bin/nodestream/autoInstall
(cd ./watch_net_settings;rsync -aPv . /)
(cd ./nano_overlayfs/;./convert_to_rofs.sh)
sudo rm -r -f /binaries
sudo rm /install.sh
#sudo rm /NSMiniInstall.sh
sudo rm /home/harvest/.bash_history
echo -e "\e[49m \e[39m .."





#?/bin/bash

backup_root_dir="/home/ubuntu/backup-system-ubuntu"
list_dirs="$backup_root_dir/list"
apt_list=$(cat $list_dirs/apt.txt)
snap_list=$(snap list | awk '{print $1}')
apt_list_installed=$(apt list --installed 2>/dev/null | awk -F '/' '{print $1}')

# Update system
sudo apt update

# Apt packages

# downgrading wpa supplicant as latest dosen't work.
sudo apt --allow-downgrades install wpasupplicant=2:2.9.0-21build1


# nordvpn installion and setup.
if [ "nordvpn" in $apt_list_installed]; then
    echo "NordVPN already installed"
	nordvpn set firewall off
	nordvpn set analytics off

else

    sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)

    sudo usermod -aG nordvpn $USER
fi

# docker post installation setup
sudo groupadd docker
sudo usermod -aG docker $USER
newgrp docker

sudo npm i -g yarn
sudo systemctl enable dhcpcd

# Snaps
sudo snap install $snap_list

#!/bin/bash

backup_root_dir="/home/ubuntu/backup-system-ubuntu"
list_dirs="$backup_root_dir/list"
apt_list=$(echo $list_dirs/apt.txt)
snap_list=$(echo $list_dirs/snap.txt)
apt_list_installed=$(apt list --installed 2>/dev/null | awk -F '/' '{print $1}')

# Update system
sudo apt update

# Apt packages

# Downgrading wpasupplicant as the latest doesn't work.
sudo apt --allow-downgrades install wpasupplicant=2:2.9.0-21build1

# NordVPN installation and setup.
if [[ " nordvpn " =~ " $apt_list_installed " ]]; then
    echo "NordVPN already installed"
    nordvpn set firewall off
    nordvpn set analytics off
else
    sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
    sudo usermod -aG nordvpn $USER
fi

# Docker post-installation setup
if ! getent group docker > /dev/null; then
    sudo groupadd docker
fi
sudo usermod -aG docker $USER
newgrp docker

sudo npm i -g yarn
sudo systemctl enable dhcpcd

# Loop to install apt packages
for package in $apt_list; do
    if [[ " $package " =~ \.deb$ ]]; then
        sudo dpkg -i $package || sudo apt-get install -f
    else
        sudo apt install -y $package
    fi
done

# Install snap packages
for package in $snap_list; do
    sudo snap install $package
done

# Install vim plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

# Post-installation setup checks and additional configurations
# (Add here any other configurations you need)


etc_backup_dir="/home/ubuntu/Documents/backup/etc"

# restoring the ufw firewall rules.
# The ufw firewall rules are stored in /etc/ufw/ folder.

sudo cp $etc_backup_dir/ufw/user*.rules /etc/ufw/

# restoring the /etc/NetworkManager/NetworkManager.conf file. and system-connections

sudo cp $etc_backup_dir/NetworkManager/system-connections/* /etc/NetworkManager/system-connections/

# restoring fs file notify max
sudo cp $etc_backup_dir/systctl.d/idea.conf /etc/sysctl.d/

sudo sysctl -p --system

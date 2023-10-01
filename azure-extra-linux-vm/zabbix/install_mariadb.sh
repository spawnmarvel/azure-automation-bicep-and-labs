#!/bin/bash
# mariadb
sudo apt install mariadb-server mariadb-client -y

# remove
# sudo apt purge mariadb-server mariadb-client -y

# Make it start at system boot.
sudo systemctl enable --now mariadb
sudo mysql_secure_installation <<EOF
secret456
n
n
y
y
y
y
EOF
echo "Mariadb successfully created!"

	
    
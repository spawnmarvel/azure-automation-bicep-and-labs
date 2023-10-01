#!/bin/bash
# mariadb
sudo apt install mariadb-server mariadb-client -y

# Make it start at system boot.
sudo systemctl enable --now mariadb
# sudo service mariadb status

# secure it
sudo mysql_secure_installation <<EOF
thesudopassword
n
n
y
y
y
y
EOF
echo "Mariadb successfully created!"

# remove
# sudo apt remove --purge mariadb* -y
# sudo apt autoremove -y
# sudo apt autoclean -y
	
    
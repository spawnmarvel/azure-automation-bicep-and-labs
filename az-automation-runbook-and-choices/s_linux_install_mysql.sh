
#!/bin/bash

# Ensure we are running as root
if [ "$EUID" -ne 0 ]; then 
  echo "Please run as sudo"
  exit
fi

export DEBIAN_FRONTEND=noninteractive

echo "1. Updating repositories..."
apt-get update -y > /dev/null

echo "2. Installing MySQL Server..."
apt-get install -y mysql-server > /dev/null

echo "3. Starting MySQL service..."
systemctl start mysql
systemctl enable mysql

echo "4. Running Security Hardening..."
# This replaces the interactive mysql_secure_installation
mysql <<EOF
-- Remove anonymous users
DELETE FROM mysql.user WHERE User='';
-- Disallow root login remotely
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
-- Remove test database and access to it
DROP DATABASE IF EXISTS test;
DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
-- Reload privilege tables
FLUSH PRIVILEGES;
EOF

echo "-----------------------------------------------"
echo "SUCCESS: MySQL is installed and secured."
mysql --version
systemctl status mysql | grep "Active:"
echo "-----------------------------------------------"
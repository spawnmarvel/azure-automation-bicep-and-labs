# Ubuntu SSL


## How to install OpenSSL on Ubuntu 22.04

Method 1: Using the Default Repository to Install OpenSSL on Ubuntu 22.04

https://itslinuxfoss.com/install-openssl-ubuntu-22-04/?utm_content=cmp-true

## How To Create a Self-Signed SSL Certificate for Apache in Ubuntu 20.04

```bash
sudo apt update
sudo apt upgrade -y

sudo apt install apache2

sudo ufw app list

sudo ufw allow OpenSSH
sudo ufw allow "Apache Full"
sudo ufw enable
sudo ufw status

```

Step 1 — Enabling mod_ssl
```bash
# Before we can use any SSL certificates, we first have to enable mod_ssl
# an Apache module that provides support for SSL encryption.
# Enable mod_ssl with the a2enmod command:

sudo a2enmod ssl

# Activate module
sudo systemctl restart apache2

sudo service apache2 status

# Enable at boot
sudo systemctl enable apache2

```
Open port 80 NSG to test apache

![Apache home ](https://github.com/spawnmarvel/azure-automation/blob/main/images/apache.jpg)


Step 2 – Creating the SSL Certificate

* openssl: This is the command line tool for creating and managing OpenSSL certificates, keys, and other files.
* req -x509: This specifies that we want to use X.509 certificate signing request (CSR) management. X.509 is a public key infrastructure standard that SSL and TLS adhere to for key and certificate management.
* -nodes: This tells OpenSSL to skip the option to secure our certificate with a passphrase. We need Apache to be able to read the file, without user intervention, when the server starts up. A passphrase would prevent this from happening, since we would have to enter it after every restart.
* -days 365: This option sets the length of time that the certificate will be considered valid. We set it for one year here. Many modern browsers will reject any certificates that are valid for longer than one year.
* -newkey rsa:2048: This specifies that we want to generate a new certificate and a new key at the same time. We did not create the key that is required to sign the certificate in a previous step, so we need to create it along with the certificate. The rsa:2048 portion tells it to make an RSA key that is 2048 bits long.
* -keyout: This line tells OpenSSL where to place the generated private key file that we are creating.
* -out: This tells OpenSSL where to place the certificate that we are creating.

```bash
hostname

sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt

NO
BER
BER
NAN
NAN INC
simpleLinuxVM-26304
(no mail adr)
```
Both of the files you created will be placed in the appropriate subdirectories under /etc/ssl.

Step 3 – Configuring Apache to Use SSL

Now that we have our self-signed certificate and key available, we need to update our Apache configuration to use them. 

On Ubuntu, you can place new Apache configuration files (they must end in .conf) into /etc/apache2/sites-available/and they will be loaded the next time the Apache process is reloaded or restarted.

For this tutorial we will create a new minimal configuration file. (If you already have an Apache <Virtualhost> set up and just need to add SSL to it, you will likely need to copy over the configuration lines that start with SSL, and switch the VirtualHost port from 80 to 443. We will take care of port 80 in the next step.)

Open a new file in the /etc/apache2/sites-available directory:

```bash
cd /etc/ssl
ls
certs  openssl.cnf  private

cd /etc/apache2
cd sites-available/
ls
000-default.conf  default-ssl.conf

sudo nano hostname.conf

<VirtualHost *:443>
   ServerName simpleLinuxVM-26304
   DocumentRoot /var/www/simpleLinuxVM-26304

   SSLEngine on
   SSLCertificateFile /etc/ssl/certs/apache-selfsigned.crt
   SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
</VirtualHost>

# Be sure to update the ServerName line to however you intend to address your server. This can be a hostname, full domain name, or an IP address. 
# Make sure whatever you choose matches the Common Name you chose when making the certificate.

ls
000-default.conf  default-ssl.conf  simpleLinuxVM-26304.conf

# Create root document
sudo mkdir /var/www/simpleLinuxVM-26304

# Open a new index.html file with your text editor:
sudo nano /var/www/simpleLinuxVM-26304/index.html

# Paste in file
<h1>it worked!</h1>
# This is not a full HTML file, of course, but browsers are lenient and it will be enough to verify our configuration.

# Save and close the file
# Next, we need to enable the configuration file with the a2ensite tool:
sudo a2ensite simpleLinuxVM-26304.conf

# Next, let’s test for configuration errors:
sudo apache2ctl configtest
Syntax OK

# If your output has Syntax OK in it, your configuration file has no syntax errors. We can safely reload Apache to implement our changes:
sudo systemctl reload apache2

```
Open port 443 NSG to test apache

![Apache document ROOT SSL ](https://github.com/spawnmarvel/azure-automation/blob/main/images/apachessl.jpg)


Restart server and test for same result, = ok, yea.
Step 4 — Redirecting HTTP to HTTPS

https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-20-04


## HTTPS for wordpress self signed

Using this CA:

https://github.com/spawnmarvel/quickguides/blob/main/securityPKI-CA/README.md

```bash
sudo apt update
sudo apt upgrade -y

sudo apt install apache2
sudo systemctl enable apache2
systemctl status apache2

# NSG HTTP
# Page OK, Apache2 Default Page

sudo apt install -y php php-{common,mysql,xml,xmlrpc,curl,gd,imagick,cli,dev,imap,mbstring,opcache,soap,zip,intl}

php -v
# PHP 8.1.2-1ubuntu2.14 (cli) (built: Aug 18 2023 11:41:11) (NTS)

sudo apt install mariadb-server mariadb-client
sudo systemctl enable --now mariadb
systemctl status mariadb

# You already have your root account protected, so you can safely answer 'n'. n
# Change the root password? [Y/n] n
# Remove anonymous users? [Y/n] y
# Disallow root login remotely? [Y/n] y
# Remove test database and access to it? [Y/n] y
# Reload privilege tables now? [Y/n] y

# Cleaning up...
# All done!  If you've completed all of the above steps, your MariaDB
# installation should now be secure.

CREATE USER 'XXXXXXXXXX'@'localhost' IDENTIFIED BY 'XXXXXXXXXX';

CREATE DATABASE goodtech_wp;

GRANT ALL PRIVILEGES ON goodtech_wp.* TO 'XXXXXXXXXXX'@'localhost';

FLUSH PRIVILEGES;

exit;

wget https://wordpress.org/latest.zip
sudo apt install unzip
unzip latest.zip

sudo mv wordpress/ /var/www/html/
sudo chown www-data:www-data -R /var/www/html/wordpress/
sudo chmod -R 755 /var/www/html/wordpress/

# Optionally, you can create a configuration for WordPress to help in processing any files relating to WordPress and logging any errors that arise. For that, create a configuration file and paste the below content, editing where necessary.

<VirtualHost *:80>

ServerAdmin admin@simplelinuxvm-12860.com

DocumentRoot /var/www/html/wordpress

ServerName simplelinuxvm-12860-xyhcam5pdsxny.uksouth.cloudapp.azure.com

ServerAlias www.simplelinuxvm-12860-xyhcam5pdsxny.uksouth.cloudapp.azure.com

<Directory /var/www/html/wordpress/>

Options FollowSymLinks

AllowOverride All

Require all granted

</Directory>

ErrorLog ${APACHE_LOG_DIR}/error.log

CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

sudo a2ensite wordpress.conf

sudo a2enmod rewrite

sudo systemctl restart apache2

# Use the below command to disable the Apache test page, restart Apache, and open the address again.

sudo a2dissite 000-default.conf
sudo systemctl restart apache2

```

Then you get wordpress setup and can continue:

![Wordpress](https://github.com/spawnmarvel/azure-automation/blob/main/images/wordpress.jpg)

Done

![Wordpress main](https://github.com/spawnmarvel/azure-automation/blob/main/images/wordpressmain.jpg)


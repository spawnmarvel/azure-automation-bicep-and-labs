# Ubuntu SSL

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
Go to http://hostname.uksouth.cloudapp.azure.com/

![Apache home ](https://github.com/spawnmarvel/azure-automation/blob/main/images/apache.jpg)

Step 2 creating the SSL Certificate

We will use our CA server

https://github.com/spawnmarvel/quickguides/blob/main/securityPKI-CA/README.md

```bash
# Get FQDN
hostname

```
Now create the certificate on the CA server

```bash
# cmd on CA server
# Generating RSA private key
openssl genrsa -out c:\testca\server2\private_key.pem 2048

# Generating request
openssl req -new -key c:\testca\server4\private_key.pem -out c:\testca\server4\req.pem -outform PEM -subj /CN=hostname -nodes

# Server and client extension using new config openssl2.cnf
openssl ca -config c:\testca\openssl2.cnf -in c:\testca\server4\req.pem -out c:\testca\server4\server4_certificate.pem -notext -batch

# Using configuration from c:\testca\openssl2.cnf
# Check that the request matches the signature
# Signature ok
# The Subject's Distinguished Name is as follows
# commonName            :ASN.1 12:'hostname'
# Certificate is to be certified until Sep  3 18:11:57 2033 GMT (3652 days)

# CP files you created to appropriate subdirectories under /etc/ssl on the host that will be using the certificate
/etc/ssl/certs
sudo nano server4_certificate.pem
cd 
# save the key local and move it
sudo nano private_key.pem
sudo cp private_key.pem /etc/ssl/private/private_key.pem

# Open a new file in the /etc/apache2/sites-available directory:
hostname --fqdn
sudo nano /etc/apache2/sites-available/hostname.conf

<VirtualHost *:443>
   ServerName hostname
   DocumentRoot /var/www/hostname

   SSLEngine on
   SSLCertificateFile /etc/ssl/certs/server4_certificate.pem
   SSLCertificateKeyFile /etc/ssl/private/private_key.pem
</VirtualHost>

# Now let’s create our DocumentRoot and put an HTML file in it just for testing purposes:
sudo mkdir /var/www/hostname

# Open a new index.html file with your text editor:
/var/www/simpleLinuxVM-28885
sudo nano index.html

<h1>it worked!</h1>

# Save and close the file Next, we need to enable the configuration file with the a2ensite tool:
sudo a2ensite hostname.conf

# Next, let’s test for configuration errors:
sudo apache2ctl configtest

sudo systemctl reload apache2
```
Open port 443 NSG to test apache

![HTTPS](https://github.com/spawnmarvel/azure-automation/blob/main/images/itworked.jpg)

Or you can use the tutorial from DO, if you do not have a CA

https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-20-04


## Apache DocumentRoot

The DocumentRoot is the top-level directory in the document tree visible from the web and this directive sets the directory in the configuration from which Apache2 or HTTPD looks for and serves web files from the requested URL to the document root.

* DocumentRoot "/var/www/html"
* then access to http://domain.com/index.html refers to /var/www/html/index.html. The DocumentRoot should be described without a trailing slash.

https://www.tecmint.com/find-apache-documentroot-in-linux/

Make a new app

```bash

sudo nano /etc/apache2/sites-available/appnew.conf

<VirtualHost *:443>
   ServerName hostname
   DocumentRoot /var/www/hostname
   DocumentRoot /var/www/html/appnew

   SSLEngine on
   SSLCertificateFile /etc/ssl/certs/server4_certificate.pem
   SSLCertificateKeyFile /etc/ssl/private/private_key.pem   
</VirtualHost>

/var/www/html
sudo mkdir appnew
cd app

<h1>it worked!2</h1>

sudo a2ensite appnew.conf

sudo apache2ctl configtest

# AH00112: Warning: DocumentRoot [/var/www/hostname] does not exist
# Syntax OK

sudo systemctl reload apache2

# Hm, and it shows, it worked!2
```

## HTTPS for wordpress self signed

Using this CA:

https://github.com/spawnmarvel/quickguides/blob/main/securityPKI-CA/README.md


Check this

https://www.liberiangeek.net/2014/10/install-wordpress-self-signed-ssl-apache2-ubuntu-14-04/

https://thejeshgn.com/2012/09/12/securing-your-wordpress-site-with-self-ssl/



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

https://www.digitalocean.com/community/tutorials/how-to-create-a-self-signed-ssl-certificate-for-apache-in-ubuntu-20-04


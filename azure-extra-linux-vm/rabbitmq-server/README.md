# How To Install and Start Using RabbitMQ on Ubuntu 22.04

https://www.cherryservers.com/blog/how-to-install-and-start-using-rabbitmq-on-ubuntu-22-04

## Steps

Step 1: Install RabbitMQ Server
First things first, let’s install the prerequisites:

```bash
sudo apt install curl gnupg apt-transport-https -y
```

We are now ready to add repository signing keys for RabbiMQ main, ErLang, and RabbitMQ PackageCloud repositories respectively:
```bash
# one at a time
curl -1sLf "https://keys.openpgp.org/vks/v1/by-fingerprint/0A9AF2115F4687BD29803A206B73A36E6026DFCA" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/com.rabbitmq.team.gpg > /dev/null
curl -1sLf "https://keyserver.ubuntu.com/pks/lookup?op=get&search=0xf77f1eda57ebb1cc" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg > /dev/null
curl -1sLf "https://packagecloud.io/rabbitmq/rabbitmq-server/gpgkey" | sudo gpg --dearmor | sudo tee /usr/share/keyrings/io.packagecloud.rabbitmq.gpg > /dev/null

```

Create a new file at /etc/apt/sources.list.d/rabbitmq.list and add the following repositories for ErLang and RabbitMQ respectively 
that are suited for Ubuntu 22.04 jammy release:
```bash
cd /etc/apt/sources.list.d/
sudo touch rabbitmq.list

deb [signed-by=/usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg] http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu jammy main
deb-src [signed-by=/usr/share/keyrings/net.launchpad.ppa.rabbitmq.erlang.gpg] http://ppa.launchpad.net/rabbitmq/rabbitmq-erlang/ubuntu jammy main
deb [signed-by=/usr/share/keyrings/io.packagecloud.rabbitmq.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ jammy main
deb-src [signed-by=/usr/share/keyrings/io.packagecloud.rabbitmq.gpg] https://packagecloud.io/rabbitmq/rabbitmq-server/ubuntu/ jammy main

```
Save the file and you are ready to update your repository listings:
```bash
sudo apt update -y
```

After your repository listings are updated, continue with installing required ErLang packages:
```bash
sudo apt install -y erlang-base erlang-asn1 erlang-crypto erlang-eldap erlang-ftp erlang-inets erlang-mnesia erlang-os-mon erlang-parsetools erlang-public-key erlang-runtime-tools erlang-snmp erlang-ssl erlang-syntax-tools erlang-tftp erlang-tools erlang-xmerl
```

Finally, we can install RabbitMQ server and its dependencies:
```bash
sudo apt install rabbitmq-server -y --fix-missing

sudo systemctl status rabbitmq-server

# Enable it at boot
sudo systemctl enable rabbitmq-server

# Restart server and verify start up
sudo shutdown -r now
```
![RabbitMQ install](https://github.com/spawnmarvel/azure-automation/blob/main/images/rabbitmqinstall.jpg)
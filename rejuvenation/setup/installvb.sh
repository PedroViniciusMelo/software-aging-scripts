apt-get install gnupg wget curl sysstat -y
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bullseye contrib" >> /etc/apt/sources.list
wget -O oracle_vbox_2016.asc https://www.virtualbox.org/download/oracle_vbox_2016.asc
gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg oracle_vbox_2016.asc
apt-get update
apt-get install virtualbox-7.0 -y

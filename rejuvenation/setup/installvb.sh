apt-get install gnupg wget curl sysstat -y

echo "deb [arch=amd64 signed-by=/usr/share/keyrings/oracle-virtualbox-2016.gpg] https://download.virtualbox.org/virtualbox/debian bullseye contrib" >> /etc/apt/sources.list

gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg oracle_vbox_2016.asc

# wget -O oracle_vbox_2016.asc https://www.virtualbox.org/download/oracle_vbox_2016.asc

wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc

# The key fingerprint for oracle_vbox_2016.asc is
# B9F8 D658 297A F3EF C18D  5CDF A2F6 83C5 2980 AECF
# Oracle Corporation (VirtualBox archive signing key) <info@virtualbox.org>

apt-get update
apt-get install virtualbox-7.0 -y

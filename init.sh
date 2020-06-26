#!/bin/bash

# New user & password
HOST_NAME=''
NEW_USER=''
NEW_PASS=''
useradd $NEW_USER
usermoad -a -G wheel $NEW_USER
echo "$NEW_PASS" | passwd --stdin $NEW_USER

#Enable password authentication
sed -i 's(PasswordAuthentication no(PasswordAuthentication yes(g' /etc/ssh/sshd_config
systemctl restart sshd

# Reset hostname
hostnamectl set-hostname $HOST_NAME

#Update system
yum update -y

# Install custom packages
yum install unzip wget vim psmisc setroubleshoot-server bash-completion rsync curl tuned bind-utils firewalld rsync epel-release -y

# Configure Firewalld
systemctl enable --now firewalld
firewall-cmd --set-default-zone=public
firewall-cmd --zone=public --permanent --add-port={22,80,443}/tcp 
firewall-cmd --reload

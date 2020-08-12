#!/bin/bash

# Exit if error
set -e

# New user & password
HOST_NAME=''
NEW_USER=''
NEW_PASS=''

useradd $NEW_USER
usermod -a -G wheel $NEW_USER
echo "$NEW_PASS" | passwd --stdin $NEW_USER

#Enable password authentication
sed -i 's(PasswordAuthentication no(PasswordAuthentication yes(g' /etc/ssh/sshd_config
systemctl restart sshd

# Reset hostname
hostnamectl set-hostname $HOST_NAME

#Update system
yum update -y

# Install custom packages

source /etc/os-release

if [[ "$NAME" == "Fedora" ]]; then
        dnf install unzip wget vim psmisc setroubleshoot-server bash-completion rsync curl tuned bind-utils firewalld rsync -y
elif [[ "$NAME" == "CentOS Linux" ]]; then
        yum install unzip wget vim psmisc setroubleshoot-server bash-completion rsync curl tuned bind-utils firewalld rsync epel-release -y
fi

# Configure Firewalld
systemctl enable --now firewalld
firewall-cmd --set-default-zone=public
firewall-cmd --zone=public --permanent --add-port={22,80,443}/tcp
firewall-cmd --reload

#!/bin/bash
echo -n "Enter desired hostname(XXX.local): "
#read hostname
hostnamectl set-hostname $1
echo -n "Enter local ip (i.e 10.0.0.3): "
#read localIP
# echo -n "Enter netmask (i.e 255.255.255.0): "
# read netmask
cp /etc/sysconfig/network-scripts/ifcfg-ens33 /etc/sysconfig/network-scripts/ifcfg-ens33.bak

sed -i '/ONBOOT/'d /etc/sysconfig/network-scripts/ifcfg-ens33
sed -i '/IPADDR/'d /etc/sysconfig/network-scripts/ifcfg-ens33
sed -i '/GATEWAY/'d /etc/sysconfig/network-scripts/ifcfg-ens33
cat >>/etc/sysconfig/network-scripts/ifcfg-ens33 <<EOL
ONBOOT=yes
IPADDR=$2
GATEWAY=10.0.0.2
EOL

service network restart

rm -rf /etc/yum.repos.d/* 
echo "backup success!"
cd /etc/yum.repos.d/
echo "start download aliyun source ..."
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
echo "download success, start cleanup and update"
yum -y clean all
yum -y update
echo ""
echo "update success!"
echo "install key software"

yum -y install vim
yum -y install wget

# host
cat >>/etc/hosts <<EOL
10.0.0.99 d.local
EOL

# ssh
cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
sed -i '/UseDNS/'d /etc/ssh/sshd_config
sed -i '/GSSAPIAuthentication/'d /etc/ssh/sshd_config
cat >>/etc/ssh/sshd_config <<EOL
UseDNS=no
GSSAPIAuthentication=no
EOL
service sshd restart
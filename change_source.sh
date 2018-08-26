mv /etc/yum.repos.d/*  /etc/yum.repos.d/bak/
echo "backup success!"
cd /etc/yum.repos.d/
echo "start downlod aliyun source ..."
wget -O /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
echo "down success, start cleanup and update"
yum clean all
yum update
echo ""
echo "update success!"


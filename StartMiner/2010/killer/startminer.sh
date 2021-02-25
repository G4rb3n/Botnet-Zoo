#!/bin/bash

# 上次修改时间 --> 2021-1-7
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgank/startminer-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgank/startminer-$time/" ]
then
    # 创建定时任务、文件、进程备份目录
    mkdir -p $log_dir
    mkdir -p $log_dir/crontab
    mkdir -p $log_dir/file
    mkdir -p $log_dir/process
    touch $log_file
fi

echo "[+] start clean --> $(date)" | tee -a $log_file


# --------------------------------------------------
# 函数定义

# 文件清除函数
kill_file()
{
    if [ -f "$1" ]
    then
        cp -n $1 $log_dir/file
        chattr -ia $1
        echo 'botgank' > $1
        chattr +ia $1
        echo "[+] clean file --> $1" | tee -a $log_file
    fi
}

# 进程清除函数
kill_proc()
{
    if [ -n "$(echo $1 | egrep '[0-9]{3,6}')" ]
    then
        proc_name=$(basename $(ps -fp $1 | awk 'NR>=2 {print $8}'))
        cat /proc/$1/exe >> $log_dir/process/$1-$proc_name.dump
        echo "[+] clean process --> $(ps -fp $1 | awk 'NR>=2 {print $2,$8}')" | tee -a $log_file
        kill -9 $1
    fi
}

cron_dirs=("/var/spool/cron/" "/etc/cron.d/" "/etc/cron.hourly/" "/etc/cron.daily/" "/etc/cron.weekly" "/etc/cron.monthly" "/var/spool/cron/crontabs" )

# 定时任务清除函数
kill_cron()
{
    for cron_dir in ${cron_dirs[@]}
    do
        if [ -n "$(grep -r $1 $cron_dir)" ]
        then
            crontab=$(grep -r $1 $cron_dir)
            cron_file=$(grep -r $1 $cron_dir | awk '{print $1}' | cat | cut -d : -f 1 | uniq)
            cp -n $cron_file $log_dir/crontab
            chattr -ia $cron_file
            sed -i "/$1/d" $cron_file > /dev/null 2>&1
            if [ $? != 0 ]
            then
                echo '' > $cron_file
            fi
            echo "[+] clean crontab --> $crontab" | tee -a $log_file
        fi
    done
}

# --------------------------------------------------
# 清除startminer病毒进程

# 清除2010变种攻击进程
pids="$(ps -elf | grep 'givemexyz' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

pids="$(ps -elf | grep '198.98.57.217' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

pids="$(ps -elf | grep '205.185.116.78' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

# care
pids="$(ps -elf | grep 'lwp_donwload' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

# 清除2006变种攻击进程

urls=("104.244.75.25" "205.185.113.151" "209.141.61.233" "209.141.33.226" "107.189.11.170")
for url in ${urls[@]}
do
    pids="$(netstat -antp | grep $url | grep -v grep | awk '{print $7}' | cut -d / -f 1)"
    if [ -n "$pids" ]
    then
        for pid in $pids
        do
            kill_proc $pid
        done
    fi
done

pids="$(ps -elf | grep '/tmp/scan' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

pids="$(ps -elf | grep '/tmp/.xo' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

# 清除2005变种挖矿进程
pids="$(ps -elf | grep 'kworkerdss\|kworkerds32' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

# 清除2002变种挖矿进程
pids="$(ps -elf | grep 'dbused' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

# 清除1812变种挖矿进程
pids="$(ps -elf | grep 'r1x' | grep 'xd.json' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

pids="$(ps -elf | grep 'r2x' | grep '54.36.137.146:3333' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

# 清除1810变种挖矿进程
pids="$(ps -elf | grep 'sustse' | grep 'config.json' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

# 清除1808变种挖矿进程
pids="$(ps -elf | grep 'java' | grep 'w.conf' | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

# --------------------------------------------------
# 清除startminer病毒文件

# 删除2010变种文件
kill_file '/usr/bin/sysdr' 
kill_file '/bin/sysdr'
kill_file '/usr/bin/initdr'
kill_file '/bin/initdr'
kill_file '/usr/bin/crondr'
kill_file '/bin/crondr'
kill_file '/usr/bin/bprofr'
kill_file '/bin/bprofr'

kill_file '/tmp/dbused'
kill_file '/tmp/dbusex'

kill_file '/tmp/x64b'
kill_file '/tmp/x32b'
kill_file '/tmp/x86_64'
kill_file '/tmp/i686'

# 删除2006变种文件
kill_file '/tmp/xmi'
kill_file '/tmp/.xo'
kill_file '/tmp/dbused'
kill_file '/tmp/ipList.txt'
kill_file '/tmp/hxx'
kill_file '/tmp/p'
kill_file '/tmp/scan'
kill_file '/tmp/masscan'
kill_file '/tmp/scan2.py'
kill_file '/tmp/ip.sh'
kill_file '/tmp/ips.sh'
kill_file '/tmp/x64b'

# 删除2005变种文件
kill_file '/var/tmp/kworkerdss'
kill_file '/var/tmp/kworkerds32'
kill_file '/var/tmp/ss2.py'
kill_file '/var/tmp/ss3.py'
kill_file '/var/tmp/xdd.conf'

# 删除2002变种文件
kill_file '/tmp/.sh/x86_64'
kill_file '/tmp/x86_64'
kill_file '/tmp/i686'
kill_file '/tmp/go'
kill_file '/tmp/x86_643'

# 删除1812变种文件
kill_file '/var/tmp/r1x'
kill_file '/var/tmp/r2x'
kill_file '/var/tmp/r1x3'
kill_file '/var/tmp/xd.json'

# 删除1810变种文件
kill_file '/var/tmp/sustse'
kill_file '/var/tmp/config.json'

# 删除1808变种文件
kill_file '/tmp/java'
kill_file '/tmp/pscf3'
kill_file '/tmp/w.conf'

# --------------------------------------------------
# 清除startminer定时任务

# 清除2010变种定时任务
kill_cron 'givemexyz'
kill_cron '205.185.116.78'
kill_cron '198.98.57.217'

kill_cron "dbused"
kill_cron "dbusex"
kill_cron "\/tmp\/xms"

# 清除2006变种定时任务
kill_cron '\/xmi'

# 清除2005变种定时任务
kill_cron 'hehe.sh'

# 清除2002变种定时任务
kill_cron '2start.jpg'

# 清除1812变种定时任务
kill_cron 'xdd.sh'

# 清除1810变种定时任务
kill_cron 'logo9.jpg'

# 清除1808变种定时任务
kill_cron 'cr.sh'

echo "[+] end clean --> $(date)" | tee -a $log_file
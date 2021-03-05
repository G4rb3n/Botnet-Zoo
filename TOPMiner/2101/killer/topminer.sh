#!/bin/bash

# 上次修改时间 --> 2021-3-4
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgak/topminer-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgak/topminer-$time/" ]
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
        echo 'botgak' > $1
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

cron_dirs=("/var/spool/cron/" "/etc/cron.d/" "/etc/cron.hourly/")

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

# 重定向域名函数
redirect_dns()
{
    if [ -z "$(grep $1 /etc/hosts)" ]
    then
        echo "0.0.0.0 $1" >> /etc/hosts
        echo "[+] add dns redirection --> $1" | tee -a $log_file
    fi
}

# --------------------------------------------------
# 清除topminer定时任务

# 清除2101变种定时任务
kill_cron '\/tmp\/.top-unix'

# --------------------------------------------------
# 清除topminer病毒进程

# 清除2101变种进程
proc_id="$(ps -elf | grep 'crypto' | grep -v grep | awk '{print $4}')"
kill_proc $proc_id

proc_id="$(cat /tmp/.ICE-unix1/top)"
kill_proc $proc_id

proc_id="$(ps -elf | grep 'masscan' | grep -v grep | awk '{print $4}')"
kill_proc $proc_id

# --------------------------------------------------
# 清除topminer病毒文件

# 删除2101变种文件
kill_file '/tmp/.top-unix/nginx'
kill_file '/tmp/.ICE-unix1/top'
kill_file '/tmp/.ICE-unix1/ips.txt'
kill_file '/tmp/.ICE-unix1/password.txt'
kill_file '/tmp/.ICE-unix1/pingbi.txt'
kill_file '/tmp/.ICE-unix1/user.txt'
kill_file '/srv/.ICE-unix1/sshd'
kill_file '/srv/.ICE-unix1/sshd.filepart'
kill_file '/srv/.ICE-unix1/scan.sh'
kill_file '/etc/ipv6_addrconf'
kill_file '/etc/crypto'

# --------------------------------------------------
# 清除其他启动项
sed -i '/crypto/'d /etc/rc.local
sed -i '/crypto/'d /etc/crontab

echo "[+] end clean --> $(date)" | tee -a $log_file
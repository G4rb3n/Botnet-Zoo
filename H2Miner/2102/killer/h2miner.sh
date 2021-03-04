#!/bin/bash

# 上次修改时间 --> 2021-3-4
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgak/h2miner-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgak/h2miner-$time/" ]
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
# 清除h2miner定时任务

# 清除2102变种定时任务
kill_cron '194.38.20.199'

# 清除2012变种定时任务
kill_cron '195.3.146.118'

# --------------------------------------------------
# 清除h2miner病毒进程

# 清除2102、2012变种进程
proc_id="$(ps -elf | grep 'kinsing' | grep -v grep | awk '{print $4}')"
kill_proc $proc_id

proc_id="$(ps -elf | grep 'kdevtmpfsi' | grep -v grep | awk '{print $4}')"
kill_proc $proc_id

# --------------------------------------------------
# 清除h2miner病毒文件

# 删除2102、2012变种文件
kill_file '/etc/kinsing'
kill_file '/tmp/kinsing'
kill_file '/var/tmp/kinsing'
kill_file '/dev/shm/kinsing'
kill_file '/etc/kdevtmpfsi'
kill_file '/tmp/kdevtmpfsi'
kill_file '/var/tmp/kdevtmpfsi'
kill_file '/dev/shm/kdevtmpfsi'
kill_file '/etc/libsystem.so'

echo "[+] end clean --> $(date)" | tee -a $log_file
#!/bin/bash

# 上次修改时间 --> 2020-7-3
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgank/sysupdataminer-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgank/sysupdataminer-$time/" ]
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
# 清除sysupdataminer定时任务

kill_cron '\/etc\/update.sh'

# --------------------------------------------------
# 清除sysupdataminer病毒进程
proc_id="$(ps -elf | grep 'sysupdate' | grep -v grep | awk '{print $4}')"
if [ "$(readlink /proc/$(echo $proc_id | awk '{print $1}')/exe)"=="/etc/sysupdate" ]
then
    kill_proc $proc_id
fi

proc_id="$(ps -elf | grep 'networkservice' | grep -v grep | awk '{print $4}')"
if [ "$(readlink /proc/$(echo $proc_id | awk '{print $1}')/exe)"=="/etc/networkservice" ]
then
    kill_proc $proc_id
fi

proc_id="$(ps -elf | grep 'sysguard' | grep -v grep | awk '{print $4}')"
if [ "$(readlink /proc/$(echo $proc_id | awk '{print $1}')/exe)"=="/etc/sysguard" ]
then
    kill_proc $proc_id
fi

proc_id="$(ps -elf | grep 'update.sh' | grep -v grep | awk '{print $4}')"
kill_proc $proc_id

# --------------------------------------------------
# 清除sysupdataminer病毒文件

# 清除病毒文件
kill_file '/etc/config.json'
kill_file '/etc/sysupdate'
kill_file '/etc/sysupdates'
kill_file '/etc/sysguard'
kill_file '/etc/networkservice'
kill_file '/etc/update.sh'

# --------------------------------------------------
# 清除ssh后门
if [ -f "~/.ssh/authorized_keys" ]
then
    if [ "$(grep "fmwzDMv1RKxPdJI" ~/.ssh/authorized_keys)" ]
    then
        chattr -ia ~/.ssh/authorized_keys
        sed -i "/fmwzDMv1RKxPdJI/d" ~/.ssh/authorized_keys
        echo "[+] clean malicious ssh key --> *fmwzDMv1RKxPdJI*" | tee -a $log_file
    fi
fi

# --------------------------------------------------
# 重定向C&C域名进行免疫
redirect_dns 'de.gsearch.com.de'

echo "[+] end clean --> $(date)" | tee -a $log_file
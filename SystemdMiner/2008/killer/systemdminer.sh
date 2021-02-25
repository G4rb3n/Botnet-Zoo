#!/bin/bash

# 上次修改时间 --> 2020-7-3
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgank/systemdminer-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgank/systemdminer-$time/" ]
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

# 定时任务清除函数
kill_cron()
{
    cron_dirs=("/var/spool/cron/" "/etc/cron.d/" "/etc/cron.hourly/")
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
# 清除sytemdminer定时任务

# 清除定时任务1
# 若存在带有base64字符串的随机名sh脚本，则是systemdminer创建的定时任务
if [ "$(grep -r "\......\.sh" /var/spool/cron/ | awk '{print $6}' | xargs sed -n "/base64 -d/p")" ]
then
    # 获取病毒脚本
    script_file1=$(grep -r "\......\.sh" /var/spool/cron/ | awk '{print $6}')
    # 清除定时任务
    kill_cron "\......\.sh"
fi

# 清除定时任务2
# 若存在带有base64字符串的随机名sh脚本，则是systemdminer创建的定时任务
if [ "$(grep -r "\/opt\/.....\.sh" /etc/cron.d/ | awk '{print $7}' | xargs sed -n "/base64 -d/p")" ]
then
    # 获取病毒脚本
    script_file2=$(grep -r "\/opt\/.....\.sh" /etc/cron.d/ | awk '{print $7}')
    # 清除定时任务
    kill_cron "\/opt\/.....\.sh"
fi


# --------------------------------------------------
# 清除sytemdminer病毒文件

# 清除病毒脚本文件
if [ -f "$script_file1" ]
then
    kill_file $script_file1
fi

if [ -f "$script_file2" ]
then
    kill_file $script_file2
fi

# 清除病毒垃圾文件
if [ -d "/tmp/.X11-unix" ]
then
    cd /tmp/.X11-unix
    if [ -f "/tmp/.X11-unix/00" ]
    then
        pid1=$(cat "/tmp/.X11-unix/00")
        kill_file "/tmp/.X11-unix/00"
    fi

    if [ -f "/tmp/.X11-unix/11" ]
    then
        pid2=$(cat "/tmp/.X11-unix/11")
        kill_file "/tmp/.X11-unix/11"
    fi

    if [ -f "/tmp/.X11-unix/2" ]
    then
        pid3=$(cat "/tmp/.X11-unix/2")
        kill_file "/tmp/.X11-unix/2"
    fi

    if [ -d "/tmp/.X11-unix/sshd" ]
    then
        kill_dir "/tmp/.X11-unix/sshd"
    fi
fi

# --------------------------------------------------
# 清除sytemdminer病毒进程

# 清除病毒母体进程
if [ "$pid1" ]
then
    kill_proc $pid1
fi

# 清除挖矿进程
if [ "$pid2" ]
then
    kill_proc $pid2
fi

# 清除定时任务进程
if [ "$script_file1" ]
then
    if [ "$(ps -elf | grep $script_file1 | grep -v grep)" ]
    then
        proc_ids="$(ps -elf | grep $script_file1 | grep -v grep | awk '{print $4}')"
        for proc_id in $proc_ids
        do
            kill_proc $proc_id
        done
    fi
fi


if [ "$script_file2" ]
then
    if [ "$(ps -elf | grep $script_file2 | grep -v grep)" ]
    then
        proc_ids="$(ps -elf | grep $script_file2 | grep -v grep | awk '{print $4}')"
        for proc_id in $proc_ids
        do
            kill_proc $proc_id
        done
    fi
fi

# 清除随机名挖矿进程


# 清除wget下载进程
if [ "$(ps -elf | grep wget | grep onion\|tor | grep -v grep)" ]
then
    proc_ids="$(ps -elf | grep wget | grep onion\|tor | grep -v grep | awk '{print $4}')"
    for proc_id in $proc_ids
    do
        kill_proc $proc_id
    done
fi

# 清除curl下载进程
if [ "$(ps -elf | grep curl | grep onion\|tor | grep -v grep)" ]
then
    proc_ids="$(ps -elf | grep curl | grep onion\|tor | grep -v grep | awk '{print $4}')"
    for proc_id in $proc_ids
    do
        kill_proc $proc_id
    done
fi

# 重定向恶意域名进行免疫
redirect_dns 'relay.tor2socks.in'

echo "[+] end clean --> $(date)" | tee -a $log_file
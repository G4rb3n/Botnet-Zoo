#!/bin/bash

# 上次修改时间 --> 2020-7-3
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgank/ddg-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgank/ddg-$time/" ]
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

# 目录清除函数
kill_dir()
{
    if [ -d "$1" ]
    then
        cp -r $1 $log_dir/file
        rm -rf $1
        echo "[+] clean dir --> $1" | tee -a $log_file
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

# --------------------------------------------------
# 清除ddg病毒进程

# 遍历寻找挖矿进程
miner_pids="$(netstat -antp | grep '178.128.108.158\|50.116.37.115\|134.209.249.49\|103.195.4.139\|68.183.182.120' | awk '{print $7}' | cut -d "/" -f 1 | sort -u)"
if [ -n "$miner_pids" ]
then
    for miner_pid in $miner_pids
    do
        if [ -n "$(echo $miner_pid | egrep '[0-9]{3,6}')" ]
        then
            miner_path="$(readlink /proc/$miner_pid/exe)"
            # 结束挖矿进程
            kill_proc $miner_pid
            # 删除挖矿文件
            kill_file $miner_path
        fi
    done
fi

# 结束爆破传播进程
# 正则匹配长度为6的随机名进程
brute_pids="$(netstat -antp | awk '{print $7}' | sort -u | egrep "/[a-z]{6}$" | cut -d "/" -f 1 | sort -u)"
if [ -n "$brute_pids" ]
then
    for brute_pid in $brute_pids
    do
        if [ -n "$(echo $brute_pid | egrep '[0-9]{3,6}')" ]
        then
            brute_path="$(readlink /proc/$brute_pid/exe)"
            if [ -n "$brute_path" ]
            then
                # 判断可疑文件是否存在字符串"upx"
                if [ -n "$(grep -i 'upx' $brute_path)" ]
                then
                    kill_proc $brute_pid
                    kill_file $brute_path
                fi
            fi
        fi
    done
fi

# --------------------------------------------------
# 清除ddg病毒文件

# 截取出母体病毒文件路径
if [ -f '/var/spool/cron/root' ]
then
    file_path="$(grep '\/i.sh' /var/spool/cron/root | head -1 | cut -d "(" -f 2 | cut -d "|" -f 1)"
    file_name="${file_path##*\/}"

    # 删除母体病毒文件
    kill_file "/usr/bin/$file_name"
    kill_file "/usr/libexec/$file_name"
    kill_file "/usr/local/bin/$file_name"
    kill_file "/tmp/$file_name"
fi

# 寻找/tmp/目录下的长度为6的随机名文件
files="$(ls -al /tmp/ | awk '{print $9}' | grep -E '^[a-z]{6}$')"
if [ -n "$files" ]
then
    for file in $files
    do
        if [ -n "$(grep -i 'upx' /tmp/$file)" ]
        then
            pid=$(lsof /tmp/$file | awk 'NR>=2 {print $2}')
            if [ -n "$pid" ]
            then
                kill_proc $pid
            fi
            kill_file /tmp/$file
        fi
    done
fi

# 删除病毒随机名文件夹
folders="$(ls -al /var/lib/ | awk '{print $9}' | grep -E '^\.[a-z]{4}$')"
if [ -n "$folders" ]
then
    for folder in $folders
    do
        if [ -n "$(ls -al /var/lib/$folder | awk '{print $9}' | grep -E '[0-9]{4}')" ]
        then
            kill_dir /var/lib/$folder
        fi
    done
fi

folders="$(ls -al /usr/local/ | awk '{print $9}' | grep -E '^\.[a-z]{4}$')"
if [ -n "$folders" ]
then
    for folder in $folders
    do
        if [ -n "$(ls -al /usr/local/$folder | awk '{print $9}' | grep -E '[0-9]{4}')" ]
        then
            kill_dir /usr/local/$folder
        fi
    done
fi

# --------------------------------------------------
# 清除ddg定时任务
kill_cron '\/i.sh'
kill_cron '\/ddgs'

# --------------------------------------------------
# 清除ssh后门
if [ -f "/root/.ssh/authorized_keys" ]
then
    if [ "$(grep "AAAAB3NzaC1yc2EAAAADAQABAAABAQDfxLBb" /root/.ssh/authorized_keys)" ]
    then
        chattr -ia ~/.ssh/authorized_keys
        sed -i "/AAAAB3NzaC1yc2EAAAADAQABAAABAQDfxLBb/d" /root/.ssh/authorized_keys
        chattr +ia ~/.ssh/authorized_keys
        echo "[+] clean malicious ssh key --> *AAAAB3NzaC1yc2EAAAADAQABAAABAQDfxLBb*" | tee -a $log_file
    fi
fi

# --------------------------------------------------
# 添加文件免疫
echo "botgank" > /usr/libexec/pnhmaf
chattr +ia /usr/libexec/pnhmaf
echo "botgank" > /usr/bin/zerocert
chattr +ia /usr/bin/zerocert
echo "botgank" > /usr/bin/ruckusapd
chattr +ia /usr/bin/ruckusapd
echo "botgank" > /tmp/firstpress
chattr +ia /tmp/firstpress

echo "[+] end clean --> $(date)" | tee -a $log_file
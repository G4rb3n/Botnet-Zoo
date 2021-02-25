#!/bin/bash

busybox='/tmp/busybox'

# 上次修改时间 --> 2020-7-3
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgank/lsdminer-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgank/lsdminer-$time/" ]
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
# 下载busybox工具

if [ ! -f "$busybox" ]
then
    echo "[+] downloading busybox..."
    wget -q --timeout=5 http://www.busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-$(uname -m) -O $busybox
    if [ -f "$busybox" ]
    then
        echo "[+] download busybox success --> /tmp/busybox" | tee -a $log_file
        chmod a+x $busybox
    fi
fi

# --------------------------------------------------
# 清除lsdminer定时任务

# 清除1902定时任务
kill_cron 'pastebin.com/raw/sByq0rym'

# 清除1904定时任务
kill_cron 'pastebin.com/raw/LUgg78iz'
kill_cron 'pastebin.com/raw/xmxHzu5P'

# 清除1906、1910定时任务
kill_cron 'lsd.systemten.org'

# 清除1912定时任务
kill_cron 'aliyun.one'

# --------------------------------------------------
# 清除lsdminer病毒进程

# 清除1902变种进程
proc_id="$($busybox ps -elf | grep 'watchdogs' | grep -v grep | awk '{print $1}')"
kill_proc $proc_id

proc_id="$($busybox ps -elf | grep 'ksoftirqds' | grep -v grep | awk '{print $1}')"
kill_proc $proc_id

# 清除1904变种进程
proc_id="$($busybox ps -elf | grep 'kerberods' | grep -v grep | awk '{print $1}')"
kill_proc $proc_id

proc_id="$($busybox ps -elf | grep 'khugepageds' | grep -v grep | awk '{print $1}')"
kill_proc $proc_id

proc_id="$($busybox ps -elf | grep 'kthrotlds' | grep -v grep | awk '{print $1}')"
kill_proc $proc_id

proc_id="$($busybox ps -elf | grep 'kpsmouseds' | grep -v grep | awk '{print $1}')"
kill_proc $proc_id

proc_id="$($busybox ps -elf | grep 'kintegrityds' | grep -v grep | awk '{print $1}')"
kill_proc $proc_id

# 清除1906、1910变种进程
proc_id="$($busybox ps -elf | grep 'sshd' | grep -v grep | awk '{print $1}')"
if [ -n "$proc_id" ]
then
    if [ "$(ls /proc/$proc_id/exe)" == "/tmp/sshd" ]
    then
        kill_proc $proc_id
    fi
fi

proc_id="$($busybox ps -elf | grep 'lsd.systemten.org' | grep -v grep | awk '{print $1}')"
kill_proc $proc_id

proc_id="$($busybox netstat -antp | grep 'lsd.systemten.org' | grep -v grep | awk '{print $7}' | cut -d / -f 1)"
kill_proc $proc_id

# 清除1912变种进程

proc_id="$($busybox ps -elf | grep 'aliyun.one' | grep -v grep | awk '{print $1}')"
kill_proc $proc_id

proc_id="$($busybox netstat -antp | grep 'aliyun.one' | grep -v grep | awk '{print $7}' | cut -d / -f 1)"
kill_proc $proc_id

# --------------------------------------------------
# 清除lsdminer病毒文件

# 清除病毒驱动文件
kill_file '/etc/ld.so.preload'
kill_file '/usr/local/lib/libioset.so'
kill_file '/usr/local/lib/libcryptod.so'
kill_file '/usr/local/lib/libcset.so'
kill_file '/usr/local/lib/libdevmapped.so'
kill_file '/usr/local/lib/libpamcd.so'
kill_file '/usr/local/lib/libdevmapped.so'

# 清除1902变种文件
kill_file '/tmp/watchdogs'
kill_file '/usr/sbin/watchdogs'
kill_file '/tmp/ksoftirqds'
kill_file '/etc/rc.d/init.d/watchdogs'

# 清除1904变种文件
kill_file '/tmp/kerberods'
kill_file '/tmp/khugepageds'
kill_file '/usr/sbin/kerberods'
kill_file '/usr/sbin/kthrotlds'
kill_file '/usr/sbin/kintegrityds'
kill_file '/usr/sbin/kpsmouseds'

kill_file '/etc/init.d/netdns'
kill_file '/etc/rc.d/init.d/kerberods'
kill_file '/etc/rc.d/init.d/kthrotlds'
kill_file '/etc/rc.d/init.d/kpsmouseds'
kill_file '/etc/rc.d/init.d/kintegrityds'

# 清除1906变种文件
kill_file '/tmp/sshd'
kill_file '/usr/bin/sshd'
kill_file '/usr/libexec/sshd'
kill_file '/usr/local/bin/sshd'
kill_file '/usr/local/sbin/sshd'

# 清除1910变种文件
kill_file '/tmp/638b6d9fb883b8'
kill_file '/usr/bin/638b6d9fb883b8'
kill_file '/usr/local/bin/638b6d9fb883b8'
kill_file '/usr/local/sbin/638b6d9fb883b8'

# 清除1912变种文件
kill_file '/tmp/3c2d1c5b54'
kill_file '/usr/bin/3c2d1c5b54'
kill_file '/usr/local/bin/3c2d1c5b54'
kill_file '/usr/local/sbin/3c2d1c5b54'

kill_file '/etc/init.d/sshservice'
kill_file '/usr/lib/systemd/system/sshservice.service'
kill_file '/lib/systemd/system/sshservice.service'
kill_file '/etc/systemd/system/sshservice.service'

# --------------------------------------------------
# 重定向C&C域名进行免疫
redirect_dns 'lsd.systemten.org'
redirect_dns 'aliyun.one'

echo "[+] end clean --> $(date)" | tee -a $log_file
#!/bin/bash

busybox="/tmp/busybox"

# 上次修改时间 --> 2020-11-16
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgank/xorddos-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgank/xorddos-$time/" ]
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

# --------------------------------------------------
# 下载busybox工具

if [ ! -f "$busybox" ]
then
    echo "[+] downloading busybox..."
    wget -q --timeout=5 http://www.busybox.net/downloads/binaries/1.31.0-defconfig-multiarch-musl/busybox-$(uname -m) -O $busybox
    echo "[+] download busybox success --> /tmp/busybox" | tee -a $log_file
    chmod a+x $busybox
fi

# 清除xorddos
kill_xorddos()
{
    echo "[+] clear script path: $1" | tee -a $log_file
    if [ -n "$1" ]
    then
        script_name="$(basename $1)"
    fi

    # 清除xorddos病毒进程
    if [ -n "$script_name" ]
    then
        pids="$($busybox ps -elf | grep $script_name | grep -v grep | awk '{print $1}')"
        for pid in $pids; do kill_proc $pid; done

        pids="$($busybox netstat -atnp | grep ':5009' | grep -v grep | awk '{print $7}' | cut -d / -f 1)"
        for pid in $pids; do kill_proc $pid; done
    fi

    # 清除自启动项
    if [ -n "$script_name" ]
    then
        kill_file /boot/$script_name
        chattr +i /boot/
        kill_file /usr/bin/$script_name
        chattr +i /usr/bin/

        rm -f /etc/rc[1-5].d/S90$script_name
        rm -f /etc/rc.d/rc[1-5].d/S90$script_name
    fi

    # 清除脚本文件
    kill_file $1
    
    # 清除xorddos病毒服务
    if [ -n "$script_name" ]
    then
        # 判断命令是否存在
        if [ -x "$(command -v chkconfig)" ]
        then
            chkconfig –del $script_name
        fi

        if [ -x "$(command -v update-rc.d)" ]
        then
            update-rc.d $script_name remove
        fi
    fi
}

# 获取病毒随机名
script_paths="$(grep -r '# chkconfig: 12345 90 90' /etc/init.d/ | awk '{print $1}' | cut -d : -f 1)"
for script_path in $script_paths; do kill_xorddos $script_path; done

# 清除脚本文件
chattr +i /etc/init.d/

kill_file '/etc/cron.hourly/udev.sh'
kill_file '/etc/cron.hourly/gcc.sh'
kill_file '/etc/cron.hourly/gcc4.sh'
kill_file '/etc/cron.hourly/cron.sh'
chattr +i /etc/cron.hourly/

# 清除驱动文件
kill_file '/lib/libgcc4.so'
kill_file '/lib/libgcc4.4.so'
kill_file '/lib/libudev.so'
kill_file '/lib/libudev.so.6'
kill_file '/lib/libudev4.so'
kill_file '/lib/libudev4.so.6'

# 清除可执行文件
kill_file '/lib/udev/debug'
kill_file '/lib/udev/udev'
kill_file '/lib/udev/dev'
chattr +i '/lib/udev/'

# --------------------------------------------------
# 还原关键目录属性
sleep 5

chattr -i /boot/
chattr -i /usr/bin/
chattr -i /etc/init.d/
chattr -i /etc/cron.hourly
chattr -i /lib/udev

# --------------------------------------------------
# 兜底检查/boot/是否还有残留随机名可执行文件
random_file="$(ls -l /boot/ | awk '{print $9}' | egrep -i '[a-z]{10}')"
kill_file /boot/$random_file

echo "[+] end clean --> $(date)" | tee -a $log_file

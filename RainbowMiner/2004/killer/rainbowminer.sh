#!/bin/bash

busybox="/tmp/busybox"

# 上次修改时间 --> 2020-7-3
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgank/rainbowminer-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgank/rainbowminer-$time/" ]
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

if [ ! -f "/tmp/busybox" ]
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
# 清除rainbowminer病毒进程

# 结束守护进程pdflushs
if [ "$($busybox ps -elf | grep '/etc/init.d/pdflushs' | grep -v grep)" ]
then
    proc_id="$($busybox ps -elf | grep '/etc/init.d/pdflushs' | grep -v grep | awk '{print $1}')"
    cat /proc/$proc_id/exe >> $log_dir/process/$proc_id-pdflushs.dump
    echo "[+] clean process --> $($busybox ps -elf | grep $proc_id | grep -v grep | awk '{print $1,$4,$5,$6,$7,$8}')" | tee -a $log_file
    kill -9 $proc_id
fi

# 结束守护进程libgc++.so
if [ "$($busybox ps -elf | grep '/lib64/libgc++.so' | grep -v grep)" ]
then
    proc_id="$($busybox ps -elf | grep '/lib64/libgc++.so' | grep -v grep | awk '{print $1}')"
    cat /proc/$proc_id/exe >> $log_dir/process/$proc_id-libgc++.dump
    echo "[+] clean process --> $($busybox ps -elf | grep $proc_id | grep -v grep | awk '{print $1,$4,$5,$6,$7,$8}')" | tee -a $log_file
    kill -9 $proc_id
fi

# 结束挖矿进程kthreadds
if [ "$($busybox ps -elf | grep 'kthreadds' | grep -v grep)" ]
then
    proc_id="$($busybox ps -elf | grep 'kthreadds' | grep -v grep | awk '{print $1}')"
    cat /proc/$proc_id/exe >> $log_dir/process/$proc_id-kthreadds.dump
    echo "[+] clean process --> $($busybox ps -elf | grep $proc_id | grep -v grep | awk '{print $1,$4,$5,$6,$7,$8}')" | tee -a $log_file
    kill -9 $proc_id
fi

# --------------------------------------------------
# 清除rainbowminer病毒文件

# 删除病毒母体脚本文件
kill_file '/etc/init.d/pdflushs'

# 删除挖矿程序文件
kill_file '/usr/bin/kthreadds'

# 删除python守护脚本文件
kill_file '/lib64/libgc++.so'

# 删除preload文件
if [ -f "/etc/ld.so.preload" ]
then
    cp -n '/etc/ld.so.preload' $log_dir/file
    chattr -ia '/etc/ld.so.preload'
    rm -f '/etc/ld.so.preload'
    echo "[+] clean file --> /etc/ld.so.preload" | tee -a $log_file
fi

# 删除processhider文件
kill_file '/lib64/libstdc++.so'

# 删除垃圾文件busybox
kill_file '/lib64/busybox'

# 删除垃圾文件chattr
kill_file '/lib64/libg++.so'

# --------------------------------------------------
# 清除ssh后门
if [ -f "~/.ssh/authorized_keys" ]
then
    if [ "$(grep "paDKiUwmHNUSW7E1S18Cl" ~/.ssh/authorized_keys)" ]
    then
        chattr -ia ~/.ssh/authorized_keys
        sed -i "/paDKiUwmHNUSW7E1S18Cl/d" ~/.ssh/authorized_keys
        echo "[+] clean malicious ssh key --> *paDKiUwmHNUSW7E1S18Cl*" | tee -a $log_file
    fi
fi

# --------------------------------------------------
# 重定向C&C域名进行免疫
redirect_dns 'Rainbow66.f3322.net'
redirect_dns 'rainbow20.eatuo.com'

echo "[+] end clean --> $(date)" | tee -a $log_file
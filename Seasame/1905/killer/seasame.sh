#!/bin/bash

# 上次修改时间 --> 2021-3-5
# --------------------------------------------------
# 创建备份目录，以清除时间命名

time=$(date | awk '{print $5}')
log_dir="/tmp/botgak/seasame-$time"
log_file="$log_dir/log"
if [ ! -d "/tmp/botgak/seasame-$time/" ]
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
# 清除seasame定时任务

# 清除1905变种定时任务
kill_cron '\/tmp\/seasame'

# --------------------------------------------------
# 清除seasame病毒文件

# 删除1905变种文件
mal_md5s=("cd4bf850a354a80eb860586d253a4385" "d71eb083e7943f0641982797c09f3e73" "3e86ec46f977a954f304d64ffeadf062")
bash_md5=$(md5sum `command -v bash` | cut -d ' ' -f1)
tmp_files=$(find /tmp -xdev -type f)

for file in ${tmp_files[@]};do
	file_md5=$(md5sum "$file" | cut -d ' ' -f1)
	for mal_md5 in ${mal_md5s[@]};do
		if [ $file_md5 = $mal_md5 ];then
			kill_file $file
		fi
	done
	if [ $file_md5 = $bash_md5 ];then
		new_bash_name=`basename $file`
	fi
done

# 删除恶意服务
kill_file '/etc/systemd/system/cloud_agent.service'

# --------------------------------------------------
# 清除seasame病毒进程

# 清除1905变种进程
proc_id="$(ps -elf | grep 'seasame' | grep -v grep | awk '{print $4}')"
kill_proc $proc_id

proc_id="$(ps -elf | grep 'omelette' | grep -v grep | awk '{print $4}')"
kill_proc $proc_id

proc_id="$(ps -elf | grep '/boot/vmlinuz' | grep -v grep | awk '{print $4}')"
kill_proc $proc_id

pids="$(ps -elf | grep $new_bash_name | grep -v grep | awk '{print $4}')"
if [ -n "$pids" ]
then
    for pid in $pids; do kill_proc $pid; done
fi

# --------------------------------------------------
# 恢复系统文件
cp /usr/bin/wgetak /usr/bin/wget
cp /usr/bin/curlak /usr/bin/curl

echo "[+] end clean --> $(date)" | tee -a $log_file
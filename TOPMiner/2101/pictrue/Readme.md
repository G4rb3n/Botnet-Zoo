## TOPMiner

2020-1-4

TopMiner挖矿团伙针对SSH弱口令进行爆破攻击，成功后执行命令下载恶意shell脚本，并将启动脚本写入crontab定时任务进行持久化，shell脚本继续下载挖矿木马nginx、top启动挖矿。木马入侵系统后，还会下载SSH爆破程序sshd，扫描到网络中开放22端口的Linux系统机器后，通过实时更新的密码字典对其root账号进行爆破攻击。攻击者在爆破攻击程序代码留下注释："宽带充足基本可以12个小时扫描全球"，气焰可谓十分嚣张。

分析过程中，我们还在黑客控制的服务器上发现了具有执行远程命令功能的backdoor木马、具有DDoS攻击、远程shell功能的kaiji木马、黑客可使用这些木马对目标系统进行完全控制。

文件和进程：

/tmp/.top-unix/nginx
/tmp/.ICE-unix1/top
/srv/.ICE-unix1/sshd
/srv/.ICE-unix1/scan.sh
/etc/ipv6_addrconf
/etc/crypto

Crontab定时任务：

/tmp/.top-unix/top -o stratum+tcp://pool.supportxmr.com:8080 -u 42GLbQu8JBqVedDLHdpJEL8U5hSHwSuKh36HBebxeszHFEYDFLG5doz5LVsgAxfYoEJBQpeU39oq81MaJUmMUXYz2ZZXFXN -p X
/tmp/.top-unix/nginx -o stratum+tcp://mine.c3pool.com:15555 -u 43e7GPvFJNrH9X8xeByMkCcqkBr95rZ8rH3YVB13mgYMiQTcJ4Ehtx8ZMVJvWpqnQZ41aMkuiUCFN23BW2ZUpptsH8k7XbL -p X
/etc/crypto

![TOPMiner原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/TOPMiner/TOPMiner.png)

参考链接
```
https://s.tencent.com/research/report/1213.html
```
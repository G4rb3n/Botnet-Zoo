## Sysrv-hello

2021-1-22

腾讯安全威胁情报中心检测到Sysrv-hello僵尸网络对云上Nexus Repository Manager 3存在默认帐号密码的服务器进行攻击。得手后再下载门罗币矿机程序挖矿，同时下载mysql、Tomcat弱口令爆破工具，Weblogic远程代码执行漏洞（CVE-2020-14882）攻击工具进行横向扩散。其攻击目标同时覆盖Linux和Windows操作系统。

排查加固

[文件]

Linux:
/tmp/network01
/tmp/sysrv
/tmp/flag.txt

Windows:
%USERPROFILE%\appdata\loacal\tmp\network01.exe
%USERPROFILE%\appdata\loacal\tmp\sysrv.exe

[进程]

network01
sysrv

[定时任务]

hxxp://185.239.242.71/ldr.sh

加固

Nexus，mysql，tomcat使用强密码
weblogic升级到最新版本

![Sysrv-hello原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/Sysrv-hello/Sysrv-hello.png)

参考链接
```
https://s.tencent.com/research/report/1234.html
```
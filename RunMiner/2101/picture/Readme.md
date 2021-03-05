## RunMiner

2021-1-19

腾讯安全云防火墙检测到RunMiner挖矿木马团伙使用新增漏洞武器攻击云主机挖矿： 利用weblogic反序列化漏洞（CVE-2017-10271）对云主机发起攻击，攻击成功后执行恶意脚本对Linux、Windows双平台植入挖矿木马，进行门罗币挖矿操作。

RunMiner挖矿木马团伙是非常活跃的黑产组织，该组织擅长利用各种漏洞武器入侵存在漏洞的系统，植入木马，控制远程主机挖矿。2020年12月，腾讯安全曾捕获该组织利用Apache Shiro反序列化漏洞（CVE-2016-4437）攻击控制约1.6万台主机挖矿（https://mp.weixin.qq.com/s/7SUXrdZ4WdTVenkVcMpZJQ）。

排查加固：

腾讯安全专案建议weblogic组件存在漏洞，可能遭受漏洞影响的用户对以下条目进行排查，及时检查、清除是否已被植入挖矿木马。

[文件]

Linux:
/tmp/tcpp

Windows:
%USERPROFILE%\Documents\debug\debug.exe
%USERPROFILE%\Documents\debug.bat

[进程]

Linux:
tcpp

Windows:
Debug.exe

[定时任务]

Linux:
/var/spool/cron/`whoami`

Windows:
%systemroot%\System32\Tasks\SystemProcessDebug
%systemroot%\Tasks\SystemProcessDebug

[加固]

腾讯安全专家建议受影响的用户尽快升级Weblogic组件到最新版本，腾讯安全全系列产品支持在各个环节检测、防御RunMiner挖矿木马对云上主机的攻击。

![RunMiner原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/RunMiner/RunMiner.png)

参考链接
```
https://s.tencent.com/research/report/1229.html
```
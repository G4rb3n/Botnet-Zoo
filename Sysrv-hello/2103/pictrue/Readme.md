## Sysrv-hello

2021-3-1

Sysrv-hello僵尸网络于2020年12月首次披露，腾讯安全曾在今年1月发现该团伙使用Weblogic远程代码执行漏洞（CVE-2020-14882）攻击传播，本月该团伙再次升级攻击手法：新增5种攻击能力，已观察到失陷主机数量呈上升趋势。其入侵方式覆盖到多数政企单位。

Sysrv-hello僵尸网络木马当前版本更新较大，更新基础设施，新增端口反调试。
传统攻击手法保留，Mysql爆破、Tomcat爆破、Weblogic漏洞利用、Nexus弱口令命令执行漏洞利用。新增5种攻击方式，Jupyter弱口令爆破、WordPress 弱口令爆破、Jenkins弱口令爆破、Redis未授权写入计划任务、Apache Solr命令执行漏洞攻击。入侵成功后拉取sysrv蠕虫扩散模块，每5分钟随机扫描探测新攻击目标。投递门罗币挖矿木马kthreaddi。

![Sysrv-hello原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/Sysrv-hello/2021-3/Sysrv-hello.png)

参考链接
```
https://s.tencent.com/research/report/1259.html
```
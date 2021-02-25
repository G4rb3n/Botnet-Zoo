## H2Miner

2021-2-22

腾讯安全威胁情报中心检测到春节期间H2Miner挖矿团伙异常活跃，该团伙利用多个漏洞武器攻击云上主机挖矿。H2Miner挖矿团伙攻击活跃，猜测其意图趁春节假期安全运维相对薄弱发起扩散。攻击者利用失陷主机挖矿，会大量消耗主机CPU资源，严重影响主机正常服务运行。

攻击者合并使用了多个漏洞攻击武器，除利用该团伙惯用的XXL-JOB未授权命令执行攻击之外，还使用了PHPUnit远程代码执行漏洞（CVE-2017-9841)、Supervisord远程命令执行漏洞（CVE-2017-11610）和ThinkPHP 5.X远程命令执行漏洞进行攻击扩散，最终投递名为kdevtmpfsi的XMR门罗币矿机组件挖矿牟利。

![H2Miner原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/H2Miner/2102/H2Miner.png)

参考链接
```
https://s.tencent.com/research/report/1254.html
```
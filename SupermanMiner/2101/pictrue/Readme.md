## SupermanMiner

2021-1-11

腾讯安全近期已捕获较多利用golang语言编写的各类脚本木马，这些木马利用多个不同linux服务器组件的高危漏洞或弱密码入侵云服务器挖矿。对这些挖矿木马进行分析溯源，发现分属不同的黑产团伙控制，有点“千军万马一窝蜂携漏洞武器弱口令武器抢占云主机挖矿淘金”的意思。腾讯安全专家建议政企机构安全运维人员及时修补漏洞，排查弱口令，避免服务器沦为黑产控制的肉鸡。

在本例中，部分政企机构使用Redis时，由于没有对redis进行良好的配置，如使用空口令或者弱口令等，导致攻击者可以直接访问redis服务器，并可以通过该问题直接写入计划任务甚至可以直接拿到服务器权限。

腾讯安全专家推荐的修复建议：

[1] 针对未配置redis密码访问的，需要对其进行配置添加用户和密码访问。针对弱口令则需要使用强密码。

[2] 如非必须，不对外开放redis端口，如需要对外开放服务则正确配置好ACL策略。

清理利用漏洞入侵的挖矿木马：

[1] 清除计划任务中的python3.8m.sh相关条目；

[2] 在确认JavaUpdate和mysqlserver进程异常后，将其kill掉；

[3] 删除/var/tmp/下的.system-python3.8-Updates和.Javadoc 文件夹。

![SupermanMiner原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/SupermanMiner/SupermanMiner.png)

参考链接
```
https://s.tencent.com/research/report/1219.html
```
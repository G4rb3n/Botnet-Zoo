## TeamTNT

2021-1-14

腾讯安全威胁情报中心也监测到TeamTNT 变种利用IRC进行通信控制肉鸡服务器组建僵尸网络，此次使用的IRC 采用的是github开源的oragono，暂未检测到后门有执行拒绝服务（DoS）功能。趋势科技曾在12月18日发布的文章中提到TeamTNT在部署具有DoS功能的IRC Bot TNTbotinger。本次攻击目前还只是检测到利用Docker remote api未授权访问漏洞进行攻击，再利用SSH攻击传播，再安装IRC后门。

该挖矿木马通过SSH复用连接进行横向移动感染，利用masscan和zgrab对外扫描占用带宽。同时挖矿木马会占用大量CPU资源进行计算，可能导致业务系统崩溃。除了利用肉鸡服务器挖矿牟利，攻击者还可能利用已失陷的服务器继续横向传播，以攻占更多其他主机，得手后会在失陷主机安装IRC后门实现远程控制，包括：随时可能利用已控制的服务器集群对指定目标发起DDoS攻击、窃取服务器资料等等。

腾讯安全专家建议企业用户按照以下步骤进行自查以及处置，以确认是否被此蠕虫感染，如有删除相关进程文件及定时任务：

[1] Docker Remote API的2375 非必要情况不要暴露在公网，如必须暴露公网 ，则需要配置正确的访问控制策略。

[2] 排查当前主机docker的容器，是否存在非正常容器，将其停止并删除。

[3] 停止xmrigMiner进程。

[4] 如非主动安装masscan/zgrab，将其卸载。

![TeamTNT原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/TeamTNT/2021-1/TeamTNT.png)

参考链接
```
https://s.tencent.com/research/report/1226.html
```
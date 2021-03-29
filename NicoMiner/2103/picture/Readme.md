## NicoMiner

2021-3-18

摘要：
[1] 利用三个漏洞入侵传播：
Hadoop Yarn未授权访问漏洞
PostgreSQL未授权漏洞
PostgreSQL提权代码执行漏洞（CVE-2019-9193）；
[2] 利用漏洞入侵成功后会针对Windows、Linux系统分别投放门罗币矿机；
[3] 感染量增长较快，一个月内翻倍，受害服务器约3000台；
[4] 针对Windows、Linux两个平台的挖矿木马使用相同的钱包；
[5] 关联分析发现疑似作者ID：Nico Jiang；
[6] 通过腾讯安图查询历史情报，发现作者疑似从事刷量相关的黑产记录

由于NicoMiner挖矿木马的攻击呈现明显增长趋势，腾讯安全专家建议企业客户参考以下步骤对系统进行排查和加固：

文件：
/*/pgsql-*/data/java.*
/*/pgsql/data/java.*
/*/postgres/*/data/LinuxTF
/tmp/java

c:\postgresql\*\data\conhost.exe
c:\postgresql\*\data\sqltools.exe
c:\windows\temp\st.exe
c:\program files\postgresql\data\pg*\sqltools.exe

检查CPU占用高的进程：
java
LinuxTF
conhost.exe
sqltools.exe

加固系统：
Hadoop
[1] 如果Hadoop环境仅对内网提供服务，请不要将其服务开放到外网可访问。
[2] 如果必须开启公网访问，Hadoop在2.X以上版本提供了安全认证功能，建议管理员升级并启用Kerberos的认证功能，阻止未经授权的访问。

PostgreSQL
[1] 修改PostgreSQL的访问配置/data/pgsql/9.3/data/pg_hba.conf，限制不受信任的对象进行访问；
[2] 谨慎考虑分配pg_read_server_files、pg_write_server_files、pg_execute_server_program 角色权限给数据库客户。

![Nicominer原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/NicoMiner/nicominer.png)
![Nicominer原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/NicoMiner/nicominer2.png)

参考链接
```
https://s.tencent.com/research/report/1274.html
```
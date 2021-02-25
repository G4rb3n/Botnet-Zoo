## TeamTNT

2020-12-15

腾讯安全威胁情报中心近期发现的TeamTNT挖矿木马新变种，对数据回传和横向移动的模块代码进行了功能升级和性能优化，新变种的主要改进有以下几点：

[1] 代码结构进行了调整，功能模块更加清晰明了；

[2] 更新C2地址，并将恶意模块下载和数据回传合并为同一C2；

[3] 受害主机隐私数据拆分为多个文件独立上传，并附带受害主机公网IP地址信息。该团伙收集目标计算机信息，显然是为了下一步的攻击更加有效。

![TeamTNT原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/TeamTNT/2020-12/TeamTNT.png)

参考链接
```
https://s.tencent.com/research/report/1200.html
```
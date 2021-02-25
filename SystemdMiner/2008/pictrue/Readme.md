2020-3-3

![SystemdMiner原理图](https://github.com/G4rb3n/Malware-Picture/blob/master/Miner/SystemdMiner/SystemdMiner.jpg)

```
入侵点
  ｜
  ｜--> SSH爆破登陆

攻击组件
   ｜
   ｜--> 攻击脚本
   ｜       ｜
   ｜       ｜--> Kpccv.sh -- 下载模块 -- 177e3be14adcc6630122f9ee1133b5d3
   ｜       ｜--> INI -- 挖矿模块 -- e5f8c201b1256b617974f9c1a517d662
   ｜       ｜--> trc -- 僵尸网络模块
   ｜       ｜--> bot -- 僵尸网络模块

漏洞
 ｜
 ｜--> 无

绕过防御
   ｜
   ｜--> 卸载删除阿里云安骑士(aliyun)和腾讯(yunjing)主机安全产品

横向渗透
   ｜
   ｜--> ansible工具
   ｜--> knife工具
   ｜--> salt工具

持久化
  ｜
  ｜--> 创建定时任务0kpccv，每53分钟执行一次病毒脚本kpccv.sh
  ｜--> 清除其他挖矿木马，并屏蔽systemten.org、pm.cpuminerpool.com等挖矿网址

C&C通信
   ｜
   ｜--> tencentxjy5kpccv.t.tor2web.io
   ｜--> tencentxjy5kpccv.t.tor2web.io
   ｜--> tencentxjy5kpccv.t.tor2web.to
   ｜--> tencentxjy5kpccv.t.tor2web.in
   ｜--> tencentxjy5kpccv.t.onion.to
   ｜--> tencentxjy5kpccv.t.onion.in.net
   ｜--> tencentxjy5kpccv.t.civiclink.network
   ｜--> tencentxjy5kpccv.t.onion.nz
   ｜--> tencentxjy5kpccv.t.onion.pet
   ｜--> tencentxjy5kpccv.t.onion.ws
   ｜--> tencentxjy5kpccv.t.onion.ly

目的
  ｜
  ｜--> 挖矿 -- 矿池地址：136.243.90.99:8080
```

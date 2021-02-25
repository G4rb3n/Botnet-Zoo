// H2Miner脚本通配规则
rule linux_miner_h2miner_script_gen
{
    meta:
        description = "h2miner script general"
        author = "G4rb3n"
        reference = "https://mp.weixin.qq.com/s/iNq8SdTZ9IrttAoQYLJw5A"
        date = "2020-7-31"
        md5_2001 = "A626C7274F51C55FDFF1F398BB10BAD5"
        md5_2005 = "E600632DA9A710BBA3C53C1DFDD7BAC1"
        md5_2007 = "BE17040E1A4EAF7E2DF8C0273FF2DFD2"
        md5_2008 = "69886742CF56F9FC97B97DF0A19FC8F0"

   strings:
      $s1 = "ulimit -n 65535"
      $s2 = "echo '0' >/proc/sys/kernel/nmi_watchdog"
      $s3 = "echo 'kernel.nmi_watchdog=0' >>/etc/sysctl.conf"
      $s4 = "LDR="

      $c1 = "kingsing"
      $c2 = "195.3.146.118"

   condition:
      ( filesize < 50KB ) and ( ( 2 of ($s*) )  and ( 1 of ($c*) ) )
}
// z0Miner脚本通配规则
rule linux_miner_z0miner_script_gen
{
    meta:
        description = "z0miner shell script general"
        author = "G4rb3n"
        reference = "https://s.tencent.com/research/report/1170.html"
        date = "2020-11-25"

   strings:
      $s1 = "cron good"
      $s2 = "base64.b64decode"
      $s3 = "for file in /home/*"

      $c1 = "z0.txt"
      $c2 = "189.7.105.47"
      $c3 = "/tmp/javax/"
      $c4 = "javae.exe"
      $c5 = "sshd2"

   condition:
      ( filesize < 50KB ) and ( 2 of ($s*) ) and ( 2 of ($c*) )
}
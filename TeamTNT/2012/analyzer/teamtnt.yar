// TeamTNT传播脚本规则
rule linux_miner_teamtnt_script_ssh
{
    meta:
        description = "teamtnt shell script ssh"
        author = "G4rb3n"
        reference1 = "https://x.threatbook.cn/nodev4/vb4/article?threatInfoID=2813"
        reference2 = "https://s.tencent.com/research/report/1185.html"
        date = "2020-12-28"
        md5_2009 = "2B38E23793E4A62936E113B16BFA5C9A"
        md5_2011 = "6DF90D50390DAC474A78AC3571FCBB7F"
        md5_2012 = "1771A2F9846A6883A78CA682B5016539"

   strings:
      $s1 = "echo '###################################################################'"
      $s2 = "PWNWITHTHISLINK="
      $s3 = "RSAUPLOAD="
      $s4 = "i know this server"

      $c = "if type"

      $x1 = "tntrecht +i"
      $x2 = "/.alsp"
      $x3 = "/.daemon"
      $x4 = "85.214.149.236"
      $x5 = "teamtnt.red"
      $x6 = "kaiserfranz.cc"

   condition:
      ( filesize < 20KB ) and  ( 2 of ($s*) ) and ( ( 2 of ($x*) ) or ((#c) > 5) )
}

// TeamTNT母体脚本规则
rule linux_miner_teamtnt_script_gen
{
    meta:
        description = "teamtnt shell script general"
        author = "G4rb3n"
        reference1 = "https://s.tencent.com/research/report/1185.html"
        reference2 = "https://s.tencent.com/research/report/1200.html"
        date = "2020-12-28"
        md5_2011 = "97DABBB953425C00B686369B1253553D"
        md5_2012 = "51ABF38300C85CF27BC275BCF1CC6317"

   strings:
      $s1 = "base64 -d"
      $s2 = "bash 2>/dev/null"
      $s3 = "python"
      $s4 = "hisotry -c\nclear"

      $x1 = "tntrecht "
      $x2 = "kaiserfranz.cc"
      $x3 = "teamtnt.red"

   condition:
      ( filesize < 100KB ) and  ( 3 of ($s*) ) or  ( 2 of ($x*) )
}
// SysUpdataMiner脚本通配规则
rule linux_miner_sysupdataminer_script_gen
{
    meta:
        description = "sysupdataminer script general"
        author = "G4rb3n"
        reference1 = "https://s.tencent.com/research/report/904.html"
        reference2 = "https://s.tencent.com/research/report/1012.html"
        date = "2021-1-25"

   strings:

      $s1 = "setenforce 0 2>dev/null"
      $s2 = "echo SELINUX=disabled > /etc/sysconfig/selinux 2>/dev/null"
      $s3 = "sync && echo 3 >/proc/sys/vm/drop_caches"
      $s4 = "crondir='/var/spool/cron/'\"$USER\""
      $s5 = "cont="
      $s6 = "ssht="
      $s7 = "rtdir"
      $s8 = "bbdir"
      $s9 = "ccdir"

      $x1 = "echo \"no need download\""
      $x2 = "echo \"i am here\""
      $x3 = "echo \"don't kill\""
      $x4 = "echo \"not tmp runing\""
      $x5 = "if [ \"$filesize1\" -ne \"$miner_size\" ]"

      $c1 = "kill_miner_proc()"
      $c2 = "kill_sus_proc()"
      $c3 = "unlock_cron()"
      $c4 = "lock_cron()"
      $c5 = "/tmp/config.json"
      $c6 = "/usr/bin/cur" fullword ascii
      $c7 = "/usr/bin/wge" fullword ascii

   condition:
      ( filesize < 50KB ) and ( ( 4 of ($s*) ) or ( 2 of ($x*) ) or ( 2 of ($c*) ) )
}
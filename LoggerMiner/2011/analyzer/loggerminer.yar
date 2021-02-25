// LoggerMiner脚本通配规则
rule linux_miner_loggerminer_script_gen
{
   meta:
      description = "loggerminer script general"
      author = "G4rb3n"
      date = "2020-12-22"
      md5_xanthe = "7633912D6E1B62292189B756E895CDAE"
      md5_xesa = "7309B0F891A0487B4762D67FE44BE94A"
      md5_fczyo = "E55E452C43BB35F03D3915549C90BFD7"
      md5_pop = "D77ACAF80E157C682065AA515FAA1ADF"

   strings:
      $s1 = "#thanks for everything"
      $s2 = "pwning to pwn"
      $s3 = "if this script helped you make some $$ mining monero, throw a little my way?"
      $s4 = "go()"

      $x1 = "47TmDBB14HuY7xw55RqU27EfYyzfQGp6qKmfg6f445eihemFMn3xPhs8e1qM726pVj6XKtyQ1zqC24kqtv8fXkPZ7bvgSPU"
      $x2 = "34.92.166.158"
      $x3 = "139.162.124.27"
      $x4 = "iplogger.org"
      $x5 = "/var/tmp/java_c"

   condition:
      ( filesize < 50KB ) and ( ( 2 of ($s*) ) or ( 2 of ($x*) ) )
}
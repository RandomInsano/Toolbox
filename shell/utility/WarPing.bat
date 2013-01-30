@echo off

set big=0
set low=1


echo Search started on %date% at %time% >> FoundComputers.txt

:1
set addr=10.0.%big%.%low%

echo Pinging %addr%...
@ping -n 1 -w 500 %addr% > crap.txt
if %errorlevel%==0 echo Found computer at %addr% >> FoundComputers.txt
if %errorlevel%==0 echo Computer found

set /a low=%low%+1
if %low%==255 goto RESET_LOW

GOTO 1


:RESET_LOW
set low=1
set /a big=%big%+1
if %big%==256 end
GOTO 1

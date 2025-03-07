@echo off
setlocal EnableDelayedExpansion

for /F %%a in ('echo prompt $E ^| cmd') do set "ESC=%%a"

:mode
cls
echo.
echo   %ESC%[90m[ %ESC%[96mVSPAMMER v2.1%ESC%[90m ]%ESC%[0m
echo.
echo   %ESC%[96m1.%ESC%[0m Hypixel Mode
echo   %ESC%[96m2.%ESC%[0m Normal Mode
echo   %ESC%[96m3.%ESC%[0m Custom Mode
echo   %ESC%[96m4.%ESC%[0m Nuke Mode
echo.
set /p "mode=%ESC%[90m>%ESC%[0m "
if "%mode%"=="1" goto hypixel
if "%mode%"=="2" goto normal
if "%mode%"=="3" goto custom
if "%mode%"=="4" goto nuke
goto mode

:hypixel
set /p "message=%ESC%[96m1.%ESC%[0m Enter your message: "
set "delay=4000"
set "random=y"
set "ping=n"
set "limit=0"
goto normalstart

:normal
set /p "message=%ESC%[96m1.%ESC%[0m Enter message: "
set "delay=1500"
set "random=n"
set "ping=n"
set "limit=0"
goto normalstart

:custom
set /p "message=%ESC%[96m1.%ESC%[0m Enter message: "
set /p "delay=%ESC%[96m2.%ESC%[0m Enter delay in milliseconds (1000 = 1 second): "
set /p "random=%ESC%[96m3.%ESC%[0m Enable random code? (adds #XXXXXX) (y/n): "
set /p "ping=%ESC%[96m4.%ESC%[0m Enable ping mode? (Discord) (y/n): "
if /i "%ping%"=="y" (
    set /p "userid=%ESC%[96m4.1%ESC%[0m Enter user ID to ping: "
    set "message=xxx %message%"
)
set /p "limityn=%ESC%[96m5.%ESC%[0m Enable message limit? (y/n): "
if /i "%limityn%"=="y" (
    set /p "limit=%ESC%[96m5.1.%ESC%[0m Enter number of messages to send: "
) else (
    set "limit=0"
)
goto normalstart

:nuke
set /p "message=%ESC%[96m1.%ESC%[0m Enter message: "
set /p "nukes=%ESC%[96m2.%ESC%[0m Enter number of nukes to send: "
set /p "raiddelay=%ESC%[96m3.%ESC%[0m Enter delay between raids in seconds: "
cls
echo Current mode: %mode%
echo Message: %message%
echo Number of nukes: %nukes%
echo Raid delay: %raiddelay% seconds
echo.
echo Controls:
echo ESC - Stop
echo CTRL+P - Pause/Resume
echo.
set /p "input=Enter 'start' to begin: "
if /i not "%input%"=="start" goto nuke

powershell -NoProfile -ExecutionPolicy Bypass -File "vspammerhelper.ps1" -message "%message%" -delay 15 -random n -ping n -limit 0 -nukes %nukes% -raiddelay %raiddelay%
exit

:normalstart
cls
echo Current mode: %mode%
echo Message: %message%
echo Delay: %delay%ms
if /i "%random%"=="y" echo Random code: Enabled
if /i "%ping%"=="y" echo Ping mode: Enabled
if defined limit if %limit% gtr 0 echo Message limit: %limit%
echo.
echo Controls:
echo ESC - Stop
echo CTRL+P - Pause/Resume
echo.
set /p "input=Enter 'start' to begin: "
if /i not "%input%"=="start" goto normalstart

powershell -NoProfile -ExecutionPolicy Bypass -File "vspammerhelper.ps1" -message "%message%" -delay %delay% -random "%random%" -ping "%ping%" -userid "%userid%" -limit %limit%

if errorlevel 1 (
    echo [ERROR] PowerShell execution failed
    pause
    goto normalstart
)

exit
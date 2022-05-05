@echo off
@chcp 65001
REM Copyright © 2020 snomiao (snomiao@gmail.com)

REM cd %~dp0
REM start "启动-VPN" ".\vpn\启动.bat"
REM start "启动-FRPC" ".\frpc\启动.bat"


SET STARTUP="%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\sit-vpn-service.bat"
echo @chcp 65001    > %STARTUP%
echo @"%~0"         >> %STARTUP%

cd %~dp0\vpn
start "启动-VPN"  "EasyAutoConnect.exe"

cd %~dp0\frpc
start "启动-FRPC" "frpc-daemon.exe"

cd %~dp0

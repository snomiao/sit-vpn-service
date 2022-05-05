@echo off
git branch --show-current | grep main ^
    || (echo Run this only in main branch && exit 1)

@REM [Robocopy Exit Codes - Windows CMD - SS64.com]( https://ss64.com/nt/robocopy-exit.html )

robocopy \\sits\SIT-VPN-SERVICE .\deploy /MIR

@REM this will exit 1 when frpc.log changed, mostly it's a error line
@REM just like this
@REM 2022/05/05 11:03:13 [W] [control.go:142] [https_frpc] start error: router config conflict

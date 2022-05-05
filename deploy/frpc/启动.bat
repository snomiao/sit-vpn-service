@echo off
chcp 65001
REM Copyright © 2020 snomiao (snomiao@gmail.com)

cd %~dp0
start "FRPC" ".\frpc.exe"

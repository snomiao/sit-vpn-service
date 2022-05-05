@echo off
git branch --show-current | grep main ^
    || (echo Run this only in main branch && exit 1)

echo flag > .\deploy\deploy-frpc-flag.log
echo flag > .\deploy\deploy-vpn-flag.log

robocopy .\deploy \\sits\SIT-VPN-SERVICE /MIR || ^
robocopy .\deploy \\sits\SIT-VPN-SERVICE /MIR

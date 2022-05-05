@echo off
git branch --show-current | grep main ^
    || (echo Run this only in main branch && exit 1)

robocopy .\deploy \\sits\SIT-VPN-SERVICE /MIR

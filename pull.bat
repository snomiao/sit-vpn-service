pnpx snogwt deploy --no-vscode
robocopy \\sits\SIT-VPN-SERVICE .\worktrees\deploy@sit-vpn-service\deploy /MIR 
git --work-tree=.\worktrees\deploy@sit-vpn-service commit -a -m "deploy changed"

git merge deploy
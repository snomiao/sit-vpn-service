#SingleInstance Force
; fprc restart when crashed
while , 1 {
    Process, Exist, frpc.exe
    if (ErrorLevel == 0) {
        RunWait %A_ScriptDir%/frpc.exe
        TrayTip, % 启动 frpc
    }
    Sleep 5000
}
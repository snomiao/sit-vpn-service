#SingleInstance Force
; fprc restart when crashed
while , 1 {
    if ( FileExist(A_ScriptDir "/../deploy-frpc-flag.log")) {
        FileDelete, % A_ScriptDir "/../deploy-frpc-flag.log"
        Reload
    }
    
    Process, Exist, frpc.exe
    if (ErrorLevel == 0) {
        RunWait %A_ScriptDir%/frpc.exe
        TrayTip, % launch frpc
    }
    Sleep 5000
    
}
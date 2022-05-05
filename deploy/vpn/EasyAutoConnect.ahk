; save as UTF-8 with BOM
;
; Copyright © 2020-2022 snomiao (snomiao@gmail.com)
;
#SingleInstance Force

global 脚本UUID := "338ab5e0-31f6-143a-694a-690d0c9d92c1"
global VPN路径 := "C:\Program Files (x86)\Sangfor\SSL\SangforCSClient\SangforCSClient.exe"
global 配置文件 := A_ScriptDir "\configs.ini"

global 服务器地址
IniRead, 服务器地址, %配置文件%, VPN, 服务器地址, 请配置服务器地址
IniWrite, %服务器地址%, %配置文件%, VPN, 服务器地址

global 循环间隔
IniRead, 循环间隔, %配置文件%, VPN, 循环间隔, 5000
IniWrite, %循环间隔%, %配置文件%, VPN, 循环间隔

global 账号
IniRead, 账号, %配置文件%, VPN, 账号, 请配置账号
IniWrite, %账号%, %配置文件%, VPN, 账号

global 密码
IniRead, 密码, %配置文件%, VPN, 密码, 请配置密码
IniWrite, %密码%, %配置文件%, VPN, 密码

global 记住密码
IniRead, 记住密码, %配置文件%, VPN, 记住密码, 1
IniWrite, %记住密码%, %配置文件%, VPN, 记住密码

global 自动登录
IniRead, 自动登录, %配置文件%, VPN, 自动登录, 1
IniWrite, %自动登录%, %配置文件%, VPN, 自动登录

global 自动填写连接信息
IniRead, 自动填写连接信息, %配置文件%, VPN, 自动填写连接信息, 0
IniWrite, %自动填写连接信息%, %配置文件%, VPN, 自动填写连接信息

自动填写连接信息 := 自动填写连接信息 | 0

if(!(FileExist(VPN路径))) {
    ; 安装程序需要管理员权限
    if !A_IsAdmin {
        Run *RunAs "%A_ScriptFullPath%"
        ExitApp
    }
    MsgBox, , , 未能找到 VPN 安装目录，5秒后尝试安装, 5
    ; 这俩会影响
    Process, Close, iexplore.exe
    Process, Close, firefox.exe
    ;
    Run %A_ScriptDir%\EasyConnectInstaller.exe
    ; 等待安装成功（2分钟超时）
    WinWait, EasyConnect Setup, Installed successfully!, 120
    ; 关掉窗口
    WinClose ; fails
    WinKill ; fails
    WinGet, PID, PID ; fails
    Process Close, %PID% ; fails
    ; 因为这个窗口是管理员权限打开的所以似乎很难去关掉它……
    ; 安装成功后以普通用户权限（可能还是管理）重启自己
    Run "%A_ScriptFullPath%"
    ExitApp
}

循环间隔 |= 0
theLoop()
SetTimer theloop, % 循环间隔
Return
theLoop:
    theLoop()
Return

theLoop()
{
    ; 心跳
    FormatTime, TimeString, , (yyyyMMdd.HHmmss)
    Tooltip SIT-VPN-SERVICE - v2020.08.14 - %TimeString% - Running
    
    ; ; 关掉停止工作的错误窗口
    if WinExist("ahk_exe WerFault.exe") {
        ControlClick, 关闭程序
        Tooltip 停止工作
        Return
    }
    if WinActive("ahk_exe WerFault.exe") {
        ControlClick, 关闭程序
        Tooltip 停止工作
        Return
    }
    Process, Close, WerFault.exe
    
    ; VPN崩掉自动重启
    Process, Exist, SangforCSClient.exe
    if (ErrorLevel == 0) {
        Run %VPN路径% /ShortCutAutoLogin
        Return
    }
    ; 自动确认提示信息
    ;  WinExist("Prompt ahk_class #32770 ahk_exe SangforCSClient.exe")
    if WinExist("提示信息 ahk_class #32770 ahk_exe SangforCSClient.exe") {
        ControlClick, OK
        ControlClick, 确定
        ControlClick, Button1
        Return
    }
    
    ; 断线自动重连
    if WinExist("EasyConnect ahk_class #32770 ahk_exe LogoutTimeOut.exe") {
        ControlClick, 重新登录
        Return
    }
    ; 自动切换中文界面
    if WinExist("EasyConnect ahk_class #32770 ahk_exe SangforCSClient.exe", "Address:") {
        ControlSend, ComboBox2, {Up}
    }
    ; 自动阻止弹出浏览器
    ; 安全提示： VPN安全助手发现有尝试启动第三方应用程序行为, 是否允许运行此程序:
    ; ClassNN:	MFCButton2
    ; Text:	禁止
    if WinExist("EasyConnect ahk_class #32770 ahk_exe SangforCSClient.exe") {
        ControlClick, 阻止
        ControlClick, MFCButton2
    }
    ; 自动连接服务器
    if WinExist("EasyConnect ahk_class #32770 ahk_exe SangforCSClient.exe", "服务器地址：") {
        ; 可能是连接也可能是登录窗口
        if 自动填写连接信息
        {
            ControlSetText, Edit1, %服务器地址%
            ControlSetText, Edit5, %账号%
            ControlSetText, Edit6, %密码%
            Sleep, 200
        }
        
        ControlGet, _记住密码, Checked, , 记住密码
        if 记住密码 && !_记住密码
        ControlClick, 记住密码
        
        ControlGet, _自动登录, Checked, , 自动登录
        if 自动登录 && !_自动登录
        ControlClick, 自动登录
        
        ControlClick, 连接
        ControlClick, 登录
        Return
    }
    
    ; 遇到验证码自动重启
    if WinExist("EasyConnect ahk_class #32770 ahk_exe SangforCSClient.exe", "验证码：") {
        WinClose
    }
    ; ; 自动关掉系统消息窗口（算了它会自己关）
    ; if WinExist("系统消息 ahk_class #32770 ahk_exe SangforCSClient.exe") {
    ;     WinClose
    ;     Return
    ; }
    
    ; ; 如果 VPN 打开了浏览器就自动关掉
    Process, Close, MicrosoftEdge.exe
    Process, Close, iexplore.exe
    
    Tooltip SIT-VPN-SERVICE - v2020.08.14 - %TimeString% - Idle
}

; reload & exit
^F12:: ExitApp
F12:: Reload

; debug
F1:: theLoop()

F10::
    Tooltip alive
Return

F3::
    ; ; update self
    ; UrlDownloadToFile, http://xinhang.:8082/EasyAutoConnect/EasyAutoConnect.ahk, tmpEasyAutoConnect.ahk
    ; ; version check
    ; FileRead, content, tmpEasyAutoConnect.ahk
    ; ; 文件读取：内容，临时文件
    
    ; ; 若非 脚本UUID 与 串中串：内容、脚本UUID。 则返回
    ; if (!( 脚本UUID && InStr(content, 脚本UUID))){
    ;     Return
    ; }
    ; ; FileRead, content, tmpEasyAutoConnect.ahk
    ; ; A_StartMenu
    ; ; MsgBox %A_ScriptFullPath%
    
    ; ; FileMove, tmpEasyAutoConnect.ahk, %A_ScriptFullPath%, 1 ; /* OverWrite */
    ; MsgBox, , Updated..., Updated... reload in 3s..
    
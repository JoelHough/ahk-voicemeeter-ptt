#SingleInstance, force
#NoEnv
#Warn
SendMode Input
SetWorkingDir %A_ScriptDir%
#Persistent
Menu, Tray, Icon, mic_red.ico

Logout() {
    DllCall("VoicemeeterRemote64\VBVMR_Logout")
}
OnExit("Logout")

isMuted := 0.0
Menu, Tray, Add, Mute
Menu, Tray, Default, Mute
Menu, Tray, Click, 1
DllCall("LoadLibrary", "Str", "C:\Program Files (x86)\VB\Voicemeeter\VoicemeeterRemote64.dll", "Ptr")
DllCall("VoicemeeterRemote64\VBVMR_Login")
SetTimer, CheckMute, 10000
Gosub, CheckMute
return

RCtrl & v::
RCtrl & v Up::
RCtrl & m::
Mute:
SetTimer, CheckMute, Off
isMuted := 1.0 - isMuted
DllCall("VoicemeeterRemote64\VBVMR_SetParameterFloat", "AStr", "Bus[3].Mute", "Float", isMuted)
Gosub SetMuteIcon
Sleep 100
Gosub CheckMute
KeyWait RCtrl
SetTimer, CheckMute, On
return

SetMuteIcon:
if (isMuted < 0.5) {
    Menu, Tray, UnCheck, Mute
    Menu, Tray, Icon, mic_red.ico
} else {
    Menu, Tray, Check, Mute
    Menu, Tray, Icon, mic_muted.ico
}
return

CheckMute:
DllCall("VoicemeeterRemote64\VBVMR_IsParametersDirty")
DllCall("VoicemeeterRemote64\VBVMR_GetParameterFloat", "AStr", "Bus[3].Mute", "Float*", isMuted)
;MsgBox, % isMuted
Gosub SetMuteIcon
return

#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\phoenix.ico
#AutoIt3Wrapper_Outfile=Builds\AtlasServerUpdateUtility_v1.5.5.exe
#AutoIt3Wrapper_Outfile_x64=Builds\AtlasServerUpdateUtility_v1.5.5_64-bit(x64).exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=By Phoenix125 based on Dateranoth's ConanServerUtility v3.3.0-Beta.3
#AutoIt3Wrapper_Res_Description=Atlas Dedicated Server Update Utility
#AutoIt3Wrapper_Res_Fileversion=1.5.5.0
#AutoIt3Wrapper_Res_ProductName=AtlasServerUpdateUtility
#AutoIt3Wrapper_Res_ProductVersion=v1.5.5
#AutoIt3Wrapper_Res_CompanyName=http://www.Phoenix125.com
#AutoIt3Wrapper_Res_LegalCopyright=http://www.Phoenix125.com
#AutoIt3Wrapper_Res_Icon_Add=Resources\phoenixfaded.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\check1.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\no.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\check2.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\refresh.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\pause.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\info.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\forum.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\discord.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\about.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\configuration.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\manual.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\help.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\toggle_on.ico
#AutoIt3Wrapper_Res_Icon_Add=Resources\toggle_off.ico
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/mo
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;**** Directives created by AutoIt3Wrapper_GUI ****

;AutoIT Native
#include <Date.au3>
#include <Process.au3>
#include <StringConstants.au3>
#include <String.au3>
#include <IE.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Inet.au3>
#include <TrayConstants.au3>; Required For the $TRAY_ICONSTATE_SHOW constant.
#include <GuiConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <ColorConstants.au3>
#include <ListViewConstants.au3>
#include <WinAPI.au3>
#include <ButtonConstants.au3>
#include <GuiListView.au3>
#include <SliderConstants.au3>
#include <Misc.au3>
#include <AutoItConstants.au3>
#include <GDIPlus.au3>
#include <GuiRichEdit.au3>
#include <GuiTab.au3>
#include "GUIListViewEx.au3" ; EXTERNAL : GUIListViewEX

$aGameName = "Atlas"
Global $aFolderTemp = @ScriptDir & "\" & $aGameName & "UtilFiles\"
If Not FileExists($aFolderTemp) Then
	Do
		DirCreate($aFolderTemp)
	Until FileExists($aFolderTemp)
EndIf
FileInstall("G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Resources\AtlasUtilFiles\i_button_green_left1.png", $aFolderTemp, 0)
FileInstall("G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Resources\AtlasUtilFiles\i_button_red_left1.png", $aFolderTemp, 0)
FileInstall("G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Resources\AtlasUtilFiles\i_check_gray_left1.png", $aFolderTemp, 0)
FileInstall("G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Resources\AtlasUtilFiles\i_check_green_left1.png", $aFolderTemp, 0)
FileInstall("G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Resources\AtlasUtilFiles\i_toggle_off_left0.png", $aFolderTemp, 0)
FileInstall("G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Resources\AtlasUtilFiles\i_toggle_on_left0.png", $aFolderTemp, 0)

$aUtilVerStable = "v1.5.5" ; (2019-05-08)
$aUtilVerBeta = "v1.5.5" ; (2019-05-08)
Global $aUtilVerNumber = 5 ; New number assigned for each config file change. Used to write temp update script so that users are not forced to update config.
; 0 = v1.5.0(beta19/20)
; 1 = v1.5.0(beta21/22/23)
; 2 = v1.5.0(beta24)
; 3 = v1.5.0/1/2
; 4 = v1.5.3/4
; 5 = v1.5.5

$aUtilName = "AtlasServerUpdateUtility"
$aServerEXE = "ShooterGameServer.exe"
$aConfigFile = "ServerGrid.json"
$aExperimentalString = "latest_experimental"
$aServerVer = 0
Global $aDuplicateErrorFile = @ScriptDir & "\__DUPLICATE_PORTS_IN_" & $aConfigFile & "__.txt"

Global $oErrorHandler = ObjEvent("AutoIt.Error", "_ErrFunc")
Global $aObjErrFunc = "System" ; Used to list function calling the object in case of object error.
; User's COM error function. Will be called if COM error occurs
Func _ErrFunc($oError = 0)
	; Do anything here.
	$tErr = @ScriptName & " (" & $oError.scriptline & ") : ==> COM Error intercepted !" & @CRLF & _
			@TAB & "err.number is: " & @TAB & @TAB & "0x" & Hex($oError.number) & @CRLF & _
			@TAB & "err.windescription:" & @TAB & $oError.windescription & @CRLF & _
			@TAB & "err.description is: " & @TAB & $oError.description & @CRLF & _
			@TAB & "err.source is: " & @TAB & @TAB & $oError.source & @CRLF & _
			@TAB & "err.helpfile is: " & @TAB & $oError.helpfile & @CRLF & _
			@TAB & "err.helpcontext is: " & @TAB & $oError.helpcontext & @CRLF & _
			@TAB & "err.lastdllerror is: " & @TAB & $oError.lastdllerror & @CRLF & _
			@TAB & "err.scriptline is: " & @TAB & $oError.scriptline & @CRLF & _
			@TAB & "err.retcode is: " & @TAB & "0x" & Hex($oError.retcode) & @CRLF
;~ 	ConsoleWrite(@ScriptName & " (" & $oError.scriptline & ") : ==> COM Error intercepted !" & @CRLF & _
	LogWrite(" [" & $aObjErrFunc & "] Error in ObjEvent:0x" & Hex($oError.number) & " Description:" & $oError.description, " [" & $aObjErrFunc & "] " & $tErr)
	Sleep(500)
EndFunc   ;==>_ErrFunc

Global $aSteamAppID = "1006030"
Global $aSteamDBURLPublic = "https://steamdb.info/app/" & $aSteamAppID & "/depots/?branch=public"
Global $aSteamDBURLExperimental = "https://steamdb.info/app/" & $aSteamAppID & "/depots/?branch=public"
Global $aRCONBroadcastCMD = "broadcast"
Global $aRCONSaveGameCMD = "saveworld"
Global $aRCONShutdownCMD = "DoExit"
$aServerWorldFriendlyName = "temp"
Global $aModAppWorkshop = "appworkshop_834910.acf"
Global $aRebootReason = ""
Global $aServerName = $aGameName
$aServerUpdateLinkVerStable = "http://www.phoenix125.com/share/atlas/atlaslatestver.txt"
$aServerUpdateLinkVerBeta = "http://www.phoenix125.com/share/atlas/atlaslatestbeta.txt"
$aServerUpdateLinkDLStable = "http://www.phoenix125.com/share/atlas/AtlasServerUpdateUtility.zip"
$aServerUpdateLinkDLBeta = "http://www.phoenix125.com/share/atlas/AtlasServerUpdateUtilityBeta.zip"
$aServerBatchFile = @ScriptDir & "\_start_" & $aUtilName & ".bat"
Global $aWebsite = "http://www.phoenix125.com/AtlasServerUpdateUtil.html"
Global $aIniFailFileFull = @ScriptDir & "\___INI_FAIL_VARIABLES___.txt"
Global $aIniFailFileBasic = $aFolderTemp & "IniFailBasic.txt"
Local $aServerSummaryFile = @ScriptDir & "\_SERVER_SUMMARY_.txt"
Global $aUtilUpdateFile = @ScriptDir & "\__UTIL_UPDATE_AVAILABLE___.txt"
Global $aFirstModBoot = True
Global $iIniErrorCRLF = ""
Global $aModMsgInGame[10]
Global $aModMsgDiscord[10]
Global $aModMsgTwitch[10]
Global $aFirstBoot = True
Local $aFirstStartDiscordAnnounce = True
Global $aShowUpdate = False
Global $aPIDRedisFile = $aFolderTemp & $aUtilName & "_lastpidredis.tmp"
Global $aPIDServerFile = $aFolderTemp & $aUtilName & "_lastpidserver.tmp"
Global $aUtilCFGFile = $aFolderTemp & $aUtilName & "_cfg.ini"
Global $aFolderLog = @ScriptDir & "\_Log\"
Global $aSteamCMDDir = @ScriptDir & "\SteamCMD"
Global $aGridSelectFile = @ScriptDir & "\" & $aUtilName & "GridStartSelect.ini"
;Global $aGridLocalFile = @ScriptDir & "\" & $aUtilName & "GridLocalSelect.ini"
Global $aBatFolder = @ScriptDir & "\Batch Files (to run " & $aGameName & " manually)"
Global $aBatUpdateGame = "Update" & $aGameName & ".bat"
Global $aPIDServerReadYetTF = False
Global $aPIDRedisreadYetTF = False
Global $aSteamUpdateNow = False
Global $aOnlinePlayerLast = ""
Global $aRCONError = False
Global $aServerReadyTF = False
$aServerReadyOnce = True
Global $aNoExistingPID = True ; Used to determine whether to announce servers online. If no server PID file exists, it will announce.
Global $aGUIW = 500
Global $aGUIH = 250
Global $aPlayerCountShowTF = True
Global $aPlayerCountWindowTF = False
Global $wOnlinePlayers = 0
Global $gOnlinePlayerWindow = 0
Global $tOnlinePlayerReady = False
;Global $aGUIClear = False
Global $aShowGUI = True
Global $aGUIMainActive = False
;~ Global $aFirstModCheck = False
Global $aGUILogWindowText = ""
Global $aGUIReady = False
Global $sGridIniReWrite = False
Global $LabelUtilReadyStatus = 0
Global $IconReady = 0 ; To prevent undeclared variable
Global $aSelectServers = False ; To prevent undeclared variable
Global $tSelectServersTxt = "" ; To prevent undeclared variable
Global $aExitGUIW2 = False ; Needed to exit Setup Wizard Existing Server GUI due to OnEventMode = 1
Global $aExitGUIW1 = False ; Needed to exit Setup Wizard Select GUI due to OnEventMode = 1
Global $aExitGUIW3 = False ; Needed to exit Setup Wizard New Server GUI due to OnEventMode = 1
Global $aWizardSelect = 99999 ; Predeclare GUI variable for Wizard Select window ControlID
Global $ConfigEditWindow = 99999 ; Predeclare GUI variable for Config Editor window ControlID
Global $aConfigEditWindow = False ; Needed to exit Config Edit due to OnEventMode = 1
Global $LogWindow = 99999 ; Predeclare GUI variable for Log Window ControlID
Global $MainWindow = -1, $gOnlinePlayerWindow = 99999, $wGUIMainWindow = -1 ; Predeclare GUI variables with dummy values to prevent firing the Case statements
Global $WizardWindowNew = 99999, $WizardWindowExist = 99999, $WizardWindowSelect = 99999
Global $aCPUOverallTracker, $fPercent
Global $aCPUOverallTracker = _CPUOverallUsageTracker_Create()
Global $aConfigSettingsImported = False ; Indicates whether the ServerGrid.json file has been imported or not.
Global $iIniRead = False ; Indicators whether the Ini File has been imported or not.

;Atlas Only
$aServerRedisCmd = "redis-server.exe"
$aServerRedisDir = "\AtlasTools\RedisDatabase"
Global $aServerPIDRedis = 0
Global $aServersMax = 400
Global $xTelnetCMD[$aServersMax]
Global $xServerStart[$aServersMax]
Global $aServerPID[$aServersMax]
Global $yServerAltSaveDir[$aServersMax]
Global $xServerModList[50]
Global $aServerModList = ""
Global $xServerGridExtraCMD[$aServersMax]
Global $xServerCrashNumber[$aServersMax]
Global $xServerCPU[$aServersMax]
;Global $aRebootServerDelay = False
Global $aSteamRunCount = 0
;Global $aSteamFailedTwice = False
Global $aSteamFailCount = 0
If @Compiled = 0 Then
	Global $aIconFile = "AtlasServerUpdateUtility_Icons.exe"
Else
	Global $aIconFile = @ScriptName
EndIf

;Global $cSWRunning = "0x0b6623"		; Color SW Server Window Running Text
;Global $cSWRunning = "0x39ff14"		; Color SW Server Window Running Text
;Global $cSWRunning = "0x00a86b" ; Color SW Server Window Running Text
Global $cSWRunning = "0x388E3C" ; Color SW Server Window Running Text
Global $cSWOffline = "0xE65100" ; Color SW Server Window Offline Text
Global $cSWDisabled = "0x666666" ; Color SW Server Window Disabled Text
Global $cSWCrashed = "0xc40233" ; Color SW Server Window Crashed Text
Global $cMWBackground = "0x646464" ; Color MW Main Window Background
Global $cMWMemCPU = "0xFFFF00" ; Color MW Main window Title, CPU, Mem Text
Global $cSWBackground = "0xC8C8C8" ; Color SW Server Window Background
Global $cLWBackground = "0x808080" ; Color LW Log Window Background
Global $cSWTextHL2 = "0xc40233" ; Color SW Server Windows Highlight Text 2 (Red)
Global $cFWBackground = "0xE0E0E0" ; Color FW Log Window Background
Global $fFWFixedFont = "Courier New" ; Font FW for Fix Font Windows
Global $cFWTabBackground = "0xE0E0E0"
Global $cW1Background = "0x979A9A" ; Color LW Wizard Select Window Background
Global $cW2Background = "0x979A9A" ; Color LW Wizard Existing Server Window Background
Global $cW3Background = "0x979A9A" ;  0x808080" ; Color LW Wizard New Server Window Background
; **** Temp
Global $aTotalPlayersOnline = "0"

;~ $aUsePuttytel = "yes"
$aTelnetCheckYN = "no"
$aTelnetCheckSec = "300"
$aTelnetPort = "27520"
$aTelnetPass = "TeLneT_PaSsWoRd"
$aServerVer = "0"
$aServerIP = "127.0.0.1"

#Region ;**** Global Variables ****

Global Const $aIniFile = @ScriptDir & "\" & $aUtilName & ".ini"
Global $aLogFile = $aFolderLog & $aUtilName & "_Log_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
Global $aLogDebugFile = $aFolderLog & $aUtilName & "_LogFull_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
Global $aOnlinePlayerFile = $aFolderLog & $aUtilName & "_OnlineUserLog_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
Global $aOnlinePlayerWebFile = $aFolderLog & $aUtilName & "_OnlineUsers.txt"
Global $aTimeCheck0 = _NowCalc()
Global $aTimeCheck1 = _NowCalc()
Global $aTimeCheck2 = _NowCalc()
Global $aTimeCheck3 = _NowCalc()
Global $aTimeCheck4 = _NowCalc()
Global $aTimeCheck5 = _NowCalc()
; Global $aTimeCheck6 = _NowCalc()
Global $aTimeCheck7 = _NowCalc()
Global $aTimeCheck8 = _NowCalc()
$aBeginDelayedShutdown = 0
Global $aUpdateVerify = "no"
$aFailCount = 0
$aShutdown = 0
$aAnnounceCount1 = 0
$aErrorShutdown = 0
Global $aIniForceWrite = False ; Forces a rewrite of the config.ini file : used after auto-updating config with util updates

#EndRegion ;**** Global Variables ****
; Error handling for Discord announcements
Global Enum $WinHttpRequestOption_UserAgentString, _
		$WinHttpRequestOption_URL, _
		$WinHttpRequestOption_URLCodePage, _
		$WinHttpRequestOption_EscapePercentInURL, _
		$WinHttpRequestOption_SslErrorIgnoreFlags, _
		$WinHttpRequestOption_SelectCertificate, _
		$WinHttpRequestOption_EnableRedirects, _
		$WinHttpRequestOption_UrlEscapeDisable, _
		$WinHttpRequestOption_UrlEscapeDisableQuery, _
		$WinHttpRequestOption_SecureProtocols, _
		$WinHttpRequestOption_EnableTracing, _
		$WinHttpRequestOption_RevertImpersonationOverSsl, _
		$WinHttpRequestOption_EnableHttpsToHttpRedirects, _
		$WinHttpRequestOption_EnablePassportAuthentication, _
		$WinHttpRequestOption_MaxAutomaticRedirects, _
		$WinHttpRequestOption_MaxResponseHeaderSize, _
		$WinHttpRequestOption_MaxResponseDrainSize, _
		$WinHttpRequestOption_EnableHttp1_1, _
		$WinHttpRequestOption_EnableCertificateRevocationCheck
Global Const $WinHttpRequestOption_SslErrorIgnoreFlags_UnknownCA = 0x0100
Global Const $WinHttpRequestOption_SslErrorIgnoreFlags_CertWrongUsage = 0x0200
Global Const $WinHttpRequestOption_SslErrorIgnoreFlags_CertCNInvalid = 0x1000
Global Const $WinHttpRequestOption_SslErrorIgnoreFlags_CertDateInvalid = 0x2000
Global Const $WinHttpRequestOption_SslErrorIgnoreFlags_IgnoreAll = 0x3300 ;IGNORE ALL OF THE ABOVE
; END Error handling for Discord announcements

Opt("GUIOnEventMode", 1)
; -----------------------------------------------------------------------------------------------------------------------
#Region ;**** Startup Checks. Initial Log, Read INI, Check for Correct Paths, Check Remote Restart is bound to port. ****
OnAutoItExitRegister("Gamercide")
Local $xUtilBetaYN = IniRead($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", $aUtilName & " version: (0)Stable, (1)Beta ###", 0)
If $xUtilBetaYN = "1" Then
	Global $aUtilVersion = $aUtilVerBeta
Else
	Global $aUtilVersion = $aUtilVerStable
EndIf
Global $aUtilityVer = $aUtilName & " " & $aUtilVersion
DirCreate($aFolderTemp)
DirCreate($aFolderLog)
LogWrite(" ============================ " & $aUtilName & " " & $aUtilVersion & " Started ============================")
If FileExists($aIniFile) Then _FileWriteToLine($aIniFile, 3, "Version  :  " & $aUtilityVer, True)
Global $aStartText = $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF
Global $aSplashStartUp = SplashTextOn($aUtilName, $aStartText, 475, 110, -1, -1, $DLG_MOVEABLE, "")
FileDelete($aServerBatchFile)
FileWrite($aServerBatchFile, "@echo off" & @CRLF & "START """ & $aUtilName & """ """ & @ScriptDir & "\" & $aUtilName & "_" & $aUtilVersion & ".exe""" & @CRLF & "EXIT")
ReadCFG($aUtilCFGFile)
; ----------- Temporary until enough time has passed for most users to have updated
If FileExists(@ScriptDir & "\" & $aUtilName & "_lastpidredis.tmp") Then FileMove(@ScriptDir & "\" & $aUtilName & "_lastpidredis.tmp", $aPIDRedisFile)
If FileExists(@ScriptDir & "\" & $aUtilName & "_lastpidserver.tmp") Then FileMove(@ScriptDir & "\" & $aUtilName & "_lastpidserver.tmp", $aPIDServerFile)
FileMove(@ScriptDir & "\mod_*.tmp", $aFolderTemp & "*.*", 1)
FileMove(@ScriptDir & "\*.log*", $aFolderLog & "*.*", 1)
If $aCFGLastVerNumber < 1 Then
	$aIniForceWrite = True
	Local $aServerAltSaveDirOld = IniRead($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryName(s) (comma separated. Use same order as listed in ServerGrid.json. Leave blank for default 00,01,10, etc) ###", 0)
	If $aServerAltSaveDirOld <> "" Then
		IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames (Use same order as listed in ServerGrid.json. Comma separated) ###", $aServerAltSaveDirOld)
		IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", 3)
	Else
		IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames (Use same order as listed in ServerGrid.json. Comma separated) ###", "")
		IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", 1)
	EndIf
EndIf
If $aCFGLastVerNumber < 2 Then
	$aIniForceWrite = True
	IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND COUNT --------------- ", "Number of custom RCON Commands to schedule (If changed, util will restart and new custom entries will be added) ###", 1)
	IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND 1 --------------- ", "1-RCON Command to send (leave BLANK to skip) ###", "")
	IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND 1 --------------- ", "1-RCON Command send to (0) ALL grids or (1) Local Grids Only ###", 1)
	IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND 1 --------------- ", "1-File to Execute (leave BLANK to skip) ###", "")
	IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND 1 --------------- ", "1-Scheduled Event days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", 0)
	IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND 1 --------------- ", "1-Scheduled Event hours (comma separated 00-23 ex.04,16) ###", 4)
	IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND 1 --------------- ", "1-Scheduled Event minute (00-59) ###", "00")
	IniWrite($aUtilCFGFile, "CFG", "aCFGRCONCustomLastCount", 1)
	IniWrite($aUtilCFGFile, "CFG", "aCFGRCONCustomShowConfig", "no")
EndIf
If $aCFGLastVerNumber < 4 Then
	$aIniForceWrite = True
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Start servers minimized (for a cleaner look)? (yes/no) ###", "no")
EndIf
If $aCFGLastVerNumber < 5 Then
	Local $tTmp = IniRead($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Check for " & $aUtilName & " updates? (yes/no) ###", "")
	If $tTmp = "no" Then
		Local $tTmp1 = 0
	Else
		Local $tTmp1 = 4
	EndIf
	IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Check for " & $aUtilName & " updates every __ hours (0 to disable) (0-24) ###", $tTmp1)
	IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Automatically install " & $aUtilName & " updates? (yes/no) ###", "no")
	$aIniForceWrite = True
	Local $tObfuscatePass = IniRead($aIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hide passwords in log files? (yes/no) ###", "no")
	IniWrite($aIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hide passwords in log files? (yes/no) ###", $tObfuscatePass)
	IniWrite($aIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before STOP SERVER (comma separated 0-60) ###", "1,3")
	IniWrite($aIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement STOP SERVER (\m - minutes) ###", "Servers shutting down in \m minute(s) for maintenance.")
	IniWrite($aIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement STOP SERVER (\m - minutes) ###", "Server is shutting down in \m minute(s) for maintenance.")
	IniWrite($aIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement STOP SERVER (\m - minutes) ###", "Server is shutting down in \m minute(s) for maintenance.")
	IniWrite($aIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for STOP SERVER? (yes/no) ###", "no")
	IniWrite($aIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for STOP SERVER? (yes/no) ###", "no")

EndIf
; ----------- END Temporary until enough time has passed for most users to have updated
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from " & $aIniFile & ".")
Local $tRunConfig = IniRead($aUtilCFGFile, "CFG", "aCFGRCONCustomShowConfig", "no")
Local $aRunWizard = ReadUini($aIniFile, $aLogFile, True)
If $tRunConfig = "yes" Then
	Global $aServerUseRedis = ""
	ConfigEdit($aSplashStartUp)
	IniWrite($aUtilCFGFile, "CFG", "aCFGRCONCustomShowConfig", "no")
EndIf
If FileExists($aIniFailFileBasic) Then
	FileDelete($aIniFailFileBasic)
EndIf
If FileExists($aIniFailFileFull) Then
	FileDelete($aIniFailFileFull)
EndIf

Global $aConfigFull = $aServerDirLocal & "\ShooterGame\" & $aConfigFile
Global $aDefaultGame = $aServerDirLocal & "\ShooterGame\Config\DefaultGame.ini"
Global $aDefaultGUS = $aServerDirLocal & "\ShooterGame\Config\DefaultGameUserSettings.ini"
Global $aDefaultEngine = $aServerDirLocal & "\ShooterGame\Config\DefaultEngine.ini"

; ----------- Temporary until enough time has passed for most users to have updated: Needed if files were edited with util because _GUICtrlRichEdit_GetText returns a @CR instead of @CRLF
If ($aCFGLastVersion = "v1.5.0(beta15)") Then
	__ReplaceCRwithCRLF($aGridSelectFile)
	__ReplaceCRwithCRLF($aConfigFull)
	__ReplaceCRwithCRLF($aDefaultGame)
	__ReplaceCRwithCRLF($aDefaultGUS)
	__ReplaceCRwithCRLF($aDefaultEngine)
EndIf
Func __ReplaceCRwithCRLF($tFile)
	Local $tFileOpen = FileOpen($tFile)
	Local $tTxt = FileRead($tFileOpen)
	Local $tTxt1 = StringRegExpReplace($tTxt, '\r\N', @CRLF) ; Idea by Ascend4nt
	If @extended > 0 Then
		FileClose($tFileOpen)
		Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
		Local $tFileBak = $tFile & "_" & $tTime & ".bak"
		Local $tTxt2 = StringRegExpReplace($tTxt, '(*BSR_ANYCRLF)\R', @CRLF) ; Idea by Ascend4nt
		FileMove($tFile, $tFileBak, 1)
		FileWrite($tFile, $tTxt2)
	EndIf
	FileClose($tFileOpen)
EndFunc   ;==>__ReplaceCRwithCRLF
; ----------- END Temporary until enough time has passed for most users to have updated

ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Checking for running server and redis processes.")
If $aUtilBetaYN = "1" Then
	$aServerUpdateLinkVerUse = $aServerUpdateLinkVerBeta
	$aServerUpdateLinkDLUse = $aServerUpdateLinkDLBeta
	$aUtilVersion = $aUtilVerBeta
Else
	$aServerUpdateLinkVerUse = $aServerUpdateLinkVerStable
	$aServerUpdateLinkDLUse = $aServerUpdateLinkDLStable
	$aUtilVersion = $aUtilVerStable
EndIf
$aUtilityVer = $aUtilName & " " & $aUtilVersion

;~ If $aUpdateUtil = "yes" And $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) Then
;~ If $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) Then
If $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) And $aUpdateUtil > 0 Then
;~ 	Local $tUtilUpdateAvailableTF = UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName, $aSplashStartUp, $aUpdateUtil)
	Local $tUtilUpdateAvailableTF = UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName, $aSplashStartUp, "show")
	If $tUtilUpdateAvailableTF Then $aSplashStartUp = SplashTextOn($aUtilName, $aStartText, 475, 110, -1, -1, $DLG_MOVEABLE, "")
EndIf

; Atlas
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from " & $aConfigFile & ".")
ImportConfig($aServerDirLocal, $aConfigFile)

;If $aServerRCONImport = "yes" Then
;	$aServerRCONPort=ImportRCON($aServerDirLocal, $xServerAltSaveDir, $aServerGridTotal)
;EndIf
$aTelnetPass = $aServerAdminPass

Global $xServerAltSaveDir[$aServerGridTotal]
If $aServerAltSaveSelect = "3" Then
	$xServerAltSaveDir = StringSplit($aServerAltSaveDir, ",", 2)
ElseIf $aServerAltSaveSelect = "2" Then
	For $i = 0 To ($aServerGridTotal - 1)
		$xServerAltSaveDir[$i] = Chr(Int($xServergridx[$i]) + 65) & (Int($xServergridy[$i]) + 1)
	Next
Else
	Global $xServerAltSaveDir[$aServerGridTotal]
	For $i = 0 To ($aServerGridTotal - 1)
		$xServerAltSaveDir[$i] = $xServergridx[$i] & $xServergridy[$i]
	Next
EndIf
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from GridStartSelect.ini")
GridStartSelect($aGridSelectFile, $aLogFile)

If $aServerUseRedis = "yes" Then
	$aServerPIDRedis = PIDReadRedis($aPIDRedisFile, $aSplashStartUp)
Else
	$aServerPIDRedis = ""
EndIf
$aServerPID = PIDReadServer($aPIDServerFile, $aSplashStartUp)
Global $aServerPlayers[$aServerGridTotal]
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Preparing server startup scripts.")

If ($aServerRCONImport = "yes") Then
	$xServerRCONPort = ImportRCON($aServerDirLocal, $xServerAltSaveDir, $aServerGridTotal, $xStartGrid)
EndIf

If ($sInGameAnnounce = "yes") Or ($aTelnetCheckYN = "yes") Or ($aEnableRCON = "yes") And ($aServerWorldFriendlyName <> "TempXY") Then ; "TempXY" indicates temp settings set to complete a fresh install of Atlas files.
	If $aServerGridTotal <> (UBound($xServerRCONPort) - 1) Then
		SplashOff()
		Local $aErrorMsg = " [CRITICAL ERROR!] The number of grids does not match the number of RCON ports listed in " & $aUtilName & ".ini." & @CRLF & "Grid Total:" & $aServerGridTotal & ". Number of RCON entries:" & (UBound($xServerRCONPort) - 1) & @CRLF & "Example: Server RCON Port(s) (comma separated, grid order left-to-right ) ###: 57510,57512,57514,57516" & @CRLF & @CRLF & "Please correct the RCON entries in " & $aUtilName & ".ini file and restart " & $aUtilName & "."
		LogWrite($aErrorMsg)
		MsgBox($MB_OK, $aUtilityVer, $aErrorMsg)
		Exit
	EndIf
EndIf

;~ If $aServerGridTotal <> (UBound($xServerAltSaveDir)) And ($xServerAltSaveDir <> "") And ($aServerWorldFriendlyName <> "TempXY") Then
If $aServerGridTotal <> UBound($xServerAltSaveDir) And ($aServerWorldFriendlyName <> "TempXY") Then
	SplashOff()
	Local $aErrorMsg = " [CRITICAL ERROR!] The number of grids does not match the number of AltSaveDirectoryNames listed in " & $aUtilName & ".ini." & @CRLF & "Grid Total:" & $aServerGridTotal & ". Number of Server AltSaveDirectoryName entries:" & (UBound($xServerAltSaveDir)) & @CRLF & "Example: Server AltSaveDirectoryName(s) (comma separated. Leave blank for default a00 a01 a10, etc) ###" & @CRLF & @CRLF & "Please correct the AltSaveDirectoryName entries in " & $aUtilName & ".ini file and restart " & $aUtilName & "."
	LogWrite($aErrorMsg)
	MsgBox($MB_OK, $aUtilityVer, $aErrorMsg)
	Exit
EndIf

If (($sInGameAnnounce = "yes") Or ($aTelnetCheckYN = "yes") Or ($aEnableRCON = "yes")) And ($aServerRCONImport = "no") Then
	For $i = 0 To ($aServerGridTotal - 1)
		$xTelnetCMD[$i] = "?RCONEnabled=True?RCONPort=" & $xServerRCONPort[$i + 1]
	Next
Else
	For $i = 0 To ($aServerGridTotal - 1)
		$xTelnetCMD[$i] = ""
	Next
EndIf

If Not $aServerMultiHomeIP = "" Then
	$aServerMultiHomeFull = "?MultiHome=" & $aServerMultiHomeIP
Else
	$aServerMultiHomeFull = ""
EndIf
$aServerDirFull = $aServerDirLocal & "\ShooterGame\Binaries\Win64"

If $aServerRedisFolder = "" Then
	$xServerRedis = """" & $aServerDirLocal & $aServerRedisDir & "\" & $aServerRedisCmd & """ """ & $aServerDirLocal & $aServerRedisDir & "\" & $aServerRedisConfig & """"
Else
	$xServerRedis = """" & $aServerRedisFolder & "\" & $aServerRedisCmd & """ """ & $aServerRedisFolder & "\" & $aServerRedisConfig & """"
EndIf
_CheckForDuplicatePorts()

If $aServerModYN = "yes" Then
	$aServerModCMD = " -manualmanagedmods"
	Local $aMods = StringSplit($aServerModList, ",")
	Global $aModName[$aMods[0] + 1]
	If $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) Then ; $aUtilReboot = A planned reboot of the util... no need to check for updates.
;~ 		$aFirstModCheck = True
		CheckMod($aServerModList, $aSteamCMDDir, $aServerDirLocal, $aSplashStartUp, True)
	EndIf
;~ 	SplashOff()
Else
	$aServerModCMD = ""
EndIf
$aFirstModBoot = False
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Preparing server start files.")
For $i = 0 To ($aServerGridTotal - 1)
	$xServerStart[$i] = """" & $aServerDirFull & "\" & $aServerEXE & """ Ocean?ServerX=" & $xServergridx[$i] & "?ServerY=" & $xServergridy[$i] & "?AltSaveDirectoryName=" & _
			$xServerAltSaveDir[$i] & "?ServerAdminPassword=" & $aServerAdminPass & "?MaxPlayers=" & $aServerMaxPlayers & "?ReservedPlayerSlots=" & $aServerReservedSlots & "?QueryPort=" & _
			$xServerport[$i] & "?Port=" & $xServergameport[$i] & "?SeamlessIP=" & $xServerIP[$i] & $aServerMultiHomeFull & $xTelnetCMD[$i] & $xServerGridExtraCMD[$i] & $aServerExtraCMD & $aServerModCMD
	If ($xStartGrid[$i] = "yes") Then
		LogWrite("", " Imported from " & $aConfigFile & ": Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " Port:" & $xServergameport[$i] & " GamePort:" & $xServerport[$i] & " SeamlessIP:" & $xServerIP[$i] & " RCONPort:" & $xServerRCONPort[$i + 1] & " Folder:" & $xServerAltSaveDir[$i])
	EndIf
Next

; Generic (Not speciifc to Atlas)
;$aSteamCMDDir = $aServerDirLocal & "\SteamCMD"
Global $aSteamAppFile = $aServerDirLocal & "\steamapps\appmanifest_" & $aSteamAppID & ".acf"

If $aUtilReboot = "no" Then
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Checking for existance of external files.")
	FileExistsFunc()
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Checking for existance of external scripts (if enabled).")
EndIf
ExternalScriptExist()

If $aRemoteRestartUse = "yes" Then
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Initializing Remote Restart.")
	TCPStartup()
	Local $aRemoteRestartSocket = TCPListen($aRemoteRestartIP, $aRemoteRestartPort, 100)
	If $aRemoteRestartSocket = -1 Then
		SplashOff()
		MsgBox(0x0, "TCP Error", "Could not bind to [" & $aRemoteRestartIP & "] Check server IP, disable Remote Restart in INI, or check for multiple instances of this util using the same port.")
		LogWrite(" [Remote Restart] Remote Restart enabled. Could not bind to " & $aRemoteRestartIP & ":" & $aRemoteRestartPort)
		Exit
	Else
		If $sObfuscatePass = "no" Then
			LogWrite(" [Remote Restart] Listening for restart request at http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/?" & $aRemoteRestartKey & "=" & $aRemoteRestartCode & " OR http://" & $xServerIP[0] & ":" & $aRemoteRestartPort & "/?" & $aRemoteRestartKey & "=" & $aRemoteRestartCode)
			LogWrite(" [Remote RCON] Listening for RCON commands at http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets , use % as [space]) OR http://" & $xServerIP[0] & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command]")
			LogWrite(" [Remote RCON] To send [space], use [%] without brackets. ex: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi OR http://" & $xServerIP[0] & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@DoExit")
		Else
			LogWrite(" [Remote Restart] Listening for restart request at http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/?[key]=[password]" & " OR http://" & $xServerIP[0] & ":" & $aRemoteRestartPort & "/?[key]=[password]")
			LogWrite(" [Remote RCON] Listening for RCON commands at http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/[server_password]@[command] (no brackets , use % as [space]) OR http://" & $xServerIP[0] & ":" & $aRemoteRestartPort & "/[server_password]@[command]")
			LogWrite(" [Remote RCON] To send [space], use [%] without brackets. ex: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/[server_password]@broadcast%Admin%Says%Hi OR http://" & $xServerIP[0] & ":" & $aRemoteRestartPort & "/[server_password]@DoExit")
		EndIf
	EndIf
EndIf

LogWrite(" [Update] Running initial update check . . ")

$aFirstBoot = True

If $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) Then
	RunExternalScriptBeforeSteam($aSplashStartUp)
;~ 	Local $bRestart = UpdateCheck(False, $aSplashStartUp)
	UpdateCheck(False, $aSplashStartUp)
	RunExternalScriptAfterSteam($aSplashStartUp)
EndIf

;~ Else
;~ 	$bRestart = False
;~ EndIf

;~ If $bRestart Then
;~ 	SteamcmdDelete($aSteamCMDDir)
;~ 	CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
;~ EndIf

$aFirstBoot = False
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Creating _SERVER_SUMMARY_.txt file.")
MakeServerSummaryFile($aServerSummaryFile)
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Starting servers.")

If Not ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
	$aBeginDelayedShutdown = 0
	$aServerPIDRedis = ""
	If $aServerMinimizedYN = "no" Then
		$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir)
	Else
		$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir, "", @SW_MINIMIZE)
	EndIf
	PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
	LogWrite(" [Redis started (PID: " & $aServerPIDRedis & ")]", " [Redis started (PID: " & $aServerPIDRedis & ")] " & $xServerRedis)
	;$aTimeCheck5 = _NowCalc()
EndIf
For $i = 0 To ($aServerGridTotal - 1)
	;	If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) And ($xStartGrid[$i] = "yes") Then
	If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) Then
		If $xStartGrid[$i] = "yes" Then
			ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Starting server " & $xServergridx[$i] & $xServergridy[$i])
			If $aServerMinimizedYN = "no" Then
				$aServerPID[$i] = Run($xServerStart[$i])
			Else
				$aServerPID[$i] = Run($xServerStart[$i], "", @SW_MINIMIZE)
			EndIf
			$xServerCPU[$i] = _ProcessUsageTracker_Create("", $aServerPID[$i])
			Sleep($aServerStartDelay * 1000)
			LogWrite(" [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")]", " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
		Else
			LogWrite(" [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " -*NOT*- STARTED] because it is set to ""no"" in " & $aGridSelectFile)
		EndIf
	EndIf
Next
PIDSaveServer($aServerPID, $aPIDServerFile)
BatchFilesCreate($aSplashStartUp)
If $aUtilReboot = "yes" Then
	$aUtilReboot = "no"
	IniWrite($aUtilCFGFile, "CFG", "aUtilReboot", $aUtilReboot)
EndIf

#EndRegion ;**** Startup Checks. Initial Log, Read INI, Check for Correct Paths, Check Remote Restart is bound to port. ****

#Region ;**** Tray Menu ****
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Preparing GUI. Getting server information.")
$aStartText = ""
Opt("TrayMenuMode", 3) ; The default tray menu items will not be shown and items are not checked when selected. These are options 1 and 2 for TrayMenuMode.
Opt("TrayOnEventMode", 1) ; Enable TrayOnEventMode.
Local $iTrayShowGUI = TrayCreateItem("- SHOW GUI -")
TrayItemSetOnEvent(-1, "Tray_ShowGUI")
Local $iTrayShowConfig = TrayCreateItem("Show Config")
TrayItemSetOnEvent(-1, "Tray_ShowConfig")
TrayCreateItem("") ; Create a separator line.
Local $iTrayAbout = TrayCreateItem("About")
TrayItemSetOnEvent(-1, "Tray_About")
Local $iTrayUpdateUtilCheck = TrayCreateItem("Check for Util Update")
TrayItemSetOnEvent(-1, "Tray_UtilUpdate")
Local $iTrayUpdateUtilPause = TrayCreateItem("Pause Util")
TrayItemSetOnEvent(-1, "Tray_PauseUtil")
TrayCreateItem("") ; Create a separator line.
Local $iTraySendMessage = TrayCreateItem("Send message")
TrayItemSetOnEvent(-1, "Tray_AllSendMsg")
Local $iTraySendRCON = TrayCreateItem("Send RCON command")
TrayItemSetOnEvent(-1, "Tray_AllSendRCON")
;TrayCreateItem("") ; Create a separator line.
Local $iTrayPlayerCount = TrayCreateItem("Show Online Players")
TrayItemSetOnEvent(-1, "Tray_ShowOnlinePlayers")
If $aPlayerCountShowTF Then TrayItemSetState(-1, $TRAY_DISABLE)
Local $iTrayPlayerCheckPause = TrayCreateItem("Disable Online Players Check/Log")
TrayItemSetOnEvent(-1, "Tray_OnlinePlayersCheckDisable")
Local $iTrayPlayerCheckUnPause = TrayCreateItem("Enable Online Players Check/Log")
TrayItemSetOnEvent(-1, "Tray_OnlinePlayersCheckEnable")
;Local $iTrayPlayerHideCount = TrayCreateItem("Hide Online Players")
TrayCreateItem("") ; Create a separator line.
Local $iTrayUpdateServCheck = TrayCreateItem("Check for Server Update")
TrayItemSetOnEvent(-1, "Tray_ServerUpdateCheck")
Local $iTrayUpdateServPause = TrayCreateItem("Disable Server Update Check")
TrayItemSetOnEvent(-1, "Tray_ServerUpdateDisable")
Local $iTrayUpdateServUnPause = TrayCreateItem("Enable Server Update Check")
TrayItemSetOnEvent(-1, "Tray_ServerUpdateEnable")
TrayCreateItem("") ; Create a separator line.
Local $iTrayRemoteRestart = TrayCreateItem("Initiate Remote Restart")
TrayItemSetOnEvent(-1, "Tray_RemoteRestart")
Local $iTrayRestartNow = TrayCreateItem("Restart Servers Now")
TrayItemSetOnEvent(-1, "Tray_RestartServersNow")
TrayCreateItem("") ; Create a separator line.
Local $iTrayExitCloseN = TrayCreateItem("Exit: Do NOT Shut Down Servers")
TrayItemSetOnEvent(-1, "Tray_ExitShutDownN")
Local $iTrayExitCloseY = TrayCreateItem("Exit: Shut Down Servers")
TrayItemSetOnEvent(-1, "Tray_ExitShutDownY")
If $aCheckForUpdate = "yes" Then
	TrayItemSetState($iTrayUpdateServPause, $TRAY_ENABLE)
	TrayItemSetState($iTrayUpdateServUnPause, $TRAY_DISABLE)
Else
	TrayItemSetState($iTrayUpdateServPause, $TRAY_DISABLE)
	TrayItemSetState($iTrayUpdateServUnPause, $TRAY_ENABLE)
EndIf
If $aServerOnlinePlayerYN = "yes" Then
	TrayItemSetState($iTrayPlayerCheckPause, $TRAY_ENABLE)
	TrayItemSetState($iTrayPlayerCheckUnPause, $TRAY_DISABLE)
Else
	TrayItemSetState($iTrayPlayerCheckPause, $TRAY_DISABLE)
	TrayItemSetState($iTrayPlayerCheckUnPause, $TRAY_ENABLE)
EndIf
TraySetState($TRAY_ICONSTATE_SHOW) ; Show the tray menu.
#EndRegion ;**** Tray Menu ****

Opt("GUIResizeMode", $GUI_DOCKAUTO)

$aGUIH = 70 + $aServerGridTotal * 15 ;Create Show Online Players Window Frame
If $aGUIH > 800 Then $aGUIH = 800

ShowMainGUI($aSplashStartUp)
$aGUIReady = True

GUIRegisterMsg($WM_SIZE, "_WM_SIZE")

SplashOff()
Local $tMsg = "Welcome to the new GUI Interface!" & @CRLF & _
		"- The main window updates every 10 seconds." & @CRLF & _
		"- Online Player Count updates independently." & @CRLF & _
		"- COMING SOON! Adjust server settings by clicking on main window." & @CRLF & @CRLF & _
		"- Please report any problems to Discord or email: kim@kim125.com"
MsgBox(0, $aUtilName, $tMsg, 15)
If $aUpdateUtil > 0 Then AdlibRegister("RunUtilUpdate", $aUpdateUtil * 3600000)
;~ If $aUpdateUtil > 0 Then AdlibRegister("RunUtilUpdate", $aUpdateUtil * 60000) ;Kim!!
Local $aSliderPrev = GUICtrlRead($UpdateIntervalSlider)
$aServerCheck = TimerInit()
Global $lLogTabWindow = 0, $lBasicEdit = 0, $lDetailedEdit = 0, $lOnlinePlayersEdit = 0, $lServerSummaryEdit = 0, $lConfigEdit = 0, $lGridSelectEdit = 0, $lServerGridEdit = 0, $lDefaultGameEdit = 0, $lDefaultGUSEdit = 0, $lDefaultEngineEdit = 0
While True ;**** Loop Until Closed ****
	$aSliderNow = GUICtrlRead($UpdateIntervalSlider)
	If $aSliderNow <> $aSliderPrev Then
		GUICtrlSetData($UpdateIntervalEdit, $aSliderNow)
		$aSliderPrev = $aSliderNow
	EndIf
	If WinExists($LogWindow) Then
		$iTab = _GUICtrlTab_GetCurSel($lLogTabWindow)
		Switch $iTab
			Case 0
				ControlShow($LogWindow, "", $lBasicEdit)
				ControlHide($LogWindow, "", $lDetailedEdit)
				ControlHide($LogWindow, "", $lOnlinePlayersEdit)
				ControlHide($LogWindow, "", $lServerSummaryEdit)
				ControlHide($LogWindow, "", $lConfigEdit)
				ControlHide($LogWindow, "", $lGridSelectEdit)
				ControlHide($LogWindow, "", $lServerGridEdit)
				ControlHide($LogWindow, "", $lDefaultGameEdit)
				ControlHide($LogWindow, "", $lDefaultGUSEdit)
				ControlHide($LogWindow, "", $lDefaultEngineEdit)
			Case 1
				ControlHide($LogWindow, "", $lBasicEdit)
				ControlShow($LogWindow, "", $lDetailedEdit)
				ControlHide($LogWindow, "", $lOnlinePlayersEdit)
				ControlHide($LogWindow, "", $lServerSummaryEdit)
				ControlHide($LogWindow, "", $lConfigEdit)
				ControlHide($LogWindow, "", $lGridSelectEdit)
				ControlHide($LogWindow, "", $lServerGridEdit)
				ControlHide($LogWindow, "", $lDefaultGameEdit)
				ControlHide($LogWindow, "", $lDefaultGUSEdit)
				ControlHide($LogWindow, "", $lDefaultEngineEdit)
			Case 2
				ControlHide($LogWindow, "", $lBasicEdit)
				ControlHide($LogWindow, "", $lDetailedEdit)
				ControlShow($LogWindow, "", $lOnlinePlayersEdit)
				ControlHide($LogWindow, "", $lServerSummaryEdit)
				ControlHide($LogWindow, "", $lConfigEdit)
				ControlHide($LogWindow, "", $lGridSelectEdit)
				ControlHide($LogWindow, "", $lServerGridEdit)
				ControlHide($LogWindow, "", $lDefaultGameEdit)
				ControlHide($LogWindow, "", $lDefaultGUSEdit)
				ControlHide($LogWindow, "", $lDefaultEngineEdit)
			Case 3
				ControlHide($LogWindow, "", $lBasicEdit)
				ControlHide($LogWindow, "", $lDetailedEdit)
				ControlHide($LogWindow, "", $lOnlinePlayersEdit)
				ControlShow($LogWindow, "", $lServerSummaryEdit)
				ControlHide($LogWindow, "", $lConfigEdit)
				ControlHide($LogWindow, "", $lGridSelectEdit)
				ControlHide($LogWindow, "", $lServerGridEdit)
				ControlHide($LogWindow, "", $lDefaultGameEdit)
				ControlHide($LogWindow, "", $lDefaultGUSEdit)
				ControlHide($LogWindow, "", $lDefaultEngineEdit)
			Case 4
				ControlHide($LogWindow, "", $lBasicEdit)
				ControlHide($LogWindow, "", $lDetailedEdit)
				ControlHide($LogWindow, "", $lOnlinePlayersEdit)
				ControlHide($LogWindow, "", $lServerSummaryEdit)
				ControlShow($LogWindow, "", $lConfigEdit)
				ControlHide($LogWindow, "", $lGridSelectEdit)
				ControlHide($LogWindow, "", $lServerGridEdit)
				ControlHide($LogWindow, "", $lDefaultGameEdit)
				ControlHide($LogWindow, "", $lDefaultGUSEdit)
				ControlHide($LogWindow, "", $lDefaultEngineEdit)
			Case 5
				ControlHide($LogWindow, "", $lBasicEdit)
				ControlHide($LogWindow, "", $lDetailedEdit)
				ControlHide($LogWindow, "", $lOnlinePlayersEdit)
				ControlHide($LogWindow, "", $lServerSummaryEdit)
				ControlHide($LogWindow, "", $lConfigEdit)
				ControlShow($LogWindow, "", $lGridSelectEdit)
				ControlHide($LogWindow, "", $lServerGridEdit)
				ControlHide($LogWindow, "", $lDefaultGameEdit)
				ControlHide($LogWindow, "", $lDefaultGUSEdit)
				ControlHide($LogWindow, "", $lDefaultEngineEdit)
			Case 6
				ControlHide($LogWindow, "", $lBasicEdit)
				ControlHide($LogWindow, "", $lDetailedEdit)
				ControlHide($LogWindow, "", $lOnlinePlayersEdit)
				ControlHide($LogWindow, "", $lServerSummaryEdit)
				ControlHide($LogWindow, "", $lConfigEdit)
				ControlHide($LogWindow, "", $lGridSelectEdit)
				ControlShow($LogWindow, "", $lServerGridEdit)
				ControlHide($LogWindow, "", $lDefaultGameEdit)
				ControlHide($LogWindow, "", $lDefaultGUSEdit)
				ControlHide($LogWindow, "", $lDefaultEngineEdit)
			Case 7
				ControlHide($LogWindow, "", $lBasicEdit)
				ControlHide($LogWindow, "", $lDetailedEdit)
				ControlHide($LogWindow, "", $lOnlinePlayersEdit)
				ControlHide($LogWindow, "", $lServerSummaryEdit)
				ControlHide($LogWindow, "", $lConfigEdit)
				ControlHide($LogWindow, "", $lGridSelectEdit)
				ControlHide($LogWindow, "", $lServerGridEdit)
				ControlShow($LogWindow, "", $lDefaultGameEdit)
				ControlHide($LogWindow, "", $lDefaultGUSEdit)
				ControlHide($LogWindow, "", $lDefaultEngineEdit)
			Case 8
				ControlHide($LogWindow, "", $lBasicEdit)
				ControlHide($LogWindow, "", $lDetailedEdit)
				ControlHide($LogWindow, "", $lOnlinePlayersEdit)
				ControlHide($LogWindow, "", $lServerSummaryEdit)
				ControlHide($LogWindow, "", $lConfigEdit)
				ControlHide($LogWindow, "", $lGridSelectEdit)
				ControlHide($LogWindow, "", $lServerGridEdit)
				ControlHide($LogWindow, "", $lDefaultGameEdit)
				ControlShow($LogWindow, "", $lDefaultGUSEdit)
				ControlHide($LogWindow, "", $lDefaultEngineEdit)
			Case 9
				ControlHide($LogWindow, "", $lBasicEdit)
				ControlHide($LogWindow, "", $lDetailedEdit)
				ControlHide($LogWindow, "", $lOnlinePlayersEdit)
				ControlHide($LogWindow, "", $lServerSummaryEdit)
				ControlHide($LogWindow, "", $lConfigEdit)
				ControlHide($LogWindow, "", $lGridSelectEdit)
				ControlHide($LogWindow, "", $lServerGridEdit)
				ControlHide($LogWindow, "", $lDefaultGameEdit)
				ControlHide($LogWindow, "", $lDefaultGUSEdit)
				ControlShow($LogWindow, "", $lDefaultEngineEdit)
		EndSwitch
	EndIf

	If TimerDiff($aServerCheck) > 10000 Then
		SetStatusBusy("Server process check in progress...", "Updating Server Info")
		PIDSaveServer($aServerPID, $aPIDServerFile)
		If GUICtrlRead($gPollOnlinePlayers) = $GUI_CHECKED Then
			If $aServerOnlinePlayerYN = "yes" Then
			Else
				$aServerOnlinePlayerYN = "yes"
				IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for, and log, online players? (yes/no) ###", $aServerOnlinePlayerYN)
			EndIf
		Else
			If $aServerOnlinePlayerYN = "no" Then
			Else
				$aServerOnlinePlayerYN = "no"
				IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for, and log, online players? (yes/no) ###", $aServerOnlinePlayerYN)
			EndIf
		EndIf
		If GUICtrlRead($gPollRemoteServersCB) = $GUI_CHECKED Then
			If $aPollRemoteServersYN = "yes" Then
			Else
				$aPollRemoteServersYN = "yes"
				IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for online players on remote servers? (yes/no) ###", $aPollRemoteServersYN)
			EndIf
		Else
			If $aPollRemoteServersYN = "no" Then
			Else
				$aPollRemoteServersYN = "no"
				IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for online players on remote servers? (yes/no) ###", $aPollRemoteServersYN)
			EndIf
		EndIf
		$aSliderNow = GUICtrlRead($UpdateIntervalSlider)
		Local $aUpdateIntervalEdit = GUICtrlRead($UpdateIntervalEdit)
		If $aUpdateIntervalEdit <> $aSliderNow Then
			GUICtrlSetData($UpdateIntervalSlider, $aUpdateIntervalEdit)
		EndIf
		If $aUpdateIntervalEdit <> $aServerOnlinePlayerSec Then
			If $UpdateIntervalEdit <> $aServerOnlinePlayerSec Then
				$aServerOnlinePlayerSec = $aUpdateIntervalEdit
				IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for online players every _ seconds (30-600) ###", $aServerOnlinePlayerSec)
			EndIf
		EndIf
		GUIUpdateQuick()
		#Region ;**** Listen for Remote Restart Request ****
		If $aRemoteRestartUse = "yes" Then
			Local $sRestart = _RemoteRestart($aRemoteRestartSocket, $aRemoteRestartCode, $aRemoteRestartKey, $sObfuscatePass, $aRemoteRestartIP, $aServerName, True)
			Switch @error
				Case 0
					;If ProcessExists($aServerPID) And ($aBeginDelayedShutdown = 0) Then
					If $aBeginDelayedShutdown = 0 Then
						LogWrite(" [" & $aServerName & "] " & $sRestart)
						If ($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes") Then
							$aRebootReason = "remoterestart"
							$aBeginDelayedShutdown = 1
							$aTimeCheck0 = _NowCalc()
						Else
							RunExternalRemoteRestart()
							CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False) ; Do NOT restart redis, Do not set servers to disable.
						EndIf
					EndIf
				Case 1 To 4
					LogWrite(" " & $sRestart & @CRLF)
			EndSwitch
		EndIf
		#EndRegion ;**** Listen for Remote Restart Request ****

		#Region ;**** Keep Server Alive Check. ****
		If Not ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
			$aBeginDelayedShutdown = 0
			If $aServerMinimizedYN = "no" Then
				$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir)
			Else
				$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir, "", @SW_MINIMIZE)
			EndIf
			LogWrite(" [Redis started (PID: " & $aServerPIDRedis & ")]", " [Redis started (PID: " & $aServerPIDRedis & ")] " & $xServerRedis)
			BatchFilesCreate()
		EndIf
		SplashOff()
		; ------------------------------
		For $i = 0 To ($aServerGridTotal - 1)
			If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) Then ; And ($xStartGrid[$i] = "yes") Then
				If $xStartGrid[$i] = "yes" Then
					If $aServerMinimizedYN = "no" Then
						$aServerPID[$i] = Run($xServerStart[$i])
					Else
						$aServerPID[$i] = Run($xServerStart[$i], "", @SW_MINIMIZE)
					EndIf
					$xServerCPU[$i] = _ProcessUsageTracker_Create("", $aServerPID[$i])
					LogWrite(" [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")]", " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
					Sleep($aServerStartDelay * 1000)
					BatchFilesCreate()
				EndIf
			EndIf
		Next
		#EndRegion ;**** Keep Server Alive Check. ****
		#Region ;**** Show Online Players ****
		If $aServerOnlinePlayerYN = "yes" Then
			If ((_DateDiff('s', $aTimeCheck8, _NowCalc())) >= $aServerOnlinePlayerSec) Then
				$aOnlinePlayers = GetPlayerCount(0)
				ShowPlayerCount()
				If $aServerReadyTF And $aServerReadyOnce Then
					If $aNoExistingPID Then
						If $sUseDiscordBotServersUpYN = "yes" Then
							Local $aAnnounceCount3 = 0
							If $aRebootReason = "remoterestart" And $sUseDiscordBotRemoteRestart = "yes" Then
								SplashTextOn($aUtilName, " All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
								SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
								$aAnnounceCount3 = $aAnnounceCount3 + 1
							EndIf
							If $aRebootReason = "stopservers" And $sUseDiscordBotStopServer = "yes" And ($aAnnounceCount3 = 0) Then
								SplashTextOn($aUtilName, " All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
								SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
								$aAnnounceCount3 = $aAnnounceCount3 + 1
							EndIf
							If $aRebootReason = "update" And $sUseDiscordBotUpdate = "yes" And ($aAnnounceCount3 = 0) Then
								SplashTextOn($aUtilName, " All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
								SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
								$aAnnounceCount3 = $aAnnounceCount3 + 1
							EndIf
							If $aRebootReason = "mod" And $sUseDiscordBotUpdate = "yes" And ($aAnnounceCount3 = 0) Then
								SplashTextOn($aUtilName, " All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
								SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
								$aAnnounceCount3 = $aAnnounceCount3 + 1
							EndIf
							If $aRebootReason = "daily" And $sUseDiscordBotDaily = "yes" And ($aAnnounceCount3 = 0) Then
								SplashTextOn($aUtilName, " All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
								SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
								$aAnnounceCount3 = $aAnnounceCount3 + 1
							EndIf
							If $aFirstStartDiscordAnnounce And ($aAnnounceCount3 = 0) Then
								SplashTextOn($aUtilName, " All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
								SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
								$aFirstStartDiscordAnnounce = False
							EndIf
						Else
							SplashTextOn($aUtilName, " All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement NOT sent. Enable first announcement and/or daily, mod, update, remote restart annoucements in config if desired.", 400, 200, -1, -1, $DLG_MOVEABLE, "")
						EndIf
					Else
						SplashTextOn($aUtilName, " All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement SKIPPED because servers were already running or feature disabled in config.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
						$aNoExistingPID = True
					EndIf
					$aServerReadyOnce = False
					Sleep(5000)
					SplashOff()
				EndIf
				$aTimeCheck8 = _NowCalc()
			EndIf
		EndIf
		#EndRegion ;**** Show Online Players ****
		GUICtrlSetData($LabelUtilReadyStatus, "Updating Server Info")
		If ($aDestroyWildDinosYN) = "yes" Then
			If ((_DateDiff('n', $aTimeCheck7, _NowCalc())) >= 60) Then
				If RespawnDinosCheck($aDestroyWildDinosDays, $aDestroyWildDinosHours) Then
					$aTimeCheck7 = _NowCalc()
					DestroyWildDinos()
				EndIf
			EndIf
		EndIf

		#Region ;**** Restart Server Every X Days and X Hours & Min****
		If (($aRestartDaily = "yes") And ((_DateDiff('n', $aTimeCheck2, _NowCalc())) >= 1) And (DailyRestartCheck($aRestartDays, $aRestartHours, $aRestartMin)) And ($aBeginDelayedShutdown = 0)) Then
			;		If ProcessExists($aServerPID) Then
			;		Local $MEM = ProcessGetStats($aServerPID, 0)
			;		LogWrite(" [" & $aServerName & "] Work Memory:" & $MEM[0] & " Peak Memory:" & $MEM[1] & " - Daily restart requested by " & $aUtilName & ".")
			LogWrite(" [" & $aServerName & "] - Daily restart requested by " & $aUtilName & ".")
			If $aDelayShutdownTime Not = 0 Then
				$aBeginDelayedShutdown = 1
				$aRebootReason = "daily"
				$aTimeCheck0 = _NowCalc()
				$aAnnounceCount1 = $aAnnounceCount1 + 1
			Else
				RunExternalScriptDaily()
				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)
			EndIf
			;		EndIf
			$aTimeCheck2 = _NowCalc()
		EndIf
		#EndRegion ;**** Restart Server Every X Days and X Hours & Min****

		If ((_DateDiff('n', $aTimeCheck5, _NowCalc())) >= 1) Then
			For $i = 0 To ($aCustomRCONCount - 1)
				If RCONCustomTimeCheck($xCustomRCONDays[$i], $xCustomRCONHours[$i], $xCustomRCONMinute[$i]) Then
					If $xCustomRCONCmd[$i] <> "" Then
						If $xCustomRCONAllorLocal[$i] = "1" Then
							LogWrite(" [Scheduled Event " & $i & "] Sending RCON command to Local servers: " & $xCustomRCONCmd[$i])
							F_SendRCON("local", $xCustomRCONCmd[$i])
						Else
							LogWrite(" [Scheduled Event " & $i & "] Sending RCON command to ALL servers: " & $xCustomRCONCmd[$i])
							F_SendRCON("all", $xCustomRCONCmd[$i])
						EndIf
					EndIf
					If $xCustomRCONFile <> "" Then
						LogWrite(" [Scheduled Event " & $i & "] Executing file: " & $xCustomRCONFile[$i])
						Run($xCustomRCONFile[$i])
					EndIf
				EndIf
			Next
			$aTimeCheck5 = _NowCalc()
		EndIf

		;	#Region ;**** KeepServerAlive Telnet Check ****
		;	If ($aTelnetCheckYN = "yes") And (_DateDiff('s', $gTelnetTimeCheck0, _NowCalc()) >= $aTelnetCheckSec) Then
		;		$TelnetCheckResult = TelnetCheck($aServerIP, $aTelnetPort, $aTelnetPass)
		;		$gTelnetTimeCheck0 = _NowCalc()
		;		If $TelnetCheckResult = 0 Then
		;			If $xDebug Then
		;				LogWrite(" [" & $aServerName & " (PID: " & $aServerPID & ")] Server not responding to telnet. Restarting server.")
		;			EndIf
		;			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
		;		Else
		;			If $xDebug Then
		;				LogWrite(" [" & $aServerName & " (PID: " & $aServerPID & ")] Server responded to telnet inquiry.")
		;			EndIf
		;		EndIf
		;	EndIf
		;	#EndRegion ;**** KeepServerAlive Telnet Check ****

		#Region ;**** Check for Update every X Minutes ****
		If $aServerModYN = "yes" And ((_DateDiff('n', $aTimeCheck0, _NowCalc())) >= $aUpdateCheckInterval) And ($aBeginDelayedShutdown = 0) Then
			SetStatusBusy("Check: Mod Update")
			CheckMod($aServerModList, $aSteamCMDDir, $aServerDirLocal, 0, False)
			SetStatusIdle()
		EndIf
		If ($aCheckForUpdate = "yes") And ((_DateDiff('n', $aTimeCheck0, _NowCalc())) >= $aUpdateCheckInterval) And ($aBeginDelayedShutdown = 0) Then
			SetStatusBusy("Check: Server Update")
;~ 			Local $bRestart = UpdateCheck(False)
			UpdateCheck(False, 0, False)
			SetStatusIdle()
;~ 			If $bRestart And (($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes")) Then
;~ 				$aBeginDelayedShutdown = 1
;~ 				$aRebootReason = "update"
;~ 			ElseIf $bRestart Then
;~ 				RunExternalScriptUpdate()
			;			SteamcmdDelete($aSteamCMDDir)
;~ 				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
;~ 			EndIf
			$aTimeCheck0 = _NowCalc()
		EndIf
		#EndRegion ;**** Check for Update every X Minutes ****

		#Region ;**** Announce to Twitch, In Game, Discord ****
		If $aDelayShutdownTime Not = 0 Then
			If $aBeginDelayedShutdown = 1 Then
				RunExternalScriptAnnounce()
				If $aRebootReason = "daily" Then
					$aAnnounceCount0 = $aDailyCnt
					$aAnnounceCount1 = $aAnnounceCount0 - 1
					If $aAnnounceCount1 = 0 Then
						;					$aDelayShutdownTime = $aDailyTime[$aAnnounceCount0]
						$aDelayShutdownTime = 0
						$aBeginDelayedShutdown = 3
					Else
						$aDelayShutdownTime = $aDailyTime[$aAnnounceCount0] - $aDailyTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aDailyMsgInGame[$aAnnounceCount0])
					EndIf
					If $sUseDiscordBotDaily = "yes" Then
						SendDiscordMsg($sDiscordWebHookURLs, $aDailyMsgDiscord[$aAnnounceCount0], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotDaily = "yes" Then
						TwitchMsgLog($aDailyMsgTwitch[$aAnnounceCount0])
					EndIf
				EndIf
				If $aRebootReason = "remoterestart" Then
					$aAnnounceCount0 = $aRemoteCnt
					$aAnnounceCount1 = $aAnnounceCount0 - 1
					$aDelayShutdownTime = $aRemoteTime[$aAnnounceCount0] - $aRemoteTime[$aAnnounceCount1] + 1
					If $aAnnounceCount1 = 0 Then
						;					$aDelayShutdownTime = $aRemoteTime[$aAnnounceCount0]
						$aDelayShutdownTime = 0
						$aBeginDelayedShutdown = 3
					Else
						$aDelayShutdownTime = $aRemoteTime[$aAnnounceCount0] - $aRemoteTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aRemoteMsgInGame[$aAnnounceCount0])
					EndIf
					If $sUseDiscordBotRemoteRestart = "yes" Then
						SendDiscordMsg($sDiscordWebHookURLs, $aRemoteMsgDiscord[$aAnnounceCount0], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotRemoteRestart = "yes" Then
						TwitchMsgLog($aRemoteMsgTwitch[$aAnnounceCount0])
					EndIf
				EndIf
				If $aRebootReason = "stopservers" Then
					$aAnnounceCount0 = $aStopServerCnt
					$aAnnounceCount1 = $aAnnounceCount0 - 1
					$aDelayShutdownTime = $aStopServerTime[$aAnnounceCount0] - $aStopServerTime[$aAnnounceCount1] + 1
					If $aAnnounceCount1 = 0 Then
						;					$aDelayShutdownTime = $aRemoteTime[$aAnnounceCount0]
						$aDelayShutdownTime = 0
						$aBeginDelayedShutdown = 3
					Else
						$aDelayShutdownTime = $aStopServerTime[$aAnnounceCount0] - $aStopServerTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aStopServerMsgInGame[$aAnnounceCount0])
					EndIf
					If $sUseDiscordBotStopServer = "yes" Then
						SendDiscordMsg($sDiscordWebHookURLs, $aStopServerMsgDiscord[$aAnnounceCount0], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotStopServer = "yes" Then
						TwitchMsgLog($aStopServerMsgTwitch[$aAnnounceCount0])
					EndIf
				EndIf
				If $aRebootReason = "update" Then
					$aAnnounceCount0 = $aUpdateCnt
					$aAnnounceCount1 = $aAnnounceCount0 - 1
					$aDelayShutdownTime = $aUpdateTime[$aAnnounceCount0] - $aUpdateTime[$aAnnounceCount1] + 1
					If $aAnnounceCount1 = 0 Then
						$aDelayShutdownTime = 0
						$aBeginDelayedShutdown = 3
					Else
						$aDelayShutdownTime = $aUpdateTime[$aAnnounceCount0] - $aUpdateTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aUpdateMsgInGame[$aAnnounceCount0])
					EndIf
					If $sUseDiscordBotUpdate = "yes" Then
						SendDiscordMsg($sDiscordWebHookURLs, $aUpdateMsgDiscord[$aAnnounceCount0], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotUpdate = "yes" Then
						TwitchMsgLog($aUpdateMsgTwitch[$aAnnounceCount0])
					EndIf
				EndIf
				If $aRebootReason = "mod" Then
					$aAnnounceCount0 = $aModCnt
					$aAnnounceCount1 = $aAnnounceCount0 - 1
					$aDelayShutdownTime = $aModTime[$aAnnounceCount0] - $aModTime[$aAnnounceCount1] + 1
					If $aAnnounceCount1 = 0 Then
						$aDelayShutdownTime = 0
						$aBeginDelayedShutdown = 3
					Else
						$aDelayShutdownTime = $aModTime[$aAnnounceCount0] - $aModTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aModMsgInGame[$aAnnounceCount0])
					EndIf
					If $sUseDiscordBotUpdate = "yes" Then
						SendDiscordMsg($sDiscordWebHookURLs, $aModMsgDiscord[$aAnnounceCount0], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotUpdate = "yes" Then
						TwitchMsgLog($aModMsgTwitch[$aAnnounceCount0])
					EndIf
				EndIf
				$aBeginDelayedShutdown = 2
				$aTimeCheck0 = _NowCalc()

			ElseIf ($aBeginDelayedShutdown > 2 And ((_DateDiff('n', $aTimeCheck0, _NowCalc())) >= $aDelayShutdownTime)) Then ; **** REBOOT SERVER ****

				$aBeginDelayedShutdown = 0
				$aTimeCheck0 = _NowCalc()
				If $aRebootReason = "daily" Then
					SplashTextOn($aUtilName & ": " & $aServerName, "Daily server requested. Restarting server . . .", 350, 50, -1, -1, $DLG_MOVEABLE, "")
					RunExternalScriptDaily()
				EndIf
				If $aRebootReason = "update" Then
					SplashTextOn($aUtilName & ": " & $aServerName, "New server update. Restarting server . . .", 350, 50, -1, -1, $DLG_MOVEABLE, "")
					RunExternalScriptUpdate()
				EndIf
				If $aRebootReason = "remoterestart" Then
					SplashTextOn($aUtilName & ": " & $aServerName, "Remote Restart requested. Restarting server . . .", 350, 50, -1, -1, $DLG_MOVEABLE, "")
					RunExternalRemoteRestart()
				EndIf
				If $aRebootReason = "stopservers" Then
					SplashTextOn($aUtilName & ": " & $aServerName, "Stop Servers requested. " & @CRLF & "Shutting down " & $tSelectServersTxt & "servers.", 450, 80, -1, -1, $DLG_MOVEABLE, "")
				EndIf
				If $sInGameAnnounce = "yes" Then
					SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $sInGame10SecondMessage)
					Sleep(10000)
				EndIf
;~ 				If $aRebootReason = "stopservers" Then
				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)

			ElseIf ($aBeginDelayedShutdown = 2) And (_DateDiff('n', $aTimeCheck0, _NowCalc()) >= $aDelayShutdownTime) Then ; **** REPEAT ANNOUNCEMENTS UNTIL LAST COUNT ***

				If $aRebootReason = "daily" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = $aDailyTime[$aAnnounceCount1] - $aDailyTime[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = $aDailyTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aDailyMsgInGame[$aAnnounceCount1])
					EndIf
					If $sUseDiscordBotDaily = "yes" And ($sUseDiscordBotFirstAnnouncement = "no") Then
						SendDiscordMsg($sDiscordWebHookURLs, $aDailyMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotDaily = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						TwitchMsgLog($aDailyMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf
				If $aRebootReason = "remoterestart" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = $aRemoteTime[$aAnnounceCount1] - $aRemoteTime[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = $aRemoteTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aRemoteMsgInGame[$aAnnounceCount1])
					EndIf
					If ($sUseDiscordBotRemoteRestart = "yes") And ($sUseDiscordBotFirstAnnouncement = "no") Then
						SendDiscordMsg($sDiscordWebHookURLs, $aRemoteMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotRemoteRestart = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						TwitchMsgLog($aRemoteMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf
				If $aRebootReason = "stopservers" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = $aStopServerTime[$aAnnounceCount1] - $aStopServerTime[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = $aStopServerTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aStopServerMsgInGame[$aAnnounceCount1])
					EndIf
					If ($sUseDiscordBotStopServer = "yes") And ($sUseDiscordBotFirstAnnouncement = "no") Then
						SendDiscordMsg($sDiscordWebHookURLs, $aStopServerMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotStopServer = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						TwitchMsgLog($aStopServerMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf
				If $aRebootReason = "update" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = $aUpdateTime[$aAnnounceCount1] - $aUpdateTime[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = $aUpdateTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aUpdateMsgInGame[$aAnnounceCount1])
					EndIf
					If $sUseDiscordBotUpdate = "yes" And ($sUseDiscordBotFirstAnnouncement = "no") Then
						SendDiscordMsg($sDiscordWebHookURLs, $aUpdateMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotUpdate = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						TwitchMsgLog($aUpdateMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf
				If $aRebootReason = "mod" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = $aModTime[$aAnnounceCount1] - $aModTime[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = $aModTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aModMsgInGame[$aAnnounceCount1])
					EndIf
					If $sUseDiscordBotUpdate = "yes" And ($sUseDiscordBotFirstAnnouncement = "no") Then
						SendDiscordMsg($sDiscordWebHookURLs, $aModMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotUpdate = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						TwitchMsgLog($aModMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf

				$aAnnounceCount1 = $aAnnounceCount1 - 1
				If $aAnnounceCount1 = 0 Then
					$aBeginDelayedShutdown = 3
				EndIf
				$aTimeCheck0 = _NowCalc()
			EndIf
		Else
			$aBeginDelayedShutdown = 0
		EndIf
		#EndRegion ;**** Announce to Twitch, In Game, Discord ****

		;		#Region ;**** Rotate Logs ****
		;		If (_DateDiff('h', $aTimeCheck4, _NowCalc()) >= 1) Then
		;			If Not FileExists($aLogFile) Then
		;				FileWriteLine($aLogFile, $aTimeCheck4 & " Log File Created")
		;				FileSetTime($aLogFile, @YEAR & @MON & @MDAY, 1)
		;			EndIf
		;			Local $aLogFileTime = FileGetTime($aLogFile, 1)
		;			Local $logTimeSinceCreation = _DateDiff('h', $aLogFileTime[0] & "/" & $aLogFileTime[1] & "/" & $aLogFileTime[2] & " " & $aLogFileTime[3] & ":" & $aLogFileTime[4] & ":" & $aLogFileTime[5], _NowCalc())
		;			If $logTimeSinceCreation >= $aLogHoursBetweenRotate Then
		;				RotateFile($aLogFile, $aLogQuantity)
		;			EndIf
		;			$aTimeCheck4 = _NowCalc()
		;		EndIf
		;		#EndRegion ;**** Rotate Logs ****
		$aServerCheck = TimerInit()
		SetStatusIdle()
	EndIf
	Sleep(100)
WEnd

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Define GUI Functions
Func GUI_Main_Close()
	GUISetState(@SW_HIDE, $wGUIMainWindow)
	;	GUIDelete($MainWindow)
	$aShowGUI = False
	$aGUIMainActive = False
	TrayItemSetState($iTrayShowGUI, $TRAY_ENABLE)
EndFunc   ;==>GUI_Main_Close
Func GUI_Main_B_ServerInfo()
	WizardSelect()
;~ 	LogWindow(4)
EndFunc   ;==>GUI_Main_B_ServerInfo
Func GUI_Main_B_Players()
	F_ShowPlayerCount()
EndFunc   ;==>GUI_Main_B_Players
Func GUI_Main_B_Config()
	ConfigEdit()
;~ 	LogWindow(5)
EndFunc   ;==>GUI_Main_B_Config
Func GUI_Main_B_LogFile()
	LogWindow(1)
EndFunc   ;==>GUI_Main_B_LogFile
Func GUI_Main_B_ExitShutDownY()
	F_ExitCloseY()
EndFunc   ;==>GUI_Main_B_ExitShutDownY
Func GUI_Main_B_ExitShutDownN()
	F_ExitCloseN()
EndFunc   ;==>GUI_Main_B_ExitShutDownN
Func GUI_Main_I_DiscordServer()
	F_DiscordServer()
EndFunc   ;==>GUI_Main_I_DiscordServer
Func GUI_Main_I_DiscussionForum()
	F_DiscussionForum()
EndFunc   ;==>GUI_Main_I_DiscussionForum
Func GUI_Main_I_Help()
	F_Help()
EndFunc   ;==>GUI_Main_I_Help
Func GUI_Main_I_MainWebpage()
	F_MainWebpage()
EndFunc   ;==>GUI_Main_I_MainWebpage
Func GUI_Main_I_About()
	F_About()
EndFunc   ;==>GUI_Main_I_About
Func GUI_Main_I_Pause()
	F_UpdateUtilPause()
EndFunc   ;==>GUI_Main_I_Pause
Func GUI_Main_I_CheckForUtilUpdates()
	F_UpdateUtilCheck()
EndFunc   ;==>GUI_Main_I_CheckForUtilUpdates
Func GUI_Main_I_UtilConfig()
	LogWindow(5)
EndFunc   ;==>GUI_Main_I_UtilConfig
Func GUI_Main_B_ModUpdates()
	F_ModUpdate()
EndFunc   ;==>GUI_Main_B_ModUpdates
Func GUI_Main_B_UpdateGame()
	F_UpdateServCheck()
EndFunc   ;==>GUI_Main_B_UpdateGame
Func GUI_Main_B_UpdateUtil()
	F_UpdateUtilCheck()
EndFunc   ;==>GUI_Main_B_UpdateUtil
Func GUI_Main_B_AllRmtRestart()
	F_RemoteRestart()
EndFunc   ;==>GUI_Main_B_AllRmtRestart
Func GUI_Main_B_AllRestartNow()
	F_RestartNow()
EndFunc   ;==>GUI_Main_B_AllRestartNow
Func GUI_Main_B_StopServerAll()
	F_StopServer()
EndFunc   ;==>GUI_Main_B_StopServerAll
Func GUI_Main_B_AllSendRCON()
	F_SendRCON("all")
EndFunc   ;==>GUI_Main_B_AllSendRCON
Func GUI_Main_B_AllSendMsg()
	F_SendMessage("all")
EndFunc   ;==>GUI_Main_B_AllSendMsg
Func GUI_Main_B_SelectSendRCON()
	F_SendRCON("sel")
EndFunc   ;==>GUI_Main_B_SelectSendRCON
Func GUI_Main_B_SelectSendMsg()
	F_SendMessage("sel")
EndFunc   ;==>GUI_Main_B_SelectSendMsg
Func GUI_Main_B_SelectStartServers()
	SelectServersStart()
EndFunc   ;==>GUI_Main_B_SelectStartServers
Func GUI_Main_B_SelectStopServers()
	SelectServersStop()
EndFunc   ;==>GUI_Main_B_SelectStopServers
Func GUI_Main_CB_PollRemoteServers()
EndFunc   ;==>GUI_Main_CB_PollRemoteServers
Func GUI_Main_CB_PollOnlinePlayers()
EndFunc   ;==>GUI_Main_CB_PollOnlinePlayers
;Func GUI_Main_S_UpdateIntervalSlider()
;EndFunc
Func GUI_Main_E_UpdateIntervalEdit()
EndFunc   ;==>GUI_Main_E_UpdateIntervalEdit
Func GUI_OnlinePlayers_Close()
	GUIDelete($gOnlinePlayerWindow)
	$aPlayerCountWindowTF = False
	$aPlayerCountShowTF = False
	GUICtrlSetState($Players, $GUI_ENABLE)
	TrayItemSetState($iTrayPlayerCount, $TRAY_ENABLE)
EndFunc   ;==>GUI_OnlinePlayers_Close
Func Tray_ShowGUI()
	$aShowGUI = True
	$aGUIMainActive = False
	GUISetState(@SW_SHOWNORMAL, $wGUIMainWindow)
	;	ShowMainGUI()
EndFunc   ;==>Tray_ShowGUI
Func Tray_ShowConfig()
	Run("notepad.exe " & $aIniFile)
EndFunc   ;==>Tray_ShowConfig
Func Tray_About()
	F_About()
EndFunc   ;==>Tray_About
Func Tray_UtilUpdate()
	F_UpdateUtilCheck()
EndFunc   ;==>Tray_UtilUpdate
Func Tray_PauseUtil()
	F_UpdateUtilPause()
EndFunc   ;==>Tray_PauseUtil
Func Tray_AllSendMsg()
	F_SendMessage()
EndFunc   ;==>Tray_AllSendMsg
Func Tray_AllSendRCON()
	F_SendRCON("all")
EndFunc   ;==>Tray_AllSendRCON
Func Tray_ShowOnlinePlayers()
	F_ShowPlayerCount()
EndFunc   ;==>Tray_ShowOnlinePlayers
Func Tray_OnlinePlayersCheckDisable()
	TrayShowPlayerCheckPause()
EndFunc   ;==>Tray_OnlinePlayersCheckDisable
Func Tray_OnlinePlayersCheckEnable()
	TrayShowPlayerCheckUnPause()
EndFunc   ;==>Tray_OnlinePlayersCheckEnable
Func Tray_ServerUpdateCheck()
	F_UpdateServCheck()
EndFunc   ;==>Tray_ServerUpdateCheck
Func Tray_ServerUpdateDisable()
	TrayUpdateServPause()
EndFunc   ;==>Tray_ServerUpdateDisable
Func Tray_ServerUpdateEnable()
	TrayUpdateServUnPause()
EndFunc   ;==>Tray_ServerUpdateEnable
Func Tray_RemoteRestart()
	F_RemoteRestart()
EndFunc   ;==>Tray_RemoteRestart
Func Tray_RestartServersNow()
	F_RestartNow()
EndFunc   ;==>Tray_RestartServersNow
Func Tray_ExitShutDownN()
	F_ExitCloseN()
EndFunc   ;==>Tray_ExitShutDownN
Func Tray_ExitShutDownY()
	F_ExitCloseY()
EndFunc   ;==>Tray_ExitShutDownY
Func GUI_Log_Close()
;~ 	GUISetState(@SW_HIDE, $LogWindow)
	GUIDelete($LogWindow)
EndFunc   ;==>GUI_Log_Close
Func GUI_Log_Basic_B_Button()
	Local $i = @GUI_CtrlId - $lBasicBDay[0]
	Local $tFileName = $aFolderLog & $aUtilName & "_Log_" & StringRegExpReplace($lBasicDDate[$i], "/", "-") & ".txt"
	Local $tFileOpen = FileOpen($tFileName)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	If $tTxt = "" Then
		$tTxt = "[No file found]"
		For $i = 0 To 50
			$tTxt &= @CRLF
		Next
	EndIf
	_GUICtrlRichEdit_SetText($lBasicEdit, $tTxt)
	_GUICtrlRichEdit_SetText($lBasicEdit, $tTxt)
EndFunc   ;==>GUI_Log_Basic_B_Button
Func GUI_Log_Detailed_B_Button()
	Local $i = @GUI_CtrlId - $lDetailedBDay[0]
	Local $tFileName = $aFolderLog & $aUtilName & "_LogFull_" & StringRegExpReplace($lDetailedDDate[$i], "/", "-") & ".txt"
	Local $tFileOpen = FileOpen($tFileName)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	If $tTxt = "" Then
		$tTxt = "[No file found]"
		For $i = 0 To 50
			$tTxt &= @CRLF
		Next
	EndIf
	_GUICtrlRichEdit_SetText($lDetailedEdit, $tTxt)
	_GUICtrlRichEdit_SetText($lDetailedEdit, $tTxt)
EndFunc   ;==>GUI_Log_Detailed_B_Button
Func GUI_Log_OnlinePlayers_B_Button()
	Local $i = @GUI_CtrlId - $lOnlinePlayersBDay[0]
	Local $tFileName = $aFolderLog & $aUtilName & "_OnlineUserLog_" & StringRegExpReplace($lOnlinePlayersDDate[$i], "/", "-") & ".txt"
	Local $tFileOpen = FileOpen($tFileName)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	If $tTxt = "" Then
		$tTxt = "[No file found]"
		For $i = 0 To 50
			$tTxt &= @CRLF
		Next
	EndIf
	_GUICtrlRichEdit_SetText($lOnlinePlayersEdit, $tTxt)
	_GUICtrlRichEdit_SetText($lOnlinePlayersEdit, $tTxt)
EndFunc   ;==>GUI_Log_OnlinePlayers_B_Button
Func GUI_Log_ServerSummary_B_Button()
	MakeServerSummaryFile($aServerSummaryFile)
	Local $tFileOpen = FileOpen($aServerSummaryFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	_GUICtrlRichEdit_SetText($lServerSummaryEdit, $tTxt)
	SetFont($lServerSummaryEdit, $fFWFixedFont)
EndFunc   ;==>GUI_Log_ServerSummary_B_Button
Func GUI_Log_Config_B_Save()
;~ 	Local $tTxt = GUICtrlRead($lConfigEdit)
	Local $tTxt = ReplaceCRwithCRLF(_GUICtrlRichEdit_GetText($lConfigEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aIniFile & "_" & $tTime & ".bak"
	FileMove($aIniFile, $tFile, 1)
	FileWrite($aIniFile, $tTxt)
	SplashTextOn($aUtilName, $aUtilName & ".ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "_" & $tTime & ".bak", 475, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_Config_B_Save
Func GUI_Log_Config_B_Reset()
	Local $tFileOpen = FileOpen($aIniFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	_GUICtrlRichEdit_SetText($lConfigEdit, $tTxt)
	SetFont($lConfigEdit, $fFWFixedFont)
EndFunc   ;==>GUI_Log_Config_B_Reset
Func GUI_Log_GridSelect_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(_GUICtrlRichEdit_GetText($lGridSelectEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
	FileMove($aGridSelectFile, $tFile, 1)
	FileWrite($aGridSelectFile, $tTxt)
	SplashTextOn($aUtilName, $aUtilName & "GridStartSelect.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "GridStartSelect.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_GridSelect_B_Save
Func GUI_Log_GridSelect_B_Reset()
	Local $tFileOpen = FileOpen($aGridSelectFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	_GUICtrlRichEdit_SetText($lGridSelectEdit, $tTxt)
	SetFont($lGridSelectEdit, $fFWFixedFont)
EndFunc   ;==>GUI_Log_GridSelect_B_Reset
Func GUI_Log_ServerGrid_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(_GUICtrlRichEdit_GetText($lServerGridEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aConfigFull & "_" & $tTime & ".bak"
	FileMove($aConfigFull, $tFile, 1)
	FileWrite($aConfigFull, $tTxt)
	SplashTextOn($aUtilName, $aConfigFile & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aConfigFile & "_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_ServerGrid_B_Save
Func GUI_Log_ServerGrid_B_Reset()
	Local $tFileOpen = FileOpen($aConfigFull)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	_GUICtrlRichEdit_SetText($lServerGridEdit, $tTxt)
	SetFont($lServerGridEdit, $fFWFixedFont)
EndFunc   ;==>GUI_Log_ServerGrid_B_Reset
Func GUI_Log_DefaultGame_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(_GUICtrlRichEdit_GetText($lDefaultGameEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aDefaultGame & "_" & $tTime & ".bak"
	FileMove($aDefaultGame, $tFile, 1)
	FileWrite($aDefaultGame, $tTxt)
	SplashTextOn($aUtilName, "DefaultGame.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & "DefaultGame.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_DefaultGame_B_Save
Func GUI_Log_DefaultGame_B_Reset()
	Local $tFileOpen = FileOpen($aDefaultGame)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	_GUICtrlRichEdit_SetText($lDefaultGameEdit, $tTxt)
	SetFont($lDefaultGameEdit, $fFWFixedFont)
EndFunc   ;==>GUI_Log_DefaultGame_B_Reset
Func GUI_Log_DefaultGUS_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(_GUICtrlRichEdit_GetText($lDefaultGUSEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aDefaultGUS & "_" & $tTime & ".bak"
	FileMove($aDefaultGUS, $tFile, 1)
	FileWrite($aDefaultGUS, $tTxt)
	SplashTextOn($aUtilName, "DefaultGameUserSettings.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & "DefaultGameUserSettings.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_DefaultGUS_B_Save
Func GUI_Log_DefaultGUS_B_Reset()
	Local $tFileOpen = FileOpen($aDefaultGUS)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	_GUICtrlRichEdit_SetText($lDefaultGUSEdit, $tTxt)
	SetFont($lDefaultGUSEdit, $fFWFixedFont)
EndFunc   ;==>GUI_Log_DefaultGUS_B_Reset
Func GUI_Log_DefaultEngine_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(_GUICtrlRichEdit_GetText($lDefaultEngineEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aDefaultEngine & "_" & $tTime & ".bak"
	FileMove($aDefaultEngine, $tFile, 1)
	FileWrite($aDefaultEngine, $tTxt)
	SplashTextOn($aUtilName, "DefaultEngine.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & "DefaultEngine.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_DefaultEngine_B_Save
Func GUI_Log_DefaultEngine_B_Reset()
	Local $tFileOpen = FileOpen($aDefaultEngine)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	_GUICtrlRichEdit_SetText($lDefaultEngineEdit, $tTxt)
	SetFont($lDefaultEngineEdit, $fFWFixedFont)
EndFunc   ;==>GUI_Log_DefaultEngine_B_Reset

Func SetFont($tID, $tFont, $tSize = 9)
	_GUICtrlRichEdit_SetSel($tID, 0, -1) ; select all
	_GUICtrlRichEdit_SetFont($tID, $tSize, $tFont)
	ControlSend("", "", $tID, "^+{Home}")
	ControlSend("", "", $tID, "^+{Home}")
EndFunc   ;==>SetFont

#EndRegion ;**** Define GUI Functions

; -----------------------------------------------------------------------------------------------------------------------

Func F_DiscordServer()
	Run(@ComSpec & " /c " & "start http://discord.gg/EU7pzPs", "")
EndFunc   ;==>F_DiscordServer
Func F_DiscussionForum()
	Run(@ComSpec & " /c " & "start http://phoenix125.createaforum.com/index.php", "")
EndFunc   ;==>F_DiscussionForum
Func F_Help()
	Run(@ComSpec & " /c " & "start http://www.phoenix125.com/AtlasHelp.html", "")
EndFunc   ;==>F_Help
Func F_MainWebpage()
	Run(@ComSpec & " /c " & "start " & $aWebsite, "")
EndFunc   ;==>F_MainWebpage
Func F_About()
	MsgBox($MB_SYSTEMMODAL, $aUtilName, $aUtilName & @CRLF & "Version: " & $aUtilVersion & @CRLF & @CRLF & "Install Path: " & @ScriptDir & @CRLF & @CRLF & "Discord: http://discord.gg/EU7pzPs" & @CRLF & "Website: http://www.phoenix125.com", 15)
EndFunc   ;==>F_About
Func F_ModUpdate()
;~ 	$aFirstModCheck = True
	SetStatusBusy("Check: Mod Update")
	CheckMod($aServerModList, $aSteamCMDDir, $aServerDirLocal, 0, True)
	SetStatusIdle()
	SplashOff()
EndFunc   ;==>F_ModUpdate

#Region ;**** INI Settings - User Variables ****

Func ReadUini($sIniFile, $sLogFile, $tUseWizard = False)
	Global $iIniError = ""
	Global $iIniFail = 0
	$iIniRead = True
	Local $iniCheck = ""
	Local $aChar[3]
	For $i = 1 To 13
		$aChar[0] = Chr(Random(97, 122, 1)) ;a-z
		$aChar[1] = Chr(Random(48, 57, 1)) ;0-9
		$iniCheck &= $aChar[Random(0, 1, 1)]
	Next
	;	Global $aServerName = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server name (for announcements and logs only) ###", $iniCheck)
	Global $aServerDirLocal = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " DIR ###", $iniCheck)
	;Global $aServerVer = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Version (0-Stable,1-Experimental) ###", $iniCheck)
	Global $aServerExtraCMD = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " extra commandline parameters (ex.?serverpve-pve -NoCrashDialog) ###", $iniCheck)
	;	Global $aServerIP = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server IP ###", $iniCheck)
	Global $aServerMultiHomeIP = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server multi-home IP (Leave blank to disable) ###", $iniCheck)
	;	Global $aSteamCMDDir = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD DIR ###", $iniCheck)
	Global $aSteamExtraCMD = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD extra commandline parameters (ex. -latest_experimental) ###", $iniCheck)
	;Global $aServerSaveDir = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Gamesave directory name ###", $iniCheck)
	Global $aServerMinimizedYN = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Start servers minimized (for a cleaner look)? (yes/no) ###", $iniCheck)
	Global $aServerAdminPass = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Admin password ###", $iniCheck)
	Global $aServerMaxPlayers = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Max players ###", $iniCheck)
	Global $aServerReservedSlots = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Reserved slots ###", $iniCheck)
	Global $aServerRCONImport = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Import RCON ports from GameUserSettings.ini files? (yes/no) ###", $iniCheck)
	Global $aServerRCONIP = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "RCON IP (ex. 127.0.0.1 - Leave BLANK for server IP) ###", $iniCheck)
	Global $aServerRCONPort = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server RCON Port(s) (comma separated, grid order as in ServerGrid.json, ignore if importing RCON ports) ###", $iniCheck)
	Global $aServerAltSaveSelect = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", $iniCheck)
	Global $aServerAltSaveDir = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames (Use same order as listed in ServerGrid.json. Comma separated) ###", $iniCheck)
	Global $aServerModYN = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Use this util to install mods and check for mod updates (as listed in ServerGrid.json)? (yes/no) ###", $iniCheck)
	;	Global $aServerModList = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Mod number(s) (comma separated) ###", $iniCheck)
	Global $aServerOnlinePlayerYN = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for, and log, online players? (yes/no) ###", $iniCheck)
	Global $aServerOnlinePlayerSec = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for online players every _ seconds (30-600) ###", $iniCheck)
	Global $aPollRemoteServersYN = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for online players on remote servers? (yes/no) ###", $iniCheck)

	;	Global $aServerOnlinePlayerWidth = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Online Players window width (250-800) ###", $iniCheck)
	Global $aServerUseRedis = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Autostart and keep-alive redis-server.exe? Use NO to manage redis-server.exe yourself (yes/no) ###", $iniCheck)
	Global $aServerRedisConfig = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Redis-server config file (Not used if autostart is NO above) ###", $iniCheck)
	Global $aServerRedisFolder = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Redis-server.exe and config DIR (Not used if autostart is NO above) Leave BLANK for default DIR ###", $iniCheck)
	Global $aServerStartDelay = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Delay in seconds between grid server starts (0-600) ###", $iniCheck)
	Global $aServerShutdownDelay = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Delay in seconds between grid server shutdowns (0-600) ###", $iniCheck)
	Global $aShutDnWait = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Seconds allowed for GameSave before taskkilling servers during reboots (10-600) ###", $iniCheck)
	;
	Global $aCheckForUpdate = IniRead($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Check for server updates? (yes/no) ###", $iniCheck)
	Global $aUpdateCheckInterval = IniRead($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Update check interval in Minutes (05-59) ###", $iniCheck)
	;
	Global $aCustomRCONCount = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND COUNT --------------- ", "Number of custom RCON Commands to schedule (If changed, util will restart and new custom entries will be added) ###", $iniCheck)
	Global $xCustomRCONCmd[$aCustomRCONCount], $xCustomRCONDays[$aCustomRCONCount], $xCustomRCONHours[$aCustomRCONCount], $xCustomRCONMinute[$aCustomRCONCount], $xCustomRCONAllorLocal[$aCustomRCONCount], $xCustomRCONFile[$aCustomRCONCount]
	For $i = 0 To ($aCustomRCONCount - 1)
		$xCustomRCONCmd[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command to send (leave BLANK to skip) ###", $iniCheck)
		$xCustomRCONAllorLocal[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command send to (0) ALL grids or (1) Local Grids Only ###", $iniCheck)
		$xCustomRCONFile[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-File to Execute (leave BLANK to skip) ###", $iniCheck)
		$xCustomRCONDays[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $iniCheck)
		$xCustomRCONHours[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event hours (comma separated 00-23 ex.04,16) ###", $iniCheck)
		$xCustomRCONMinute[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event minute (00-59) ###", $iniCheck)
	Next
	;
	Global $aDestroyWildDinosYN = IniRead($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos? (yes/no) ###", $iniCheck)
	Global $aDestroyWildDinosDays = IniRead($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $iniCheck)
	Global $aDestroyWildDinosHours = IniRead($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos hours (comma separated 00-23 ex.04,16) ###", $iniCheck)

	;Global $aTelnetCheckYN = IniRead($sIniFile, " --------------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE --------------- ", "Use RCON/telnet to check if server is alive? (yes/no) ###", $iniCheck)
	;Global $aTelnetCheckSec = IniRead($sIniFile, " --------------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE --------------- ", "RCON/Telnet check interval in seconds (30-900) ###", $iniCheck)
	;Global $aTelnetPort = IniRead($sIniFile, " --------------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE --------------- ", "RCON/Telnet port ###", $iniCheck)
	;Global $aTelnetPass = IniRead($sIniFile, " --------------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE --------------- ", "RCON/Telnet password ###", $iniCheck)
	;
	;	Global $aExMemRestart = IniRead($sIniFile, " --------------- RESTART ON EXCESSIVE MEMORY USE --------------- ", "Restart on excessive memory use? (yes/no) ###", $iniCheck)
	;	Global $aExMemAmt = IniRead($sIniFile, " --------------- RESTART ON EXCESSIVE MEMORY USE --------------- ", "Excessive memory amount? ###", $iniCheck)
	;
	Global $aRemoteRestartUse = IniRead($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Use Remote Restart? (yes/no) ###", $iniCheck)
	Global $aRemoteRestartIP = IniRead($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Server Local IP (ex. 192.168.1.10) ###", $iniCheck)
	Global $aRemoteRestartPort = IniRead($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Restart Port ###", $iniCheck)
	Global $aRemoteRestartKey = IniRead($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Restart Key ###", $iniCheck)
	Global $aRemoteRestartCode = IniRead($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Restart Code ###", $iniCheck)
	;
	Global $aRestartDaily = IniRead($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Use scheduled restarts? (yes/no) ###", $iniCheck)
	Global $aRestartDays = IniRead($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $iniCheck)
	Global $bRestartHours = IniRead($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart hours (comma separated 00-23 ex.04,16) ###", $iniCheck)
	Global $bRestartMin = IniRead($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart minute (00-59) ###", $iniCheck)
	;
	Global $sAnnounceNotifyDaily = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before DAILY reboot (comma separated 0-60) ###", $iniCheck)
	Global $sAnnounceNotifyUpdate = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before UPDATES reboot (comma separated 0-60) ###", $iniCheck)
	Global $sAnnounceNotifyRemote = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before REMOTE RESTART reboot (comma separated 0-60) ###", $iniCheck)
	Global $sAnnounceNotifyStopServer = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before STOP SERVER (comma separated 0-60) ###", $iniCheck)
	Global $sAnnounceNotifyModUpdate = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before MOD UPDATE reboot (comma separated 0-60) ###", $iniCheck)
	;
	Global $sInGameAnnounce = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires telnet) (yes/no) ###", $iniCheck)
	Global $sInGameDailyMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement DAILY (\m - minutes) ###", $iniCheck)
	Global $sInGameUpdateMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $iniCheck)
	Global $sInGameRemoteRestartMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $iniCheck)
	Global $sInGameStopServerMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement STOP SERVER (\m - minutes) ###", $iniCheck)
	Global $sInGameModUpdateMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement MOD UPDATE (\m - minutes, \x - Mod ID) ###", $iniCheck)
	Global $sInGame10SecondMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement 10 seconds before reboot ###", $iniCheck)
	;
	Global $sUseDiscordBotDaily = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for DAILY reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotUpdate = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for UPDATE reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotRemoteRestart = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for REMOTE RESTART reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotStopServer = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for STOP SERVER? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotModUpdate = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for MOD UPDATE reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotServersUpYN = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message when all servers are back online (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotFirstAnnouncement = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for first ANNOUNCEMENT only? (reduces bot spam)(yes/no) ###", $iniCheck)
	;Global $sUseDiscordBotAppendServer - IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Append server name to beginning of messages? (yes/no) ###", $iniCheck)
	Global $sDiscordDailyMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $iniCheck)
	Global $sDiscordUpdateMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $iniCheck)
	Global $sDiscordRemoteRestartMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $iniCheck)
	Global $sDiscordStopServerMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement STOP SERVER (\m - minutes) ###", $iniCheck)
	Global $sDiscordModUpdateMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement MOD UPDATE (\m - minutes, \x - Mod ID) ###", $iniCheck)
	Global $sDiscordServersUpMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement Servers back online ###", $iniCheck)
	Global $sDiscordWebHookURLs = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "WebHook URL ###", $iniCheck)
	Global $sDiscordBotName = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Bot Name ###", $iniCheck)
	Global $bDiscordBotUseTTS = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Use TTS? (yes/no) ###", $iniCheck)
	Global $sDiscordBotAvatar = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Bot Avatar Link ###", $iniCheck)
	;
	Global $sUseTwitchBotDaily = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for DAILY reboot? (yes/no) ###", $iniCheck)
	Global $sUseTwitchBotUpdate = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for UPDATE reboot? (yes/no) ###", $iniCheck)
	Global $sUseTwitchBotRemoteRestart = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for REMOTE RESTART reboot? (yes/no) ###", $iniCheck)
	Global $sUseTwitchBotStopServer = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for STOP SERVER? (yes/no) ###", $iniCheck)
	Global $sUseTwitchBotModUpdate = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for MOD UPDATE reboot? (yes/no) ###", $iniCheck)
	Global $sUseTwitchFirstAnnouncement = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for first announcement only? (reduces bot spam)(yes/no) ###", $iniCheck)
	Global $sTwitchDailyMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $iniCheck)
	Global $sTwitchUpdateMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $iniCheck)
	Global $sTwitchRemoteRestartMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $iniCheck)
	Global $sTwitchStopServerMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement STOP SERVER (\m - minutes) ###", $iniCheck)
	Global $sTwitchModUpdateMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement MOD UPDATE (\m - minutes, \x - Mod ID) ###", $iniCheck)
	Global $sTwitchNick = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Nick ###", $iniCheck)
	Global $sChatOAuth = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "ChatOAuth ###", $iniCheck)
	Global $sTwitchChannels = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Channels ###", $iniCheck)
	;
	Global $aExecuteExternalScript = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Execute external script BEFORE update? (yes/no) ###", $iniCheck)
	Global $aExternalScriptDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Script directory ###", $iniCheck)
	Global $aExternalScriptName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Script filename ###", $iniCheck)
	Global $aExternalScriptWait = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Wait for script to complete before continuing? (yes/no) ###", $iniCheck)
	;
	Global $aExternalScriptValidateYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Execute external script AFTER update but BEFORE server start? (yes/no) ###", $iniCheck)
	Global $aExternalScriptValidateDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Script directory ###", $iniCheck)
	Global $aExternalScriptValidateName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Script filename ###", $iniCheck)
	Global $aExternalScriptValidateWait = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Wait for script to complete before continuing? (yes/no) ###", $iniCheck)
	;
	Global $aExternalScriptUpdateYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Execute external script for server update restarts? (yes/no) ###", $iniCheck)
	Global $aExternalScriptUpdateDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Script directory ###", $iniCheck)
	Global $aExternalScriptUpdateFileName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Script filename ###", $iniCheck)
	Global $aExternalScriptUpdateWait = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Wait for script to complete before continuing? (yes/no) ###", $iniCheck)
	;
	Global $aExternalScriptDailyYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Execute external script for daily server restarts? (yes/no) ###", $iniCheck)
	Global $aExternalScriptDailyDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Script directory ###", $iniCheck)
	Global $aExternalScriptDailyFileName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Script filename ###", $iniCheck)
	Global $aExternalScriptDailyWait = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Wait for script to complete before continuing? (yes/no) ###", $iniCheck)
	;
	Global $aExternalScriptAnnounceYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Execute external script when first restart announcement is made? (yes/no) ###", $iniCheck)
	Global $aExternalScriptAnnounceDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Script directory ###", $iniCheck)
	Global $aExternalScriptAnnounceFileName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Script filename ###", $iniCheck)
	Global $aExternalScriptAnnounceWait = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Wait for script to complete before continuing? (yes/no) ###", $iniCheck)
	;
	Global $aExternalScriptRemoteYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Execute external script during restart when a remote restart request is made? (yes/no) ###", $iniCheck)
	Global $aExternalScriptRemoteDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Script directory ###", $iniCheck)
	Global $aExternalScriptRemoteFileName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Script filename ###", $iniCheck)
	Global $aExternalScriptRemoteWait = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Wait for script to complete before continuing? (yes/no) ###", $iniCheck)
	;
	Global $aExternalScriptModYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *MOD UPDATE* SERVER RESTART --------------- ", "7-Execute external script when mod update required (prior to server shutdown)? (yes/no) ###", $iniCheck)
	Global $aExternalScriptModDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *MOD UPDATE* SERVER RESTART --------------- ", "7-Script directory ###", $iniCheck)
	Global $aExternalScriptModFileName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *MOD UPDATE* SERVER RESTART --------------- ", "7-Script filename ###", $iniCheck)
	Global $aExternalScriptModWait = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *MOD UPDATE* SERVER RESTART --------------- ", "7-Wait for script to complete before continuing? (yes/no) ###", $iniCheck)
	;
	;	Global $aLogRotate = IniRead($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Rotate log files? (yes/no) ###", $iniCheck)
	Global $aLogQuantity = IniRead($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Delete util log files older than __ days ###", $iniCheck)
	Global $sObfuscatePass = IniRead($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hide passwords in log files? (yes/no) ###", $iniCheck)
	;	Global $aLogHoursBetweenRotate = IniRead($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hours between log rotations ###", $iniCheck)
	;
	Global $aEnableRCON = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable RCON? Required for clean shutdown (yes/no) ###", $iniCheck)
	;	Global $aRCONSaveDelaySec = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Delay between saveworld and quit commands during shutdown in seconds (5-120) ###", $iniCheck)
	Global $aValidate = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Validate files with SteamCMD update? (yes/no) ###", $iniCheck)
	Global $aUpdateSource = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "For update checks, use (0)SteamCMD or (1)SteamDB.com ###", $iniCheck)
	Global $aUpdateUtil = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Check for " & $aUtilName & " updates every __ hours (0 to disable) (0-24) ###", $iniCheck)
	Global $aUpdateAutoUtil = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Automatically install " & $aUtilName & " updates? (yes/no) ###", $iniCheck)

	Global $aUtilBetaYN = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", $aUtilName & " version: (0)Stable, (1)Beta ###", $iniCheck)
;~ 	Global $aUsePuttytel = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Use puttytel for telnet client? (yes/no) ###", $iniCheck)
	Global $aExternalScriptHideYN = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide external scripts when executed? (if yes, scripts may not execute properly) (yes/no) ###", $iniCheck)
	;	Global $aDebug = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable debug to output more log detail? (yes/no) ###", $iniCheck)

	If $iniCheck = $aServerDirLocal Then
		$aServerDirLocal = "D:\Game Servers\" & $aGameName & " Dedicated Server"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerDirLocal, "
	EndIf
	If $iniCheck = $aServerAltSaveSelect Then
		$aServerAltSaveSelect = "1"
		$iIniFail += 1
		$iIniError = $iIniError & "Server AltSaveDirectoryNames Pattern, "
	EndIf
	If $iniCheck = $aServerAltSaveDir Then
		$aServerAltSaveDir = ""
		$iIniFail += 1
		$iIniError = $iIniError & "Server AltSaveDirectoryNames, "
	EndIf
	If $iniCheck = $aServerExtraCMD Then
		$aServerExtraCMD = "-log -server -servergamelog -NoBattlEye"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerExtraCMD, "
	EndIf
	If $iniCheck = $aSteamExtraCMD Then
		$aSteamExtraCMD = ""
		$iIniFail += 1
		$iIniError = $iIniError & "SteamExtraCMD, "
	EndIf
	;	If $iniCheck = $aSteamCMDDir Then
	;		$aSteamCMDDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\SteamCMD"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "SteamCMDDir, "
	;	EndIf
	;	If $iniCheck = $aServerVer Then
	;		$aServerVer = "0"
	;		$iIniFail += 1
	;	$iIniError = $iIniError & "aServerVer, "
	;	EndIf
	;	If $iniCheck = $aServerIP Then
	;		$aServerIP = "192.168.1.10"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "aServerIP, "
	;	EndIf
	If $iniCheck = $aServerMultiHomeIP Then
		$aServerMultiHomeIP = ""
		$iIniFail += 1
		$iIniError = $iIniError & "ServerMultiHomeIP, "
	EndIf
	If $iniCheck = $aServerMinimizedYN Then
		$aServerMinimizedYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerMinimizedYN, "
	EndIf
	;	If $iniCheck = $aServerName Then
	;		$aServerName = $aGameName
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "GameName, "
	;	EndIf
	If $iniCheck = $aValidate Then
		$aValidate = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "Validate, "
	EndIf
	If StringLeft($aServerExtraCMD, 1) = "-" Then
		$aServerExtraCMD = " " & $aServerExtraCMD
	EndIf
	;	If $iniCheck = $aServerSaveDir Then
	;		$aServerSaveDir = "10"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "aServerSaveDir, "
	;	EndIf
	If $iniCheck = $aServerAdminPass Then
		$aServerAdminPass = "AdMiN_PaSsWoRd"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerAdminPass, "
	EndIf
	If $iniCheck = $aServerMaxPlayers Then
		$aServerMaxPlayers = "40"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerMaxPlayers, "
	EndIf
	If $iniCheck = $aServerReservedSlots Then
		$aServerReservedSlots = "10"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerReservedSlots, "
	EndIf
	If $iniCheck = $aServerRCONIP Then
		$aServerRCONIP = ""
		$iIniFail += 1
		$iIniError = $iIniError & "ServerRCONIP, "
	EndIf
	If $iniCheck = $aServerRCONImport Then
		$aServerRCONImport = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerRCONImport, "
	EndIf
	If $iniCheck = $aServerRCONPort Then
		$aServerRCONPort = "25720,25722,25724,25726"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerRCONPort, "
	EndIf
	If $iniCheck = $aServerModYN Then
		$aServerModYN = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerModYN, "
	EndIf
	If $iniCheck = $aServerOnlinePlayerYN Then
		$aServerOnlinePlayerYN = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerOnlinePlayerYN, "
	EndIf
	If $iniCheck = $aServerOnlinePlayerSec Then
		$aServerOnlinePlayerSec = "60"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerOnlinePlayerSec, "
	ElseIf $aServerOnlinePlayerSec < 30 Then
		$aServerOnlinePlayerSec = 30
	ElseIf $aServerOnlinePlayerSec > 600 Then
		$aServerOnlinePlayerSec = 600
	EndIf
	If $iniCheck = $aPollRemoteServersYN Then
		$aPollRemoteServersYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "PollRemoteServersYN, "
	EndIf
	;	If $iniCheck = $aServerModList Then
	;		$aServerModList = ""
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "ServerModList, "
	;	EndIf

	If $iniCheck = $aServerUseRedis Then
		$aServerUseRedis = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerUseRedis, "
	EndIf
	If $iniCheck = $aServerRedisConfig Then
		$aServerRedisConfig = "redis.conf"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerRedisConfig, "
	EndIf
	If $iniCheck = $aServerRedisFolder Then
		$aServerRedisFolder = ""
		$iIniFail += 1
		$iIniError = $iIniError & "ServerRedisFolder, "
	EndIf

	If $iniCheck = $aServerStartDelay Then
		$aServerStartDelay = "5"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerStartDelay, "
	ElseIf $aServerStartDelay < 0 Then
		$aServerStartDelay = 0
	ElseIf $aServerStartDelay > 600 Then
		$aServerStartDelay = 600
	EndIf
	If $iniCheck = $aServerShutdownDelay Then
		$aServerShutdownDelay = "2"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerShutdownDelay, "
	ElseIf $aServerShutdownDelay < 0 Then
		$aServerShutdownDelay = 0
	ElseIf $aServerShutdownDelay > 600 Then
		$aServerShutdownDelay = 600
	EndIf
	If $iniCheck = $aShutDnWait Then
		$aShutDnWait = "60"
		$iIniFail += 1
		$iIniError = $iIniError & "ShutdownWait, "
	ElseIf $aShutDnWait < 10 Then
		$aServerStartDelay = 10
	ElseIf $aShutDnWait > 600 Then
		$aShutDnWait = 600
	EndIf

	If $iniCheck = $aEnableRCON Then
		$aEnableRCON = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "EnableRCON, "
	EndIf
	;	If $iniCheck = $aRCONSaveDelaySec Then
	;		$aRCONSaveDelaySec = "10"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "aRCONSaveDelaySec, "
	;	ElseIf $aRCONSaveDelaySec < 5 Then
	;		$aRCONSaveDelaySec = 5
	;	ElseIf $aRCONSaveDelaySec > 120 Then
	;		$aRCONSaveDelaySec = 120
	;	EndIf
	If $iniCheck = $aRemoteRestartUse Then
		$aRemoteRestartUse = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "RemoteRestartUse, "
	EndIf
	If $iniCheck = $aRemoteRestartIP Then
		$aRemoteRestartIP = @IPAddress1
		$iIniFail += 1
		$iIniError = $iIniError & "RemoteRestartIP, "
	EndIf
	If $iniCheck = $aRemoteRestartPort Then
		$aRemoteRestartPort = "57520"
		$iIniFail += 1
		$iIniError = $iIniError & "RemoteRestartPort, "
	EndIf
	If $iniCheck = $aRemoteRestartKey Then
		$aRemoteRestartKey = "restart"
		$iIniFail += 1
		$iIniError = $iIniError & "RemoteRestartKey, "
	EndIf
	If $iniCheck = $aRemoteRestartCode Then
		$aRemoteRestartCode = "password"
		$iIniFail += 1
		$iIniError = $iIniError & "RemoteRestartCode, "
	EndIf
	;	If $iniCheck = $aUsePuttytel Then
	;		$aUsePuttytel = "yes"
	;		$iIniFail += 1
	;	EndIf

	;	If $iniCheck = $aTelnetCheckYN Then
	;		$aTelnetCheckYN = "yes"
	;		$iIniFail += 1
	;	EndIf
	;	If $iniCheck = $aTelnetCheckSec Then
	;		$aTelnetCheckSec = "300"
	;		$iIniFail += 1
	;	ElseIf $aTelnetCheckSec < 30 Then
	;		$aTelnetCheckSec = 30
	;	ElseIf $aTelnetCheckSec > 900 Then
	;		$aTelnetCheckSec = 900
	;	EndIf
	$aTelnetRequired = 0
	;	If $iniCheck = $aTelnetPort Then
	;		$aTelnetPort = "27520"
	;		$iIniFail += 1
	;	ElseIf $aTelnetPort < 22 Then
	;		$aTelnetPort = "27520"
	;		$aTelnetRequired = 1
	;	ElseIf $aTelnetPort > 99999 Then
	;		$aTelnetPort = "27520"
	;		$aTelnetRequired = 1
	;	EndIf
	;	If $iniCheck = $aTelnetPass Then
	;		$aTelnetPass = "TeLneT_PaSsWoRd"
	;		$iIniFail += 1
	;	EndIf
	If $iniCheck = $sObfuscatePass Then
		$sObfuscatePass = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ObfuscatePass, "
	EndIf
	If $iniCheck = $aCheckForUpdate Then
		$aCheckForUpdate = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "CheckForUpdate, "
	EndIf
	If $iniCheck = $aUpdateCheckInterval Then
		$aUpdateCheckInterval = "15"
		$iIniFail += 1
		$iIniError = $iIniError & "UpdateCheckInterval, "
	ElseIf $aUpdateCheckInterval < 5 Then
		$aUpdateCheckInterval = 5
	EndIf

	If $iniCheck = $aDestroyWildDinosYN Then
		$aDestroyWildDinosYN = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "DestroyWildDinosYN, "
	EndIf
	If $iniCheck = $aDestroyWildDinosDays Then
		$aDestroyWildDinosDays = "2,6"
		$iIniFail += 1
		$iIniError = $iIniError & "DestroyWildDinosDays, "
	EndIf
	If $iniCheck = $aDestroyWildDinosHours Then
		$aDestroyWildDinosHours = "03"
		$iIniFail += 1
		$iIniError = $iIniError & "DestroyWildDinosHours, "
	EndIf
	If $iniCheck = $aCustomRCONCount Then
		$aCustomRCONCount = 1
		$iIniFail += 1
		$iIniError = $iIniError & "CustomRCONCount, "
		Global $xCustomRCONCmd[$aCustomRCONCount], $xCustomRCONDays[$aCustomRCONCount], $xCustomRCONHours[$aCustomRCONCount], $xCustomRCONMinute[$aCustomRCONCount], $xCustomRCONAllorLocal[$aCustomRCONCount], $xCustomRCONFile[$aCustomRCONCount]
	Else
		For $i = 0 To ($aCustomRCONCount - 1)
			If $iniCheck = $xCustomRCONCmd[$i] Then
				$xCustomRCONCmd[$i] = ""
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONCmd" & $i & ", "
			EndIf
			If $iniCheck = $xCustomRCONAllorLocal[$i] Then
				$xCustomRCONAllorLocal[$i] = "1"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONAllorLocal" & $i & ", "
			EndIf
			If $iniCheck = $xCustomRCONFile[$i] Then
				$xCustomRCONFile[$i] = ""
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONFile" & $i & ", "
			EndIf
			If $iniCheck = $xCustomRCONDays[$i] Then
				$xCustomRCONDays[$i] = "0"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONDays" & $i & ", "
			EndIf
			If $iniCheck = $xCustomRCONHours[$i] Then
				$xCustomRCONHours[$i] = "04"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONHours" & $i & ", "
			EndIf
			If $iniCheck = $xCustomRCONMinute[$i] Then
				$xCustomRCONMinute[$i] = "00"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONMinute" & $i & ", "
			EndIf
		Next
	EndIf
	If $aCFGRCONCustomLastCount <> $aCustomRCONCount Then
		IniWrite($aUtilCFGFile, "CFG", "aCFGRCONCustomLastCount", $aCustomRCONCount)
		IniWrite($aUtilCFGFile, "CFG", "aCFGRCONCustomShowConfig", "yes")
		If FileExists($sIniFile) Then
			Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
			Local $tFile = $sIniFile & "_" & $tTime & ".bak"
			FileMove($sIniFile, $tFile, 1)
		EndIf
		UpdateIni($sIniFile)
		If FileExists($aIniFailFileBasic) Then
			FileDelete($aIniFailFileBasic)
		EndIf
		FileWrite($aIniFailFileBasic, "[--------------- SCHEDULED USER DEFINED RCON COMMAND ---------------]" & @CRLF & "Number of custom RCON Commands to schedule ...")
		Global $xCustomRCONCmd[$aCustomRCONCount], $xCustomRCONDays[$aCustomRCONCount], $xCustomRCONHours[$aCustomRCONCount], $xCustomRCONMinute[$aCustomRCONCount]
		Local $aMsg = "Custom RCON Command count changed!" & @CRLF & @CRLF & _
				"Click (YES) to restart util and run config editor." & @CRLF & _
				"Click (NO) Or (CANCEL) to continue running utility WITHOUT changes."
		SplashOff()
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 30)
		If $tMB = 6 Then ; YES
			F_ExitCloseN(True)
		EndIf
	EndIf

	If $iniCheck = $aRestartDaily Then
		$aRestartDaily = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "RestartDaily, "
	EndIf
	If $iniCheck = $aRestartDays Then
		$aRestartDays = "0"
		$iIniFail += 1
		$iIniError = $iIniError & "RestartDays, "
	EndIf
	If $iniCheck = $bRestartHours Then
		$bRestartHours = "04,16"
		$iIniFail += 1
		$iIniError = $iIniError & "RestartHours, "
	EndIf
	If $iniCheck = $bRestartMin Then
		$bRestartMin = "00"
		$iIniFail += 1
		$iIniError = $iIniError & "RestartMin, "
	EndIf
	;	If $iniCheck = $aExMemAmt Then
	;		$aExMemAmt = "6000000000"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "aExMemAmt, "
	;	EndIf
	;	If $iniCheck = $aExMemRestart Then
	;		$aExMemRestart = "no"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "aExMemRestart, "
	;	EndIf
	;	If $iniCheck = $aLogRotate Then
	;		$aLogRotate = "yes"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "LogRotate, "
	;	EndIf
	If $iniCheck = $aLogQuantity Then
		$aLogQuantity = "30"
		$iIniFail += 1
		$iIniError = $iIniError & "LogQuantity, "
	EndIf
	;	If $iniCheck = $aLogHoursBetweenRotate Then
	;		$aLogHoursBetweenRotate = "24"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "LogHoursBetweenRotate, "
	;	ElseIf $aLogHoursBetweenRotate < 1 Then
	;		$aLogHoursBetweenRotate = 1
	;	EndIf
	If $iniCheck = $sAnnounceNotifyDaily Then
		$sAnnounceNotifyDaily = "1,2,5,10,15"
		$iIniFail += 1
		$iIniError = $iIniError & "AnnounceNotifyDaily, "
	EndIf
	If $iniCheck = $sAnnounceNotifyUpdate Then
		$sAnnounceNotifyUpdate = "1,2,5"
		$iIniFail += 1
		$iIniError = $iIniError & "AnnounceNotifyUpdate, "
	EndIf
	If $iniCheck = $sAnnounceNotifyRemote Then
		$sAnnounceNotifyRemote = "1,3"
		$iIniFail += 1
		$iIniError = $iIniError & "AnnounceNotifyRemote, "
	EndIf
	If $iniCheck = $sAnnounceNotifyStopServer Then
		$sAnnounceNotifyStopServer = "1,3"
		$iIniFail += 1
		$iIniError = $iIniError & "AnnounceNotifyStopServer, "
	EndIf
	If $iniCheck = $sAnnounceNotifyModUpdate Then
		$sAnnounceNotifyModUpdate = "1,2,5"
		$iIniFail += 1
		$iIniError = $iIniError & "AnnounceNotifyModUpdate, "
	EndIf
	If $iniCheck = $sInGameDailyMessage Then
		$sInGameDailyMessage = "Daily server restart begins in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "InGameDailyMessage, "
	EndIf
	If $iniCheck = $sInGameUpdateMessage Then
		$sInGameUpdateMessage = "A new server update has been released. Server is rebooting in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "InGameUpdateMessage, "
	EndIf
	If $iniCheck = $sInGameRemoteRestartMessage Then
		$sInGameRemoteRestartMessage = "Admin has requested a server reboot. Server is rebooting in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "InGameRemoteRestartMessage, "
	EndIf
	If $iniCheck = $sInGameStopServerMessage Then
		$sInGameStopServerMessage = "Servers shutting down in \m minute(s) for maintenance."
		$iIniFail += 1
		$iIniError = $iIniError & "InGameStopServerMessage, "
	EndIf
	If $iniCheck = $sInGameModUpdateMessage Then
		$sInGameModUpdateMessage = "Mod \x released an update. Server is rebooting in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "InGameModUpdateMessage, "
	EndIf
	If $iniCheck = $sInGame10SecondMessage Then
		$sInGame10SecondMessage = "FINAL WARNING! Rebooting server in 10 seconds..."
		$iIniFail += 1
		$iIniError = $iIniError & "InGameMod10SecondMessage, "
	EndIf
	If $iniCheck = $sDiscordDailyMessage Then
		$sDiscordDailyMessage = "Daily server restart begins in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordDailyMessage, "
	EndIf
	If $iniCheck = $sDiscordUpdateMessage Then
		$sDiscordUpdateMessage = "A new server update has been released. Server is rebooting in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordUpdateMessage, "
	EndIf
	If $iniCheck = $sDiscordRemoteRestartMessage Then
		$sDiscordRemoteRestartMessage = "Admin has requested a server reboot. Server is rebooting in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordRemoteRestartMessage, "
	EndIf
	If $iniCheck = $sDiscordStopServerMessage Then
		$sDiscordStopServerMessage = "Servers shutting down in \m minute(s) for maintenance."
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordStopServerMessage, "
	EndIf
	If $iniCheck = $sDiscordModUpdateMessage Then
		$sDiscordModUpdateMessage = "Mod \x released an update. Server is rebooting in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordModUpdateMessage, "
	EndIf
	If $iniCheck = $sDiscordServersUpMessage Then
		$sDiscordServersUpMessage = $aGameName & " server online and ready for connection."
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordServersUpMessage, "
	EndIf
	If $iniCheck = $sTwitchDailyMessage Then
		$sTwitchDailyMessage = "Daily server restart begins in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "TwitchDailyMessage, "
	EndIf
	If $iniCheck = $sTwitchUpdateMessage Then
		$sTwitchUpdateMessage = "A new server update has been released. Server is rebooting in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "TwitchUpdateMessage, "
	EndIf
	If $iniCheck = $sTwitchRemoteRestartMessage Then
		$sTwitchRemoteRestartMessage = "Admin has requested a server reboot. Server is rebooting in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "TwitchRemoteRestartMessage, "
	EndIf
	If $iniCheck = $sTwitchStopServerMessage Then
		$sTwitchStopServerMessage = "Servers shutting down in \m minute(s) for maintenance."
		$iIniFail += 1
		$iIniError = $iIniError & "TwitchStopServerMessage, "
	EndIf
	If $iniCheck = $sTwitchModUpdateMessage Then
		$sTwitchModUpdateMessage = "Mod \x released an update. Server is rebooting in \m minute(s)."
		$iIniFail += 1
		$iIniError = $iIniError & "TwitchModUpdateMessage, "
	EndIf
	If $iniCheck = $sInGameAnnounce Then
		$sInGameAnnounce = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "InGameAnnounce, "
	EndIf
	If $iniCheck = $sUseDiscordBotDaily Then
		$sUseDiscordBotDaily = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseDiscordBotDaily, "
	EndIf
	If $iniCheck = $sUseDiscordBotUpdate Then
		$sUseDiscordBotUpdate = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseDiscordBotUpdate, "
	EndIf
	If $iniCheck = $sUseDiscordBotRemoteRestart Then
		$sUseDiscordBotRemoteRestart = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseDiscordBotRemoteRestart, "
	EndIf
	If $iniCheck = $sUseDiscordBotStopServer Then
		$sUseDiscordBotStopServer = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseDiscordBotStopServer, "
	EndIf
	If $iniCheck = $sUseDiscordBotModUpdate Then
		$sUseDiscordBotModUpdate = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseDiscordBotModUpdate, "
	EndIf
	If $iniCheck = $sUseDiscordBotServersUpYN Then
		$sUseDiscordBotServersUpYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseDiscordBotServersUpYN, "
	EndIf
	If $iniCheck = $sUseDiscordBotFirstAnnouncement Then
		$sUseDiscordBotFirstAnnouncement = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseDiscordBotFirstAnnouncement, "
	EndIf
	If $iniCheck = $sDiscordWebHookURLs Then
		$sDiscordWebHookURLs = "https://discordapp.com/api/webhooks/XXXXXX/XXXX<-NO TRAILING SLASH AND USE FULL URL FROM WEBHOOK URL ON DISCORD"
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordWebHookURLs, "
	EndIf
	If $iniCheck = $sDiscordBotName Then
		$sDiscordBotName = $aGameName & " Bot"
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordBotName, "
	EndIf
	If $iniCheck = $bDiscordBotUseTTS Then
		$bDiscordBotUseTTS = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordBotUseTTS, "
	EndIf
	If $iniCheck = $sDiscordBotAvatar Then
		$sDiscordBotAvatar = ""
		$iIniFail += 1
		$iIniError = $iIniError & "DiscordBotAvatar, "
	EndIf
	If $iniCheck = $sUseTwitchBotDaily Then
		$sUseTwitchBotDaily = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseTwitchBotDaily, "
	EndIf
	If $iniCheck = $sUseTwitchBotUpdate Then
		$sUseTwitchBotUpdate = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseTwitchBotUpdate, "
	EndIf
	If $iniCheck = $sUseTwitchBotRemoteRestart Then
		$sUseTwitchBotRemoteRestart = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseTwitchBotRemoteRestart, "
	EndIf
	If $iniCheck = $sUseTwitchBotStopServer Then
		$sUseTwitchBotStopServer = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseTwitchBotStopServer, "
	EndIf
	If $iniCheck = $sUseTwitchBotModUpdate Then
		$sUseTwitchBotModUpdate = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseTwitchBotModUpdate, "
	EndIf
	If $iniCheck = $sUseTwitchFirstAnnouncement Then
		$sUseTwitchFirstAnnouncement = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UseDiscordBotFirstAnnouncement, "
	EndIf
	If $iniCheck = $sTwitchNick Then
		$sTwitchNick = "twitchbotusername"
		$iIniFail += 1
		$iIniError = $iIniError & "TwitchNick, "
	EndIf
	If $iniCheck = $sChatOAuth Then
		$sChatOAuth = "oauth:1234(Generate OAuth Token Here: https://twitchapps.com/tmi)"
		$iIniFail += 1
		$iIniError = $iIniError & "ChatOAuth, "
	EndIf
	If $iniCheck = $sTwitchChannels Then
		$sTwitchChannels = "channel1,channel2,channel3"
		$iIniFail += 1
		$iIniError = $iIniError & "TwitchChannels, "
	EndIf
	If $iniCheck = $aExecuteExternalScript Then
		$aExecuteExternalScript = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExecuteExternalScript, "
	EndIf
	If $iniCheck = $aExternalScriptDir Then
		$aExternalScriptDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\Scripts"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptDir, "
	EndIf
	If $iniCheck = $aExternalScriptName Then
		$aExternalScriptName = "beforesteamcmd.bat"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptName, "
	EndIf
	If $iniCheck = $aExternalScriptWait Then
		$aExternalScriptWait = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptWait, "
	EndIf
	If $iniCheck = $aExternalScriptValidateYN Then
		$aExternalScriptValidateYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptValidateYN, "
	EndIf
	If $iniCheck = $aExternalScriptValidateDir Then
		$aExternalScriptValidateDir = "D:\Game Servers\" & $aGameName & " Server\Scripts"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptValidateDir, "
	EndIf
	If $iniCheck = $aExternalScriptValidateName Then
		$aExternalScriptValidateName = "aftersteamcmd.bat"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptValidateName, "
	EndIf
	If $iniCheck = $aExternalScriptValidateWait Then
		$aExternalScriptValidateWait = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptValidateWait, "
	EndIf
	If $iniCheck = $aExternalScriptUpdateYN Then
		$aExternalScriptUpdateYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptUpdateYN, "
	EndIf
	If $iniCheck = $aExternalScriptUpdateDir Then
		$aExternalScriptUpdateDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\Scripts"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptUpdateDir, "
	EndIf
	If $iniCheck = $aExternalScriptUpdateFileName Then
		$aExternalScriptUpdateFileName = "update.bat"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptUpdateFileName, "
	EndIf
	If $iniCheck = $aExternalScriptUpdateWait Then
		$aExternalScriptUpdateWait = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptUpdateWait, "
	EndIf
	If $iniCheck = $aExternalScriptDailyYN Then
		$aExternalScriptDailyYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptDailyYN, "
	EndIf
	If $iniCheck = $aExternalScriptDailyDir Then
		$aExternalScriptDailyDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\Scripts"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptDailyDir, "
	EndIf
	If $iniCheck = $aExternalScriptDailyFileName Then
		$aExternalScriptDailyFileName = "daily.bat"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptDailyFileName, "
	EndIf
	If $iniCheck = $aExternalScriptDailyWait Then
		$aExternalScriptDailyWait = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptDailyWait, "
	EndIf
	If $iniCheck = $aExternalScriptAnnounceYN Then
		$aExternalScriptAnnounceYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptAnnounceYN, "
	EndIf
	If $iniCheck = $aExternalScriptAnnounceDir Then
		$aExternalScriptAnnounceDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\Scripts"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptAnnounceDir, "
	EndIf
	If $iniCheck = $aExternalScriptAnnounceFileName Then
		$aExternalScriptAnnounceFileName = "firstannounce.bat"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptAnnounceFileName, "
	EndIf
	If $iniCheck = $aExternalScriptAnnounceWait Then
		$aExternalScriptAnnounceWait = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptAnnounceWait, "
	EndIf
	If $iniCheck = $aExternalScriptRemoteYN Then
		$aExternalScriptRemoteYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptRemoteYN, "
	EndIf
	If $iniCheck = $aExternalScriptRemoteDir Then
		$aExternalScriptRemoteDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\Scripts"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptRemoteDir, "
	EndIf
	If $iniCheck = $aExternalScriptRemoteFileName Then
		$aExternalScriptRemoteFileName = "remoterestart.bat"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptRemoteFileName, "
	EndIf
	If $iniCheck = $aExternalScriptRemoteWait Then
		$aExternalScriptRemoteWait = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptRemoteWait, "
	EndIf
	If $iniCheck = $aExternalScriptModYN Then
		$aExternalScriptModYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptModYN, "
	EndIf
	If $iniCheck = $aExternalScriptModDir Then
		$aExternalScriptModDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\Scripts"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptModDir, "
	EndIf
	If $iniCheck = $aExternalScriptModFileName Then
		$aExternalScriptModFileName = "modupdate.bat"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptModFileName, "
	EndIf
	If $iniCheck = $aExternalScriptModWait Then
		$aExternalScriptModWait = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptModWait, "
	EndIf
	If $iniCheck = $aExternalScriptHideYN Then
		$aExternalScriptHideYN = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "ExternalScriptHideYN, "
	EndIf
	If $iniCheck = $aUpdateSource Then
		$aUpdateSource = "0"
		$iIniFail += 1
		$iIniError = $iIniError & "UpdateSource, "
	EndIf
	If $iniCheck = $aUpdateUtil Then
		$aUpdateUtil = "4"
		$iIniFail += 1
		$iIniError = $iIniError & "UpdateUtil, "
	ElseIf $aUpdateUtil < 0 Then
		$aUpdateUtil = 0
	ElseIf $aUpdateUtil > 24 Then
		$aUpdateUtil = 24
	EndIf
	If $iniCheck = $aUtilBetaYN Then
		$aUtilBetaYN = "0"
		$iIniFail += 1
		$iIniError = $iIniError & "UtilBetaYN, "
	EndIf
	If ($aUpdateSource = "1") And ($aUpdateCheckInterval < 30) Then
		$aUpdateCheckInterval = 30
		LogWrite(" [Update] NOTICE: SteamDB will ban your IP if you check too often. Update check interval set to 30 minutes")
		$iIniFail += 1
		$iIniError = $iIniError & "NOTICE: SteamDB will ban your IP if you check too often. Update check interval set to 30 minutes, "
	EndIf
	If $aIniForceWrite Then
		If FileExists($sIniFile) Then
			Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
			Local $tFile = $sIniFile & "_" & $tTime & ".bak"
			FileMove($sIniFile, $tFile, 1)
		EndIf
		UpdateIni($sIniFile)
		Local $tIniFail = True
	Else
		If $iIniFail > 0 Then
			iniFileCheck($sIniFile, $iIniFail, $iIniError, $tUseWizard)
			Local $tIniFail = True
		Else
			Local $tIniFail = False
		EndIf
	EndIf
;~ 	If $iIniFail > 0 Then
;~ 		iniFileCheck($sIniFile, $iIniFail, $iIniError, $tUseWizard)
;~ 		Local $tIniFail = True
;~ 	Else
;~ 		Local $tIniFail = False
;~ 		If $aIniForceWrite Then
;~ 			If FileExists($sIniFile) Then
;~ 				Local $aMyDate, $aMyTime
;~ 				_DateTimeSplit(_NowCalc(), $aMyDate, $aMyTime)
;~ 				Local $iniDate = StringFormat("%04i.%02i.%02i.%02i%02i", $aMyDate[1], $aMyDate[2], $aMyDate[3], $aMyTime[1], $aMyTime[2])
;~ 				FileMove($sIniFile, $sIniFile & "_" & $iniDate & ".bak", 1)
;~ 			EndIf
;~ 			UpdateIni($sIniFile)
;~ 		EndIf
;~ 	EndIf
	If $bDiscordBotUseTTS = "yes" Then
		$bDiscordBotUseTTS = True
	Else
		$bDiscordBotUseTTS = False
	EndIf
	Global $aDelayShutdownTime = 0
	If ($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes") Then
		$aDelayShutdownTime = $sAnnounceNotifyDaily
	EndIf
	LogWrite(" Importing settings from " & $aUtilName & ".ini.")

	$aServerDirLocal = RemoveInvalidCharacters($aServerDirLocal)
	$aServerDirLocal = RemoveTrailingSlash($aServerDirLocal)
	;	$aSteamCMDDir = RemoveInvalidCharacters($aSteamCMDDir)
	;	$aSteamCMDDir = RemoveTrailingSlash($aSteamCMDDir)
	$aServerRedisFolder = RemoveInvalidCharacters($aServerRedisFolder)
	$aServerRedisFolder = RemoveTrailingSlash($aServerRedisFolder)
	;	$aConfigFile = RemoveInvalidCharacters($aConfigFile)
	$aExternalScriptDir = RemoveInvalidCharacters($aExternalScriptDir)
	$aExternalScriptDir = RemoveTrailingSlash($aExternalScriptDir)
	$aExternalScriptName = RemoveInvalidCharacters($aExternalScriptName)
	$aExternalScriptValidateDir = RemoveInvalidCharacters($aExternalScriptValidateDir)
	$aExternalScriptValidateDir = RemoveTrailingSlash($aExternalScriptValidateDir)
	$aExternalScriptValidateName = RemoveInvalidCharacters($aExternalScriptValidateName)
	$aExternalScriptUpdateDir = RemoveInvalidCharacters($aExternalScriptUpdateDir)
	$aExternalScriptUpdateDir = RemoveTrailingSlash($aExternalScriptUpdateDir)
	$aExternalScriptUpdateFileName = RemoveInvalidCharacters($aExternalScriptUpdateFileName)
	$aExternalScriptAnnounceDir = RemoveInvalidCharacters($aExternalScriptAnnounceDir)
	$aExternalScriptAnnounceDir = RemoveTrailingSlash($aExternalScriptAnnounceDir)
	$aExternalScriptAnnounceFileName = RemoveInvalidCharacters($aExternalScriptAnnounceFileName)
	$aExternalScriptDailyDir = RemoveInvalidCharacters($aExternalScriptDailyDir)
	$aExternalScriptDailyDir = RemoveTrailingSlash($aExternalScriptDailyDir)
	$aExternalScriptDailyFileName = RemoveInvalidCharacters($aExternalScriptDailyFileName)
	$aExternalScriptModDir = RemoveInvalidCharacters($aExternalScriptModDir)
	$aExternalScriptModDir = RemoveTrailingSlash($aExternalScriptModDir)
	$aExternalScriptModFileName = RemoveInvalidCharacters($aExternalScriptModFileName)
	$sDiscordWebHookURLs = StringRegExpReplace($sDiscordWebHookURLs, "<-NO TRAILING SLASH AND USE FULL URL FROM WEBHOOK URL ON DISCORD", "")

	If $aServerRCONImport = "no" Then
		Global $xServerRCONPort = StringSplit($aServerRCONPort, ",")
	EndIf
;~ 	If $aServerAltSaveDir = "" Then
;~ 		Global $xServerAltSaveDir = ""
;~ 	Else
;~ 		Global $xServerAltSaveDir = StringSplit($aServerAltSaveDir, ",", 2)
;~ 	EndIf
	If $sUseTwitchBotModUpdate = "yes" Or $sUseDiscordBotModUpdate = "yes" Or $sUseDiscordBotRemoteRestart = "yes" Or $sUseDiscordBotDaily = "yes" Or $sUseDiscordBotUpdate = "yes" Or $sUseTwitchBotRemoteRestart = "yes" Or $sUseTwitchBotDaily = "yes" Or $sUseTwitchBotUpdate = "yes" Or $sInGameAnnounce = "yes" Then
		Global $aDailyMsgInGame = AnnounceReplaceTime($sAnnounceNotifyDaily, $sInGameDailyMessage)
		Global $aDailyMsgDiscord = AnnounceReplaceTime($sAnnounceNotifyDaily, $sDiscordDailyMessage)
		Global $aDailyMsgTwitch = AnnounceReplaceTime($sAnnounceNotifyDaily, $sTwitchDailyMessage)
		Global $aDailyTime = StringSplit($sAnnounceNotifyDaily, ",")
		Global $aDailyCnt = Int($aDailyTime[0])

		Global $aUpdateMsgInGame = AnnounceReplaceTime($sAnnounceNotifyUpdate, $sInGameUpdateMessage)
		Global $aUpdateMsgDiscord = AnnounceReplaceTime($sAnnounceNotifyUpdate, $sDiscordUpdateMessage)
		Global $aUpdateMsgTwitch = AnnounceReplaceTime($sAnnounceNotifyUpdate, $sTwitchUpdateMessage)
		Global $aUpdateTime = StringSplit($sAnnounceNotifyUpdate, ",")
		Global $aUpdateCnt = Int($aUpdateTime[0])

		Global $aRemoteMsgInGame = AnnounceReplaceTime($sAnnounceNotifyRemote, $sInGameRemoteRestartMessage)
		Global $aRemoteMsgDiscord = AnnounceReplaceTime($sAnnounceNotifyRemote, $sDiscordRemoteRestartMessage)
		Global $aRemoteMsgTwitch = AnnounceReplaceTime($sAnnounceNotifyRemote, $sTwitchRemoteRestartMessage)
		Global $aRemoteTime = StringSplit($sAnnounceNotifyRemote, ",")

		Global $sModMsgInGame = AnnounceReplaceTime($sAnnounceNotifyModUpdate, $sInGameModUpdateMessage)
		Global $sModMsgDiscord = AnnounceReplaceTime($sAnnounceNotifyModUpdate, $sDiscordModUpdateMessage)
		Global $sModMsgTwitch = AnnounceReplaceTime($sAnnounceNotifyModUpdate, $sTwitchModUpdateMessage)
		Global $aModTime = StringSplit($sAnnounceNotifyModUpdate, ",")
		Global $aModCnt = Int($aModTime[0])

		Global $aDelayShutdownTime = Int($aDailyTime[$aDailyCnt])
		DailyRestartOffset($bRestartHours, $bRestartMin, $aDelayShutdownTime)
	Else
		Global $aDelayShutdownTime = 0
	EndIf

	Global $aStopServerMsgInGame = AnnounceReplaceTime($sAnnounceNotifyStopServer, $sInGameStopServerMessage)
	Global $aStopServerMsgDiscord = AnnounceReplaceTime($sAnnounceNotifyStopServer, $sDiscordStopServerMessage)
	Global $aStopServerMsgTwitch = AnnounceReplaceTime($sAnnounceNotifyStopServer, $sTwitchStopServerMessage)
	Global $aStopServerTime = StringSplit($sAnnounceNotifyStopServer, ",")
	Global $aStopServerCnt = Int($aStopServerTime[0])

	LogWrite("", " . . . Server Folder = " & $aServerDirLocal)
	LogWrite("", " . . . SteamCMD Folder = " & $aSteamCMDDir)
	;	If ($sInGameAnnounce = "yes") Or ($aTelnetCheckYN = "yes") And ($aTelnetRequired = "1") Then
	;		LogWrite("RCON/Telnet Required", "RCON/Telnet required for in-game announcements and ROCN/Telnet KeepAlive checks. RCON/Telnet enabled and set to port: " & $aTelnetPort & ".")
	;	EndIf
	Return $tIniFail
EndFunc   ;==>ReadUini

Func iniFileCheck($sIniFile, $iIniFail, $iIniError, $tUseWizard)
	If FileExists($sIniFile) Then
		Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
		Local $tFile = $aIniFile & "_" & $tTime & ".bak"
		FileMove($sIniFile, $tFile, 1)
		UpdateIni($sIniFile)
		;		FileWriteLine($aIniFailFileFull, _NowCalc() & " INI MISMATCH: Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini. Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		$iIniErrorCRLF = StringRegExpReplace($iIniError, ", ", @CRLF & @TAB)
		FileWriteLine($aIniFailFileFull, _NowCalc() & @CRLF & " ---------- Parameters missing or changed ----------" & @CRLF & @CRLF & @TAB & $iIniErrorCRLF)
		FileWriteLine($aIniFailFileBasic, $iIniErrorCRLF)
		LogWrite(" [Util] New or changed INI Parameters: Parameters missing or changed: " & $iIniFail, " [Util] New or changed INI Parameters: Found " & $iIniFail & _
				" missing or changed variable(s) in " & $aUtilName & ".ini. Backup created and all existing settings transfered to new INI. Please make any desired changes to INI.")
		If $tUseWizard Then
			SplashTextOn($aUtilName, $aStartText & $aUtilName & ".ini file changed. Restarting utility.", 475, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(3000)
			IniWrite($aUtilCFGFile, "CFG", "aCFGRCONCustomShowConfig", "yes")
			F_ExitCloseN(True)
;~ 			SplashOff()
;~ 			ConfigEdit($aSplashStartUp, True)
		Else
			SplashOff()
			Run("notepad " & $aIniFailFileFull, @WindowsDir)
			$tMB = MsgBox($MB_YESNOCANCEL, "New or changed INI Parameters", "INI FILE WAS UPDATED." & @CRLF & "Found " & $iIniFail & " missing or changes variable(s) in " & $aUtilName & ".ini:" & @CRLF & @CRLF & $iIniError & @CRLF & @CRLF & _
					"Backup created and all existing settings transfered to new INI." & @CRLF & @CRLF & "Please make any desired changes to INI." & @CRLF & @CRLF & "File created: ___INI_FAIL_VARIABLES___.txt" & @CRLF & @CRLF & _
					"Click (YES) to download update, but NOT install, to " & @CRLF & @ScriptDir & @CRLF & _
					"Click (NO) to stop checking for updates." & @CRLF & _
					"Click (CANCEL) to skip this update check.", 15)
;~ 					"Click OK to continue 30 seconds to run program.", 30)
		EndIf
	Else
		UpdateIni($sIniFile)
		If $tUseWizard = False Then
			SplashOff()
			MsgBox(4096, "Default INI File Created", "Please Modify Default Values and Restart Program." & @CRLF & @CRLF & "IF NEW DEDICATED SERVER INSTALL:" & @CRLF & " - Once the server is installed and running," & @CRLF & _
					"Rt-Click on " & $aUtilName & " icon and shutdown server." & @CRLF & " - Then modify the server files and restart this utility.")
			LogWrite(" Default INI File Created . . Please Modify Default Values and Restart Program.")
			Run("notepad " & $sIniFile, @WindowsDir)
			Exit
		Else
			SplashOff()
			WizardSelect()
		EndIf
	EndIf
EndFunc   ;==>iniFileCheck

Func UpdateIni($sIniFile)
	FileWriteLine($sIniFile, "[ --------------- " & StringUpper($aUtilName) & " INFORMATION --------------- ]")
	FileWriteLine($sIniFile, "Author   :  Phoenix125")
	FileWriteLine($sIniFile, "Version  :  " & $aUtilityVer)
	FileWriteLine($sIniFile, "Website  :  http://www.Phoenix125.com")
	FileWriteLine($sIniFile, "Discord  :  http://discord.gg/EU7pzPs")
	FileWriteLine($sIniFile, "Forum    :  https://phoenix125.createaforum.com/index.php")
	FileWriteLine($sIniFile, @CRLF)
	FileWriteLine($sIniFile, "[ --------------- GAME SERVER CONFIGURATION --------------- ]")
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server name (for announcements and logs only) ###", $aServerName)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " DIR ###", $aServerDirLocal)
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD DIR ###", $aSteamCMDDir)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", $aServerAltSaveSelect)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames (Use same order as listed in ServerGrid.json. Comma separated) ###", $aServerAltSaveDir)
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Version (0-Stable,1-Experimental)", $aServerVer)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " extra commandline parameters (ex.?serverpve-pve -NoCrashDialog) ###", $aServerExtraCMD)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD extra commandline parameters (ex. -latest_experimental) ###", $aSteamExtraCMD)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server multi-home IP (Leave blank to disable) ###", $aServerMultiHomeIP)
	FileWriteLine($sIniFile, @CRLF)
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server IP ###", $aServerIP)
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Gamesave directory name", $aServerSaveDir)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Admin password ###", $aServerAdminPass)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Max players ###", $aServerMaxPlayers)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Reserved slots ###", $aServerReservedSlots)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Start servers minimized (for a cleaner look)? (yes/no) ###", $aServerMinimizedYN)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "RCON IP (ex. 127.0.0.1 - Leave BLANK for server IP) ###", $aServerRCONIP)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Import RCON ports from GameUserSettings.ini files? (yes/no) ###", $aServerRCONImport)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server RCON Port(s) (comma separated, grid order as in ServerGrid.json, ignore if importing RCON ports) ###", $aServerRCONPort)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Delay in seconds between grid server starts (0-600) ###", $aServerStartDelay)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Delay in seconds between grid server shutdowns (0-600) ###", $aServerShutdownDelay)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Seconds allowed for GameSave before taskkilling servers during reboots (10-600) ###", $aShutDnWait)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Use this util to install mods and check for mod updates (as listed in ServerGrid.json)? (yes/no) ###", $aServerModYN)
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Mod number(s) (comma separated) ###", $aServerModList)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for, and log, online players? (yes/no) ###", $aServerOnlinePlayerYN)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for online players every _ seconds (30-600) ###", $aServerOnlinePlayerSec)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for online players on remote servers? (yes/no) ###", $aPollRemoteServersYN)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Autostart and keep-alive redis-server.exe? Use NO to manage redis-server.exe yourself (yes/no) ###", $aServerUseRedis)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Redis-server config file (Not used if autostart is NO above) ###", $aServerRedisConfig)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Redis-server.exe and config DIR (Not used if autostart is NO above) Leave BLANK for default DIR ###", $aServerRedisFolder)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Check for server updates? (yes/no) ###", $aCheckForUpdate)
	IniWrite($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Update check interval in minutes (05-59) ###", $aUpdateCheckInterval)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Use scheduled restarts? (yes/no) ###", $aRestartDaily)
	IniWrite($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $aRestartDays)
	IniWrite($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart hours (comma separated 00-23 ex.04,16) ###", $bRestartHours)
	IniWrite($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart minute (00-59) ###", $bRestartMin)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND COUNT --------------- ", "Number of custom RCON Commands to schedule (If changed, util will restart and new custom entries will be added) ###", $aCustomRCONCount)
	For $i = 0 To ($aCustomRCONCount - 1)
		FileWriteLine($sIniFile, @CRLF)
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command to send (leave BLANK to skip) ###", $xCustomRCONCmd[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command send to (0) ALL grids or (1) Local Grids Only ###", $xCustomRCONAllorLocal[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-File to Execute (leave BLANK to skip) ###", $xCustomRCONFile[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $xCustomRCONDays[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event hours (comma separated 00-23 ex.04,16) ###", $xCustomRCONHours[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event minute (00-59) ###", $xCustomRCONMinute[$i])
	Next
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos? (yes/no) ###", $aDestroyWildDinosYN)
	IniWrite($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $aDestroyWildDinosDays)
	IniWrite($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos hours (comma separated 00-23 ex.04,16) ###", $aDestroyWildDinosHours)
	;	FileWriteLine($sIniFile, "( - !!! - Other server information imported from ServerGrid.json - !!! - )")
	;	FileWriteLine($sIniFile, "(If ServerGrid.json is not found, Atlas can still be downloaded and installed)")

	;	IniWrite($sIniFile, " --------------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE --------------- ", "Use RCON/telnet to check if server is alive? (yes/no)", $aTelnetCheck)
	;	IniWrite($sIniFile, " --------------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE --------------- ", "RCON/Telnet check interval in seconds (30-900)", $aTelnetCheckSec)
	;	IniWrite($sIniFile, " --------------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE --------------- ", "RCON/Telnet port", $aTelnetPort)
	;	IniWrite($sIniFile, " --------------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE --------------- ", "RCON/Telnet password", $aTelnetPass)
	FileWriteLine($sIniFile, @CRLF)
	;	IniWrite($sIniFile, " --------------- RESTART ON EXCESSIVE MEMORY USE --------------- ", "Restart on excessive memory use? (yes/no) ###", $aExMemRestart)
	;	IniWrite($sIniFile, " --------------- RESTART ON EXCESSIVE MEMORY USE --------------- ", "Excessive memory amount? ###", $aExMemAmt)
	;	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Use Remote Restart? (yes/no) ###", $aRemoteRestartUse)
	IniWrite($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Server Local IP (ex. 192.168.1.10) ###", $aRemoteRestartIP)
	IniWrite($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Restart Port ###", $aRemoteRestartPort)
	IniWrite($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Restart Key ###", $aRemoteRestartKey)
	IniWrite($sIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Restart Code ###", $aRemoteRestartCode)
	FileWriteLine($sIniFile, "(Usage example: http://192.168.1.10:57520/?restart=password)")
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before DAILY reboot (comma separated 0-60) ###", $sAnnounceNotifyDaily)
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before UPDATES reboot (comma separated 0-60) ###", $sAnnounceNotifyUpdate)
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before REMOTE RESTART reboot (comma separated 0-60) ###", $sAnnounceNotifyRemote)
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before STOP SERVER (comma separated 0-60) ###", $sAnnounceNotifyStopServer)
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before MOD UPDATE reboot (comma separated 0-60) ###", $sAnnounceNotifyModUpdate)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires telnet) (yes/no) ###", $sInGameAnnounce)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement DAILY (\m - minutes) ###", $sInGameDailyMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $sInGameUpdateMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $sInGameRemoteRestartMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement STOP SERVER (\m - minutes) ###", $sInGameStopServerMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement MOD UPDATE (\m - minutes, \x - Mod ID) ###", $sInGameModUpdateMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement 10 seconds before reboot ###", $sInGame10SecondMessage)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for DAILY reboot? (yes/no) ###", $sUseDiscordBotDaily)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for UPDATE reboot? (yes/no) ###", $sUseDiscordBotUpdate)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for REMOTE RESTART reboot? (yes/no) ###", $sUseDiscordBotRemoteRestart)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for STOP SERVER? (yes/no) ###", $sUseDiscordBotStopServer)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for MOD UPDATE reboot? (yes/no) ###", $sUseDiscordBotModUpdate)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message when all servers are back online (yes/no) ###", $sUseDiscordBotServersUpYN)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for first announcement only? (reduces bot spam)(yes/no) ###", $sUseDiscordBotFirstAnnouncement)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $sDiscordDailyMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $sDiscordUpdateMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $sDiscordRemoteRestartMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement STOP SERVER (\m - minutes) ###", $sDiscordStopServerMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement MOD UPDATE (\m - minutes, \x - Mod ID) ###", $sDiscordModUpdateMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement Servers back online ###", $sDiscordServersUpMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "WebHook URL ###", $sDiscordWebHookURLs)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Bot Name ###", $sDiscordBotName)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Use TTS? (yes/no) ###", $bDiscordBotUseTTS)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Bot Avatar Link ###", $sDiscordBotAvatar)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for DAILY reboot? (yes/no) ###", $sUseTwitchBotDaily)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for UPDATE reboot? (yes/no) ###", $sUseTwitchBotUpdate)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for REMOTE RESTART reboot? (yes/no) ###", $sUseTwitchBotRemoteRestart)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for STOP SERVER? (yes/no) ###", $sUseTwitchBotStopServer)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for MOD UPDATE reboot? (yes/no) ###", $sUseTwitchBotModUpdate)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for first announcement only? (reduces bot spam)(yes/no) ###", $sUseTwitchFirstAnnouncement)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $sTwitchDailyMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $sTwitchUpdateMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $sTwitchRemoteRestartMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement STOP SERVER (\m - minutes) ###", $sTwitchStopServerMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement MOD UPDATE (\m - minutes, \x - Mod ID) ###", $sTwitchModUpdateMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Nick ###", $sTwitchNick)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "ChatOAuth ###", $sChatOAuth)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Channels ###", $sTwitchChannels)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Execute external script BEFORE update? (yes/no) ###", $aExecuteExternalScript)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Script directory ###", $aExternalScriptDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Script filename ###", $aExternalScriptName)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Wait for script to complete before continuing? (yes/no) ###", $aExternalScriptWait)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Execute external script AFTER update but BEFORE server start? (yes/no) ###", $aExternalScriptValidateYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Script directory ###", $aExternalScriptValidateDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Script filename ###", $aExternalScriptValidateName)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Wait for script to complete before continuing? (yes/no) ###", $aExternalScriptValidateWait)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Execute external script for server update restarts? (yes/no) ###", $aExternalScriptUpdateYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Script directory ###", $aExternalScriptUpdateDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Script filename ###", $aExternalScriptUpdateFileName)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Wait for script to complete before continuing? (yes/no) ###", $aExternalScriptUpdateWait)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Execute external script for daily server restarts? (yes/no) ###", $aExternalScriptDailyYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Script directory ###", $aExternalScriptDailyDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Script filename ###", $aExternalScriptDailyFileName)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Wait for script to complete before continuing? (yes/no) ###", $aExternalScriptDailyWait)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Execute external script when first restart announcement is made? (yes/no) ###", $aExternalScriptAnnounceYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Script directory ###", $aExternalScriptAnnounceDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Script filename ###", $aExternalScriptAnnounceFileName)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Wait for script to complete before continuing? (yes/no) ###", $aExternalScriptAnnounceWait)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Execute external script during restart when a remote restart request is made? (yes/no) ###", $aExternalScriptRemoteYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Script directory ###", $aExternalScriptRemoteDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Script filename ###", $aExternalScriptRemoteFileName)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Wait for script to complete before continuing? (yes/no) ###", $aExternalScriptRemoteWait)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *MOD UPDATE* SERVER RESTART --------------- ", "7-Execute external script when mod update required (prior to server shutdown)? (yes/no) ###", $aExternalScriptModYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *MOD UPDATE* SERVER RESTART --------------- ", "7-Script directory ###", $aExternalScriptModDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *MOD UPDATE* SERVER RESTART --------------- ", "7-Script filename ###", $aExternalScriptModFileName)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *MOD UPDATE* SERVER RESTART --------------- ", "7-Wait for script to complete before continuing? (yes/no) ###", $aExternalScriptModWait)
	FileWriteLine($sIniFile, @CRLF)
	;	IniWrite($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Rotate log files? (yes/no) ###", $aLogRotate)
	IniWrite($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Delete util log files older than __ days ###", $aLogQuantity)
	IniWrite($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hide passwords in log files? (yes/no) ###", $sObfuscatePass)
	;	IniWrite($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hours between log rotations ###", $aLogHoursBetweenRotate)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Validate files with SteamCMD update? (yes/no) ###", $aValidate)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable RCON? Required for clean shutdown (yes/no) ###", $aEnableRCON)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Delay between saveworld and quit commands during shutdown in seconds (5-120) ###", $aRCONSaveDelaySec)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "For update checks, use (0)SteamCMD or (1)SteamDB.com ###", $aUpdateSource)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Check for " & $aUtilName & " updates every __ hours (0 to disable) (0-24) ###", $aUpdateUtil)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Automatically install " & $aUtilName & " updates? (yes/no) ###", $aUpdateAutoUtil)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", $aUtilName & " version: (0)Stable, (1)Beta ###", $aUtilBetaYN)
	FileWriteLine($sIniFile, @CRLF)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Use puttytel for telnet client? (yes/no)", $aUsePuttytel)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide external scripts when executed? (if yes, scripts may not execute properly) (yes/no) ###", $aExternalScriptHideYN)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable debug to output more log detail? (yes/no) ###", $aDebug)
EndFunc   ;==>UpdateIni
#EndRegion ;**** INI Settings - User Variables ****

Func ReadCFG($sIniFile)
	Local $iIniFail = 0
	Local $iniCheck = ""
	If FileExists($sIniFile) Then
		Local $aChar[3]
		For $i = 1 To 13
			$aChar[0] = Chr(Random(97, 122, 1)) ;a-z
			$aChar[1] = Chr(Random(48, 57, 1)) ;0-9
			$iniCheck &= $aChar[Random(0, 1, 1)]
		Next
		Global $aUtilReboot = IniRead($sIniFile, "CFG", "aUtilReboot", $iniCheck)
		Global $aUtilLastClose = IniRead($sIniFile, "CFG", "aUtilLastClose", $iniCheck)
		Global $aCFGLastUpdate = IniRead($sIniFile, "CFG", "aCFGLastUpdate", $iniCheck)
		Global $aCFGLastVersion = IniRead($sIniFile, "CFG", "aCFGLastVersion", $iniCheck)
		Global $aCFGLastVerNumber = IniRead($sIniFile, "CFG", "aCFGLastVerNumber", $iniCheck)
		Global $aCFGRCONCustomLastCount = IniRead($sIniFile, "CFG", "aCFGRCONCustomLastCount", $iniCheck)
		If $iniCheck = $aUtilReboot Then
			$aUtilReboot = "no"
			$iIniFail += 1
		EndIf
		If $iniCheck = $aUtilLastClose Then
			$aUtilLastClose = _NowCalc()
			$iIniFail += 1
		EndIf
		If $iniCheck = $aCFGLastUpdate Then
			$aCFGLastUpdate = _NowCalc()
			$iIniFail += 1
		EndIf
		If $iniCheck = $aCFGRCONCustomLastCount Then
			$aCFGRCONCustomLastCount = 1
			$iIniFail += 1
		EndIf
		If $iIniFail > 0 Then
			IniWrite($sIniFile, "CFG", "aUtilReboot", $aUtilReboot)
			IniWrite($sIniFile, "CFG", "aUtilLastClose", $aUtilLastClose)
			IniWrite($sIniFile, "CFG", "aCFGLastUpdate", $aCFGLastUpdate)
;~ 		IniWrite($sIniFile, "CFG", "aCFGLastVersion", $aCFGLastVersion)
;~ 		IniWrite($sIniFile, "CFG", "aCFGLastVerNumber", $aCFGLastVerNumber)
		EndIf
		IniWrite($sIniFile, "CFG", "aCFGLastVersion", $aUtilVersion)
		IniWrite($sIniFile, "CFG", "aCFGLastVerNumber", $aUtilVerNumber)
	Else
		Global $aUtilReboot = "no"
		Global $aUtilLastClose = _NowCalc()
		Global $aCFGLastUpdate = _NowCalc()
		Global $aCFGRCONCustomLastCount = 1
		Global $aCFGLastVersion = $aUtilVersion
		Global $aCFGLastVerNumber = $aUtilVerNumber
		IniWrite($sIniFile, "CFG", "aUtilReboot", $aUtilReboot)
		IniWrite($sIniFile, "CFG", "aUtilLastClose", $aUtilLastClose)
		IniWrite($sIniFile, "CFG", "aCFGLastUpdate", $aCFGLastUpdate)
		IniWrite($sIniFile, "CFG", "aCFGLastVersion", $aUtilVersion)
		IniWrite($sIniFile, "CFG", "aCFGLastVerNumber", $aUtilVerNumber)
	EndIf
EndFunc   ;==>ReadCFG

Func CFGLastClose()
	IniWrite($aUtilCFGFile, "CFG", "aUtilLastClose", _NowCalc())
EndFunc   ;==>CFGLastClose

Func CFGUtilReboot($i = True)
	IniWrite($sIniFile, "CFG", "aUtilReboot", $i)
EndFunc   ;==>CFGUtilReboot

Func RunUtilUpdate()
;~ 	UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName, 0, $aUpdateUtil)
	UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName, 0, "Auto")
	PurgeLogFile()
EndFunc   ;==>RunUtilUpdate

Func ResizeArray($tArray, $tArrayAssignedMax = 0)
	Local $tArrayMax = UBound($tArray), $tArrayRange = 0
	If $tArrayAssignedMax > $tArrayMax Then
		ReDim $tArray[$tArrayAssignedMax]
	ElseIf $tArrayAssignedMax = 0 Then
		For $tArrayi = 0 To ($tArrayMax - 1)
			If $tArray[$tArrayi] = "" Then
				$tArrayRange = $tArrayi & "-" & ($tArrayMax - 1)
				ExitLoop
			EndIf
		Next
	ElseIf $tArrayAssignedMax = $tArrayMax Then
		Return $tArray
	Else
		$tArrayRange = $tArrayAssignedMax & "-" & ($tArrayMax - 1)
	EndIf
	If $tArrayRange <> 0 Then _ArrayDelete($tArray, $tArrayRange)
	Return $tArray
EndFunc   ;==>ResizeArray

Func _AddCommasDecimalNo($tNumber)
	Return StringRegExpReplace(Int($tNumber), '\G(\d+?)(?=(\d{3})+(\D|$))', '$1,')
EndFunc   ;==>_AddCommasDecimalNo

; -----------------------------------------------------------------------------------------------------------------------


#Region ; **** Gamercide Shutdown Protocol ****
Func Gamercide()
	Local $aMsg = "Thank you for using " & $aUtilName & "." & @CRLF & "Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
			"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com"
	If @exitMethod <> 1 Then
		If ($aServerUseRedis = "yes") And ($aPIDRedisreadYetTF = False) Or ($aPIDServerReadYetTF = False) Then
			LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
			CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
			MsgBox(4096, $aUtilityVer, $aMsg, 20)
			LogWrite(" " & $aUtilityVer & " Stopped by User")
			Exit
		Else
			If $aServerUseRedis = "yes" Then
				$bMsg = "Utility exited unexpectedly or before it was fully initialized." & @CRLF & @CRLF & _
						"Close utility?" & @CRLF & @CRLF & _
						"Click (YES) to shutdown all servers and exit utility." & @CRLF & _
						"Click (NO) to shutdown all servers BUT LEAVE REDIS RUNNING." & @CRLF & _
						"Click (CANCEL) to exit utility but leave servers and redis still running."
			Else
				$bMsg = "Utility exited unexpectedly or before it was fully initialized." & @CRLF & @CRLF & _
						"Close utility?" & @CRLF & @CRLF & _
						"Click (YES) to shutdown all servers and exit utility." & @CRLF & _
						"Click (NO) or (CANCEL) to exit utility but leave servers running."
			EndIf
			SplashOff()
			$Shutdown = MsgBox($MB_YESNOCANCEL, $aUtilName, $bMsg, 60)
			; ----------------------------------------------------------
			If $Shutdown = 6 Then ; YES
				LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, True, False)
				SplashOff()
				If ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
					LogWrite(" [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
					ProcessClose($aServerPIDRedis)
					If FileExists($aPIDRedisFile) Then
						FileDelete($aPIDRedisFile)
					EndIf
				EndIf
				MsgBox(4096, $aUtilityVer, $aMsg, 20)
				LogWrite(" " & $aUtilityVer & " Stopped by User")
				If FileExists($aPIDServerFile) Then
					FileDelete($aPIDServerFile)
				EndIf
				Exit
				; ----------------------------------------------------------
			ElseIf $Shutdown = 7 Then ; NO
				If $aServerUseRedis = "yes" Then
					LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
					CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False) ; Do NOT close redis
					PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
					MsgBox(4096, $aUtilityVer, $aMsg, 20)
					LogWrite(" " & $aUtilityVer & " Stopped by User")
				Else
					LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
					CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
					PIDSaveServer($aServerPID, $aPIDServerFile)
					PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
					MsgBox(4096, $aUtilityVer, $aMsg, 20)
					LogWrite(" " & $aUtilityVer & " Stopped by User")
				EndIf
				Exit
				; ----------------------------------------------------------
			ElseIf $Shutdown = 2 Then ; CANCEL
				LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
				CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
				PIDSaveServer($aServerPID, $aPIDServerFile)
				If $aServerUseRedis = "yes" Then
					PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
				EndIf
				MsgBox(4096, $aUtilityVer, $aMsg, 20)
				LogWrite(" " & $aUtilityVer & " Stopped by User")
				; ----------------------------------------------------------
			EndIf
		EndIf
	Else
	EndIf
EndFunc   ;==>Gamercide
#EndRegion ; **** Gamercide Shutdown Protocol ****

; -----------------------------------------------------------------------------------------------------------------------

Func CloseServer($ip, $port, $pass, $tCloseRedisTF = True, $tDisableServers = False)
	If $aFirstBoot Then
		Global $aSplashCloseServer = 0
	Else
		Global $aSplashCloseServer = SplashTextOn($aUtilName & ": " & $aServerName, "Sending shutdown command to server(s) . . .", 550, 100, -1, -1, $DLG_MOVEABLE, "")
	EndIf
	If $aRebootReason = "stopservers" Then
		If $aSelectServers Then
		Else
			$tDisableServers = True
			$aRebootReason = ""
		EndIf
	EndIf
	CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, $aSplashCloseServer)
	ControlSetText($aSplashCloseServer, "", "Static1", "Sending shutdown (DoExit) command to server(s) . . .")
	$aServerReadyOnce = True
	$aServerReadyTF = False
	$aShutdown = 1
	$aFailCount = 0
	LogWrite(" --------- Server(s) shutdown sequence beginning ---------")
	If $aSelectServers Then
		SetStatusBusy("Stopping select server(s).", "Stop Server ")
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
				ControlSetText($aSplashCloseServer, "", "Static1", "Sending shutdown command to server: " & $xServergridx[$i] & $xServergridy[$i])
				GUICtrlSetData($LabelUtilReadyStatus, "Stop Server " & $xServergridx[$i] & $xServergridy[$i])
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, "DoExit", "no")
				LogWrite(" [Server] Sending shutdown (DoExit) command to select servers. Server " & $xServergridx[$i] & $xServergridy[$i])
				Sleep(1000 * $aServerShutdownDelay)
			EndIf
		Next
	Else
		For $i = 0 To ($aServerGridTotal - 1)
			If ($xStartGrid[$i] = "yes") Then
				If ProcessExists($aServerPID[$i]) Then
					$aErrorShutdown = 1
					ControlSetText($aSplashCloseServer, "", "Static1", "Sending shutdown command to server: " & $xServergridx[$i] & $xServergridy[$i])
					GUICtrlSetData($LabelUtilReadyStatus, "Stop Server " & $xServergridx[$i] & $xServergridy[$i])
					SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aRCONShutdownCMD)
					Sleep(1000 * $aServerShutdownDelay)
				EndIf
			EndIf
		Next
	EndIf
	$aErrorShutdown = 0
	LogWrite(" Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . .")
	If $aSelectServers Then
		For $k = 1 To $aShutDnWait
			For $i = 0 To ($aServerGridTotal - 1)
				If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
					If $xStartGrid[$i] = "yes" Then
						SendCTRLC($aServerPID[$i])
						$aErrorShutdown = 1
						SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, "DoExit", "no")
					EndIf
				EndIf
			Next
			If $aErrorShutdown = 1 Then
				Sleep(950)
				ControlSetText($aSplashCloseServer, "", "Static1", "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . ." & @CRLF & @CRLF & "Countdown: " & ($aShutDnWait - $k))
				$aErrorShutdown = 0
			Else
				ExitLoop
			EndIf
		Next
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
				If $xStartGrid[$i] = "yes" And ProcessExists($aServerPID[$i]) Then
					$aErrorShutdown = 1
					ProcessClose($aServerPID[$i])
					LogWrite(" [Server (PID: " & $aServerPID[$i] & ")] Warning: Shutdown failed. Killing Process")
					$aServerPID[$i] = ""
				EndIf
			EndIf
		Next
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
				$xStartGrid[$i] = "no"
				$aGridSomeDisable = True
				IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", "no")
			EndIf
		Next
		$aSelectServers = False
		$aStopServerMsgInGame = AnnounceReplaceTime($sAnnounceNotifyStopServer, $sInGameStopServerMessage)
		$aStopServerMsgDiscord = AnnounceReplaceTime($sAnnounceNotifyStopServer, $sDiscordStopServerMessage)
		$aStopServerMsgTwitch = AnnounceReplaceTime($sAnnounceNotifyStopServer, $sTwitchStopServerMessage)
	Else
		For $k = 1 To $aShutDnWait
			For $i = 0 To ($aServerGridTotal - 1)
				If ProcessExists($aServerPID[$i]) Then
					$aErrorShutdown = 1
					SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aRCONShutdownCMD)
					SendCTRLC($aServerPID[$i])
				EndIf
			Next
			If $aErrorShutdown = 1 Then
				Sleep(950)
				ControlSetText($aSplashCloseServer, "", "Static1", "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . ." & @CRLF & @CRLF & "Countdown: " & ($aShutDnWait - $k))
				$aErrorShutdown = 0
			Else
				ExitLoop
			EndIf
		Next
		For $i = 0 To ($aServerGridTotal - 1)
			If ProcessExists($aServerPID[$i]) And ($xStartGrid[$i] = "yes") Then
				$aErrorShutdown = 1
				LogWrite(" [Server (PID: " & $aServerPID[$i] & ")] Warning: Shutdown failed. Killing Process")
				ProcessClose($aServerPID[$i])
			EndIf
		Next
		If ($aErrorShutdown = 1) And ($aServerMultiHomeIP <> "") Then
			SplashOff()
			MsgBox($MB_OK, $aUtilityVer, "[Shutdown Error] The server(s) did not shut down properly." & @CRLF & "- Try removing the IP in: " & @CRLF & _
					"[Server multi-home IP (Leave blank to disable) ###]" & @CRLF & "in " & $aUtilName & ".ini. " & @CRLF & @CRLF & "(This message will disappear in 20 seconds)", 20)
		EndIf
		For $i = 0 To ($aServerGridTotal - 1)
			$aServerPID[$i] = ""
		Next
		If FileExists($aPIDServerFile) Then
			FileDelete($aPIDServerFile)
		EndIf
		If $aServerUseRedis = "yes" Then
			If $tCloseRedisTF Then
				If ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
					LogWrite(" [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
					ProcessClose($aServerPIDRedis)
				EndIf
				If FileExists($aPIDRedisFile) Then
					FileDelete($aPIDRedisFile)
				EndIf
			Else
				PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
			EndIf
		EndIf
		If $aSteamUpdateNow Then
			SteamUpdate($aSteamExtraCMD, $aSteamCMDDir, $aValidate)
		EndIf
		$aShutdown = 0
	EndIf
	LogWrite(" --------------- Server(s) shutdown sequence completed ----------")
	If $tDisableServers Then
		For $i = 0 To ($aServerGridTotal - 1)
			If ($xStartGrid[$i] = "yes") Then
				IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", "no")
				$xStartGrid[$i] = "no"
				$aGridSomeDisable = True
			EndIf
		Next
		$tDisableServers = False
	EndIf
	SplashOff()
EndFunc   ;==>CloseServer

; -----------------------------------------------------------------------------------------------------------------------

#Region ;****  Get data from ServerGrid.json ****
Func ImportConfig($tServerDirLocal, $tConfigFile)
;~ 	Local Const $sConfigPath = $tServerDirLocal & "\ShooterGame\" & $tConfigFile
	Local $sConfigPath = $aConfigFull
	LogWrite(" Importing settings from " & $sConfigPath)
	Global $xServergridx[$aServersMax]
	Global $xServergridy[$aServersMax]
	Global $xServerport[$aServersMax]
	Global $xServergameport[$aServersMax]
	Global $xServerNames[$aServersMax]
	Global $xServerseamlessDataPort[400]
	Global $xServerIP[$aServersMax]
	Local $sFileExists = FileExists($sConfigPath)
	If $sFileExists = 0 Then
		LogWrite(" !!! ERROR !!! Could not find " & $sConfigPath)
		SplashOff()
		$aContinue = MsgBox($MB_YESNO, $aConfigFile & " Not Found", "Could not find " & $sConfigPath & "." & @CRLF & "(This is normal for New Install) " & @CRLF & @CRLF & "Do you wish to continue with installation?", 60)
		If $aContinue = 7 Then
			LogWrite(" !!! ERROR !!! Could not find " & $sConfigPath & ". Program terminated by user.")
			Exit
		Else
			SplashTextOn($aUtilName, "Using temporary settings to complete the download and installation of " & $aGameName & " dedicated server." & @CRLF & @CRLF & _
					"Once installation is complete, please exit " & $aUtilName & ", copy your files into the server folder, and rerun " & $aUtilName & ".", 500, 175, -1, -1, $DLG_MOVEABLE, "")
			Global $aServerWorldFriendlyName = "TempXY"
			$xServerIP[0] = "127.0.0.1"
			$xServergridx[0] = "0"
			$xServergridy[0] = "0"
			$xServerport[0] = "48011"
			$xServergameport[0] = "48015"
			$xServerseamlessDataPort[0] = "48018"
			$xtotalGridsX = 1
			$xtotalGridsY = 1
			;			$aServerModList = ""
			$aServerModYN = "no"

		EndIf
	Else
		Local $kServerWorldFriendlyName = "WorldFriendlyName"
		Local $kServerModList = "ModIDs"
		Local $ktotalGridsX = "totalGridsX"
		Local $ktotalGridsY = "totalGridsY"

		Local $kServergridx = "gridX"
		Local $kServergridy = "gridY"
		Local $kServerip = "ip"
		Local $kServerport = "port"
		Local $kServergameport = "gamePort"
		Local $kServerNames = "name"

		Local $kServerSeamlessDataPort = "seamlessDataPort"
		Local $sConfigPathOpen = FileOpen($sConfigPath, 0)
		Local $sConfigRead = FileRead($sConfigPathOpen)
		FileClose($sConfigPathOpen)
		Local $sConfigReadServer = _ArrayToString(_StringBetween($sConfigRead, """servers"": [", "    }" & @CRLF & "  ],"))
		;Local $sConfigRead3 = StringRegExpReplace($sConfigRead4, """", "}")
		;Local $sConfigRead2 = StringRegExpReplace($sConfigRead3, "\t", "")
		;Local $sConfigRead1 = StringRegExpReplace($sConfigRead2, "  ", "")
		;Local $sConfigRead = StringRegExpReplace($sConfigRead1, " value=", "value=")

		; Items with Quotes
		$aServerModList = _ArrayToString(_StringBetween($sConfigRead, """" & $kServerModList & """: """, ""","))
		Local $xServerWorldFriendlyName = _StringBetween($sConfigRead, """" & $kServerWorldFriendlyName & """: """, """,")
		$aServerWorldFriendlyName = _ArrayToString($xServerWorldFriendlyName)
		$xServerIP = _StringBetween($sConfigReadServer, """" & $kServerip & """: """, """,")
		For $i = 0 To (UBound($xServerIP) - 1)
			$xServerIP[$i] = RemoveTrailingSlashT($xServerIP[$i])
		Next
		$xServerNames = _StringBetween($sConfigReadServer, @CRLF & "      """ & $kServerNames & """: """, """," & @CRLF & "      ""port")

		;Global $aServerip = _ArrayToString($xServerip)

		; Items without Quotes
		$xtotalGridsX = _ArrayToString(_StringBetween($sConfigRead, """" & $ktotalGridsX & """: ", ","))
		$xtotalGridsY = _ArrayToString(_StringBetween($sConfigRead, """" & $ktotalGridsY & """: ", ","))
		$xServergridx = _StringBetween($sConfigReadServer, """" & $kServergridx & """: ", ",")
		;Global $aServergridx = _ArrayToString($xServergridx)
		$xServergridy = _StringBetween($sConfigReadServer, """" & $kServergridy & """: ", ",")
		;Global $aServergridy = _ArrayToString($xServergridy)
		$xServerport = _StringBetween($sConfigReadServer, """" & $kServerport & """: ", ",")
		;Global $aServerport = _ArrayToString($xServerport)
		$xServergameport = _StringBetween($sConfigReadServer, """" & $kServergameport & """: ", ",")
		;Global $aServergameport = _ArrayToString($xServergameport)
		$xServerseamlessDataPort = _StringBetween($sConfigRead, """" & $kServerSeamlessDataPort & """: ", ",")
;~ 		Global $aServerseamlessDataPort = _ArrayToString($xServerseamlessDataPort)
;~ 		$aServerseamlessDataPort = RemoveTrailingSlashT($aServerseamlessDataPort)
		FileClose($sConfigRead)
	EndIf
	If $aServerModList = "" Then
		If $aServerModYN = "yes" Then
			LogWrite(" [MOD] NOTICE: ""Use this util to install mods and check for mod updates""=yes in " & $aUtilName & ".ini but no mods were listed in " & $aConfigFile & ".")
		EndIf
		$aServerModYN = "no"
	Else
		$xServerModList = StringSplit($aServerModList, ",")
	EndIf
	Global $aServerGridTotal = Int($xtotalGridsX) * Int($xtotalGridsY)
EndFunc   ;==>ImportConfig
#EndRegion ;****  Get data from ServerGrid.json ****

Func _CheckForDuplicatePorts()
	FileDelete($aDuplicateErrorFile)
	Global $aDupError = False
	;	Local $aTxt = "WARNING!!! The following are duplicate entries in your " & $aConfigFile & " file." & @CRLF & "The following list contains a separate entry [Paramater:Duplicate] for each duplicate." & @CRLF & @CRLF
	Local $aTxt = "WARNING!!! The following ports are used more than once!" & @CRLF & @CRLF & "Duplicates within the " & $aConfigFile & " file (if any):" & @CRLF
	$aTxt &= "----- Duplicate Ports in Same Category -----" & @CRLF
	$aTxt &= _ConfigCheckForDuplicates($xServerport, "Query Port")
	$aTxt &= _ConfigCheckForDuplicates($xServergameport, "Port")
	$aTxt &= _ConfigCheckForDuplicates($xServerseamlessDataPort, "SeamlessDataPort")
	$aTxt &= @CRLF & "----- Duplicate RCON Ports in " & $aUtilName & ".ini File -----" & @CRLF
	$aTxt &= _ConfigCheckForDuplicates($xServerRCONPort, "RCON Port")
	$aTxt &= @CRLF & "----- Duplicate Ports in Same & Multiple Categories -----" & @CRLF
	Local $xAllPortsArray = $xServerport
	_ArrayConcatenate($xAllPortsArray, $xServerRCONPort)
	_ArrayConcatenate($xAllPortsArray, $xServergameport)
	_ArrayConcatenate($xAllPortsArray, $xServerseamlessDataPort)
	$aTxt &= _ConfigCheckForDuplicates($xAllPortsArray, "(Query/RCON/Port/SeamlessDataPort)")
	$aTxt &= @CRLF & "Click (OK) to exit util."
	If $aDupError Then
		SplashOff()
		MsgBox($MB_OK, $aUtilName, $aTxt)
		FileWrite($aDuplicateErrorFile, $aTxt)
		Run("notepad.exe " & $aDuplicateErrorFile)
		Run("notepad.exe " & $aConfigFull)
		Exit
	EndIf

EndFunc   ;==>_CheckForDuplicatePorts

Func _ConfigCheckForDuplicates($tArray, $tParameter)
	Local $tTxt = ""
	Local $aArray = _ArrayDuplicates($tArray)
	If UBound($aArray) > 0 Then
		;Local $tTxt = "WARNING!!! There are duplicate entries in your " & $aConfigFile & " file." & @CRLF & "The following list contains a separate entry [Paramater:Duplicate] for each duplicate." & @CRLF & @CRLF
		For $i = 0 To (UBound($aArray) - 1)
			If $aArray[$i] <> "" Then
				$tTxt &= $tParameter & ":" & $aArray[$i] & @CRLF
				$aDupError = True
			EndIf
		Next
		;		$tTxt &= @CRLF & "Click (OK) to exit util."
		;		SplashOff()
		;		MsgBox($MB_OK, $aUtilName, $tTxt)
		;		Run("notepad.exe " & $aConfigFull)
		;		Exit
	EndIf
	Return $tTxt
EndFunc   ;==>_ConfigCheckForDuplicates

Func _ArrayDuplicates($aArray, $tAddCountToArrayZero = False)  ; Modified version of Melba23's script: https://www.autoitscript.com/forum/topic/164666-get-duplicate-from-array/
	; Create dictionary
	Local $oDict = ObjCreate("Scripting.Dictionary")
	Local $vElem
	; Loop through array
	For $i = 0 To UBound($aArray) - 1
		; Extract element
		$vElem = $aArray[$i]
		; Check if already in dictionary
		If $oDict.Exists($vElem) Then
			; Increase count
			$oDict($vElem) = $oDict($vElem) + 1
		Else
			; Add to dictionary
			$oDict.Item($vElem) = 1
		EndIf
	Next
	; Create return array large enough for all elements
	If $tAddCountToArrayZero Then
		Local $aRet[UBound($aArray) + 1], $iIndex = 0
		; Loop through dictionary and transfer multiple elements to return array
		For $vKey In $oDict
			; Get count
			$iCount = $oDict($vKey)
			; if more than 1
			If $iCount > 1 Then
				; Add as many as required
				For $i = 1 To $iCount
					$iIndex += 1
					$aRet[$iIndex] = $vKey
				Next
			EndIf
		Next
		; Add count to [0]element
		$aRet[0] = $iIndex
		; Remove ampty elements of return array
		ReDim $aRet[$iIndex + 1] ; You need this one ReDim, honest!!! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	Else
		Local $aRet[UBound($aArray)], $iIndex = 0
		For $vKey In $oDict
			$iCount = $oDict($vKey)
			If $iCount > 1 Then
				For $i = 1 To $iCount
					$aRet[$iIndex] = $vKey
					$iIndex += 1
				Next
			EndIf
		Next
		ReDim $aRet[$iIndex] ; You need this one ReDim, honest!!! <<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<
	EndIf
	Return $aRet
EndFunc   ;==>_ArrayDuplicates

; -----------------------------------------------------------------------------------------------------------------------

#Region ;****  Get data from GameUserSettings.ini ****
Func ImportRCON($zServerDirLocal, $zServerAltSaveDir, $zServerGridTotal, $zStartGrid)
	Local $tFilePath[$zServerGridTotal + 1]
	Global $hRCON[$zServerGridTotal + 1]
	$hRCON[0] = $zServerGridTotal
	LogWrite(" Importing RCON ports from GameUserSettings.ini files")
	If UBound($zServerAltSaveDir) < $zServerGridTotal Then
		SplashOff()
		MsgBox($MB_OK, $aUtilityVer, "!!! ERROR !!! Number of AltSaveDIR in " & $aUtilName & ".ini does not match actual folders available." & @CRLF & _
				"Please ensure your AltSaveFolders is correct in " & $aUtilName & ".ini and restart " & $aUtilName & ".")
		Exit
	EndIf
	For $i = 1 To ($zServerGridTotal)
		If ($zStartGrid[$i - 1] = "yes") Then
			$tFilePath[$i] = $zServerDirLocal & "\ShooterGame\Saved\" & $zServerAltSaveDir[$i - 1] & "\Config\WindowsServer\GameUserSettings.ini"
			Local $sFileExists = FileExists($tFilePath[$i])
			If ($sFileExists = 0) And ($aServerWorldFriendlyName <> "TempXY") Then
				Local $aErrorMsg = "!!! ERROR !!! Could not find " & $tFilePath[$i] & "."
				LogWrite($aErrorMsg)
				SplashOff()
				MsgBox($MB_OK, $aUtilityVer, $aErrorMsg & @CRLF & "Please ensure your AltSaveFolders is correct in " & $aUtilName & ".ini and restart " & $aUtilName & ".")
				Exit
			Else
				Local $hFileOpen = FileOpen($tFilePath[$i], 0)
				Local $hFileRead1 = FileRead($hFileOpen)
				If $hFileOpen = -1 Then
					$hRCON[0] = False
				Else
					$hRCON[$i] = _ArrayToString(_StringBetween($hFileRead1, "RCONPort=", @CRLF))
					If $hRCON[$i] < 1 Then
						Local $aErrorMsg = "!!! ERROR !!! RCON Port not assigned in  " & $tFilePath[$i] & "."
						LogWrite($aErrorMsg)
						SplashOff()
						MsgBox($MB_OK, $aUtilityVer, $aErrorMsg & @CRLF & "Please add RCONEnabled=True and RCONPort=[port] to GameUserSettings.ini" & @CRLF & "OR add RCON ports to " & $aUtilName & ".ini and restart " & $aUtilName & ".")
						;$hRCON[0] = False
						Exit
					EndIf
					;					If $xDebug Then
					LogWrite("", " Server: " & $i & " , RCON Port:" & $hRCON[$i])
					;					EndIf
				EndIf
			EndIf
			FileClose($hFileOpen)
		EndIf
	Next
	Return $hRCON
EndFunc   ;==>ImportRCON
#EndRegion ;****  Get data from GameUserSettings.ini ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Start Server Selection ****
Func GridStartSelect($sGridFile, $sLogFile, $tWizardTF = False)
	Global $xStartGrid[$aServerGridTotal + 1]
	Global $xLocalGrid[$aServerGridTotal + 1]
	Global $aGridSomeDisable = False
	Global $aGridIniTitle[3]
	Local $tServerGridExtraCMD = False
	$aGridIniTitle[0] = " --------------- RUN THE FOLLOWING GRID SERVER(S) (yes/no) --------------- "
	$aGridIniTitle[1] = " --------------- LOCAL GRID SERVER(S) (yes-Local, no-Remote) (yes/no) --------------- "
	$aGridIniTitle[2] = " --------------- EXTRA COMMANDLINE PARAMETERS PER GRID SERVER --------------- "
	Local $iIniError = ""
	Local $iIniFail = 0
	Local $iniCheck = ""
	Local $aChar[3]
	For $i = 1 To 13
		$aChar[0] = Chr(Random(97, 122, 1))     ;a-z
		$aChar[1] = Chr(Random(48, 57, 1))     ;0-9
		$iniCheck &= $aChar[Random(0, 1, 1)]
	Next
	For $i = 0 To ($aServerGridTotal - 1)
		$xStartGrid[$i] = IniRead($sGridFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", $iniCheck)
		If $xStartGrid[$i] = "no" Then
			$aGridSomeDisable = True
		EndIf

		If $iniCheck = $xStartGrid[$i] Then
			$xStartGrid[$i] = "yes"
			$iIniFail += 1
			;		$iIniError = $iIniError & $xStartGrid[$i] & ", "
		EndIf
	Next
	For $i = 0 To ($aServerGridTotal - 1)
		$xLocalGrid[$i] = IniRead($sGridFile, $aGridIniTitle[1], "Is Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") Local (yes/no)", $iniCheck)
		If $xLocalGrid[$i] = "no" Then
			$aGridSomeDisable = True
		EndIf
		If $iniCheck = $xLocalGrid[$i] Then
			$xLocalGrid[$i] = "yes"
			$iIniFail += 1
			;$iIniError = $iIniError & $xStartGrid[$i] & ", "
		EndIf
	Next
	For $i = 0 To ($aServerGridTotal - 1)
		$xServerGridExtraCMD[$i] = IniRead($sGridFile, $aGridIniTitle[2], "Add to Commandline for Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ")", $iniCheck)
		If $iniCheck = $xServerGridExtraCMD[$i] Then
			$sGridIniReWrite = True
			$xServerGridExtraCMD[$i] = ""
			$tServerGridExtraCMD = True
			;			$iIniFail += 1
		EndIf
		If StringLeft($xServerGridExtraCMD[$i], 1) = "-" Then
			$xServerGridExtraCMD[$i] = " " & $xServerGridExtraCMD[$i]
		EndIf
;~ 		If $xServerGridExtraCMD[$i] = "no" Then
;~ 			$aGridSomeDisable = True
;~ 		EndIf
	Next
	If $tServerGridExtraCMD Then $iIniError = $iIniError & "Extra Commandline per Grid Server, "
	If $iIniFail > 0 Or $sGridIniReWrite Then
		GridFileStartCheck($sGridFile, $iIniFail, $iIniError, $tWizardTF)
	EndIf
EndFunc   ;==>GridStartSelect
Func GridFileStartCheck($sGridFile, $iIniFail, $tIniError, $tWizardTF = False)
	If FileExists($sGridFile) Then
		Local $aMyDate, $aMyTime
		_DateTimeSplit(_NowCalc(), $aMyDate, $aMyTime)
;~ 		Local $iniDate = StringFormat("%04i.%02i.%02i.%02i%02i", $aMyDate[1], $aMyDate[2], $aMyDate[3], $aMyTime[1], $aMyTime[2])
;~ 		FileMove($sGridFile, $sGridFile & "_" & $iniDate & ".bak", 1)
		Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
		Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
		FileMove($aGridSelectFile, $tFile, 1)
		UpdateGridSelectINI($sGridFile)
		LogWrite(" " & $sGridFile & " needs updating. Found " & $iIniFail & " server change(s). Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		;		LogWrite(" " & $sGridFile & " needs updating. Parameters missing: " & $iIniError)
		If $sGridIniReWrite Then
			For $i = 1 To 6
				ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "!!NOTICE!! GridStartSelect.ini has new or changed parameter:" & @CRLF & StringTrimRight($tIniError, 2))
				Sleep(1000)
				ControlSetText($aSplashStartUp, "", "Static1", $aStartText)
				Sleep(250)
			Next
		Else
			SplashOff()
			Run("notepad " & $sGridFile, @WindowsDir)
			MsgBox(4096, $aUtilityVer, "GridStartSelect.ini needs updating. " & @CRLF & "- Found " & $iIniFail & " server change(s). " & @CRLF & @CRLF & "Backup created and all existing settings transfered to new INI." & @CRLF & @CRLF & "Please modify INI and restart.", 15)
			Exit
		EndIf
	Else
		UpdateGridSelectINI($sGridFile)
		If $tWizardTF Then
		Else
			SplashOff()
			Run("notepad " & $sGridFile, @WindowsDir)
			MsgBox(4096, $aUtilityVer, "Default GridStartSelect.ini file created." & @CRLF & @CRLF & "If you plan to run all grid servers, no change is needed. " & @CRLF & @CRLF & "If you want to only run selected grid servers or have remote servers, please modify the default values and restart program.")
			LogWrite(" Default " & $sGridFile & " file created. If you want to only run selected grid server(s), please modify the default values and restart program.")
			Exit
		EndIf
	EndIf
EndFunc   ;==>GridFileStartCheck
Func UpdateGridSelectINI($sGridFile)
	;	FileWriteLine($sIniFile, "[ --------------- " & StringUpper($aUtilName) & " INFORMATION --------------- ]")
	For $i = 0 To ($aServerGridTotal - 1)
		IniWrite($sGridFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", $xStartGrid[$i])
	Next
	FileWriteLine($sGridFile, @CRLF)
	For $i = 0 To ($aServerGridTotal - 1)
		IniWrite($sGridFile, $aGridIniTitle[1], "Is Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") Local (yes/no)", $xLocalGrid[$i])
	Next
	FileWriteLine($sGridFile, @CRLF)
	FileWriteLine($sGridFile, "!! Extra commandline parameters used IN ADDITION to the existing parameters set in the " & $aUtilName & ".ini file.")
	FileWriteLine($sGridFile, "!! Existing parameters: " & $aServerExtraCMD)
	For $i = 0 To ($aServerGridTotal - 1)
		IniWrite($sGridFile, $aGridIniTitle[2], "Add to Commandline for Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ")", $xServerGridExtraCMD[$i])
	Next

EndFunc   ;==>UpdateGridSelectINI
#EndRegion ;**** Start Server Selection ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Fail Count Announce ****
Func FailCountRun()
	LogWrite(" [--== CRITICAL ERROR! ==-- ] The " & $aGameName & " Dedicated Server (" & $aServerEXE & ") failed to start at least twice within 1 minute. Please check " & $aGameName & " config files and " & $aUtilName & ".ini file")
	CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, True, False)
	MsgBox($MB_OK, $aUtilityVer, "[CRITICAL ERROR!] The " & $aGameName & " Dedicated Server (" & $aServerEXE & ") failed to start at least twice within 1 minute. " & @CRLF & @CRLF & "Please check " & $aGameName & " config files and " & $aUtilName & ".ini file and restart " & $aUtilName & ".")
	Exit
EndFunc   ;==>FailCountRun
#EndRegion ;**** Fail Count Announce ****

#Region ;**** Function to Send Message to Discord ****
;~ Func _Discord_ErrFunc($oError)
;~ 	LogWrite(" [Discord] Error: 0x" & Hex($oError.number) & " While Sending Discord Bot Message.")
;~ EndFunc   ;==>_Discord_ErrFunc

Func SendDiscordMsg($sHookURLs, $sBotMessage, $sBotName = "", $sBotTTS = False, $sBotAvatar = "", $aServerPID = "0")
;~ 	Local $oErrorHandler = ObjEvent("AutoIt.Error", "_Discord_ErrFunc")
	Local $tObjErrFunc = $aObjErrFunc
	$aObjErrFunc = "Discord"
	Local $sJsonMessage = '{"content" : "' & $sBotMessage & '", "username" : "' & $sBotName & '", "tts" : "' & $sBotTTS & '", "avatar_url" : "' & $sBotAvatar & '"}'
	Local $oHTTPOST = ObjCreate("WinHttp.WinHttpRequest.5.1")
	$oHTTPOST.Open("POST", StringStripWS($sHookURLs, 2) & "?wait=true", False)
	$oHTTPOST.Option($WinHttpRequestOption_SslErrorIgnoreFlags) = $WinHttpRequestOption_SslErrorIgnoreFlags_IgnoreAll     ;Kim!! Test code
;~ 	$oHTTPOST.setOption(2, 0x3300)   ;<== Modified
	$oHTTPOST.SetRequestHeader("Content-Type", "application/json")
	$oHTTPOST.Send($sJsonMessage)
	Local $oStatusCode = $oHTTPOST.Status
	LogWrite(" [Discord] Message sent: " & $sBotMessage, " [Discord] Message Status Code {" & $oStatusCode & "} " & "Message Response: " & $oHTTPOST.ResponseText)
	$aObjErrFunc = $tObjErrFunc
EndFunc   ;==>SendDiscordMsg
#EndRegion ;**** Function to Send Message to Discord ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Send In-Game Message via MCRCON ****
Func SendInGame($mIP, $mPort, $mPass, $mMessage)

	For $i = 0 To ($aServerGridTotal - 1)
		If ($xStartGrid[$i] = "yes") Then
			If $aServerRCONIP = "" Then
				Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $xServerIP[$i] & ' -P ' & $xServerRCONPort[$i + 1] & ' -p ' & $mPass & " """ & $aRCONBroadcastCMD & " " & $mMessage & """"
			Else
				Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $aServerRCONIP & ' -P ' & $xServerRCONPort[$i + 1] & ' -p ' & $mPass & " """ & $aRCONBroadcastCMD & " " & $mMessage & """"
			EndIf
			;			If $xDebug Then
			LogWrite("", " [RCON In-Game Message] " & $aMCRCONcmd)
			;			EndIf
			;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
			Run($aMCRCONcmd, @ScriptDir, @SW_HIDE)
		EndIf
	Next
	;	If $xDebug Then
	;	Else
	LogWrite(" [RCON In-Game Message Sent] " & $mMessage, "no")     ; "no" = do not write to debug log file
	;	EndIf

	;	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & " """ & $aRCONBroadcastCMD & " " & $mMessage & """"
	;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)


	;	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $aServerIP & ' -P ' & $aServer00RCONPort & ' -p ' & $mPass & " """ & $aRCONBroadcastCMD & " " & $mMessage & """"
	;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
	;	If $xDebug Then
	;		LogWrite(" [RCON In-Game Message] " & $aMCRCONcmd)
	;	Else
	;		LogWrite(" [RCON In-Game Message Sent] " & $mMessage)
	;	EndIf
EndFunc   ;==>SendInGame
#EndRegion ;**** Send In-Game Message via MCRCON ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Send RCON Command via MCRCON ****
Func SendRCON($mIP, $mPort, $mPass, $mCommand, $mLogYN = "yes")
	;	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $aServerIP & ' -P ' & $aServer00RCONPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	;RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
	;For $i = 0 to ($aServerGridTotal - 1)
	If $aServerRCONIP = "" Then
		Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	Else
		Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $aServerRCONIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	EndIf
	;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
	Run($aMCRCONcmd, @ScriptDir, @SW_HIDE)
	If $aErrorShutdown = 0 Then
		;		If $xDebug Then
		;			LogWrite(" [RCON] " & $aMCRCONcmd)
		;		Else
		If $mLogYN = "yes" Then
			If $aServerRCONIP = "" Then
				LogWrite(" [RCON] IP: " & $mIP & ". Port:" & $mPort & ". Command:" & $mCommand, " [RCON] " & $aMCRCONcmd)
			Else
				LogWrite(" [RCON] IP: " & $aServerRCONIP & ". Port:" & $mPort & ". Command:" & $mCommand, " [RCON] " & $aMCRCONcmd)
			EndIf
		Else
			LogWrite("", " [RCON] " & $aMCRCONcmd)
		EndIf
		;		EndIf
	EndIf

	;	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	;	If $xDebug Then
	;		LogWrite(" [RCON] " & $aMCRCONcmd)
	;	Else
	;		LogWrite(" [RCON] Port:" & $mPort & ". Command:" & $mCommand)
	;	EndIf
	;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
EndFunc   ;==>SendRCON
#EndRegion ;**** Send RCON Command via MCRCON ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Functions to Check for Update ****

Func UpdateCheck($tAsk, $tSplash = 0, $tShow = True)
;~ 	GUICtrlSetImage($IconReady, $aIconFile, 203)
;~ 	GUICtrlSetData($LabelUtilReadyStatus, "Check: Server Update")
;~ 	Local $bUpdateRequired = False
	$aSteamUpdateNow = False
	If $aUpdateSource = "1" Then
		If ($aFirstBoot Or $tAsk) And $tShow Then
			Local $tTxt = $aStartText & "Acquiring latest buildid from SteamDB." & @CRLF & "Please wait up to 2 minutes."
			If $tSplash > 0 Then
				ControlSetText($tSplash, "", "Static1", $tTxt)
			Else
				SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			EndIf
;~ 			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & @CRLF & @CRLF & "Acquiring latest buildid from SteamDB.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
		EndIf
		Local $aLatestVersion = GetLatestVerSteamDB($aSteamAppID, $aServerVer)
	Else
		If ($aFirstBoot Or $tAsk) And $tShow Then
			Local $tTxt = $aStartText & "Acquiring latest buildid from SteamCMD." & @CRLF & "Please wait up to 2 minutes."
			If $tSplash > 0 Then
				ControlSetText($tSplash, "", "Static1", $tTxt)
			Else
				SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			EndIf
;~ 			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & @CRLF & @CRLF & "Acquiring latest buildid from SteamCMD." & @CRLF & "This can take a minute or two. Please wait...", 400, 110, -1, -1, $DLG_MOVEABLE, "")
		EndIf
		Local $aLatestVersion = GetLatestVersion($aSteamCMDDir)
	EndIf
	If ($aFirstBoot Or $tAsk) And $tShow Then
		Local $tTxt = $aStartText & "Retrieving installed version buildid." & @CRLF & "Please wait up to 2 minutes."
		If $tSplash > 0 Then
			ControlSetText($tSplash, "", "Static1", $tTxt)
		Else
			SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
		EndIf
;~ 		SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & @CRLF & @CRLF & "Retrieving installed version buildid.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	EndIf
	Local $aInstalledVersion = GetInstalledVersion($aServerDirFull)
	IniWrite($aUtilCFGFile, "CFG", "aCFGLastUpdate", _NowCalc())
	If $tSplash = 0 Then
		SplashOff()
	EndIf
	If ($aLatestVersion[0] And $aInstalledVersion[0]) Then
		If StringCompare($aLatestVersion[1], $aInstalledVersion[1]) = 0 Then
			$aSteamRunCount = 0
			LogWrite(" [Update] Server is Up to Date. Installed Version: " & $aInstalledVersion[1] & " Latest Version: " & $aLatestVersion[1])
			If $tAsk Then
				SplashOff()
				$tMB = MsgBox($MB_OK, $aUtilityVer, "Server is Up to Date." & @CRLF & @CRLF & "Installed Version: " & $aInstalledVersion[1] & @CRLF & "   Latest Version: " & $aLatestVersion[1], 5)
			EndIf
		Else
			LogWrite(" [Update] Server is Out of Date! Installed Version: " & $aInstalledVersion[1] & " Latest Version: " & $aLatestVersion[1])
			If $tAsk Then
				SplashOff()
;~ 				$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Server is Out of Date!!!" & @CRLF & @CRLF & "Installed Version: " & $aInstalledVersion[1] & @CRLF & "   Latest Version: " & $aLatestVersion[1] & @CRLF & @CRLF & _
;~ 						"Click (YES) to update server." & @CRLF & _
;~ 						"Click (NO) or (CANCEL) to continue without updating.", 15)
				If (($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes")) Then
					Local $aMsg = "Server is Out of Date! Installed Version: " & $aInstalledVersion[1] & " Latest Version: " & $aLatestVersion[1] & @CRLF & @CRLF & _
							"Click (YES) to update " & $aGameName & " NOW with -validate." & @CRLF & _
							"Click (NO) to start update announcements (Discord, In-Game, and/or Twitch), then update." & @CRLF & _
							"Click (CANCEL) to cancel."
				Else
					Local $aMsg = "Server is Out of Date! Installed Version: " & $aInstalledVersion[1] & " Latest Version: " & $aLatestVersion[1] & @CRLF & @CRLF & _
							"Click (YES) to update " & $aGameName & " NOW with -validate." & @CRLF & _
							"Click (NO) or (CANCEL) to cancel."
				EndIf
				SplashOff()
				$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 60)
				; ----------------------------------------------------------
				If $tMB = 6 Then     ; YES
					$bUpdateRequired = True
					$aSteamUpdateNow = True
					$aUpdateVerify = "yes"
					RunExternalScriptUpdate()
					$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
					SteamcmdDelete($aSteamCMDDir)
					CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)
					; ----------------------------------------------------------
				ElseIf ($tMB = 7) And (($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes")) Then
					$bUpdateRequired = True
					$aSteamUpdateNow = True
					$aUpdateVerify = "yes"
					RunExternalScriptUpdate()
					$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
					$aBeginDelayedShutdown = 1
					$aRebootReason = "update"
				Else
					SplashTextOn($aUtilName, "Utility update check canceled by user." & @CRLF & "Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
				EndIf
			Else
				If $aFirstBoot Then
					Local $tTxt = $aStartText & "Server is Out of Date! Updating server." & @CRLF & "Installed Version: " & $aInstalledVersion[1] & ", Latest: " & $aLatestVersion[1]
					If $tSplash > 0 Then
						ControlSetText($tSplash, "", "Static1", $tTxt)
					Else
						SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
					EndIf
					Sleep(4000)
				EndIf

				If ($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes") Then
					$bUpdateRequired = True
					$aSteamUpdateNow = True
					$aUpdateVerify = "yes"
					RunExternalScriptUpdate()
					$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
					$aBeginDelayedShutdown = 1
					$aRebootReason = "update"
				Else
					$bUpdateRequired = True
					$aSteamUpdateNow = True
					$aUpdateVerify = "yes"
					RunExternalScriptUpdate()
					$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
					SteamcmdDelete($aSteamCMDDir)
					CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)
				EndIf
;~ 				$bUpdateRequired = True
;~ 				$aSteamUpdateNow = True
;~ 				$aUpdateVerify = "yes"
;~ 				RunExternalScriptUpdate()
;~ 				$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
;~ 				SteamcmdDelete($aSteamCMDDir)
;~ 				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
;~ 					SplashOff()
;~ 					SplashTextOn($aUtilName, "Server is Out of Date!" & @CRLF & "Installed Version: " & $aInstalledVersion[1] & @CRLF & "Latest Version: " & $aLatestVersion[1] & @CRLF & "Updating server . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
;~ 				EndIf
;~ 				$bUpdateRequired = True
;~ 				$aSteamUpdateNow = True
;~ 				$aUpdateVerify = "yes"
;~ 				RunExternalScriptUpdate()
;~ 				$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
;~ 				Local $sManifestExists = FileExists($aSteamAppFile)
				;			If $sManifestExists = 1 Then
				;				FileMove($aSteamAppFile, $aServerDirLocal & "\steamapps\appmanifest_" & $aSteamAppID & "_" & $TimeStamp & ".acf", 1)
				;				If $xDebug Then
				;					LogWrite(" Notice: """ & $aSteamAppFile & """ renamed to ""appmanifest_" & $aSteamAppID & "_" & $TimeStamp & ".acf""")
				;				EndIf
				;			EndIf
			EndIf
		EndIf
	ElseIf Not $aLatestVersion[0] And Not $aInstalledVersion[0] Then
		LogWrite(" [Update] Something went wrong retrieving Latest & Installed Versions. Running update with -validate")
		SplashTextOn($aUtilName, "Something went wrong retrieving Latest & Installed Versions." & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 500, 125, -1, -1, $DLG_MOVEABLE, "")
		$bUpdateRequired = True
		$aSteamUpdateNow = True
		$aUpdateVerify = "yes"
		RunExternalScriptUpdate()
		$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
		SteamcmdDelete($aSteamCMDDir)
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)

	ElseIf Not $aInstalledVersion[0] Then
		LogWrite(" [Update] Something went wrong retrieving Installed Version. Running update with -validate. (This is normal for new install)")
		SplashTextOn($aUtilName, "Something went wrong retrieving Installed Version." & @CRLF & "(This is normal for new install)" & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 450, 175, -1, -1, $DLG_MOVEABLE, "")
		$bUpdateRequired = True
		$aSteamUpdateNow = True
		$aUpdateVerify = "yes"
		RunExternalScriptUpdate()
		$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
		SteamcmdDelete($aSteamCMDDir)
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)

	ElseIf Not $aLatestVersion[0] Then
		LogWrite(" [Update] Something went wrong retrieving Latest Version.  Skipping this update check.")
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Something went wrong retrieving Latest Version. " & @CRLF & @CRLF & _
				"Click (YES) to update " & $aGameName & " NOW with -validate." & @CRLF & _
				"Click (NO) or (CANCEL) to cancel." & @CRLF & @CRLF & "(This window will close in 5 seconds)", 15)
		If $tMB = 6 Then
			$bUpdateRequired = True
			$aSteamUpdateNow = True
			$aUpdateVerify = "yes"
			RunExternalScriptUpdate()
			$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
			SteamcmdDelete($aSteamCMDDir)
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)
		Else
			SplashTextOn($aUtilName, "Utility update check canceled by user." & @CRLF & "Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
			SplashOff()
		EndIf
		;		$aUpdateVerify = "yes"
		;		$aSteamFailedTwice = True
		;		$bUpdateRequired = True
	EndIf
;~ 	Return $bUpdateRequired
EndFunc   ;==>UpdateCheck

;**** Retreive latest build ID from SteamDB ****
Func GetLatestVerSteamDB($bSteamAppID, $bServerVer)
	Local $aReturn[2] = [False, ""]
	If $bServerVer = 0 Then
		Local $aURL = $aSteamDBURLPublic
		Local $aBranch = "stable"
	Else
		Local $aURL = $aSteamDBURLExperimental
		Local $aBranch = "experimental"
	EndIf
	$aSteamDB1 = _IECreate($aURL, 0, 0)
	$aSteamDB = _IEDocReadHTML($aSteamDB1)
	_IEQuit($aSteamDB1)
	FileWrite($aFolderTemp & "SteamDB.tmp", $aSteamDB)

	Local Const $sFilePath = $aFolderTemp & "SteamDB.tmp"
	Local $hFileOpen = FileOpen($sFilePath, 0)
	Local $hFileRead1 = FileRead($hFileOpen)
	If $hFileOpen = -1 Then
		$aReturn[0] = False
	Else
		Local $xBuildID = _ArrayToString(_StringBetween($hFileRead1, "buildid:</i> <b>", "</b></li><li><i>timeupdated"))
		Local $hBuildID = Int($xBuildID)
		LogWrite("", " [Update] Using SteamDB " & $aBranch & " branch. Latest version: " & $hBuildID)
	EndIf
	FileClose($hFileOpen)
	If $hBuildID < 100000 Then
		SplashOff()
		MsgBox($mb_ok, "ERROR", " [Update] Error retrieving buildid via SteamDB website. Please visit:" & @CRLF & @CRLF & $aURL & @CRLF & @CRLF & _
				"in *Internet Explorer* (NOT Chrome.. must be Internet Explorer) to CAPTCHA authorize your PC or use SteamCMD for updates." & @CRLF & "! Press OK to close " & $aUtilName & " !")
		LogWrite("Error retrieving buildid via SteamDB website. Please visit:" & $aURL & _
				"in **Internet Explorer** (NOT Chrome.. must be Internet Explorer) to CAPTCHA authorize your PC or use SteamCMD for updates.")
	EndIf
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	$aReturn[0] = True
	$aReturn[1] = $hBuildID
	Return $aReturn
EndFunc   ;==>GetLatestVerSteamDB

Func GetLatestVersion($sCmdDir)
	$hBuildID = "0"
	Local $aReturn[2] = [False, ""]
	DirRemove($sCmdDir & "\appcache", 1)
	DirRemove($sCmdDir & "\depotcache", 1)
	$sAppInfoTemp = "app_info_" & StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_") & ".tmp"
	$aSteamUpdateCheck = '"' & @ComSpec & '" /c "' & $sCmdDir & "\steamcmd.exe"" +login anonymous +app_info_update 1 +app_info_print " & $aSteamAppID & " +app_info_print " & $aSteamAppID & " +app_info_print " & $aSteamAppID & " +exit > " & $sAppInfoTemp
	$Timer = TimerInit()
	; -------------------
	Local $tPID = Run($aSteamUpdateCheck, $aSteamCMDDir, @SW_MINIMIZE)
	Do
		If Not ProcessExists($tPID) Then ExitLoop
		Sleep(500)
	Until TimerDiff($Timer) > 20000
	If ProcessExists($tPID) Then
		ProcessClose($tPID)
	EndIf
	; -------------------
	Local Const $sFilePath = $sCmdDir & "\" & $sAppInfoTemp
	Local $hFileOpen = FileOpen($sFilePath, 0)
	Local $hFileRead1 = FileRead($hFileOpen)
	If $hFileOpen = -1 Then
		;		$aSteamRunCount = $aSteamRunCount + 1
		;		If $aSteamRunCount = 3 Then
		$aReturn[0] = False
		;		Else
		;			$aReturn[0] = True
		LogWrite(" [Update] SteamCMD update check FAILED to create update file. Skipping this update check.")
		;		EndIf
	Else
		;	Local $aString = _ArrayToString($hFileOpen)
		If StringInStr($hFileRead1, "buildid") > 0 Then
			Local $hFileReadArray = _StringBetween($hFileRead1, "branches", "AppID")
			Local $hFileRead = _ArrayToString($hFileReadArray)
			If $aServerVer = 0 Then
				Local $hString1 = _StringBetween($hFileRead, "public", "timeupdated")
			Else
				Local $hString1 = _StringBetween($hFileRead, $aExperimentalString, "timeupdated")
			EndIf
			Local $hString2 = StringSplit($hString1[0], '"', 2)
			$hString3 = _ArrayToString($hString2)
			Local $hString4 = StringRegExpReplace($hString3, "\t", "")
			Local $hString5 = StringRegExpReplace($hString4, @CR & @LF, ".")
			Local $hString6 = StringRegExpReplace($hString5, "{", "")
			Local $hBuildIDArray = _StringBetween($hString6, "buildid||", "|.")
			Local $hBuildID = _ArrayToString($hBuildIDArray)
			If $aServerVer = 0 Then
				LogWrite("", " [Update] Update Check via Stable Branch. Latest version: " & $hBuildID)
			EndIf
			If $aServerVer = 1 Then
				LogWrite("", " [Update] Update Check via Experimental Branch. Latest version: " & $hBuildID)
			EndIf
			If FileExists($sFilePath) Then
				FileDelete($sFilePath)
			EndIf
			$aReturn[0] = True
		Else
			;			$aSteamRunCount = $aSteamRunCount + 1
			;			If $aSteamRunCount = 3 Then
			$aReturn[0] = False
			;			Else
			LogWrite(" [Update] SteamCMD update check returned a FAILURE response. Skipping this update check.")
			;				$aReturn[0] = True
			;			EndIf
		EndIf
		FileClose($hFileOpen)
	EndIf
	$aReturn[1] = $hBuildID
	Return $aReturn
EndFunc   ;==>GetLatestVersion

Func GetInstalledVersion($sGameDir)
	Local $aReturn[2] = [False, ""]
	Local Const $sFilePath = $aSteamAppFile
	Local $hFileOpen = FileOpen($sFilePath, 0)
	If $hFileOpen = -1 Then
		$aReturn[0] = False
	Else
		Local $sFileRead = FileRead($hFileOpen)
		FileClose($hFileOpen)
		$aReturn[0] = True
		$aReturn[1] = _ArrayToString(_StringBetween($sFileRead, "buildid""" & @TAB & @TAB & """", """"))
		#cs		Local $aAppInfo = StringSplit($sFileRead, '"buildid"', 1)
		
			If UBound($aAppInfo) >= 3 Then
			$aAppInfo = StringSplit($aAppInfo[2], '"buildid"', 1)
			EndIf
			If UBound($aAppInfo) >= 2 Then
			$aAppInfo = StringSplit($aAppInfo[1], '"LastOwner"', 1)
			EndIf
			If UBound($aAppInfo) >= 2 Then
			$aAppInfo = StringSplit($aAppInfo[1], '"', 1)
			EndIf
			If UBound($aAppInfo) >= 2 Then
			$aReturn[0] = True
			$aReturn[1] = $aAppInfo[2]
			EndIf
		
			If FileExists($sFilePath) Then
			FileClose($hFileOpen)
			EndIf
		#ce		Local $aAppInfo = StringSplit($sFileRead, '"buildid"', 1)
	EndIf
	Return $aReturn
EndFunc   ;==>GetInstalledVersion
#EndRegion ;**** Functions to Check for Update ****

; -----------------------------------------------------------------------------------------------------------------------

Func DailyRestartCheck($sWDays, $sHours, $sMin)
	Local $iDay = -1
	Local $iHour = -1
	Local $aDays = StringSplit($sWDays, ",")
	Local $aHours = StringSplit($sHours, ",")
	For $d = 1 To $aDays[0]
		$iDay = StringStripWS($aDays[$d], 8)
		If Int($iDay) = Int(@WDAY) Or Int($iDay) = 0 Then
			For $h = 1 To $aHours[0]
				$iHour = StringStripWS($aHours[$h], 8)
				If Int($iHour) = Int(@HOUR) And Int($sMin) = Int(@MIN) Then
					Return True
				EndIf
			Next
		EndIf
	Next
	Return False
EndFunc   ;==>DailyRestartCheck

Func RCONCustomTimeCheck($sWDays, $sHours, $sMin)
	Local $iDay = -1
	Local $iHour = -1
	Local $aDays = StringSplit($sWDays, ",")
	Local $aHours = StringSplit($sHours, ",")
	For $d = 1 To $aDays[0]
		$iDay = StringStripWS($aDays[$d], 8)
		If Int($iDay) = Int(@WDAY) Or Int($iDay) = 0 Then
			For $h = 1 To $aHours[0]
				$iHour = StringStripWS($aHours[$h], 8)
				If Int($iHour) = Int(@HOUR) And Int($sMin) = Int(@MIN) Then
					Return True
				EndIf
			Next
		EndIf
	Next
	Return False
EndFunc   ;==>RCONCustomTimeCheck

Func RunExternalScriptBeforeSteam($tSplash = 0)
	If $aExecuteExternalScript = "yes" Then
		LogWrite(" Executing BEFORE SteamCMD UPDATE AND SERVER START external script " & $aExternalScriptDir & "\" & $aExternalScriptName)
		If $aExternalScriptWait = "no" Then
			If $aExternalScriptHideYN = "yes" Then
				Run($aExternalScriptDir & '\' & $aExternalScriptName, $aExternalScriptDir, @SW_HIDE)
			Else
				Run($aExternalScriptDir & '\' & $aExternalScriptName, $aExternalScriptDir)
			EndIf
		Else
			Local $tTxt = $aStartText & "Waiting for BEFORE SteamCMD UPDATE AND SERVER START external script to finish . . ."
			If $tSplash > 0 Then
				ControlSetText($tSplash, "", "Static1", $tTxt)
			Else
				SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			EndIf
;~ 			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for BEFORE SteamCMD UPDATE AND SERVER START external script to finish . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			If $aExternalScriptHideYN = "yes" Then
				RunWait($aExternalScriptDirr & '\' & $aExternalScriptName, $aExternalScriptDir, @SW_HIDE)
			Else
				RunWait($aExternalScriptDir & '\' & $aExternalScriptName, $aExternalScriptDir)
			EndIf
			LogWrite(" External BEFORE SteamCMD UPDATE AND SERVER START restart script finished.")
			If $tSplash = 0 Then
				SplashOff()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>RunExternalScriptBeforeSteam

Func RunExternalScriptAfterSteam($tSplash = 0)
	If $aExternalScriptValidateYN = "yes" Then
		LogWrite(" Executing AFTER SteamCMD BUT BEFORE SERVER external script " & $aExternalScriptValidateDir & "\" & $aExternalScriptValidateName)
		If $aExternalScriptValidateWait = "no" Then
			If $aExternalScriptHideYN = "yes" Then
				Run($aExternalScriptValidateDir & '\' & $aExternalScriptValidateName, $aExternalScriptValidateDir, @SW_HIDE)
			Else
				Run($aExternalScriptValidateDir & '\' & $aExternalScriptValidateName, $aExternalScriptValidateDir)
			EndIf
		Else
			Local $tTxt = $aStartText & "Waiting for AFTER SteamCMD BUT BEFORE SERVER external script to finish . . ."
			If $tSplash > 0 Then
				ControlSetText($tSplash, "", "Static1", $tTxt)
			Else
				SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			EndIf
;~ 			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for AFTER SteamCMD BUT BEFORE SERVER external script to finish . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			If $aExternalScriptHideYN = "yes" Then
				RunWait($aExternalScriptValidateDir & '\' & $aExternalScriptValidateName, $aExternalScriptValidateDir, @SW_HIDE)
			Else
				RunWait($aExternalScriptValidateDir & '\' & $aExternalScriptValidateName, $aExternalScriptValidateDir)
			EndIf
			LogWrite(" External AFTER SteamCMD BUT BEFORE SERVER restart script finished.")
			If $tSplash = 0 Then
				SplashOff()
			EndIf
		EndIf
	EndIf
EndFunc   ;==>RunExternalScriptAfterSteam


Func RunExternalScriptDaily()
	If $aExternalScriptDailyYN = "yes" Then
		LogWrite(" Executing DAILY restart external script " & $aExternalScriptDailyDir & "\" & $aExternalScriptDailyFileName)
		If $aExternalScriptDailyWait = "no" Then
			If $aExternalScriptHideYN = "yes" Then
				Run($aExternalScriptDailyDir & '\' & $aExternalScriptDailyFileName, $aExternalScriptDailyDir, @SW_HIDE)
			Else
				Run($aExternalScriptDailyDir & '\' & $aExternalScriptDailyFileName, $aExternalScriptDailyDir)
			EndIf
		Else
			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for DAILY external script to finish . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			If $aExternalScriptHideYN = "yes" Then
				RunWait($aExternalScriptDailyDir & '\' & $aExternalScriptDailyFileName, $aExternalScriptDailyDir, @SW_HIDE)
			Else
				RunWait($aExternalScriptDailyDir & '\' & $aExternalScriptDailyFileName, $aExternalScriptDailyDir)
			EndIf
			LogWrite(" External DAILY restart script finished.")
			SplashOff()
		EndIf
	EndIf
EndFunc   ;==>RunExternalScriptDaily

Func RunExternalScriptAnnounce()
	If $aExternalScriptAnnounceYN = "yes" Then
		LogWrite(" Executing FIRST ANNOUNCEMENT external script " & $aExternalScriptAnnounceDir & "\" & $aExternalScriptAnnounceFileName)
		If $aExternalScriptAnnounceWait = "no" Then
			If $aExternalScriptHideYN = "yes" Then
				Run($aExternalScriptAnnounceDir & '\' & $aExternalScriptAnnounceFileName, $aExternalScriptAnnounceDir, @SW_HIDE)
			Else
				Run($aExternalScriptAnnounceDir & '\' & $aExternalScriptAnnounceFileName, $aExternalScriptAnnounceDir)
			EndIf
		Else
			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for FIRST ANNOUNCEMENT external script to finish . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			If $aExternalScriptHideYN = "yes" Then
				RunWait($aExternalScriptAnnounceDir & '\' & $aExternalScriptAnnounceFileName, $aExternalScriptAnnounceDir, @SW_HIDE)
			Else
				RunWait($aExternalScriptAnnounceDir & '\' & $aExternalScriptAnnounceFileName, $aExternalScriptAnnounceDir)
			EndIf
			LogWrite(" External FIRST ANNOUNCEMENT restart script finished.")
			SplashOff()
		EndIf
	EndIf
EndFunc   ;==>RunExternalScriptAnnounce

Func RunExternalRemoteRestart()
	If $aExternalScriptRemoteYN = "yes" Then
		LogWrite(" Executing REMOTE RESTART external script " & $aExternalScriptRemoteDir & "\" & $aExternalScriptRemoteFileName)
		If $aExternalScriptRemoteWait = "no" Then
			If $aExternalScriptHideYN = "yes" Then
				Run($aExternalScriptRemoteDir & '\' & $aExternalScriptRemoteFileName, $aExternalScriptRemoteDir, @SW_HIDE)
			Else
				Run($aExternalScriptRemoteDir & '\' & $aExternalScriptRemoteFileName, $aExternalScriptRemoteDir)
			EndIf
		Else
			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for REMOTE RESTART external script to finish . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			If $aExternalScriptHideYN = "yes" Then
				RunWait($aExternalScriptRemoteDir & '\' & $aExternalScriptRemoteFileName, $aExternalScriptRemoteDir, @SW_HIDE)
			Else
				RunWait($aExternalScriptRemoteDir & '\' & $aExternalScriptRemoteFileName, $aExternalScriptRemoteDir)
			EndIf
			LogWrite(" External REMOTE RESTART script finished.")
			SplashOff()
		EndIf
	EndIf
EndFunc   ;==>RunExternalRemoteRestart

Func RunExternalScriptUpdate()
	If $aExternalScriptUpdateYN = "yes" Then
		LogWrite(" Executing Script When Restarting For Server Update: " & $aExternalScriptUpdateDir & "\" & $aExternalScriptUpdateFileName)
		If $aExternalScriptUpdateWait = "no" Then
			If $aExternalScriptHideYN = "yes" Then
				Run($aExternalScriptUpdateDir & '\' & $aExternalScriptUpdateFileName, $aExternalScriptUpdateDir, @SW_HIDE)
			Else
				Run($aExternalScriptUpdateDir & '\' & $aExternalScriptUpdateFileName, $aExternalScriptUpdateDir)
			EndIf
		Else
			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for Script When Restarting For Server Update external script to finish . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			If $aExternalScriptHideYN = "yes" Then
				RunWait($aExternalScriptUpdateDir & '\' & $aExternalScriptUpdateFileName, $aExternalScriptUpdateDir, @SW_HIDE)
			Else
				RunWait($aExternalScriptUpdateDir & '\' & $aExternalScriptUpdateFileName, $aExternalScriptUpdateDir)
			EndIf
			LogWrite(" Executing Script When Restarting For Server Update Finished. Continuing Server Start.")
			SplashOff()
		EndIf
	EndIf
EndFunc   ;==>RunExternalScriptUpdate

Func RunExternalScriptMod()
	If $aExternalScriptModYN = "yes" Then
		LogWrite(" Executing Script When Restarting For MOD Update: " & $aExternalScriptModDir & "\" & $aExternalScriptModFileName)
		If $aExternalScriptModWait = "no" Then
			If $aExternalScriptHideYN = "yes" Then
				Run($aExternalScriptModDir & '\' & $aExternalScriptModFileName, $aExternalScriptModDir, @SW_HIDE)
			Else
				Run($aExternalScriptModDir & '\' & $aExternalScriptModFileName, $aExternalScriptModDir)
			EndIf
		Else
			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for Script When Restarting For MOD Update external script to finish . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			If $aExternalScriptHideYN = "yes" Then
				RunWait($aExternalScriptModDir & '\' & $aExternalScriptModFileName, $aExternalScriptModDir, @SW_HIDE)
			Else
				RunWait($aExternalScriptModDir & '\' & $aExternalScriptModFileName, $aExternalScriptModDir)
			EndIf
			LogWrite(" Executing Script When Restarting For MOD Update Finished. Continuing Server Start.")
			SplashOff()
		EndIf
	EndIf
EndFunc   ;==>RunExternalScriptMod

Func ExternalScriptExist()
	Local $sFileExists = FileExists($aBatFolder & "\" & $aBatUpdateGame)
	If $sFileExists = 0 Then
		Local $tTxt = "start /wait /high """ & $aSteamCMDDir & "\steamcmd.exe ^" & @CRLF & _
				"+login anonymous ^" & @CRLF & _
				"+force_install_dir """ & $aServerDirLocal & """ ^" & @CRLF & _
				"+app_update " & $aSteamAppID & " validate ^" & @CRLF & _
				"+quit"
	EndIf
	If $aExecuteExternalScript = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptDir & "\" & $aExternalScriptName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External BEFORE update script not found", "Could not find " & $aExternalScriptDir & "\" & $aExternalScriptName & @CRLF & "Would you like to exit now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExecuteExternalScript = "no"
				LogWrite(" External BEFORE update script execution disabled - Could not find " & $aExternalScriptDir & "\" & $aExternalScriptName)
			EndIf
		EndIf
	EndIf
	If $aExternalScriptValidateYN = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptValidateDir & "\" & $aExternalScriptValidateName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External AFTER update script not found", "Could not find " & $aExternalScriptValidateDir & "\" & $aExternalScriptValidateName & @CRLF & "Would you like to exit now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExternalScriptValidateYN = "no"
				LogWrite(" External AFTER update script execution disabled - Could not find " & $aExternalScriptValidateDir & "\" & $aExternalScriptValidateName)
			EndIf
		EndIf
	EndIf
	If $aExternalScriptDailyYN = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptDailyDir & "\" & $aExternalScriptDailyFileName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External DAILY restart script not found", "Could not find " & $aExternalScriptDailyDir & "\" & $aExternalScriptDailyFileName & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExternalScriptDailyYN = "no"
				LogWrite(" External DAILY restart script execution disabled - Could not find " & $aExternalScriptDailyDir & "\" & $aExternalScriptDailyFileName)
			EndIf
		EndIf
	EndIf
	If $aExternalScriptUpdateYN = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptUpdateDir & "\" & $aExternalScriptUpdateFileName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External UPDATE restart script not found", "Could not find " & $aExternalScriptUpdateDir & "\" & $aExternalScriptUpdateFileName & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExternalScriptUpdateYN = "no"
				LogWrite(" External UPDATE restart script execution disabled - Could not find " & $aExternalScriptUpdateDir & "\" & $aExternalScriptUpdateFileName)
			EndIf
		EndIf
	EndIf
	If $aExternalScriptAnnounceYN = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptAnnounceDir & "\" & $aExternalScriptAnnounceFileName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External FIRST RESTART ANNOUNCEMENT restart script not found", "Could not find " & $aExternalScriptAnnounceDir & "\" & $aExternalScriptAnnounceFileName & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExternalScriptDailyYN = "no"
				LogWrite(" External FIRST RESTART ANNOUNCEMENT restart script execution disabled - Could not find " & $aExternalScriptAnnounceDir & "\" & $aExternalScriptAnnounceFileName)
			EndIf
		EndIf
	EndIf
	If $aExternalScriptRemoteYN = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptRemoteDir & "\" & $aExternalScriptRemoteFileName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External REMOTE RESTART script not found", "Could not find " & $aExternalScriptRemoteDir & "\" & $aExternalScriptRemoteFileName & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExternalScriptDailyYN = "no"
				LogWrite(" External REMOTE RESTART script execution disabled - Could not find " & $aExternalScriptRemoteDir & "\" & $aExternalScriptRemoteFileName)
			EndIf
		EndIf
	EndIf
	If $aExternalScriptModYN = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptModDir & "\" & $aExternalScriptModFileName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External MOD UPDATE restart script not found", "Could not find " & $aExternalScriptModDir & "\" & $aExternalScriptModFileName & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExternalScriptModYN = "no"
				LogWrite(" External MOD UPDATE restart script execution disabled - Could not find " & $aExternalScriptModDir & "\" & $aExternalScriptModFileName)
			EndIf
		EndIf
	EndIf
	For $i = 0 To ($aCustomRCONCount - 1)
		If $xCustomRCONFile[$i] <> "" Then
			Local $sFileExists = FileExists($xCustomRCONFile[$i])
			If $sFileExists = 0 Then
				SplashOff()
				$xCustomRCONFile[$i] = FileOpenDialog("WARNING!!! Scheduled File " & $i & " to Execute not found", @ScriptDir, "All (*.*)", 3, "ScheduledFile" & $i & ".bat")
				IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-File to Execute (leave BLANK to skip) ###", $xCustomRCONFile[$i])
				Global $aSplashStartUp = SplashTextOn($aUtilName, $aStartText, 475, 110, -1, -1, $DLG_MOVEABLE, "")
				F_ExitCloseN(True)
			EndIf
		EndIf
	Next
EndFunc   ;==>ExternalScriptExist

#Region ;**** Adjust restart time for announcement delay ****
Func DailyRestartOffset($bHour0, $sMin, $sTime)
	If $bRestartMin - $sTime < 0 Then
		Local $tDay = ""
		Local $bHour1 = -1
		Local $bHour2 = ""
		Local $bHour3 = StringSplit($bHour0, ",")
		For $bRestartHours = 1 To $bHour3[0]
			$bHour1 = StringStripWS($bHour3[$bRestartHours], 8) - 1
			If Int($bHour1) = -1 Then
				$bHour1 = 23
				If $aRestartDays <> "0" Then
					Local $tDays = StringSplit($aRestartDays, ",")
					For $i = 1 To (UBound($tDays) - 1)
						If $tDays[$i] = 1 Then
							$tDays[$i] = 7
						Else
							$tDays[$i] = $tDays[$i] - 1
						EndIf
						$tDay = $tDay & "," & Int($tDays[$i])
					Next
					$aRestartDays = StringTrimLeft($tDay, 1)
				EndIf
			EndIf
			$bHour2 = $bHour2 & "," & Int($bHour1)
		Next
		Global $aRestartMin = 60 - $sTime + $bRestartMin
		Global $aRestartHours = StringTrimLeft($bHour2, 1)
	Else
		Global $aRestartMin = $bRestartMin - $sTime
		Global $aRestartHours = $bRestartHours
	EndIf
EndFunc   ;==>DailyRestartOffset
#EndRegion ;**** Adjust restart time for announcement delay ****

#Region ;**** Replace "\m" with minutes in announcement ****
Func AnnounceReplaceTime($tTime0, $tMsg0)
	If StringInStr($tMsg0, "\m") = "0" Then
	Else
		Local $tTime2 = -1
		Local $tTime3 = StringSplit($tTime0, ",")
		Local $tMsg1 = $tTime3
		For $tTime2 = 1 To $tTime3[0]
			$tTime1 = StringStripWS($tTime3[$tTime2], 8) - 1
			$tMsg1[$tTime2] = StringReplace($tMsg0, "\m", $tTime3[$tTime2])
		Next
		Return $tMsg1
	EndIf
EndFunc   ;==>AnnounceReplaceTime
#EndRegion ;**** Replace "\m" with minutes in announcement ****

#Region ;**** Replace "\x" with MOD ID in announcement ****
Func AnnounceReplaceModID($tMod, $tMsg0, $tTime0, $tMNo)
	If $aFirstModBoot Then
		Return $tMsg0
	Else
		Local $tTime2 = -1
		Local $tTime3 = StringSplit($tTime0, ",")
		Local $tMsg1 = $tTime3
		For $tTime2 = 1 To $tTime3[0]
			;			$tTime1 = StringStripWS($tTime3[$tTime2], 8) - 1
			$tMsg1[$tTime2] = StringReplace($tMsg0[$tTime2], "\x", $tMod & " " & $aModName[$tMNo])
		Next
		Return $tMsg1
	EndIf
EndFunc   ;==>AnnounceReplaceModID
#EndRegion ;**** Replace "\x" with MOD ID in announcement ****

#Region ;**** Remove invalid characters ****
Func RemoveInvalidCharacters($aString)
	Local $bString = StringRegExpReplace($aString, "[\x3D\x22\x3B\x3C\x3E\x3F\x25\x27\x7C]", "")
	If $aString = $bString Then
	Else
		LogWrite(" [ERROR] Invalid character found in " & $aIniFile & ". Changed parameter from """ & $aString & """ to """ & $bString & """.")
	EndIf
	Return $bString
EndFunc   ;==>RemoveInvalidCharacters
#EndRegion ;**** Remove invalid characters ****

#Region ;**** Remove Trailing Slash ****
Func RemoveTrailingSlash($aString)
	Local $bString = StringRight($aString, 1)
	If $bString = "\" Then
		$aString = StringTrimRight($sString, 1)
	EndIf
	Return $aString
EndFunc   ;==>RemoveTrailingSlash
#EndRegion ;**** Remove Trailing Slash ****

Func RemoveTrailingSlashT($aString)
	Local $bString = StringRight($aString, 2)
	If $bString = "\t" Then
		$cString = StringTrimRight($aString, 2)
	Else
		$cString = $aString
	EndIf
	Return $cString
EndFunc   ;==>RemoveTrailingSlashT

Func CloseTCP($tIP, $tPort, $tSplash = 0)
	Local $tTxt = "Shutting down Remote Restart." & @CRLF & @CRLF
	If $tSplash > 0 Then
		ControlSetText($tSplash, "", "Static1", $tTxt)
	Else
		SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
	EndIf
	If $aRemoteRestartUse = "yes" Then
		TCPShutdown()
		Sleep(250)
		For $ix = 1 To 6
			$socket = TCPConnect($tIP, $tPort)
			If $socket <> -1 Then
				TCPShutdown()
				ControlSetText($tSplash, "", "Static1", $tTxt & "Coundown:  " & (6 - $ix))
			Else
				ExitLoop
			EndIf
			Sleep(500)
		Next
	EndIf
	If $tSplash = 0 Then
		SplashOff()
	EndIf

EndFunc   ;==>CloseTCP

; -----------------------------------------------------------------------------------------------------------------------
#Region ;**** _RemoteRestart ****
;===============================================================================
;
; Name...........: _RemoteRestart
; Description ...: Receives TCP string from GET request and checks against list of known passwords.
;				   Expects GET /?restart=user_pass HTTP/x.x
; Syntax.........: RemoteRestart($vMSocket, $sCodes, [$sKey = "restart", $sHideCodes = "no", [$sServIP = "0.0.0.0", [$sName = "Server", [$bDebug = False]]]]])
; Parameters ....: $vMSocket - Main Socket to Accept TCP Requests on. Should already be open from TCPListen
;                  $sCodes - Comma Seperated list of user1_password1,user2_password2,password3
;							 Allowed Characters: abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890!@$%^&*()+=-{}[]\|:;./?
;				   $sKey - Key to match before matching password. http://IP:Pass?KEY=user_pass
;                  $sHideCodes - Obfuscate codes or not, (yes/no) string
;                  $sServIP - IP  to send back in Header Response.
;				   $sName - Server Name to use in HTML Response.
;				   $sDebug - True to return Full TCP Request when Request is invalid
; Return values .: Success - Returns String
;                          - Sets @error to 0
;				   No Connection - Sets @ error to -1
;                  Failure - Returns Descriptive String sets @error:
;                  |1 - Password doesn't match
;                  |2 - Invalid Request
;                  |3 - CheckHTTPReq Failed - Returns error in string
;                  |4 - TCPRecv Failed - Returns error in string
; Author ........: Dateranoth
;
;==========================================================================================

Func PassCheck($sPass, $sPassString)     ;**** PassCheck - Checks if received password matches any of the known passwords ****
	Local $aPassReturn[3] = [False, "", ""]
	Local $aPasswords = StringSplit($sPassString, ",")
	For $i = 1 To $aPasswords[0]
		If (StringCompare($sPass, $aPasswords[$i], 1) = 0) Then
			Local $aUserPass = StringSplit($aPasswords[$i], "_")
			If $aUserPass[0] > 1 Then
				$aPassReturn[0] = True
				$aPassReturn[1] = $aUserPass[1]
				$aPassReturn[2] = $aUserPass[2]
			Else
				$aPassReturn[0] = True
				$aPassReturn[1] = "Anonymous"
				$aPassReturn[2] = $aUserPass[1]
			EndIf
			ExitLoop
		EndIf
	Next
	Return $aPassReturn
EndFunc   ;==>PassCheck

Func ObfPass($sObfPassString)     ;**** ObfPass - Obfuscates password string for logging
	Local $sObfPass = ""
	For $i = 1 To (StringLen($sObfPassString) - 3)
		If $i <> 4 Then
			$sObfPass = $sObfPass & "*"
		Else
			$sObfPass = $sObfPass & StringMid($sObfPassString, 4, 4)
		EndIf
	Next
	Return $sObfPass
EndFunc   ;==>ObfPass

Func _TCP_Server_ClientIP($hSocket)     ;**** Function to get IP from Restart Client ****
	Local $pSocketAddress, $aReturn
	$pSocketAddress = DllStructCreate("short;ushort;uint;char[8]")
	$aReturn = DllCall("ws2_32.dll", "int", "getpeername", "int", $hSocket, "ptr", DllStructGetPtr($pSocketAddress), "int*", DllStructGetSize($pSocketAddress))
	If @error Or $aReturn[0] <> 0 Then Return $hSocket
	$aReturn = DllCall("ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($pSocketAddress, 3))
	If @error Then Return $hSocket
	$pSocketAddress = 0
	Return $aReturn[0]
EndFunc   ;==>_TCP_Server_ClientIP

Func CheckHTTPReq($sRequest, $sKey = "restart")     ;**** Function to Check Request from Browser and return restart string if request is valid****
	If IsString($sRequest) Then
		Local $aRequest = StringRegExp($sRequest, '^GET[[:blank:]]\/\?(?i)' & $sKey & '(?-i)=(\S+)[[:blank:]]HTTP\/\d.\d\R', 2)
		If Not @error Then
			Return SetError(0, 0, $aRequest[1])
		ElseIf @error = 1 Then
			Return SetError(1, @extended, "Invalid Request")
		ElseIf @error = 2 Then
			Return SetError(2, @extended, "Bad pattern, array is invalid. @extended = offset of error in pattern.")
		EndIf
	Else
		Return SetError(3, 0, "Not A String")
	EndIf
EndFunc   ;==>CheckHTTPReq

Func MultipleAttempts($sRemoteIP, $bFailure = False, $bSuccess = False)     ;**** Function to Check for Multiple Password Failures****
	Local $aPassFailure[1][3] = [[0, 0, 0]]
	For $i = 1 To UBound($aPassFailure, 1) - 1
		If StringCompare($aPassFailure[$i][0], $sRemoteIP) = 0 Then
			If (_DateDiff('n', $aPassFailure[$i][2], _NowCalc()) >= 10) Or $bSuccess Then
				$aPassFailure[$i][1] = 0
				$aPassFailure[$i][2] = _NowCalc()
				Return SetError(0, 0, "Maximum Attempts Reset")
			ElseIf $bFailure Then
				$aPassFailure[$i][1] += 1
				$aPassFailure[$i][2] = _NowCalc()
			EndIf
			If $aPassFailure[$i][1] >= 15 Then
				Return SetError(1, $aPassFailure[$i][1], "Maximum Number of Attempts Exceeded. Wait 10 minutes before trying again.")
			Else
				Return SetError(0, $aPassFailure[$i][1], $aPassFailure[$i][1] & " attempts out of 15 used.")
			EndIf
			ExitLoop
		EndIf
	Next
	ReDim $aPassFailure[(UBound($aPassFailure, 1) + 1)][3]
	$aPassFailure[(UBound($aPassFailure, 1) - 1)][0] = $sRemoteIP
	$aPassFailure[(UBound($aPassFailure, 1) - 1)][1] = 0
	$aPassFailure[(UBound($aPassFailure, 1) - 1)][2] = _NowCalc()
	Return SetError(0, 0, "IP Added to List")
EndFunc   ;==>MultipleAttempts

Func _RemoteRestart($vMSocket, $sCodes, $sKey, $sHideCodes, $sServIP, $sName, $bDebug = True)     ;**** Uses other Functions to check connection, verify request is valid, verify restart code is correct, gather IP, and send proper message back to User depending on request received****
	Local $vConnectedSocket = TCPAccept($vMSocket)
	If $vConnectedSocket >= 0 Then
		Local $sRecvIP = _TCP_Server_ClientIP($vConnectedSocket)
		Local $sRECV = TCPRecv($vConnectedSocket, 512)
		Local $iError = 0
		Local $iExtended = 0
		If @error = 0 Then
			Local $aRemoteRCONTF = RemoteRCON($sRECV, $aServerAdminPass, $vConnectedSocket, $sServIP, $sName)
			If $aRemoteRCONTF Then
				Local $sRecvPass = CheckHTTPReq($sRECV, $sKey)
				If @error = 0 Then
					Local $sCheckMaxAttempts = MultipleAttempts($sRecvIP)
					If @error = 1 Then
						TCPSend($vConnectedSocket, "HTTP/1.1 429 Too Many Requests" & @CRLF & "Retry-After: 600" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
						TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>" & $sName & " Remote Restart</title></head><body><h1>429 Too Many Requests</h1><p>You tried to Restart " & $sName & " 15 times in a row.<BR>" & $sCheckMaxAttempts & "</body></html>")
						If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
						Return SetError(1, 0, "[Remote Restart] Restart ATTEMPT by Remote Host: " & $sRecvIP & " | Wrong Code was entered 15 times. User must wait 10 minutes before trying again.")
					EndIf
					Local $aPassCompare = PassCheck($sRecvPass, $sCodes)
					If $sHideCodes = "yes" Then
						$aPassCompare[2] = ObfPass($aPassCompare[2])
					EndIf
					If $aPassCompare[0] Then
						TCPSend($vConnectedSocket, "HTTP/1.1 200 OK" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
						TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>" & $sName & " Remote Restart</title></head><body><h1>Authentication Accepted. " & $sName & " Restarting.</h1></body></html>")
						If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
						$sCheckMaxAttempts = MultipleAttempts($sRecvIP, False, True)
						Return SetError(0, 0, "[Remote Restart] Restart Requested by Remote Host: " & $sRecvIP & " | User: " & $aPassCompare[1] & " | Pass: " & $aPassCompare[2])
					Else
						TCPSend($vConnectedSocket, "HTTP/1.1 403 Forbidden" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
						TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>" & $sName & " Remote Restart</title></head><body><h1>403 Forbidden</h1><p>You are not allowed to restart " & $sName & ".<BR> Attempt from <b>" & $sRecvIP & "</b> has been logged.</body></html>")
						If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
						$sCheckMaxAttempts = MultipleAttempts($sRecvIP, True, False)
						Return SetError(1, 0, "[Remote Restart] Restart ATTEMPT by Remote Host: " & $sRecvIP & " | Unknown Restart Code: " & $sRecvPass)
					EndIf
				Else
					$iError = @error
					$iExtended = @extended
					TCPSend($vConnectedSocket, "HTTP/1.1 404 Not Found" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
					TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>404 Not Found</title></head><body><h1>404 Not Found.</h1></body></html>")
					If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
					If $iError = 1 Then
;~ 						If Not $bDebug Then
;~ 							$sRECV = "Enable Debug to Log Full TCP Request"
;~ 						Else
						$sRECV = "Full TCP Request: " & @CRLF & $sRECV
;~ 						EndIf
						Return SetError(2, 0, "[Remote Restart] IGNORE THIS MESSAGE: Invalid Restart Request by: " & $sRecvIP & ". Should be in the format of GET /?" & $sKey & "=user_pass HTTP/x.x | " & $sRECV)
					Else
						;This Shouldn't Happen
						$tTxt = StringRegExpReplace("[Remote Restart] CheckHTTPReq Failed with Error: " & $iError & " Extended: " & $iExtended & " [" & $sRecvPass & "] CHECK REMOTE RESTART PORT: Make sure it isn't being used as an RCON port for a server)", @CRLF, "")
						Return SetError(3, 0, $tTxt)
					EndIf
				EndIf
			Else
				;Remote Restart RCON - sent after command received.
				TCPSend($vConnectedSocket, "HTTP/1.1 200 OK" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
				TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>" & $sName & " Remote Restart</title></head><body><h1>RCON command being sent to all servers: [" & $zCMD[2] & "].</h1></body></html>")
				If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
				$sCheckMaxAttempts = MultipleAttempts($sRecvIP, False, True)
				;Remote Restart RCON - sent after command received.
			EndIf
		Else
			$iError = @error
			$iExtended = @extended
			TCPSend($vConnectedSocket, "HTTP/1.1 400 Bad Request" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
			TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>400 Bad Request</title></head><body><h1>400 Bad Request.</h1></body></html>")
			If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
			Return SetError(4, 0, "[Remote Restart] TCPRecv Failed to Complete with Error: " & $iError & " Extended: " & $iExtended)
		EndIf
	EndIf
	Return SetError(-1, 0, "No Connection")
	If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
EndFunc   ;==>_RemoteRestart
#EndRegion ;**** _RemoteRestart ****

Func RotateFile($sFile, $sBackupQty, $bDelOrig = True)     ;Pass File to Rotate and Quantity of Files to Keep for backup. Optionally Keep Original.
	Local $hCreateTime = @YEAR & @MON & @MDAY
	For $i = $sBackupQty To 1 Step -1
		If FileExists($sFile & $i) Then
			$hCreateTime = FileGetTime($sFile & $i, 1)
			FileMove($sFile & $i, $sFile & ($i + 1), 1)
			FileSetTime($sFile & ($i + 1), $hCreateTime, 1)
		EndIf
	Next
	If FileExists($sFile & ($sBackupQty + 1)) Then
		FileDelete($sFile & ($sBackupQty + 1))
	EndIf
	If FileExists($sFile) Then
		If $bDelOrig = True Then
			$hCreateTime = FileGetTime($sFile, 1)
			FileMove($sFile, $sFile & "1", 1)
			FileWriteLine($sFile, _NowCalc() & " " & $sFile & " Rotated")
			FileSetTime($sFile & "1", $hCreateTime, 1)
			FileSetTime($sFile, @YEAR & @MON & @MDAY, 1)
		Else
			FileCopy($sFile, $sFile & "1", 1)
		EndIf
	EndIf
EndFunc   ;==>RotateFile

Func RemoteRCON($tCMD, $tPWD, $vConnectedSocket, $sServIP, $sName)
	Global $zCMD[2]
	Local $tCMD1 = _ArrayToString(_StringBetween($tCMD, "GET /", " HTTP/"))
	$zCMD = StringSplit($tCMD1, "@")
	If $zCMD[0] = 2 Then
		If $zCMD[1] = $tPWD Then
			$zCMD[2] = ReplaceSpace($zCMD[2])
			LogWrite(" [Remote RCON] Correct password received. Sending RCON command to all servers:" & $zCMD[2])
			For $i = 0 To ($aServerGridTotal - 1)
				If ProcessExists($aServerPID[$i]) Then
					SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $zCMD[2])
				EndIf
				Return False
			Next
			Sleep(5000)
		Else
			Return True
		EndIf
	Else
		Return True
	EndIf
EndFunc   ;==>RemoteRCON

Func LogWrite($Msg, $msgdebug = "blank")
	$aLogFile = $aFolderLog & $aUtilName & "_Log_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
	$aLogDebugFile = $aFolderLog & $aUtilName & "_LogFull_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
	If $Msg <> "" Then
		FileWriteLine($aLogFile, _NowCalc() & $Msg)
		$aGUILogWindowText = _NowTime(5) & $Msg & @CRLF & StringLeft($aGUILogWindowText, 10000)
		If $aGUIReady Then GUICtrlSetData($LogTicker, $aGUILogWindowText)
	EndIf
	If $msgdebug <> "no" Then
		If $msgdebug = "blank" Then
			FileWriteLine($aLogDebugFile, _NowCalc() & $Msg)
		Else
			FileWriteLine($aLogDebugFile, _NowCalc() & $msgdebug)
		EndIf
	EndIf
EndFunc   ;==>LogWrite

Func PurgeLogFile($TF = True)
	If $TF Then
		$aPurgeLogFileName = $aFolderTemp & $aUtilName & "_PurgeLogFile.bat"
		Local $sFileExists = FileExists($aPurgeLogFileName)
		If $sFileExists = 1 Then
			FileDelete($aPurgeLogFileName)
		EndIf
		FileWriteLine($aPurgeLogFileName, "for /f ""tokens=* skip=" & $aLogQuantity & """ %%F in " & Chr(40) & "'dir """ & $aFolderLog & $aUtilName & "_Log_*.txt"" /o-d /tc /b'" & Chr(41) & " do del """ & $aFolderLog & "%%F""")
		FileWriteLine($aPurgeLogFileName, "for /f ""tokens=* skip=" & $aLogQuantity & """ %%F in " & Chr(40) & "'dir """ & $aFolderLog & $aUtilName & "_LogFull_*.txt"" /o-d /tc /b'" & Chr(41) & " do del """ & $aFolderLog & "%%F""")
		FileWriteLine($aPurgeLogFileName, "for /f ""tokens=* skip=" & $aLogQuantity & """ %%F in " & Chr(40) & "'dir """ & $aFolderLog & $aUtilName & "_OnlineUserLog_*.txt"" /o-d /tc /b'" & Chr(41) & " do del """ & $aFolderLog & "%%F""")
		LogWrite("", " Deleting log files >" & $aLogQuantity & " in folder " & $aFolderTemp)
		Run($aPurgeLogFileName, "", @SW_HIDE)
	EndIf

EndFunc   ;==>PurgeLogFile

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** UnZip Function by trancexx ****
; #FUNCTION# ;===============================================================================
;
; Name...........: _ExtractZip
; Description ...: Extracts file/folder from ZIP compressed file
; Syntax.........: _ExtractZip($sZipFile, $sFolderStructure, $sFile, $sDestinationFolder)
; Parameters ....: $sZipFile - full path to the ZIP file to process
;                  $sFolderStructure - 'path' to the file/folder to extract inside ZIP file
;                  $sFile - file/folder to extract
;                  $sDestinationFolder - folder to extract to. Must exist.
; Return values .: Success - Returns 1
;                          - Sets @error to 0
;                  Failure - Returns 0 sets @error:
;                  |1 - Shell Object creation failure
;                  |2 - Destination folder is unavailable
;                  |3 - Structure within ZIP file is wrong
;                  |4 - Specified file/folder to extract not existing
; Author ........: trancexx
; https://www.autoitscript.com/forum/topic/101529-sunzippings-zipping/#comment-721866
;
;==========================================================================================
Func _ExtractZip($sZipFile, $sFolderStructure, $sFile, $sDestinationFolder)

	Local $i
	Do
		$i += 1
		$sTempZipFolder = @TempDir & "\Temporary Directory " & $i & " for " & StringRegExpReplace($sZipFile, ".*\\", "")
	Until Not FileExists($sTempZipFolder)     ; this folder will be created during extraction

	Local $oShell = ObjCreate("Shell.Application")

	If Not IsObj($oShell) Then
		Return SetError(1, 0, 0)     ; highly unlikely but could happen
	EndIf

	Local $oDestinationFolder = $oShell.NameSpace($sDestinationFolder)
	If Not IsObj($oDestinationFolder) Then
		Return SetError(2, 0, 0)     ; unavailable destionation location
	EndIf

	Local $oOriginFolder = $oShell.NameSpace($sZipFile & "\" & $sFolderStructure)     ; FolderStructure is overstatement because of the available depth
	If Not IsObj($oOriginFolder) Then
		Return SetError(3, 0, 0)     ; unavailable location
	EndIf

	Local $oOriginFile = $oOriginFolder.ParseName($sFile)
	If Not IsObj($oOriginFile) Then
		Return SetError(4, 0, 0)     ; no such file in ZIP file
	EndIf

	; copy content of origin to destination
	$oDestinationFolder.CopyHere($oOriginFile, 4)     ; 4 means "do not display a progress dialog box", but apparently doesn't work

	DirRemove($sTempZipFolder, 1)     ; clean temp dir

	Return 1     ; All OK!

EndFunc   ;==>_ExtractZip
#EndRegion ;**** UnZip Function by trancexx ****

; -----------------------------------------------------------------------------------------------------------------------

Func SteamcmdDelete($sCmdDir)
	;	DirRemove($bSteamCMDDir,1)
	LogWrite(" [Update] Deleting SteamCMD package and steampps temp folders.")

	DirRemove($sCmdDir & "\package", 1)
	DirRemove($sCmdDir & "\steamapps", 1)
	;		InetGet("https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip", @ScriptDir & "\steamcmd.zip", 0)
	;		DirCreate($bSteamCMDDir) ; to extract to
	;		_ExtractZip(@ScriptDir & "\steamcmd.zip", "", "steamcmd.exe", $bSteamCMDDir)
	;		FileDelete(@ScriptDir & "\steamcmd.zip")
	;		LogWrite(" Running SteamCMD. [steamcmd.exe +quit]")
	;		RunWait("" & $bSteamCMDDir & "\steamcmd.exe +quit", @SW_MINIMIZE)
	;		If Not FileExists($bSteamCMDDir & "\steamcmd.exe") Then
	;			MsgBox(0x0, "SteamCMD Not Found", "Could not find steamcmd.exe at " & $bSteamCMDDir)
	;			Exit
	;		EndIf
EndFunc   ;==>SteamcmdDelete

#Region ;**** Check for Files Exist ****
Func FileExistsFunc()
	Local $sFileExists = FileExists($aSteamCMDDir & "\steamcmd.exe")
	If $sFileExists = 0 Then
		InetGet("https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip", @ScriptDir & "\steamcmd.zip", 0)
		DirCreate($aSteamCMDDir)     ; to extract to
		_ExtractZip(@ScriptDir & "\steamcmd.zip", "", "steamcmd.exe", $aSteamCMDDir)
		FileDelete(@ScriptDir & "\steamcmd.zip")
		LogWrite(" Running SteamCMD. [steamcmd.exe +quit]")
		RunWait("" & $aSteamCMDDir & "\steamcmd.exe +quit", @SW_MINIMIZE)
		If Not FileExists($aSteamCMDDir & "\steamcmd.exe") Then
			SplashOff()
			MsgBox(0x0, "SteamCMD Not Found", "Could not find steamcmd.exe at " & $aSteamCMDDir)
			Exit
		EndIf
	EndIf
	If ($sInGameAnnounce = "yes") Then
		Local $sFileExists = FileExists(@ScriptDir & "\mcrcon.exe")
		If $sFileExists = 0 Then
			LogWrite(" Downloaded and installed mcrcon.exe")
			InetGet("https://github.com/Tiiffi/mcrcon/releases/download/v0.0.5/mcrcon-0.0.5-windows.zip", @ScriptDir & "\mcrcon.zip", 0)
			DirCreate(@ScriptDir)     ; to extract to
			_ExtractZip(@ScriptDir & "\mcrcon.zip", "", "mcrcon.exe", @ScriptDir)
			FileDelete(@ScriptDir & "\mcrcon.zip")
			If Not FileExists(@ScriptDir & "\mcrcon.exe") Then
				SplashOff()
				MsgBox(0x0, "MCRCON Not Found", "Could not find mcrcon.exe at " & @ScriptDir)
				Exit
			EndIf
		EndIf
	EndIf
EndFunc   ;==>FileExistsFunc
#EndRegion ;**** Check for Files Exist ****

;#Region ;**** Convert .mod file from Ark version to Atlas version ****
;Func ConvertModfileToAtlas($tServDIR,$tModID)
;$aStringToReplace1 = "616d650001000000" ; Tells the program where to add the file path into the .mod file (and replaces four characters that are not needed)
;$aStringReplace1 = "616d65002d0000002e2e2f2e2e2f2e2e2f53686f6f74657247616d652f436f6e74656e742f4d6f64732f" & _StringToHex($aModID)  ; Adds "../../../ShooterGame/Content/Mods/[ModID]" into .mod file
;$aStringToReplace2 = "ff22ff02000000000500000008"  ; A minor change required for an unknown reason
;  $aStringReplace2 = "ff22ff02000000010500000008"
;Local $tFileOpen = FileOpen($tServDIR & "\ShooterGame\Content\Mods\" & $tModID & "\.mod", 0)
;Local $tFileRead = FileRead($tFileOpen)
;Local $tFileRead1 = StringReplace($tFileRead,$aStringToReplace1,$aStringReplace1)
;Local $tFileRead2 = StringReplace($tFileRead1,$aStringToReplace2,$aStringReplace2)
;FileWrite($tServDIR & "\ShooterGame\Content\Mods\" & $tModID & ".mod", BinaryToString($tFileRead2, 1))
;FileClose($tFileOpen)
;EndFunc
;#EndRegion ;**** Convert .mod file from Ark version to Atlas version ****

;~ #Region **** Download and install mod updates ****
;Func UpdateMods()
;	$xServerModList
;	$aSteamCMDDir
;	$aServerModDIR = $aServerDirLocal & "\ShooterGame\Content\Mods\"
;	$aServerModAppworkshopSource = $aSteamCMDDir & "\steamapps\workshop\"
;	$aServerModAppworkshopDest = $aServerDirLocal & "\steamapps\workshop\"
;	https://github.com/phoenix125/Atlas-Mod-Downloader/raw/master/AtlasModDownloader.exe
;EndFunc

#Region ;**** Functions to Check for Mod Updates ****
Func CheckMod($sMods, $sSteamCmdDir, $sServerDir, $tSplash = 0, $tShow = False)
	Local $xError = False
	Local $tTxt = $aStartText & "Checking for mod updates"
	If $tSplash > 0 Then
		ControlSetText($tSplash, "", "Static1", $tTxt)
		Global $aSplashMod = $tSplash
	Else
;~ 		If $aFirstModCheck Then
		If $tShow Then
			Global $aSplashMod = SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
		EndIf
	EndIf
	;	If $xDebug Then
	;		LogWrite(" [Mod] Running mod update check.")
	;	EndIf
	If ($aServerModYN = "yes") Then
		Local $sFileExists = FileExists(@ScriptDir & "\AtlasModDownloader.exe")
		If $sFileExists = 0 Then
			SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Downloading AtlasModDownloader.exe.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
;~ 			ControlSetText($aSplashMod, "", "Static1", $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Downloading AtlasModDownloader.exe.")
			LogWrite(" Downloaded and installed AtlasModDownloader.exe")
			InetGet("http://www.phoenix125.com/share/atlas/AtlasModDownloader.exe", @ScriptDir & "\AtlasModDownloader.exe", 1)
			If Not FileExists(@ScriptDir & "\AtlasModDownloader.exe") Then
				SplashOff()
				MsgBox(0x0, "AtlasModDownloader Not Found", "Could not find AtlasModDownloader.exe at " & @ScriptDir)
				Exit
			EndIf
		EndIf
	EndIf
	Local $aMods = StringSplit($sMods, ",")
	Local $tError = 0
	For $i = 1 To $aMods[0]
		$aMods[$i] = StringStripWS($aMods[$i], 8)
		Local $aLatestTime = GetLatestModUpdateTime($aMods[$i], $tShow)
		$aModName[$i] = $aLatestTime[3]
		Local $aInstalledTime = GetInstalledModUpdateTime($sServerDir, $aMods[$i], $aModName[$i], $tShow)
		Local $bStopUpdate = False
		If Not $aLatestTime[0] Or Not $aLatestTime[1] Then
			Local $aErrorMsg = "Something went wrong downloading update information for mod [" & $aMods[$i] & "] If running Windows Server, Disable ""IE Enhanced Security Configuration"" for Administrators (via Server Manager > Local Server > IE Enhanced Security Configuration)."
			LogWrite(" [Mod] " & $aErrorMsg)
			$xError = True
			$tError = 1
			SplashOff()
			If $tShow Then
				MsgBox($MB_OK, $aUtilityVer, $aErrorMsg, 5)
			EndIf
			If $tSplash > 0 Then $aSplashStartUp = SplashTextOn($aUtilName, $aStartText, 475, 110, -1, -1, $DLG_MOVEABLE, "")
		ElseIf Not $aInstalledTime[0] Then
			$xError = True
			$tError = 2
			$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, $tError, $i)     ;No Manifest. Download First Mod
			If $bStopUpdate Then ExitLoop
		ElseIf Not $aInstalledTime[1] Then
			$xError = True
			$tError = 3
			$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, $tError, $i)     ;Mod does not exists. Download
			If $bStopUpdate Then ExitLoop
		ElseIf $aInstalledTime[1] And (StringCompare($aLatestTime[2], $aInstalledTime[2]) <> 0) Then
			$tError = 4
			$xError = True
			$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, $tError, $i)     ;Mod Out of Date. Update.
			If $bStopUpdate Then ExitLoop
		EndIf
	Next
;~ 	$aFirstModCheck = False
;~ 	SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Mod update check complete.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	;	WriteModList($sServerDir)
	If ($aBeginDelayedShutdown <> 1) And ($xError = False) Then
		LogWrite(" [Mod] Mods are Up to Date.")
	ElseIf $tError = 1 Then
		LogWrite(" [Mod] " & $aErrorMsg)
	Else
		$aRebootReason = "mod"
		$aBeginDelayedShutdown = 1
		RunExternalScriptMod()
	EndIf
	If $tShow And $xError Then
		Local $tTxt = $aStartText & "Checking for mod updates complete."
		Global $aSplashStartUp = SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
	EndIf
EndFunc   ;==>CheckMod

Func GetLatestModUpdateTime($sMod, $sShow)
	Local $aReturn[4] = [True, False, "", ""]
	Local $zModName = ""
;~ 	If $aModCheckMethod = 0 Then
	Local $sFilePath = $aFolderTemp & "mod_" & $sMod & "_latest_ver.tmp"
	LogWrite("", " [Mod] Checking for mod update via Internal Browser: http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
	InetGet("http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod, $sFilePath, 1)
	Local $hFileOpen = FileOpen($sFilePath, 0)
	Local $sFileRead = FileRead($hFileOpen)
	If $hFileOpen = -1 Then
		FileClose($hFileOpen)
		LogWrite("", " [Mod] Checking for mod update via Internet Explorer: http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
		Local $sFileRead = _INetGetSource("http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
		If @error Then $aReturn[0] = False
	Else
		FileClose($hFileOpen)
	EndIf

	If $aReturn[0] Then
		$aReturn[0] = True     ;File Exists
		Local $aAppInfo = StringSplit($sFileRead, 'Update:', 1)
		If UBound($aAppInfo) >= 3 Then
			$aAppInfo = StringSplit($aAppInfo[2], '">', 1)
		EndIf
		If UBound($aAppInfo) >= 2 Then
			$aAppInfo = StringSplit($aAppInfo[1], 'id="', 1)
		EndIf
		If UBound($aAppInfo) >= 2 And StringRegExp($aAppInfo[2], '^\d+$') Then
			$aReturn[1] = True     ;Successfully Read numerical value at positition expected
			$aReturn[2] = $aAppInfo[2]     ;Return Value Read
		EndIf
		Local $zModName = _ArrayToString(_StringBetween($sFileRead, "<title>Steam Community :: ", " :: Change Notes</title>"))
		$aReturn[3] = $zModName
	EndIf
;~ 	If $aFirstModCheck Then
	If $sShow Then
;~ 		SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Checking for mod " & $sMod & @CRLF & $zModName & " update or new mod.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
		ControlSetText($aSplashMod, "", "Static1", $aStartText & "Checking for mod " & $sMod & @CRLF & $zModName & " update or new mod.")
	EndIf
	Return $aReturn
EndFunc   ;==>GetLatestModUpdateTime

Func GetInstalledModUpdateTime($sServerDir, $sMod, $sModName, $sShow)
	Local $aReturn[3] = [False, False, ""]
	;	Local Const $sFilePath = $sServerDir & "\steamapps\workshop\appworkshop_440900.acf"
;~ 	If $aFirstModCheck Then
	If $sShow Then
;~ 		SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Checking for installed version of mod" & @CRLF & $sMod & " " & $sModName, 400, 110, -1, -1, $DLG_MOVEABLE, "")
		ControlSetText($aSplashMod, "", "Static1", $aStartText & "Checking for mod updates" & @CRLF & $sMod & " " & $sModName)
	EndIf
	Local Const $sFilePath = $aFolderTemp & "mod_" & $sMod & "_appworkshop.tmp"
	Local $hFileOpen = FileOpen($sFilePath, 0)
	If $hFileOpen = -1 Then
		$aReturn[0] = False
	Else
		$aReturn[0] = True     ;File Exists
		Local $sFileRead = FileRead($hFileOpen)
		Local $aAppInfo = StringSplit($sFileRead, '"WorkshopItemDetails"', 1)
		If UBound($aAppInfo) >= 3 Then
			$aAppInfo = StringSplit($aAppInfo[2], '"' & $sMod & '"', 1)
		EndIf
		If UBound($aAppInfo) >= 3 Then
			$aAppInfo = StringSplit($aAppInfo[2], '"timetouched', 1)
		EndIf
		If UBound($aAppInfo) >= 2 Then
			$aAppInfo = StringSplit($aAppInfo[1], '"', 1)
		EndIf
		If UBound($aAppInfo) >= 9 And StringRegExp($aAppInfo[8], '^\d+$') Then
			$aReturn[1] = True     ;Successfully Read numerical value at positition expected
			$aReturn[2] = $aAppInfo[8]     ;Return Value Read
		EndIf
		If FileExists($sFilePath) Then
			FileClose($hFileOpen)
		EndIf
	EndIf
	Return $aReturn
EndFunc   ;==>GetInstalledModUpdateTime

;Func WriteModList($sServerDir)
;	Local $sModFile = $sServerDir & "\ConanSandbox\Mods\modlist.txt"
;	FileMove($sModFile, $sModFile & ".BAK", 9)
;	Local $aMods = StringSplit($g_sMods, ",")
;	Local $sModName = ""
;	For $i = 1 To $aMods[0]
;		$aMods[$i] = StringStripWS($aMods[$i], 8)
;		$sModName = IniRead($g_c_sMODIDFile, "MODID2MODNAME", $aMods[$i], $aMods[$i])
;		If $aMods[$i] = $sModName Then
;			LogWrite("Could not find Mod name for " & $aMods[$i] & " in " & $g_c_sMODIDFile & " Please refer to README and manually update list.")
;		Else
;			FileWriteLine($sModFile, $sModName)
;		EndIf
;	Next
;EndFunc   ;==>WriteModList

;Func UpdateModNameList($sSteamCmdDir, $sMod)
;	Local $hSearch = FileFindFirstFile($sSteamCmdDir & "\steamapps\workshop\content\440900\" & $sMod & "\*.pak")
;	If $hSearch = -1 Then
;		LogWrite("Error: No Mod Files Found.")
;		Return False
;	Else
;		Local $sFileName = FileFindNextFile($hSearch)
;		IniWrite($g_c_sMODIDFile, "MODID2MODNAME", $sMod, $sFileName)
;	EndIf
;	FileClose($hSearch)
;EndFunc   ;==>UpdateModNameList

Func UpdateMod($sMod, $sModName, $sSteamCmdDir, $sServerDir, $iReason, $sModNo)
	Local $bReturn = False
	;	Local $tModSpace = StringRegExpReplace($sMod, ",", " ")
	SplashTextOn($aUtilName, " Mod " & $sMod & " " & $sModName & @CRLF & " update released or new mod." & @CRLF & "Downloading and installing mod update.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	Local $aModScript = @ScriptDir & "\AtlasModDownloader.exe  --modids " & $sMod & " --steamcmd """ & $sSteamCmdDir & """ --workingdir """ & $sServerDir & """"
	LogWrite(" [Mod] Mod " & $sMod & " " & $sModName & " update released or new mod found. Downloading and installing mod.", " [Mod] Mod " & $sMod & " " & $sModName & " update released or new mod found. Downloading and installing mod:" & $aModScript)
	$aModMsgInGame = AnnounceReplaceModID($sMod, $sModMsgInGame, $sAnnounceNotifyModUpdate, $sModNo)
	$aModMsgDiscord = AnnounceReplaceModID($sMod, $sModMsgDiscord, $sAnnounceNotifyModUpdate, $sModNo)
	$aModMsgTwitch = AnnounceReplaceModID($sMod, $sModMsgTwitch, $sAnnounceNotifyModUpdate, $sModNo)
	$Timer = TimerInit()
	If $aServerMinimizedYN = "no" Then
		Local $tPID = Run($aModScript)
	Else
		Local $tPID = Run($aModScript, "", @SW_MINIMIZE)
	EndIf
	Do
		If Not ProcessExists($tPID) Then ExitLoop
		Sleep(500)
	Until TimerDiff($Timer) > 180000     ; Wait 3 minutes for mod to finish downloading
	If ProcessExists($tPID) Then
		ProcessClose($tPID)
	EndIf
;~ 	RunWait($aModScript)
	If FileExists($sSteamCmdDir & "\steamapps\workshop\" & $aModAppWorkshop) Then
		FileMove($sSteamCmdDir & "\steamapps\workshop\" & $aModAppWorkshop, $aFolderTemp & "mod_" & $sMod & "_appworkshop.tmp", 1)
	EndIf
;~ 	$aRebootReason = "mod"
;~ 	$aBeginDelayedShutdown = 1
;~ 	RunExternalScriptMod()
	SplashOff()
	Return $bReturn
EndFunc   ;==>UpdateMod
#EndRegion ;**** Functions to Check for Mod Updates ****

Func _InetGetMulti($tCnt, $tFile, $tLink1, $tLink2 = "0")
	FileDelete($tFile)
	Local $i = 0
	Local $tTmp = InetGet($tLink1, $tFile, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
	Do
		Sleep(100)
		$i += 1
	Until InetGetInfo($tTmp, $INET_DOWNLOADCOMPLETE) Or $i = $tCnt
	InetClose($tTmp)
	If $i = $tCnt And $tLink2 <> "0" Then
		$tTmp = InetGet($tLink2, $tFile, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
		Do
			Sleep(100)
			$i += 1
		Until InetGetInfo($tTmp, $INET_DOWNLOADCOMPLETE) Or $i = $tCnt
	EndIf
	Local $hFileOpen = FileOpen($tFile, 0)
	Local $hFileRead = FileRead($hFileOpen)
	If $hFileOpen = -1 Then
		FileClose($hFileOpen)
		Local $hFileRead = _INetGetSource($tLink1)
		If @error Then
			If $tLink2 <> "0" Then
				$hFileRead = _INetGetSource($tLink2)
				If @error Then
					Return "Error" ; Error
				Else
					FileClose($hFileOpen)
				EndIf
			Else
				Return True ; Error
			EndIf
		Else
			FileClose($hFileOpen)
		EndIf
	EndIf
	Return $hFileRead ; No error
EndFunc   ;==>_InetGetMulti

#Region ;**** Check for Server Utility Update ****
Func UtilUpdate($tLink, $tDL, $tUtil, $tUtilName, $tSplash = 0, $tUpdate = "show")
	SetStatusBusy("Starting Util Update.")
	Local $tUtilUpdateAvailableTF = False
	If $tUpdate = "show" Then
		Local $tTxt = $aStartText & "Checking for " & $tUtilName & " updates."
		If $tSplash > 0 Then
			ControlSetText($tSplash, "", "Static1", $tTxt)
		Else
			SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
		EndIf
	EndIf
	Local $tVer[2]
	Local $sFilePath = $aFolderTemp & $aUtilName & "_latest_ver.tmp"
	$iGet = _InetGetMulti(20, $sFilePath, $tLink)
	If $iGet = "Error" Then
		LogWrite(" [UTIL] " & $tUtilName & " update check failed to download latest version: " & $tLink)
		If $tUpdate = "show" Then
			If $aShowUpdate Then
				Local $tTxt = $aStartText & $aUtilName & " update check failed." & @CRLF & "Please try again later."
				If $tSplash > 0 Then
					ControlSetText($tSplash, "", "Static1", $tTxt)
				Else
					SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
				EndIf
				Sleep(2000)
				$aShowUpdate = False
			EndIf
		EndIf
	Else
		$tVer = StringSplit($iGet, "^", 2)
		Local $tTxt1 = ReplaceCRLF(ReplaceCRwithCRLF($tVer[1]))
		If $tVer[0] = $tUtil Then
			$tUtilUpdateAvailableTF = False
			LogWrite(" [UTIL] " & $tUtilName & " up to date. Version: " & $tVer[0], " [UTIL] " & $tUtilName & " up to date. Version : " & $tVer[0] & ", Notes : " & $tTxt1)
			If FileExists($aUtilUpdateFile) Then
				FileDelete($aUtilUpdateFile)
			EndIf
			If $tUpdate = "show" Then
				If $aShowUpdate Then
					Local $tTxt = $aStartText & $aUtilName & " up to date . . ."
					If $tSplash > 0 Then
						ControlSetText($tSplash, "", "Static1", $tTxt)
					Else
						SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
					EndIf
					Sleep(2000)
					$aShowUpdate = False
				EndIf
			EndIf
		Else
			$tUtilUpdateAvailableTF = True
			LogWrite(" [UTIL] !!! New " & $aUtilName & " update available. Installed version: " & $tUtil & ", Latest version: " & $tVer[0], " [UTIL] New " & $aUtilName & _
					" update available. Installed version: " & $tUtil & ", Latest version: " & $tVer[0] & ", Notes: " & $tTxt1)
			FileWrite($aUtilUpdateFile, _NowCalc() & " [UTIL] New " & $aUtilName & " update available. Installed version: " & $tUtil & ", Latest version: " & $tVer[0] & ", Notes: " & $tTxt1)
			If ($tUpdate = "show") Or ($tUpdate = "auto") Then
				SplashOff()
				If ($tUpdate = "Auto") And ($aUpdateAutoUtil = "yes") Then
					Local $tMB = 6
				Else
					SetStatusBusy("Util Update. Waiting for User Input.", "Waiting for User Input")
					Local $tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "New " & $aUtilName & " update available. " & @CRLF & "Installed version: " & $tUtil & @CRLF & "Latest version: " & $tVer[0] & @CRLF & @CRLF & _
							"Notes: " & @CRLF & $tVer[1] & @CRLF & @CRLF & _
							"Click (YES) to download update to " & @CRLF & @ScriptDir & @CRLF & _
							"Click (NO) to stop checking for updates." & @CRLF & _
							"Click (CANCEL) to skip this update check.", 15)
				EndIf
				If $tMB = 6 Then
					SplashTextOn($aUtilityVer, " Downloading latest version of " & @CRLF & $tUtilName, 400, 110, -1, -1, $DLG_MOVEABLE, "")
					Local $tZIP = @ScriptDir & "\" & $tUtilName & "_" & $tVer[0] & ".zip"
					If FileExists($tZIP) Then
						FileDelete($tZIP)
					EndIf
					If FileExists($tUtilName & "_" & $tVer[0] & ".exe") Then
						FileDelete($tUtilName & "_" & $tVer[0] & ".exe")
					EndIf
					InetGet($tDL, $tZIP, 1)
					_ExtractZip($tZIP, "", $tUtilName & "_" & $tVer[0] & ".exe", @ScriptDir)
					If FileExists(@ScriptDir & "\readme.txt") Then
						FileDelete(@ScriptDir & "\readme.txt")
					EndIf
					_ExtractZip($tZIP, "", "readme.txt", @ScriptDir)
					;				FileDelete(@ScriptDir & "\" & $tUtilName & "_" & $tVer[1] & ".zip")
					If Not FileExists(@ScriptDir & "\" & $tUtilName & "_" & $tVer[0] & ".exe") Then
						LogWrite(" [UTIL] ERROR! " & $tUtilName & ".exe download failed.")
						SplashOff()
						$tMB = MsgBox($MB_OKCANCEL, $aUtilityVer, "Utility update download failed . . . " & @CRLF & "Go to """ & $tLink & """ to download latest version." & @CRLF & @CRLF & "Click (OK), (CANCEL), or wait 60 seconds, to resume current version.", 60)
					Else
						SplashOff()
						If ($tUpdate = "Auto") And ($aUpdateAutoUtil = "yes") Then
							$tMB = MsgBox($MB_OKCANCEL, $aUtilityVer, "Auto utility update download complete. . . " & @CRLF & @CRLF & "Click (OK) to run new version or wait 60 seconds (servers will remain running) OR" & @CRLF & "Click (CANCEL) to resume current version.", 60)
							If $tMB = 1 Then ; OK

							ElseIf $tMB = -1 Then
								$tMB = 1 ; OK
							ElseIf $tMB = 2 Then ; CANCEL

							EndIf
						Else
							$tMB = MsgBox($MB_OKCANCEL, $aUtilityVer, "Utility update download complete. . . " & @CRLF & @CRLF & "Click (OK) to run new version (servers will remain running) OR" & @CRLF & "Click (CANCEL), or wait 15 seconds, to resume current version.", 15)
						EndIf
						If $tMB = 1 Then
							LogWrite(" [UTIL] Update download complete. Shutting down current version and starting new version. Initiated by User or Auto Update.")
							CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
							PIDSaveServer($aServerPID, $aPIDServerFile)
							PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
							Run(@ScriptDir & "\" & $tUtilName & "_" & $tVer[0] & ".exe")
							Exit
						Else
							LogWrite(" [UTIL] Update download complete. Per user request, continuing to run current version. Resuming utility . . .")
							SplashTextOn($aUtilName, "Utility update check canceled by user." & @CRLF & "Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
							Sleep(2000)
							SplashOff()
						EndIf
					EndIf
				ElseIf $tMB = 7 Then
					$aUpdateUtil = "0"
					IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Check for " & $aUtilName & " updates every __ hours (0 to disable) (0-24) ###", $aUpdateUtil)
					LogWrite(" [UTIL] " & "Utility update check disabled. To enable update check, " & @CRLF & "change [Check for Updates ###=yes] in the .ini.")
					SplashTextOn($aUtilName, "Utility update check disabled." & @CRLF & "To enable update check, change [Check for Updates ###=yes] in the .ini.", 500, 110, -1, -1, $DLG_MOVEABLE, "")
					Sleep(5000)
					SplashOff()
				ElseIf $tMB = 2 Then
					LogWrite(" [UTIL] Utility update check canceled by user. Resuming utility . . .")
					SplashTextOn($aUtilName, "Utility update check canceled by user." & @CRLF & "Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
					Sleep(2000)
					SplashOff()
				EndIf
			EndIf
		EndIf
	EndIf
	SetStatusIdle()
	Return $tUtilUpdateAvailableTF
EndFunc   ;==>UtilUpdate
#EndRegion ;**** Check for Server Utility Update ****

Func ReplaceReturn($tMsg0)
	Return StringReplace($tMsg0, "|", @CRLF)
EndFunc   ;==>ReplaceReturn

Func ReplaceCRLF($tMsg0)
	Return StringReplace($tMsg0, @CRLF, "|")
EndFunc   ;==>ReplaceCRLF

Func ReplaceSpace($tMsg0)
;~ 	If StringInStr($tMsg0, "%") = "0" Then
;~ 	Else
	Return StringReplace($tMsg0, "%", Chr(32))
;~ 	EndIf
EndFunc   ;==>ReplaceSpace

Func ReplaceCRwithCRLF($sString)     ; Initial Regular expression by Melba23 with a new suggestion by Ascend4nt and modified By guinness.
	Return StringRegExpReplace($sString, '(*BSR_ANYCRLF)\R', @CRLF)     ; Idea by Ascend4nt
EndFunc   ;==>ReplaceCRwithCRLF

Func MakeServerSummaryFile($tServerSummaryFile)
;~ 	If FileExists($tServerSummaryFile) Then
	FileDelete($tServerSummaryFile)
	Sleep(250)
;~ 	EndIf
	FileWriteLine($tServerSummaryFile, _NowCalc() & @CRLF & " ------------------------- SERVER SUMMARY -------------------------" & @CRLF & @CRLF)
;~ 	If $xServerAltSaveDir = "" Then
;~ 		For $i = 0 To ($aServerGridTotal - 1)
;~ 			If $xStartGrid[$i] = "no" Then
;~ 				$xStartGrid[$i] = "no "
;~ 			EndIf
;~ 			FileWriteLine($tServerSummaryFile, "[Server " & $xServergridx[$i] & $xServergridy[$i] & "] Use:" & $xStartGrid[$i] & ", QueryPort:" & $xServerport[$i] & ", Port:" & $xServergameport[$i] & _
;~ 					", SeamlessIP:" & $xServerIP[$i] & ", RCON:" & $xServerRCONPort[$i + 1] & ", DIR:" & $xServergridx[$i] & $xServergridy[$i] & ", PID:" & $aServerPID[$i])
;~ 		Next
;~ 	Else
	For $i = 0 To ($aServerGridTotal - 1)
		If $xStartGrid[$i] = "no" Then
			$xStartGrid[$i] = "no "
		EndIf
		FileWriteLine($tServerSummaryFile, " [Server " & $xServergridx[$i] & $xServergridy[$i] & "] Use:" & $xStartGrid[$i] & " QueryPort:" & $xServerport[$i] & ", Port:" & $xServergameport[$i] & _
				", SeamlessIP:" & $xServerIP[$i] & ", SeamlessDataPort:" & $xServerseamlessDataPort[$i] & ", RCON:" & $xServerRCONPort[$i + 1] & ", DIR:" & $xServerAltSaveDir[$i] & ", PID:" & $aServerPID[$i])
	Next
;~ 	EndIf
	Local $aWAN = _GetIP()
	FileWriteLine($aServerSummaryFile, @CRLF & _
			"            AdminPassword: " & $aServerAdminPass & @CRLF & _
			"               MaxPlayers: " & $aServerMaxPlayers & @CRLF & _
			"      ReservedPlayerSlots: " & $aServerReservedSlots & @CRLF & _
			"                Multihome: " & $aServerMultiHomeIP & @CRLF & _
			"    Server Extra Commands: " & $aServerExtraCMD & @CRLF & _
			"  SteamCMD Extra Commands: " & $aSteamExtraCMD & @CRLF)
	If $aServerModYN = "yes" Then
		FileWriteLine($aServerSummaryFile, _
				"          Mod Number List: " & $aServerModList & @CRLF & _
				"                Mod Names: " & _ArrayToString($aModName) & @CRLF)
	Else
		FileWriteLine($aServerSummaryFile, _
				"          Mod Number List: " & @CRLF & _
				"                Mod Names: " & @CRLF)
	EndIf
	FileWriteLine($aServerSummaryFile, _
			"          Local Server IP: " & @IPAddress1 & @CRLF & _
			"                   WAN IP: " & $aWAN & @CRLF & @CRLF)
	If $aRemoteRestartUse = "yes" Then
		FileWriteLine($aServerSummaryFile, _
				"Remote Restart Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/?" & $aRemoteRestartKey & "=" & $aRemoteRestartCode & @CRLF & _
				"  Remote Restart WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/?" & $aRemoteRestartKey & "=" & $aRemoteRestartCode & @CRLF & @CRLF & _
				"RCON Broadcast Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & _
				"  RCON Broadcast WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & @CRLF & _
				"  RCON Command Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)" & @CRLF & _
				"    RCON Command WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)")
	Else
		FileWriteLine($aServerSummaryFile, _
				"Remote Restart Local Link: http://" & @CRLF & _
				"  Remote Restart WAN Link: http://" & @CRLF & @CRLF & _
				"RCON Broadcast Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & _
				"  RCON Broadcast WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & @CRLF & _
				"  RCON Command Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)" & @CRLF & _
				"    RCON Command WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)")
	EndIf

	FileWriteLine($aServerSummaryFile, @CRLF & "Settings listed in the order as listed in ServerGrid.json: (if having server problems, paste the following in the appropriate section in the " & $aUtilName & ".ini file)")
	Local $tRCON = "              RCON ports: "
	For $i = 1 To ($aServerGridTotal - 1)
		$tRCON = $tRCON & $xServerRCONPort[$i] & ","
	Next
	$tRCON = $tRCON & $xServerRCONPort[$aServerGridTotal]
	FileWriteLine($aServerSummaryFile, $tRCON)

	Local $tDIR = "              AltSaveDIR: "
;~ 	If $xServerAltSaveDir = "" Then
;~ 		For $i = 0 To ($aServerGridTotal - 2)
;~ 			$tDIR = $tDIR & $xServergridx[$i] & $xServergridy[$i] & ","
;~ 		Next
;~ 		$tDIR = $tDIR & $xServergridx[$aServerGridTotal - 1] & $xServergridy[$aServerGridTotal - 1]
;~ 	Else
	For $i = 0 To ($aServerGridTotal - 2)
		$tDIR = $tDIR & $xServerAltSaveDir[$i] & ","
	Next
	$tDIR = $tDIR & $xServerAltSaveDir[$aServerGridTotal - 1]
;~ 	EndIf
	FileWriteLine($aServerSummaryFile, $tDIR)
	LogWrite(" Created server summary file: " & $tServerSummaryFile)
EndFunc   ;==>MakeServerSummaryFile

Func _HTTP_ResponseText($URL)
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("GET", $URL)
	$oHTTP.SetRequestHeader("User-Agent", "Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.0.10) Gecko/2009042316 Firefox/3.0.10 (.NET CLR 4.0.20506)")
	$oHTTP.Send()
	Return $oHTTP.ResponseText
EndFunc   ;==>_HTTP_ResponseText

Func F_ExitCloseN($tRestart = False)
	LogWrite(" [" & $aServerName & "] Utility exit without server shutdown initiated by user (Exit: Do NOT Shut Down Servers).")
	;	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Do you wish to close this utility?" & @CRLF & "(all servers and redis will remain running)" & @CRLF & @CRLF & _
	;			"Click (YES) to close this utility." & @CRLF & _
	;			"Click (NO) or (CANCEL) to cancel.", 15)
	;	If $tMB = 6 Then ; (YES)
	SplashOff()
	If ($aServerUseRedis = "yes") And ($aPIDRedisreadYetTF = False) Or ($aPIDServerReadYetTF = False) Then
		If $aServerUseRedis = "yes" Then
			Local $aMsg = "Closing Utility. If Redis and/or Servers were running, they will remain running."
		Else
			Local $aMsg = "Closing Utility. If Servers were running, they will remain running."
		EndIf
		LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
		CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
		If $tRestart = False Then
			MsgBox(0, $aUtilityVer, $aMsg, 20)
			LogWrite(" [Util] " & $aUtilityVer & " Stopped by User")
		Else
			LogWrite(" [Util] " & $aUtilityVer & " Restarting Util")
			If @Compiled = 1 Then
				Run(FileGetShortName(@ScriptFullPath))
			Else
				Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
			EndIf
;~ 	Run(@ScriptDir & "\" & $aUtilName & "_" & $tVer[0] & ".exe")
		EndIf
		Exit
	Else
		If $tRestart = False Then
			MsgBox(4096, $aUtilityVer, "Thank you for using " & $aUtilName & "." & @CRLF & @CRLF & "SERVERS AND REDIS ARE STILL RUNNING ! ! !" & @CRLF & @CRLF & _
					"Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
					"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com", 20)
			LogWrite(" [Util] " & $aUtilityVer & " Stopped by User")
		Else
			LogWrite(" [Util] " & $aUtilityVer & " Restarting Util")
		EndIf
		PIDSaveServer($aServerPID, $aPIDServerFile)
		PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
		CFGLastClose()
		CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
		If $tRestart Then
			If @Compiled = 1 Then
				Run(FileGetShortName(@ScriptFullPath))
			Else
				Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
			EndIf
;~ 	Run(@ScriptDir & "\" & $aUtilName & "_" & $tVer[0] & ".exe")
		EndIf
		Exit
	EndIf

	;	Else
	;		SplashTextOn($aUtilName, "Shutdown canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	;		Sleep(2000)
	;	EndIf
EndFunc   ;==>F_ExitCloseN

Func F_ExitCloseY($tRestart = False)
	SetStatusBusy("Util Shutdown Initiated")
	If $tRestart = False Then
		LogWrite(" [" & $aServerName & "] Utility exit with server shutdown initiated by user (Exit: Shut Down Servers).")
	EndIf
	If ($aServerUseRedis = "yes") And ($aPIDRedisreadYetTF = False) Or ($aPIDServerReadYetTF = False) Then
		If $aServerUseRedis = "yes" Then
			Local $aMsg = "Closing Utility. If Redis and/or Servers were running, they will remain running."
		Else
			Local $aMsg = "Closing Utility. If Servers were running, they will remain running."
		EndIf
		LogWrite(" [Util] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
		CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
		If $tRestart = False Then
			MsgBox(0, $aUtilityVer, $aMsg, 20)
			LogWrite(" [Util] " & $aUtilityVer & " Stopped by User")
		Else
			LogWrite(" [Util] " & $aUtilityVer & " Restarting Util")
			If @Compiled = 1 Then
				Run(FileGetShortName(@ScriptFullPath))
			Else
				Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
			EndIf
		EndIf
		Exit
	Else
		SetStatusBusy("Util Shutdown. Waiting for User Input.", "Waiting for User Input")
		If $aServerUseRedis = "yes" Then
			$bMsg = "Utility exited unexpectedly or before it was fully initialized." & @CRLF & @CRLF & _
					"Close utility?" & @CRLF & @CRLF & _
					"Click (YES) to shutdown all servers and redis and exit utility." & @CRLF & _
					"Click (NO) to shutdown all servers BUT LEAVE REDIS RUNNING." & @CRLF & _
					"Click (CANCEL) to exit utility but leave servers and redis still running."
		Else
			$bMsg = "Utility exited unexpectedly or before it was fully initialized." & @CRLF & @CRLF & _
					"Close utility?" & @CRLF & @CRLF & _
					"Click (YES) to shutdown all servers and exit utility." & @CRLF & _
					"Click (NO) or (CANCEL) to exit utility but leave servers running."
		EndIf
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $bMsg, 60)
;~ $tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Do you wish to shut down all servers and exit this utility?" & @CRLF & @CRLF & _
;~ 			"Click (YES) to Shutdown all servers and exit." & @CRLF & _
;~ 			"Click (NO) or (CANCEL) to cancel.", 15)
		SetStatusBusy("Util Shutdown Initiated.")
		If $tMB = 6 Then     ; (YES)
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, True, False)
			SplashOff()
			If ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
				LogWrite(" [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
				ProcessClose($aServerPIDRedis)
				If FileExists($aPIDRedisFile) Then
					FileDelete($aPIDRedisFile)
				EndIf
			EndIf
			SplashOff()
			If $tRestart = False Then
				MsgBox(4096, $aUtilityVer, "Thank you for using " & $aUtilName & "." & @CRLF & "Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
						"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com", 20)
				LogWrite(" [Util] " & $aUtilityVer & " Stopped by User")
			Else
				LogWrite(" [Util] " & $aUtilityVer & " Restarting Util")
			EndIf
			;		If FileExists($aPIDRedisFile) Then
			;			FileDelete($aPIDRedisFile)
			;		EndIf
			;		If FileExists($aPIDServerFile) Then
			;			FileDelete($aPIDServerFile)
			;		EndIf
			CFGLastClose()
			If $tRestart Then
				If @Compiled = 1 Then
					Run(FileGetShortName(@ScriptFullPath))
				Else
					Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
				EndIf
;~ 	Run(@ScriptDir & "\" & $aUtilName & "_" & $tVer[0] & ".exe")
			EndIf
			Exit
			; ----------------------------------------------------------
		ElseIf $tMB = 7 Then     ; NO
			Local $aMsg = "Thank you for using " & $aUtilName & "." & @CRLF & "Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
					"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com"
			LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)     ; Do NOT close redis
			SplashOff()
			If $tRestart = False Then
				MsgBox(4096, $aUtilityVer, $aMsg, 20)
				LogWrite(" [Util] " & $aUtilityVer & " Stopped by User")
			Else
				LogWrite(" [Util] " & $aUtilityVer & " Restarting Util")
				If @Compiled = 1 Then
					Run(FileGetShortName(@ScriptFullPath))
				Else
					Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
				EndIf
;~ 	Run(@ScriptDir & "\" & $aUtilName & "_" & $tVer[0] & ".exe")
			EndIf
			Exit
			; ----------------------------------------------------------
		Else
			Local $aMsg = "Thank you for using " & $aUtilName & "." & @CRLF & "Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
					"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com"
			LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
			SplashOff()
			If $tRestart = False Then
				MsgBox(4096, $aUtilityVer, $aMsg, 20)
				LogWrite(" [Util] " & $aUtilityVer & " Stopped by User")
			Else
				LogWrite(" [Util] " & $aUtilityVer & " Restarting Util")
				If @Compiled = 1 Then
					Run(FileGetShortName(@ScriptFullPath))
				Else
					Run(FileGetShortName(@AutoItExe) & " " & FileGetShortName(@ScriptFullPath))
				EndIf
			EndIf
			PIDSaveServer($aServerPID, $aPIDServerFile)
			PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
			CFGLastClose()
			CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
			Exit
		EndIf
	EndIf
	SetStatusIdle()
EndFunc   ;==>F_ExitCloseY

Func F_RestartNow()
	SetStatusBusy("Restart Now. Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [Server] Restart Server Now requested by user (Restart Server Now) Redis will remain running.")
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Do you wish to Restart Server Now?" & @CRLF & @CRLF & _
			"Click (YES) to Restart Server Now." & @CRLF & _
			"Click (NO) or (CANCEL) to cancel.", 15)
	If $tMB = 6 Then     ; (YES)
		;		If $aBeginDelayedShutdown = 0 Then
		LogWrite(" [Server] Restart Server Now request initiated by user.")
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)     ; Do NOT close redis
		;		EndIf
	Else
		LogWrite(" [Server] Restart Server Now request canceled by user.")
		SplashTextOn($aUtilName, "Restart Server Now canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
		Sleep(2000)
	EndIf
	SplashOff()
	SetStatusIdle()
EndFunc   ;==>F_RestartNow

Func F_RemoteRestart()
	SetStatusBusy("Remote Restart. Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [Remote Restart] Remote Restart requested by user (Initiate Remote Restart).")
	If $aRemoteRestartUse <> "yes" Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "You must enable Remote Restart in the " & $aUtilName & ".ini." & @CRLF & @CRLF & _
				"Would you like to enable it? (Port:" & $aRemoteRestartPort & ")" & @CRLF & _
				"Click (YES) to enable Remote Restart. A utility restart will be required (including shutting down all servers. COMING SOON, this will not be required)" & @CRLF & _
				"Click (NO) or (CANCEL) to skip.", 15)
		If $tMB = 6 Then     ; (YES)
			LogWrite(" [Remote Restart] Remote Restart enabled in " & $aUtilName & ".ini per user request")
			IniWrite($aIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Use Remote Restart? (yes/no) ###", "yes")
			$aRemoteRestartUse = "yes"
			MsgBox($MB_OK, $aUtilityVer, "Remote Restart enabled in " & $aUtilName & ".ini. " & @CRLF & "Please restart this utility for Remote Restart to be started.", 5)
			;ElseIf $tMB = 7 Then  ;(NO)
			;ElseIf $tMB = 2 Then  ; (CANCEL)
		Else
			LogWrite(" [Remote Restart] No changes made to Remote Restart setting in " & $aUtilName & ".ini per user request.")
			SplashTextOn($aUtilName, "No changes were made. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
			SplashOff()
		EndIf
	Else
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Do you wish to initiate Remote Restart (reboot all servers in " & $aRemoteTime[$aRemoteCnt] & "min)?" & @CRLF & @CRLF & _
				"Click (YES) to Initiate Remote Restart." & @CRLF & _
				"Click (NO) or (CANCEL) to cancel.", 15)
		If $tMB = 6 Then     ; (YES)
			If $aBeginDelayedShutdown = 0 Then
				LogWrite(" [Remote Restart] Remote Restart request initiated by user.")
				If ($sUseDiscordBotRemoteRestart = "yes") Or ($sUseTwitchBotRemoteRestart = "yes") Or ($sInGameAnnounce = "yes") Then
					$aRebootReason = "remoterestart"
					$aBeginDelayedShutdown = 1
					$aTimeCheck0 = _NowCalc()
				Else
					RunExternalRemoteRestart()
					CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)     ; Do NOT close redis
				EndIf
			EndIf
		Else
			LogWrite(" [Remote Restart] Remote Restart request canceled by user.")
			SplashTextOn($aUtilName, "Remote Restart canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
			SplashOff()
		EndIf
	EndIf
	SetStatusIdle()
EndFunc   ;==>F_RemoteRestart

Func SetStatusBusy($tMsg0, $tMsg1 = "no")
	If $tMsg1 = "no" Then $tMsg1 = $tMsg0
	TraySetToolTip($tMsg0)
	TraySetIcon($aIconFile, 201)
	GUICtrlSetImage($IconReady, $aIconFile, 203)     ; Busy Icon
	GUICtrlSetData($LabelUtilReadyStatus, $tMsg1)
EndFunc   ;==>SetStatusBusy

Func SetStatusIdle()
	GUICtrlSetImage($IconReady, $aIconFile, 204)
	GUICtrlSetData($LabelUtilReadyStatus, "Idle")
	TraySetToolTip($aIconFile)
	TraySetIcon($aIconFile, 99)
EndFunc   ;==>SetStatusIdle

Func F_StopServer()
	SetStatusBusy("Stop server(s). Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [" & $aServerName & "] Send shutdown (DoExit) command to servers requested by user (Stop Server(s)).")
	Local $aMsg = "Do you wish to shut down servers?" & @CRLF & @CRLF & _
			"Click (YES) to shut down in " & $aStopServerTime[$aStopServerCnt] & " min with announcements?" & @CRLF & _
			"Click (NO) to shut down servers now without announcements." & @CRLF & _
			"Click (CANCEL) to cancel."
	SplashOff()
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 15)
	; ----------------------------------------------------------
	If $tMB = 6 Then                 ; YES
		If $aBeginDelayedShutdown = 0 Then
			SetStatusBusy("Stop Server Started")
			LogWrite(" [" & $aServerName & "] Stop Server request initiated by user.")
			If ($sUseDiscordBotStopServer = "no") And (IniRead($aUtilCFGFile, "CFG", "aAskStopServerDiscord", "yes") = "yes") Then
				IniWrite($aUtilCFGFile, "CFG", "aAskStopServerDiscord", "no")
				$tMB1 = MsgBox($MB_YESNOCANCEL, $aUtilName, "Notice! Discord announcement for STOP SERVER is disabled in " & @CRLF & $aUtilName & ".ini." & @CRLF & @CRLF & _
						"Would you like to enable it?" & @CRLF & _
						"Click (YES) to enable STOP SERVER Discord announcement" & @CRLF & _
						"Click (NO) or (CANCEL) to keep STOP SERVER Discord announcement disabled.", 20)
				If $tMB1 = 6 Then ; (YES)
					LogWrite(" [" & $aServerName & "] STOP SERVER Discord announcement enabled in " & $aUtilName & ".ini.")
					SplashTextOn($aUtilName, "Stop Server Discord and In-Game Announcements were disabled." & @CRLF & @CRLF & "The following setting was changed in the " & $aUtilName & ".ini." & @CRLF _
							 & """Send Discord message for STOP SERVER? (yes/no) ###=yes""", 500, 150, -1, -1, $DLG_MOVEABLE, "")
					$sUseDiscordBotStopServer = "yes"
					IniWrite($aIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for STOP SERVER? (yes/no) ###", "yes")
					Sleep(7000)
					SplashOff()
				Else
					LogWrite(" [" & $aServerName & "] No changes made to STOP SERVER Discord announcement setting in " & $aUtilName & ".ini.")
					SplashTextOn($aUtilName, "No changes were made. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
					Sleep(2000)
					SplashOff()
				EndIf
			EndIf
			If ($sUseDiscordBotStopServer = "yes") Or ($sUseTwitchBotStopServer = "yes") Or ($sInGameAnnounce = "yes") Then
				$aRebootReason = "stopservers"
				$aBeginDelayedShutdown = 1
				$aTimeCheck0 = _NowCalc()
				SplashTextOn($aUtilName, "Stop Server with announcements initiated.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
				Sleep(2000)
				SplashOff()
			Else
				LogWrite(" [" & $aServerName & "] Stop Server Discord, Twitch, and In-Game announcements are disabled in " & @CRLF & $aUtilName & ".ini.")
				SplashTextOn($aUtilName, "Stop Server Discord, Twitch, and In-Game announcements are disabled." & @CRLF & @CRLF & "Stopping servers WITHOUT announcements", 500, 150, -1, -1, $DLG_MOVEABLE, "")
				SetStatusBusy("Stopping Servers")
				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, True)     ; Do NOT close redis, But disable servers
				SetStatusIdle()
				SplashOff()
			EndIf
		EndIf
		; ----------------------------------------------------------
	ElseIf $tMB = 7 Then
		SetStatusBusy("Stopping Servers")
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, True)     ; Do NOT close redis, But disable servers
		SetStatusIdle()
		; ----------------------------------------------------------
	ElseIf $tMB = 2 Then     ; CANCEL
		SetStatusBusy("Canceled")
		LogWrite(" [" & $aServerName & "] Stop Server request canceled by user.")
		SplashTextOn($aUtilName, "Stop Server canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
		Sleep(2000)
		SplashOff()
	EndIf
	SetStatusIdle()
EndFunc   ;==>F_StopServer

Func F_UpdateUtilCheck()
	LogWrite(" [Util] " & $aUtilName & " update check requested by user (Check for Updates).")
	$aShowUpdate = True
	UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName, 0, "show")
EndFunc   ;==>F_UpdateUtilCheck

Func F_UpdateServCheck()
	SplashOff()
	SplashTextOn($aUtilName, "Checking for server updates.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	SetStatusBusy("Check: Server Update")
	UpdateCheck(True)
	SetStatusIdle()
	SplashOff()
EndFunc   ;==>F_UpdateServCheck

Func F_SendMessage($tAllorSel = "ask")
	SetStatusBusy("Send Message. Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [Remote RCON] Broadcast message requested by user (Send message).")
	SplashOff()
	;	$tMsg = ""
	If $aGridSomeDisable And $tAllorSel = "ask" Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Send in-game message to ALL servers, including disabled ones in GridStartSelect?" & @CRLF & @CRLF & _
				"Click (YES) to send message to ALL servers." & @CRLF & _
				"Click (NO) to send to LOCAL hosted servers (only ones marked ""yes"" in GridStartSelect)." & @CRLF & _
				"Click (CANCEL) to cancel.", 15)
		;		If $tMB = 6 Then ; (YES)
		If $tMB = 2 Then
			LogWrite(" [Remote RCON] Broadcast message canceled by user.")
			SplashTextOn($aUtilName, "Broadcast Message canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		Else
			$tMsg = InputBox($aUtilName, "Enter message to broadcast to all active servers", "", "", 400, 125)
			If $tMsg = "" Then
				LogWrite(" [Remote RCON] Broadcast message canceled by user.")
				SplashTextOn($aUtilName, "Broadcast Message canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
				Sleep(2000)
			Else
				$tMsg = "broadcast " & $tMsg
				If $tMB = 6 Then
					LogWrite(" [Remote RCON] Sending message to ALL servers, including disabled ones in GridStartSelect:" & $tMsg)
					SplashTextOn($aUtilName, "Sending message to ALL servers. " & $tMsg, 5)
					For $i = 0 To ($aServerGridTotal - 1)
						SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
					Next
					SplashTextOn($aUtilName, "Broadcast Message sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
					Sleep(2000)
				ElseIf $tMB = 7 Then
					LogWrite(" [Remote RCON] Sending message to local servers:" & $tMsg)
					SplashTextOn($aUtilName, "Sending message to local servers. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
					For $i = 0 To ($aServerGridTotal - 1)
						;						If ProcessExists($aServerPID[$i]) Then
						If $xStartGrid[$i] = "yes" Then
							SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
						EndIf
					Next
					SplashTextOn($aUtilName, "Broadcast Message sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
					Sleep(2000)
				EndIf
			EndIf
		EndIf
	ElseIf $tAllorSel = "all" Then
		$tMsg = InputBox($aUtilName, "Enter message to broadcast to all servers", "", "", 400, 125)
		If $tMsg = "" Then
			LogWrite(" [Remote RCON] Broadcast message canceled by user.")
			SplashTextOn($aUtilName, "Broadcast Message canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		Else
			$tMsg = "broadcast " & $tMsg
			LogWrite(" [Remote RCON] Sending message to all servers: " & $tMsg)
			SplashTextOn($aUtilName, "Sending message to ALL servers. " & $tMsg, 5)
			For $i = 0 To ($aServerGridTotal - 1)
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
			Next
			SplashTextOn($aUtilName, "Broadcast Message sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		EndIf
	ElseIf $tAllorSel = "sel" Then
		$tMsg = InputBox($aUtilName, "Enter message to broadcast to selected servers", "", "", 400, 125)
		If $tMsg = "" Then
			LogWrite(" [Remote RCON] Broadcast message canceled by user.")
			SplashTextOn($aUtilName, "Broadcast Message canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		Else
			$tMsg = "broadcast " & $tMsg
			LogWrite(" [Remote RCON] Sending message to selected servers:" & $tMsg)
			SplashTextOn($aUtilName, "Sending message to selected servers. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			For $i = 0 To ($aServerGridTotal - 1)
				If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
					SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
				EndIf
			Next
			SplashTextOn($aUtilName, "Broadcast Message sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		EndIf
	EndIf
	SetStatusIdle()
	SplashOff()
EndFunc   ;==>F_SendMessage

Func F_SendRCON($tAllorSel = "ask", $tMsgCmd = "")
	SetStatusBusy("Send RCON. Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [Remote RCON] Send RCON command requested by user (Send command).")
	SplashOff()
	;	$tMsg = ""
	If $aGridSomeDisable And $tAllorSel = "ask" Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Send Send RCON command to ALL servers, including disabled ones in GridStartSelect?" & @CRLF & @CRLF & _
				"Click (YES) to send RCON command to ALL servers." & @CRLF & _
				"Click (NO) to send to LOCAL hosted servers (only ones marked ""yes"" in GridStartSelect)." & @CRLF & _
				"Click (CANCEL) to cancel.", 15)
		;		If $tMB = 6 Then ; (YES)
		If $tMB = 2 Then
			LogWrite(" [Remote RCON] Send RCON command canceled by user.")
			SplashTextOn($aUtilName, "Send RCON command canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		Else
			$tMsg = InputBox($aUtilName, "Enter RCON command to send to all active servers", "", "", 400, 125)
			If $tMsg = "" Then
				LogWrite(" [Remote RCON] Send RCON command canceled by user.")
				SplashTextOn($aUtilName, "Send RCON command canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
				Sleep(2000)
			Else
				If $tMB = 6 Then
					LogWrite(" [Remote RCON] Sending RCON command to ALL servers, including disabled ones in GridStartSelect:" & $tMsg)
					SplashTextOn($aUtilName, "Sending RCON command to ALL servers. " & $tMsg, 5)
					For $i = 0 To ($aServerGridTotal - 1)
						SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
					Next
					SplashTextOn($aUtilName, "RCON command sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
					Sleep(2000)
				ElseIf $tMB = 7 Then
					LogWrite(" [Remote RCON] Sending RCON command to local servers:" & $tMsg)
					SplashTextOn($aUtilName, "Sending RCON command to local servers. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
					For $i = 0 To ($aServerGridTotal - 1)
						;						If ProcessExists($aServerPID[$i]) Then
						If $xStartGrid[$i] = "yes" Then
							SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
						EndIf
					Next
					SplashTextOn($aUtilName, "RCON command sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
					Sleep(2000)
				EndIf
			EndIf
		EndIf
	ElseIf $tAllorSel = "all" Then
		If $tMsgCmd = "" Then
			$tMsg = InputBox($aUtilName, "Enter RCON command to send to all servers", "", "", 400, 125)
		Else
			$tMsg = $tMsgCmd
		EndIf
		If $tMsg = "" Then
			LogWrite(" [Remote RCON] Send RCON command canceled by user.")
			SplashTextOn($aUtilName, "Send RCON command canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		Else
			LogWrite(" [Remote RCON] Sending RCON command to all servers: " & $tMsg)
			If $tMsgCmd = "" Then
				SplashTextOn($aUtilName, "Sending RCON command to ALL servers. " & $tMsg, 5)
			EndIf
			For $i = 0 To ($aServerGridTotal - 1)
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
			Next
			If $tMsgCmd = "" Then
				SplashTextOn($aUtilName, "RCON command sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
				Sleep(2000)
			EndIf
		EndIf
	ElseIf $tAllorSel = "sel" Then
		If $tMsgCmd = "" Then
			$tMsg = InputBox($aUtilName, "Enter RCON command to send to selected servers", "", "", 400, 125)
		Else
			$tMsg = $tMsgCmd
		EndIf
		LogWrite(" [Remote RCON] Sending RCON command to selected servers:" & $tMsg)
		If $tMsgCmd = "" Then
			SplashTextOn($aUtilName, "Sending RCON command to selected servers. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
		EndIf
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
			EndIf
		Next
		If $tMsgCmd = "" Then
			SplashTextOn($aUtilName, "RCON command sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		EndIf
	ElseIf $tAllorSel = "local" Then
		If $tMsgCmd = "" Then
			$tMsg = InputBox($aUtilName, "Enter RCON command to send to selected servers", "", "", 400, 125)
		Else
			$tMsg = $tMsgCmd
		EndIf
		LogWrite(" [Remote RCON] Sending RCON command to selected servers:" & $tMsg)
		If $tMsgCmd = "" Then
			SplashTextOn($aUtilName, "Sending RCON command to selected servers. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
		EndIf
		For $i = 0 To ($aServerGridTotal - 1)
			If $xStartGrid[$i] = "yes" Then
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
			EndIf
		Next
		If $tMsgCmd = "" Then
			SplashTextOn($aUtilName, "RCON command sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		EndIf
	EndIf
	SetStatusIdle()
	SplashOff()
EndFunc   ;==>F_SendRCON

Func SelectServersStop()
	SetStatusBusy("Stop select server(s). Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [Remote RCON] Send shutdown (DoExit) command to select servers requested by user (Stop Server(s)).")
	$bMsg = "Shut down selected server(s)." & @CRLF & @CRLF & _
			"Click (YES) to shutdown select servers WITH an announcement." & @CRLF & _
			"Click (NO)  to shutdown select servers with NO announcement." & @CRLF & _
			"Click (CANCEL) to cancel."
	SplashOff()
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $bMsg, 60)
	; ----------------------------------------------------------
	If $tMB = 6 Then                 ; YES
		If $aBeginDelayedShutdown = 0 Then
			$tSelectServersTxt = ""
			For $i = 0 To ($aServerGridTotal - 1)
				If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
					$tSelectServersTxt &= $xServergridx[$i] & $xServergridy[$i] & " "
				EndIf
			Next
			$aStopServerMsgInGame = AnnounceReplaceTime($sAnnounceNotifyStopServer, $tSelectServersTxt & $sInGameStopServerMessage)
			$aStopServerMsgDiscord = AnnounceReplaceTime($sAnnounceNotifyStopServer, $tSelectServersTxt & $sDiscordStopServerMessage)
			$aStopServerMsgTwitch = AnnounceReplaceTime($sAnnounceNotifyStopServer, $tSelectServersTxt & $sTwitchStopServerMessage)
			SetStatusBusy("Stop Server Started")
			LogWrite(" [" & $aServerName & "] Stop Server request initiated by user. Servers: " & $tSelectServersTxt)
			If ($sUseDiscordBotStopServer = "no") And (IniRead($aUtilCFGFile, "CFG", "aAskStopServerDiscord", "yes") = "yes") Then
				IniWrite($aUtilCFGFile, "CFG", "aAskStopServerDiscord", "no")
				$tMB1 = MsgBox($MB_YESNOCANCEL, $aUtilName, "Notice! Discord announcement for STOP SERVER is disabled in " & @CRLF & $aUtilName & ".ini." & @CRLF & @CRLF & _
						"Would you like to enable it?" & @CRLF & _
						"Click (YES) to enable STOP SERVER Discord announcement" & @CRLF & _
						"Click (NO) or (CANCEL) to keep STOP SERVER Discord announcement disabled.", 20)
				If $tMB1 = 6 Then ; (YES)
					LogWrite(" [" & $aServerName & "] STOP SERVER Discord announcement enabled in " & $aUtilName & ".ini.")
					SplashTextOn($aUtilName, "Stop Server Discord and In-Game Announcements were disabled." & @CRLF & @CRLF & "The following setting was changed in the " & $aUtilName & ".ini." & @CRLF _
							 & """Send Discord message for STOP SERVER? (yes/no) ###=yes""", 500, 150, -1, -1, $DLG_MOVEABLE, "")
					$sUseDiscordBotStopServer = "yes"
					IniWrite($aIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for STOP SERVER? (yes/no) ###", "yes")
					Sleep(7000)
					SplashOff()
				Else
					LogWrite(" [" & $aServerName & "] No changes made to STOP SERVER Discord announcement setting in " & $aUtilName & ".ini.")
					SplashTextOn($aUtilName, "No changes were made. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
					Sleep(2000)
					SplashOff()
				EndIf
			EndIf
			If ($sUseDiscordBotStopServer = "yes") Or ($sUseTwitchBotStopServer = "yes") Or ($sInGameAnnounce = "yes") Then
				$aRebootReason = "stopservers"
				$aSelectServers = True
				$aBeginDelayedShutdown = 1
				$aTimeCheck0 = _NowCalc()
				SplashTextOn($aUtilName, "Stop Server with announcements initiated.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
				Sleep(2000)
				SplashOff()
			Else
				LogWrite(" [" & $aServerName & "] Stop Server Discord, Twitch, and In-Game announcements are disabled in " & @CRLF & $aUtilName & ".ini.")
				SplashTextOn($aUtilName, "Stop Server Discord, Twitch, and In-Game announcements are disabled" & @CRLF & @CRLF & "Stopping servers WITHOUT announcements", 500, 150, -1, -1, $DLG_MOVEABLE, "")
				SetStatusBusy("Stopping Servers")
				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, True)     ; Do NOT close redis, But disable servers
				SetStatusIdle()
				SplashOff()
			EndIf
		EndIf
		; ----------------------------------------------------------
	ElseIf $tMB = 7 Then             ; NO
		$tMsg1 = "Sending shutdown (DoExit) command to select servers."
		$aSplash = SplashTextOn($aUtilName, $tMsg1, 500, 110, -1, -1, $DLG_MOVEABLE, "")
		SetStatusBusy("Stopping select server(s).", "Stop Server ")
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
				ControlSetText($aSplash, "", "Static1", $tMsg1 & @CRLF & @CRLF & "Server:" & $xServergridx[$i] & $xServergridy[$i])
				GUICtrlSetData($LabelUtilReadyStatus, "Stop Server " & $xServergridx[$i] & $xServergridy[$i])
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, "DoExit", "no")
				LogWrite(" [Server] " & $tMsg1 & " Server:" & $xServergridx[$i] & $xServergridy[$i])
				$xStartGrid[$i] = "no"
				$aGridSomeDisable = True
				IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", "no")
				Sleep(1000 * $aServerShutdownDelay)
			EndIf
		Next
		; ---------------------------------------------
		LogWrite(" Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . .")
		For $k = 1 To $aShutDnWait
			For $i = 0 To ($aServerGridTotal - 1)
				If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
					If ProcessExists($aServerPID[$i]) Then
						$aErrorShutdown = 1
						SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, "DoExit", "no")
						SendCTRLC($aServerPID[$i])
					EndIf
				EndIf
			Next
			If $aErrorShutdown = 1 Then
				Sleep(950)
				ControlSetText($aSplash, "", "Static1", "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . ." & @CRLF & @CRLF & "Countdown: " & ($aShutDnWait - $k))
				GUICtrlSetData($LabelUtilReadyStatus, "Stop Svr Cntdn " & ($aShutDnWait - $k))
				$aErrorShutdown = 0
			Else
				ExitLoop
			EndIf
		Next
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
				If ProcessExists($aServerPID[$i]) Then
					$aErrorShutdown = 1
					LogWrite(" [Server (PID: " & $aServerPID[$i] & ")] Warning: Shutdown failed. Killing Process")
					ProcessClose($aServerPID[$i])
				Else
					$aServerPID[$i] = ""
				EndIf
			EndIf
		Next
		; ---------------------------------------------
		GUICtrlSetData($LabelUtilReadyStatus, "Stop Server Complete")
		ControlSetText($aSplash, "", "Static1", "Select server(s) shutdown complete.")
		Sleep(2000)
		SplashOff()
	ElseIf $tMB = 2 Then             ; CANCEL
		LogWrite(" [Remote RCON] Select server(s) shutdown CANCELED.")
		SplashTextOn($aUtilName, "Select server(s) shutdown CANCELED.", 500, 110, -1, -1, $DLG_MOVEABLE, "")
		GUICtrlSetData($LabelUtilReadyStatus, "Stop Server CANCELED")
		Sleep(2000)
		SplashOff()
	EndIf
	SetStatusIdle()
EndFunc   ;==>SelectServersStop

Func SelectServersStart()
	LogWrite(" [Server] Start select servers requested by user (Start Server(s)).")
	$tMsg1 = "Starting select servers." & @CRLF & @CRLF
	$aSplash = SplashTextOn($aUtilName, $tMsg1, 500, 110, -1, -1, $DLG_MOVEABLE, "")
	SetStatusBusy("Stopping select server(s).", "Stop Server ")
	For $i = 0 To ($aServerGridTotal - 1)
		If Not ProcessExists($aServerPID[$i]) And _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then     ; And ($xStartGrid[$i] = "yes") Then
			If ($xLocalGrid[$i] = "yes") Then
				ControlSetText($aSplash, "", "Static1", "Starting server " & $xServergridx[$i] & $xServergridy[$i])
				GUICtrlSetData($LabelUtilReadyStatus, "Start Server " & $xServergridx[$i] & $xServergridy[$i])
				If $aServerMinimizedYN = "no" Then
					$aServerPID[$i] = Run($xServerStart[$i])
				Else
					$aServerPID[$i] = Run($xServerStart[$i], "", @SW_HIDE)
				EndIf
				$xServerCPU[$i] = _ProcessUsageTracker_Create("", $aServerPID[$i])
				LogWrite(" [Server] Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")]", " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
				Sleep($aServerStartDelay * 1000)
				$xStartGrid[$i] = "yes"
				IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", "yes")
			Else
				ControlSetText($aSplash, "", "Static1", "Server NOT started because it is not local: " & $xServergridx[$i] & $xServergridy[$i])
				Sleep(4000)
			EndIf
		EndIf
	Next
	SplashOff()
	SetStatusIdle()
EndFunc   ;==>SelectServersStart

Func PIDSaveRedis($tPID, $tFile)
	If $aPIDRedisreadYetTF Then
		If FileExists($tFile) Then
			FileDelete($tFile & ".bak")
			FileMove($tFile, $tFile & ".bak", 1)
		EndIf
		FileWrite($tFile, $tPID)
	EndIf
EndFunc   ;==>PIDSaveRedis
Func PIDSaveServer($tPID, $tFile)
	If $aPIDServerReadYetTF Then
		If FileExists($tFile) Then
			FileDelete($tFile & ".bak")
			FileMove($tFile, $tFile & ".bak", 1)
		EndIf
		Local $tTmp = _ArrayToString($tPID)
		FileWrite($tFile, $tTmp)
	EndIf
EndFunc   ;==>PIDSaveServer
Func PIDReadRedis($tFile, $tSplash = 0)
	$aPIDRedisreadYetTF = True
	;	If FileExists($tFile) Then
	Local $tTmp = FileOpen($tFile)
	$tReturn = FileRead($tTmp)
	FileClose($tTmp)
	If $tTmp = -1 Then
		$tReturn = "0"
		LogWrite("", " Lastpidredis.tmp file not found. Existing Redis Server NOT running")
	ElseIf $tReturn = "" Then     ; Empty/Blank File
		$tReturn = "0"
		FileDelete($tFile)
		LogWrite("", " Lastpidredis.tmp file corrupt.")
	EndIf
	If $tReturn = "0" Then
		Local $tTmp = FileOpen($tFile & ".bak")
		$tReturn = FileRead($tTmp)
		FileClose($tTmp)
		If $tTmp = -1 Then
			$tReturn = "0"
			LogWrite("", " Lastpidredis.tmp.bak file not found. Existing Redis Server NOT running")
		ElseIf $tReturn = "" Then     ; Empty/Blank File
			$tReturn = "0"
			FileDelete($tFile)
			LogWrite("", " Lastpidredis.tmp.bak file corrupt.")
		EndIf
	EndIf
	If $tReturn <> "0" Then
		If ProcessExists($tReturn) Then
			LogWrite(" Redis Server PID(" & $tReturn & ") found.")
			If $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) Then
				Local $tTxt = $aStartText & "Redis Server found." & @CRLF & "PID:(" & $tReturn & ")"
				If $tSplash > 0 Then
					ControlSetText($tSplash, "", "Static1", $tTxt)
				Else
					SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
				EndIf
				Sleep(1500)
			EndIf
		Else
			$tReturn = "0"
		EndIf
	EndIf
	Return $tReturn
EndFunc   ;==>PIDReadRedis
Func PIDReadServer($tFile, $tSplash = 0)
	$aPIDServerReadYetTF = True
	Local $tReturn[$aServersMax]
	Local $tTmp1 = FileOpen($tFile)     ; Open existing ServerPID File
	Local $tReturn1 = FileRead($tTmp1)
	FileClose($tTmp1)
	Local $tTmp2 = FileOpen($tFile & ".bak")     ; Open existing ServerPID.bak File
	Local $tReturn2 = FileRead($tTmp2)
	FileClose($tTmp2)
	If $tTmp1 = -1 Then     ; ServerPID file not exist
		LogWrite("", " [Util PID Check] Lastpidserver.tmp file not found.")
		$tReturn1 = $tReturn2
		$aNoExistingPID = True
		If $tTmp2 = -1 Then     ; ServerPID.bak file not exist
			$tReturn[0] = "0"
			LogWrite("", " [Util PID Check] Lastpidserver.tmp.bak file not found.")
			$aNoExistingPID = True
		Else
			If $tReturn2 = "" Then     ; Empty/Blank File
				$tReturn[0] = "0"
				LogWrite("", " [Util PID Check] Lastpidserver.tmp.bak contained no server PID data.")
				$aNoExistingPID = True
				FileDelete($tFile & ".bak")
			EndIf
		EndIf
	Else
		$aNoExistingPID = False
		If $tReturn1 = "" Then     ; Empty/Blank File
			LogWrite("", " [Util PID Check] Lastpidserver.tmp file contained no server PID data.")
			$tReturn1 = $tReturn2
			If $tTmp2 = -1 Then     ; File not exist
				$tReturn[0] = "0"
				LogWrite("", " [Util PID Check] Lastpidserver.tmp.bak file not found.")
				$aNoExistingPID = True
			Else
				If $tReturn2 = "" Then     ; Empty/Blank File
					$tReturn[0] = "0"
					LogWrite("", " [Util PID Check] Lastpidserver.tmp.bak contained no server PID data.")
					$aNoExistingPID = True
					FileDelete($tFile & ".bak")
				EndIf
			EndIf
		EndIf
	EndIf
	If $tReturn[0] <> "0" Then
		$dReturn = StringSplit($tReturn1, "|", 2)
		$tReturn = ResizeArray($dReturn, $aServersMax)
		Local $tPID = ""
		Local $tFound = 0
		For $i = 0 To $aServerGridTotal
			If ProcessExists($tReturn[$i]) Then
				Local $tProcessNameFromPID = _ProcessGetName($tReturn[$i])
				If (StringInStr($tProcessNameFromPID, "Shooter") <> 0) Or (StringInStr($tProcessNameFromPID, "Atlas") <> 0) Then
					$xServerCPU[$i] = _ProcessUsageTracker_Create("", $tReturn[$i])
					LogWrite(" Server PID(" & $tReturn[$i] & ") found.")
					$tPID = $tPID & $tReturn[$i] & ","
					$tFound += 1
				Else
					LogWrite(" -ERROR- Server PID(" & $tReturn[$i] & ") was found but was not an Atlas server.  Server will be restarted.")
					$tReturn[$i] = ""
					$aNoExistingPID = True
				EndIf
			Else
				If $tReturn[$i] <> "" Then
					LogWrite(" -ERROR- Server PID(" & $tReturn[$i] & ") NOT found. Server will be restarted.")
					$tReturn[$i] = ""
					$aNoExistingPID = True
				EndIf
			EndIf
		Next
		If $tPID <> "" Then
			If $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) Then
				$aTmp = ResizeArray($tReturn)
				Local $tTxt = $aStartText & $tFound & " Running servers found." & @CRLF & "PID:(" & StringTrimRight($tPID, 1) & ")"
				If $tSplash > 0 Then
					ControlSetText($tSplash, "", "Static1", $tTxt)
				Else
					SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
				EndIf
				Sleep(2500)
			EndIf
		EndIf
	EndIf
;~ 	$aServerPID = ResizeArray($aServerPID, $aServersMax)
	Return $tReturn
EndFunc   ;==>PIDReadServer

Func SendCTRLC($tPID)
	Local $hWnd = _WinGetByPID($tPID, 1)
	;	MsgBox(4096, "", "PID:" & $iPID & @CRLF & "_WinGetByPID hWnd: " & $hWnd)
	ControlSend($hWnd, "", "", "^C" & @CR)
EndFunc   ;==>SendCTRLC

Func _WinGetByPID($iPID, $iArray = 1)     ; 0 Will Return 1 Base Array & 1 Will Return The First Window.
	Local $aError[1] = [0], $aWinList, $sReturn
	If IsString($iPID) Then
		$iPID = ProcessExists($iPID)
	EndIf
	$aWinList = WinList()
	For $A = 1 To $aWinList[0][0]
		If WinGetProcess($aWinList[$A][1]) = $iPID And BitAND(WinGetState($aWinList[$A][1]), 2) Then
			If $iArray Then
				Return $aWinList[$A][1]
			EndIf
			$sReturn &= $aWinList[$A][1] & Chr(1)
		EndIf
	Next
	If $sReturn Then
		Return StringSplit(StringTrimRight($sReturn, 1), Chr(1))
	EndIf
	Return SetError(1, 0, $aError)
EndFunc   ;==>_WinGetByPID

Func RespawnDinosCheck($sWDays, $sHours)
	Local $iDay = -1
	Local $iHour = -1
	Local $aDays = StringSplit($sWDays, ",")
	Local $aHours = StringSplit($sHours, ",")
	For $d = 1 To $aDays[0]
		$iDay = StringStripWS($aDays[$d], 8)
		If Int($iDay) = Int(@WDAY) Or Int($iDay) = 0 Then
			For $h = 1 To $aHours[0]
				$iHour = StringStripWS($aHours[$h], 8)
				If Int($iHour) = Int(@HOUR) Then
					Return True
				EndIf
			Next
		EndIf
	Next
	Return False
EndFunc   ;==>RespawnDinosCheck

Func DestroyWildDinos()
	$aCMD = "destroywilddinos"
	For $i = 0 To ($aServerGridTotal - 1)
		If ProcessExists($aServerPID[$i]) Then
			SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aCMD)
		EndIf
	Next
EndFunc   ;==>DestroyWildDinos

Func BatchFilesCreate($tSplash = 0)
	If $tSplash <> 0 Then ControlSetText($tSplash, "", "Static1", $aStartText & "Creating backup batch files.")
	DirRemove($aBatFolder, 1)
	DirCreate($aBatFolder)
	Local $tTxtValY = "start """ & $aUtilName & """ /wait /high """ & $aSteamCMDDir & "\steamcmd.exe"" ^" & @CRLF & _
			"+login anonymous ^" & @CRLF & _
			"+force_install_dir """ & $aServerDirLocal & """ ^" & @CRLF & _
			"+app_update " & $aSteamAppID & " validate ^" & @CRLF & _
			"+quit"
	Local $tTxtValN = "start """ & $aUtilName & """ /wait /high """ & $aSteamCMDDir & "\steamcmd.exe"" ^" & @CRLF & _
			"+login anonymous ^" & @CRLF & _
			"+force_install_dir """ & $aServerDirLocal & """ ^" & @CRLF & _
			"+app_update " & $aSteamAppID & " ^" & @CRLF & _
			"+quit"
	FileDelete($aBatFolder & "\Install_Atlas.bat")
	FileWrite($aBatFolder & "\Install_Atlas.bat", $tTxtValY)
	FileDelete($aBatFolder & "\Update_Atlas.bat")
	FileWrite($aBatFolder & "\Update_Atlas_Validate_Yes.bat", $tTxtValY)
	FileDelete($aBatFolder & "\Update_Atlas.bat")
	FileWrite($aBatFolder & "\Update_Atlas_Validate_No.bat", $tTxtValN)

	If FileExists($aBatFolder & "\Launch_Atlas All.bat") Then FileDelete($aBatFolder & "\Launch_Atlas All.bat")
	FileWriteLine($aBatFolder & "\Launch_Atlas All.bat", "start """ & $aUtilName & """ cmd /k Call " & $xServerRedis & @CRLF & "timeout /t 5" & @CRLF)
	For $i = 0 To ($aServerGridTotal - 1)
		If $xStartGrid[$i] = "yes" Then
			If FileExists($aBatFolder & "\Launch_Atlas_" & $xServergridx[$i] & $xServergridy[$i] & ".bat") Then FileDelete($aBatFolder & "\" & "Launch_Atlas_" & $xServergridx[$i] & $xServergridy[$i] & ".bat")
			FileWrite($aBatFolder & "\Launch_Atlas_" & $xServergridx[$i] & $xServergridy[$i] & ".bat", "Start """ & $aUtilName & """ " & $xServerStart[$i] & @CRLF & "Exit")
			FileWriteLine($aBatFolder & "\Launch_Atlas All.bat", "start """ & $aUtilName & """ cmd /k Call " & "Launch_Atlas_" & $xServergridx[$i] & $xServergridy[$i] & ".bat" & @CRLF & "timeout /t 1" & @CRLF)
		EndIf
	Next
	FileWriteLine($aBatFolder & "\Launch_Atlas All.bat", "exit")
EndFunc   ;==>BatchFilesCreate

Func SteamInstallGame($tSplash)
	Local $tTxt = "start """ & $aUtilName & """ /wait /high """ & $aSteamCMDDir & "\steamcmd.exe"" ^" & @CRLF & _
			"+login anonymous ^" & @CRLF & _
			"+force_install_dir """ & $aServerDirLocal & """ ^" & @CRLF & _
			"+app_update " & $aSteamAppID & " validate ^" & @CRLF & _
			"+quit"
	DirCreate($aBatFolder)
	FileDelete($aBatFolder & "\" & $aBatUpdateGame)
	FileWrite($aBatFolder & "\" & $aBatUpdateGame, $tTxt)
	If FileExists($aSteamCMDDir & "\logs\content_log.txt") Then
		Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
		Local $tFile = $aSteamCMDDir & "\logs\content_log.txt" & "_" & $tTime & ".bak"
		FileMove($aSteamCMDDir & "\logs\content_log.txt", $tFile)
	EndIf
	RunWait($aBatFolder & "\" & $aBatUpdateGame)
	Local $tError = ""
	Local $tFile = FileOpen($aSteamCMDDir & "\logs\content_log.txt")
	Local $tRead = FileRead($tFile)
	Local $tString = StringInStr($tRead, "update canceled : ")
	If $tString <> 0 Then
		$tError1 = _ArrayToString(_StringBetween($tRead, "canceled : ", @CRLF))
		SplashOff()
		MsgBox(0, $aUtilName, "Error!!! SteamCMD install failed with error:" & @CRLF & @CRLF & $tError1)
	Else
		ControlSetText($tSplash, "", "Static1", $aUtilName & " file installation complete.")
		Sleep(3000)
		SplashOff()
	EndIf
EndFunc   ;==>SteamInstallGame

Func SteamUpdate($aSteamExtraCMD, $aSteamCMDDir, $tValidateINI, $tSplash = 0)
	If $tSplash = 0 Then SplashOff()
	$aSteamUpdateNow = False
	$aSteamEXE = $aSteamCMDDir & "\steamcmd.exe +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 " & $aSteamExtraCMD & "+login anonymous +force_install_dir """ & $aServerDirLocal & """ +app_update " & $aSteamAppID
	If ($tValidateINI = "yes") Or ($aUpdateVerify = "yes") Then
		$aSteamEXE = $aSteamEXE & " validate"
	EndIf
	$aSteamEXE = $aSteamEXE & " +quit"
	LogWrite(" [Running SteamCMD update]", " [Running SteamCMD update] " & $aSteamEXE)
	RunWait($aSteamEXE)
	If $tSplash = 0 Then SplashOff()
EndFunc   ;==>SteamUpdate

Func _ArraySum(ByRef $a_array, $i_lbound1 = 0, $i_lbound2 = 0)
	Local $i_ubound1 = UBound($a_array, 1) - 1
	Local $i_ubound2 = UBound($a_array, 2) - 1
	Local $i_add = 0

	If $i_ubound2 > 0 Then
		For $i = $i_lbound1 To $i_ubound1
			For $n = $i_lbound2 To $i_ubound2
				$i_add += Number($a_array[$i][$n])
			Next
		Next
	Else
		For $i = $i_lbound1 To $i_ubound1
			$i_add += Number($a_array[$i])
		Next
	EndIf

	Return $i_add
EndFunc   ;==>_ArraySum

Func GetRCONOutput($mIP, $mPort, $mPass, $mCommand)
	If $aServerRCONIP = "" Then
		Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	Else
		Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -H ' & $aServerRCONIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	EndIf
	;	Local $tTimer = TimerInit()

	Local $mOut = Run($aMCRCONcmd, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	$tErr = ProcessWaitClose($mOut, 1)
	If $tErr = 0 Then
		$aRCONError = True
	EndIf
	Local $tcrcatch = StdoutRead($mOut)

	;	Local $mOut = Run($aMCRCONcmd, @ScriptDir, @SW_HIDE, $STDOUT_CHILD)
	;	Local $tcrtout = ""
	;	Local $tcrcatch = ""
	;	While 1
	;		$tcrtout &= StdoutRead($mOut)
	;		If $tcrtout <> $tcrcatch Then
	;			$tcrcatch = $tcrtout
	;		EndIf
	;		If @error Then ExitLoop
	;		If TimerDiff($tTimer) > 1000 Then
	;			$aRCONError = True
	;			WriteOnlineLog($aMCRCONcmd)
	;			ExitLoop
	;		EndIf
	;
	;	WEnd
	Return $tcrcatch
EndFunc   ;==>GetRCONOutput

Func GetPlayerCount($tSplash = 0)
	Local $aCMD = "listplayers"
	$tOnlinePlayerReady = True
	Global $tOnlinePlayers[4]
	Local $aErr = False
	$aServerReadyTF = False
	$tOnlinePlayers[0] = False
	$tOnlinePlayers[1] = ""
	$tOnlinePlayers[2] = ""
	$tOnlinePlayers[3] = ""
	SetStatusBusy("Scanning servers for online players.", "Check: Players")
	;			If $tSplash Then
	;				SplashTextOn($aUtilName, " Checking online players . . . " & @CRLF & "If taking a while, please wait for servers to finish coming online", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	;			EndIf
	For $i = 0 To ($aServerGridTotal - 1)
		If ($xStartGrid[$i] = "yes") Or ($aPollRemoteServersYN = "yes" And $xLocalGrid[$i] = "no") Then
			GUICtrlSetData($LabelUtilReadyStatus, "Check: Players " & $xServergridx[$i] & $xServergridy[$i])
			Local $tTxt = $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Preparing GUI. Getting server information." & @CRLF & "Checking online players on server " & $xServergridx[$i] & $xServergridy[$i]
			If $tSplash > 0 Then
				ControlSetText($tSplash, "", "Static1", $tTxt)
				GUICtrlSetData($LabelUtilReadyStatus, "Check: Players " & $xServergridx[$i] & $xServergridy[$i])
;~  			ElseIf $tSplash = -2 Then
;~ 				SplashTextOn($aUtilName, " Checking online players on server: " & $xServergridx[$i] & $xServergridy[$i] & @CRLF & @CRLF & "If taking a while, please wait for servers to finish coming online", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			EndIf
;~ 		EndIf
			If $aServerRCONIP = "" Then
				$mMsg = GetRCONOutput($xServerIP[$i], $xServerRCONPort[$i + 1], $aTelnetPass, $aCMD)
			Else
				$mMsg = GetRCONOutput($aServerRCONIP, $xServerRCONPort[$i + 1], $aTelnetPass, $aCMD)
			EndIf
			If StringInStr($mMsg, "No Players Connected") <> 0 Then
				$aServerPlayers[$i] = 0
				$tOnlinePlayers[1] = $tOnlinePlayers[1] & $xServergridx[$i] & $xServergridy[$i] & "(0) "
				$tOnlinePlayers[2] = $tOnlinePlayers[2] & "Server " & $xServergridx[$i] & $xServergridy[$i] & ": 0" & @CRLF
				$tOnlinePlayers[3] = $tOnlinePlayers[3] & "Server " & $xServergridx[$i] & $xServergridy[$i] & ": 0" & @CRLF
			Else
				If $aRCONError Then
					LogWrite(" [Online Players] Error receiving online players from Server: " & $xServergridx[$i] & $xServergridy[$i])
					$aErr = True
					$aRCONError = False
					$aServerPlayers[$i] = -2
					$tOnlinePlayers[1] = $tOnlinePlayers[1] & $xServergridx[$i] & $xServergridy[$i] & "(-) "
					$tOnlinePlayers[2] = $tOnlinePlayers[2] & "Server " & $xServergridx[$i] & $xServergridy[$i] & ": -" & @CRLF
					$tOnlinePlayers[3] = $tOnlinePlayers[3] & "Server " & $xServergridx[$i] & $xServergridy[$i] & ": -" & @CRLF
				Else
					$mMsg = StringReplace($mMsg, " ", "")
					Local $tUserAll = _StringBetween($mMsg, ".", ",")
					Local $tUserCnt = UBound($tUserAll)
					Local $tSteamAll[$tUserCnt + 1]
					Local $tUsers = _ArrayToString($tUserAll)
					Local $tSteamAll = _StringBetween($mMsg, ",", @CRLF)
					;				Local $tSteamID = _ArrayToString($tSteamAll)
					Local $tUserLog = ""
					Local $tUserMsg = ""
					Local $tUserNoSteam = ""
					For $x = 0 To ($tUserCnt - 1)
						$tUserLog = $tUserLog & $tUserAll[$x] & "." & $tSteamAll[$x] & "|"
						$tUserMsg = $tUserMsg & $tUserAll[$x] & " [" & $tSteamAll[$x] & "], "
						$tUserNoSteam = $tUserNoSteam & $tUserAll[$x] & ", "
					Next
					If $tUsers < 0 Then
						LogWrite(" [Online Players] Error receiving online players from Server: " & $xServergridx[$i] & $xServergridy[$i])
						$aErr = True
						$aRCONError = False
						$aServerPlayers[$i] = -2
						$tOnlinePlayers[1] = $tOnlinePlayers[1] & $xServergridx[$i] & $xServergridy[$i] & "(-), "
						$tOnlinePlayers[2] = $tOnlinePlayers[2] & "Server " & $xServergridx[$i] & $xServergridy[$i] & ": -" & @CRLF
						$tOnlinePlayers[3] = $tOnlinePlayers[3] & "Server " & $xServergridx[$i] & $xServergridy[$i] & ": -" & @CRLF
					Else
						$aServerPlayers[$i] = $tUserCnt
						$tOnlinePlayers[1] = $tOnlinePlayers[1] & $xServergridx[$i] & $xServergridy[$i] & "(" & $tUserCnt & " " & $tUserLog & "), "
						$tOnlinePlayers[2] = $tOnlinePlayers[2] & "Server " & $xServergridx[$i] & $xServergridy[$i] & ": " & $tUserCnt & " " & $tUserMsg & @CRLF
						$tOnlinePlayers[3] = $tOnlinePlayers[3] & "Server " & $xServergridx[$i] & $xServergridy[$i] & ": " & $tUserCnt & " " & $tUserNoSteam & @CRLF
					EndIf
				EndIf
			EndIf
		Else
			$aServerPlayers[$i] = -2
		EndIf
	Next
	If ($aOnlinePlayerLast <> $tOnlinePlayers[1]) Then
		$tOnlinePlayers[0] = True
		LogWrite(" [Online Players] " & $tOnlinePlayers[1])
		WriteOnlineLog("[Online] " & $tOnlinePlayers[1])
;~ 		If $tSplash = -2 Then
;~ 			MsgBox($MB_OK, $aUtilityVer, "ONLINE PLAYERS CHANGED!" & @CRLF & @CRLF & "Online players: " & @CRLF & $tOnlinePlayers[2], 10)
;~ 		EndIf
;~ 	Else
;~ 		If $tSplash = -2 Then
;~ 			MsgBox($MB_OK, $aUtilityVer, "No Change in online players: " & @CRLF & $tOnlinePlayers[2], 10)
;~ 			LogWrite("[Usr Ck] " & $tOnlinePlayers[1])
;~ 			WriteOnlineLog("[Usr Ck] " & $tOnlinePlayers[1])
;~ 		EndIf
	EndIf
	$aOnlinePlayerLast = $tOnlinePlayers[1]
	If $aErr = 0 Then
		$aServerReadyTF = True
	EndIf
	If $tSplash < 1 Then
		SplashOff()
	EndIf
	If FileExists($aOnlinePlayerWebFile) Then
		FileDelete($aOnlinePlayerWebFile)
	EndIf
	FileWrite($aOnlinePlayerWebFile, $tOnlinePlayers[3])
	SetStatusIdle()
	Return $tOnlinePlayers
EndFunc   ;==>GetPlayerCount

Func F_ShowPlayerCount()
	GUICtrlSetState($Players, $GUI_DISABLE)
	TrayItemSetState($iTrayPlayerCount, $TRAY_DISABLE)
	$aPlayerCountShowTF = True
	If $aServerOnlinePlayerYN = "no" Then
		SplashTextOn($aUtilName, "To show online players, " & @CRLF & "you must Enable Online Players Check/Log. . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
		Sleep(3000)
		SplashOff()
	Else
		ShowPlayerCount()
	EndIf
	;	If $aPlayerCountShow = False Then
	;		$aPlayerCountShow = True
	;		Global $aGUIH = 50 + $aServerGridTotal * 13 ;Create Show Online Players Window Frame
	;		If $aGUIH > 800 Then $aGUIH = 800
	;		Local $gOnlinePlayerWindow = GUICreate($aUtilName & " Online Players", 500, $aGUIH, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME)) ;Creates the GUI window
	;		GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
	;		GUICtrlSetLimit(-1, 0xFFFFFF)
	;		ShowPlayerCount()
	;EndIf
EndFunc   ;==>F_ShowPlayerCount

Func WriteOnlineLog($aMsg)
	FileWriteLine($aFolderLog & $aUtilName & "_OnlineUserLog_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt", _NowCalc() & " " & $aMsg)
EndFunc   ;==>WriteOnlineLog

Func F_UpdateUtilPause()
	SplashOff()
	MsgBox($MB_OK, $aUtilityVer, $aUtilityVer & " Paused.  Press OK to resume.")
EndFunc   ;==>F_UpdateUtilPause

Func TrayUpdateServPause()
	TrayItemSetState($iTrayUpdateServPause, $TRAY_DISABLE)
	TrayItemSetState($iTrayUpdateServUnPause, $TRAY_ENABLE)
	IniWrite($aIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Check for server updates? (yes/no) ###", "no")
EndFunc   ;==>TrayUpdateServPause

Func TrayUpdateServUnPause()
	TrayItemSetState($iTrayUpdateServPause, $TRAY_ENABLE)
	TrayItemSetState($iTrayUpdateServUnPause, $TRAY_DISABLE)
	IniWrite($aIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Check for server updates? (yes/no) ###", "yes")
EndFunc   ;==>TrayUpdateServUnPause

Func ShowPlayerCount()
	$aServerOnlinePlayerYN = "yes"
	ShowOnlinePlayersGUI()
	;	If $aPlayerCountShow Then
	;		Local $aGUIH = 50 + $aServerGridTotal * 13
	;		If $aGUIH > 800 Then $aGUIH = 800
	;		Local $gOnlinePlayerWindow = GUICreate($aUtilName & " Online Players", 500, $aGUIH, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME)) ;Creates the GUI window
	;		Local $wOnlinePlayers = GUICtrlCreateEdit(_DateTimeFormat(_NowCalc(), 0) & @CRLF & $tOnlinePlayers[2], 0, 0, 500, $aGUIH, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_READONLY), $WS_EX_STATICEDGE)
	;		GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
	;		GUICtrlSetLimit(-1, 0xFFFFFF)
	;		ControlClick($gOnlinePlayerWindow, "", $wOnlinePlayers)
	;		GUISetState(@SW_SHOW) ;Shows the GUI window
	;	EndIf

EndFunc   ;==>ShowPlayerCount

Func _WM_SIZE($hWndGUI, $Msg, $wParam, $lParam)
	Local $iHeight, $iWidth
	$iWidth = BitAND($lParam, 0xFFFF)     ; _WinAPI_LoWord
	$iHeight = BitShift($lParam, 16)     ; _WinAPI_HiWord
	If ($hWndGUI = $wOnlinePlayers) Then
		_WinAPI_MoveWindow($wOnlinePlayers, 10, 10, $iWidth - 20, $iHeight - 20)
	ElseIf ($hWndGUI = $wGUIMainWindow) Then
		_WinAPI_MoveWindow($wMainListViewWindow, 112, 64, $iWidth - 128, $iHeight - 204)
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_SIZE

Func ShowOnlinePlayersGUI()
	If $aServerOnlinePlayerYN = "yes" Then
		If $aPlayerCountShowTF Then
			If $aPlayerCountWindowTF = False Then
				$gOnlinePlayerWindow = GUICreate($aUtilName & " Online Players", $aGUIW, $aGUIH, -1, -1, $WS_SIZEBOX)
				GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_OnlinePlayers_Close", $gOnlinePlayerWindow)
				$wOnlinePlayers = GUICtrlCreateEdit("", 0, 0, _WinAPI_GetClientWidth($gOnlinePlayerWindow), _WinAPI_GetClientHeight($gOnlinePlayerWindow), BitOR($ES_AUTOHSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL, $ES_READONLY))     ; Horizontal Scroll, NO wrap text
				GUICtrlSetState($wOnlinePlayers, $GUI_FOCUS)
				GUIRegisterMsg($WM_SIZE, "_WM_SIZE")
				$aPlayerCountWindowTF = True
				GUISetState(@SW_SHOWNORMAL, $gOnlinePlayerWindow)     ;Shows the GUI window
			EndIf
			If $tOnlinePlayerReady Then
				GUICtrlSetData($wOnlinePlayers, _DateTimeFormat(_NowCalc(), 0) & @CRLF & $tOnlinePlayers[2])
			Else
				GUICtrlSetData($wOnlinePlayers, _DateTimeFormat(_NowCalc(), 0) & @CRLF & "Waiting for first Online Player check.")
			EndIf
		EndIf
	EndIf
EndFunc   ;==>ShowOnlinePlayersGUI

Func TrayShowPlayerCheckPause()
	GUIDelete()
	$aPlayerCountWindowTF = False
	TrayItemSetState($iTrayPlayerCheckPause, $TRAY_DISABLE)
	TrayItemSetState($iTrayPlayerCheckUnPause, $TRAY_ENABLE)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for, and log, online players? (yes/no) ###", "no")
	$aServerOnlinePlayerYN = "no"
EndFunc   ;==>TrayShowPlayerCheckPause

Func TrayShowPlayerCheckUnPause()
	TrayItemSetState($iTrayPlayerCheckPause, $TRAY_ENABLE)
	TrayItemSetState($iTrayPlayerCheckUnPause, $TRAY_DISABLE)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Check for, and log, online players? (yes/no) ###", "yes")
	$aServerOnlinePlayerYN = "yes"
EndFunc   ;==>TrayShowPlayerCheckUnPause

Func _ImageToGUIImageListResized($tGUICreate, $tFile, $tWidth = 16, $tHeight = 16)     ; By Phoenix125.com
	_GDIPlus_Startup()
	Local $GDIpBmpLarge, $GDIpBmpResized, $GDIbmp, $tReturn
	$GDIpBmpLarge = _GDIPlus_ImageLoadFromFile($tFile)     ;GDI+ image!
	$GDIpBmpResized = _GDIPlus_ImageResize($GDIpBmpLarge, $tWidth, $tHeight)     ;GDI+ image
	$GDIbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($GDIpBmpResized)     ;GDI image!
	$tReturn = _GUIImageList_Add($tGUICreate, $GDIbmp)
	_GDIPlus_BitmapDispose($GDIpBmpLarge)
	_GDIPlus_BitmapDispose($GDIpBmpResized)
	_WinAPI_DeleteObject($GDIbmp)
	_GDIPlus_Shutdown()
	Return $tReturn
EndFunc   ;==>_ImageToGUIImageListResized

; ------------------------------------------------------------------------------------------------------------
;      Main GUI Window
; ------------------------------------------------------------------------------------------------------------

Func ShowMainGUI($tSplash = 0)
;~ 	$aServerPID = ResizeArray($aServerPID)
	Global $aServerPI_Stripped = ResizeArray($aServerPID, $aServerGridTotal)
	Global $aServerMem = _GetMemArrayRawAvg($aServerPI_Stripped)
	$aGUIMainActive = True
	TrayItemSetState($iTrayShowGUI, $TRAY_DISABLE)
	#Region ### START Koda GUI section ### Form=G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Temp Work Files\atladkoda(b10-listview).kxf
	Global $wGUIMainWindow = GUICreate($aUtilityVer, 1001, 701, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_Main_Close", $wGUIMainWindow)
	GUISetIcon($aIconFile, 99)
	GUISetBkColor($cMWBackground)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	Global $RestartAllGrids = GUICtrlCreateGroup("Log", 112, 592, 873, 97)     ; Previous(8, 592, 985, 97)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	Global $LogTicker = GUICtrlCreateEdit("", 120, 608, 857, 73, BitOR($ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL))     ; Previous(16, 608, 969, 73)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	GUICtrlSetState($LogTicker, $GUI_FOCUS)
	DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', '')
	GUICtrlSetData(-1, $aGUILogWindowText)
	GUICtrlSetBkColor(-1, $cLWBackground)
;~ 	GUICtrlSetResizing(-1, $GUI_DOCKLEFT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	Global $Header = GUICtrlCreateGroup("", 8, 0, 985, 49)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKHEIGHT)
	$LabelMEM = GUICtrlCreateLabel("Mem: ", 292, 10, 33, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetColor(-1, $cMWMemCPU)
	$LabelCPU = GUICtrlCreateLabel("CPU:", 293, 27, 29, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetColor(-1, $cMWMemCPU)
	Local $MemStats = MemGetStats()     ;Retrieves memory related information
	Global $MemPercent = GUICtrlCreateLabel($MemStats[$MEM_LOAD] & "-- %", 323, 11, 20, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetColor(-1, $cMWMemCPU)
	Global $CPUPercent = GUICtrlCreateLabel("-- %", 322, 27, 24, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetColor(-1, $cMWMemCPU)
	Global $ServerHeading = GUICtrlCreateLabel($aUtilName, 45, 15, 225, 28)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, $cMWMemCPU)
;~ 	GUICtrlSetResizing(-1, $GUI_DOCKLEFT)
	Global $ExitShutDownServers = GUICtrlCreateButton("Exit: SHUT DOWN servers", 664, 16, 155, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_ExitShutDownY")
	Global $ExitDoNotShutDownServers = GUICtrlCreateButton("Exit: Do NOT shut down servers", 824, 16, 163, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_ExitShutDownN")
	Global $IconDiscord = GUICtrlCreateIcon($aIconFile, 209, 600, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_DiscordServer")
	GUICtrlSetTip(-1, "Discord Server")
	Global $IconForum = GUICtrlCreateIcon($aIconFile, 208, 536, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_DiscussionForum")
	GUICtrlSetTip(-1, "Discussion Forum")
	Global $IconHelp = GUICtrlCreateIcon($aIconFile, 213, 504, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_Help")
	GUICtrlSetTip(-1, "Help")
	Global $IconPhoenix = GUICtrlCreateIcon($aIconFile, 99, 568, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_MainWebpage")
	GUICtrlSetTip(-1, "Main Webpage")
	Global $IconPhoenixMain = GUICtrlCreateIcon($aIconFile, 99, 16, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_MainWebpage")
	GUICtrlSetTip(-1, "Main Webpage")
	Global $IconInfo = GUICtrlCreateIcon($aIconFile, 207, 632, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_About")
	GUICtrlSetTip(-1, "About")
	Global $IconPause = GUICtrlCreateIcon($aIconFile, 206, 376, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_Pause")
	GUICtrlSetTip(-1, "Pause All AtlasServerUpdateUtility functions (Servers will remain running)")
	Global $IconUpdate = GUICtrlCreateIcon($aIconFile, 205, 408, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_CheckForUtilUpdates")
	GUICtrlSetTip(-1, "Check for Updates for AtlasServerUpdateUtility")
	Global $IconConfig = GUICtrlCreateIcon($aIconFile, 211, 440, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_UtilConfig")
	GUICtrlSetTip(-1, "AtlasServerUpdateUtility Config")
;~ 	GUICtrlCreateGroup("", -99, -99, 1, 1)
;~ 	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	Local $tX = 8, $tY = 54     ; Starting Location
	Local $tGroupW = 89, $tButtonW = $tGroupW - 14, $tButtonH = 25     ; Default Group Dimensions

	Local $tButtons = 4, $tGroupH = (32 * $tButtons + 17)
	Global $ShowWindows = GUICtrlCreateGroup("Show Window", $tX, $tY, $tGroupW, $tGroupH)     ; (8, 48, 89, 145)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	$tY += 16
	Global $ServerInfo = GUICtrlCreateButton("Setup Wizard", $tX + 8, $tY, $tButtonW, $tButtonH)     ; (16, 64, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_ServerInfo")
	GUICtrlSetTip(-1, "Display Server Summary Window")
	$tY += 32
	Global $Players = GUICtrlCreateButton("Players", $tX + 8, $tY, $tButtonW, $tButtonH)     ; (16, 96, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	If $aPlayerCountShowTF Then GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_Players")
	GUICtrlSetTip(-1, "Display Online Players Window")
	$tY += 32
	Global $Config = GUICtrlCreateButton("CONFIG", $tX + 8, $tY, $tButtonW, $tButtonH)     ; (16, 128, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_Config")
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Display Config Window")
	$tY += 32
	Global $LogFile = GUICtrlCreateButton("Log/Ini Files", $tX + 8, $tY, $tButtonW, $tButtonH)     ; (16, 160, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_LogFile")
	GUICtrlSetTip(-1, "Display Latest Log File")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	$tY += 40
	Local $tButtons = 5, $tGroupH = (32 * $tButtons + 17)
	Global $RestartAllGrid = GUICtrlCreateGroup("All Grids", $tX, $tY, $tGroupW, $tGroupH)     ; Manual(8, 200, 89, 145)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	$tY += 16
	Global $SendRCONAll = GUICtrlCreateButton("Send RCON", $tX + 8, $tY, $tButtonW, $tButtonH)     ; Manual(6, 216, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllSendRCON")
	GUICtrlSetTip(-1, "Send RCON Command to All Grids")
	$tY += 32
	Global $SendMsgAll = GUICtrlCreateButton("Send Msg", $tX + 8, $tY, $tButtonW, $tButtonH)     ; Manual(16, 248, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllSendMsg")
	GUICtrlSetTip(-1, "Broadcast In Game Message to All Grids")
	$tY += 32
	Global $RemoteRestartAll = GUICtrlCreateButton("Rmt Restart", $tX + 8, $tY, $tButtonW, $tButtonH)     ; Manual(16, 280, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllRmtRestart")
	GUICtrlSetTip(-1, "Initiate Remote Restart: Restart All Local Grid Servers with Message and Delay")
	$tY += 32
	Global $RestartNowAll = GUICtrlCreateButton("Restart NOW", $tX + 8, $tY, $tButtonW, $tButtonH)     ; Manual(16, 312, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllRestartNow")
	GUICtrlSetTip(-1, "Restart All Local Grid Servers")
	$tY += 32
	Global $StopServerAll = GUICtrlCreateButton("Stop Server(s)", $tX + 8, $tY, $tButtonW, $tButtonH)     ; Manual(16, 312, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_StopServerAll")
	GUICtrlSetTip(-1, "Stop All Grids With or Without Announcement")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	$tY += 40
	Local $tButtons = 4, $tGroupH = (32 * $tButtons + 17)
	Global $SelectedGrids = GUICtrlCreateGroup("Selected Grids", $tX, $tY, $tGroupW, $tGroupH)     ; (8, 352, 89, 145)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	$tY += 16
	Global $SendRCONSel = GUICtrlCreateButton("Send RCON", $tX + 8, $tY, $tButtonW, $tButtonH)     ;(16, 368, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectSendRCON")
	GUICtrlSetTip(-1, "Send RCON Command to Selected Grids")
	$tY += 32
	Global $SendMsgSel = GUICtrlCreateButton("Send Msg", $tX + 8, $tY, $tButtonW, $tButtonH)     ; (16, 400, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectSendMsg")
	GUICtrlSetTip(-1, "Send In Game Message to Selected Grids")
	$tY += 32
	Global $StartServers = GUICtrlCreateButton("Start Server(s)", $tX + 8, $tY, $tButtonW, $tButtonH)     ; (16, 432, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectStartServers")
	GUICtrlSetTip(-1, "Start Selected Grids")
	$tY += 32
	Global $StopServers = GUICtrlCreateButton("Stop Server(s)", $tX + 8, $tY, $tButtonW, $tButtonH)     ; (16, 464, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectStopServers")
	GUICtrlSetTip(-1, "Stop Selected Grids With or Without Announcement")
;~ 	$tY += 32
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	$tY += 40
	Local $tButtons = 3, $tGroupH = (32 * $tButtons + 17)
	Global $Update = GUICtrlCreateGroup("Update", $tX, $tY, $tGroupW, $tGroupH)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	$tY += 16
	Global $UpdateMods = GUICtrlCreateButton("Update Mods", $tX + 8, $tY, $tButtonW, $tButtonH)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_ModUpdates")
	GUICtrlSetTip(-1, "Check for Mod Updates")
	If $aServerModYN = "no" Then GUICtrlSetState(-1, $GUI_DISABLE)
	$tY += 32
	Global $UpdateAtlas = GUICtrlCreateButton("Update " & $aServerName, $tX + 8, $tY, $tButtonW, $tButtonH)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_UpdateGame")
	GUICtrlSetTip(-1, "Check for " & $aServerName & " Updates")
	$tY += 32
	Global $UpdateUtil = GUICtrlCreateButton("Update Util", $tX + 8, $tY, $tButtonW, $tButtonH)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_UpdateUtil")
	GUICtrlSetTip(-1, "Check for " & $aUtilName & " Updates")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	Global $wMainListViewWindow = _GUICtrlListView_Create($wGUIMainWindow, "", 112, 64, 873, 497, BitOR($LVS_NOLABELWRAP, $LVS_REPORT, $LVS_SINGLESEL))
	_GUICtrlListView_SetExtendedListViewStyle($wMainListViewWindow, BitOR($LVS_EX_GRIDLINES, $LVS_EX_SUBITEMIMAGES, $LVS_EX_CHECKBOXES))
	_GUICtrlListView_SetBkColor($wMainListViewWindow, $cSWBackground)
	_GUICtrlListView_SetTextBkColor($wMainListViewWindow, $cSWBackground)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	Global $aGUI_Main_Columns[12] = ["", "Run", "Local", "Rmt", "Server Name", "Grid", "Players", "CPU %", "Mem MB", "Folder", "PID", "Status"]
	Global $aGUI_Main_Widths[12] = [21, 32, 38, 38, 320, 35, 60, 50, 60, 60, 60, 70]
	For $i = 0 To (UBound($aGUI_Main_Columns) - 1)
		_GUICtrlListView_InsertColumn($wMainListViewWindow, $i, $aGUI_Main_Columns[$i], $aGUI_Main_Widths[$i])
		_GUICtrlListView_JustifyColumn($wMainListViewWindow, $i, 2)
	Next
	Local $tW1 = 24, $tH1 = 16
	Global $hImage = _GUIImageList_Create($tW1, $tH1, 5)     ; Load ListView Icons into memory
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_toggle_on_left0.png", $tW1, $tH1)     ; 0 - Yes toggle 0
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_toggle_off_left0.png", $tW1, $tH1)     ; 1 - No toggle 0
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_button_green_left1.png", $tW1, $tH1)     ; 2 - Red button 1
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_button_red_left1.png", $tW1, $tH1)     ; 3 - Green button 1
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_check_green_left1.png", $tW1, $tH1)     ; 4 - Green checkmark 1
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_check_gray_left1.png", $tW1, $tH1)     ; 5 - Gray checkmark 1
;~ 	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_check_left2.png", $tW1, $tH1)		; 5 - Green checkmark 2
;~ 		_GUIImageList_AddIcon($hImage, @ScriptDir & "\AtlasUtilFiles\i_toggle_on.ico") 			; 0 - Yes slider
;~ 		_GUIImageList_AddIcon($hImage, $aIconFile, 17) 			; 0 - Yes slider
;~ 		_GUIImageList_AddIcon($hImage, $aIconFile, 18)			; 1 - No slider
;~ 		_GUIImageList_AddIcon($hImage, $aIconFile, 5) 			; 2 - Yes checkmark
;~ 		_GUIImageList_AddIcon($hImage, $aIconFile, 7) 			; 3 - Yes checkmark button
;~ 		_GUIImageList_AddIcon($hImage, $aIconFile, 6) 			; 4 - No red X button
;~ 		_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 131)
;~ 		_GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 165)
	_GUICtrlListView_SetImageList($wMainListViewWindow, $hImage, 1)

	Global $aMainLVW[$aServerGridTotal][12]
	For $i = 0 To ($aServerGridTotal - 1)
		$aMainLVW[$i][0] = ""     ; $xStartGrid[$i] ; Checked YN
		If $xStartGrid[$i] <> "yes" Then
			$aMainLVW[$i][1] = "--"     ; Local YN
		Else
			$aMainLVW[$i][1] = $xStartGrid[$i]     ; Local YN
		EndIf
		If $xStartGrid[$i] <> "yes" Then
			$aMainLVW[$i][2] = "--"     ; Local YN
		Else
			$aMainLVW[$i][2] = $xStartGrid[$i]     ; Local YN
		EndIf
		If $xStartGrid[$i] = "yes" Then     ; Remote YN
			$aMainLVW[$i][3] = "--"
		Else
			$aMainLVW[$i][3] = "yes"
		EndIf
		$aMainLVW[$i][4] = $xServerNames[$i]     ; "Server " & $xServergridx[$i] & $xServergridy[$i] ; Server Name
		$aMainLVW[$i][5] = $xServergridx[$i] & $xServergridy[$i]     ; Grid
		If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) Then
			$aMainLVW[$i][6] = $aServerPlayers[$i] & " / " & $aServerMaxPlayers     ; Online PLayers
		Else
			$aMainLVW[$i][6] = "-- / " & $aServerMaxPlayers     ; Online PLayers
		EndIf
		If $xStartGrid[$i] = "yes" Then
			$aMainLVW[$i][7] = "--"     ; CPU
;~ 			$aMainLVW[$i][8] = (Int($aServerMem[$i] / (1024 ^ 2))) & " MB" ; Memory
			Local $aMemTmp = ($aServerMem[$i] / (1024 ^ 2))
			$aMainLVW[$i][8] = _AddCommasDecimalNo($aMemTmp) & " MB"     ; Memory
		Else
			$aMainLVW[$i][7] = ""     ; CPU
			$aMainLVW[$i][8] = ""     ; Memory
		EndIf
		$aMainLVW[$i][9] = $xServerAltSaveDir[$i]     ; Folder
		$aMainLVW[$i][10] = $aServerPID[$i]     ; PID
		If ProcessExists($aServerPID[$i]) Then
			$aMainLVW[$i][11] = "Running"     ; Status
		Else
			If $xStartGrid[$i] = "yes" Then
				$aMainLVW[$i][11] = "CRASHED"     ; Status
			Else
				If $xLocalGrid[$i] = "yes" Then
					$aMainLVW[$i][11] = "Disabled"     ; Status
				Else
					$aMainLVW[$i][11] = "Offline"     ; Status
					If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) And ($aServerOnlinePlayerYN = "yes") Then
						$aMainLVW[$i][11] = "Running"     ; Status #008000
					EndIf
				EndIf
			EndIf
		EndIf
		Local $aString = ""
		For $x = 0 To 10
			$aString &= $aMainLVW[$i][$x] & "|"
		Next
		$aString &= $aMainLVW[$i][11]
		_GUICtrlListView_AddItem($wMainListViewWindow, "", 0)
		For $x = 4 To 11
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, $aMainLVW[$i][$x], $x)
		Next
	Next

	For $i = 0 To ($aServerGridTotal - 1)     ; Place icon for RUN column
		If $xStartGrid[$i] = "yes" Then
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 1, 0)
		Else
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 1, 1)
		EndIf
	Next
	For $i = 0 To ($aServerGridTotal - 1)     ; Place icon for RUN column
		If $xLocalGrid[$i] = "yes" Then
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 2, 4)
		Else
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 3, 5)
;~ 				_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 2, 3)
		EndIf
	Next
	; -----------------------------------------------------------------------------------------------
	Global $aGUIListViewEX = _GUIListViewEx_Init($wMainListViewWindow, $aMainLVW, 0, 0, True, 2 + 32 + 1024)
	For $i = 0 To (UBound($aGUI_Main_Columns) - 1)
		_GUIListViewEx_SetEditStatus($aGUIListViewEX, $i)     ; Default = standard text edit
	Next
	Local $aSelCol[4] = [Default, $cSWBackground, Default, Default]
	_GUIListViewEx_SetDefColours($aGUIListViewEX, $aSelCol)
	For $i = 0 To ($aServerGridTotal - 1)
		If ProcessExists($aServerPID[$i]) Then     ; RUNNING
			_GUIListViewEx_SetColour($aGUIListViewEX, $cSWRunning & ";", $i, 11)
		Else
			If $xStartGrid[$i] = "yes" Then     ; CRASHED
				_GUIListViewEx_SetColour($aGUIListViewEX, $cSWCrashed & ";", $i, 11)
			Else
				If $xLocalGrid[$i] = "yes" Then     ; DISABLED
					_GUIListViewEx_SetColour($aGUIListViewEX, $cSWDisabled & ";", $i, 11)
				Else     ; OFFLINE
					_GUIListViewEx_SetColour($aGUIListViewEX, $cSWOffline & ";", $i, 11)
					If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) And ($aServerOnlinePlayerYN = "yes") Then     ; REMOTE PLAYERS ONLINE
						_GUIListViewEx_SetColour($aGUIListViewEX, $cSWRunning & ";", $i, 11)
					EndIf
				EndIf
			EndIf
		EndIf
	Next

	_GUIListViewEx_MsgRegister()
	; -----------------------------------------------------------------------------------------------
	Global $UpdateIntervalLabel = GUICtrlCreateLabel("Player Update Interval (sec)", 710, 568)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	Global $UpdateIntervalSlider = GUICtrlCreateSlider(848, 565, 102, 21, BitOR($GUI_SS_DEFAULT_SLIDER, $TBS_NOTICKS))
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_S_UpdateIntervalSlider")
	GUICtrlSetLimit(-1, 600, 30)
	GUICtrlSetData(-1, $aServerOnlinePlayerSec)
	GUICtrlSetTip(-1, "Seconds: 30-600")
	GUICtrlSetBkColor(-1, $cMWBackground)
	Global $UpdateIntervalEdit = GUICtrlCreateEdit("", 952, 568, 33, 17, BitOR($ES_CENTER, $ES_WANTRETURN))
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_E_UpdateIntervalEdit")
	GUICtrlSetData(-1, $aServerOnlinePlayerSec)
	GUICtrlSetBkColor(-1, $cSWBackground)
	GUICtrlSetTip(-1, "Seconds: 30-600")
	Global $gPollOnlinePlayers = GUICtrlCreateCheckbox("Poll Online Players", 580, 564)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_CB_PollOnlinePLayers")
	If $aServerOnlinePlayerYN = "yes" Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	Else
		GUICtrlSetState(-1, $GUI_UNCHECKED)
	EndIf
	$IconReady = GUICtrlCreateIcon($aIconFile, 204, 113, 563, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	Global $LabelUtilReadyStatus = GUICtrlCreateLabel("Idle", 144, 568, 120, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	Global $gPollRemoteServersCB = GUICtrlCreateCheckbox("Poll Remote Servers", 295, 564)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
;~ 	Global $gPollRemoteServersCB = GUICtrlCreateCheckbox(" ", 295, 564)
;~ 	Global $gPollRemoteServersLabel = GUICtrlCreateLabel("Poll Remote Servers", 310, 568, -1, -1, $WS_EX_TOPMOST)
	Global $gPollRemoteServersLabel = GUICtrlCreateLabel("Poll Remote Servers", 310, 568, -1, -1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_CB_PollRemoteServers")
	If $aPollRemoteServersYN = "yes" Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	Else
		GUICtrlSetState(-1, $GUI_UNCHECKED)
	EndIf
	Global $LabelTotalPlayers = GUICtrlCreateLabel("Total Players: ", 432, 568, 71, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	Global $TotalPlayersEdit = GUICtrlCreateEdit("", 504, 566, 35, 17, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetState($TotalPlayersEdit, $GUI_FOCUS)
	DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', '')
;~ 	$aTotalPlayersOnline = _ArraySum($aServerPlayers)
	GUICtrlSetData(-1, $aTotalPlayersOnline)     ; & " / " & $aServerMaxPlayers)
	GUICtrlSetBkColor(-1, $cLWBackground)
	GUICtrlSetTip(-1, "Total Players Online")
;~ 		Global $LabelDblClick = GUICtrlCreateLabel("Dbl-Click to Change Value", 255, 568, 163, 17)
;~ 		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
;~ 		GUICtrlSetColor(-1, $cSWTextHL2)
;~ 		GUICtrlCreateGroup("", -99, -99, 1, 1)
;~ 	GUICtrlCreateGroup("", -99, -99, 1, 1)
;~ 	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	#EndRegion ### END Koda GUI section ###
	If $aServerOnlinePlayerYN = "yes" Then
		$aOnlinePlayers = GetPlayerCount($tSplash)
		GUICtrlSetData($LabelUtilReadyStatus, "Idle")
	EndIf
	GUIUpdateQuick()
	If $aShowGUI Then
		GUISetState(@SW_SHOWNORMAL, $wGUIMainWindow)
	Else
		GUISetState(@SW_HIDE, $wGUIMainWindow)
	EndIf
	If $aServerOnlinePlayerYN = "yes" Then
		ShowPlayerCount()
	EndIf
	SetStatusIdle()
;~ 	GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY_Main_UpdateIntervalSlider')    ; **** WM_NOTIFY SLIDER
EndFunc   ;==>ShowMainGUI

; ------------------------------------------------------------------------------------------------------------
;      Update GUI Main GUI Window
; ------------------------------------------------------------------------------------------------------------

Func GUIUpdateQuick()
	Local $MemStats = MemGetStats()
	GUICtrlSetData($MemPercent, $MemStats[$MEM_LOAD] & "%")
	Local $tCPU = _CPUOverallUsageTracker_GetUsage($aCPUOverallTracker)
;~ 	Local $tCPU = _CurrentCPU()
	GUICtrlSetData($CPUPercent, Int($tCPU) & "%")
;~ 	$LabelCPU = GUICtrlCreateLabel("CPU:", 293, 27, 29, 17)
;~ 	$CPUPercent = GUICtrlCreateLabel("%", 322, 27, 24, 17)
	Local $tMainLVW[$aServerGridTotal][12]
	$aServerPI_Stripped = ResizeArray($aServerPID, $aServerGridTotal)
	$aServerMem = _GetMemArrayRawAvg($aServerPI_Stripped)
	Local $tTotalPlayers = 0
	Local $tTotalPlayerError = False
	Local $aHasRemoteServersTF = False
	For $i = 0 To ($aServerGridTotal - 1)
		If $xStartGrid[$i] <> "yes" Then
			$tMainLVW[$i][1] = "--"     ; Local YN
		Else
			$tMainLVW[$i][1] = $xStartGrid[$i]     ; Local YN
		EndIf
		If $xStartGrid[$i] <> "yes" Then
			$tMainLVW[$i][2] = "--"     ; Local YN
		Else
			$tMainLVW[$i][2] = $xStartGrid[$i]     ; Local YN
		EndIf
		$tMainLVW[$i][4] = $xServerNames[$i]     ; "Server " & $xServergridx[$i] & $xServergridy[$i] ; Server Name
		$tMainLVW[$i][5] = $xServergridx[$i] & $xServergridy[$i]     ; Grid
		If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) And $aServerOnlinePlayerYN = "yes" Then
			$tMainLVW[$i][6] = $aServerPlayers[$i] & " / " & $aServerMaxPlayers     ; Online PLayers
		Else
			$tMainLVW[$i][6] = "-- / " & $aServerMaxPlayers     ; Online PLayers
		EndIf

		If $xStartGrid[$i] = "yes" Then
			Local $tCPU = _ProcessUsageTracker_GetUsage($xServerCPU[$i])
			$tMainLVW[$i][7] = Round($tCPU, 1) & "%"     ; CPU
			Local $aMemTmp = ($aServerMem[$i] / (1024 ^ 2))
			$tMainLVW[$i][8] = _AddCommasDecimalNo($aMemTmp)     ; & " MB" ; Memory
		Else
			$tMainLVW[$i][7] = ""     ; CPU
			$tMainLVW[$i][8] = ""     ; Memory
		EndIf
		$tMainLVW[$i][9] = $xServerAltSaveDir[$i]     ; Folder
		If ProcessExists($aServerPID[$i]) Then
			$tMainLVW[$i][11] = "Running"     ; Status #008000
			If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
				_GUIListViewEx_SetColour($aGUIListViewEX, $cSWRunning & ";", $i, 11)
			EndIf
		Else     ; Server Not running
			$aServerPID[$i] = ""
			If $xStartGrid[$i] = "yes" Then
				If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
					$tMainLVW[$i][11] = "CRASHED"     ; Status
					_GUIListViewEx_SetColour($aGUIListViewEX, $cSWCrashed & ";", $i, 11)
					LogWrite(" WARNING!!! Server [" & $xServergridx[$i] & $xServergridy[$i] & "] PID [" & $aMainLVW[$i][10] & "] """ & $xServerNames[$i] & """ CRASHED, Restarting server")
				EndIf
			Else
				If $xLocalGrid[$i] = "yes" Then     ; Local Server
					If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
						$tMainLVW[$i][11] = "Disabled"     ; Status
						_GUIListViewEx_SetColour($aGUIListViewEX, $cSWDisabled & ";", $i, 11)
					EndIf
				Else     ; Remote Server
					$aHasRemoteServersTF = True
					If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) And ($aServerOnlinePlayerYN = "yes") Then     ; Remote Server with Online Players
						$tMainLVW[$i][11] = "Running"     ; Status #008000
						If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
							_GUIListViewEx_SetColour($aGUIListViewEX, $cSWRunning & ";", $i, 11)
						EndIf
					Else     ; Remote Server without ListPlayers response (offline)
						If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
							If $aPollRemoteServersYN = "yes" Then
								$tMainLVW[$i][11] = "Offline"     ; Status
								_GUIListViewEx_SetColour($aGUIListViewEX, $cSWOffline & ";", $i, 11)
							Else
								$tMainLVW[$i][11] = "Disabled"     ; Status
								_GUIListViewEx_SetColour($aGUIListViewEX, $cSWDisabled & ";", $i, 11)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		$tMainLVW[$i][10] = $aServerPID[$i]     ; PID
		For $x = 4 To 11
			If $tMainLVW[$i][$x] <> $aMainLVW[$i][$x] Then
				$aMainLVW[$i][$x] = $tMainLVW[$i][$x]
				_GUICtrlListView_SetItemText($wMainListViewWindow, $i, $aMainLVW[$i][$x], $x)
			EndIf
		Next
		If $aServerPlayers[$i] > -1 Then
			$tTotalPlayers += $aServerPlayers[$i]
		Else
			If $tMainLVW[$i][11] = "Offline" Then
				$tTotalPlayerError = True
			EndIf
		EndIf
		If $tMainLVW[$i][1] <> $aMainLVW[$i][1] Then
			$aMainLVW[$i][1] = $tMainLVW[$i][1]
;~ 		For $i = 0 To ($aServerGridTotal - 1) ; Place icon for RUN column
			If $xStartGrid[$i] = "yes" Then
				_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 1, 0)
			Else
				_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 1, 1)
			EndIf
;~ 		Next
		EndIf
		If $tMainLVW[$i][2] <> $aMainLVW[$i][2] Then
			$aMainLVW[$i][2] = $tMainLVW[$i][2]
;~ 		For $i = 0 To ($aServerGridTotal - 1) ; Place icon for RUN column
			If $xLocalGrid[$i] = "yes" Then
				_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 2, 4)
			Else
				_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 3, 5)
			EndIf
;~ 		Next
		EndIf
	Next
	$aTotalPlayersOnline = $tTotalPlayers
;~ 	If $aHasRemoteServersTF Then
;~ 		GUICtrlSetState($gPollRemoteServersCB, $GUI_ENABLE)
;~ 	Else
;~ 		GUICtrlSetState($gPollRemoteServersCB, $GUI_UNCHECKED)
;~ 		GUICtrlSetState($gPollRemoteServersCB, $GUI_DISABLE)
;~		GUICtrlSetColor($gPollRemoteServersLabel, 0x212121)
;~ 	EndIf
;~ 	Local $tTotalPlayers = 0
;~ 	Local $tTotalPlayerError = False
;~ 	For $i = 0 To ($aServerGridTotal - 1)
;~ 		If $aTotalPlayersOnline[$i] > -1 Then
;~ 			$tTotalPlayers += $aTotalPlayersOnline[$i]
;~ 		Else
;~ 			$tTotalPlayerError = True
;~ 		EndIf
;~ 	Next
;~ 	$aTotalPlayersOnline = _ArraySum($aServerPlayers)
	If $tTotalPlayerError Then $aTotalPlayersOnline = "--"
;~ 	If $aTotalPlayersOnline < 0 Then $aTotalPlayersOnline = "--"
	GUICtrlSetData($TotalPlayersEdit, $aTotalPlayersOnline)     ; & " / " & $aServerMaxPlayers) ; Players Edit Window

EndFunc   ;==>GUIUpdateQuick

Func _GUICtrlTab_SetBkColor($hWnd, $hSysTab32, $sBkColor)

	; Get tab position
	Local $aTabPos = ControlGetPos($hWnd, "", $hSysTab32)
	; Get size of user area
	Local $aTab_Rect = _GUICtrlTab_GetItemRect($hSysTab32, -1)
	; Create label
	GUICtrlCreateLabel("", $aTabPos[0] + 2, $aTabPos[1] + $aTab_Rect[3] + 4, $aTabPos[2] - 6, $aTabPos[3] - $aTab_Rect[3] - 7)
	; Colour label
	GUICtrlSetBkColor(-1, $sBkColor)
	; Disable label
	GUICtrlSetState(-1, $GUI_DISABLE)

EndFunc   ;==>_GUICtrlTab_SetBkColor

; ------------------------------------------------------------------------------------------------------------
;      Log GUI Window
; ------------------------------------------------------------------------------------------------------------

Func LogWindow($lDefaultTabNo = 1)
	If WinExists($LogWindow) Then
;~ 		WinSetOnTop($LogWindow, "", 1)
	Else
		#Region ### START Koda GUI section ### Form=g:\game server files\autoit\atlasserverupdateutility\temp work files\atladkoda(log-b1).kxf
		Local $lWidth = 1000, $lHeight = 600     ; 906 , 555
		Global $LogWindow = GUICreate($aUtilityVer & " Logs & Full Config Files", $lWidth, $lHeight, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
		GUISetIcon($aIconFile, 99)
		GUISetBkColor($cMWBackground)
		GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_Log_Close", $LogWindow)
		$lLogTabWindow = GUICtrlCreateTab(8, 8, ($lWidth - 17), ($lHeight - 18))     ;  889, 537
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		; ------------------------------------------------------------------------------------------------------------
		$lBasicTab = GUICtrlCreateTabItem("Basic Log")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lBasicTab, $cFWTabBackground)
;~     GUICtrlSetBkColor(-1, $cFWTabBackground)
		If $lDefaultTabNo = 1 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lBasicEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lBasicEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lBasicEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aLogFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lBasicEdit, $tTxt)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lBasicBDay[7], $lBasicDDate[7]
		Local $lX = 12
		$lBasicDDate[0] = _NowCalcDate()
		$lBasicBDay[0] = GUICtrlCreateButton("Today", $lX, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_Basic_B_Button")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetFont(-1, -1, $FW_EXTRABOLD)
		For $i = 1 To 6
			$lBasicDDate[$i] = _DateAdd('d', (0 - $i), _NowCalcDate())
			$lBasicBDay[$i] = GUICtrlCreateButton(StringTrimLeft($lBasicDDate[$i], 5), ($lX + (80 * $i)), 41, 75, 25)
			GUICtrlSetOnEvent(-1, "GUI_Log_Basic_B_Button")
			GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Next
		; ------------------------------------------------------------------------------------------------------------
		$lDetailedTab = GUICtrlCreateTabItem("Detailed Log")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lDetailedTab, $cFWTabBackground)
		If $lDefaultTabNo = 2 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lDetailedEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lDetailedEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lDetailedEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aLogDebugFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lDetailedEdit, $tTxt)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lDetailedBDay[7], $lDetailedDDate[7]
		Local $lX = 12
		$lDetailedDDate[0] = _NowCalcDate()
		$lDetailedBDay[0] = GUICtrlCreateButton("Today", $lX, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_Detailed_B_Button")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetFont(-1, -1, $FW_EXTRABOLD)
		For $i = 1 To 6
			$lDetailedDDate[$i] = _DateAdd('d', (0 - $i), _NowCalcDate())
			$lDetailedBDay[$i] = GUICtrlCreateButton(StringTrimLeft($lDetailedDDate[$i], 5), ($lX + (80 * $i)), 41, 75, 25)
			GUICtrlSetOnEvent(-1, "GUI_Log_Detailed_B_Button")
			GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Next
		; ------------------------------------------------------------------------------------------------------------
		$lOnlinePlayersTab = GUICtrlCreateTabItem("OnlinePlayers Log")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lOnlinePlayersTab, $cFWTabBackground)
		If $lDefaultTabNo = 3 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lOnlinePlayersEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lOnlinePlayersEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lOnlinePlayersEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aOnlinePlayerFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lOnlinePlayersEdit, $tTxt)
;~ 		_GUICtrlRichEdit_SetSel($lOnlinePlayersEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lOnlinePlayersEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lOnlinePlayersEdit) ; deselect all
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lOnlinePlayersBDay[7], $lOnlinePlayersDDate[7]
		Local $lX = 12
		$lOnlinePlayersDDate[0] = _NowCalcDate()
		$lOnlinePlayersBDay[0] = GUICtrlCreateButton("Today", $lX, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_OnlinePlayers_B_Button")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetFont(-1, -1, $FW_EXTRABOLD)
		For $i = 1 To 6
			$lOnlinePlayersDDate[$i] = _DateAdd('d', (0 - $i), _NowCalcDate())
			$lOnlinePlayersBDay[$i] = GUICtrlCreateButton(StringTrimLeft($lOnlinePlayersDDate[$i], 5), ($lX + (80 * $i)), 41, 75, 25)
			GUICtrlSetOnEvent(-1, "GUI_Log_OnlinePlayers_B_Button")
			GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Next
		; ------------------------------------------------------------------------------------------------------------
		Global $lServerSummaryTab = GUICtrlCreateTabItem("Server Summary")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lServerSummaryTab, $cFWTabBackground)
		If $lDefaultTabNo = 4 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lServerSummaryEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_MULTILINE)
		Local $tFileOpen = FileOpen($aServerSummaryFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lServerSummaryEdit, $tTxt)
		_GUICtrlRichEdit_SetBkColor($lServerSummaryEdit, $cFWBackground)
		SetFont($lServerSummaryEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lServerSummaryEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lServerSummaryEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lServerSummaryEdit) ; deselect all
;~ 		ControlSend("", "", $lServerSummaryEdit, "^+{Home}")
		GUICtrlSetFont(-1, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lServerSummaryBRefresh = GUICtrlCreateButton("Refresh", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_ServerSummary_B_Button")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$lConfigTab = GUICtrlCreateTabItem("AtlasServerUpdateUtility.ini")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lConfigTab, $cFWTabBackground)
		If $lDefaultTabNo = 5 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lConfigEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lConfigEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lConfigEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aIniFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lConfigEdit, $tTxt)
		SetFont($lConfigEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lConfigEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lConfigEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lConfigEdit) ; deselect all
;~ 		ControlSend("","", $lConfigEdit, "^+{Home}")
		GUICtrlSetFont(-1, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lConfigIniBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_Config_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lConfigINIBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_Config_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		$lGridSelectTab = GUICtrlCreateTabItem("GridStartSelect.ini")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lGridSelectTab, $cFWTabBackground)
		If $lDefaultTabNo = 6 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lGridSelectEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lGridSelectEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lGridSelectEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aGridSelectFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lGridSelectEdit, $tTxt)
		SetFont($lGridSelectEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lGridSelectEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lGridSelectEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lGridSelectEdit) ; deselect all
;~ 		ControlSend("","", $lGridSelectEdit, "^+{Home}")
		GUICtrlSetFont(-1, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lGridStartSelectBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_GridSelect_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lGridStartSelectBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_GridSelect_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		$lServerGridTab = GUICtrlCreateTabItem("ServerGrid.json")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lServerGridTab, $cFWTabBackground)
		If $lDefaultTabNo = 7 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lServerGridEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lServerGridEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lServerGridEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aConfigFull)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lServerGridEdit, $tTxt)
		SetFont($lServerGridEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lServerGridEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lServerGridEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lServerGridEdit) ; deselect all
;~ 		ControlSend("","", $lServerGridEdit, "^+{Home}")
		GUICtrlSetFont(-1, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lServerGridBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_ServerGrid_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lServerGridBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_ServerGrid_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		$lDefaultGameTab = GUICtrlCreateTabItem("DefaultGame.ini")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lDefaultGameTab, $cFWTabBackground)
		If $lDefaultTabNo = 8 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lDefaultGameEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lDefaultGameEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lDefaultGameEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aDefaultGame)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lDefaultGameEdit, $tTxt)
		SetFont($lDefaultGameEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lDefaultGameEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lDefaultGameEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lDefaultGameEdit) ; deselect all
;~ 		ControlSend("","", $lDefaultGameEdit, "^+{Home}")
		GUICtrlSetFont(-1, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lDefaultGameBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultGame_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lDefaultGameBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultGame_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		$lDefaultGUSTab = GUICtrlCreateTabItem("DefaultGUS.ini")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lDefaultGUSTab, $cFWTabBackground)
		If $lDefaultTabNo = 9 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lDefaultGUSEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lDefaultGUSEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lDefaultGUSEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aDefaultGUS)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lDefaultGUSEdit, $tTxt)
		SetFont($lDefaultGUSEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lDefaultGUSEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lDefaultGUSEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lDefaultGUSEdit) ; deselect all
;~ 		ControlSend("","", $lDefaultGUSEdit, "^+{Home}")
		GUICtrlSetFont(-1, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lDefaultGUSBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultGUS_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lDefaultGUSBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultGUS_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		$lDefaultEngineTab = GUICtrlCreateTabItem("DefaultEngine.ini")
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lDefaultEngineTab, $cFWTabBackground)
		If $lDefaultTabNo = 10 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lDefaultEngineEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lDefaultEngineEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lDefaultEngineEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aDefaultEngine)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		_GUICtrlRichEdit_SetText($lDefaultEngineEdit, $tTxt)
		SetFont($lDefaultEngineEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lDefaultEngineEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lDefaultEngineEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lDefaultEngineEdit) ; deselect all
;~ 		ControlSend("","", $lDefaultEngineEdit, "^+{Home}")
		GUICtrlSetFont(-1, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $lDefaultEngineBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultEngine_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lDefaultEngineBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultEngine_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)

		GUICtrlCreateTabItem("")
		GUISetState(@SW_SHOW)
	EndIf
	#EndRegion ### END Koda GUI section ###
EndFunc   ;==>LogWindow

Func WM_NOTIFY_Main_UpdateIntervalSlider($hWnd, $iMsg, $iWParam, $iLParam)
	Local $iWLoWord = BitAND($iWParam, 0xFFFF)
	If $iWLoWord = $UpdateIntervalSlider Then
		GUICtrlSetData($UpdateIntervalEdit, GUICtrlRead($UpdateIntervalSlider))
	EndIf
	Return $GUI_RUNDEFMSG
	;
	;	$aSliderNow = GUICtrlRead($UpdateIntervalSlider)
	;	If $aSliderNow <> $aSliderPrev Then
	;		GUICtrlSetData($UpdateIntervalEdit, $aSliderNow)
	;		$aSliderPrev = $aSliderNow
	;	EndIf
EndFunc   ;==>WM_NOTIFY_Main_UpdateIntervalSlider

; ------------------------------------------------------------------------------------------------------------
;      Wizard Select GUI Window
; ------------------------------------------------------------------------------------------------------------

Func WizardSelect()
;~ 	Opt("GUIResizeMode", $GUI_DOCKLEFT + $GUI_DOCKTOP)
	#Region ### START Koda GUI section ### Form=g:\game server files\autoit\atlasserverupdateutility\temp work files\atladkoda(lwiz-1 new or exist)b1.kxf
	Global $WizardWindowSelect = GUICreate("AtlasServerUpdateUtility Setup Wizard", 906, 555, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_WizardSelect_Close", $WizardWindowSelect)
	GUISetIcon($aIconFile, 99)
	GUISetBkColor($cW1Background)
	$Group1 = GUICtrlCreateGroup("Group1", 192, -32, 1, 33)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group2 = GUICtrlCreateGroup("AtlasServerUpdateUtility", 48, 40, 809, 337)
	GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
	$Label1 = GUICtrlCreateLabel("Welcome to the AtlasServerupdateUtility setup wizard!", 172, 123, 526, 29)
	GUICtrlSetFont(-1, 16, 800, 4, "MS Sans Serif")
	$Label2 = GUICtrlCreateLabel("Please select from the following:", 308, 223, 272, 28)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
	Global $W1_B_New = GUICtrlCreateButton("New Install", 299, 267, 115, 33)
	GUICtrlSetOnEvent(-1, "GUI_W1_B_NewInstall")
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	Global $W1_B_Exist = GUICtrlCreateButton("Existing Server", 475, 267, 115, 33)
	GUICtrlSetOnEvent(-1, "GUI_W1_B_Existing")
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	If WinExists($wGUIMainWindow) Then
	Else
		While $aExitGUIW1 = False
;~ 		If $aExitGUIW1 Then
;~ 			GUIDelete($WizardWindowSelect)
;~ 			ExitLoop
;~ 		EndIf
			Sleep(100)
		WEnd
		GUIDelete($WizardWindowSelect)
		$aExitGUIW1 = False
		If $aWizardSelect = 2 Then WizardExisting(1)
		If $aWizardSelect = 3 Then WizardNew()
	EndIf
EndFunc   ;==>WizardSelect
Func GUI_WizardSelect_Close()
	$aExitGUIW1 = True
	$aWizardSelect = 1
	If WinExists($wGUIMainWindow) Then
		GUIDelete($WizardWindowSelect)
		$aExitGUIW1 = False
	EndIf
EndFunc   ;==>GUI_WizardSelect_Close
Func GUI_W1_B_Existing()
	GUIDelete($WizardWindowSelect)
	$aExitGUIW1 = True
	If WinExists($wGUIMainWindow) Then
		WizardExisting(1)
	Else
		$aWizardSelect = 2
	EndIf
EndFunc   ;==>GUI_W1_B_Existing
Func GUI_W1_B_NewInstall()
	GUIDelete($WizardWindowSelect)
	$aExitGUIW1 = True
	If WinExists($wGUIMainWindow) Then
		WizardNew()
	Else
		$aWizardSelect = 3
	EndIf
EndFunc   ;==>GUI_W1_B_NewInstall

;~ Func WizardNew()
;~ 	MsgBox(0, $aUtilName, "New Install Coming Soon!", 10)
;~ EndFunc   ;==>WizardNew


; ------------------------------------------------------------------------------------------------------------
;      Wizard Existing GUI Window
; ------------------------------------------------------------------------------------------------------------

Func WizardExisting($wDefaultTabNo = 1)
	Global $aGUI_W2_LastTab = 0
	Global $aGUI_W2_T4_GridStartClicked = False
	Global $aGUI_W2_T6_ConfigClicked = False
	If WinExists($wGUIMainWindow) Then $aConfigSettingsImported = True
;~ 	Opt("GUIResizeMode", $GUI_DOCKLEFT + $GUI_DOCKTOP)
	#Region ### START Koda GUI section ### Form=G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Temp Work Files\atladkoda(lwiz-2 exist)b1.kxf
;~ 	Global $WizardWindowExist = GUICreate("AtlasServerUpdateUtility Setup Wizard", 906, 555, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
	Global $WizardWindowExist = GUICreate("AtlasServerUpdateUtility Setup Wizard", 906, 555, -1, -1)
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_WizardExist_Close", $WizardWindowExist)
	GUISetIcon($aIconFile, 99)
	GUISetBkColor($cW2Background)
	Global $WizardTabWindow = GUICtrlCreateTab(8, 8, 889, 537)
	GUICtrlSetOnEvent(-1, "GUI_W2_On_Tab")
	GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
	Global $Tab1 = GUICtrlCreateTabItem("1 Atlas Folder")
	If $wDefaultTabNo = 1 Then GUICtrlSetState(-1, $GUI_SHOW)
	$Label1 = GUICtrlCreateLabel("Welcome to the AtlasServerUpdateUtility install Wizard.", 72, 64, 537, 29)
	GUICtrlSetFont(-1, 16, 800, 0, "MS Sans Serif")
	$Label2 = GUICtrlCreateLabel("Please select the Atlas Dedicated Server installation folder: ", 104, 192, 358, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	Global $W2_T1_B_ImportSettings = GUICtrlCreateButton("Import Settings", 105, 370, 179, 25)
	GUICtrlSetOnEvent(-1, "GUI_W2_T1_B_ImportSettings")
	Global $W2_T1_B_SelectFolder = GUICtrlCreateButton("Select Folder", 684, 225, 107, 25)
	GUICtrlSetOnEvent(-1, "GUI_W2_T1_B_SelectFolder")
	$Label3 = GUICtrlCreateLabel("Click below to import existing settings from the " & $aConfigFile & " file.", 104, 336, 392, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Label4 = GUICtrlCreateLabel("Step 1", 72, 160, 51, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label5 = GUICtrlCreateLabel("Step 2", 72, 294, 51, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	Global $W2_T1_I_AtlasDIR = GUICtrlCreateInput($aServerDirLocal, 108, 225, 569, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T1_I_AtlasDIR")
	$Label32 = GUICtrlCreateLabel("For existing servers.", 504, 104, 173, 28)
	GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
	Global $Tab2 = GUICtrlCreateTabItem("2 AltSaveDIR")
	If $wDefaultTabNo = 2 Then GUICtrlSetState(-1, $GUI_SHOW)
	$Group1 = GUICtrlCreateGroup("AltSaveDIR", 76, 89, 753, 369)
	Global $W2_T2_R_Default00 = GUICtrlCreateRadio("Default Scheme: 00,01,02,10,11,12", 100, 169, 209, 17)
	GUICtrlSetState($W2_T2_R_Default00, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "GUI_W2_T2_R_Default00")
	Global $W2_T2_R_DefaultA1 = GUICtrlCreateRadio("Default Scheme: A1,A2,A3,B1,B2,B3", 100, 201, 281, 17)
	GUICtrlSetOnEvent(-1, "GUI_W2_T2_R_DefaultA10")
	Global $W2_T2_R_Custom1 = GUICtrlCreateRadio("Custom Method 1: Direct listing of Folders", 100, 233, 217, 17)
	GUICtrlSetOnEvent(-1, "GUI_W2_T2_R_Custom1")
	Global $W2_T2_R_Custom2 = GUICtrlCreateRadio("Custom Method 2: Enter folders one-at-a-time using a new popup window for each server.  (Coming soon!)", 100, 337, 600, 17)
	GUICtrlSetOnEvent(-1, "GUI_W2_T2_R_Custom2")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$Label6 = GUICtrlCreateLabel("Server AltSaveDirectoryName(s) (comma separated. Use same order as servers are listed in ServerGrid.json) ex.A1,A2,A3,B1,B2,B3,C1,C2,C3", 116, 257, 700, 17)
	Global $W2_T2_B_Folders = GUICtrlCreateButton("Enter Folders", 116, 361, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_W2_T2_B_Folders")
	GUICtrlSetState(-1, $GUI_DISABLE)
	$Label8 = GUICtrlCreateLabel("Please select the naming scheme for the grid server folders:", 100, 129, 358, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Label7 = GUICtrlCreateLabel("Coming Soon! Folder and RCON port entry in one simple screen.", 116, 409, 306, 17)
	GUICtrlSetFont(-1, 8, 400, 2, "MS Sans Serif")
	Global $W2_T2_I_AltSaveDIR = GUICtrlCreateInput($aServerAltSaveDir, 116, 281, 625, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T2_I_AltSaveDIR")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Label22 = GUICtrlCreateLabel("Step 3", 36, 49, 51, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	Global $Tab3 = GUICtrlCreateTabItem("3 RCON Ports")
	If $wDefaultTabNo = 3 Then GUICtrlSetState(-1, $GUI_SHOW)
	$Group2 = GUICtrlCreateGroup("RCON Ports", 76, 193, 753, 329)
	Global $W2_T3_R_Import = GUICtrlCreateRadio("Import RCON ports from each grid server's GameUserSettings.ini file.", 100, 281, 361, 17)
	GUICtrlSetOnEvent(-1, "GUI_W2_T3_R_Import")
	Global $W2_T3_R_Method1 = GUICtrlCreateRadio("Entry Method 1: Direct listing of RCON ports", 100, 313, 233, 17)
	GUICtrlSetState($W2_T3_R_Method1, $GUI_CHECKED)
	GUICtrlSetOnEvent(-1, "GUI_W2_T3_R_Method1")
	Global $W2_T3_R_Method2 = GUICtrlCreateRadio("Custom Method 2: Enter RCON ports one-at-a-time using a new popup window for each server. (Coming Soon!)", 100, 417, 600, 17)
	GUICtrlSetState(-1, $GUI_DISABLE)     ; Disabled (Coming Soon!)
	GUICtrlSetOnEvent(-1, "GUI_W2_T3_R_Method2")
	$Label9 = GUICtrlCreateLabel("Server RCON ports (comma separated. Use same order as servers are listed in ServerGrid.json", 116, 337, 447, 17)
	Global $W2_T3_B_Ports = GUICtrlCreateButton("Enter Ports", 116, 441, 75, 25)
	GUICtrlSetState(-1, $GUI_DISABLE)     ; Disabled (Coming Soon!)
	GUICtrlSetOnEvent(-1, "GUI_W2_T3_B_Ports")
	$Label10 = GUICtrlCreateLabel("Please select the entry method for the RCON ports for each grid server.", 100, 233, 422, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	$Label11 = GUICtrlCreateLabel("Coming Soon! Folder and RCON port entry in one simple screen.", 116, 489, 306, 17)
	GUICtrlSetFont(-1, 8, 400, 2, "MS Sans Serif")
;~ 	Local $tRCONCnt = 25710
;~ 	Local $tRCONStr = $tRCONCnt
;~ 	If $aServerGridTotal > 1 Then
;~ 		$tRCONStr &= ","
;~ 		If $aServerGridTotal > 2 Then
;~ 			For $i = 2 To ($aServerGridTotal - 1)
;~ 				$tRCONCnt += 2
;~ 				$tRCONStr &= $tRCONCnt & ","
;~ 			Next
;~ 		EndIf
;~ 		$tRCONCnt += 2
;~ 		$tRCONStr &= $tRCONCnt
;~ 	EndIf
	Global $W2_T3_I_RCONPorts = GUICtrlCreateInput("25710,25712,25714,25716,25718,25720,25722,25724,25726", 116, 361, 657, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T3_I_RCONPorts")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Group4 = GUICtrlCreateGroup("RCON IP Address", 76, 89, 753, 97)
	Global $W2_T3_R_UseServerIP = GUICtrlCreateRadio("Use Server IP (Requires port forwarding with router loopback)", 100, 121, 393, 17)
	GUICtrlSetOnEvent(-1, "GUI_W2_T3_R_UseServerIP")
	GUICtrlSetState($W2_T3_R_UseServerIP, $GUI_CHECKED)
	Global $W2_T3_R_CustomIP = GUICtrlCreateRadio("Custom IP", 100, 153, 65, 17)
	GUICtrlSetOnEvent(-1, "GUI_W2_T3_R_CustomIP")
	If $iIniRead Then
		If $aServerIP = "" Then
			$tTmp = "127.0.0.1"
		Else
			$tTmp = $aServerRCONIP
		EndIf
	Else
		$tTmp = "127.0.0.1"
	EndIf
	Global $W2_T3_I_RCONIP = GUICtrlCreateInput($tTmp, 172, 153, 145, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T3_I_RCONIP")
	$Label31 = GUICtrlCreateLabel("(Ex: 127.0.0.1)", 324, 153, 73, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Label23 = GUICtrlCreateLabel("Step 4", 36, 49, 51, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Tab4 = GUICtrlCreateTabItem("4 Grid Start")
	If $wDefaultTabNo = 4 Then GUICtrlSetState(-1, $GUI_SHOW)
	$Label12 = GUICtrlCreateLabel("* If all grid servers are on one machine and you plan to start them all, skip this section.", 96, 40, 595, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$Label13 = GUICtrlCreateLabel("Otherwise, please make any changes to the AtlasServerUpdateUtilityGridStartSelect.ini file below:", 104, 64, 581, 20)
	GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
	Global $W2_T4_E_GridStart = GUICtrlCreateEdit("", 16, 120, 873, 409)
	GUICtrlSetOnEvent(-1, "GUI_W2_T4_E_GridStart")
	Local $tFileOpen = FileOpen($aGridSelectFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($W2_T4_E_GridStart, $tTxt)
	Global $W2_T4_B_Save = GUICtrlCreateButton("Save", 16, 88, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_W2_T4_B_Save")
	Global $W2_T4_B_Reset = GUICtrlCreateButton("Reset", 96, 88, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_W2_T4_B_Reset")
	$Label24 = GUICtrlCreateLabel("Step 5", 36, 49, 51, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	;----------
	$Tab5 = GUICtrlCreateTabItem("5 Priority Settings")
	If $wDefaultTabNo = 5 Then GUICtrlSetState(-1, $GUI_SHOW)
	$Group3 = GUICtrlCreateGroup("Atlas Server", 72, 112, 753, 177)
	$Label14 = GUICtrlCreateLabel("Admin Password", 88, 136, 82, 17, $SS_RIGHT)
	$Label15 = GUICtrlCreateLabel("Max Players", 352, 136, 61, 17, $SS_RIGHT)
	$Label16 = GUICtrlCreateLabel("Reserved Slots", 488, 136, 76, 17, $SS_RIGHT)
;~ Global $W2_T5_I_ReservedSlots = GUICtrlCreateInput("", 176, 136, 9, 1)
;~ GUICtrlSetOnEvent(-1, "GUI_W2_T5_I_ReservedSlots")
;~ GUICtrlSetData(-1, "Edit1")
	Global $W2_T5_I_AdminPass = GUICtrlCreateInput($aServerAdminPass, 176, 136, 121, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T5_I_AdminPass")
	Global $W2_T5_I_MaxPlayers = GUICtrlCreateInput($aServerMaxPlayers, 416, 136, 25, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T5_I_MaxPlayers")
	Global $W2_T5_I_ReservedSlots = GUICtrlCreateInput($aServerReservedSlots, 568, 136, 25, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T5_I_ReservedSlots")
	$Label17 = GUICtrlCreateLabel("Atlas extra commandline parameters", 136, 184, 173, 17, $SS_RIGHT)
	$Label18 = GUICtrlCreateLabel("SteamCMD extra commandline parameters", 104, 216, 204, 17, $SS_RIGHT)
	Global $W2_T5_I_AtlasExtraCMD = GUICtrlCreateInput($aServerExtraCMD, 320, 184, 369, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T5_I_AtlasExtraCMD")
	Global $W2_T5_I_SteamCMDExtraCMD = GUICtrlCreateInput($aSteamExtraCMD, 320, 216, 369, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T5_I_SteamCMDExtraCMD")
	$Label19 = GUICtrlCreateLabel("Atlas server and mod update check interval", 96, 248, 209, 17, $SS_RIGHT)
	Global $W2_T5_I_UpdateInterval = GUICtrlCreateInput($aUpdateCheckInterval, 320, 248, 25, 21)
	GUICtrlSetOnEvent(-1, "GUI_W2_T5_I_UpdateInterval")
	$Label20 = GUICtrlCreateLabel("minutes (05-59)", 352, 248, 76, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Label25 = GUICtrlCreateLabel("Step 6", 36, 49, 51, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	;----------
	$Tab6 = GUICtrlCreateTabItem("6 Review All Settings")
	If $wDefaultTabNo = 6 Then GUICtrlSetState(-1, $GUI_SHOW)
	$Label21 = GUICtrlCreateLabel("Make any desired changes to the AtlasServerUpdateUtility.ini file below.", 104, 48, 502, 20)
	GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
	$Label26 = GUICtrlCreateLabel("Step 7", 36, 49, 51, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	Global $W2_T6_B_Save = GUICtrlCreateButton("Save", 12, 89, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_W2_T6_B_Save")
	Global $W2_T6_B_Reset = GUICtrlCreateButton("Reset", 92, 89, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_W2_T6_B_Reset")
	Global $W2_T6_E_Config = GUICtrlCreateEdit("", 12, 129, 873, 409)
	GUICtrlSetOnEvent(-1, "GUI_W2_T6_E_Config")
	Local $tFileOpen = FileOpen($aIniFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData(-1, $tTxt)
	$Label29 = GUICtrlCreateLabel("NOTICE!!! The utility must be restarted for most changes to take effect.", 176, 72, 547, 17)
	$Tab7 = GUICtrlCreateTabItem("7 Finish")
	If $wDefaultTabNo = 7 Then GUICtrlSetState(-1, $GUI_SHOW)
	$Label27 = GUICtrlCreateLabel("Step 8", 36, 49, 51, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	$Label28 = GUICtrlCreateLabel("Congratulations!  You have completed the setup wizard.", 186, 120, 540, 29)
	GUICtrlSetFont(-1, 16, 800, 0, "MS Sans Serif")
	$Label30 = GUICtrlCreateLabel("Click to restart the utility with your new settings.", 282, 232, 334, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	Global $W2_T7_B_ExitRestartY = GUICtrlCreateButton("RESTART", 402, 272, 75, 25)
	GUICtrlSetOnEvent(-1, "W2_T7_B_ExitRestartY")
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	Global $W2_T7_B_ExitRestartN = GUICtrlCreateButton("Exit without Restarting Util", 368, 336, 147, 25)
	GUICtrlSetOnEvent(-1, "W2_T7_B_ExitRestartN")
	$Label33 = GUICtrlCreateLabel("(Warning! Some settings will not take effect until utility is restarted)", 288, 368, 313, 17, $SS_CENTER)
	GUICtrlCreateTabItem("")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	If WinExists($wGUIMainWindow) Then
	Else
		While $aExitGUIW2 = False
			Sleep(100)
		WEnd
		GUIDelete($WizardWindowExist)
		$aExitGUIW2 = False
	EndIf
EndFunc   ;==>WizardExisting

Func GUI_WizardExist_Close()
	If WinExists($wGUIMainWindow) Then
		GUIDelete($WizardWindowExist)
	Else
		$aExitGUIW2 = True
	EndIf
	If $aSplashStartUp <> 0 Then
		$aSplashStartUp = SplashTextOn($aUtilName, $aStartText & @CRLF & "Setup Wizard Completed.", 475, 110, -1, -1, $DLG_MOVEABLE, "")
		Sleep(1500)
		SplashOff()
	EndIf
EndFunc   ;==>GUI_WizardExist_Close

Func GUI_W2_On_Tab()
	Switch GUICtrlRead($WizardTabWindow)
		Case 0     ; Tab 1 Atlas Folder
			GUI_W2_Last_Tab(0)
		Case 1     ; Tab 2 AltSaveDIR
			GUI_W2_Last_Tab(1)
			If $iIniRead Then
				If $aServerAltSaveSelect = "1" Then GUICtrlSetState($W2_T2_R_Default00, $GUI_CHECKED)
				If $aServerAltSaveSelect = "2" Then GUICtrlSetState($W2_T2_R_DefaultA1, $GUI_CHECKED)
				If $aServerAltSaveSelect = "3" Then
					GUICtrlSetState($W2_T2_R_Custom1, $GUI_CHECKED)
					GUICtrlSetData($W2_T2_I_AltSaveDIR, $aServerAltSaveDir)
				EndIf
			EndIf
		Case 2     ; Tab 3 RCON Ports
			GUI_W2_Last_Tab(2)
			If $aConfigSettingsImported Then
				If $iIniRead Then
					GUICtrlSetData($W2_T3_I_RCONPorts, $aServerRCONPort)
				Else
					Local $tRCONCnt = 25710
					Local $tRCONStr = $tRCONCnt
					If $aServerGridTotal > 1 Then
						$tRCONStr &= ","
						If $aServerGridTotal > 2 Then
							For $i = 2 To ($aServerGridTotal - 1)
								$tRCONCnt += 2
								$tRCONStr &= $tRCONCnt & ","
							Next
						EndIf
						$tRCONCnt += 2
						$tRCONStr &= $tRCONCnt
					EndIf
					GUICtrlSetData($W2_T3_I_RCONPorts, $tRCONStr)
				EndIf
			EndIf
			If $iIniRead And ($aServerRCONImport = "yes") Then GUICtrlSetState($W2_T3_R_Import, $GUI_CHECKED)
		Case 3     ; Tab 4 Grid Start
			GUI_W2_Last_Tab(3)
			If $aConfigSettingsImported Then
				If FileExists($aGridSelectFile) Then
				Else
					GridStartSelect($aGridSelectFile, $aLogFile, True)
				EndIf
				Local $tFileOpen = FileOpen($aGridSelectFile)
				Local $tTxt = FileRead($tFileOpen)
				FileClose($tFileOpen)
				GUICtrlSetData($W2_T4_E_GridStart, $tTxt)
			Else
				MsgBox($MB_OK, $aUtilName, "Cannot create GridStartSelect.ini file until the " & $aConfigFile & " file has been imported.")
				GUICtrlSetState($Tab1, $GUI_SHOW)
			EndIf
		Case 4     ; Tab 5 Priority Settings
			GUI_W2_Last_Tab(4)
			If $iIniRead Then
				GUICtrlSetData($W2_T5_I_AdminPass, $aServerAdminPass)
				GUICtrlSetData($W2_T5_I_MaxPlayers, $aServerMaxPlayers)
				GUICtrlSetData($W2_T5_I_ReservedSlots, $aServerReservedSlots)
				GUICtrlSetData($W2_T5_I_AtlasExtraCMD, $aServerExtraCMD)
				GUICtrlSetData($W2_T5_I_SteamCMDExtraCMD, $aSteamExtraCMD)
				GUICtrlSetData($W2_T5_I_UpdateInterval, $aUpdateCheckInterval)
			EndIf
		Case 5     ; Tab 6 Review All Settings
			Local $tFileOpen = FileOpen($aIniFile)
			Local $tTxt = FileRead($tFileOpen)
			FileClose($tFileOpen)
			GUICtrlSetData($W2_T6_E_Config, $tTxt)
			GUI_W2_Last_Tab(5)
		Case 6     ; Tab 7 Finish
			GUI_W2_Last_Tab(6)
	EndSwitch
EndFunc   ;==>GUI_W2_On_Tab

Func GUI_W2_Last_Tab($tTab)
	If ($aGUI_W2_LastTab = 0) And ($aConfigSettingsImported = False) Then
		MsgBox($MB_OK, $aUtilName, "You must Import " & $aConfigFile & " file to continue.")
		GUICtrlSetState($Tab1, $GUI_SHOW)
		Return
	EndIf
	If ($aGUI_W2_LastTab = 3) And ($aGUI_W2_T4_GridStartClicked = True) Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to GridStartSelect.ini?" & @CRLF & @CRLF & _
				"Click (YES) to Save" & @CRLF & _
				"Click (NO) to Skip" & @CRLF & _
				"Click (CANCEL) to Reset.", 10)
		If $tMB = 6 Then     ; YES
			Local $tTxt = GUICtrlRead($W2_T4_E_GridStart)
			Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
			Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
			FileMove($aGridSelectFile, $tFile, 1)
			FileWrite($aGridSelectFile, $tTxt)
			SplashTextOn($aUtilName, $aUtilName & "GridStartSelect.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "GridStartSelect.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(3000)
			SplashOff()
		ElseIf $tMB = 2 Then     ; CANCEL
			GUI_W2_T4_B_Reset()
		EndIf
	EndIf
	If ($aGUI_W2_LastTab = 5) And ($aGUI_W2_T6_ConfigClicked = True) Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to AtlasServerUpdateUtility.ini?" & @CRLF & @CRLF & _
				"Click (YES) to Save" & @CRLF & _
				"Click (NO) to Skip" & @CRLF & _
				"Click (CANCEL) to Reset.", 10)
		If $tMB = 6 Then     ; YES
			GUI_W2_T6_B_Save()
		ElseIf $tMB = 2 Then     ; CANCEL
			GUI_W2_T6_B_Reset()
		EndIf
	EndIf
	$aGUI_W2_LastTab = $tTab
EndFunc   ;==>GUI_W2_Last_Tab

Func GUI_W2_T1_B_SelectFolder()
	Local $tCtrlID = $W2_T1_I_AtlasDIR
	Local $tInput = FileSelectFolder("Please select " & $aUtilName & " installation folder", $aServerDirLocal)
	If @error Then
		Local $tRead = GUICtrlRead($tCtrlID)
		GUICtrlSetData($tCtrlID, $tRead)
	Else
		GUICtrlSetData($tCtrlID, $tInput)
	EndIf
	$aServerDirLocal = GUICtrlRead($tCtrlID)
	$aServerDirLocal = RemoveInvalidCharacters($aServerDirLocal)
	$aServerDirLocal = RemoveTrailingSlash($aServerDirLocal)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " DIR ###", $aServerDirLocal)
EndFunc   ;==>GUI_W2_T1_B_SelectFolder
Func GUI_W2_T1_I_AtlasDIR()
	Local $tCtrlID = $W2_T1_I_AtlasDIR
	$aServerDirLocal = GUICtrlRead($tCtrlID)
	$aServerDirLocal = RemoveInvalidCharacters($aServerDirLocal)
	$aServerDirLocal = RemoveTrailingSlash($aServerDirLocal)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " DIR ###", $aServerDirLocal)
EndFunc   ;==>GUI_W2_T1_I_AtlasDIR
Func GUI_W2_T1_B_ImportSettings()
	$aConfigSettingsImported = True
	SplashTextOn($aUtilName, "Importing settings from " & $aConfigFile & ".", 475, 110, -1, -1, $DLG_MOVEABLE, "")
	Global $aConfigFull = $aServerDirLocal & "\ShooterGame\" & $aConfigFile
	Global $aDefaultGame = $aServerDirLocal & "\ShooterGame\Config\DefaultGame.ini"
	Global $aDefaultGUS = $aServerDirLocal & "\ShooterGame\Config\DefaultGameUserSettings.ini"
	Global $aDefaultEngine = $aServerDirLocal & "\ShooterGame\Config\DefaultEngine.ini"
	ImportConfig($aServerDirLocal, $aConfigFile)
	Sleep(2000)
	SplashOff()
EndFunc   ;==>GUI_W2_T1_B_ImportSettings
; TAB 2 -------------------------
Func GUI_W2_T2_R_Default00()
	$aServerAltSaveSelect = 1
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", $aServerAltSaveSelect)
EndFunc   ;==>GUI_W2_T2_R_Default00
Func GUI_W2_T2_R_DefaultA10()
	$aServerAltSaveSelect = 2
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", $aServerAltSaveSelect)
EndFunc   ;==>GUI_W2_T2_R_DefaultA10
Func GUI_W2_T2_R_Custom1()
	$aServerAltSaveSelect = 3
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", $aServerAltSaveSelect)
	$aServerAltSaveDir = GUICtrlRead($W2_T2_I_AltSaveDIR)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames (Use same order as listed in ServerGrid.json. Comma separated) ###", $aServerAltSaveDir)
EndFunc   ;==>GUI_W2_T2_R_Custom1
Func GUI_W2_T2_R_Custom2()
	; Coming Soon!
EndFunc   ;==>GUI_W2_T2_R_Custom2
Func GUI_W2_T2_B_Folders()
	; Coming Soon!
EndFunc   ;==>GUI_W2_T2_B_Folders
Func GUI_W2_T2_I_AltSaveDIR()
	$aServerAltSaveSelect = 3
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", $aServerAltSaveSelect)
	$aServerAltSaveDir = GUICtrlRead($W2_T2_I_AltSaveDIR)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames (Use same order as listed in ServerGrid.json. Comma separated) ###", $aServerAltSaveDir)
	GUICtrlSetState($W2_T2_R_Custom1, $GUI_CHECKED)
EndFunc   ;==>GUI_W2_T2_I_AltSaveDIR
; TAB 3 -------------------------
Func GUI_W2_T3_R_UseServerIP()
	$aServerRCONIP = ""
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "RCON IP (ex. 127.0.0.1 - Leave BLANK for server IP) ###", $aServerRCONIP)
EndFunc   ;==>GUI_W2_T3_R_UseServerIP
Func GUI_W2_T3_I_RCONIP()
	$aServerRCONIP = GUICtrlRead($W2_T3_I_RCONIP)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "RCON IP (ex. 127.0.0.1 - Leave BLANK for server IP) ###", $aServerRCONIP)
	GUICtrlSetState($W2_T3_R_CustomIP, $GUI_CHECKED)
EndFunc   ;==>GUI_W2_T3_I_RCONIP
Func GUI_W2_T3_R_CustomIP()
	$aServerRCONIP = GUICtrlRead($W2_T3_I_RCONIP)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "RCON IP (ex. 127.0.0.1 - Leave BLANK for server IP) ###", $aServerRCONIP)
	GUICtrlSetState($W2_T3_R_CustomIP, $GUI_CHECKED)
EndFunc   ;==>GUI_W2_T3_R_CustomIP
Func GUI_W2_T3_R_Import()
	$aServerRCONImport = "yes"
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Import RCON ports from GameUserSettings.ini files? (yes/no) ###", $aServerRCONImport)
EndFunc   ;==>GUI_W2_T3_R_Import
Func GUI_W2_T3_R_Method1()
	$aServerRCONImport = "no"
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Import RCON ports from GameUserSettings.ini files? (yes/no) ###", $aServerRCONImport)
	$aServerRCONPort = GUICtrlRead($W2_T3_I_RCONPorts)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server RCON Port(s) (comma separated, grid order as in ServerGrid.json, ignore if importing RCON ports) ###", $aServerRCONPort)
	GUICtrlSetState($W2_T3_R_Method1, $GUI_CHECKED)
EndFunc   ;==>GUI_W2_T3_R_Method1
Func GUI_W2_T3_I_RCONPorts()
	$aServerRCONImport = "no"
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Import RCON ports from GameUserSettings.ini files? (yes/no) ###", $aServerRCONImport)
	$aServerRCONPort = GUICtrlRead($W2_T3_I_RCONPorts)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server RCON Port(s) (comma separated, grid order as in ServerGrid.json, ignore if importing RCON ports) ###", $aServerRCONPort)
	GUICtrlSetState($W2_T3_R_Method1, $GUI_CHECKED)
EndFunc   ;==>GUI_W2_T3_I_RCONPorts
Func GUI_W2_T3_R_Method2()
	; Coming Soon!
EndFunc   ;==>GUI_W2_T3_R_Method2
Func GUI_W2_T3_B_Ports()
	; Coming Soon!
EndFunc   ;==>GUI_W2_T3_B_Ports
; TAB 4 -------------------------
Func GUI_W2_T4_B_Save()
	Local $tTxt = GUICtrlRead($W2_T4_E_GridStart)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
	FileMove($aGridSelectFile, $tFile, 1)
	FileWrite($aGridSelectFile, $tTxt)
	SplashTextOn($aUtilName, $aUtilName & "GridStartSelect.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "GridStartSelect.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
	$aGUI_W2_T4_GridStartClicked = False
EndFunc   ;==>GUI_W2_T4_B_Save
Func GUI_W2_T4_B_Reset()
	Local $tFileOpen = FileOpen($aGridSelectFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($W2_T4_E_GridStart, $tTxt)
EndFunc   ;==>GUI_W2_T4_B_Reset
Func GUI_W2_T4_E_GridStart()
	$aGUI_W2_T4_GridStartClicked = True
EndFunc   ;==>GUI_W2_T4_E_GridStart
; TAB 5 -------------------------
Func GUI_W2_T5_I_AdminPass()
	$aServerAdminPass = GUICtrlRead($W2_T5_I_AdminPass)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Admin password ###", $aServerAdminPass)
EndFunc   ;==>GUI_W2_T5_I_AdminPass
Func GUI_W2_T5_I_MaxPlayers()
	$aServerMaxPlayers = GUICtrlRead($W2_T5_I_MaxPlayers)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Max players ###", $aServerMaxPlayers)
EndFunc   ;==>GUI_W2_T5_I_MaxPlayers
Func GUI_W2_T5_I_ReservedSlots()
	$aServerReservedSlots = GUICtrlRead($W2_T5_I_ReservedSlots)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Reserved slots ###", $aServerReservedSlots)
EndFunc   ;==>GUI_W2_T5_I_ReservedSlots
Func GUI_W2_T5_I_AtlasExtraCMD()
	$aServerExtraCMD = GUICtrlRead($W2_T5_I_AtlasExtraCMD)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " extra commandline parameters (ex.?serverpve-pve -NoCrashDialog) ###", $aServerExtraCMD)
EndFunc   ;==>GUI_W2_T5_I_AtlasExtraCMD
Func GUI_W2_T5_I_SteamCMDExtraCMD()
	$aSteamExtraCMD = GUICtrlRead($W2_T5_I_SteamCMDExtraCMD)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD extra commandline parameters (ex. -latest_experimental) ###", $aSteamExtraCMD)
EndFunc   ;==>GUI_W2_T5_I_SteamCMDExtraCMD
Func GUI_W2_T5_I_UpdateInterval()
	$aUpdateCheckInterval = GUICtrlRead($W2_T5_I_UpdateInterval)
	If $aUpdateCheckInterval < 5 Then $aUpdateCheckInterval = 5
	If $aUpdateCheckInterval > 59 Then $aUpdateCheckInterval = 59
	IniWrite($aIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Update check interval in minutes (05-59) ###", $aUpdateCheckInterval)
EndFunc   ;==>GUI_W2_T5_I_UpdateInterval
; TAB 6 -------------------------
Func GUI_W2_T6_B_Save()
	Local $tTxt = GUICtrlRead($W2_T6_E_Config)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aIniFile & "_" & $tTime & ".bak"
	FileMove($aIniFile, $tFile, 1)
	FileWrite($aIniFile, $tTxt)
	SplashTextOn($aUtilName, $aUtilName & ".ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & ".ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
	$aGUI_W2_T6_ConfigClicked = False
EndFunc   ;==>GUI_W2_T6_B_Save
Func GUI_W2_T6_B_Reset()
	Local $tFileOpen = FileOpen($aIniFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($W2_T6_E_Config, $tTxt)
EndFunc   ;==>GUI_W2_T6_B_Reset
Func GUI_W2_T6_E_Config()
	$aGUI_W2_T6_ConfigClicked = True
EndFunc   ;==>GUI_W2_T6_E_Config
; TAB 7 -------------------------
Func W2_T7_B_ExitRestartY()
	If WinExists($wGUIMainWindow) Then
		GUIDelete($WizardWindowExist)
	Else
		$aExitGUIW2 = True
	EndIf
	If $aSplashStartUp <> 0 Then
		$aSplashStartUp = SplashTextOn($aUtilName, $aStartText & @CRLF & "Setup Wizard Completed.", 475, 110, -1, -1, $DLG_MOVEABLE, "")
		Sleep(1500)
		SplashOff()
	EndIf
	F_ExitCloseN(True)
EndFunc   ;==>W2_T7_B_ExitRestartY
Func W2_T7_B_ExitRestartN()
	If WinExists($wGUIMainWindow) Then
		GUIDelete($WizardWindowExist)
	Else
		$aExitGUIW2 = True
	EndIf
	If $aSplashStartUp <> 0 Then
		$aSplashStartUp = SplashTextOn($aUtilName, $aStartText & @CRLF & "Setup Wizard Completed.", 475, 110, -1, -1, $DLG_MOVEABLE, "")
		Sleep(1500)
		SplashOff()
	EndIf
EndFunc   ;==>W2_T7_B_ExitRestartN

; ------------------------------------------------------------------------------------------------------------
;      Wizard New GUI Window
; ------------------------------------------------------------------------------------------------------------

Func WizardNew()
	SplashOff()
	If WinExists($WizardWindowNew) Then
	Else
		#Region ### START Koda GUI section ### Form=G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Temp Work Files\atladkoda(lwiz-2 new)b1.kxf
		Global $WizardWindowNew = GUICreate("AtlasServerUpdateUtility Setup Wizard", 906, 555, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
		GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_WizardNew_Close", $WizardWindowNew)
		GUISetIcon($aIconFile, 99)
		GUISetBkColor($cW3Background)
		$Group1 = GUICtrlCreateGroup("Install New Atlas Server Wizard", 24, 24, 857, 497)
		$W3_Label1 = GUICtrlCreateLabel("Welcome to the AtlasServerUpdateUtility install Wizard.", 90, 49, 537, 29)
		GUICtrlSetFont(-1, 16, 800, 0, "MS Sans Serif")
		$W3_Label4 = GUICtrlCreateLabel("Step 1", 78, 82, 51, 24)
		GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
		$W3_Label2 = GUICtrlCreateLabel("Please select the Atlas Dedicated Server installation folder: ", 126, 106, 358, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		Global $W3_I_AtlasDIR = GUICtrlCreateInput("D:\Game Servers\" & $aGameName & " Dedicated Server", 126, 130, 569, 21)
		GUICtrlSetOnEvent(-1, "W3_I_AtlasDIR")
		$W3_Label32 = GUICtrlCreateLabel("Install new Atlas server.", 522, 97, 198, 28)
		GUICtrlSetFont(-1, 14, 400, 0, "MS Sans Serif")
		Global $W3_B_SelectFolder = GUICtrlCreateButton("Select Folder", 702, 130, 107, 25)
		GUICtrlSetOnEvent(-1, "W3_B_SelectFolder")
		$W3_Label5 = GUICtrlCreateLabel("Step 2", 78, 162, 51, 24)
		GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
		$W3_Label8 = GUICtrlCreateLabel("SteamCMD extra commandline parameters", 126, 186, 261, 20, $SS_RIGHT)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		Global $W3_I_SteamCMDExtraCMD = GUICtrlCreateInput("", 126, 210, 369, 21)
		GUICtrlSetOnEvent(-1, "W3_I_SteamCMDExtraCMD")
		$W3_Label7 = GUICtrlCreateLabel("Step 3", 78, 242, 51, 24)
		GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
		$W3_Label3 = GUICtrlCreateLabel("Click below to install Atlas Server (using SteamCMD)", 122, 265, 314, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		Global $W3_B_InstallServer = GUICtrlCreateButton("Install Atlas Server", 123, 291, 115, 25)
		GUICtrlSetOnEvent(-1, "W3_B_InstallServer")
		$W3_Label9 = GUICtrlCreateLabel("Step 4", 78, 330, 51, 24)
		GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
		Global $W3_B_Continue = GUICtrlCreateButton("Import Config and Continue", 128, 456, 179, 25)
		GUICtrlSetOnEvent(-1, "W3_B_Continue")
		Global $W3_B_Cancel = GUICtrlCreateButton("Cancel", 784, 472, 75, 25)
		GUICtrlSetOnEvent(-1, "W3_B_Cancel")
		$W3_Label12 = GUICtrlCreateLabel("Copy your Grid files (ServerGrid.json, ServerGrid.ServerOnly.json, and map image files) to", 128, 360, 534, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		Global $W3_Label2 = GUICtrlCreateLabel("D:\Game Servers\" & $aGameName & " Dedicated Server\ShooterGame", 128, 384, 569, 17)
		GUICtrlSetBkColor(-1, 0xC0C0C0)
		$W3_Label11 = GUICtrlCreateLabel("Step 5", 78, 424, 51, 24)
		GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
		$W3_Label1 = GUICtrlCreateLabel("For help creating your map files, visit:", 408, 416, 222, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
		Global $W3_B_GridHelpWebPage = GUICtrlCreateButton("AtlasDSSGuide (Webpage Link)", 632, 408, 187, 25)
		GUICtrlSetOnEvent(-1, "W3_B_GridHelpWebPage")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
		If WinExists($wGUIMainWindow) Then
		Else
			While $aExitGUIW3 = False
				Sleep(100)
			WEnd
			GUIDelete($WizardWindowNew)
			$aExitGUIW3 = False
			If $aWizardSelect = 1 Then WizardExisting(2)
		EndIf
	EndIf
EndFunc   ;==>WizardNew

Func GUI_WizardNew_Close()
	If WinExists($wGUIMainWindow) Then
		GUIDelete($WizardWindowNew)
	Else
		$aExitGUIW3 = True
	EndIf
EndFunc   ;==>GUI_WizardNew_Close
Func W3_I_AtlasDIR()
	$aServerDirLocal = GUICtrlRead($W3_I_AtlasDIR)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " DIR ###", $aServerDirLocal)
	GUICtrlSetData($W3_Label2, $aServerDirLocal & "\ShooterGame")
EndFunc   ;==>W3_I_AtlasDIR
Func W3_B_SelectFolder()
	Local $tCtrlID = $W3_I_AtlasDIR
	Local $tInput = FileSelectFolder("Please select " & $aUtilName & " installation folder", $aServerDirLocal)
	If @error Then
		Local $tRead = GUICtrlRead($tCtrlID)
		GUICtrlSetData($tCtrlID, $tRead)
	Else
		GUICtrlSetData($tCtrlID, $tInput)
	EndIf
	$aServerDirLocal = GUICtrlRead($tCtrlID)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " DIR ###", $aServerDirLocal)
	GUICtrlSetData($W3_Label2, $aServerDirLocal & "\ShooterGame")
EndFunc   ;==>W3_B_SelectFolder
Func W3_I_SteamCMDExtraCMD()
	$aSteamExtraCMD = GUICtrlRead($W3_I_SteamCMDExtraCMD)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD extra commandline parameters (ex. -latest_experimental) ###", $aSteamExtraCMD)
EndFunc   ;==>W3_I_SteamCMDExtraCMD
Func W3_B_InstallServer()
	$tSplash = SplashTextOn($aUtilName, "Downloading and installing " & @CRLF & "SteamCMD and mcrcon.exe (if needed).", 475, 110, -1, -1, $DLG_MOVEABLE, "")
	FileExistsFunc()
	ControlSetText($tSplash, "", "Static1", "Downloading and installing " & @CRLF & $aUtilName & " dedicated server.")
	SteamcmdDelete($aSteamCMDDir)
	SteamInstallGame($tSplash)
;~ 	SteamUpdate($aSteamExtraCMD, $aSteamCMDDir, "yes", $tSplash)
EndFunc   ;==>W3_B_InstallServer
Func W3_B_GridHelpWebPage()
	Run(@ComSpec & " /c " & "start https://krookedskull.com/index.php?title=AtlasDSSGuide#Building_the_Map", "")
EndFunc   ;==>W3_B_GridHelpWebPage
Func W3_B_Continue()
	GUI_WizardNew_Close()
	GUI_W2_T1_B_ImportSettings()
;~ 	$tSplash = SplashTextOn($aUtilName, "Importing settings from " & $aConfigFile & ".", 475, 110, -1, -1, $DLG_MOVEABLE, "")
;~ 	Global $aConfigFull = $aServerDirLocal & "\ShooterGame\" & $aConfigFile
;~ 	Global $aDefaultGame = $aServerDirLocal & "\ShooterGame\Config\DefaultGame.ini"
;~ 	Global $aDefaultGUS = $aServerDirLocal & "\ShooterGame\Config\DefaultGameUserSettings.ini"
;~ 	Global $aDefaultEngine = $aServerDirLocal & "\ShooterGame\Config\DefaultEngine.ini"
;~ 	$aConfigSettingsImported = True
;~ 	ImportConfig($aServerDirLocal, $aConfigFile)
	SplashTextOn($aUtilName, "Creating default GridStartSelect.ini file.", 475, 110, -1, -1, $DLG_MOVEABLE, "")
;~ 	ControlSetText($tSplash, "", "Static1", "Creating default GridStartSelect.ini file.")
	GridStartSelect($aGridSelectFile, $aLogFile, True)
	SplashOff()
	$aWizardSelect = 1
EndFunc   ;==>W3_B_Continue
Func W3_B_Cancel()
	GUI_WizardNew_Close()
EndFunc   ;==>W3_B_Cancel

; ------------------------------------------------------------------------------------------------------------
;      Config GUI Window
; ------------------------------------------------------------------------------------------------------------

Func ConfigEdit($tSplash = 0, $tWarn = False)
	SplashOff()
	If WinExists($ConfigEditWindow) Then
	Else
		#Region ### START Koda GUI section ### Form=g:\game server files\autoit\atlasserverupdateutility\temp work files\atladkoda(configedit)b1.kxf
		Global $ConfigEditWindow = GUICreate($aUtilName & " Config Editor", 1001, 701, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
		GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_ConfigEdit_Close", $ConfigEditWindow)
		GUISetIcon($aIconFile, 99)
		GUISetBkColor($cMWBackground)
		Global $C_IniFailWindow = GUICtrlCreateEdit("", 8, 616, 985, 73, BitOR($ES_AUTOVSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL))
		GUICtrlSetBkColor(-1, $cLWBackground)
		Local $tFile = FileOpen($aIniFailFileBasic)
		Local $tFailFile = FileRead($tFile)
		FileClose($tFile)
		GUICtrlSetData(-1, $tFailFile)
		$Label1 = GUICtrlCreateLabel("Changes:", 8, 592, 69, 20)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		Global $C_B_Save = GUICtrlCreateButton("Save", 8, 8, 75, 25)
		GUICtrlSetOnEvent(-1, "C_B_Save")
		Global $C_B_Reset = GUICtrlCreateButton("Reset", 88, 8, 75, 25)
		GUICtrlSetOnEvent(-1, "C_B_Reset")
		Global $C_B_SaveResetShutDownN = GUICtrlCreateButton("Save and Restart Util (Leave Servers Running)", 208, 8, 299, 25)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetOnEvent(-1, "C_B_SaveResetShutDownN")
		Global $ConifgINIEdit = GUICtrlCreateEdit("", 8, 40, 985, 545)
		GUICtrlSetBkColor(-1, $cFWBackground)
		Local $tFileOpen = FileOpen($aIniFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetData(-1, $tTxt)
		Global $C_B_SaveResetShutDownY = GUICtrlCreateButton("Save and Restart Util (SHUT DOWN Servers)", 512, 8, 243, 25)
		GUICtrlSetOnEvent(-1, "C_B_SaveResetShutDownY")
		If WinExists($wGUIMainWindow) Then
			GUICtrlSetState($C_B_SaveResetShutDownY, $GUI_ENABLE)
		Else
			GUICtrlSetState($C_B_SaveResetShutDownY, $GUI_DISABLE)
		EndIf
		Global $C_B_ContinueNoRestartUtil = GUICtrlCreateButton("Continue WITHOUT Restarting Util", 800, 8, 195, 25)
		GUICtrlSetOnEvent(-1, "C_B_ContinueNoRestartUtil")
		$Label2 = GUICtrlCreateLabel(" NOTICE! Util must be restarted for changes to take effect.", 576, 592, 417, 20, BitOR($SS_CENTER, $WS_BORDER), $WS_EX_STATICEDGE)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		GUICtrlSetBkColor(-1, 0xFFFF00)
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
		If $tWarn Then MsgBox($MB_OK, "New or changed INI Parameters", "INI FILE WAS UPDATED." & @CRLF & "Found " & $iIniFail & " missing or changes variable(s) in " & $aUtilName & ".ini:" & @CRLF & @CRLF & _
				$iIniError & @CRLF & @CRLF & "Please make any required changes.", 5)
		If WinExists($wGUIMainWindow) Then
		Else
			While $aConfigEditWindow = False
				Sleep(100)
			WEnd
			GUIDelete($ConfigEditWindow)
			$aConfigEditWindow = False
			If $tSplash > 0 Then Global $aSplashStartUp = SplashTextOn($aUtilName, $aStartText, 475, 110, -1, -1, $DLG_MOVEABLE, "")
		EndIf
	EndIf
EndFunc   ;==>ConfigEdit

Func GUI_ConfigEdit_Close()
	If WinExists($wGUIMainWindow) Then
		GUIDelete($ConfigEditWindow)
	Else
		$aConfigEditWindow = True
	EndIf
EndFunc   ;==>GUI_ConfigEdit_Close
Func C_B_Save()
	Local $tTxt = GUICtrlRead($ConifgINIEdit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aIniFile & "_" & $tTime & ".bak"
	FileMove($aIniFile, $tFile, 1)
	FileWrite($aIniFile, $tTxt)
	SplashTextOn($aUtilName, $aUtilName & ".ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & ".ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>C_B_Save
Func C_B_Reset()
	Local $tFileOpen = FileOpen($aIniFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($ConifgINIEdit, $tTxt)
EndFunc   ;==>C_B_Reset
Func C_B_SaveResetShutDownN()
	C_B_Save()
	GUI_ConfigEdit_Close()
	F_ExitCloseN(True)
EndFunc   ;==>C_B_SaveResetShutDownN
Func C_B_SaveResetShutDownY()
	C_B_Save()
	GUI_ConfigEdit_Close()
	F_ExitCloseY(True)
EndFunc   ;==>C_B_SaveResetShutDownY
Func C_B_ContinueNoRestartUtil()
	GUI_ConfigEdit_Close()
EndFunc   ;==>C_B_ContinueNoRestartUtil

; ------------------------------------------------------------------------------------------------------------

Func _GetMemArrayRawAvg($pid)
	Local $tMem[UBound($pid)], $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2")
	If @error Then Return 0
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PerfRawData_PerfProc_Process", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) Then
		For $objItem In $colItems
			For $x = 0 To (UBound($pid) - 1)
;~ 				If $pid[$x] = $objItem.IDProcess Then $tMem[$x] = (($objItem.WorkingSetPrivate + $objItem.WorkingSet) / 2) ; Average
				If $pid[$x] = $objItem.IDProcess Then $tMem[$x] = ($objItem.WorkingSetPrivate)     ; Working Set Private
				If @error Then Return 0
			Next
		Next
		Return $tMem
	EndIf
	Return 0
EndFunc   ;==>_GetMemArrayRawAvg

Func _CurrentCPU($init = 0)
	Global $liOldIdleTime = 0
	Global $liOldSystemTime = 0
	Local $SYS_BASIC_INFO = 0
	Local $SYS_PERFORMANCE_INFO = 2
	Local $SYS_TIME_INFO = 3

	$SYSTEM_BASIC_INFORMATION = DllStructCreate("int;uint;uint;uint;uint;uint;uint;ptr;ptr;uint;byte;byte;short")
	$status = DllCall("ntdll.dll", "int", "NtQuerySystemInformation", "int", $SYS_BASIC_INFO, _
			"ptr", DllStructGetPtr($SYSTEM_BASIC_INFORMATION), _
			"int", DllStructGetSize($SYSTEM_BASIC_INFORMATION), _
			"int", 0)

	If $status[0] Then Return -1

	While 1
		$SYSTEM_PERFORMANCE_INFORMATION = DllStructCreate("int64;int[76]")
		$SYSTEM_TIME_INFORMATION = DllStructCreate("int64;int64;int64;uint;int")

		$status = DllCall("ntdll.dll", "int", "NtQuerySystemInformation", "int", $SYS_TIME_INFO, _
				"ptr", DllStructGetPtr($SYSTEM_TIME_INFORMATION), _
				"int", DllStructGetSize($SYSTEM_TIME_INFORMATION), _
				"int", 0)

		If $status[0] Then Return -2

		$status = DllCall("ntdll.dll", "int", "NtQuerySystemInformation", "int", $SYS_PERFORMANCE_INFO, _
				"ptr", DllStructGetPtr($SYSTEM_PERFORMANCE_INFORMATION), _
				"int", DllStructGetSize($SYSTEM_PERFORMANCE_INFORMATION), _
				"int", 0)

		If $status[0] Then Return -3

		If $init = 1 Or $liOldIdleTime = 0 Then
			$liOldIdleTime = DllStructGetData($SYSTEM_PERFORMANCE_INFORMATION, 1)
			$liOldSystemTime = DllStructGetData($SYSTEM_TIME_INFORMATION, 2)
			Sleep(1000)
			If $init = 1 Then Return -99
		Else
			$dbIdleTime = DllStructGetData($SYSTEM_PERFORMANCE_INFORMATION, 1) - $liOldIdleTime
			$dbSystemTime = DllStructGetData($SYSTEM_TIME_INFORMATION, 2) - $liOldSystemTime
			$liOldIdleTime = DllStructGetData($SYSTEM_PERFORMANCE_INFORMATION, 1)
			$liOldSystemTime = DllStructGetData($SYSTEM_TIME_INFORMATION, 2)

			$dbIdleTime = $dbIdleTime / $dbSystemTime

			$dbIdleTime = 100.0 - $dbIdleTime * 100.0 / DllStructGetData($SYSTEM_BASIC_INFORMATION, 11) + 0.5
			Return $dbIdleTime
		EndIf
		$SYSTEM_PERFORMANCE_INFORMATION = 0
		$SYSTEM_TIME_INFORMATION = 0
	WEnd
EndFunc   ;==>_CurrentCPU

#Region ; **** CPU Usage Code Section **** by Ascend4nt.  Visit https://sites.google.com/site/ascend4ntscode/performancecounters-pdh
; ========================================================================================================
; <Process_CPUUsage.au3>
;
; Example of Tracking a Process (or multiple processes) CPU usage.
; The functions maintain a 'Process Usage' object which updates itself and returns CPU usage.
;  Readings are shown in a 'Splash' window
;
; Functions:
;	_CPUGetTotalProcessorTimes()	; Gets Overall (combined CPUs) Processor Times
;	_ProcessUsageTracker_Create()	; Creates a Process CPU usage tracker for the given Process
;	_ProcessUsageTracker_GetUsage()	; Updates Process CPU usage tracker and returns Process % CPU usage
;	_ProcessUsageTracker_Destroy()	; Destroys the Process CPU Usage Tracker
;
; See Also:
;	<CPU_ProcessorUsage.au3>
;	Performance Counters UDF
;
; Author: Ascend4nt
; ========================================================================================================


; ==============================================================================================
; Func _CPUGetTotalProcessorTimes()
;
; Gets the total (combined CPUs) system processor times (as FILETIME)
; Note that Kernel Mode time includes Idle Mode time, so a proper calculation of usage time is
;   Kernel + User - Idle
; And percentage (based on two readings):
;  (Kernel_b - Kernel_a) + (User_b - User_a) - (Idle_b - Idle_a) * 100
;	/ (Kernel_b - Kernal_a) + (User_b - User_a)
;
; O/S Requirements: min. Windows XP SP1+
;
; Returns:
;  Success: Array of info for total (combined CPU's) processor times:
;   [0] = Idle Mode Time
;   [1] = Kernel Mode Time -> NOTE This INCLUDES Idle Time
;   [2] = User Mode Time
;
;  Failure: "" with @error set:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned False - call GetLastError for more info
;
; Author: Ascend4nt
; ==============================================================================================

Func _CPUGetTotalProcessorTimes()
	Local $aRet, $aTimes

	$aRet = DllCall("kernel32.dll", "bool", "GetSystemTimes", "uint64*", 0, "uint64*", 0, "uint64*", 0)
	If @error Then Return SetError(2, @error, "")
	If Not $aRet[0] Then Return SetError(3, 0, "")

	Dim $aTimes[3] = [$aRet[1], $aRet[2], $aRet[3]]

	Return $aTimes
EndFunc   ;==>_CPUGetTotalProcessorTimes


; ==============================================================================================
; Func _ProcessUsageTracker_Destroy(ByRef $aProcUsage)
;
; Destroys a ProcessUsage array object, closing handles first.
;
; In the future, if more than one process is monitored, this shouldn't be called until the
; end, and only individual process elements should be invalidated (and release their handles)
;
; Returns:
;  Success: True
;  Failure: False with @error set to 1 for invalid parameters
;
; Author: Ascend4nt
; ==============================================================================================

Func _ProcessUsageTracker_Destroy(ByRef $aProcUsage)
	If Not IsArray($aProcUsage) Or UBound($aProcUsage) < 2 Then Return SetError(1, 0, False)
	DllCall("kernel32.dll", "bool", "CloseHandle", "handle", $aProcUsage[1][2])
	$aProcUsage = ""
	Return True
EndFunc   ;==>_ProcessUsageTracker_Destroy


; ==============================================================================================
; Func _ProcessUsageTracker_Create($sProcess, $nPID = 0)
;
; Creates a Process CPU usage tracker array (object)
; This array should be passed to _ProcessUsageTracker_GetUsage() to get
; current CPU usage information, and _ProcessUsageTracker_Destroy() to cleanup the resources.
;
; Returns:
;  Success: An array used to track Process CPU usage
;   Array 'internal' format:
;	  $arr[0][0] = # of Processes Being tracked (1 for now, may add to functionality in future)
;	  $arr[0][1] = Total Overall SYSTEM CPU Time (Kernel + User Mode) [updated with _GetUsage() call]
;	  $arr[1][0] = Process 1 Name
;	  $arr[1][1] = Process 1 PID
;	  $arr[1][2] = Process 1 Handle
;	  $arr[1][3] = Process 1 Access Rights (important for Protected Processes)
;	  $arr[1][4] = Process 1 Kernel Mode Time (updated with _GetUsage() call)
;	  $arr[1][5] = Process 1 User Mode Time (updated with _GetUsage() call)
;
;  Failure: "" with @error set [reflects _CPUGetTotalProcessorTimes codes]:
;	 @error =  2: DLLCall error, @extended = error returned from DLLCall
;    @error =  3: API call returned False - call GetLastError for more info
;	 @error = -1: GetProcessTimes error (shouldnt' occur)
;
; Author: Ascend4nt
; ==============================================================================================

Func _ProcessUsageTracker_Create($sProcess, $nPID = 0)
	Local $aRet, $iAccess, $hProcess, $aProcUsage[2][6]

	If Not $nPID Then
		$nPID = ProcessExists($sProcess)
	EndIf

	; XP, XPe, 2000, or 2003? - Affects process access requirement
	If StringRegExp(@OSVersion, "_(XP|200(0|3))") Then
		$iAccess = 0x0400     ; PROCESS_QUERY_INFORMATION
	Else
		$iAccess = 0x1000     ; PROCESS_QUERY_LIMITED_INFORMATION
	EndIf

	; SYNCHRONIZE access - required to determine if process has terminated
	$iAccess += 0x00100000

	$aRet = _CPUGetTotalProcessorTimes()
	If @error Then Return SetError(@error, @extended, "")

	; Total Overall CPU Time
	$aProcUsage[0][1] = $aRet[1] + $aRet[2]

	$hProcess = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", False, "dword", $nPID)
	If @error Then Return SetError(2, @error, "")
	$hProcess = $hProcess[0]

	If $hProcess = 0 Then
		Local $nLastError = DllCall("kernel32.dll", "dword", "GetLastError")
		If @error Then Return SetError(2, @error, "")
		$nLastError = $nLastError[0]

		; ERROR_ACCESS_DENIED?  It must be a Protected process
		If $nLastError = 5 Then
			; Try without SYNCHRONIZE right. - Rely instead on ExitTime & GetExitCodeProcess
			$iAccess -= 0x00100000
			$hProcess = DllCall("kernel32.dll", "handle", "OpenProcess", "dword", $iAccess, "bool", False, "dword", $nPID)
			If @error Then Return SetError(2, @error, False)
			$hProcess = $hProcess[0]
			; Even with LIMITED access rights, some processes still won't open.. (e.g. CTAudSvc.exe)
			If $hProcess = 0 Then Return SetError(3, 0, "")
		Else
			Return SetError(3, $nLastError, "")
		EndIf
	EndIf

	$aProcUsage[0][0] = 1     ; 1 Process Total (possible future expansion)

	$aProcUsage[1][0] = $sProcess     ; Process Name
	$aProcUsage[1][1] = $nPID     ; Process ID
	$aProcUsage[1][2] = $hProcess     ; Process Handle
	$aProcUsage[1][3] = $iAccess     ; Access Rights (useful to determine when process terminated)

	$aRet = DllCall("kernel32.dll", "bool", "GetProcessTimes", "handle", $hProcess, "uint64*", 0, "uint64*", 0, "uint64*", 0, "uint64*", 0)
	If @error Or Not $aRet[0] Then
		Local $iErr = @error
		_ProcessUsageTracker_Destroy($aProcUsage)
		Return SetError(-1, $iErr, "")
	EndIf

	$aProcUsage[1][4] = $aRet[4]     ; Process Kernel Time
	$aProcUsage[1][5] = $aRet[5]     ; Process User Time

	Return $aProcUsage
EndFunc   ;==>_ProcessUsageTracker_Create


; ==============================================================================================
; Func _ProcessUsageTracker_GetUsage(ByRef $aProcUsage)
;
; Updates a ProcessUsage array and returns Process % CPU Usage information
;
; IMPORTANT: If Process is exited, this will return @error code of -1 and destroy the
; Process Usage array object. In the future this may change to just closing the handle
; if more Processes are monitored..
;
; Returns:
;  Success: Process CPU Usage (Percentage)
;  Failure: 0 with @error set to 1 for invalid parameters, or:
;	 @error =  2: DLLCall error, @extended = error returned from DLLCall
;    @error =  3: API call returned False - call GetLastError for more info
;	 @error = -1: Process Exited. The Usage Tracker will be destroyed after this!
;
; Author: Ascend4nt
; ==============================================================================================

Func _ProcessUsageTracker_GetUsage(ByRef $aProcUsage)
	If Not IsArray($aProcUsage) Or UBound($aProcUsage) < 2 Then Return SetError(1, 0, 0)

	Local $fUsage, $nCPUTotal, $aRet

	$aRet = _CPUGetTotalProcessorTimes()
	If @error Then Return SetError(@error, @extended, 0)

	; Total Overall CPU Time (current)
	$nCPUTotal = $aRet[1] + $aRet[2]

	$aRet = DllCall("kernel32.dll", "bool", "GetProcessTimes", "handle", $aProcUsage[1][2], "uint64*", 0, "uint64*", 0, "uint64*", 0, "uint64*", 0)
	If @error Or Not $aRet[0] Then
		Local $iErr = @error
		_ProcessUsageTracker_Destroy($aProcUsage)
		Return SetError(-1, $iErr, 0)
	EndIf

	; ExitTime field set with a time > CreationTime? (typically field is 0 if not exited)
	If $aRet[3] > $aRet[2] Then
		; MSDN says ExitTime is 'undefined' if process hasn't exited, so we do further checking]
		If BitAND($aProcUsage[1][3], 0x00100000) Then
			; See if process has ended (requires SYNCHRONIZE access (0x00100000)
			$aRet = DllCall("kernel32.dll", "dword", "WaitForSingleObject", "handle", $aProcUsage[1][2], "dword", 0)
			If Not @error And $aRet[0] = 0 Then
				_ProcessUsageTracker_Destroy($aProcUsage)
				Return SetError(-1, 0, 0)
			EndIf
		Else
			$aRet = DllCall("kernel32.dll", "bool", "GetExitCodeProcess", "handle", $aProcUsage[1][2], "dword*", 0)
			; Since we couldn't open with SYNCHRONIZE access, checking for no STILL_ACTIVE exit code is the next best thing
			If Not @error And $aRet[0] And $aRet[2] <> 259 Then
				_ProcessUsageTracker_Destroy($aProcUsage)
				Return SetError(-1, 0, 0)
			EndIf
		EndIf
		Return 0
	EndIf

	; Process Usage: (ProcKernelDelta + ProcUserDelta) * 100 / SysTotalDelta:
	$fUsage = Round((($aRet[4] - $aProcUsage[1][4]) + ($aRet[5] - $aProcUsage[1][5])) * 100 / ($nCPUTotal - $aProcUsage[0][1]), 1)

	; Update current usage tracker info
	$aProcUsage[0][1] = $nCPUTotal
	$aProcUsage[1][4] = $aRet[4]
	$aProcUsage[1][5] = $aRet[5]

	Return $fUsage
EndFunc   ;==>_ProcessUsageTracker_GetUsage

; ==============================================================================================
; Func _CPUOverallUsageTracker_Create()
;
; Creates a CPU usage tracker array for Overall combined processors usage.
; This array should be passed to _CPUOverallUsageTracker_GetUsage() to get
; current usage information.
;
; Returns:
;  Success: An array used to track Overall CPU usage
;   Array 'internal' format:
;	  $arr[0] = Total Overall CPU Time (Kernel + User Mode)
;	  $arr[1] = Total Active Overall CPU Time (Kernel + User - Idle)
;
;  Failure: "" with @error set [reflects _CPUGetTotalProcessorTimes codes]:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned False - call GetLastError for more info
;
; Author: Ascend4nt
; ==============================================================================================

Func _CPUOverallUsageTracker_Create()
	Local $aCPUTimes, $aCPUsUsage[2]

	$aCPUTimes = _CPUGetTotalProcessorTimes()
	If @error Then Return SetError(@error, @extended, "")

	; Total
	$aCPUsUsage[0] = $aCPUTimes[1] + $aCPUTimes[2]
	; TotalActive (Kernel Time includes Idle time, so we need to subtract that)
	$aCPUsUsage[1] = $aCPUTimes[1] + $aCPUTimes[2] - $aCPUTimes[0]

	Return $aCPUsUsage
EndFunc   ;==>_CPUOverallUsageTracker_Create


; ==============================================================================================
; Func _CPUOverallUsageTracker_GetUsage(ByRef $aCPUsUsage)
;
; Updates a CPUsUsage array and returns CPU Usage information [Overall processor usage]
;
; Returns:
;  Success: CPU Usage (Percentage)
;  Failure: 0 with @error set to 1 for invalid parameters, or:
;	 @error = 2: DLLCall error, @extended = error returned from DLLCall
;    @error = 3: API call returned False - call GetLastError for more info
;
; Author: Ascend4nt
; ==============================================================================================

Func _CPUOverallUsageTracker_GetUsage(ByRef $aCPUsUsage)
	If Not IsArray($aCPUsUsage) Or UBound($aCPUsUsage) < 2 Then Return SetError(1, 0, "")

	Local $aCPUsCurInfo, $fUsage, $nTotalActive, $nTotal

	$aCPUsCurInfo = _CPUOverallUsageTracker_Create()
	If @error Then Return SetError(@error, @extended, 0)

	$nTotal = $aCPUsCurInfo[0] - $aCPUsUsage[0]
	$nTotalActive = $aCPUsCurInfo[1] - $aCPUsUsage[1]

	; Replace current usage tracker info
	$aCPUsUsage = $aCPUsCurInfo

	Return Round($nTotalActive * 100 / $nTotal, 1)
EndFunc   ;==>_CPUOverallUsageTracker_GetUsage









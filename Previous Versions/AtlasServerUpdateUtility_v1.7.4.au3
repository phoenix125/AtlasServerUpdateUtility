#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\phoenix.ico
#AutoIt3Wrapper_Outfile=Builds\AtlasServerUpdateUtility_v1.7.4.exe
#AutoIt3Wrapper_Outfile_x64=Builds\AtlasServerUpdateUtility_v1.7.4_64-bit(x64).exe
#AutoIt3Wrapper_Compile_Both=y
#AutoIt3Wrapper_UseX64=y
#AutoIt3Wrapper_Res_Comment=By Phoenix125 based on Dateranoth's ConanServerUtility v3.3.0-Beta.3
#AutoIt3Wrapper_Res_Description=Atlas Dedicated Server Update Utility
#AutoIt3Wrapper_Res_Fileversion=1.7.4.0
#AutoIt3Wrapper_Res_ProductName=AtlasServerUpdateUtility
#AutoIt3Wrapper_Res_ProductVersion=v1.7.4
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
#AutoIt3Wrapper_Res_Icon_Add=Resources\refreshnotice.ico
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_AU3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/mo
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;**** Directives created by AutoIt3Wrapper_GUI ****

;AutoIT Native
#include <Array.au3>
#include <AutoItConstants.au3>
#include <ButtonConstants.au3>
#include <ColorConstants.au3>
#include <Date.au3>
#include <EditConstants.au3>
#include <File.au3>
#include <GDIPlus.au3>
#include <GuiConstants.au3>
#include <GUIImageList.au3>
#include <GuiListBox.au3>
#include <GuiListView.au3>
#include <GuiEdit.au3>
#include <GuiTab.au3>
#include <GuiRichEdit.au3>
;~ #include <GuiStatusBar.au3>
;~ #include "GUIListViewEx.au3" ; EXTERNAL : GUIListViewEX
#include <IE.au3>
#include <Inet.au3>
#include <ListViewConstants.au3>
#include <Misc.au3>
#include <MsgBoxConstants.au3>
#include <Process.au3>
#include <ScrollBarsConstants.au3>
#include <SliderConstants.au3>
#include <StringConstants.au3>
#include <String.au3>
#include <StaticConstants.au3>
#include <TrayConstants.au3>; Required For the $TRAY_ICONSTATE_SHOW constant.
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <WinAPISys.au3>

_GUIListViewEx_Globals()
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

$aUtilVerStable = "v1.7.4" ; (2019-06-12)
$aUtilVerBeta = "v1.7.4" ; (2019-06-12)
Global $aUtilVerNumber = 14 ; New number assigned for each config file change. Used to write temp update script so that users are not forced to update config.
; 0 = v1.5.0(beta19/20)
; 1 = v1.5.0(beta21/22/23)
; 2 = v1.5.0(beta24)
; 3 = v1.5.0/1/2
; 4 = v1.5.3/4
; 5 = v1.5.5
; 6 = v1.5.6/7
; 7 = v1.6.0(b1)/v1.6.0
; 8 = v1.6.1/2/3
; 9 = v1.6.4/5/6
;10 = v1.6.7
;11 = v1.6.8
;12 = v1.6.9/1.7.0
;13 = v1.7.1
;14 = v1.7.2/3/4

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
	LogWrite(" [" & $aObjErrFunc & "] Error in ObjEvent:0x" & Hex($oError.number) & " Description:" & $oError.description, " [" & $aObjErrFunc & "] " & $tErr)
EndFunc   ;==>_ErrFunc

Global $aSteamAppID = "1006030"
Global $aSteamDBURLPublic = "https://steamdb.info/app/" & $aSteamAppID & "/depots/?branch=public"
Global $aSteamDBURLExperimental = "https://steamdb.info/app/" & $aSteamAppID & "/depots/?branch=public"
Global $aRCONBroadcastCMD = "broadcast"
Global $aRCONSaveGameCMD = "saveworld"
Global $aRCONShutdownCMD = "DoExit"
Global $aServerWorldFriendlyName = "temp"
Global $aModAppWorkshop = "appworkshop_834910.acf"
Global $aRebootReason = ""
Global $xCustomRCONRebootNumber = -1 ; Determines which Custom Schedule number requested the server reboot.
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
Global $aEventSaveFile = @ScriptDir & "\_EVENT_SCHEDULE_.txt"
Global $aUtilUpdateFile = @ScriptDir & "\__UTIL_UPDATE_AVAILABLE___.txt"
Global $aDiscordSendWebhookEXE = @ScriptDir & "\DiscordSendWebhook.exe"
Global $aUseKeepAliveYN = "yes"
Local $aKeepAliveFileVersion = "v1.4"
Global $aKeepAliveConfigFileName = $aUtilName & "KeepAlive.ini"
Global $aKeepAliveConfigFileFull = @ScriptDir & "\" & $aKeepAliveConfigFileName
Global $aKeepAliveFileName = $aUtilName & "KeepAlive_" & $aKeepAliveFileVersion
Global $aKeepAliveFileExe = $aUtilName & "KeepAlive_" & $aKeepAliveFileVersion & ".exe"
Global $aKeepAliveFileZip = $aUtilName & "KeepAlive_" & $aKeepAliveFileVersion & ".zip"
Global $aFirstModBoot = True
Global $iIniErrorCRLF = ""
Global $aModMsgInGame[10]
Global $aModMsgDiscord[10]
Global $aModMsgTwitch[10]
Global $aFirstBoot = True
Local $aFirstStartDiscordAnnounce = True
Global $aShowUpdate = False
Global $aConfigFolder = @ScriptDir & "\Config"
Global $aIniFile = $aConfigFolder & "\" & $aUtilName & ".ini"
Global $aGridSelectFile = $aConfigFolder & "\" & $aUtilName & "GridStartSelect.ini"
Global $aPIDRedisFile = $aFolderTemp & $aUtilName & "_lastpidredis.tmp"
Global $aPIDServerFile = $aFolderTemp & $aUtilName & "_lastpidserver.tmp"
Global $aUtilCFGFile = $aFolderTemp & $aUtilName & "_cfg.ini"
Global $aFolderLog = @ScriptDir & "\_Log\"
Global $aSteamCMDDir = @ScriptDir & "\SteamCMD"
Global $aExportDataFolder = @ScriptDir & "\ExportData"
Global $aExportMainGUIGridFile = $aExportDataFolder & "\MainGUIData.txt"
Global $aOnlinePlayerWebFile = $aExportDataFolder & "\OnlineUsers.txt"
Global $aBatFolder = @ScriptDir & "\Batch Files (to run " & $aGameName & " manually)"
Global $aBatUpdateGame = "Update" & $aGameName & ".bat"
Global $aPIDServerReadYetTF = False
Global $aPIDRedisreadYetTF = False
Global $aServerUseRedis = "yes"
Global $aCloseServerTF = False
Global $aSteamUpdateNow = False
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
Global $tUtilUpdateAvailableTF = False ; Indicates whether a there is a new util update is available
Global $IconReady = 0 ; To prevent undeclared variable
Global $aSelectServers = False ; To prevent undeclared variable
Global $tSelectServersTxt = "" ; To prevent undeclared variable
Global $aExitGUIW2 = False ; Needed to exit Setup Wizard Existing Server GUI due to OnEventMode = 1
Global $aExitGUIW1 = False ; Needed to exit Setup Wizard Select GUI due to OnEventMode = 1
Global $aExitGUIW3 = False ; Needed to exit Setup Wizard New Server GUI due to OnEventMode = 1
Global $aExitGUIT1 = False ; Needed to exit Tools GUI due to OnEventMode = 1
Global $aExitGUISF1 = False ; Needed to exit SelecrFolder1 GUI due to OnEventMode = 1
Global $wSelectFolder = 99999 ; Predeclare GUI variable for Select Folder 1 window ControlID
Global $aWizardSelect = 99999 ; Predeclare GUI variable for Wizard Select window ControlID
Global $ConfigEditWindow = 99999 ; Predeclare GUI variable for Config Editor window ControlID
Global $wGridConfig = 99999, $wToolsWindow = 99999
Global $aGUITools = 99999 ; Predeclare GUI variable for Tools window ControlID
Global $aConfigEditWindow = False ; Needed to exit Config Edit due to OnEventMode = 1
Global $LogWindow = 99999 ; Predeclare GUI variable for Log Window ControlID
Global $MainWindow = -1, $gOnlinePlayerWindow = 99999, $wGUIMainWindow = -1 ; Predeclare GUI variables with dummy values to prevent firing the Case statements
Global $WizardWindowNew = 99999, $WizardWindowExist = 99999, $WizardWindowSelect = 99999
Global $aCPUOverallTracker, $fPercent
Global $aCPUOverallTracker = _CPUOverallUsageTracker_Create()
Global $aConfigSettingsImported = False ; Indicates whether the ServerGrid.json file has been imported or not.
Global $iIniRead = False ; Indicators whether the Ini File has been imported or not.
Global $aPIDKeepAlive = 0
Global $aUtilityVer = 0, $aRemoteRestartIP = 0, $aRemoteRestartPort = 0, $aRemoteRestartUse = 0 ; Default perameters to avoid errors when util crashes.

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
Global $xGridStartDelay[$aServersMax]
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

#OnAutoItStartRegister "OnAutoItStart" ; _RestartUtil()
Global $__Restart = False ; _RestartUtil()

;Global $cSWRunning = "0x0b6623"		; Color SW Server Window Running Text
;Global $cSWRunning = "0x39ff14"		; Color SW Server Window Running Text
;Global $cSWRunning = "0x00a86b" ; Color SW Server Window Running Text
Global $cSWRunning = "0x388E3C" ; Color SW Server Window Running Text
Global $cSWOffline = "0xE65100" ; Color SW Server Window Offline Text
Global $cSWDisabled = "0x666666" ; Color SW Server Window Disabled Text
Global $cSWCrashed = "0xc40233" ; Color SW Server Window Crashed Text
Global $cSWStarting = "0x0c62ef" ; Color SW Server Window Crashed Text
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
Global $cT1Background = "0x979A9A"
Global $cGGridButtonActive = "0xFFFF00"
Global $cGGridButtonInactive = "0xD7DBDD"
Global $cGGridSaveButtonActive = "0xFEAF69"

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

Global $aLogFile = $aFolderLog & $aUtilName & "_Log_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
Global $aLogDebugFile = $aFolderLog & $aUtilName & "_LogFull_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
Global $aOnlinePlayerFile = $aFolderLog & $aUtilName & "_OnlineUserLog_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
Global $aTimeCheck0 = _NowCalc() ; Upodate Check
Global $aTimeCheck1 = _NowCalc() ; Not Used
Global $aTimeCheck2 = _NowCalc() ; Daily Restart Server
Global $aTimeCheck3 = _NowCalc() ; Not Used
Global $aTimeCheck4 = _NowCalc() ; Backup Scheduler
Global $aTimeCheck5 = _NowCalc() ; Check for RCON custom commands scheduler every minute timer
Global $aTimeCheck6 = _NowCalc() ; Online Player check when server start.
Global $aTimeCheck7 = _NowCalc() ; Destroy Wild Dinos
Global $aTimeCheck8 = _NowCalc() ; Online Players count check
$aBeginDelayedShutdown = 0
Global $aUpdateVerify = "no"
$aFailCount = 0
$aShutdown = 0
$aAnnounceCount1 = 0
$aErrorShutdown = 0
Global $aIniForceWrite = False ; Forces a rewrite of the config.ini file : used after auto-updating config with util updates

#EndRegion ;**** Global Variables ****
;~ #cs
; Error handling for Discord announcements ; https://www.autoitscript.com/forum/topic/196243-winhttpwinhttprequest51-certificate-error/
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
;~ #ce
Opt("GUIOnEventMode", 1)
; -----------------------------------------------------------------------------------------------------------------------
#Region ;**** Startup Checks. Initial Log, Read INI, Check for Correct Paths, Check Remote Restart is bound to port. ****
OnAutoItExitRegister("Gamercide")
Global $aCFGLastVerNumber = IniRead($aUtilCFGFile, "CFG", "aCFGLastVerNumber", 0)
If $aCFGLastVerNumber < 12 Then
	Local $xUtilBetaYN = IniRead(@ScriptDir & "\AtlasServerUpdateUtility.ini", " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", $aUtilName & " version: (0)Stable, (1)Beta ###", 0)
Else
	Local $xUtilBetaYN = IniRead($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", $aUtilName & " version: (0)Stable, (1)Beta ###", 0)
EndIf

Local $xUtilBetaYN = IniRead($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", $aUtilName & " version: (0)Stable, (1)Beta ###", 0)
If $xUtilBetaYN = "1" Then
	Global $aUtilVersion = $aUtilVerBeta
Else
	Global $aUtilVersion = $aUtilVerStable
EndIf
Global $aUtilityVer = $aUtilName & " " & $aUtilVersion
If FileExists($aFolderTemp) = 0 Then DirCreate($aFolderTemp)
If FileExists($aFolderLog) = 0 Then DirCreate($aFolderLog)
If FileExists($aExportDataFolder) = 0 Then DirCreate($aExportDataFolder)
If FileExists($aConfigFolder) = 0 Then DirCreate($aConfigFolder)
LogWrite(" ============================ " & $aUtilName & " " & $aUtilVersion & " Started ============================")
If FileExists($aIniFile) Then _FileWriteToLine($aIniFile, 3, "Version  :  " & $aUtilityVer, True)
Global $aStartText = $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF
Global $aSplashStartUp = _Splash($aStartText, 0, 475)
FileDelete($aServerBatchFile)
FileWrite($aServerBatchFile, "@echo off" & @CRLF & "START """ & $aUtilName & """ """ & @ScriptDir & "\" & $aUtilName & "_" & $aUtilVersion & ".exe""" & @CRLF & "EXIT")
If $aUseKeepAliveYN = "yes" Then
	IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "Program to Keep Alive ###", $aUtilName & "_" & $aUtilVersion & ".exe")
	IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "Program to run ###", @ScriptDir & "\" & $aUtilName & "_" & $aUtilVersion & ".exe")
	IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "System use: Close AtlasServerUpdateUtilityKeepAlive? (Checked prior to restarting above Program... used when purposely shutting down above Program)(yes/no) ###", "no")
	If @Compiled = 1 Then
		IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "System use: Is program compiled? (yes/no) ###", "yes")
	Else
		IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "System use: Is program compiled? (yes/no) ###", "no")
		IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "Program to run ###", @AutoItExe & ' "' & @ScriptFullPath & '" ' & $CmdLineRaw)
	EndIf
	KeepUtilAliveCounter()
	AdlibRegister("KeepUtilAliveCounter", 60000)
EndIf

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
	IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND 1 --------------- ", "1-RCON Command(s) to send (Separated by ~, leave BLANK to skip) ###", "")
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
If $aCFGLastVerNumber < 6 Then
	Local $tServerAltSaveSelect = IniRead($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", "2")
	IniWrite($aIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement grid naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###", "2")
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Grid naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###", $tServerAltSaveSelect)
	$aIniForceWrite = True
EndIf
If ($aCFGLastVerNumber < 7) And ($xUtilBetaYN = 1) Then
	IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Run KeepAlive program to detect util crashes and restart it? (yes/no) ###", "yes")
	$aIniForceWrite = True
EndIf
If $aCFGLastVerNumber < 8 Then
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Max time (minutes) to wait for each mod to download (0-180) (0-No Timeout) ###", 10)
	$aIniForceWrite = True
EndIf
If $aCFGLastVerNumber < 9 Then
	$aEventCount = IniRead($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND COUNT --------------- ", "Number of custom RCON Commands to schedule (If changed, util will restart and new custom entries will be added) ###", "")
	Global $xCustomRCONCmd[$aEventCount], $xEventDays[$aEventCount]
	For $i = 0 To ($aEventCount - 1)
		$xCustomRCONCmd[$i] = IniRead($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command to send (leave BLANK to skip) ###", "")
		$xEventDays[$i] = IniRead($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", "")
		$sInGameAnnounce = IniRead($aIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires telnet) (yes/no) ###", "")
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Event Name ###", "Event " & ($i + 1))
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event Months (comma separated 0-Monthly, 1-12) ###", "0")
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event Days of Month (comma separated 0-Use Weekday Below, 1-31) ###", "0")
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command(s) to send (Separated by ~, leave BLANK to skip) ###", $xCustomRCONCmd[$i])
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event Weekdays (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $xEventDays[$i])
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Restart servers afterward? (with announcements below) (yes/no) ###", "no")
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Announcement _ minutes before reboot (comma separated 1-60) ###", "")
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-In-Game Message to send (\m - minutes)(leave BLANK to skip) ###", "")
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Discord Message to send (\m - minutes)(leave BLANK to skip) ###", "")
		IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Twitch Message to send (\m - minutes)(leave BLANK to skip) ###", "")
		IniWrite($aIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires RCON) (yes/no) ###", $sInGameAnnounce)
		IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " ADVANCED OPTIONS --------------- ", "Time to wait for RCON response in milliseconds (100-3000) ###", 1500)
		IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " ADVANCED OPTIONS --------------- ", "Time to wait for Online Players RCON response in milliseconds (100-3000) ###", 1500)
	Next
	$aIniForceWrite = True
EndIf
If $aCFGLastVerNumber < 10 Then
	IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " ADVANCED OPTIONS --------------- ", "Update the Main Window data every __ seconds (2-60) ###", 10)
	IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "System use: Close AtlasServerUpdateUtilityKeepAlive? (Checked prior to restarting above Program... used when purposely shutting down above Program)(yes/no) ###", "yes")
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Shutting down AtlasServerUpdateUtilityKeepAlive (if running) for update.")
	Sleep(5000)
	$aIniForceWrite = True
EndIf
If $aCFGLastVerNumber < 11 Then
	IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "System use: Max hang time before restarting program? (90-600) ###", 180)
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Use scheduled backups? (yes/no) ###", "yes")
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Backup days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", 0)
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Backup hours (comma separated 00-23 ex.04,16) ###", "06,12,18,00")
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Backup minute (00-59) ###", "00")
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Output folder ###", @ScriptDir & "\Backups")
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Number of backups to keep (1-999) ###", 56)
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Max time in seconds to wait for backup to complete (30-999) ###", 300)
	$aIniForceWrite = True
EndIf
If $aCFGLastVerNumber < 12 Then
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Redis folder (leave blank to use redis folder above or to disable) ###", "")
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "In-Game announcement when backup initiated (Leave blank to disable) ###", "Server backup in progress.")
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Discord announcement when backup initiated (Leave blank to disable) ###", "")
	IniWrite($aIniFile, " --------------- BACKUP --------------- ", "Twitch announcement when backup initiated (Leave blank to disable) ###", "")
	IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Folder to place config files ###", @ScriptDir & "\Config")
	DirCreate(@ScriptDir & "\Config")
	FileMove(@ScriptDir & "\AtlasServerUpdateUtility.ini", @ScriptDir & "\Config\AtlasServerUpdateUtility.ini", 1)
	FileMove(@ScriptDir & "\AtlasServerUpdateUtilityGridStartSelect.ini", @ScriptDir & "\Config\AtlasServerUpdateUtilityGridStartSelect.ini", 1)
	FileMove(@ScriptDir & "\*.bak", @ScriptDir & "\Config\*.*", 1)
	$aIniForceWrite = True
EndIf
If $aCFGLastVerNumber < 13 Then
	IniWrite($aIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos minute (0-59) ###", "00")
	$aIniForceWrite = True
EndIf
If $aCFGLastVerNumber < 14 Then
	IniWrite($aIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Approximate duration to display messages in-game (seconds)? (6-30) ###", "15")
	$aIniForceWrite = True
EndIf
;~ Global $aIniFile = IniRead($aUtilCFGFile, "CFG", "aIniFile", "error")
;~ If $aIniFile = "error" Then
;~ 	$aIniFile = @ScriptDir & "\Config\" & $aUtilName & ".ini"
;~ Else
;~ 	Global $aConfigFolder = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Folder to place config files ###", $iniCheck)
;~ 	If FileExists($aConfigFolder & "\" & $aUtilName & ".ini" Then
;~ 		If $aIniFile <> $aConfigFolder & "\" & $aUtilName & ".ini" Then
;~ 	Else
;~ 			SplashOff()
;~ 			$aIniFile = FileSelectFolder("Error! " & $aUtilName & ".ini not found at:" & @CRLF & $aIniFile & @CRLF & @CRLF & _
;~ 			"Please select location for " & $aUtilName & ".ini", 1 + 4, @ScriptDir)
;~ 			$aSplashStartUp = _Splash($aStartText, 0, 475)
;~ 		EndIf
;~ 	EndIf
;~ EndIf

; ----------- END Temporary until enough time has passed for most users to have updated

;~ Local $tPID = WinGetProcess("[CLASS:AutoIt v3 GUI]", "AtlasServerUpdateUtility v")
Local $tPID = WinGetProcess("AtlasServerUpdateUtility v")
If $tPID > 0 Then
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Another instance of Util PID[" & $tPID & "] is running." & @CRLF & "Waiting 5 seconds for it to close.")
	Sleep(5000)
;~ 	Local $tPID = WinGetProcess("[CLASS:AutoIt v3 GUI]", "AtlasServerUpdateUtility v")
	Local $tPID = WinGetProcess("AtlasServerUpdateUtility v")
	If $tPID > 0 Then
		SplashOff()
		LogWrite(" [Util] Another instance of " & $aUtilName & " PID[" & $tPID & "] is already running.")
		Local $aMsg = "Another instance of " & $aUtilName & " PID[" & $tPID & "] is already running." & @CRLF & @CRLF & _
				"Click (YES) to CLOSE the OTHER instance and continue running this one." & @CRLF & _
				"Click (NO) to continue running this instance." & @CRLF & _
				"Click (CANCEL) to exit utility."
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 30)
		; ----------------------------------------------------------
		If $tMB = 6 Then ; YES
			LogWrite(" [Util] Closing the other instance and continue running this one.")
			ProcessClose($tPID)
			$aSplashStartUp = _Splash("Closing the other instance and continue running this one.", 2000)
;~ 			IniWrite(@ScriptDir & "\AtlasServerUpdateUtilityKeepAlive.ini", " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "Program to Keep Alive ###", $aUtilName & "_" & $aUtilVersion & ".exe")
			If $aUseKeepAliveYN = "yes" Then IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "System use: Close AtlasServerUpdateUtilityKeepAlive? (Checked prior to restarting above Program... used when purposely shutting down above Program)(yes/no) ###", "no")
		ElseIf $tMB = 7 Then ; NO
			LogWrite(" [Util] Continuing to run this instance.")
			$aSplashStartUp = _Splash("Continuing to run this instance.", 2000)
		ElseIf $tMB = 2 Then ; CANCEL
			LogWrite(" [Util] Exiting utility.")
			_Splash($aUtilName & " exiting.", 2000)
			Exit
		EndIf
	EndIf
EndIf
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from " & $aUtilName & ".ini.")
Local $tRunConfig = IniRead($aUtilCFGFile, "CFG", "aCFGRCONCustomShowConfig", "no")
Local $aRunWizard = ReadUini($aIniFile, $aLogFile)
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

If $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) And $aUpdateUtil > 0 Then
	UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName, $aSplashStartUp, "show")
	If $tUtilUpdateAvailableTF Then $aSplashStartUp = _Splash($aStartText, 0, 475)
Else
	UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName, 0, "skip")
EndIf
;~ EndIf

; Atlas
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from " & $aConfigFile & ".")
ImportConfig($aServerDirLocal, $aConfigFile)
;~ IniWrite($aUtilCFGFile, "CFG", "aIniFile", $aConfigFolder)

;If $aServerRCONImport = "yes" Then
;	$aServerRCONPort=ImportRCON($aServerDirLocal, $xServerAltSaveDir, $aServerGridTotal)
;EndIf
$aTelnetPass = $aServerAdminPass

If $aServerAltSaveSelect = "3" Then
	Global $xServerAltSaveDir = StringSplit($aServerAltSaveDir, ",", 2)
;~ 	If
ElseIf $aServerAltSaveSelect = "2" Then
	Global $xServerAltSaveDir[$aServerGridTotal]
	For $i = 0 To ($aServerGridTotal - 1)
		$xServerAltSaveDir[$i] = Chr(Int($xServergridx[$i]) + 65) & (Int($xServergridy[$i]) + 1)
	Next
Else
	Global $xServerAltSaveDir[$aServerGridTotal]
	For $i = 0 To ($aServerGridTotal - 1)
		$xServerAltSaveDir[$i] = $xServergridx[$i] & $xServergridy[$i]
	Next
EndIf
If $aCFGLastVerNumber < 8 Then
	For $i = 0 To ($aServerGridTotal - 1)
		IniWrite($aGridSelectFile, " --------------- ADDITIONAL STARTUP DELAY (in seconds) --------------- ", "Additional startup delay Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (0-600)", 0)
	Next
EndIf

ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from GridStartSelect.ini")
GridStartSelect($aGridSelectFile, $aLogFile)

If ($aCFGLastVerNumber = 6) Or ($aCFGLastVerNumber = 7) Then
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
	FileMove($aGridSelectFile, $tFile, 1)
	UpdateGridSelectINI($aGridSelectFile)
EndIf

If $aServerUseRedis = "yes" Then
	$aServerPIDRedis = PIDReadRedis($aPIDRedisFile, $aSplashStartUp)
Else
	$aServerPIDRedis = ""
EndIf
$aServerPID = PIDReadServer($aPIDServerFile, $aSplashStartUp)
Global $aServerPlayers[$aServerGridTotal]
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Preparing server startup scripts.")

If ($aServerRCONImport = "yes") Then
	$xServerRCONPort = ImportRCON($aServerDirLocal, $xServerAltSaveDir, $aServerGridTotal, $xLocalGrid)
;~ 	$xServerRCONPort = ImportRCON($aServerDirLocal, $xServerAltSaveDir, $aServerGridTotal, $xStartGrid)
EndIf

If ($sInGameAnnounce = "yes") Or ($aTelnetCheckYN = "yes") Or ($aEnableRCON = "yes") And ($aServerWorldFriendlyName <> "TempXY") Then ; "TempXY" indicates temp settings set to complete a fresh install of Atlas files.
	If $aServerGridTotal <> (UBound($xServerRCONPort) - 1) Then
		SplashOff()
		Local $aErrorMsg = " [CRITICAL ERROR!] The number of grids does not match the number of RCON ports listed in " & $aUtilName & ".ini." & @CRLF & "Grid Total:" & $aServerGridTotal & ". Number of RCON entries:" & (UBound($xServerRCONPort) - 1) & @CRLF & "Example: Server RCON Port(s) (comma separated, grid order left-to-right ) ###: 57510,57512,57514,57516" & @CRLF & @CRLF & "Please correct the RCON entries in " & $aUtilName & ".ini file and restart " & $aUtilName & "."
		LogWrite($aErrorMsg)
		MsgBox($MB_OK, $aUtilityVer, $aErrorMsg)
		_ExitUtil()
	EndIf
EndIf

If $aServerGridTotal <> UBound($xServerAltSaveDir) And ($aServerWorldFriendlyName <> "TempXY") Then
	SplashOff()
	Local $aErrorMsg = " [CRITICAL ERROR!] The number of grids does not match the number of AltSaveDirectoryNames listed in " & $aUtilName & ".ini." & @CRLF & "Grid Total:" & $aServerGridTotal & ". Number of Server AltSaveDirectoryName entries:" & (UBound($xServerAltSaveDir)) & @CRLF & "Example: Server AltSaveDirectoryName(s) (comma separated. Leave blank for default a00 a01 a10, etc) ###" & @CRLF & @CRLF & "Please correct the AltSaveDirectoryName entries in " & $aUtilName & ".ini file and restart " & $aUtilName & "."
	LogWrite($aErrorMsg)
	MsgBox($MB_OK, $aUtilityVer, $aErrorMsg)
	_ExitUtil()
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

If $aServerModYN = "yes" Then
	$aServerModCMD = " -manualmanagedmods"
	Local $aMods = StringSplit($aServerModList, ",")
	Global $aModName[$aMods[0] + 1]
	If $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) Then ; $aUtilReboot = A planned reboot of the util... no need to check for updates.
;~ 		$aFirstModCheck = True
		CheckMod($aServerModList, $aSteamCMDDir, $aServerDirLocal, $aSplashStartUp, True)
	EndIf
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
		LogWrite("", " Imported from " & $aConfigFile & ": Server " & _ServerNamingScheme($i, $aNamingScheme) & " Port:" & $xServergameport[$i] & " GamePort:" & $xServerport[$i] & " SeamlessIP:" & $xServerIP[$i] & " RCONPort:" & $xServerRCONPort[$i + 1] & " Folder:" & $xServerAltSaveDir[$i])
	EndIf
Next

; Generic (Not speciifc to Atlas)
;$aSteamCMDDir = $aServerDirLocal & "\SteamCMD"
Global $aSteamAppFile = $aServerDirLocal & "\steamapps\appmanifest_" & $aSteamAppID & ".acf"

If $aUtilReboot = "no" Then
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Checking for existance of external files.")
	FileExistsFunc($aSplashStartUp)
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Checking for existance of external scripts (if enabled).")
EndIf
ExternalScriptExist()
If $aUseKeepAliveYN = "yes" Then
	_DownloadAndExtractFile($aKeepAliveFileName, "http://www.phoenix125.com/share/atlas/" & $aKeepAliveFileZip, "https://github.com/phoenix125/AtlasServerUpdateUtilityKeepAlive/releases/download/LatestVersion/" & $aKeepAliveFileZip, $aSplashStartUp)
	$aPIDKeepAlive = IniRead($aUtilCFGFile, "CFG", "aKeepAlivePID", 99999)
	If Not ProcessExists($aPIDKeepAlive) Then
		$aPIDKeepAlive = WinGetProcess("[CLASS:AutoIt v3 GUI]", "AtlasServerUpdateUtilityKeepAlive")
		If $aPIDKeepAlive < 1 Then $aPIDKeepAlive = Run(@ScriptDir & "\" & $aKeepAliveFileExe)
		IniWrite($aUtilCFGFile, "CFG", "aKeepAlivePID", $aPIDKeepAlive)
	EndIf
EndIf

If $aRemoteRestartUse = "yes" Then
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Initializing Remote Restart.")
	TCPStartup()
	Local $aRemoteRestartSocket = TCPListen($aRemoteRestartIP, $aRemoteRestartPort, 100)
	If $aRemoteRestartSocket = -1 Then
		SplashOff()
;~ 		MsgBox($MB_OK, "TCP Error", "Could not bind to [" & $aRemoteRestartIP & "] Check server IP, disable Remote Restart in INI, or check for multiple instances of this util using the same port." & @CRLF & @CRLF & _
;~ 				"Remote Restart will likely not function. Click (OK) to continue", 15)
;~ 		LogWrite(" [Remote Restart] Remote Restart enabled. Could not bind to " & $aRemoteRestartIP & ":" & $aRemoteRestartPort)
;~ 		TCPShutdown()
		FileDelete($aFolderTemp & "pid.txt")
		Local $tCMD = @ComSpec & " /c netstat -a -n -o >> """ & $aFolderTemp & "pid.txt"""
		Local $mOut = Run($tCMD, $aFolderTemp, @SW_HIDE)
		$tErr = ProcessWaitClose($mOut, 1)
		If $tErr = 0 Then
			$aPIDError = True
		Else
			$tFile = FileOpen($aFolderTemp & "pid.txt")
			$tRead = FileRead($tFile)
			FileClose($tFile)
			$tTxt1 = _StringBetween($tRead, $aRemoteRestartPort, "CP")
			If $tTxt1 = "" Then
			Else
				$tTxt = _StringBetween($tTxt1[0], "LISTENING", "T")
				$tPID = StringRegExp($tTxt[0], '\d+', 1)
				If @error Then
				Else
					Local $tProgPID = _ProcessGetName($tPID[0])
					Local $aMsg = "Could not bind to [" & $aRemoteRestartIP & "] Check server IP, disable Remote Restart in INI, or check for multiple instances of this util using the same port." & @CRLF & @CRLF & _
							"The Remote Restart port is being used by" & @CRLF & _
							"Program:" & $tProgPID & @CRLF & _
							"PID:" & $tPID[0] & @CRLF & "Port:" & $aRemoteRestartPort & @CRLF & @CRLF & _
							"Click (YES) to close the above program and restart Remote Restart." & @CRLF & _
							"Click (NO) to continue (Remote Restart will likely not function.)" & @CRLF & _
							"Click (CANCEL) to exit utility."
					SplashOff()
					$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 30)
					; ----------------------------------------------------------
					If $tMB = 6 Then ; YES
						LogWrite(" [Remote Restart] Program(" & $tProgPID & "), PID(" & $tPID[0] & ") terminated. Remote Restart initialized.")
						ProcessClose($tPID[0])
						Local $aRemoteRestartSocket = TCPListen($aRemoteRestartIP, $aRemoteRestartPort, 100)
						_Splash($aStartText & "Program terminated." & @CRLF & "Initializing Remote Restart.", 2000, 475)
						$aSplashStartUp = _Splash($aStartText & "Program terminated." & @CRLF & "Initializing Remote Restart.", 0, 475)
					ElseIf $tMB = 7 Then ; NO
						$aSplashStartUp = _Splash($aStartText & "Continuing startup.", 0, 475)
					ElseIf $tMB = 2 Then ; CANCEL
						_Splash($aUtilName & " exiting.", 2000)
						_ExitUtil()
					ElseIf $tMB = -1 Then ; Timeout
						$aSplashStartUp = _Splash($aStartText & "No response. Continuing startup.", 0, 475)
					EndIf
				EndIf
			EndIf
		EndIf
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

If $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) Or $aExternalScriptValidateYN = "yes" Or $aExecuteExternalScript = "yes" Then
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

ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Scanning for running servers.")
If Not ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
	$aBeginDelayedShutdown = 0
	$aServerPIDRedis = ""
	If $aServerMinimizedYN = "no" Then
		If $aServerRedisFolder = "" Then
			$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir)
		Else
			$aServerPIDRedis = Run($xServerRedis, $aServerRedisFolder)
		EndIf
	Else
		If $aServerRedisFolder = "" Then
			$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir, "", @SW_MINIMIZE)
		Else
			$aServerPIDRedis = Run($xServerRedis, $aServerRedisFolder, "", @SW_MINIMIZE)
		EndIf
	EndIf
	PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
	LogWrite(" [Redis started (PID: " & $aServerPIDRedis & ")]", " [Redis started (PID: " & $aServerPIDRedis & ")] " & $xServerRedis)
EndIf
Local $tStartedServersTF = False
Local $tServersToStart = ""
For $i = 0 To ($aServerGridTotal - 1)
	If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) Then
		If $xStartGrid[$i] = "yes" Then
			$tStartedServersTF = True
			$tServersToStart &= _ServerNamingScheme($i, $aNamingScheme) & " "
		EndIf
	EndIf
Next
If $xServerIP[0] = "1.2.3.4" Then
	$tStartedServersTF = False
	For $i = 0 To ($aServerGridTotal - 1)
		If $xStartGrid[$i] = "yes" Then
			$xStartGrid[$i] = "no"
			$aGridSomeDisable = True
			IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", "no")
		EndIf
	Next
EndIf

If $tStartedServersTF Then
	Local $aMsg = "The following Server(s) need to be started:" & @CRLF & $tServersToStart & @CRLF & @CRLF & _
			"Click (YES) to start servers (or wait 10 seconds)." & @CRLF & _
			"Click (NO) to DISABLE ALL SERVERS and continue utility." & @CRLF & _
			"Click (CANCEL) to exit utility."
	SplashOff()
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 10)
	; ----------------------------------------------------------
	If $tMB = 6 Then ; YES
		$aSplashStartUp = _Splash($aStartText, 0, 475)
	ElseIf $tMB = -1 Then ; Timeout
		$aSplashStartUp = _Splash($aStartText, 0, 475)
	ElseIf $tMB = 7 Then ; NO
		Local $aMsg = "Are you sure you wish to disable all grids?" & @CRLF & @CRLF & _
				"Click (YES) to DISABLE ALL SERVERS and continue utility." & @CRLF & _
				"Click (NO) or (CANCEL) to exit utility."
		$tMB1 = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg)
		If $tMB1 = 6 Then ; YES
			_Splash($aStartText & "Disabling grids.", 2000, 475)
			$aSplashStartUp = _Splash($aStartText & "Disabling grids.", 0, 475)
			For $i = 0 To ($aServerGridTotal - 1)
				If $xStartGrid[$i] = "yes" Then
					$xStartGrid[$i] = "no"
					$aGridSomeDisable = True
					IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", "no")
				EndIf
			Next
		Else
			_Splash("Exiting utility. . .", 2000)
			CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
			_ExitUtil()
		EndIf
	ElseIf $tMB = 2 Then ; CANCEL
		_Splash("Exiting utility. . .", 2000)
		CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
		_ExitUtil()
	Else
		_Splash("Exiting utility. . .", 2000)
		CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
		_ExitUtil()
	EndIf
EndIf

ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Starting servers.")
Local $tFirstGrid = True
For $i = 0 To ($aServerGridTotal - 1)
	If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) Then
		If $xStartGrid[$i] = "yes" Then
			Local $tDelay = Int($aServerStartDelay) + ($xGridStartDelay[$i])
			If $tFirstGrid = False Then
				For $x = 0 To ($tDelay - 1)
					ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Starting server " & _ServerNamingScheme($i, $aNamingScheme) & " in " & ($tDelay - $x) & " seconds.")
					Sleep(1000)
					If $aUseKeepAliveYN = "yes" Then KeepUtilAliveCounter()
				Next
			Else
				$tFirstGrid = False
				ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Starting server " & _ServerNamingScheme($i, $aNamingScheme) & " in 1 seconds.")
				Sleep(1000)
			EndIf
			If $aServerMinimizedYN = "no" Then
				$aServerPID[$i] = Run($xServerStart[$i])
			Else
				$aServerPID[$i] = Run($xServerStart[$i], "", @SW_MINIMIZE)
			EndIf
			$aTimeCheck6 = _NowCalc()
			$xServerCPU[$i] = _ProcessUsageTracker_Create("", $aServerPID[$i])
			LogWrite(" [Server " & _ServerNamingScheme($i, $aNamingScheme) & " started (PID: " & $aServerPID[$i] & ")]", " [Server " & _ServerNamingScheme($i, $aNamingScheme) & "]" & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
		Else
			LogWrite(" [Server " & _ServerNamingScheme($i, $aNamingScheme) & " -*NOT*- STARTED] because it is set to ""no"" in " & $aGridSelectFile)
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
TrayItemSetState(-1, $TRAY_ENABLE)
;~ If $aPlayerCountShowTF Then TrayItemSetState(-1, $TRAY_DISABLE)
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
;~ Local $tMsg = "Welcome to the new GUI Interface!" & @CRLF & _
;~ 		"- The main window updates every 10 seconds." & @CRLF & _
;~ 		"- Online Player Count updates independently." & @CRLF & _
;~ 		"- COMING SOON! Adjust server settings by clicking on main window." & @CRLF & @CRLF & _
;~ 		"- Please report any problems to Discord or email: kim@kim125.com"
;~ MsgBox(0, $aUtilName, $tMsg, 15)
If $xServerIP[0] = "1.2.3.4" Then
	Local $tMsg = "Congrats! " & $aUtilName & " installation complete." & @CRLF & @CRLF & _
			"Click (YES) to run the Startup Wizard." & @CRLF & _
			"Click (NO) to edit the config file." & @CRLF & _
			"Click (CANCEL) to continue."
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $tMsg, 30)
	If $tMB = 6 Then ; YES
		WizardSelect()
	ElseIf $tMB = 7 Then ; NO
		ConfigEdit($aSplashStartUp)
	ElseIf $tMB = 2 Then ; CANCEL
	EndIf
Else
	Local $tMsg = "NOTICE!!! As of v1.6.9 !!! " & @CRLF & @CRLF & _
			"- The AtlasServerUpateUtility.ini and " & @CRLF & "AtlasServerUpateUtilityGridSelect.ini files" & @CRLF & _
			"were moved to ""\Config"" folder ..."
	MsgBox(0, $aUtilName, $tMsg, 15)
EndIf
If $aUpdateUtil > 0 Then AdlibRegister("RunUtilUpdate", $aUpdateUtil * 3600000)
Local $aSliderPrev = GUICtrlRead($UpdateIntervalSlider)
$aServerCheck = TimerInit()

Local $iSelected = -1
Global $lLogTabWindow = 0, $lBasicEdit = 0, $lDetailedEdit = 0, $lOnlinePlayersEdit = 0, $lServerSummaryEdit = 0, $lConfigEdit = 0, $lGridSelectEdit = 0, $lServerGridEdit = 0, $lDefaultGameEdit = 0, $lDefaultGUSEdit = 0, $lDefaultEngineEdit = 0

;Global $tClickHead = -1, $tClickCol = -1, $tClickRow = -1, $tClickType = -1, $tClickHotTrack = -1
;GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")

Global $aRet[3], $iWidth = 1001, $iHeight = 701
Local $tLVlast = 0, $tLVclick = 0

While True ;**** Loop Until Closed ****
	$aSliderNow = GUICtrlRead($UpdateIntervalSlider)
	If $aSliderNow <> $aSliderPrev Then
		GUICtrlSetData($UpdateIntervalEdit, $aSliderNow)
		$aSliderPrev = $aSliderNow
	EndIf
	#cs
		If $tClickType <> -1 Then
		Sleep(200)
		If $tClickType = "Header" Then SplashTextOn("Click", "Clicked Header Column:" & $tClickHead)
		If $tClickType = "L1" Then SplashTextOn("Click", "Left Clicked" & @CRLF & "Row:" & $tClickRow & @CRLF & "Column:" & $tClickCol)
		If $tClickType = "R1" Then SplashTextOn("Click", "Right Clicked" & @CRLF & "Row:" & $tClickRow & @CRLF & "Column:" & $tClickCol)
		If $tClickType = "L2" Then SplashTextOn("Click", "Left Clicked 2" & @CRLF & "Row:" & $tClickRow & @CRLF & "Column:" & $tClickCol)
		If $tClickType = "R2" Then SplashTextOn("Click", "Right Clicked 2" & @CRLF & "Row:" & $tClickRow & @CRLF & "Column:" & $tClickCol)
		;~ 			If $tClickType = "HotTrack" Then SplashTextOn("Click", "HotTrack" & @CRLF & "Row:" & $tClickHotTrack)
		Sleep(1000)
		ControlClick("AtlasServerUpdateUtility v", "", "[CLASS:SysListView32; INSTANCE:1]", "left", 1, 853, 33)
		SplashOff()
		$tClickHead = -1
		$tClickCol = -1
		$tClickRow = -1
		$tClickType = -1
		;~ 			_GUICtrlListView_SetItemSelected($wMainListViewWindow, 99, True, True)
		;~ 			_GUICtrlListBox_SetSel($wMainListViewWindow, 99, True)
		EndIf
	#ce

	$vRet = _GUIListViewEx_EventMonitor()
	If @error Then
;~ 		MsgBox($MB_SYSTEMMODAL, "Error", "Event error: " & @error & @CRLF & "vRet:" & $vRet & @CRLF & "$aRet[1]:" & $aRet[1] & @CRLF & "$aRet[2]:" & $aRet[2])
	EndIf
	Switch @extended
		Case 0
			; No event detected
		Case 1
;~ 			If $vRet = "" Then
;~ 				MsgBox($MB_SYSTEMMODAL, "Edit", "Edit aborted" & @CRLF) ;
;~ 			Else
;~ 				_Splash("Cell Edit Event", 1000)
;~ 				_ArrayDisplay($vRet, "ListView " & _GUIListViewEx_GetActive() & " content edited", Default, 8)
;~ 			EndIf
		Case 2
;~ 			If $vRet = "" Then
;~ 				MsgBox($MB_SYSTEMMODAL, "Header edit", "Header edit aborted" & @CRLF)
;~ 			Else
;~ 				_Splash("Header Edit Event", 1000)
;~ 				_ArrayDisplay($vRet, "ListView " & _GUIListViewEx_GetActive() & " header edited", Default, 8)
;~ 			EndIf
		Case 3
;~ 			_Splash("ListView Sort Event", 1000)
		Case 4
;~ 			Local $aRet = StringSplit($vRet, ":")
;~ 			_Splash("Dragged From ListView " & $aRet[1] & @CRLF & "To ListView " & $aRet[2], 2000)
		Case 9 ; This is returned after a selection change
			ControlClick("AtlasServerUpdateUtility v", "", "[CLASS:SysListView32; INSTANCE:1]", "left", 1, $iWidth - 156, $iHeight - 20)
			If $vRet[2] > 3 Then
;~ 				MsgBox($MB_OK, $aUtilName, "You clicked on Server " & _ServerNamingScheme($vRet[1], $aNamingScheme) & " " & $xServerNames[$vRet[1]] & "." & _
;~ 						@CRLF & "Server-speicifc config options coming soon!", 10)
				GridConfiguratorGUI($vRet[1])
				;					_Splash("New selection:" & @CRLF & "vRet0: " & $vRet[0] & @CRLF & "Row: " & $vRet[1] & @CRLF & "Col: " & $vRet[2], 1000)
			EndIf
	EndSwitch

;~ 	$tLVclick = GUICtrlRead($wMainListViewWindow).
;~ 	If $tLVclick <> 0 And $tLVclick <> $tLVlast Then
;~ 		_Splash("You Clicked Row " & $tLVclick, 1000)
;~ 		$tLVlast = $tLVclick
;~ 	EndIf

;~ 	For $i = 0 To _GUICtrlListView_GetItemCount($wMainListViewWindow)
;~ 		Local $aItemAttrib = _GUICtrlListView_GetItem($wMainListViewWindow, $i)
;~ 		; Using bitand to see if the item has focus or is selected since the attribute at [0] can be a combination of values
;~ 		If (IsArray($aItemAttrib) And BitAND($aItemAttrib[0], 12)) Then
;~ 			; Prevent the label from constantly being updated, only updates when new item is selected
;~ 			If ($iSelected <> $i) Then
;~                     GUICtrlSetData($lblSelected, "Row Selected: " & $i + 1)
;~ 				_Splash("You Clicked Row " & $i + 1, 1000)
;~                     $iSelected = $i
;~ 				$iSelected = -1
;~ 					_GUICtrlListBox_SetCurSel($wMainListViewWindow, -1)
;~ 					_GUICtrlListView_SetItemSelected($wMainListViewWindow, -1, False, False)
;~ 					_GUICtrlListBox_SetSel($wMainListViewWindow, 1, True)
;~ 				For $x = 0 To 11
;~ 					_GUICtrlListBox_SetSel($wMainListViewWindow, $x, False)
;~ 				Next
;~ 			EndIf
;~ 			ExitLoop
;~ 		EndIf
;~ 	Next

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

	If TimerDiff($aServerCheck) > ($aMainGUIRefreshTime * 1000) Then
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
		Local $tFirstGrid = True
		For $i = 0 To ($aServerGridTotal - 1)
			If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) Then ; And ($xStartGrid[$i] = "yes") Then
				If $xStartGrid[$i] = "yes" Then
					If $tFirstGrid = False Then
						Local $tDelay = Int($aServerStartDelay) + ($xGridStartDelay[$i])
						For $x = 0 To ($tDelay - 1)
							SetStatusBusy("Starting Server " & _ServerNamingScheme($i, $aNamingScheme) & " in " & ($tDelay - $x))
							Sleep(1000)
						Next
					Else
						$tFirstGrid = False
						SetStatusBusy("Starting Server " & _ServerNamingScheme($i, $aNamingScheme) & " in 1")
						Sleep(1000)
					EndIf
					If $aServerMinimizedYN = "no" Then
						$aServerPID[$i] = Run($xServerStart[$i])
					Else
						$aServerPID[$i] = Run($xServerStart[$i], "", @SW_MINIMIZE)
					EndIf
					$aTimeCheck6 = _NowCalc()
					$xServerCPU[$i] = _ProcessUsageTracker_Create("", $aServerPID[$i])
					LogWrite(" [Server " & _ServerNamingScheme($i, $aNamingScheme) & " started (PID: " & $aServerPID[$i] & ")]", " [Server " & _ServerNamingScheme($i, $aNamingScheme) & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
				EndIf
				BatchFilesCreate()
			EndIf
		Next
		#EndRegion ;**** Keep Server Alive Check. ****
		#Region ;**** Show Online Players ****
		If $aServerOnlinePlayerYN = "yes" Then
			If ((_DateDiff('s', $aTimeCheck8, _NowCalc())) >= $aServerOnlinePlayerSec) Then
;~ 				If ((_DateDiff('s', $aTimeCheck6, _NowCalc())) < 180) Then
;~ 					$aOnlinePlayers = GetPlayerCount(0, False) ; False = Servers Startup Delay time has not lapsed
;~ 					_Splash("Online Player Check." & @CRLF & @CRLF & "Waiting up to 3 minutes for servers to come online.", 3000)
;~ 				Else
				$aOnlinePlayers = GetPlayerCount(0)
;~ 				EndIf
				ShowPlayerCount()
				If $aServerReadyTF And $aServerReadyOnce Then
					Local $aSendServerReadyTF = False
					For $i = 0 To ($aServerGridTotal - 1)
						If $xStartGrid[$i] = "yes" Then $aSendServerReadyTF = True
					Next
					If $aSendServerReadyTF Then
						If $aNoExistingPID Then
							If $sUseDiscordBotServersUpYN = "yes" Then
								Local $aAnnounceCount3 = 0
								If $aRebootReason = "remoterestart" And $sUseDiscordBotRemoteRestart = "yes" Then
									_Splash(" All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .")
									SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
									$aAnnounceCount3 = $aAnnounceCount3 + 1
								EndIf
								If $aRebootReason = "stopservers" And $sUseDiscordBotStopServer = "yes" And ($aAnnounceCount3 = 0) Then
									_Splash(" All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .")
									SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
									$aAnnounceCount3 = $aAnnounceCount3 + 1
								EndIf
								If $aRebootReason = "update" And $sUseDiscordBotUpdate = "yes" And ($aAnnounceCount3 = 0) Then
									_Splash(" All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .")
									SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
									$aAnnounceCount3 = $aAnnounceCount3 + 1
								EndIf
								If $aRebootReason = "mod" And $sUseDiscordBotUpdate = "yes" And ($aAnnounceCount3 = 0) Then
									_Splash(" All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .")
									SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
									$aAnnounceCount3 = $aAnnounceCount3 + 1
								EndIf
								If $aRebootReason = "daily" And $sUseDiscordBotDaily = "yes" And ($aAnnounceCount3 = 0) Then
									_Splash(" All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .")
									SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
									$aAnnounceCount3 = $aAnnounceCount3 + 1
								EndIf
								If $xCustomRCONRebootNumber > -1 Then
									If $aRebootReason = "custom" And $xEventAnnounceInGame[$xCustomRCONRebootNumber] <> "" And ($aAnnounceCount3 = 0) Then
										_Splash(" All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .")
										SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
										$aAnnounceCount3 = $aAnnounceCount3 + 1
										$xCustomRCONRebootNumber = -1
									EndIf
								EndIf
								If $aFirstStartDiscordAnnounce And ($aAnnounceCount3 = 0) Then
									_Splash(" All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement sent . . .")
									SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
									$aFirstStartDiscordAnnounce = False
								EndIf
							Else
								_Splash(" All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement NOT sent. Enable first announcement and/or daily, mod, update, remote restart annoucements in config if desired.", 0, 400, 200)
								$xCustomRCONRebootNumber = -1
							EndIf
						Else
							_Splash(" All servers online and ready for connection." & @CRLF & @CRLF & "Discord announcement SKIPPED because servers were already running or feature disabled in config.")
							$aNoExistingPID = True
							$xCustomRCONRebootNumber = -1
						EndIf
						$aServerReadyOnce = False
						Sleep(5000)
						SplashOff()
					EndIf
				EndIf
				$aTimeCheck8 = _NowCalc()
			EndIf
		EndIf
		#EndRegion ;**** Show Online Players ****
		GUICtrlSetData($LabelUtilReadyStatus, "Updating Server Info")
		If ($aDestroyWildDinosYN) = "yes" Then
			If ((_DateDiff('n', $aTimeCheck7, _NowCalc())) >= 1) Then
				If RespawnDinosCheck($aDestroyWildDinosDays, $aDestroyWildDinosHours, $aDestroyWildDinosMinute) Then
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

		#Region ;**** Backup Every X Days and X Hours & Min****
		If ($aBackupYN = "yes") And ((_DateDiff('n', $aTimeCheck4, _NowCalc())) >= 1) And (BackupCheck($aBackupDays, $aBackupHours, $aBackupMin)) Then
			_BackupGame(True)
			$aTimeCheck4 = _NowCalc()
		EndIf
		#EndRegion ;**** Backup Every X Days and X Hours & Min****

		If ((_DateDiff('n', $aTimeCheck5, _NowCalc())) >= 1) Then ; Event Scheduler
			For $t = 0 To ($aMax6moAll - 1)
				If $xEventTimePastTF[$t] = False Then
;~ 					Local $tDateDiff = _DateDiff('n', _NowCalc(), $xEventRestartTimeAll[$t][0])
					Local $tDateDiff = _DateDiff('n', _NowCalc(), _DateAdd('n', 1, $xEventRestartTimeAll[$t][0]))
					If $tDateDiff <= 0 Then
						$xEventTimePastTF[$t] = True
						$i = $xEventRestartTimeAll[$t][1]
						If $xCustomRCONCmd[$i] <> "" Then
							Local $xCustomRCONSplitCmd = StringSplit($xCustomRCONCmd[$i], "~", 2)
							For $x = 0 To (UBound($xCustomRCONSplitCmd) - 1)
								If $xCustomRCONAllorLocal[$i] = "1" Then
									LogWrite(" [Scheduled Event " & $i & "] Sending RCON command to Local servers: " & $xCustomRCONSplitCmd[$x])
									F_SendRCON("local", $xCustomRCONSplitCmd[$x])
								Else
									LogWrite(" [Scheduled Event " & $i & "] Sending RCON command to ALL servers: " & $xCustomRCONSplitCmd[$x])
									F_SendRCON("all", $xCustomRCONSplitCmd[$x])
								EndIf
							Next
						EndIf
						If $xEventFile[$i] <> "" Then
							LogWrite(" [Scheduled Event " & $i & "] Executing file: " & $xEventFile[$i])
							Run($xEventFile[$i])
						EndIf
						If $xCustomRCONRestartYN[$i] = "yes" Then
							$aRebootReason = "Custom"
							$aBeginDelayedShutdown = 1
							$aTimeCheck0 = _NowCalc()
							$xCustomRCONRebootNumber = $i
						EndIf
					EndIf
				EndIf
			Next
			$aTimeCheck5 = StringTrimRight(_NowCalc(), 2) & "00"
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
		If ((_DateDiff('n', $aTimeCheck0, _NowCalc())) >= $aUpdateCheckInterval) And ($aBeginDelayedShutdown = 0) Then
			If $aCheckForUpdate = "yes" Then
				SetStatusBusy("Check: Server Update")
				UpdateCheck(False, 0, False)
				SetStatusIdle()
			EndIf
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
				If $aRebootReason = "Custom" Then
					$aAnnounceCount0 = $aCustomCnt[$xCustomRCONRebootNumber]
					$aAnnounceCount1 = $aAnnounceCount0 - 1
					$aDelayShutdownTime = ($aCustomTime[$xCustomRCONRebootNumber])[$aAnnounceCount0] - ($aCustomTime[$xCustomRCONRebootNumber])[$aAnnounceCount1] + 1
					If $aAnnounceCount1 = 0 Then
						$aDelayShutdownTime = 0
						$aBeginDelayedShutdown = 3
					Else
						$aDelayShutdownTime = ($aCustomTime[$xCustomRCONRebootNumber])[$aAnnounceCount0] - ($aCustomTime[$xCustomRCONRebootNumber])[$aAnnounceCount1]
					EndIf
					If $xEventAnnounceInGame[$xCustomRCONRebootNumber] <> "" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, ($sCustomMsgInGame[$xCustomRCONRebootNumber])[$aAnnounceCount0])
					EndIf
					If $xEventAnnounceDiscord[$xCustomRCONRebootNumber] <> "" Then
						SendDiscordMsg($sDiscordWebHookURLs, ($sCustomMsgDiscord[$xCustomRCONRebootNumber])[$aAnnounceCount0], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $xEventAnnounceTwitch[$xCustomRCONRebootNumber] <> "" Then
						TwitchMsgLog(($sCustomMsgTwitch[$xCustomRCONRebootNumber])[$aAnnounceCount0])
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
						If $aDailyTime[($aAnnounceCount1)] > 0 Then SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aDailyMsgInGame[$aAnnounceCount1])
					EndIf
					If $sUseDiscordBotDaily = "yes" And ($sUseDiscordBotFirstAnnouncement = "no") Then
						If $aDailyTime[($aAnnounceCount1)] > 0 Then SendDiscordMsg($sDiscordWebHookURLs, $aDailyMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotDaily = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						If $aDailyTime[($aAnnounceCount1)] > 0 Then TwitchMsgLog($aDailyMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf
				If $aRebootReason = "remoterestart" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = $aRemoteTime[$aAnnounceCount1] - $aRemoteTime[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = $aRemoteTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						If $aRemoteTime[($aAnnounceCount1)] > 0 Then SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aRemoteMsgInGame[$aAnnounceCount1])
					EndIf
					If ($sUseDiscordBotRemoteRestart = "yes") And ($sUseDiscordBotFirstAnnouncement = "no") Then
						If $aRemoteTime[($aAnnounceCount1)] > 0 Then SendDiscordMsg($sDiscordWebHookURLs, $aRemoteMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotRemoteRestart = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						If $aRemoteTime[($aAnnounceCount1)] > 0 Then TwitchMsgLog($aRemoteMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf
				If $aRebootReason = "stopservers" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = $aStopServerTime[$aAnnounceCount1] - $aStopServerTime[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = $aStopServerTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						If $aStopServerTime[($aAnnounceCount1)] > 0 Then SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aStopServerMsgInGame[$aAnnounceCount1])
					EndIf
					If ($sUseDiscordBotStopServer = "yes") And ($sUseDiscordBotFirstAnnouncement = "no") Then
						If $aStopServerTime[($aAnnounceCount1)] > 0 Then SendDiscordMsg($sDiscordWebHookURLs, $aStopServerMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotStopServer = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						If $aStopServerTime[($aAnnounceCount1)] > 0 Then TwitchMsgLog($aStopServerMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf
				If $aRebootReason = "update" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = $aUpdateTime[$aAnnounceCount1] - $aUpdateTime[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = $aUpdateTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						If $aUpdateTime[($aAnnounceCount1)] > 0 Then SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aUpdateMsgInGame[$aAnnounceCount1])
					EndIf
					If $sUseDiscordBotUpdate = "yes" And ($sUseDiscordBotFirstAnnouncement = "no") Then
						If $aUpdateTime[($aAnnounceCount1)] > 0 Then SendDiscordMsg($sDiscordWebHookURLs, $aUpdateMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotUpdate = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						If $aUpdateTime[($aAnnounceCount1)] > 0 Then TwitchMsgLog($aUpdateMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf
				If $aRebootReason = "mod" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = $aModTime[$aAnnounceCount1] - $aModTime[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = $aModTime[$aAnnounceCount1]
					EndIf
					If $sInGameAnnounce = "yes" Then
						If $aModTime[($aAnnounceCount1)] > 0 Then SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $aModMsgInGame[$aAnnounceCount1])
					EndIf
					If $sUseDiscordBotUpdate = "yes" And ($sUseDiscordBotFirstAnnouncement = "no") Then
						If $aModTime[($aAnnounceCount1)] > 0 Then SendDiscordMsg($sDiscordWebHookURLs, $aModMsgDiscord[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $sUseTwitchBotUpdate = "yes" And ($sUseTwitchFirstAnnouncement = "no") Then
						If $aModTime[($aAnnounceCount1)] > 0 Then TwitchMsgLog($aModMsgTwitch[$aAnnounceCount1])
					EndIf
				EndIf
				If $aRebootReason = "Custom" Then
					If $aAnnounceCount1 > 1 Then
						$aDelayShutdownTime = ($aCustomTime[$xCustomRCONRebootNumber])[$aAnnounceCount1] - ($aCustomTime[$xCustomRCONRebootNumber])[($aAnnounceCount1 - 1)]
					Else
						$aDelayShutdownTime = ($aCustomTime[$xCustomRCONRebootNumber])[$aAnnounceCount1]
					EndIf
					If $xEventAnnounceInGame[$xCustomRCONRebootNumber] <> "" Then
						SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, ($sCustomMsgInGame[$xCustomRCONRebootNumber])[$aAnnounceCount1])
					EndIf
					If $xEventAnnounceDiscord[$xCustomRCONRebootNumber] <> "" And ($sUseDiscordBotFirstAnnouncement = "no") Then
						SendDiscordMsg($sDiscordWebHookURLs, ($sCustomMsgDiscord[$xCustomRCONRebootNumber])[$aAnnounceCount1], $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
					EndIf
					If $xEventAnnounceTwitch[$xCustomRCONRebootNumber] <> "" And ($sUseTwitchFirstAnnouncement = "no") Then
						TwitchMsgLog(($sCustomMsgTwitch[$xCustomRCONRebootNumber])[$aAnnounceCount1])
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
Func GUI_Main_B_Tools()
	ShowGUITools()
;~ 	LogWindow(4)
EndFunc   ;==>GUI_Main_B_Tools
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
Func GUI_Main_B_SelectAll()
	For $i = 0 To ($aServerGridTotal - 1)
		_GUICtrlListView_SetItemChecked($wMainListViewWindow, $i, True)
	Next
EndFunc   ;==>GUI_Main_B_SelectAll
Func GUI_Main_B_SelectNone()
	For $i = 0 To ($aServerGridTotal - 1)
		_GUICtrlListView_SetItemChecked($wMainListViewWindow, $i, False)
	Next
EndFunc   ;==>GUI_Main_B_SelectNone
Func GUI_Main_B_Invert()
	For $i = 0 To ($aServerGridTotal - 1)
		If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
			_GUICtrlListView_SetItemChecked($wMainListViewWindow, $i, False)
		Else
			_GUICtrlListView_SetItemChecked($wMainListViewWindow, $i, True)
		EndIf
	Next
EndFunc   ;==>GUI_Main_B_Invert
Func GUI_Main_B_BackupMenu()
	Local $aMsg = "Backup menu coming soon!" & @CRLF & "Edit the config file to adjust backup schedule." & @CRLF & @CRLF & _
			"Click (YES) to make a backup now." & @CRLF & _
			"Click (NO) Or (CANCEL) to cancel backup."
	SplashOff()
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 30)
	If $tMB = 6 Then ; YES
		_Splash("Backup up Atlas files now.")
		_BackupGame(False)
		SplashOff()
	EndIf
EndFunc   ;==>GUI_Main_B_BackupMenu
Func GUI_Main_B_GridConfigurator()
	GridConfiguratorGUI(0)
EndFunc   ;==>GUI_Main_B_GridConfigurator
Func GUI_Main_B_EventScheduler()
;~ 	ShellExecute($aEventSaveFile)
	Run("notepad.exe " & $aEventSaveFile)
	Sleep(500)
	MsgBox($MB_OK, $aUtilName, "Event Scheduler is unfinished.  It is fully functional, but a simpler entry method and an interactive calendar are coming soon!" & @CRLF & @CRLF & _
			"See AtlasServerUpdateUtility.ini file (or click CONFIG) to edit scheduler.", 30)
EndFunc   ;==>GUI_Main_B_EventScheduler
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
Func GUI_Main_B_StartServerAll()
	F_StartServer()
EndFunc   ;==>GUI_Main_B_StartServerAll
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
Func GUI_Main_I_IconRefreshPlayers()
	$tSplash = _Splash("")
	$aOnlinePlayers = GetPlayerCount($tSplash, False, True)
	_Splash("Online players scan complete.", 2000)
	ShowPlayerCount()
EndFunc   ;==>GUI_Main_I_IconRefreshPlayers
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
	ShellExecute($aIniFile)
;~ 	Run("notepad.exe " & $aIniFile)
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
	GUICtrlSetData($lBasicEdit, $tTxt)
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
	GUICtrlSetData($lDetailedEdit, $tTxt)
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
	GUICtrlSetData($lOnlinePlayersEdit, $tTxt)
EndFunc   ;==>GUI_Log_OnlinePlayers_B_Button
Func GUI_Log_ServerSummary_B_Button()
	MakeServerSummaryFile($aServerSummaryFile)
	Local $tFileOpen = FileOpen($aServerSummaryFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($lServerSummaryEdit, $tTxt)
EndFunc   ;==>GUI_Log_ServerSummary_B_Button
Func GUI_Log_Config_B_Save()
;~ 	Local $tTxt = GUICtrlRead($lConfigEdit)
	Local $tTxt = ReplaceCRwithCRLF(GUICtrlRead($lConfigEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aIniFile & "_" & $tTime & ".bak"
	FileMove($aIniFile, $tFile, 1)
	FileWrite($aIniFile, $tTxt)
	_Splash($aUtilName & ".ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "_" & $tTime & ".bak", 3000, 475)
EndFunc   ;==>GUI_Log_Config_B_Save
Func GUI_Log_Config_B_Reset()
	Local $tFileOpen = FileOpen($aIniFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($lConfigEdit, $tTxt)
EndFunc   ;==>GUI_Log_Config_B_Reset
Func GUI_Log_GridSelect_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(GUICtrlRead($lGridSelectEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
	FileMove($aGridSelectFile, $tFile, 1)
	FileWrite($aGridSelectFile, $tTxt)
	_Splash($aUtilName & "GridStartSelect.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "GridStartSelect.ini_" & $tTime & ".bak", 3000, 525)
EndFunc   ;==>GUI_Log_GridSelect_B_Save
Func GUI_Log_GridSelect_B_Reset()
	Local $tFileOpen = FileOpen($aGridSelectFile)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($lGridSelectEdit, $tTxt)
EndFunc   ;==>GUI_Log_GridSelect_B_Reset
Func GUI_Log_ServerGrid_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(GUICtrlRead($lServerGridEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aConfigFull & "_" & $tTime & ".bak"
	FileMove($aConfigFull, $tFile, 1)
	FileWrite($aConfigFull, $tTxt)
	_Splash($aConfigFile & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aConfigFile & "_" & $tTime & ".bak", 3000, 525)
EndFunc   ;==>GUI_Log_ServerGrid_B_Save
Func GUI_Log_ServerGrid_B_Reset()
	Local $tFileOpen = FileOpen($aConfigFull)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($lServerGridEdit, $tTxt)
EndFunc   ;==>GUI_Log_ServerGrid_B_Reset
Func GUI_Log_DefaultGame_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(GUICtrlRead($lDefaultGameEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aDefaultGame & "_" & $tTime & ".bak"
	FileMove($aDefaultGame, $tFile, 1)
	FileWrite($aDefaultGame, $tTxt)
	_Splash("DefaultGame.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & "DefaultGame.ini_" & $tTime & ".bak", 3000, 525)
EndFunc   ;==>GUI_Log_DefaultGame_B_Save
Func GUI_Log_DefaultGame_B_Reset()
	Local $tFileOpen = FileOpen($aDefaultGame)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($lDefaultGameEdit, $tTxt)
EndFunc   ;==>GUI_Log_DefaultGame_B_Reset
Func GUI_Log_DefaultGUS_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(GUICtrlRead($lDefaultGUSEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aDefaultGUS & "_" & $tTime & ".bak"
	FileMove($aDefaultGUS, $tFile, 1)
	FileWrite($aDefaultGUS, $tTxt)
	_Splash("DefaultGameUserSettings.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & "DefaultGameUserSettings.ini_" & $tTime & ".bak", 3000, 525)
EndFunc   ;==>GUI_Log_DefaultGUS_B_Save
Func GUI_Log_DefaultGUS_B_Reset()
	Local $tFileOpen = FileOpen($aDefaultGUS)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($lDefaultGUSEdit, $tTxt)
EndFunc   ;==>GUI_Log_DefaultGUS_B_Reset
Func GUI_Log_DefaultEngine_B_Save()
	Local $tTxt = ReplaceCRwithCRLF(GUICtrlRead($lDefaultEngineEdit))
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aDefaultEngine & "_" & $tTime & ".bak"
	FileMove($aDefaultEngine, $tFile, 1)
	FileWrite($aDefaultEngine, $tTxt)
	_Splash("DefaultEngine.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & "DefaultEngine.ini_" & $tTime & ".bak", 3000, 525)
EndFunc   ;==>GUI_Log_DefaultEngine_B_Save
Func GUI_Log_DefaultEngine_B_Reset()
	Local $tFileOpen = FileOpen($aDefaultEngine)
	Local $tTxt = FileRead($tFileOpen)
	FileClose($tFileOpen)
	GUICtrlSetData($lDefaultEngineEdit, $tTxt)
EndFunc   ;==>GUI_Log_DefaultEngine_B_Reset

;~ Func SetFont($tID, $tFont, $tSize = 9)
;~ 	_GUICtrlRichEdit_SetSel($tID, 0, -1)     ; select all
;~ 	_GUICtrlRichEdit_SetFont($tID, $tSize, $tFont)
;~ 	ControlSend("", "", $tID, "^+{Home}")
;~ 	ControlSend("", "", $tID, "^+{Home}")
;~ EndFunc   ;==>SetFont

#EndRegion ;**** Define GUI Functions

Func WM_NOTIFY($hWnd, $iMsg, $wParam, $lParam)
	#forceref $hWnd, $iMsg, $wParam
	Local $hWndFrom, $iIDFrom, $iCode, $tNMHDR, $hWndListView, $tInfo
	$hWndListView = $wMainListViewWindow
	If Not IsHWnd($wMainListViewWindow) Then $hWndListView = GUICtrlGetHandle($wMainListViewWindow)
	$tNMHDR = DllStructCreate($tagNMHDR, $lParam)
	$hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
	$iIDFrom = DllStructGetData($tNMHDR, "IDFrom")
	$iCode = DllStructGetData($tNMHDR, "Code")
	Switch $hWndFrom
		Case $hWndListView
			Switch $iCode
				Case $LVN_COLUMNCLICK ; A column was clicked
					$tInfo = DllStructCreate($tagNMLISTVIEW, $lParam)
					$tClickType = "Header"
					$tClickHead = DllStructGetData($tInfo, "SubItem")
					$tClickRow = -1
					$tClickCol = -1
				Case $NM_CLICK ; Sent by a list-view control when the user clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					$tClickType = "L1"
					$tClickHead = -1
					$tClickRow = DllStructGetData($tInfo, "Index")
					$tClickCol = DllStructGetData($tInfo, "SubItem")
				Case $NM_DBLCLK ; Sent by a list-view control when the user double-clicks an item with the left mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					$tClickType = "L2"
					$tClickHead = -1
					$tClickRow = DllStructGetData($tInfo, "Index")
					$tClickCol = DllStructGetData($tInfo, "SubItem")
;~ 				Case $NM_HOVER ; Sent by a list-view control when the mouse hovers over an item
;~ 					_DebugPrint("$NM_HOVER" & @CRLF & "--> hWndFrom:" & @TAB & $hWndFrom & @CRLF & _
;~ 							"-->IDFrom:" & @TAB & $iIDFrom & @CRLF & _
;~ 							"-->Code:" & @TAB & $iCode)
				Case $NM_RCLICK ; Sent by a list-view control when the user clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					$tClickType = "R1"
					$tClickHead = -1
					$tClickRow = DllStructGetData($tInfo, "Index")
					$tClickCol = DllStructGetData($tInfo, "SubItem")
				Case $NM_RDBLCLK ; Sent by a list-view control when the user double-clicks an item with the right mouse button
					$tInfo = DllStructCreate($tagNMITEMACTIVATE, $lParam)
					$tClickType = "R2"
					$tClickHead = -1
					$tClickRow = DllStructGetData($tInfo, "Index")
					$tClickCol = DllStructGetData($tInfo, "SubItem")
;~ 				Case $LVN_HOTTRACK
;~ 					$tClickType = "HotTrack"
;~ 					If DllStructGetData($tagNMLISTVIEW,4) > -1 Then $tClickHotTrack = DllStructGetData($tagNMLISTVIEW,4)
			EndSwitch
	EndSwitch
	Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY

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
	Global $aServerModTimeoutMin = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Max time (minutes) to wait for each mod to download (0-180) (0-No Timeout) ###", $iniCheck)
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
	Global $aNamingScheme = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Grid naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###", $iniCheck)
	;
	Global $aCheckForUpdate = IniRead($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Check for server updates? (yes/no) ###", $iniCheck)
	Global $aUpdateCheckInterval = IniRead($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Update check interval in Minutes (05-59) ###", $iniCheck)
	;
	Global $aBackupYN = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Use scheduled backups? (yes/no) ###", $iniCheck)
	Global $aBackupDays = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Backup days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $iniCheck)
	Global $aBackupHours = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Backup hours (comma separated 00-23 ex.04,16) ###", $iniCheck)
	Global $aBackupMin = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Backup minute (00-59) ###", $iniCheck)
	Global $aBackupOutputFolder = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Output folder ###", $iniCheck)
	Global $aBackupRedisFolder = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Redis folder (leave blank to use redis folder above or to disable) ###", $iniCheck)
	Global $aBackupNumberToKeep = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Number of backups to keep (1-999) ###", $iniCheck)
	Global $aBackupTimeoutSec = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Max time in seconds to wait for backup to complete (30-999) ###", $iniCheck)
	Global $aBackupInGame = IniRead($sIniFile, " --------------- BACKUP --------------- ", "In-Game announcement when backup initiated (Leave blank to disable) ###", $iniCheck)
	Global $aBackupTwitch = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Discord announcement when backup initiated (Leave blank to disable) ###", $iniCheck)
	Global $aBackupDiscord = IniRead($sIniFile, " --------------- BACKUP --------------- ", "Twitch announcement when backup initiated (Leave blank to disable) ###", $iniCheck)
	;
	Global $aEventCount = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND COUNT --------------- ", "Number of custom RCON Commands to schedule (If changed, util will restart and new custom entries will be added) ###", $iniCheck)
	If $iniCheck = $aEventCount Then
		$aEventCount = 1
		$aEventCntIniCheck = True
		$iIniFail += 1
		$iIniError = $iIniError & "CustomRCONCount, "
	Else
		$aEventCntIniCheck = False
	EndIf
	Global $xCustomRCONCmd[$aEventCount], $xEventDays[$aEventCount], $xEventHours[$aEventCount], $xEventMinute[$aEventCount]
	Global $xCustomRCONAllorLocal[$aEventCount], $xEventFile[$aEventCount], $xCustomRCONRestartYN[$aEventCount]
	Global $xEventAnnounceMinutes[$aEventCount], $xEventAnnounceInGame[$aEventCount], $xEventAnnounceDiscord[$aEventCount]
	Global $xEventMonthDate[$aEventCount], $xEventAnnounceTwitch[$aEventCount], $xEventMonths[$aEventCount], $xEventName[$aEventCount]
	For $i = 0 To ($aEventCount - 1)
		$xEventName[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Event Name ###", $iniCheck)
		$xCustomRCONCmd[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command(s) to send (Separated by ~, leave BLANK to skip) ###", $iniCheck)
		$xCustomRCONAllorLocal[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command send to (0) ALL grids or (1) Local Grids Only ###", $iniCheck)
		$xEventFile[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-File to Execute (leave BLANK to skip) ###", $iniCheck)
		$xEventMonths[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event Months (comma separated 0-Monthly, 1-12) ###", $iniCheck)
		$xEventMonthDate[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event Days of Month (comma separated 0-Use Weekday Below, 1-31) ###", $iniCheck)
		$xEventDays[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event Weekdays (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $iniCheck)
		$xEventHours[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event hours (comma separated 00-23 ex.04,16) ###", $iniCheck)
		$xEventMinute[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event minute (00-59) ###", $iniCheck)
		$xCustomRCONRestartYN[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Restart servers afterward? (with announcements below) (yes/no) ###", $iniCheck)
		$xEventAnnounceMinutes[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Announcement _ minutes before reboot (comma separated 1-60) ###", $iniCheck)
		$xEventAnnounceInGame[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-In-Game Message to send (\m - minutes)(leave BLANK to skip) ###", $iniCheck)
		$xEventAnnounceDiscord[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Discord Message to send (\m - minutes)(leave BLANK to skip) ###", $iniCheck)
		$xEventAnnounceTwitch[$i] = IniRead($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Twitch Message to send (\m - minutes)(leave BLANK to skip) ###", $iniCheck)
	Next
	;
	Global $aDestroyWildDinosYN = IniRead($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos? (yes/no) ###", $iniCheck)
	Global $aDestroyWildDinosDays = IniRead($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $iniCheck)
	Global $aDestroyWildDinosHours = IniRead($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos hours (comma separated 00-23 ex.04,16) ###", $iniCheck)
	Global $aDestroyWildDinosMinute = IniRead($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos minute (0-59) ###", $iniCheck)

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
	Global $sAnnounceNamingScheme = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement grid naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###", $iniCheck)
	;
	Global $sInGameAnnounce = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires RCON) (yes/no) ###", $iniCheck)
	Global $sInGameMessageDuration = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Approximate duration to display messages in-game (seconds)? (6-30) ###", $iniCheck)
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
	Global $aUseKeepAliveYN = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Run KeepAlive program to detect util crashes and restart it? (yes/no) ###", $iniCheck)
;~ 	Global $aConfigFolder = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Folder to place config files ###", $iniCheck)

	Global $aUtilBetaYN = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", $aUtilName & " version: (0)Stable, (1)Beta ###", $iniCheck)
;~ 	Global $aUsePuttytel = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Use puttytel for telnet client? (yes/no) ###", $iniCheck)
	Global $aExternalScriptHideYN = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide external scripts when executed? (if yes, scripts may not execute properly) (yes/no) ###", $iniCheck)
	;	Global $aDebug = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable debug to output more log detail? (yes/no) ###", $iniCheck)
	Global $aRCONResponseWaitms = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " ADVANCED OPTIONS --------------- ", "Time to wait for RCON response in milliseconds (100-3000) ###", $iniCheck)
	Global $aOnlinePlayerWaitms = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " ADVANCED OPTIONS --------------- ", "Time to wait for Online Players RCON response in milliseconds (100-3000) ###", $iniCheck)
	Global $aMainGUIRefreshTime = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " ADVANCED OPTIONS --------------- ", "Update the Main Window data every __ seconds (2-60) ###", $iniCheck)

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
		$aServerRCONPort = "25720"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerRCONPort, "
	EndIf
	If $iniCheck = $aServerModYN Then
		$aServerModYN = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerModYN, "
	EndIf
	If $iniCheck = $aServerModTimeoutMin Then
		$aServerModTimeoutMin = "10"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerModTimeout, "
	ElseIf $aServerModTimeoutMin < 0 Then
		$aServerModTimeoutMin = 0
	ElseIf $aServerModTimeoutMin > 180 Then
		$aServerModTimeoutMin = 180
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
	If $iniCheck = $aNamingScheme Then
		$aNamingScheme = 2
		$iIniFail += 1
		$iIniError = $iIniError & "GridNamingScheme, "
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
	If $iniCheck = $aDestroyWildDinosMinute Then
		$aDestroyWildDinosMinute = "00"
		$iIniFail += 1
		$iIniError = $iIniError & "DestroyWildDinosMinute, "
	EndIf
	If $iniCheck = $aEventCount Or $aEventCntIniCheck Then
		$aEventCount = 1
		$iIniFail += 1
		$iIniError = $iIniError & "CustomRCONCount, "
		Global $xCustomRCONCmd[$aEventCount], $xEventDays[$aEventCount], $xEventHours[$aEventCount], $xEventMinute[$aEventCount], $xCustomRCONAllorLocal[$aEventCount], $xEventFile[$aEventCount], $xCustomRCONRestartYN[$aEventCount]
		Global $xEventAnnounceMinutes[$aEventCount], $xEventAnnounceInGame[$aEventCount], $xEventAnnounceDiscord[$aEventCount]
		Global $xEventMonthDate[$aEventCount], $xEventAnnounceTwitch[$aEventCount], $xEventMonths[$aEventCount]
	Else
		For $i = 0 To ($aEventCount - 1)
			If $iniCheck = $xEventName[$i] Then
				$xEventName[$i] = "Event " & ($i + 1)
				$iIniFail += 1
				$iIniError = $iIniError & "EventName" & $i & ", "
			EndIf
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
			If $iniCheck = $xEventFile[$i] Then
				$xEventFile[$i] = ""
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONFile" & $i & ", "
			EndIf
			If $iniCheck = $xEventMonths[$i] Then
				$xEventMonths[$i] = "0"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONMonths" & $i & ", "
			EndIf
			If $iniCheck = $xEventMonthDate[$i] Then
				$xEventMonthDate[$i] = "0"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONMonthDate" & $i & ", "
			EndIf
			If $iniCheck = $xEventDays[$i] Then
				$xEventDays[$i] = "0"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONDays" & $i & ", "
			EndIf
			If $iniCheck = $xEventHours[$i] Then
				$xEventHours[$i] = "04"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONHours" & $i & ", "
			EndIf
			If $iniCheck = $xEventMinute[$i] Then
				$xEventMinute[$i] = "00"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONMinute" & $i & ", "
			EndIf
			If $iniCheck = $xCustomRCONRestartYN[$i] Then
				$xCustomRCONRestartYN[$i] = "no"
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONRestartYN" & $i & ", "
			EndIf
			If $iniCheck = $xEventAnnounceMinutes[$i] Then
				If $xCustomRCONRestartYN[$i] = "yes" Then
					$xEventAnnounceMinutes[$i] = "1"
				Else
					$xEventAnnounceMinutes[$i] = ""
				EndIf
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONAnnounceMinutes" & $i & ", "
			EndIf
			If $iniCheck = $xEventAnnounceInGame[$i] Then
				$xEventAnnounceInGame[$i] = ""
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONAnnounceInGame" & $i & ", "
			EndIf
			If $iniCheck = $xEventAnnounceDiscord[$i] Then
				$xEventAnnounceDiscord[$i] = ""
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONAnnounceDiscord" & $i & ", "
			EndIf
			If $iniCheck = $xEventAnnounceTwitch[$i] Then
				$xEventAnnounceTwitch[$i] = ""
				$iIniFail += 1
				$iIniError = $iIniError & "CustomRCONAnnounceTwitch" & $i & ", "
			EndIf
		Next
	EndIf
	If $aCFGRCONCustomLastCount <> $aEventCount Then
		IniWrite($aUtilCFGFile, "CFG", "aCFGRCONCustomLastCount", $aEventCount)
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
		Global $xCustomRCONCmd[$aEventCount], $xEventDays[$aEventCount], $xEventHours[$aEventCount], $xEventMinute[$aEventCount]
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
	If $iniCheck = $aBackupYN Then
		$aBackupYN = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "BackupYN, "
	EndIf
	If $iniCheck = $aBackupDays Then
		$aBackupDays = "0"
		$iIniFail += 1
		$iIniError = $iIniError & "BackupDays, "
	EndIf
	If $iniCheck = $aBackupHours Then
		$aBackupHours = "06,12,18,00"
		$iIniFail += 1
		$iIniError = $iIniError & "BackupHours, "
	EndIf
	If $iniCheck = $aBackupMin Then
		$aBackupMin = "00"
		$iIniFail += 1
		$iIniError = $iIniError & "BackupMin, "
	EndIf
	If $iniCheck = $aBackupOutputFolder Then
		$aBackupOutputFolder = @ScriptDir & "\Backups"
		$iIniFail += 1
		$iIniError = $iIniError & "BackupOutputFolder, "
	EndIf
	If $iniCheck = $aBackupRedisFolder Then
		$aBackupRedisFolder = ""
		$iIniFail += 1
		$iIniError = $iIniError & "BackupRedisFolder, "
	EndIf
	If $iniCheck = $aBackupNumberToKeep Then
		$aBackupNumberToKeep = "56"
		$iIniFail += 1
		$iIniError = $iIniError & "BackupDeleteOlder, "
	ElseIf $aBackupNumberToKeep < 0 Then
		$aBackupNumberToKeep = 1
	ElseIf $aBackupNumberToKeep > 999 Then
		$aBackupNumberToKeep = 999
	EndIf
	If $iniCheck = $aBackupTimeoutSec Then
		$aBackupTimeoutSec = "300"
		$iIniFail += 1
		$iIniError = $iIniError & "BackupTimeoutSec, "
	ElseIf $aBackupTimeoutSec < 30 Then
		$aBackupTimeoutSec = 30
	ElseIf $aBackupTimeoutSec > 999 Then
		$aBackupTimeoutSec = 999
	EndIf
	If $iniCheck = $aBackupInGame Then
		$aBackupInGame = "Server backup in progress."
		$iIniFail += 1
		$iIniError = $iIniError & "BackupInGame, "
	EndIf
	If $iniCheck = $aBackupDiscord Then
		$aBackupDiscord = ""
		$iIniFail += 1
		$iIniError = $iIniError & "BackupDiscord, "
	EndIf
	If $iniCheck = $aBackupTwitch Then
		$aBackupTwitch = ""
		$iIniFail += 1
		$iIniError = $iIniError & "BackupTwitch, "
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
	If $iniCheck = $sAnnounceNamingScheme Then
		$sAnnounceNamingScheme = $aServerAltSaveSelect
		$iIniFail += 1
		$iIniError = $iIniError & "AnnounceNamingScheme, "
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
	If $iniCheck = $sInGameMessageDuration Then
		$sInGameMessageDuration = 15
		$iIniFail += 1
		$iIniError = $iIniError & "InGameMessageDuration, "
	ElseIf $sInGameMessageDuration < 6 Then
		$sInGameMessageDuration = 6
	ElseIf $sInGameMessageDuration > 30 Then
		$sInGameMessageDuration = 30
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
	If $iniCheck = $aUpdateAutoUtil Then
		$aUpdateAutoUtil = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "UpdateAutoUtil, "
	EndIf
	If $iniCheck = $aUseKeepAliveYN Then
		$aUseKeepAliveYN = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "UseKeepAliveYN, "
	EndIf
;~ 	If $iniCheck = $aConfigFolder Then
;~ 		$aConfigFolder = @ScriptDir & "\Config"
;~ 		$iIniFail += 1
;~ 		$iIniError = $iIniError & "ConfigFolder, "
;~ 	EndIf
	If $iniCheck = $aUtilBetaYN Then
		$aUtilBetaYN = "0"
		$iIniFail += 1
		$iIniError = $iIniError & "UtilBetaYN, "
	EndIf
	If $iniCheck = $aRCONResponseWaitms Then
		$aRCONResponseWaitms = 1500
		$iIniFail += 1
		$iIniError = $iIniError & "RCONResponseWaitms, "
	ElseIf $aRCONResponseWaitms < 100 Then
		$aRCONResponseWaitms = 100
	ElseIf $aRCONResponseWaitms > 3000 Then
		$aRCONResponseWaitms = 3000
	EndIf
	If $iniCheck = $aOnlinePlayerWaitms Then
		$aOnlinePlayerWaitms = 1500
		$iIniFail += 1
		$iIniError = $iIniError & "RCONResponseWaitms, "
	ElseIf $aOnlinePlayerWaitms < 100 Then
		$aOnlinePlayerWaitms = 100
	ElseIf $aOnlinePlayerWaitms > 3000 Then
		$aOnlinePlayerWaitms = 3000
	EndIf
	If $iniCheck = $aMainGUIRefreshTime Then
		$aMainGUIRefreshTime = 10
		$iIniFail += 1
		$iIniError = $iIniError & "MainGUIRefreshTime, "
	ElseIf $aMainGUIRefreshTime < 2 Then
		$aMainGUIRefreshTime = 2
	ElseIf $aMainGUIRefreshTime > 60 Then
		$aMainGUIRefreshTime = 60
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
	$aServerDirLocal = RemoveShooterGame($aServerDirLocal)
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
	$aServerRCONPort = RemoveTrailingComma($aServerRCONPort)
	$aServerAltSaveDir = RemoveTrailingComma($aServerAltSaveDir)

	If $aServerRCONImport = "no" Then
		Global $xServerRCONPort = StringSplit($aServerRCONPort, ",")
	EndIf
;~ 	If $aServerAltSaveDir = "" Then
;~ 		Global $xServerAltSaveDir = ""
;~ 	Else
;~ 		Global $xServerAltSaveDir = StringSplit($aServerAltSaveDir, ",", 2)
;~ 	EndIf
	If $sUseTwitchBotModUpdate = "yes" Or $sUseDiscordBotModUpdate = "yes" Or $sUseDiscordBotRemoteRestart = "yes" Or $sUseDiscordBotDaily = "yes" Or $sUseDiscordBotUpdate = "yes" Or $sUseTwitchBotRemoteRestart = "yes" Or $sUseTwitchBotDaily = "yes" Or $sUseTwitchBotUpdate = "yes" Or $sInGameAnnounce = "yes" Then
		$sAnnounceNotifyDaily = AddZero($sAnnounceNotifyDaily)
		$sAnnounceNotifyUpdate = AddZero($sAnnounceNotifyUpdate)
		$sAnnounceNotifyRemote = AddZero($sAnnounceNotifyRemote)
		$sAnnounceNotifyStopServer = AddZero($sAnnounceNotifyStopServer)
		$sAnnounceNotifyModUpdate = AddZero($sAnnounceNotifyModUpdate)

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
		Global $aRemoteCnt = Int($aRemoteTime[0])

		Global $sModMsgInGame = AnnounceReplaceTime($sAnnounceNotifyModUpdate, $sInGameModUpdateMessage)
		Global $sModMsgDiscord = AnnounceReplaceTime($sAnnounceNotifyModUpdate, $sDiscordModUpdateMessage)
		Global $sModMsgTwitch = AnnounceReplaceTime($sAnnounceNotifyModUpdate, $sTwitchModUpdateMessage)
		Global $aModTime = StringSplit($sAnnounceNotifyModUpdate, ",")
		Global $aModCnt = Int($aModTime[0])

		EventsCreateCalendarAndOffset()

		Global $aDelayShutdownTime = Int($aDailyTime[$aDailyCnt])
		DailyRestartOffset($bRestartHours, $bRestartMin, $aDelayShutdownTime)
	Else
		Global $aDelayShutdownTime = 0
		DailyRestartOffset($bRestartHours, $bRestartMin, $aDelayShutdownTime)
		EventsCreateCalendarAndOffset()
	EndIf

	Global $aStopServerMsgInGame = AnnounceReplaceTime($sAnnounceNotifyStopServer, $sInGameStopServerMessage)
	Global $aStopServerMsgDiscord = AnnounceReplaceTime($sAnnounceNotifyStopServer, $sDiscordStopServerMessage)
	Global $aStopServerMsgTwitch = AnnounceReplaceTime($sAnnounceNotifyStopServer, $sTwitchStopServerMessage)
	Global $aStopServerTime = StringSplit($sAnnounceNotifyStopServer, ",")
	Global $aStopServerCnt = Int($aStopServerTime[0])

	LogWrite("", " . . . Server Folder = " & $aServerDirLocal)
	LogWrite("", " . . . SteamCMD Folder = " & $aSteamCMDDir)
	;	If ($sInGameAnnounce = "yes") Or ($aTelnetCheckYN = "yes") And ($aTelnetRequired = "1") Then
	;		LogWrite("RCON/Telnet Required", "RCON/Telnet required for in-game announcements and RCON/Telnet KeepAlive checks. RCON/Telnet enabled and set to port: " & $aTelnetPort & ".")
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
			_Splash($aStartText & $aUtilName & ".ini file changed. Restarting utility.", 3000, 475)
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
;~ 		If $tUseWizard = False Then ; Kim!!!
;~ 			SplashOff()
;~ 			MsgBox(4096, "Default INI File Created", "Please Modify Default Values and Restart Program." & @CRLF & @CRLF & "IF NEW DEDICATED SERVER INSTALL:" & @CRLF & " - Once the server is installed and running," & @CRLF & _
;~ 					"Rt-Click on " & $aUtilName & " icon and shutdown server." & @CRLF & " - Then modify the server files and restart this utility.")
;~ 			LogWrite(" Default INI File Created . . Please Modify Default Values and Restart Program.")
;~ 			Run("notepad " & $sIniFile, @WindowsDir)
;~ 			_ExitUtil()
;~ 		Else
;~ 			SplashOff()
;~ 			WizardSelect()
;~ 		EndIf
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
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Grid naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###", $aNamingScheme)
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
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Max time (minutes) to wait for each mod to download (0-180) (0-No Timeout) ###", $aServerModTimeoutMin)
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
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Use scheduled backups? (yes/no) ###", $aBackupYN)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Backup days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $aBackupDays)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Backup hours (comma separated 00-23 ex.04,16) ###", $aBackupHours)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Backup minute (00-59) ###", $aBackupMin)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Output folder ###", $aBackupOutputFolder)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Redis folder (leave blank to use redis folder above or to disable) ###", $aBackupRedisFolder)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Number of backups to keep (1-999) ###", $aBackupNumberToKeep)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Max time in seconds to wait for backup to complete (30-999) ###", $aBackupTimeoutSec)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "In-Game announcement when backup initiated (Leave blank to disable) ###", $aBackupInGame)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Discord announcement when backup initiated (Leave blank to disable) ###", $aBackupDiscord)
	IniWrite($sIniFile, " --------------- BACKUP --------------- ", "Twitch announcement when backup initiated (Leave blank to disable) ###", $aBackupTwitch)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND COUNT --------------- ", "Number of custom RCON Commands to schedule (If changed, util will restart and new custom entries will be added) ###", $aEventCount)
	For $i = 0 To ($aEventCount - 1)
		FileWriteLine($sIniFile, @CRLF)
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Event Name ###", $xEventName[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command(s) to send (Separated by ~, leave BLANK to skip) ###", $xCustomRCONCmd[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-RCON Command send to (0) ALL grids or (1) Local Grids Only ###", $xCustomRCONAllorLocal[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-File to Execute (leave BLANK to skip) ###", $xEventFile[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event Months (comma separated 0-Monthly, 1-12) ###", $xEventMonths[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event Days of Month (comma separated 0-Use Weekday Below, 1-31) ###", $xEventMonthDate[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event Weekdays (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $xEventDays[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event hours (comma separated 00-23 ex.04,16) ###", $xEventHours[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Scheduled Event minute (00-59) ###", $xEventMinute[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Restart servers afterward? (with announcements below) (yes/no) ###", $xCustomRCONRestartYN[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Announcement _ minutes before reboot (comma separated 1-60) ###", $xEventAnnounceMinutes[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-In-Game Message to send (\m - minutes)(leave BLANK to skip) ###", $xEventAnnounceInGame[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Discord Message to send (\m - minutes)(leave BLANK to skip) ###", $xEventAnnounceDiscord[$i])
		IniWrite($sIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-Twitch Message to send (\m - minutes)(leave BLANK to skip) ###", $xEventAnnounceTwitch[$i])
	Next
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos? (yes/no) ###", $aDestroyWildDinosYN)
	IniWrite($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $aDestroyWildDinosDays)
	IniWrite($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos hours (comma separated 00-23 ex.04,16) ###", $aDestroyWildDinosHours)
	IniWrite($sIniFile, " --------------- SCHEDULED DESTROYWILDDINOS --------------- ", "Send DestroyWildDinos minute (0-59) ###", $aDestroyWildDinosMinute)
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
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement grid naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###", $sAnnounceNamingScheme)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires RCON) (yes/no) ###", $sInGameAnnounce)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Approximate duration to display messages in-game (seconds)? (6-30) ###", $sInGameMessageDuration)
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
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Run KeepAlive program to detect util crashes and restart it? (yes/no) ###", $aUseKeepAliveYN)
	FileWriteLine($sIniFile, @CRLF)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Use puttytel for telnet client? (yes/no)", $aUsePuttytel)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide external scripts when executed? (if yes, scripts may not execute properly) (yes/no) ###", $aExternalScriptHideYN)
;~ 	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Folder to place config files ###", $aConfigFolder)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable debug to output more log detail? (yes/no) ###", $aDebug)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " ADVANCED OPTIONS --------------- ", "Time to wait for RCON response in milliseconds (100-3000) ###", $aRCONResponseWaitms)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " ADVANCED OPTIONS --------------- ", "Time to wait for Online Players RCON response in milliseconds (100-3000) ###", $aOnlinePlayerWaitms)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " ADVANCED OPTIONS --------------- ", "Update the Main Window data every __ seconds (2-60) ###", $aMainGUIRefreshTime)
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

Func AddZero($tString)
	Local $tArray = StringSplit($tString, ",")
	If $tArray[0] < 2 Then
		$tString = "0," & $tString
	EndIf
	Return $tString
EndFunc   ;==>AddZero

Func EventsCreateCalendarAndOffset()
	; ------- EVENT SCHEDULER CALENDAR CREATION PROCESS -------
	Global $sCustomMsgInGame[$aEventCount], $sCustomMsgDiscord[$aEventCount], $aCustomTime[$aEventCount], $aCustomCnt[$aEventCount]
	Global $sCustomMsgTwitch[$aEventCount]
	Global $aMax6moAll = 0, $aMax6mo[$aEventCount]
	For $i = 0 To ($aEventCount - 1)
		If $xEventMonths[$i] = 0 Then
			Local $tMax1 = 6
		Else
			Local $tSplit1 = StringSplit($xEventMonths[$i], ",")
			Local $tMax1 = Int($tSplit1[0])
		EndIf
		If $xEventMonthDate[$i] = 0 Then
			Local $tMax2 = 1
			If $xEventDays[$i] = 0 Then
				Local $tMax3 = 31
			Else
				Local $tSplit3 = StringSplit($xEventDays[$i], ",")
				Local $tMax3 = Int($tSplit3[0]) * 4.3
			EndIf
		Else
			Local $tMax3 = 1
			Local $tSplit2 = StringSplit($xEventMonthDate[$i], ",")
			Local $tMax2 = Int($tSplit2[0])
		EndIf
		Local $tSplit4 = StringSplit($xEventHours[$i], ",")
		Local $tMax4 = Int($tSplit4[0])
		$aMax6mo[$i] = Int($tMax1 * $tMax2 * $tMax3 * $tMax4)
		$aMax6moAll += $aMax6mo[$i] + 6
	Next
	Global $xEventRestartTimes[$aEventCount][$aMax6moAll]
	Global $aEventMinute[$aEventCount], $aEventHours[$aEventCount], $aEventMonthDate[$aEventCount]

	For $i = 0 To ($aEventCount - 1)
		Local $tCount = 1
		If $xEventAnnounceInGame[$i] <> "" Then $sCustomMsgInGame[$i] = AnnounceReplaceTime($xEventAnnounceMinutes[$i], $xEventAnnounceInGame[$i])
		If $xEventAnnounceDiscord[$i] <> "" Then $sCustomMsgDiscord[$i] = AnnounceReplaceTime($xEventAnnounceMinutes[$i], $xEventAnnounceDiscord[$i])
		If $xEventAnnounceTwitch[$i] <> "" Then $sCustomMsgTwitch = AnnounceReplaceTime($xEventAnnounceMinutes[$i], $xEventAnnounceTwitch[$i])
		If $xEventAnnounceDiscord[$i] <> "" Or $xEventAnnounceInGame[$i] <> "" Or $xEventAnnounceTwitch[$i] <> "" Then
		Else
			$xEventAnnounceMinutes[$i] = 0
		EndIf
		$aCustomTime[$i] = StringSplit($xEventAnnounceMinutes[$i], ",")
		$aCustomCnt[$i] = Int(($aCustomTime[$i])[0])
		$tMonSelect = StringSplit($xEventMonths[$i], ",")
		If $xEventMonths[$i] <> 0 Then
			$tMonSelect = StringSplit($xEventMonths[$i], ",")
		EndIf
		Local $sYear = @YEAR
		Local $sMon = @MON - 1
		For $iMon = 0 To 5
			$sMon += 1
			If $sMon = 13 Then
				$sMon = 1
				$sYear += 1
			EndIf
			If $xEventMonths[$i] <> 0 Then
				For $tMon1 = 1 To $tMonSelect[0]
					If $sMon = $tMonSelect[$tMon1] Then
						Local $tRun = True
						ExitLoop
					Else
						Local $tRun = False
					EndIf
				Next
			Else
				Local $tRun = True
			EndIf
			If $tRun Then
				If $xEventMonthDate[$i] > 0 Then
					Local $sMDay = StringSplit($xEventMonthDate[$i], ",")
					Local $tMDay = ""
					For $iMDay = 1 To $sMDay[0]
						Local $sHour = StringSplit($xEventHours[$i], ",")
						Local $tHour = ""
						For $iHour = 1 To $sHour[0]
							Local $tMin = ""
							Local $sMin = StringSplit($xEventMinute[$i], ",")
							Local $sDelay = StringSplit($xEventAnnounceMinutes[$i], ",")
							For $iMin = 1 To $sMin[0]
								Local $aDateBefore[7]
								$aDateBefore[1] = $sYear
								$aDateBefore[2] = $sMon
								$aDateBefore[3] = $sMDay[$iMDay]
								$aDateBefore[4] = $sHour[$iHour]
								$aDateBefore[5] = $sMin[$iMin]
								Local $tMaxTimeRestart = (0 - $sDelay[$sDelay[0]])
								Local $aDateAfter = _DateChange("n", $tMaxTimeRestart, $aDateBefore)
								If $aDateAfter[0] = 0 Then
								Else
									$xEventRestartTimes[$i][$tCount] = $aDateAfter[0]
									$tCount += 1
									$tMin = $tMin & "," & Int($aDateAfter[5])
								EndIf
							Next
							$tHour = $tHour & "," & Int($aDateAfter[4])
						Next
						$tMDay = $tMDay & "," & Int($aDateAfter[3])
					Next
					$aEventMinute[$i] = StringTrimLeft($tMin, 1)
					$aEventHours[$i] = StringTrimLeft($tHour, 1)
					$aEventMonthDate[$i] = StringTrimLeft($tMDay, 1)
				Else
					If $xEventDays[$i] = 0 Then
						Local $tMDay = ""
						For $iMDay = 1 To 31
							Local $sHour = StringSplit($xEventHours[$i], ",")
							Local $tHour = ""
							For $iHour = 1 To $sHour[0]
								Local $tMin = ""
								Local $sMin = StringSplit($xEventMinute[$i], ",")
								Local $sDelay = StringSplit($xEventAnnounceMinutes[$i], ",")
								For $iMin = 1 To $sMin[0]
									Local $aDateBefore[7]
									$aDateBefore[1] = $sYear
									$aDateBefore[2] = $sMon
									$aDateBefore[3] = $iMDay
									$aDateBefore[4] = $sHour[$iHour]
									$aDateBefore[5] = $sMin[$iMin]
									Local $tMaxTimeRestart = (0 - $sDelay[$sDelay[0]])
									Local $aDateAfter = _DateChange("n", $tMaxTimeRestart, $aDateBefore)
									If $aDateAfter[0] = 0 Then
									Else
										$xEventRestartTimes[$i][$tCount] = $aDateAfter[0]
										$tCount += 1
									EndIf
								Next
							Next
						Next
						$aEventMinute[$i] = $xEventMinute[$i]
						$aEventHours[$i] = $xEventHours[$i]
						$aEventMonthDate[$i] = $xEventMonthDate[$i]
					Else
						Local $sDays = StringSplit($xEventDays[$i], ",")
						Local $tDays = ""
						For $iMDay = 1 To 31
							For $iDays = 1 To $sDays[0]
								If _DateToDayOfWeek($sYear, $sMon, $iMDay) = $sDays[$iDays] Then
									Local $sHour = StringSplit($xEventHours[$i], ",")
									Local $tHour = ""
									For $iHour = 1 To $sHour[0]
										Local $tMin = ""
										Local $sMin = StringSplit($xEventMinute[$i], ",")
										Local $sDelay = StringSplit($xEventAnnounceMinutes[$i], ",")
										For $iMin = 1 To $sMin[0]
											Local $aDateBefore[7]
											$aDateBefore[1] = $sYear
											$aDateBefore[2] = $sMon
											$aDateBefore[3] = $iMDay
											$aDateBefore[4] = $sHour[$iHour]
											$aDateBefore[5] = $sMin[$iMin]
											Local $tMaxTimeRestart = (0 - $sDelay[$sDelay[0]])
											Local $aDateAfter = _DateChange("n", $tMaxTimeRestart, $aDateBefore)
											If $aDateAfter[0] = 0 Then
											Else
												$xEventRestartTimes[$i][$tCount] = $aDateAfter[0]
												$tCount += 1
											EndIf
										Next
									Next
								EndIf
							Next
						Next
					EndIf
				EndIf
			EndIf
		Next
		$xEventRestartTimes[$i][0] = $tCount - 1
	Next
	Global $xEventRestartTimeAll[$aMax6moAll][2]
	Local $tCount = 0
	For $i = 0 To ($aEventCount - 1)
		For $x = 1 To ($xEventRestartTimes[$i][0])
			$xEventRestartTimeAll[$tCount][0] = $xEventRestartTimes[$i][$x]
			$xEventRestartTimeAll[$tCount][1] = $i
			$tCount += 1
		Next
	Next
	$aMax6moAll = $tCount
	ReDim $xEventRestartTimeAll[$tCount][2]
	_ArraySort($xEventRestartTimeAll, 0, 0, 0, 0)
	Global $xEventTimePastTF[$aMax6moAll]
	For $i = 0 To ($aMax6moAll - 1)
		If _DateDiff('n', $xEventRestartTimeAll[$i][0], _NowCalc()) < 0 Then
			$xEventTimePastTF[$i] = False
		Else
			$xEventTimePastTF[$i] = True
		EndIf
	Next
	Local $tTxt = _NowCalc() & " ----------- Scheduled Events -----------" & @CRLF
	For $i = 0 To ($aMax6moAll - 1)
		If $xEventTimePastTF[$i] = False Then
			Local $tYear = StringTrimRight($xEventRestartTimeAll[$i][0], 15)
			Local $tMonth1 = StringTrimRight($xEventRestartTimeAll[$i][0], 12)
			Local $tMonth = StringTrimLeft($tMonth1, 5)
			Local $tDate1 = StringTrimRight($xEventRestartTimeAll[$i][0], 9)
			Local $tDate = StringTrimLeft($tDate1, 8)
			Local $tDay1 = _DateToDayOfWeek($tYear, $tMonth, $tDate)
			Local $tDay = _DateDayOfWeek($tDay1)
;~ 		Local $tTime1 = StringTrimLeft($xEventRestartTimeAll[$i][0], 11)
;~ 		Local $tTime = StringTrimRight($tTime1, 3)
;~ 		$tTxt &= StringTrimRight($xEventRestartTimeAll[$i][0], 3) & "  Event:" & ($xEventRestartTimeAll[$i][1] + 1) & "  (" & $tTime & ") " & $tDay & @CRLF
			$tTxt &= StringTrimRight($xEventRestartTimeAll[$i][0], 3) & "  Event:" & ($xEventRestartTimeAll[$i][1] + 1) & "  " & _
					$xEventName[$xEventRestartTimeAll[$i][1]] & "  (" & $tDay & ")" & @CRLF
		EndIf
	Next
	FileDelete($aEventSaveFile)
	FileWrite($aEventSaveFile, $tTxt)
EndFunc   ;==>EventsCreateCalendarAndOffset

Func CFGLastClose()
	IniWrite($aUtilCFGFile, "CFG", "aUtilLastClose", _NowCalc())
EndFunc   ;==>CFGLastClose

Func CFGUtilReboot($i = True)
	IniWrite($sIniFile, "CFG", "aUtilReboot", $i)
EndFunc   ;==>CFGUtilReboot

Func RunUtilUpdate()
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
	If $aUseKeepAliveYN = "yes" Then IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "System use: Close AtlasServerUpdateUtilityKeepAlive? (Checked prior to restarting above Program... used when purposely shutting down above Program)(yes/no) ###", "yes")
	Local $aMsg = "Thank you for using " & $aUtilName & "." & @CRLF & "Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
			"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com"
	If @exitMethod <> 1 Then
		If ($aServerUseRedis = "yes") And ($aPIDRedisreadYetTF = False) Or ($aPIDServerReadYetTF = False) Then
			LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
			CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
			MsgBox(4096, $aUtilityVer, $aMsg, 20)
			LogWrite(" " & $aUtilityVer & " Stopped by User")
			_ExitUtil()
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
				_ExitUtil()
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
				_ExitUtil()
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
	_ExitUtil()
EndFunc   ;==>Gamercide
#EndRegion ; **** Gamercide Shutdown Protocol ****

; -----------------------------------------------------------------------------------------------------------------------

Func CloseServer($ip, $port, $pass, $tCloseRedisTF = True, $tDisableServers = False)
	If $aFirstBoot Then
		Global $aSplashCloseServer = 0
	Else
		Global $aSplashCloseServer = SplashTextOn($aUtilName & ": " & $aServerName, "Sending shutdown command to server(s) . . .", 550, 100, -1, -1, $DLG_MOVEABLE, "")
	EndIf
	$aCloseServerTF = True
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
				Local $tTime = TimerInit()
				ControlSetText($aSplashCloseServer, "", "Static1", "Sending shutdown command to server: " & _ServerNamingScheme($i, $aNamingScheme))
				GUICtrlSetData($LabelUtilReadyStatus, "Stop Server " & _ServerNamingScheme($i, $aNamingScheme))
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, "DoExit", "no", 0) ; False = wait 200ms instead of 1000ms
				LogWrite(" [Server] Sending shutdown (DoExit) command to select servers. Server " & _ServerNamingScheme($i, $aNamingScheme))
				Local $tDelay = $aServerShutdownDelay - (TimerDiff($tTime) / 1000)
				If $tDelay < 0 Then $tDelay = 0
				Sleep(1000 * $tDelay)
				If $aUseKeepAliveYN = "yes" Then KeepUtilAliveCounter()
			EndIf
		Next
	Else
		For $i = 0 To ($aServerGridTotal - 1)
			If ($xStartGrid[$i] = "yes") Then
				If ProcessExists($aServerPID[$i]) Then
					Local $tTime = TimerInit()
					$aErrorShutdown = 1
					ControlSetText($aSplashCloseServer, "", "Static1", "Sending shutdown command to server: " & _ServerNamingScheme($i, $aNamingScheme))
					GUICtrlSetData($LabelUtilReadyStatus, "Stop Server " & _ServerNamingScheme($i, $aNamingScheme))
					SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aRCONShutdownCMD, "yes", 0) ; False = wait 200ms instead of 1000ms
					Local $tTimeDiff = TimerDiff($tTime) / 1000
					Local $tDelay = $aServerShutdownDelay - $tTimeDiff
					If $tDelay < 0 Then $tDelay = 0
					Sleep(1000 * $tDelay)
					If $aUseKeepAliveYN = "yes" Then KeepUtilAliveCounter()
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
					If ProcessExists($aServerPID[$i]) Then
						Local $tTime = TimerInit()
						SendCTRLC($aServerPID[$i])
						$aErrorShutdown = 1
						SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aRCONShutdownCMD, "no", 0) ; False = wait 200ms instead of 1000ms
					EndIf
				EndIf
			Next
			If $aErrorShutdown = 1 Then
				ControlSetText($aSplashCloseServer, "", "Static1", "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . ." & @CRLF & @CRLF & "Countdown: " & ($aShutDnWait - $k))
				Local $tDelay = 1000 - (TimerDiff($tTime))
				If $tDelay < 0 Then $tDelay = 0
				Sleep($tDelay)
				If $aUseKeepAliveYN = "yes" Then KeepUtilAliveCounter()
				$aErrorShutdown = 0
			Else
				ExitLoop
			EndIf
		Next
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
				If ProcessExists($aServerPID[$i]) Then
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
					Local $tTime = TimerInit()
					$aErrorShutdown = 1
					SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aRCONShutdownCMD, "no", 0) ; False = wait 200ms instead of 1000ms
					SendCTRLC($aServerPID[$i])
				EndIf
			Next
			If $aErrorShutdown = 1 Then
				Local $tDelay = 1000 - (TimerDiff($tTime))
				If $tDelay < 0 Then $tDelay = 0
				ControlSetText($aSplashCloseServer, "", "Static1", "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . ." & @CRLF & @CRLF & "Countdown: " & ($aShutDnWait - $k))
				Sleep($tDelay)
				If $aUseKeepAliveYN = "yes" Then KeepUtilAliveCounter()
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
	For $i = 1 To $aServerGridTotal
		$t = ProcessClose("mcrcon.exe")
		If $t = 0 Then ExitLoop
	Next
	SplashOff()
EndFunc   ;==>CloseServer

; -----------------------------------------------------------------------------------------------------------------------

#Region ;****  Get data from ServerGrid.json ****
Func ImportConfig($tServerDirLocal, $tConfigFile)
;~ 	Local Const $sConfigPath = $tServerDirLocal & "\ShooterGame\" & $tConfigFile
	Local $sConfigPath = $aConfigFull
	LogWrite(" Importing settings from " & $tConfigFile, " Importing settings from " & $sConfigPath)
	Global $xServergridx[$aServersMax]
	Global $xServergridy[$aServersMax]
	Global $xServerport[$aServersMax]
	Global $xServergameport[$aServersMax]
	Global $xServerseamlessDataPort[400]
	Global $xServerIP[$aServersMax]
	Local $sFileExists = FileExists($sConfigPath)
	If $sFileExists = 0 Then
		$sConfigPath = $aFolderTemp & "ServerGrid.json"
		Local $tTxt = "{" & @CRLF & _
				'  "WorldFriendlyName": "AtlasServerUpdateUtility Temp ServerGrid.json",' & @CRLF & _
				'  "ModIDs": "",' & @CRLF & _
				'  "totalGridsX": 1,' & @CRLF & _
				'  "totalGridsY": 1,' & @CRLF & _
				'  "servers": [' & @CRLF & _
				'    {' & @CRLF & _
				'      "gridX": 0,' & @CRLF & _
				'      "gridY": 0,' & @CRLF & _
				'      "ip": "1.2.3.4",' & @CRLF & _
				'      "name": "AtlasServerUpdateUtility Temp 1",' & @CRLF & _
				'      "port": 48011,' & @CRLF & _
				'      "gamePort": 48015,' & @CRLF & _
				'      "seamlessDataPort": 48018,' & @CRLF & _
				'      "isHomeServer": true,' & @CRLF & _
				"    }" & @CRLF & "  ]," & @CRLF & _
				'}' & @CRLF
		FileDelete($sConfigPath)
		FileWrite($sConfigPath, $tTxt)
		LogWrite(" !!! ERROR !!! Could not find " & $sConfigPath)
		SplashOff()
		Local $aMsg = "Could not find " & $sConfigPath & "." & @CRLF & _
				"(This is normal for New Install) " & @CRLF & @CRLF & _
				"Do you wish to continue with installation?" & @CRLF & @CRLF & _
				"Click (YES) to run Setup Wizard (recommended)." & @CRLF & _
				"Click (NO) to continue using manual config editing." & @CRLF & _
				"Click (CANCEL) to exit utility."
		$tMB = MsgBox($MB_YESNOCANCEL, "ServerGrid.json file Not Found", $aMsg, 60)
		If $tMB = 6 Or $tMB = -1 Then ; YES or Timeout
			SplashOff()
			WizardSelect()
		ElseIf $tMB = 7 Then ; NO
			_Splash("Using temporary settings to complete the download and installation of " & $aGameName & " dedicated server." & @CRLF & @CRLF & _
					"Once installation is complete, please exit " & $aUtilName & ", copy your files into the server folder, and rerun " & $aUtilName & ".", 9000, 500, 175)
			$aSplashStartUp = _Splash($aStartText, 0, 475)
		ElseIf $tMB = 2 Then ; CANCEL
			LogWrite(" !!! ERROR !!! Could not find " & $sConfigPath & ". Program terminated by user.")
			_ExitUtil()
		EndIf
	EndIf
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
	Global $xServerNames = _StringBetween($sConfigReadServer, @CRLF & "      """ & $kServerNames & """: """, """," & @CRLF & "      ""port")
	For $i = 0 To (UBound($xServerNames) - 1)
		$xServerNames[$i] = ReplaceVerticalBarCRwithSlash($xServerNames[$i])
	Next
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
;~ 	EndIf
	If $aServerModList = "" Then
		If $aServerModYN = "yes" Then
			LogWrite(" [MOD] NOTICE: ""Use this util to install mods and check for mod updates""=yes in " & $aUtilName & ".ini but no mods were listed in " & $aConfigFile & ".")
		EndIf
		$aServerModYN = "no"
	Else
		$xServerModList = StringSplit($aServerModList, ",")
		For $i = 0 To (UBound($xServerModList) - 1)
			If $xServerModList[$i] = "" Then
				Local $aMsg = "NOTICE! Mod list error in ServerGrid.json file." & @CRLF & @CRLF & _
						"Check the ModIDs line for an extra comma before the ""," & @CRLF & "Proper example: ""ModIDs"": ""1234567890""," & @CRLF & @CRLF & _
						"Click (YES) to exit utility and open ServerGrid.json file in Notepad." & @CRLF & _
						"Click (NO) or (CANCEL) to continue (Mod updater will error but continue to work)"
				SplashOff()
				$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 60)
				If $tMB = 6 Then ; YES
					ShellExecute($sConfigPath)
;~ 					Run("notepad.exe " & $sConfigPath)
					_ExitUtil()
				Else
					$aSplashStartUp = _Splash($aStartText & "Continuing startup.", 0, 475)
				EndIf
			EndIf
		Next
	EndIf
	Global $aServerGridTotal = Int($xtotalGridsX) * Int($xtotalGridsY)
EndFunc   ;==>ImportConfig
#EndRegion ;****  Get data from ServerGrid.json ****

Func _Splash($tTxt, $tTime = 0, $tWidth = 400, $tHeight = 110)
	Local $tPID = SplashTextOn($aUtilName, $tTxt, $tWidth, $tHeight, -1, -1, $DLG_MOVEABLE, "")
	If $tTime > 0 Then
		Sleep($tTime)
		SplashOff()
	EndIf
	Return $tPID
EndFunc   ;==>_Splash

Func _ExitUtil($tSleepYN = True)
	If $aUseKeepAliveYN = "yes" Then
		IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "System use: Close AtlasServerUpdateUtilityKeepAlive? (Checked prior to restarting above Program... used when purposely shutting down above Program)(yes/no) ###", "yes")
		If $tSleepYN Then _Splash("Shutting down KeepAlive utility.", 2500)
	EndIf
	If ProcessExists($aPIDKeepAlive) Then ProcessClose($aPIDKeepAlive)
	Exit
EndFunc   ;==>_ExitUtil

Func _CheckForDuplicatePorts()
	FileDelete($aDuplicateErrorFile)
	Global $aDupError = False
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
		ShellExecute($aConfigFull)
;~ 		Run("notepad.exe " & $aConfigFull)
	Else
		_Splash("No duplicate ports found.", 2000)
	EndIf
EndFunc   ;==>_CheckForDuplicatePorts

Func _ConfigCheckForDuplicates($tArray, $tParameter)
	Local $tTxt = ""
	Local $aArray = _ArrayDuplicates($tArray)
	If UBound($aArray) > 0 Then
		For $i = 0 To (UBound($aArray) - 1)
			If $aArray[$i] <> "" Then
				$tTxt &= $tParameter & ":" & $aArray[$i] & @CRLF
				$aDupError = True
			EndIf
		Next
	EndIf
	Return $tTxt
EndFunc   ;==>_ConfigCheckForDuplicates

Func _ArrayDuplicates($aArray, $tAddCountToArrayZero = False) ; Modified version of Melba23's script: https://www.autoitscript.com/forum/topic/164666-get-duplicate-from-array/
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
		_ExitUtil()
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
				_ExitUtil()
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
						_ExitUtil()
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
	Global $aGridIniTitle[4]
	Local $tServerGridExtraCMD = False
	$aGridIniTitle[0] = " --------------- RUN THE FOLLOWING GRID SERVER(S) (yes/no) --------------- "
	$aGridIniTitle[1] = " --------------- LOCAL GRID SERVER(S) (yes-Local, no-Remote) (yes/no) --------------- "
	$aGridIniTitle[2] = " --------------- EXTRA COMMANDLINE PARAMETERS PER GRID SERVER --------------- "
	$aGridIniTitle[3] = " --------------- ADDITIONAL STARTUP DELAY (in seconds) --------------- "
	Local $iIniError = ""
	Local $iIniFail = 0
	Local $iniCheck = ""
	Local $aChar[3]
	For $i = 1 To 13
		$aChar[0] = Chr(Random(97, 122, 1)) ;a-z
		$aChar[1] = Chr(Random(48, 57, 1)) ;0-9
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
	For $i = 0 To ($aServerGridTotal - 1)
		$xGridStartDelay[$i] = IniRead($sGridFile, $aGridIniTitle[3], "Additional startup delay Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (0-600)", $iniCheck)
		If $xGridStartDelay[$i] < 0 Then
			$xGridStartDelay[$i] = 0
		EndIf
		If $xGridStartDelay[$i] > 600 Then
			$xGridStartDelay[$i] = 600
		EndIf
		If $iniCheck = $xGridStartDelay[$i] Then
			$xGridStartDelay[$i] = 0
			$iIniFail += 1
			;$iIniError = $iIniError & $xStartGrid[$i] & ", "
		EndIf
	Next
	If $iIniFail > 0 Or $sGridIniReWrite Then
		GridFileStartCheck($sGridFile, $iIniFail, $iIniError, $tWizardTF)
	EndIf
EndFunc   ;==>GridStartSelect
Func GridFileStartCheck($sGridFile, $iIniFail, $tIniError, $tWizardTF = False)
	If FileExists($sGridFile) Then
		Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
		Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
		FileMove($aGridSelectFile, $tFile, 1)
		UpdateGridSelectINI($sGridFile)
		LogWrite(" " & $sGridFile & " needs updating. Found " & $iIniFail & " server change(s). Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		;		LogWrite(" " & $sGridFile & " needs updating. Parameters missing: " & $iIniError)
		If $xServerIP[0] <> "1.2.3.4" Then
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
				_ExitUtil()
			EndIf
		EndIf
	Else
		UpdateGridSelectINI($sGridFile)
		If $tWizardTF Or $xServerIP[0] = "1.2.3.4" Then
		Else
			SplashOff()
			Run("notepad " & $sGridFile, @WindowsDir)
			MsgBox(4096, $aUtilityVer, "Default GridStartSelect.ini file created." & @CRLF & @CRLF & "If you plan to run all grid servers, no change is needed. " & @CRLF & @CRLF & "If you want to only run selected grid servers or have remote servers, please modify the default values and restart program.")
			LogWrite(" Default " & $sGridFile & " file created. If you want to only run selected grid server(s), please modify the default values and restart program.")
			_ExitUtil()
		EndIf
	EndIf
EndFunc   ;==>GridFileStartCheck
Func UpdateGridSelectINI($sGridFile)
	For $i = 0 To ($aServerGridTotal - 1)
		IniWrite($sGridFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", $xStartGrid[$i])
	Next
	FileWriteLine($sGridFile, @CRLF)
	For $i = 0 To ($aServerGridTotal - 1)
		IniWrite($sGridFile, $aGridIniTitle[1], "Is Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") Local (yes/no)", $xLocalGrid[$i])
	Next
	FileWriteLine($sGridFile, @CRLF)
	FileWriteLine($sGridFile, @CRLF)
	FileWriteLine($sGridFile, "! Extra commandline parameters used IN ADDITION to the existing parameters set in the " & $aUtilName & ".ini file.")
	FileWriteLine($sGridFile, "! Existing parameters: " & $aServerExtraCMD)
	For $i = 0 To ($aServerGridTotal - 1)
		IniWrite($sGridFile, $aGridIniTitle[2], "Add to Commandline for Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ")", $xServerGridExtraCMD[$i])
	Next
	FileWriteLine($sGridFile, @CRLF)
	FileWriteLine($sGridFile, @CRLF)
	FileWriteLine($sGridFile, "! Additional startup delay (in seconds) per grid.  Base delay: " & $aServerStartDelay & " seconds as set in " & $aUtilName & ".ini file.")
	For $i = 0 To ($aServerGridTotal - 1)
		IniWrite($sGridFile, $aGridIniTitle[3], "Additional startup delay Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (0-600)", $xGridStartDelay[$i])
	Next
EndFunc   ;==>UpdateGridSelectINI
#EndRegion ;**** Start Server Selection ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Fail Count Announce ****
Func FailCountRun()
	LogWrite(" [--== CRITICAL ERROR! ==-- ] The " & $aGameName & " Dedicated Server (" & $aServerEXE & ") failed to start at least twice within 1 minute. Please check " & $aGameName & " config files and " & $aUtilName & ".ini file")
	CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, True, False)
	MsgBox($MB_OK, $aUtilityVer, "[CRITICAL ERROR!] The " & $aGameName & " Dedicated Server (" & $aServerEXE & ") failed to start at least twice within 1 minute. " & @CRLF & @CRLF & "Please check " & $aGameName & " config files and " & $aUtilName & ".ini file and restart " & $aUtilName & ".")
	_ExitUtil()
EndFunc   ;==>FailCountRun
#EndRegion ;**** Fail Count Announce ****

Func KeepUtilAliveCounter()
	IniWrite($aUtilCFGFile, "CFG", "aCFGKeepUtilAliveTime", _NowCalc())
EndFunc   ;==>KeepUtilAliveCounter
#Region ;**** Function to Send Message to Discord ****

Func SendDiscordMsg($sHookURLs, $sBotMessage, $sBotName = "", $sBotTTS = False, $sBotAvatar = "", $aServerPID = "0")
	If FileExists($aDiscordSendWebhookEXE) = 0 Then _DownloadAndExtractFile("DiscordSendWebhook", "http://www.phoenix125.com/share/atlas/DiscordSendWebhook.zip", "https://github.com/phoenix125/DiscordSendWebhook/releases/download/DiscordSendWebhook/DiscordSendWebhook.zip", $tSplash)
	FileDelete($aFolderTemp & "Discord.txt")
	$tCMD = @ComSpec & " /c " & """""" & $aDiscordSendWebhookEXE & """ """ & $sHookURLs & """ """ & $sBotMessage & """ """ & $sBotName & """ > """ & $aFolderTemp & "Discord.txt"""""
	Local $mOut = Run($tCMD, $aFolderTemp, @SW_HIDE)
	$tErr = ProcessWaitClose($mOut, 4)
	If $tErr = 0 Then
		$aRCONError = True
	EndIf
	$tFile = FileOpen($aFolderTemp & "Discord.txt")
	$tcrcatch = FileRead($tFile)
	FileClose($tFile)
	If (StringInStr($tcrcatch, "200") > 0) Or (StringInStr($tcrcatch, "204") > 0) Then
		LogWrite(" [Discord] Message sent: " & $sBotMessage, " [Discord] Message sent:[" & $tCMD & "] | Response:[" & ReplaceCRLF($tcrcatch) & "]")
	Else
		LogWrite(" [Discord] ERROR!!! Send message failed using DiscordSendWebhook.exe: " & $sBotMessage, " [Discord] ERROR!!! Send message failed using DiscordSendWebhook.exe: " & $sBotMessage & ". Response: " & ReplaceCRLF($tcrcatch))
		Local $tObjErrFunc = $aObjErrFunc
		$aObjErrFunc = "Discord"
		Local $sJsonMessage = '{"content" : "' & $sBotMessage & '", "username" : "' & $sBotName & '", "tts" : "' & $sBotTTS & '", "avatar_url" : "' & $sBotAvatar & '"}'
		Local $oHTTPOST = ObjCreate("WinHttp.WinHttpRequest.5.1")
		$oHTTPOST.Open("POST", StringStripWS($sHookURLs, 3) & "?wait=true", False)
		$oHTTPOST.Option(4) = 0x3300 ; ignore all SSL errors
		$oHTTPOST.SetRequestHeader("Content-Type", "multipart/form-data")
		$oHTTPOST.Send($sJsonMessage)
		Local $oStatusCode = $oHTTPOST.Status
		Local $oReceived = $oHTTPOST.ResponseText
		LogWrite(" [Discord] Message sent using WinHttp.WinHttpRequest.5.1 object: " & $sBotMessage, " [Discord] Message sent using WinHttp.WinHttpRequest.5.1 object. Status Code {" & $oStatusCode & "} " & "Message Response: " & $oReceived)
		$aObjErrFunc = $tObjErrFunc
	EndIf
	Return $tcrcatch
EndFunc   ;==>SendDiscordMsg

#cs  ; Old script - worked fine for most
	Func _Discord_ErrFunc($oError)
	LogWrite(" [Discord] Error: 0x" & Hex($oError.number) & " While Sending Discord Bot Message.")
	EndFunc   ;==>_Discord_ErrFunc

	Func SendDiscordMsg($sHookURLs, $sBotMessage, $sBotName = "", $sBotTTS = False, $sBotAvatar = "", $aServerPID = "0")
	Local $oErrorHandler = ObjEvent("AutoIt.Error", "_Discord_ErrFunc")
	Local $sJsonMessage = '{"content" : "' & $sBotMessage & '", "username" : "' & $sBotName & '", "tts" : "' & $sBotTTS & '", "avatar_url" : "' & $sBotAvatar & '"}'
	Local $oHTTPOST = ObjCreate("WinHttp.WinHttpRequest.5.1")
	Local $aHookURLs = StringSplit($sHookURLs, ",")
	For $i = 1 To $aHookURLs[0]
	$oHTTPOST.Open("POST", StringStripWS($aHookURLs[$i], 2) & "?wait=true", False)
	$oHTTPOST.SetRequestHeader("Content-Type", "application/json")
	$oHTTPOST.Send($sJsonMessage)
	Local $oStatusCode = $oHTTPOST.Status
	Local $sResponseText = ""
	If Not $xDebug Then
	FileWriteLine($aLogFile, _NowCalc() & " [Discord Bot] Message sent: " & $sBotMessage)
	Else
	$sResponseText = "Message Response: " & $oHTTPOST.ResponseText
	FileWriteLine($aLogFile, _NowCalc() & " [Discord Bot] Message Status Code {" & $oStatusCode & "} " & $sResponseText)
	EndIf
	Next
	EndFunc
#ce  ; Old script - worked fine for most
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
			LogWrite("", " [RCON In-Game Message] Server (" & _ServerNamingScheme($i, $aNamingScheme) & ") " & $aMCRCONcmd)
			Run($aMCRCONcmd, @ScriptDir, @SW_HIDE)
		EndIf
	Next
	LogWrite(" [RCON In-Game Message Sent] " & $mMessage, "no") ; "no" = do not write to debug log file
EndFunc   ;==>SendInGame
#EndRegion ;**** Send In-Game Message via MCRCON ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Send RCON Command via MCRCON ****
Func SendRCON($mIP, $mPort, $mPass, $mCommand, $mLogYN = "yes", $mWaitms = 1500)
	$aRCONError = False
	If StringInStr($mCommand, "broadcast") > 0 Then
		Local $tTxt = StringTrimLeft($mCommand, 10)
		Local $tTxt1 = SendMessageAddDuration($tTxt)
		$mCommand = "broadcast " & $tTxt1
	EndIf
	If $aServerRCONIP = "" Then
;~ 		Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
		Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	Else
;~ 		Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $aServerRCONIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
		Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -H ' & $aServerRCONIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	EndIf
	Local $mOut = Run($aMCRCONcmd, @ScriptDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
	If $mWaitms > 0 Then
		Local $tTimer1 = TimerInit()
		Local $tExit = False
		While ProcessExists($mOut) And $tExit = False
			Sleep(50)
			If TimerDiff($tTimer1) > $mWaitms Then $tExit = True
		WEnd
		ProcessClose($mOut)
		Local $tcrcatch = StdoutRead($mOut)
		If $aErrorShutdown = 0 Then
			If $mLogYN = "yes" Then
				If $aServerRCONIP = "" Then
					LogWrite(" [RCON] IP: " & $mIP & ". Port:" & $mPort & ". Command:" & $mCommand, " [RCON] " & $aMCRCONcmd & ", Response:" & ReplaceCRLF($tcrcatch))
				Else
					LogWrite(" [RCON] IP: " & $aServerRCONIP & ". Port:" & $mPort & ". Command:" & $mCommand, " [RCON] " & $aMCRCONcmd & ", Response:" & ReplaceCRLF($tcrcatch))
				EndIf
			ElseIf $mLogYN = "players" Then
				If $aRCONError = True Then LogWrite("", " [RCON] ERROR! " & $aMCRCONcmd & ", Response:" & ReplaceCRLF($tcrcatch))
			Else
				LogWrite("", " [RCON] " & $aMCRCONcmd & ", Response:" & ReplaceCRLF($tcrcatch))
			EndIf
		EndIf
		Return $tcrcatch
	Else
		If $mLogYN = "yes" Then
			If $aServerRCONIP = "" Then
				LogWrite(" [RCON] IP: " & $mIP & ". Port:" & $mPort & ". Command:" & $mCommand, " [RCON] " & $aMCRCONcmd)
			Else
				LogWrite(" [RCON] IP: " & $aServerRCONIP & ". Port:" & $mPort & ". Command:" & $mCommand, " [RCON] " & $aMCRCONcmd)
			EndIf
		EndIf
		Return "Did not wait for response."
	EndIf
EndFunc   ;==>SendRCON
#EndRegion ;**** Send RCON Command via MCRCON ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Functions to Check for Update ****

Func UpdateCheck($tAsk, $tSplash = 0, $tShow = True)
	If $aCheckForUpdate = "no" And $tAsk = False Then
		LogWrite(" [Update] " & $aGameName & " update check disabled.", " [Update] " & $aGameName & " update check disabled. To enable, change [Check for server updates? (yes/no) ###=no] in " & $aUtilName & ".ini file.")
		Return "skipped"
	EndIf
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
				_Splash($tTxt)
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
				_Splash($tTxt)
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
			_Splash($tTxt)
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
				If $tMB = 6 Then ; YES
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
					_Splash("Utility update check canceled by user." & @CRLF & "Resuming utility . . .")
				EndIf
			Else
				If $aFirstBoot Then
					Local $tTxt = $aStartText & "Server is Out of Date! Updating server." & @CRLF & "Installed Version: " & $aInstalledVersion[1] & ", Latest: " & $aLatestVersion[1]
					If $tSplash > 0 Then
						ControlSetText($tSplash, "", "Static1", $tTxt)
					Else
						_Splash($tTxt)
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
		_Splash("Something went wrong retrieving Latest & Installed Versions." & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 0, 500, 125)
		$bUpdateRequired = True
		$aSteamUpdateNow = True
		$aUpdateVerify = "yes"
		RunExternalScriptUpdate()
		$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
		SteamcmdDelete($aSteamCMDDir)
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)

	ElseIf Not $aInstalledVersion[0] Then
		LogWrite(" [Update] Something went wrong retrieving Installed Version. Running update with -validate. (This is normal for new install)")
		_Splash("Something went wrong retrieving Installed Version." & @CRLF & "(This is normal for new install)" & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 0, 450, 175)
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
			_Splash("Utility update check canceled by user." & @CRLF & "Resuming utility . . .", 2000)
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

Func BackupCheck($sWDays, $sHours, $sMin)
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
EndFunc   ;==>BackupCheck

Func _BackupGame($tMinimizeTF = True)
	SetStatusBusy("Backup starting")
	If $aBackupInGame <> "" Then
		LogWrite(" [Backup] In-Game Announcement sent: " & $aBackupInGame)
		For $i = 0 To ($aServerGridTotal - 1)
			If ($xStartGrid[$i] = "yes") And ProcessExists($aServerPID[$i]) Then
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aBackupInGame, "no", 0)
			EndIf
		Next
	EndIf
	If $aBackupDiscord <> "" Then
		SendDiscordMsg($sDiscordWebHookURLs, $sDiscordServersUpMessage, $aBackupDiscord, $bDiscordBotUseTTS, $sDiscordBotAvatar)
	EndIf
	If $aBackupTwitch <> "" Then
		TwitchMsgLog($aBackupTwitch)
	EndIf
	_DownloadAndExtractFile("7z", "http://www.phoenix125.com/share/atlas/7z.zip", "https://github.com/phoenix125/AtlasServerUpdateUtility/releases/download/Latest/7z.zip", 0, $aFolderTemp, "7z.dll")
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tName = $aGameName & "_Backup_" & $tTime & ".zip"
	Local $tFull = $aBackupOutputFolder & "\" & $tName
	Local $tRedis = ""
	If $aBackupRedisFolder = "" Then
		If $aServerRedisFolder = "" Then
			$tRedis = " """ & $aServerDirLocal & $aServerRedisDir & """"
		Else
			$tRedis = " """ & $aServerRedisFolder & """"
		EndIf
	Else
		$tRedis = " """ & $aBackupRedisFolder & """"
	EndIf
	Local $tCMD = """" & $aFolderTemp & "7z"" a -spf -r -tzip -ssw -x!ocean.*.atlas """ & $tFull & """ """ & $aServerDirLocal & "\ShooterGame\Saved\"" """ & $aServerDirLocal & "\ShooterGame\Server*.json""" & $tRedis & _
			" """ & $aGridSelectFile & """ """ & $aIniFile & """"
	LogWrite(" [Backup] Backup started. File:" & $tName, " [Backup] Backup initiated: " & $tCMD)
	If $tMinimizeTF Then
		Local $tPID = Run($tCMD, "", @SW_MINIMIZE)
	Else
		Local $tPID = Run($tCMD, "")
	EndIf
	Local $tTimer1 = TimerInit()
	Local $tExit = False
	While ProcessExists($tPID) And $tExit = False
		SetStatusBusy("Backup Cntdn " & Int($aBackupTimeoutSec - TimerDiff($tTimer1) / 1000))
		Sleep(950)
		If $aUseKeepAliveYN = "yes" Then KeepUtilAliveCounter()
		If TimerDiff($tTimer1) > ($aBackupTimeoutSec * 1000) Then $tExit = True
	WEnd
	If ProcessExists($tPID) Then
		ProcessClose($tPID)
		LogWrite("", " [Backup] ERROR! Backup timed out.")
	Else
		LogWrite("", " [Backup] Backup completed successfully.")
	EndIf
	If $tMinimizeTF = False Then _Splash("Backup completed successfully." & @CRLF & @CRLF & $tFull, 3000)
	PurgeBackups()
EndFunc   ;==>_BackupGame

Func PurgeBackups()
	Local $aPurgeBackups = $aFolderTemp & $aUtilName & "_PurgeBackups.bat"
	Local $sFileExists = FileExists($aPurgeBackups)
	If $sFileExists = 1 Then
		FileDelete($aPurgeBackups)
	EndIf
	FileWriteLine($aPurgeBackups, "for /f ""tokens=* skip=" & $aBackupNumberToKeep & """ %%F in " & Chr(40) & "'dir """ & $aBackupOutputFolder & "\" & $aGameName & "_Backup_*.zip"" /o-d /tc /b'" & Chr(41) & " do del """ & $aBackupOutputFolder & "\%%F""")
	LogWrite("", " Deleting Backups > " & $aBackupNumberToKeep & " in folder " & $aBackupOutputFolder)
	Run($aPurgeBackups, "", @SW_HIDE)
EndFunc   ;==>PurgeBackups

Func TwitchMsgLog($sT_Msg)
	Local $aTwitchIRC = SendTwitchMsg($sTwitchNick, $sChatOAuth, $sTwitchChannels, $sT_Msg)
	If $aTwitchIRC[0] Then
		LogWrite(" [Twitch] Successfully Connected to Twitch IRC")
		If $aTwitchIRC[1] Then
			LogWrite(" [Twitch] Username and OAuth Accepted. [" & $aTwitchIRC[2] & "]")
			If $aTwitchIRC[3] Then
				LogWrite(" [Twitch] Successfully sent ( " & $sT_Msg & " ) to all Channels")
			Else
				LogWrite(" [Twitch] ERROR | Failed sending message ( " & $sT_Msg & " ) to one or more channels")
			EndIf
		Else
			LogWrite(" [Twitch] ERROR | Username and OAuth Denied [" & $aTwitchIRC[2] & "]")
		EndIf
	Else
		LogWrite(" [Twitch] ERROR | Could not connect to Twitch IRC. Is this URL or port blocked? [irc.chat.twitch.tv:6667]")
	EndIf
EndFunc   ;==>TwitchMsgLog

Func SendTwitchMsg($sT_Nick, $sT_OAuth, $sT_Channels, $sT_Message)
	Local $aTwitchReturn[4] = [False, False, "", False]
	Local $sTwitchIRC = TCPConnect(TCPNameToIP("irc.chat.twitch.tv"), 6667)
	If @error Then
		TCPCloseSocket($sTwitchIRC)
		Return $aTwitchReturn
	Else
		$aTwitchReturn[0] = True ;Successfully Connected to irc
		TCPSend($sTwitchIRC, "PASS " & StringLower($sT_OAuth) & @CRLF)
		TCPSend($sTwitchIRC, "NICK " & StringLower($sT_Nick) & @CRLF)
		Local $sTwitchReceive = ""
		Local $iTimer1 = TimerInit()
		While TimerDiff($iTimer1) < 1000
			$sTwitchReceive &= TCPRecv($sTwitchIRC, 1)
			If @error Then ExitLoop
		WEnd
		Local $aTwitchReceiveLines = StringSplit($sTwitchReceive, @CRLF, 1)
		$aTwitchReturn[2] = $aTwitchReceiveLines[1] ;Status Line. Accepted or Not
		If StringRegExp($aTwitchReceiveLines[$aTwitchReceiveLines[0] - 1], "(?i):tmi.twitch.tv 376 " & $sT_Nick & " :>") Then
			$aTwitchReturn[1] = True ;Username and OAuth was accepted. Ready for PRIVMSG
			Local $aTwitchChannels = StringSplit($sT_Channels, ",")
			For $i = 1 To $aTwitchChannels[0]
				TCPSend($sTwitchIRC, "PRIVMSG #" & StringLower($aTwitchChannels[$i]) & " :" & $sT_Message & @CRLF)
				If @error Then
					TCPCloseSocket($sTwitchIRC)
					$aTwitchReturn[3] = False ;Check that all channels succeeded or none
					Return $aTwitchReturn
					ExitLoop
				Else
					$aTwitchReturn[3] = True ;Check that all channels succeeded or none
					If $aTwitchChannels[0] > 17 Then ;This is to make sure we don't break the rate limit
						Sleep(1600)
					Else
						Sleep(100)
					EndIf
				EndIf
			Next
			TCPSend($sTwitchIRC, "QUIT")
			TCPCloseSocket($sTwitchIRC)
		Else
			Return $aTwitchReturn
		EndIf
	EndIf
	Return $aTwitchReturn
EndFunc   ;==>SendTwitchMsg

Func RCONCustomTimeCheck($wDate, $sWDays, $sHours, $sMin)
	Local $iDate = -1
	Local $iDay = -1
	Local $iHour = -1
	Local $aDate = StringSplit($wDate, ",")
	Local $aDays = StringSplit($sWDays, ",")
	Local $aHours = StringSplit($sHours, ",")
	If $wDate = "0" Then
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
	Else
		For $d = 1 To $aDate[0]
			$iDate = StringStripWS($aDate[$d], 8)
			If Int($iDate) = Int(@MDAY) Or Int($iDate) = 0 Then
				For $h = 1 To $aHours[0]
					$iHour = StringStripWS($aHours[$h], 8)
					If Int($iHour) = Int(@HOUR) And Int($sMin) = Int(@MIN) Then
						Return True
					EndIf
				Next
			EndIf
		Next
	EndIf
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
				_Splash($tTxt)
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
				_Splash($tTxt)
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
			_Splash($aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for DAILY external script to finish . . .")
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
			_Splash($aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for FIRST ANNOUNCEMENT external script to finish . . .")
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
			_Splash($aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for REMOTE RESTART external script to finish . . .")
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
			_Splash($aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for Script When Restarting For Server Update external script to finish . . .")
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
			_Splash($aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Waiting for Script When Restarting For MOD Update external script to finish . . .")
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
				_ExitUtil()
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
				_ExitUtil()
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
				_ExitUtil()
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
				_ExitUtil()
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
				_ExitUtil()
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
				_ExitUtil()
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
				_ExitUtil()
			Else
				$aExternalScriptModYN = "no"
				LogWrite(" External MOD UPDATE restart script execution disabled - Could not find " & $aExternalScriptModDir & "\" & $aExternalScriptModFileName)
			EndIf
		EndIf
	EndIf
	For $i = 0 To ($aEventCount - 1)
		If $xEventFile[$i] <> "" Then
			Local $sFileExists = FileExists($xEventFile[$i])
			If $sFileExists = 0 Then
				SplashOff()
				$xEventFile[$i] = FileOpenDialog("WARNING!!! Scheduled File " & $i & " to Execute not found", @ScriptDir, "All (*.*)", 3, "ScheduledFile" & $i & ".bat")
				IniWrite($aIniFile, " --------------- SCHEDULED EVENT OR RCON COMMAND " & ($i + 1) & " --------------- ", ($i + 1) & "-File to Execute (leave BLANK to skip) ###", $xEventFile[$i])
				Global $aSplashStartUp = _Splash($aStartText, 0, 475, 110)
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

Func _DateChange($tType, $tDiff, $tDateBefore) ; By Phoenix125.com
	#cs
		Time interval to be used:
		D - Add/subtract days to/from the specified date
		M - Add/subtract months to/from the specified date
		Y - Add/subtract years to/from the specified date
		w - Add/subtract Weeks to/from the specified date
		h - Add/subtract hours to/from the specified date
		n - Add/subtract minutes to/from the specified date
		s - Add/subtract seconds to/from the specified date
	#ce
	If $tDateBefore[0] = "" Then
		If $tDateBefore[1] = "" Then $tDateBefore[1] = @YEAR
		If $tDateBefore[2] = "" Then $tDateBefore[2] = @MON
		If $tDateBefore[3] = "" Then $tDateBefore[3] = @MDAY
		If $tDateBefore[4] = "" Then $tDateBefore[4] = @HOUR
		If $tDateBefore[5] = "" Then $tDateBefore[5] = @MIN
		If $tDateBefore[6] = "" Then $tDateBefore[6] = "00"
		Local $tTime1 = $tDateBefore[1] & "/" & $tDateBefore[2] & "/" & $tDateBefore[3] & " " & $tDateBefore[4] & ":" & $tDateBefore[5] & ":" & $tDateBefore[6]
	Else
		$tTime1 = $tDate[0]
	EndIf
	Local $tTime2 = _DateAdd($tType, $tDiff, $tTime1)
	Local $tDateAfter[7]
	$tDateAfter[0] = $tTime2
	$tDateAfter[1] = StringLeft($tTime2, 4)
	$tDateAfter[2] = StringMid($tTime2, 6, 2)
	$tDateAfter[3] = StringMid($tTime2, 9, 2)
	$tDateAfter[4] = StringMid($tTime2, 12, 2)
	$tDateAfter[5] = StringMid($tTime2, 15, 2)
	$tDateAfter[6] = StringMid($tTime2, 18, 2)
	Return $tDateAfter
EndFunc   ;==>_DateChange

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
Func AnnounceReplaceModID($tMsg0, $tTime0, $tMsg)
	If $aFirstModBoot Then
		Return $tMsg0
	Else
		Local $tTime2 = -1
		Local $tTime3 = StringSplit($tTime0, ",")
		Local $tMsg1 = $tTime3
		For $tTime2 = 1 To $tTime3[0]
			$tMsg1[$tTime2] = StringReplace($tMsg0[$tTime2], "\x", $tMsg)
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
		$aString = StringTrimRight($aString, 1)
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

Func RemoveTrailingComma($aString)
	Local $bString = StringRight($aString, 1)
	If $bString = "," Then
		$cString = StringTrimRight($aString, 1)
	Else
		$cString = $aString
	EndIf
	Return $cString
EndFunc   ;==>RemoveTrailingComma

Func RemoveShooterGame($aString)
	Local $bString = StringRight($aString, 12)
	If $bString = "\ShooterGame" Then
		$cString = StringTrimRight($aString, 12)
	Else
		$cString = $aString
	EndIf
	Return $cString
EndFunc   ;==>RemoveShooterGame

Func CloseTCP($tIP = $aRemoteRestartIP, $tPort = $aRemoteRestartPort, $tSplash = 0)
	Local $tTxt = "Shutting down Remote Restart." & @CRLF & @CRLF
	If $tSplash > 0 Then
		ControlSetText($tSplash, "", "Static1", $tTxt)
	Else
		_Splash($tTxt)
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

Func PassCheck($sPass, $sPassString) ;**** PassCheck - Checks if received password matches any of the known passwords ****
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

Func ObfPass($sObfPassString) ;**** ObfPass - Obfuscates password string for logging
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

Func _TCP_Server_ClientIP($hSocket) ;**** Function to get IP from Restart Client ****
	Local $pSocketAddress, $aReturn
	$pSocketAddress = DllStructCreate("short;ushort;uint;char[8]")
	$aReturn = DllCall("ws2_32.dll", "int", "getpeername", "int", $hSocket, "ptr", DllStructGetPtr($pSocketAddress), "int*", DllStructGetSize($pSocketAddress))
	If @error Or $aReturn[0] <> 0 Then Return $hSocket
	$aReturn = DllCall("ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($pSocketAddress, 3))
	If @error Then Return $hSocket
	$pSocketAddress = 0
	Return $aReturn[0]
EndFunc   ;==>_TCP_Server_ClientIP

Func CheckHTTPReq($sRequest, $sKey = "restart") ;**** Function to Check Request from Browser and return restart string if request is valid****
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

Func MultipleAttempts($sRemoteIP, $bFailure = False, $bSuccess = False) ;**** Function to Check for Multiple Password Failures****
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

Func _RemoteRestart($vMSocket, $sCodes, $sKey, $sHideCodes, $sServIP, $sName, $bDebug = True) ;**** Uses other Functions to check connection, verify request is valid, verify restart code is correct, gather IP, and send proper message back to User depending on request received****
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

Func RotateFile($sFile, $sBackupQty, $bDelOrig = True) ;Pass File to Rotate and Quantity of Files to Keep for backup. Optionally Keep Original.
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
					SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $zCMD[2], "yes", $aRCONResponseWaitms)
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

; #FUNCTION# ;===============================================================================
; https://www.autoitscript.com/forum/topic/101529-sunzippings-zipping/?tab=comments#comment-721988
; Name...........: _ExtractZip
; Description ...: Extracts file/folder from ZIP compressed file
; Syntax.........: _ExtractZip($sZipFile, $sDestinationFolder)
; Parameters ....: $sZipFile - full path to the ZIP file to process
;                  $sDestinationFolder - folder to extract to. Will be created if it does not exsist exist.
; Return values .: Success - Returns 1
;                          - Sets @error to 0
;                  Failure - Returns 0 sets @error:
;                  |1 - Shell Object creation failure
;                  |2 - Destination folder is unavailable
;                  |3 - Structure within ZIP file is wrong
;                  |4 - Specified file/folder to extract not existing
; Author ........: trancexx, modifyed by corgano
;
;==========================================================================================
Func _ExtractZipAll($sZipFile, $sDestinationFolder, $sFolderStructure = "")

	Local $i
	Do
		$i += 1
		$sTempZipFolder = @TempDir & "\Temporary Directory " & $i & " for " & StringRegExpReplace($sZipFile, ".*\\", "")
	Until Not FileExists($sTempZipFolder) ; this folder will be created during extraction

	Local $oShell = ObjCreate("Shell.Application")

	If Not IsObj($oShell) Then
		Return SetError(1, 0, 0) ; highly unlikely but could happen
	EndIf

	Local $oDestinationFolder = $oShell.NameSpace($sDestinationFolder)
	If Not IsObj($oDestinationFolder) Then
		DirCreate($sDestinationFolder)
;~         Return SetError(2, 0, 0) ; unavailable destionation location
	EndIf

	Local $oOriginFolder = $oShell.NameSpace($sZipFile & "\" & $sFolderStructure) ; FolderStructure is overstatement because of the available depth
	If Not IsObj($oOriginFolder) Then
		Return SetError(3, 0, 0) ; unavailable location
	EndIf

	Local $oOriginFile = $oOriginFolder.Items() ;get all items
	If Not IsObj($oOriginFile) Then
		Return SetError(4, 0, 0) ; no such file in ZIP file
	EndIf

	; copy content of origin to destination
	$oDestinationFolder.CopyHere($oOriginFile, 20) ; 20 means 4 and 16, replaces files if asked

	DirRemove($sTempZipFolder, 1) ; clean temp dir

	Return 1 ; All OK!

EndFunc   ;==>_ExtractZipAll

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
	Until Not FileExists($sTempZipFolder) ; this folder will be created during extraction

	Local $oShell = ObjCreate("Shell.Application")

	If Not IsObj($oShell) Then
		Return SetError(1, 0, 0) ; highly unlikely but could happen
	EndIf

	Local $oDestinationFolder = $oShell.NameSpace($sDestinationFolder)
	If Not IsObj($oDestinationFolder) Then
		Return SetError(2, 0, 0) ; unavailable destionation location
	EndIf

	Local $oOriginFolder = $oShell.NameSpace($sZipFile & "\" & $sFolderStructure) ; FolderStructure is overstatement because of the available depth
	If Not IsObj($oOriginFolder) Then
		Return SetError(3, 0, 0) ; unavailable location
	EndIf

	Local $oOriginFile = $oOriginFolder.ParseName($sFile)
	If Not IsObj($oOriginFile) Then
		Return SetError(4, 0, 0) ; no such file in ZIP file
	EndIf

	; copy content of origin to destination
	$oDestinationFolder.CopyHere($oOriginFile, 4) ; 4 means "do not display a progress dialog box", but apparently doesn't work

	DirRemove($sTempZipFolder, 1) ; clean temp dir

	Return 1 ; All OK!

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
Func FileExistsFunc($tSplash = 0)
;~ 	Local $sFileExists = FileExists($aSteamCMDDir & "\steamcmd.exe")
;~ 	If $sFileExists = 0 Then
;~ 		InetGet("https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip", @ScriptDir & "\steamcmd.zip", 0)
;~ 		DirCreate($aSteamCMDDir)     ; to extract to
;~ 		_ExtractZip(@ScriptDir & "\steamcmd.zip", "", "steamcmd.exe", $aSteamCMDDir)
;~ 		FileDelete(@ScriptDir & "\steamcmd.zip")
;~ 		LogWrite(" Running SteamCMD. [steamcmd.exe +quit]")
;~ 		RunWait("" & $aSteamCMDDir & "\steamcmd.exe +quit", @SW_MINIMIZE)
;~ 		If Not FileExists($aSteamCMDDir & "\steamcmd.exe") Then
;~ 			_DownloadAndExtractFile("steamcmd", "http://www.phoenix125.com/share/atlas/steamcmd.zip", "https://github.com/phoenix125/AtlasServerUpdateUtility/releases/download/Latest/mcrcon.zip", $tSplash)
;~ 		EndIf
;~ 	EndIf
	_DownloadAndExtractFile("steamcmd", "https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip", "http://www.phoenix125.com/share/atlas/steamcmd.zip", $tSplash, $aSteamCMDDir)
	_DownloadAndExtractFile("mcrcon", "http://www.phoenix125.com/share/atlas/mcrcon.zip", "https://github.com/phoenix125/AtlasServerUpdateUtility/releases/download/Latest/mcrcon.zip", $tSplash)
	If $aServerModYN = "yes" Then _DownloadAndExtractFile("AtlasModDownloader", "http://www.phoenix125.com/share/atlas/AtlasModDownloader.zip", "https://github.com/phoenix125/Atlas-Mod-Downloader/releases/download/AtlasModDownloader/AtlasModDownloader.zip", $tSplash)
	_DownloadAndExtractFile("DiscordSendWebhook", "http://www.phoenix125.com/share/atlas/DiscordSendWebhook.zip", "https://github.com/phoenix125/DiscordSendWebhook/releases/download/DiscordSendWebhook/DiscordSendWebhook.zip", $tSplash)
	_DownloadAndExtractFile("NetworkConnectionsViewer", "http://www.phoenix125.com/share/atlas/NetworkConnectionsViewer.zip", "https://github.com/phoenix125/NetworkConnectionsViewer/releases/download/LatestVersion/NetworkConnectionsViewer.zip", $tSplash)
	If $aUseKeepAliveYN = "yes" Then _DownloadAndExtractFile($aKeepAliveFileName, "http://www.phoenix125.com/share/atlas/" & $aKeepAliveFileZip, "https://github.com/phoenix125/AtlasServerUpdateUtilityKeepAlive/releases/download/LatestVersion/" & $aKeepAliveFileZip, $tSplash)
	_DownloadAndExtractFile("wget", "http://www.phoenix125.com/share/atlas/wget.zip", "https://github.com/phoenix125/AtlasServerUpdateUtility/releases/download/Latest/wget.zip", $tSplash, $aFolderTemp)
	_DownloadAndExtractFile("7z", "http://www.phoenix125.com/share/atlas/7z.zip", "https://github.com/phoenix125/AtlasServerUpdateUtility/releases/download/Latest/7z.zip", $tSplash, $aFolderTemp, "7z.dll")
EndFunc   ;==>FileExistsFunc
#EndRegion ;**** Check for Files Exist ****

Func _DownloadAndExtractFile($tFileName, $tURL1, $tURL2 = "", $tSplash = 0, $tFolder = @ScriptDir, $tFile2 = 0, $tFile3 = 0, $tFile4 = 0, $tFile5 = 0)
	$tFolder = RemoveTrailingSlash($tFolder)
	If FileExists($tFolder & "\" & $tFileName & ".exe") = 0 Then
		If $tSplash > 0 Then
			ControlSetText($tSplash, "", "Static1", $aStartText & "Downloading " & $tFileName & ".exe.")
		Else
			_Splash($aStartText & "Downloading " & $tFileName & ".exe.", 0, 475)
		EndIf
		DirCreate($tFolder) ; to extract to
		InetGet($tURL1, $tFolder & "\" & $tFileName & ".zip", 1)
		If Not FileExists($tFolder & "\" & $tFileName & ".zip") Then
			SetError(1, 1) ; Failed to download from source 1
			LogWrite(" [Util] Error downloading " & $tFileName & " from Source1: " & $tURL1)
			InetGet($tURL2, $tFolder & "\" & $tFileName & ".zip", 1)
			If Not FileExists($tFolder & "\" & $tFileName & ".zip") Then
				SetError(1, 2) ; Failed to download from source 2
				LogWrite(" [Util] Error downloading " & $tFileName & " from Source2: " & $tURL2)
				SplashOff()
				MsgBox($MB_OK, $aUtilName, "ERROR!!!  " & $tFileName & ".zip download failed.")
				$aSplashStartUp = _Splash($aStartText, 0, 475)
				Return
			EndIf
		EndIf
		DirCreate($tFolder) ; to extract to
		_ExtractZip($tFolder & "\" & $tFileName & ".zip", "", $tFileName & ".exe", $tFolder)
		If $tFile2 <> 0 Then _ExtractZip($tFolder & "\" & $tFileName & ".zip", "", $tFile2, $tFolder)
		If $tFile3 <> 0 Then _ExtractZip($tFolder & "\" & $tFileName & ".zip", "", $tFile3, $tFolder)
		If $tFile4 <> 0 Then _ExtractZip($tFolder & "\" & $tFileName & ".zip", "", $tFile4, $tFolder)
		If $tFile5 <> 0 Then _ExtractZip($tFolder & "\" & $tFileName & ".zip", "", $tFile5, $tFolder)
		If FileExists($tFolder & "\" & $tFileName & ".exe") Then
			LogWrite(" [Util] Downloaded and installed " & $tFileName & ".")
		Else
			LogWrite(" [Util] Error extracting " & $tFileName & ".exe from " & $tFileName & ".zip")
			SetError(1, 3) ; Failed to extract file
			SplashOff()
			MsgBox($MB_OK, $aUtilName, "ERROR!!! Extracting " & $tFileName & ".exe from " & $tFileName & ".zip failed.")
			$aSplashStartUp = _Splash($aStartText, 0, 475)
			Return
		EndIf
		FileDelete($tFolder & "\" & $tFileName & ".zip")
	EndIf
EndFunc   ;==>_DownloadAndExtractFile

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
			Global $aSplashMod = _Splash($tTxt)
		EndIf
	EndIf
	;	If $xDebug Then
	;		LogWrite(" [Mod] Running mod update check.")
	;	EndIf
	If ($aServerModYN = "yes") Then
		Local $sFileExists = FileExists(@ScriptDir & "\AtlasModDownloader.exe")
		If $sFileExists = 0 Then
			_Splash($aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Downloading AtlasModDownloader.exe.")
;~ 			ControlSetText($aSplashMod, "", "Static1", $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Downloading AtlasModDownloader.exe.")
			LogWrite(" Downloaded and installed AtlasModDownloader.exe")
			InetGet("http://www.phoenix125.com/share/atlas/AtlasModDownloader.exe", @ScriptDir & "\AtlasModDownloader.exe", 1)
			If Not FileExists(@ScriptDir & "\AtlasModDownloader.exe") Then
				SplashOff()
				MsgBox(0x0, "AtlasModDownloader Not Found", "Could not find AtlasModDownloader.exe at " & @ScriptDir)
				_ExitUtil()
			EndIf
		EndIf
	EndIf
	Local $aMods = StringSplit($sMods, ",")
	Local $tError = 0
	Local $tModsUpdated = ""
	For $i = 1 To $aMods[0]
		$aMods[$i] = StringStripWS($aMods[$i], 8)
		Local $aLatestTime = GetLatestModUpdateTime($aMods[$i], $tShow)
		$aModName[$i] = $aLatestTime[3]
		Local $aInstalledTime = GetInstalledModUpdateTime($sServerDir, $aMods[$i], $aModName[$i], $tShow)
		If FileExists($aServerDirLocal & "\ShooterGame\Content\Mods\" & $aMods[$i] & ".mod") Or FileExists($aServerDirLocal & "\ShooterGame\Content\Mods\" & $aMods[$i] & "\" & $aMods[$i] & ".mod") Then
			If Not $aLatestTime[0] Or Not $aLatestTime[1] Then
				Local $aErrorMsg = "Something went wrong downloading update information for mod [" & $aMods[$i] & "] If running Windows Server, Disable ""IE Enhanced Security Configuration"" for Administrators (via Server Manager > Local Server > IE Enhanced Security Configuration)."
				LogWrite(" [Mod] " & $aErrorMsg)
				$xError = True
				$tError = 1
				SplashOff()
				If $tShow Then
					MsgBox($MB_OK, $aUtilityVer, $aErrorMsg, 5)
				EndIf
				If $tSplash > 0 Then $aSplashStartUp = _Splash($aStartText, 0, 475)
			ElseIf Not $aInstalledTime[0] Then
				$xError = True
				$tError = 2
				$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, $tError, $i) ;No Manifest. Download First Mod
				$tModsUpdated &= $aMods[$i] & " " & $aModName[$i] & ", "
;~ 				If $bStopUpdate Then ExitLoop
			ElseIf Not $aInstalledTime[1] Then
				$xError = True
				$tError = 3
				$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, $tError, $i) ;Mod does not exists. Download
				$tModsUpdated &= $aMods[$i] & " " & $aModName[$i] & ", "
;~ 				If $bStopUpdate Then ExitLoop
			ElseIf $aInstalledTime[1] And (StringCompare($aLatestTime[2], $aInstalledTime[2]) <> 0) Then
				$tError = 4
				$xError = True
				$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, $tError, $i) ;Mod Out of Date. Update.
				$tModsUpdated &= $aMods[$i] & " " & $aModName[$i] & ", "
;~ 				If $bStopUpdate Then ExitLoop
			EndIf
		Else
			$xError = True
			$tError = 2
			$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, $tError, $i) ;No Manifest exist in Atlas Mods folder. Download First Mod
			$tModsUpdated &= $aMods[$i] & " " & $aModName[$i] & ", "
		EndIf
;~ 		Local $bStopUpdate = False
	Next
	If $tError > 0 Then
		$tModsUpdated = StringTrimRight($tModsUpdated, 2)
		$aModMsgInGame = AnnounceReplaceModID($sModMsgInGame, $sAnnounceNotifyModUpdate, $tModsUpdated)
		$aModMsgDiscord = AnnounceReplaceModID($sModMsgDiscord, $sAnnounceNotifyModUpdate, $tModsUpdated)
		$aModMsgTwitch = AnnounceReplaceModID($sModMsgTwitch, $sAnnounceNotifyModUpdate, $tModsUpdated)
	EndIf

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
		Global $aSplashStartUp = _Splash($tTxt)
	EndIf
EndFunc   ;==>CheckMod

Func GetLatestModUpdateTime($sMod, $sShow)
	Local $aReturn[4] = [True, False, "", ""]
	Local $zModName = ""
	Local $sFilePath = $aFolderTemp & "mod_" & $sMod & "_latest_ver.tmp"
	Local $aFDError = 1
	If FileExists($sFilePath) Then
		$aFDError = FileDelete($sFilePath)
		If $aFDError = 0 Then
			LogWrite("", " [Mod] Error!  Failed to delete mod_" & $sMod & "_latest_ver.tmp. Ignoring Internal Browser check and using Internet Explorer instead.")
		Else
		EndIf
	Else
	EndIf
	LogWrite("", " [Mod] Checking for mod update via Internal Browser: http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
	Local $tInet = InetGet("http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod, $sFilePath, 1)
	$tErr = _InetGetErrorText(@error, 3)
	Sleep(100)
;~ 	InetClose($tInet)
	Local $hFileOpen = FileOpen($sFilePath, 0)
	Local $sFileRead = FileRead($hFileOpen)
	FileClose($hFileOpen)
	Local $aAppInfo1 = _StringBetween($sFileRead, "Update: ", "<div class=")
;~ 	If @error Then
	If _ArrayToString($aAppInfo1) = -1 Or $aFDError = 0 Then
		LogWrite("", " [Mod] Checking for mod update via Internet Explorer: http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
		Local $sFileRead = _INetGetSource("http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
		Sleep(100)
		Local $aAppInfo1 = _StringBetween($sFileRead, "Update: ", "<div class=")
;~ 	If @error Then
		If _ArrayToString($aAppInfo1) = -1 Then
			LogWrite("", " [Mod] Checking for mod update via wget.exe http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
			Local $tFolder = RemoveTrailingSlash($aFolderTemp)
			FileDelete($tFolder & "\" & $sMod)
			_DownloadAndExtractFile("wget", "http://www.phoenix125.com/share/atlas/wget.zip", "https://github.com/phoenix125/AtlasServerUpdateUtility/releases/download/Latest/wget.zip", 0, $tFolder)
			Local $mOut = Run($tFolder & "\wget.exe http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod, $tFolder, @SW_MINIMIZE)
			Local $tErr = ProcessWaitClose($mOut, 2)
			If $tErr = 0 Then
				LogWrite("", " [Mod] ERROR! Checking for mod update via GNU Wget.exe TIMEOUT.")
			EndIf
			$sFileRead = FileRead($tFolder & "\" & $sMod)
			Local $aAppInfo1 = _StringBetween($sFileRead, "Update: ", "<div class=")
			If _ArrayToString($aAppInfo1) = -1 Then
				$aReturn[1] = False
				LogWrite("", " [Mod] Failed to get latest mod version [" & $sMod & "]. Skipping this update check. " & $sMod)
			Else
				Local $aAppInfo2 = $aAppInfo1[0]
				Local $aAppInfo3 = _ArrayToString(_StringBetween($aAppInfo2, "<p id=""", """"))
				$aReturn[1] = True
				$aReturn[2] = $aAppInfo3
			EndIf
		Else
			Local $aAppInfo2 = $aAppInfo1[0]
			Local $aAppInfo3 = _ArrayToString(_StringBetween($aAppInfo2, "<p id=""", """"))
			$aReturn[1] = True
			$aReturn[2] = $aAppInfo3
		EndIf
	Else
		Local $aAppInfo2 = $aAppInfo1[0]
		Local $aAppInfo3 = _ArrayToString(_StringBetween($aAppInfo2, "<p id=""", """"))
		$aReturn[1] = True
		$aReturn[2] = $aAppInfo3
	EndIf
	Local $zModName = _ArrayToString(_StringBetween($sFileRead, "<title>Steam Community :: ", " :: Change Notes</title>"))
	$aReturn[3] = $zModName
	If $sShow Then
		ControlSetText($aSplashMod, "", "Static1", $aStartText & "Checking for mod " & $sMod & @CRLF & $zModName & " update or new mod.")
	EndIf
	Return $aReturn
EndFunc   ;==>GetLatestModUpdateTime

Func _InetGetErrorText($iErrorCode, $iInfoLevel = 1)
	; PeteW, last updated: 16.01.12
	;  $iErrorCode = @extended [InetGetInfo(handle,5)] code number
	;  $iInfoLevel 1 (Default) = return 'ERROR_CODE' text only, 2 = return 'Description' text only, 3 = return 'ERROR_CODE: Description' text.
	; Codes / descriptions obtained from http://support.microsoft.com/kb/193625 & http://www.mathemainzel.info/files/w32ineterrors.html
	;
	Local $sErrMsg, $sErrDesc
	Switch $iErrorCode
		Case 0
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_SUCCESS"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "Action completed successfully."
		Case 12001
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_OUT_OF_HANDLES"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "No more handles could be generated at this time."
		Case 12002
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_TIMEOUT"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request has timed out."
		Case 12003
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_EXTENDED_ERROR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "An extended error was returned from the server [may be 'file not found']. This is typically a string or buffer containing a verbose error message. Call InternetGetLastResponseInfo to retrieve the error text."
		Case 12004
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INTERNAL_ERROR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "An internal error has occurred."
		Case 12005
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INVALID_URL"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The URL is invalid."
		Case 12006
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_UNRECOGNIZED_SCHEME"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The URL scheme could not be recognized or is not supported."
		Case 12007
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_NAME_NOT_RESOLVED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The server name could not be resolved."
		Case 12008
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_PROTOCOL_NOT_FOUND"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The requested protocol could not be located."
		Case 12009
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INVALID_OPTION"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "A request to InternetQueryOption or InternetSetOption specified an invalid option value."
		Case 12010
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_BAD_OPTION_LENGTH"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The length of an option supplied to InternetQueryOption or InternetSetOption is incorrect for the type of option specified."
		Case 12011
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_OPTION_NOT_SETTABLE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request option cannot be set, only queried."
		Case 12012
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_SHUTDOWN"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The Win32 Internet function support is being shut down or unloaded."
		Case 12013
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INCORRECT_USER_NAME"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request to connect and log on to an FTP server could not be completed because the supplied user name is incorrect."
		Case 12014
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INCORRECT_PASSWORD"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request to connect and log on to an FTP server could not be completed because the supplied password is incorrect."
		Case 12015
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_LOGIN_FAILURE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request to connect to and log on to an FTP server failed."
		Case 12016
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INVALID_OPERATION"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The requested operation is invalid."
		Case 12017
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_OPERATION_CANCELLED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The operation was canceled, usually because the handle on which the request was operating was closed before the operation completed."
		Case 12018
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INCORRECT_HANDLE_TYPE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The type of handle supplied is incorrect for this operation."
		Case 12019
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INCORRECT_HANDLE_STATE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The requested operation cannot be carried out because the handle supplied is not in the correct state."
		Case 12020
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_NOT_PROXY_REQUEST"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request cannot be made via a proxy."
		Case 12021
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_REGISTRY_VALUE_NOT_FOUND"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "A required registry value could not be located."
		Case 12022
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_BAD_REGISTRY_PARAMETER"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "A required registry value was located but is an incorrect type or has an invalid value."
		Case 12023
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_NO_DIRECT_ACCESS"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "Direct network access cannot be made at this time."
		Case 12024
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_NO_CONTEXT"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "An asynchronous request could not be made because a zero context value was supplied."
		Case 12025
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_NO_CALLBACK"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "An asynchronous request could not be made because a callback function has not been set."
		Case 12026
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_REQUEST_PENDING"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The required operation could not be completed because one or more requests are pending."
		Case 12027
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INCORRECT_FORMAT"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The format of the request is invalid."
		Case 12028
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_ITEM_NOT_FOUND"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The requested item could not be located."
		Case 12029
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_CANNOT_CONNECT"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The attempt to connect to the server failed."
		Case 12030
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_CONNECTION_ABORTED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The connection with the server has been terminated."
		Case 12031
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_CONNECTION_RESET"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The connection with the server has been reset."
		Case 12032
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_FORCE_RETRY"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "Calls for the Win32 Internet function to redo the request."
		Case 12033
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_INVALID_PROXY_REQUEST"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request to the proxy was invalid."
		Case 12034
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_NEED_UI"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "A user interface or other blocking operation has been requested."
		Case 12036
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_HANDLE_EXISTS"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request failed because the handle already exists."
		Case 12037
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_SEC_CERT_DATE_INVALID"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "SSL certificate date that was received from the server is bad. The certificate is expired."
		Case 12038
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_SEC_CERT_CN_INVALID"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "SSL certificate common name (host name field) is incorrect. For example, if you entered www.server.com and the common name on the certificate says www.different.com."
		Case 12039
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_HTTP_TO_HTTPS_ON_REDIR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The application is moving from a non-SSL to an SSL connection because of a redirect."
		Case 12040
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_HTTPS_TO_HTTP_ON_REDIR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The application is moving from an SSL to an non-SSL connection because of a redirect."
		Case 12041
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_MIXED_SECURITY"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "Indicates that the content is not entirely secure. Some of the content being viewed may have come from unsecured servers."
		Case 12042
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_CHG_POST_IS_NON_SECURE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The application is posting and attempting to change multiple lines of text on a server that is not secure."
		Case 12043
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "INTERNET_POST_IS_NON_SECURE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The application is posting data to a server that is not secure."
		Case 12044
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_CLIENT_AUTH_CERT_NEEDED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The server is requesting client authentication."
		Case 12045
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_INVALID_CA"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The function is unfamiliar with the Certificate Authority that generated the server's certificate."
		Case 12046
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_CLIENT_AUTH_NOT_SETUP"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "Client authorization is not set up on this computer."
		Case 12047
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_ASYNC_THREAD_FAILED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The application could not start an asynchronous thread."
		Case 12048
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_REDIRECT_SCHEME_CHANGE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The function could not handle the redirection, because the scheme changed (for example, HTTP to FTP)."
		Case 12049
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_DIALOG_PENDING"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "Another thread has a password dialog box in progress."
		Case 12050
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_RETRY_DIALOG"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The dialog box should be retried."
		Case 12052
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_HTTPS_HTTP_SUBMIT_REDIR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The data being submitted to an SSL connection is being redirected to a non-SSL connection."
		Case 12053
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_INSERT_CDROM"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request requires a CD-ROM to be inserted in the CD-ROM drive to locate the resource requested."
		Case 12054
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_FORTEZZA_LOGIN_NEEDED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The requested resource requires Fortezza authentication."
		Case 12055
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_SEC_CERT_ERRORS"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The SSL certificate contains errors."
		Case 12056
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_SEC_CERT_NO_REV"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The SSL certificate was not revoked."
		Case 12057
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_SEC_CERT_REV_FAILED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "Revocation of the SSL certificate failed."
		Case 12110
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "FTP_TRANSFER_IN_PROGRESS"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The requested operation cannot be made on the FTP session handle because an operation is already in progress."
		Case 12111
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "FTP_DROPPED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The FTP operation was not completed because the session was aborted."
		Case 12130
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "GOPHER_PROTOCOL_ERROR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "An error was detected while parsing data returned from the gopher server."
		Case 12131
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "GOPHER_NOT_FILE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request must be made for a file locator."
		Case 12132
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "GOPHER_DATA_ERROR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "An error was detected while receiving data from the gopher server."
		Case 12133
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "GOPHER_END_OF_DATA"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The end of the data has been reached."
		Case 12134
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "GOPHER_INVALID_LOCATOR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The supplied locator is not valid."
		Case 12135
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "GOPHER_INCORRECT_LOCATOR_TYPE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The type of the locator is not correct for this operation."
		Case 12136
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "GOPHER_NOT_GOPHER_PLUS"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The requested operation can only be made against a Gopher+ server or with a locator that specifies a Gopher+ operation."
		Case 12137
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "GOPHER_ATTRIBUTE_NOT_FOUND"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The requested attribute could not be located."
		Case 12138
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "GOPHER_UNKNOWN_LOCATOR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The locator type is unknown."
		Case 12150
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "HTTP_HEADER_NOT_FOUND"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The requested header could not be located."
		Case 12151
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "HTTP_DOWNLEVEL_SERVER"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The server did not return any headers."
		Case 12152
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "HTTP_INVALID_SERVER_RESPONSE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The server response could not be parsed."
		Case 12153
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "HTTP_INVALID_HEADER"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The supplied header is invalid."
		Case 12154
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "HTTP_INVALID_QUERY_REQUEST"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The request made to HttpQueryInfo is invalid."
		Case 12155
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "HTTP_HEADER_ALREADY_EXISTS"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The header could not be added because it already exists."
		Case 12156
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "HTTP_REDIRECT_FAILED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The redirection failed because either the scheme changed (for example, HTTP to FTP) or all attempts made to redirect failed (default is five attempts)."
		Case 12157
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_SECURITY_CHANNEL_ERROR"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The application experienced an internal error loading the SSL libraries."
		Case 12158
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_UNABLE_TO_CACHE_FILE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The function was unable to cache the file."
		Case 12159
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_TCPIP_NOT_INSTALLED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The required protocol stack is not loaded and the application cannot start WinSock."
		Case 12160
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_HTTP_NOT_REDIRECTED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The HTTP request was not redirected."
		Case 12161
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_HTTP_COOKIE_NEEDS_CONFIRMATION"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The HTTP cookie requires confirmation."
		Case 12162
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_HTTP_COOKIE_DECLINED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The HTTP cookie was declined by the server."
		Case 12163
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_DISCONNECTED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The Internet connection has been lost."
		Case 12164
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_SERVER_UNREACHABLE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The Web site or server indicated is unreachable."
		Case 12165
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_PROXY_SERVER_UNREACHABLE"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The designated proxy server cannot be reached."
		Case 12166
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_BAD_AUTO_PROXY_SCRIPT"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "There was an error in the automatic proxy configuration script."
		Case 12167
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_UNABLE_TO_DOWNLOAD_SCRIPT"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The automatic proxy configuration script could not be downloaded. The INTERNET_FLAG_MUST_CACHE_REQUEST flag was set."
		Case 12168
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_HTTP_REDIRECT_NEEDS_CONFIRMATION"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The redirection requires user confirmation."
		Case 12169
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_SEC_INVALID_CERT"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "SSL certificate is invalid."
		Case 12170
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_SEC_CERT_REVOKED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "SSL certificate was revoked."
		Case 12171
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_FAILED_DUETOSECURITYCHECK"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The function failed due to a security check."
		Case 12172
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_NOT_INITIALIZED"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "Initialization of the WinINet API has not occurred. Indicates that a higher-level function, such as InternetOpen, has not been called yet."
		Case 12174
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_INTERNET_LOGIN_FAILURE_DISPLAY_ENTITY_BODY"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "The MS-Logoff digest header has been returned from the Web site. This header specifically instructs the digest package to purge credentials for the associated realm. This error will only be returned if INTERNET_ERROR_MASK_LOGIN_FAILURE_DISPLAY_ENTITY_BODY has been set."
		Case Else
			If BitAND($iInfoLevel, 1) Then $sErrMsg = "ERROR_UNKNOWN"
			If BitAND($iInfoLevel, 2) Then $sErrDesc = "Unidentified error - no description available."
	EndSwitch
	If $sErrMsg And $sErrDesc Then $sErrMsg &= ": "
	Return $sErrMsg & $sErrDesc
EndFunc   ;==>_InetGetErrorText

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
		$aReturn[0] = True ;File Exists
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
			$aReturn[1] = True ;Successfully Read numerical value at positition expected
			$aReturn[2] = $aAppInfo[8] ;Return Value Read
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
	Local $tSplash = _Splash(" Mod " & $sMod & " " & $sModName & @CRLF & " update released or new mod." & @CRLF & "Downloading and installing mod update.", 0, 500, 140)
	Local $aModScript = @ScriptDir & "\AtlasModDownloader.exe  --modids " & $sMod & " --steamcmd """ & $sSteamCmdDir & """ --workingdir """ & $sServerDir & """"
	LogWrite(" [Mod] Mod " & $sMod & " " & $sModName & " update released or new mod found. Downloading and installing mod.", " [Mod] Mod " & $sMod & " " & $sModName & " update released or new mod found. Downloading and installing mod:" & $aModScript)
;~ 	$aModMsgInGame = AnnounceReplaceModID($sMod, $sModMsgInGame, $sAnnounceNotifyModUpdate, $sModNo)
;~ 	$aModMsgDiscord = AnnounceReplaceModID($sMod, $sModMsgDiscord, $sAnnounceNotifyModUpdate, $sModNo)
;~ 	$aModMsgTwitch = AnnounceReplaceModID($sMod, $sModMsgTwitch, $sAnnounceNotifyModUpdate, $sModNo)
	$Timer = TimerInit()
;~ 	If $aServerMinimizedYN = "no" Then
	Local $tPID = Run($aModScript)
;~ 	Else
;~ 		Local $tPID = Run($aModScript, "", @SW_MINIMIZE)
;~ 	EndIf
	If $aServerModTimeoutMin > 0 Then
		Do
			If Not ProcessExists($tPID) Then ExitLoop
			ControlSetText($tSplash, "", "Static1", " Mod " & $sMod & " " & $sModName & @CRLF & " update released or new mod." & @CRLF & @CRLF & "Downloading and installing mod update." & @CRLF & _
					"Timeout Countdown:" & Int($aServerModTimeoutMin * 60 - (TimerDiff($Timer) / 1000)))
			Sleep(950)
			If $aUseKeepAliveYN = "yes" Then KeepUtilAliveCounter()
		Until TimerDiff($Timer) > (60000 * $aServerModTimeoutMin) ; Wait X minutes for mod to finish downloading
		If ProcessExists($tPID) Then
			ProcessClose($tPID)
		EndIf
	EndIf
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
	Local $tTmp1 = InetGet($tLink1, $tFile, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
	Do
		Sleep(100)
		$i += 1
	Until InetGetInfo($tTmp1, $INET_DOWNLOADCOMPLETE) Or $i = $tCnt
	InetClose($tTmp1)
	If $i = $tCnt And $tLink2 <> "0" Then
		$tTmp2 = InetGet($tLink2, $tFile, $INET_FORCERELOAD, $INET_DOWNLOADBACKGROUND)
		Do
			Sleep(100)
			$i += 1
		Until InetGetInfo($tTmp2, $INET_DOWNLOADCOMPLETE) Or $i = $tCnt
		InetClose($tTmp2)
	EndIf
	Local $hFileOpen = FileOpen($tFile, 0)
	Local $hFileRead = FileRead($hFileOpen)
	If $hFileOpen = -1 Then
		InetClose($tTmp1)
		Sleep(200)
		FileClose($hFileOpen)
		Local $hFileRead = _INetGetSource($tLink1)
		If @error Then
			If $tLink2 <> "0" Then
				$hFileRead = _INetGetSource($tLink2)
				If @error Then
					Return "Error" ; Error
				Else
					FileClose($hFileOpen)
					FileDelete($tFile)
					FileWrite($tFile, $hFileRead)
				EndIf
			Else
				Return True ; Error
			EndIf
		Else
			FileClose($hFileOpen)
			FileDelete($tFile)
			FileWrite($tFile, $hFileRead)
		EndIf
	Else
		FileClose($hFileOpen)
	EndIf
	Return $hFileRead ; No error
EndFunc   ;==>_InetGetMulti

#Region ;**** Check for Server Utility Update ****
Func UtilUpdate($tLink, $tDL, $tUtil, $tUtilName, $tSplash = 0, $tUpdate = "show")
	SetStatusBusy("Starting Util Update.")
	$tUtilUpdateAvailableTF = False
	If $tUpdate = "show" Then
		Local $tTxt = $aStartText & "Checking for " & $tUtilName & " updates."
		If $tSplash > 0 Then
			ControlSetText($tSplash, "", "Static1", $tTxt)
		Else
			_Splash($tTxt)
		EndIf
	EndIf
	Local $tVer[2]
	Local $sFilePath = $aFolderTemp & $aUtilName & "_latest_ver.tmp"
	$iGet = _InetGetMulti(20, $sFilePath, $tLink)
	If $iGet = "Error" Then
		LogWrite(" [Util] " & $tUtilName & " update check failed to download latest version: " & $tLink)
		If $tUpdate = "show" Then
			If $aShowUpdate Then
				Local $tTxt = $aStartText & $aUtilName & " update check failed." & @CRLF & "Please try again later."
				If $tSplash > 0 Then
					ControlSetText($tSplash, "", "Static1", $tTxt)
				Else
					_Splash($tTxt)
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
			LogWrite(" [Util] " & $tUtilName & " up to date. Version: " & $tVer[0], " [Util] " & $tUtilName & " up to date. Version : " & $tVer[0] & ", Notes : " & $tTxt1)
			If FileExists($aUtilUpdateFile) Then
				FileDelete($aUtilUpdateFile)
			EndIf
			If $tUpdate = "show" Then
				If $aShowUpdate Then
					Local $tTxt = $aStartText & $aUtilName & " up to date . . ."
					If $tSplash > 0 Then
						ControlSetText($tSplash, "", "Static1", $tTxt)
					Else
						_Splash($tTxt)
					EndIf
					Sleep(2000)
					$aShowUpdate = False
				EndIf
			EndIf
		Else
			$tUtilUpdateAvailableTF = True
			LogWrite(" [Util] !!! New " & $aUtilName & " update available. Installed version: " & $tUtil & ", Latest version: " & $tVer[0], " [Util] New " & $aUtilName & _
					" update available. Installed version: " & $tUtil & ", Latest version: " & $tVer[0] & ", Notes: " & $tTxt1)
			FileWrite($aUtilUpdateFile, _NowCalc() & " [Util] New " & $aUtilName & " update available. Installed version: " & $tUtil & ", Latest version: " & $tVer[0] & ", Notes: " & $tTxt1)
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
					_Splash(" Downloading latest version of " & @CRLF & $tUtilName)
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
						LogWrite(" [Util] ERROR! " & $tUtilName & ".exe download failed.")
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
							LogWrite(" [Util] Update download complete. Shutting down current version and starting new version. Initiated by User or Auto Update.")
							CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
							PIDSaveServer($aServerPID, $aPIDServerFile)
							PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
							Run(@ScriptDir & "\" & $tUtilName & "_" & $tVer[0] & ".exe")
							_ExitUtil()
						Else
							LogWrite(" [Util] Update download complete. Per user request, continuing to run current version. Resuming utility . . .")
							_Splash("Utility update check canceled by user." & @CRLF & "Resuming utility . . .", 2000)
						EndIf
					EndIf
				ElseIf $tMB = 7 Then
					$aUpdateUtil = "0"
					IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Check for " & $aUtilName & " updates every __ hours (0 to disable) (0-24) ###", $aUpdateUtil)
					LogWrite(" [Util] " & "Utility update check disabled. To enable update check, " & @CRLF & "change [Check for Updates ###=yes] in the .ini.")
					_Splash("Utility update check disabled." & @CRLF & "To enable update check, change [Check for Updates ###=yes] in the .ini.", 5000, 500)
				ElseIf $tMB = 2 Then
					LogWrite(" [Util] Utility update check canceled by user. Resuming utility . . .")
					_Splash("Utility update check canceled by user." & @CRLF & "Resuming utility . . .", 2000)
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

Func ReplaceCRwithCRLF($sString) ; Initial Regular expression by Melba23 with a new suggestion by Ascend4nt and modified By guinness.
	Return StringRegExpReplace($sString, '(*BSR_ANYCRLF)\R', @CRLF) ; Idea by Ascend4nt
EndFunc   ;==>ReplaceCRwithCRLF

Func ReplaceVerticalBarCRwithSlash($sString) ; Initial Regular expression by Melba23 with a new suggestion by Ascend4nt and modified By guinness.
	Return StringReplace($sString, "|", "/")
EndFunc   ;==>ReplaceVerticalBarCRwithSlash

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
		FileWriteLine($tServerSummaryFile, " [Server " & _ServerNamingScheme($i, $aNamingScheme) & "] Use:" & $xStartGrid[$i] & " QueryPort:" & $xServerport[$i] & ", Port:" & $xServergameport[$i] & _
				", SeamlessIP:" & $xServerIP[$i] & ", SeamlessDataPort:" & $xServerseamlessDataPort[$i] & ", RCON:" & $xServerRCONPort[$i + 1] & ", DIR:" & $xServerAltSaveDir[$i] & _
				", PID:" & $aServerPID[$i] & ", Name: " & $xServerNames[$i])
	Next
;~ 	EndIf
	Local $aWAN = _GetIP()
	FileWriteLine($tServerSummaryFile, @CRLF & _
			"            AdminPassword: " & $aServerAdminPass & @CRLF & _
			"               MaxPlayers: " & $aServerMaxPlayers & @CRLF & _
			"      ReservedPlayerSlots: " & $aServerReservedSlots & @CRLF & _
			"                Multihome: " & $aServerMultiHomeIP & @CRLF & _
			"    Server Extra Commands: " & $aServerExtraCMD & @CRLF & _
			"  SteamCMD Extra Commands: " & $aSteamExtraCMD & @CRLF)
	If $aServerModYN = "yes" Then
		FileWriteLine($tServerSummaryFile, _
				"          Mod Number List: " & $aServerModList & @CRLF & _
				"                Mod Names: " & _ArrayToString($aModName) & @CRLF)
	Else
		FileWriteLine($tServerSummaryFile, _
				"          Mod Number List: " & @CRLF & _
				"                Mod Names: " & @CRLF)
	EndIf
	FileWriteLine($tServerSummaryFile, _
			"          Local Server IP: " & @IPAddress1 & @CRLF & _
			"                   WAN IP: " & $aWAN & @CRLF & @CRLF)
	If $aRemoteRestartUse = "yes" Then
		FileWriteLine($tServerSummaryFile, _
				"Remote Restart Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/?" & $aRemoteRestartKey & "=" & $aRemoteRestartCode & @CRLF & _
				"  Remote Restart WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/?" & $aRemoteRestartKey & "=" & $aRemoteRestartCode & @CRLF & @CRLF & _
				"RCON Broadcast Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & _
				"  RCON Broadcast WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & @CRLF & _
				"  RCON Command Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)" & @CRLF & _
				"    RCON Command WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)")
	Else
		FileWriteLine($tServerSummaryFile, _
				"Remote Restart Local Link: http://" & @CRLF & _
				"  Remote Restart WAN Link: http://" & @CRLF & @CRLF & _
				"RCON Broadcast Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & _
				"  RCON Broadcast WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & @CRLF & _
				"  RCON Command Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)" & @CRLF & _
				"    RCON Command WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)")
	EndIf

	FileWriteLine($tServerSummaryFile, @CRLF & "Settings listed in the order as listed in ServerGrid.json: (if having server problems, paste the following in the appropriate section in the " & $aUtilName & ".ini file)")
	Local $tRCON = "              RCON ports: "
	For $i = 1 To ($aServerGridTotal - 1)
		$tRCON = $tRCON & $xServerRCONPort[$i] & ","
	Next
	$tRCON = $tRCON & $xServerRCONPort[$aServerGridTotal]
	FileWriteLine($tServerSummaryFile, $tRCON)

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
	FileWriteLine($tServerSummaryFile, $tDIR)
	LogWrite(" Created server summary file: " & $tServerSummaryFile)
EndFunc   ;==>MakeServerSummaryFile

Func _HTTP_ResponseText($Url)
	$oHTTP = ObjCreate("winhttp.winhttprequest.5.1")
	$oHTTP.Open("GET", $Url)
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
			_RestartUtil()
;~ 	Run(@ScriptDir & "\" & $aUtilName & "_" & $tVer[0] & ".exe")
		EndIf
		_ExitUtil()
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
			_RestartUtil()
;~ 	Run(@ScriptDir & "\" & $aUtilName & "_" & $tVer[0] & ".exe")
		EndIf
		_ExitUtil()
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
			_RestartUtil()
		EndIf
		_ExitUtil()
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
		If $tMB = 6 Then ; (YES)
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
				_RestartUtil()
;~ 	Run(@ScriptDir & "\" & $aUtilName & "_" & $tVer[0] & ".exe")
			EndIf
			_ExitUtil()
			; ----------------------------------------------------------
		ElseIf $tMB = 7 Then ; NO
			Local $aMsg = "Thank you for using " & $aUtilName & "." & @CRLF & "Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
					"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com"
			LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False) ; Do NOT close redis
			SplashOff()
			If $tRestart = False Then
				MsgBox(4096, $aUtilityVer, $aMsg, 20)
				LogWrite(" [Util] " & $aUtilityVer & " Stopped by User")
			Else
				LogWrite(" [Util] " & $aUtilityVer & " Restarting Util")
				_RestartUtil()
;~ 	Run(@ScriptDir & "\" & $aUtilName & "_" & $tVer[0] & ".exe")
			EndIf
			_ExitUtil()
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
				_RestartUtil()
			EndIf
			PIDSaveServer($aServerPID, $aPIDServerFile)
			PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
			CFGLastClose()
			CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
			_ExitUtil()
		EndIf
	EndIf
	SetStatusIdle()
EndFunc   ;==>F_ExitCloseY

Func F_RestartNow($tAsk = True)
	SetStatusBusy("Restart Now. Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [Server] Restart Server Now requested by user (Restart Server Now) Redis will remain running.")
	If $tAsk Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Do you wish to Restart Server Now?" & @CRLF & @CRLF & _
				"Click (YES) to Restart Server Now." & @CRLF & _
				"Click (NO) or (CANCEL) to cancel.", 15)
	Else
		$tMB = 6
	EndIf
	If $tMB = 6 Then ; (YES)
		;		If $aBeginDelayedShutdown = 0 Then
		LogWrite(" [Server] Restart Server Now request initiated by user.")
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False) ; Do NOT close redis
		;		EndIf
	Else
		LogWrite(" [Server] Restart Server Now request canceled by user.")
		_Splash("Restart Server Now canceled. Resuming utility . . .")
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
				"Click (YES) to enable Remote Restart. A utility restart will be required." & @CRLF & _
				"Click (NO) or (CANCEL) to skip.", 15)
		If $tMB = 6 Then ; (YES)
			LogWrite(" [Remote Restart] Remote Restart enabled in " & $aUtilName & ".ini per user request")
			IniWrite($aIniFile, " --------------- REMOTE RESTART OPTIONS --------------- ", "Use Remote Restart? (yes/no) ###", "yes")
			$aRemoteRestartUse = "yes"
			_Splash("Remote Restart enabled in " & $aUtilName & ".ini. " & @CRLF & "Restarting utility in 5 seconds.", 5000)
			PIDSaveServer($aServerPID, $aPIDServerFile)
			PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
			LogWrite(" [Util] " & $aUtilityVer & " Restarting Util")
			_RestartUtil()
			_ExitUtil()
		Else
			LogWrite(" [Remote Restart] No changes made to Remote Restart setting in " & $aUtilName & ".ini per user request.")
			_Splash("No changes were made. Resuming utility . . .", 2000)
		EndIf
	Else
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Do you wish to initiate Remote Restart (reboot all servers in " & $aRemoteTime[$aRemoteCnt] & "min)?" & @CRLF & @CRLF & _
				"Click (YES) to Initiate Remote Restart." & @CRLF & _
				"Click (NO) or (CANCEL) to cancel.", 15)
		If $tMB = 6 Then ; (YES)
			If $aBeginDelayedShutdown = 0 Then
				LogWrite(" [Remote Restart] Remote Restart request initiated by user.")
				If ($sUseDiscordBotRemoteRestart = "yes") Or ($sUseTwitchBotRemoteRestart = "yes") Or ($sInGameAnnounce = "yes") Then
					$aRebootReason = "remoterestart"
					$aBeginDelayedShutdown = 1
					$aTimeCheck0 = _NowCalc()
				Else
					RunExternalRemoteRestart()
					CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False) ; Do NOT close redis
				EndIf
			EndIf
		Else
			LogWrite(" [Remote Restart] Remote Restart request canceled by user.")
			_Splash("Remote Restart canceled. Resuming utility . . .", 2000)
		EndIf
	EndIf
	SetStatusIdle()
EndFunc   ;==>F_RemoteRestart

#Region _RestartUtil Function
Func _RestartUtil($fExit = 1) ; Thanks Yashied!  https://www.autoitscript.com/forum/topic/111215-restart-udf/
	;#OnAutoItStartRegister "OnAutoItStart" ; _RestartUtil() ; Put at beginning of program
	;Global $__Restart = False ; _RestartUtil() ; Put at beginning of program
	If $aUseKeepAliveYN = "yes" Then IniWrite($aKeepAliveConfigFileFull, " --------------- ATLASSERVERUPDATEUTILITYKEEPALIVE --------------- ", "System use: Close AtlasServerUpdateUtilityKeepAlive? (Checked prior to restarting above Program... used when purposely shutting down above Program)(yes/no) ###", "yes")
	_Splash("Restarting utility. . .", 2500)
	Local $Pid
	If Not $__Restart Then
		If @Compiled Then
			$Pid = Run(@ScriptFullPath & ' ' & $CmdLineRaw, @ScriptDir, Default, 1)
		Else
			$Pid = Run(@AutoItExe & ' "' & @ScriptFullPath & '" ' & $CmdLineRaw, @ScriptDir, Default, 1)
		EndIf
		If @error Then
			Return SetError(@error, 0, 0)
		EndIf
		StdinWrite($Pid, @AutoItPID)
	EndIf
	$__Restart = 1
	If $fExit Then
		Sleep(50)
		_ExitUtil(False) ; False = Exit util without sleep(2000)
	EndIf
	Return 1
EndFunc   ;==>_RestartUtil

Func OnAutoItStart()
	Sleep(50)
	Local $Pid = ConsoleRead(1)
	If @extended Then
		While ProcessExists($Pid)
			Sleep(100)
		WEnd
	EndIf
EndFunc   ;==>OnAutoItStart
#EndRegion _RestartUtil Function

Func SetStatusBusy($tMsg0, $tMsg1 = "no")
	If $tMsg1 = "no" Then $tMsg1 = $tMsg0
	TraySetToolTip($tMsg0)
	TraySetIcon($aIconFile, 201)
	GUICtrlSetImage($IconReady, $aIconFile, 203) ; Busy Icon
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
	If $tMB = 6 Then ; YES
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
					$sUseDiscordBotStopServer = "yes"
					IniWrite($aIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for STOP SERVER? (yes/no) ###", "yes")
					_Splash("Stop Server Discord and In-Game Announcements were disabled." & @CRLF & @CRLF & "The following setting was changed in the " & $aUtilName & ".ini." & @CRLF _
							 & """Send Discord message for STOP SERVER? (yes/no) ###=yes""", 7000, 500, 150)
				Else
					LogWrite(" [" & $aServerName & "] No changes made to STOP SERVER Discord announcement setting in " & $aUtilName & ".ini.")
					_Splash("No changes were made. Resuming utility . . .", 2000)
				EndIf
			EndIf
			If ($sUseDiscordBotStopServer = "yes") Or ($sUseTwitchBotStopServer = "yes") Or ($sInGameAnnounce = "yes") Then
				$aRebootReason = "stopservers"
				$aBeginDelayedShutdown = 1
				$aTimeCheck0 = _NowCalc()
				_Splash("Stop Server with announcements initiated.", 2000)
			Else
				LogWrite(" [" & $aServerName & "] Stop Server Discord, Twitch, and In-Game announcements are disabled in " & @CRLF & $aUtilName & ".ini.")
				_Splash("Stop Server Discord, Twitch, and In-Game announcements are disabled." & @CRLF & @CRLF & "Stopping servers WITHOUT announcements", 0, 500, 150)
				SetStatusBusy("Stopping Servers")
				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, True) ; Do NOT close redis, But disable servers
				SetStatusIdle()
				SplashOff()
			EndIf
		EndIf
		; ----------------------------------------------------------
	ElseIf $tMB = 7 Then
		SetStatusBusy("Stopping Servers")
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, True) ; Do NOT close redis, But disable servers
		SetStatusIdle()
		; ----------------------------------------------------------
	ElseIf $tMB = 2 Then ; CANCEL
		SetStatusBusy("Canceled")
		LogWrite(" [" & $aServerName & "] Stop Server request canceled by user.")
		_Splash("Stop Server canceled. Resuming utility . . .", 2000)
	EndIf
	SetStatusIdle()
EndFunc   ;==>F_StopServer

Func F_StartServer()
	LogWrite(" [Server] Start all servers requested by user (Start Server(s)).")
	$tMsg1 = "Starting all servers." & @CRLF & @CRLF
	$aSplash = _Splash($tMsg1, 0, 500)
	SetStatusBusy("Starting all server(s).", "Start Servers")
	Local $tFirstGrid = True
	For $i = 0 To ($aServerGridTotal - 1)
		If Not ProcessExists($aServerPID[$i]) Then ; And ($xStartGrid[$i] = "yes") Then
			If ($xLocalGrid[$i] = "yes") Then
				_GUICtrlListView_SetItemChecked($wMainListViewWindow, $i, True)
				If $tFirstGrid = False Then
					Local $tDelay = Int($aServerStartDelay) + ($xGridStartDelay[$i])
					For $x = 0 To ($tDelay - 1)
						ControlSetText($aSplash, "", "Static1", "Starting server " & _ServerNamingScheme($i, $aNamingScheme) & " in " & ($tDelay - $x) & " seconds.")
						SetStatusBusy("Starting Server " & _ServerNamingScheme($i, $aNamingScheme) & " in " & ($tDelay - $x))
						Sleep(1000)
					Next
				Else
					$tFirstGrid = False
					ControlSetText($aSplash, "", "Static1", "Starting server " & _ServerNamingScheme($i, $aNamingScheme) & " in 1 seconds.")
					SetStatusBusy("Starting Server " & _ServerNamingScheme($i, $aNamingScheme) & " in 1")
					Sleep(1000)
				EndIf
				If $aServerMinimizedYN = "no" Then
					$aServerPID[$i] = Run($xServerStart[$i])
				Else
					$aServerPID[$i] = Run($xServerStart[$i], "", @SW_MINIMIZE)
				EndIf
				$xServerCPU[$i] = _ProcessUsageTracker_Create("", $aServerPID[$i])
				LogWrite(" [Server] Server " & _ServerNamingScheme($i, $aNamingScheme) & " started (PID: " & $aServerPID[$i] & ")]", " [Server " & _ServerNamingScheme($i, $aNamingScheme) & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
				$xStartGrid[$i] = "yes"
				IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", "yes")
			EndIf
		EndIf
	Next
	SplashOff()
	SetStatusIdle()
EndFunc   ;==>F_StartServer

Func F_UpdateUtilCheck()
	LogWrite(" [Util] " & $aUtilName & " update check requested by user (Check for Updates).")
	$aShowUpdate = True
	UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName, 0, "show")
EndFunc   ;==>F_UpdateUtilCheck

Func F_UpdateServCheck()
	Local $aMsg = "Check for " & $aGameName & " server updates." & @CRLF & @CRLF & _
			"Click (YES) to check for update and install if update available." & @CRLF & _
			"Click (NO) to FORCE an update with -validate. WARNING! Will shutdown all servers!" & @CRLF & _
			"Click (CANCEL) to cancel update check."
	SplashOff()
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 30)
	If $tMB = 6 Then ; YES
		SplashOff()
		_Splash("Checking for server updates.")
		SetStatusBusy("Check: Server Update")
		UpdateCheck(True)
		SetStatusIdle()
		SplashOff()
	ElseIf $tMB = 7 Then ; NO
		Local $aMsg = "Check for " & $aGameName & " server updates." & @CRLF & @CRLF & _
				"WARNING! Continuing will shut down all servers and perform a steamcmd update with -validate." & @CRLF & @CRLF & _
				"Click (YES) to shut down servers and perform update." & @CRLF & _
				"Click (NO) or (CANCEL) to cancel and resume utility."
		SplashOff()
		$tMB1 = MsgBox($MB_YESNOCANCEL, $aUtilName, $aMsg, 30)
		If $tMB1 = 6 Then ; YES
			$bUpdateRequired = True
			$aSteamUpdateNow = True
			$aUpdateVerify = "yes"
			RunExternalScriptUpdate()
			$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
			SteamcmdDelete($aSteamCMDDir)
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, False)
		Else
			_Splash("Update check canceled. Resuming utility . . .", 2000)
		EndIf
	ElseIf $tMB = 2 Then ; CANCEL
		_Splash("Update check canceled. Resuming utility . . .", 2000)
	EndIf
EndFunc   ;==>F_UpdateServCheck

Func F_SendMessage($tAllorSel = "ask")
	SetStatusBusy("Send Message. Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [Remote RCON] Broadcast message requested by user (Send message).")
	SplashOff()
	Local $tResponse = ""
	If $aGridSomeDisable And $tAllorSel = "ask" Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Send in-game message to ALL servers, including disabled ones in GridStartSelect?" & @CRLF & @CRLF & _
				"Click (YES) to send message to ALL servers." & @CRLF & _
				"Click (NO) to send to LOCAL hosted servers (only ones marked ""yes"" in GridStartSelect)." & @CRLF & _
				"Click (CANCEL) to cancel.", 15)
		;		If $tMB = 6 Then ; (YES)
		If $tMB = 2 Then
			LogWrite(" [Remote RCON] Broadcast message canceled by user.")
			_Splash("Broadcast Message canceled. Resuming utility . . .", 2000)
		Else
			$tMsg = InputBox($aUtilName, "Enter message to broadcast to all active servers", "", "", 400, 125)
			If $tMsg = "" Then
				LogWrite(" [Remote RCON] Broadcast message canceled by user.")
				_Splash("Broadcast Message canceled. Resuming utility . . .", 2000)
			Else
				$tMsg = "broadcast " & $tMsg
				If $tMB = 6 Then
					LogWrite(" [Remote RCON] Sending message to ALL servers, including disabled ones in GridStartSelect:" & $tMsg)
					_Splash("Sending message to ALL servers: " & @CRLF & $tMsg)
;~ 					$tMsg = SendMessageAddDuration($tMsg)
					For $i = 0 To ($aServerGridTotal - 1)
						Local $tRCON = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no", $aRCONResponseWaitms)
						If $aRCONError Then $tRCON = "[Time out error: No Response]"
						$tResponse &= "Server " & _ServerNamingScheme($i, $aNamingScheme) & ":" & ReplaceCRLF($tRCON) & @CRLF
					Next
					_RCONMsgBox($tMsg, $tResponse, "Message")
;~ 					_Splash("Broadcast Message sent: " & $tMsg, 2000)
				ElseIf $tMB = 7 Then
					LogWrite(" [Remote RCON] Sending message to local servers:" & $tMsg)
					_Splash("Sending message to local servers: " & @CRLF & $tMsg)
;~ 					$tMsg = SendMessageAddDuration($tMsg)
					For $i = 0 To ($aServerGridTotal - 1)
						If $xStartGrid[$i] = "yes" Then
							Local $tRCON = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no", $aRCONResponseWaitms)
							If $aRCONError Then $tRCON = "[Time out error: No Response]"
							$tResponse &= "Server " & _ServerNamingScheme($i, $aNamingScheme) & ":" & ReplaceCRLF($tRCON) & @CRLF
						EndIf
					Next
					_RCONMsgBox($tMsg, $tResponse, "Message")
;~ 					_Splash("Broadcast Message sent. " & $tMsg, 2000)
				EndIf
			EndIf
		EndIf
	ElseIf $tAllorSel = "all" Then
		$tMsg = InputBox($aUtilName, "Enter message to broadcast to all servers", "", "", 400, 125)
		If $tMsg = "" Then
			LogWrite(" [Remote RCON] Broadcast message canceled by user.")
			_Splash("Broadcast Message canceled. Resuming utility . . .", 2000)
		Else
			$tMsg = "broadcast " & $tMsg
			LogWrite(" [Remote RCON] Sending message to all servers: " & $tMsg)
			_Splash("Sending message to ALL servers: " & @CRLF & $tMsg)
;~ 			$tMsg = SendMessageAddDuration($tMsg)
			For $i = 0 To ($aServerGridTotal - 1)
				Local $tRCON = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no", $aRCONResponseWaitms)
				If $aRCONError Then $tRCON = "[Time out error: No Response]"
				$tResponse &= "Server " & _ServerNamingScheme($i, $aNamingScheme) & ":" & ReplaceCRLF($tRCON) & @CRLF
			Next
			_RCONMsgBox($tMsg, $tResponse, "Message")
;~ 			_Splash("Broadcast Message sent. " & $tMsg, 2000)
		EndIf
	ElseIf $tAllorSel = "sel" Then
		$tMsg = InputBox($aUtilName, "Enter message to broadcast to selected servers", "", "", 400, 125)
		If $tMsg = "" Then
			LogWrite(" [Remote RCON] Broadcast message canceled by user.")
			_Splash("Broadcast Message canceled. Resuming utility . . .", 2000)
		Else
			$tMsg = "broadcast " & $tMsg
			LogWrite(" [Remote RCON] Sending message to selected servers:" & $tMsg)
			_Splash("Sending message to selected servers: " & @CRLF & $tMsg)
;~ 			$tMsg = SendMessageAddDuration($tMsg)
			For $i = 0 To ($aServerGridTotal - 1)
				If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
					Local $tRCON = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no", $aRCONResponseWaitms)
					If $aRCONError Then $tRCON = "[Time out error: No Response]"
					$tResponse &= "Server " & _ServerNamingScheme($i, $aNamingScheme) & ":" & ReplaceCRLF($tRCON) & @CRLF
				EndIf
			Next
			_RCONMsgBox($tMsg, $tResponse, "Message")
;~ 			_Splash("Broadcast Message sent. " & $tMsg, 2000)
		EndIf
	EndIf
	SetStatusIdle()
EndFunc   ;==>F_SendMessage

Func F_SendRCON($tAllorSel = "ask", $tMsgCmd = "")
	SetStatusBusy("Send RCON. Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [Remote RCON] Send RCON command requested by user (Send command).")
	SplashOff()
	Local $tResponse = ""
	;	$tMsg = ""
	If $aGridSomeDisable And $tAllorSel = "ask" Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Send Send RCON command to ALL servers, including disabled ones in GridStartSelect?" & @CRLF & @CRLF & _
				"Click (YES) to send RCON command to ALL servers." & @CRLF & _
				"Click (NO) to send to LOCAL hosted servers (only ones marked ""yes"" in GridStartSelect)." & @CRLF & _
				"Click (CANCEL) to cancel.", 15)
		;		If $tMB = 6 Then ; (YES)
		If $tMB = 2 Then
			LogWrite(" [Remote RCON] Send RCON command canceled by user.")
			_Splash("Send RCON command canceled. Resuming utility . . .", 2000)
		Else
			$tMsg = InputBox($aUtilName, "Enter RCON command to send to all active servers", "", "", 400, 125)
			If $tMsg = "" Then
				LogWrite(" [Remote RCON] Send RCON command canceled by user.")
				_Splash("Send RCON command canceled. Resuming utility . . .", 2000)
			Else
				If $tMB = 6 Then
					LogWrite(" [Remote RCON] Sending RCON command to ALL servers, including disabled ones in GridStartSelect:" & $tMsg)
					_Splash("Sending RCON command to ALL servers: " & @CRLF & $tMsg)
					For $i = 0 To ($aServerGridTotal - 1)
						Local $tRCON = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no", $aRCONResponseWaitms)
						If $aRCONError Then $tRCON = "[Time out error: No Response]"
						$tResponse &= "Server " & _ServerNamingScheme($i, $aNamingScheme) & ":" & ReplaceCRLF($tRCON) & @CRLF
					Next
					_RCONMsgBox($tMsg, $tResponse, "RCON")
;~ 					_Splash($aUtilName, "RCON command sent. " & $tMsg, 2000)
				ElseIf $tMB = 7 Then
					LogWrite(" [Remote RCON] Sending RCON command to local servers:" & $tMsg)
					_Splash("Sending RCON command to local servers: " & @CRLF & $tMsg)
					For $i = 0 To ($aServerGridTotal - 1)
						If $xStartGrid[$i] = "yes" Then
							Local $tRCON = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no", $aRCONResponseWaitms)
							If $aRCONError Then $tRCON = "[Time out error: No Response]"
							$tResponse &= "Server " & _ServerNamingScheme($i, $aNamingScheme) & ":" & ReplaceCRLF($tRCON) & @CRLF
						EndIf
					Next
					_RCONMsgBox($tMsg, $tResponse, "RCON")
;~ 					_Splash("RCON command sent. " & $tMsg, 2000)
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
			_Splash("Send RCON command canceled. Resuming utility . . .", 2000)
		Else
			LogWrite(" [Remote RCON] Sending RCON command to all servers: " & $tMsg)
			If $tMsgCmd = "" Then
				_Splash("Sending RCON command to ALL servers: " & @CRLF & $tMsg)
			EndIf
			For $i = 0 To ($aServerGridTotal - 1)
				Local $tRCON = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no", $aRCONResponseWaitms)
				If $aRCONError Then $tRCON = "[Time out error: No Response]"
				$tResponse &= "Server " & _ServerNamingScheme($i, $aNamingScheme) & ":" & ReplaceCRLF($tRCON) & @CRLF
			Next
			If $tMsgCmd = "" Then
				_RCONMsgBox($tMsg, $tResponse, "RCON")
;~ 				_Splash("RCON command sent. " & $tMsg, 2000)
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
			_Splash("Sending RCON command to selected servers: " & @CRLF & $tMsg)
		EndIf
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Then
				Local $tRCON = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no", $aRCONResponseWaitms)
				If $aRCONError Then $tRCON = "[Time out error: No Response]"
				$tResponse &= "Server " & _ServerNamingScheme($i, $aNamingScheme) & ":" & ReplaceCRLF($tRCON) & @CRLF
			EndIf
		Next
		If $tMsgCmd = "" Then
			_RCONMsgBox($tMsg, $tResponse, "RCON")
;~ 			_Splash("RCON command sent. " & $tMsg, 2000)
		EndIf
	ElseIf $tAllorSel = "local" Then
		If $tMsgCmd = "" Then
			$tMsg = InputBox($aUtilName, "Enter RCON command to send to selected servers", "", "", 400, 125)
		Else
			$tMsg = $tMsgCmd
		EndIf
		LogWrite(" [Remote RCON] Sending RCON command to selected servers:" & $tMsg)
		If $tMsgCmd = "" Then
			_Splash("Sending RCON command to selected servers: " & @CRLF & $tMsg)
		EndIf
		For $i = 0 To ($aServerGridTotal - 1)
			If $xStartGrid[$i] = "yes" Then
				Local $tRCON = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no", $aRCONResponseWaitms)
				If $aRCONError Then $tRCON = "[Time out error: No Response]"
				$tResponse &= "Server " & _ServerNamingScheme($i, $aNamingScheme) & ":" & ReplaceCRLF($tRCON) & @CRLF
			EndIf
		Next
		If $tMsgCmd = "" Then
			_RCONMsgBox($tMsg, $tResponse, "RCON")
;~ 			_Splash("RCON command sent. " & $tMsg, 2000)
		EndIf
	EndIf
	SetStatusIdle()
EndFunc   ;==>F_SendRCON

Func _RCONMsgBox($tMsg, $tResponse, $tRCONorMsg = "RCON")
	SplashOff()
	If $tRCONorMsg = "RCON" Then
		Local $tTxt1 = "RCON command sent"
	Else
		Local $tTxt1 = "Broadcast Message sent"
	EndIf
	Local $tTxt = $tTxt1 & ":" & @CRLF & $tMsg & @CRLF & @CRLF & "Response:" & @CRLF & $tResponse
	ClipPut($tTxt)
	LogWrite("", " [Remote RCON] " & ReplaceCRLF($tTxt))
	MsgBox($MB_OK, $aUtilName, $tTxt & @CRLF & @CRLF & "Response copied to clipboard.", 30)
EndFunc   ;==>_RCONMsgBox

Func SendMessageAddDuration($tTxt)
	If $sInGameMessageDuration = 6 Then
		Return $tTxt
	Else
		Local $tTxt1 = ""
		For $i = 1 To $sInGameMessageDuration
			$tTxt1 &= "   "
		Next
		$tTxt2 = "-" & $tTxt1 & "\n" & $tTxt & "\n-" & $tTxt1
		Return $tTxt2
	EndIf
EndFunc   ;==>SendMessageAddDuration

Func _ServerNamingScheme($ti, $tScheme)
	If $tScheme = 1 Then Return $xServergridx[$ti] & $xServergridy[$ti]
	If $tScheme = 2 Then Return Chr(Int($xServergridx[$ti]) + 65) & (Int($xServergridy[$ti]) + 1)
	If $tScheme = 3 Then Return $xServergridx[$ti] & "," & $xServergridy[$ti]
EndFunc   ;==>_ServerNamingScheme

Func SelectServersStop($tServNo = -1)
	SetStatusBusy("Stop select server(s). Waiting for User Input.", "Waiting for User Input")
	LogWrite(" [Remote RCON] Send shutdown (DoExit) command to select servers requested by user (Stop Server(s)).")
	If $tServNo = -1 Then
		$bMsg = "Shut down selected server(s)." & @CRLF & @CRLF & _
				"Click (YES) to shutdown select servers WITH an announcement." & @CRLF & _
				"Click (NO)  to shutdown select servers with NO announcement." & @CRLF & _
				"Click (CANCEL) to cancel."
	Else
		$bMsg = "Shut down server " & _ServerNamingScheme($tServNo, $aNamingScheme) & "." & @CRLF & @CRLF & _
				"Click (YES) to shutdown WITH an announcement." & @CRLF & _
				"Click (NO)  to shutdown with NO announcement." & @CRLF & _
				"Click (CANCEL) to cancel."
	EndIf
	SplashOff()
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $bMsg, 60)
	; ----------------------------------------------------------
	If $tMB = 6 Then ; YES
		If $aBeginDelayedShutdown = 0 Then
			Local $tSelectServersTxt1 = "("
			For $i = 0 To ($aServerGridTotal - 1)
				If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Or $i = $tServNo Then
;~ 					$tSelectServersTxt &= $xServergridx[$i] & $xServergridy[$i] & " "
					$tSelectServersTxt1 &= _ServerNamingScheme($i, $sAnnounceNamingScheme) & " "
				EndIf
			Next
			$tSelectServersTxt &= StringTrimRight($tSelectServersTxt1, 1) & ") "
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
					$sUseDiscordBotStopServer = "yes"
					IniWrite($aIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for STOP SERVER? (yes/no) ###", "yes")
					_Splash("Stop Server Discord and In-Game Announcements were disabled." & @CRLF & @CRLF & "The following setting was changed in the " & $aUtilName & ".ini." & @CRLF _
							 & """Send Discord message for STOP SERVER? (yes/no) ###=yes""", 7000, 500, 150)
				Else
					LogWrite(" [" & $aServerName & "] No changes made to STOP SERVER Discord announcement setting in " & $aUtilName & ".ini.")
					_Splash("No changes were made. Resuming utility . . .", 2000)
				EndIf
			EndIf
			If ($sUseDiscordBotStopServer = "yes") Or ($sUseTwitchBotStopServer = "yes") Or ($sInGameAnnounce = "yes") Then
				$aRebootReason = "stopservers"
				$aSelectServers = True
				$aBeginDelayedShutdown = 1
				$aTimeCheck0 = _NowCalc()
				_Splash("Stop Server with announcements initiated.", 2000)
			Else
				LogWrite(" [" & $aServerName & "] Stop Server Discord, Twitch, and In-Game announcements are disabled in " & @CRLF & $aUtilName & ".ini.")
				_Splash("Stop Server Discord, Twitch, and In-Game announcements are disabled" & @CRLF & @CRLF & "Stopping servers WITHOUT announcements", 0, 500, 150)
				SetStatusBusy("Stopping Servers")
				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass, False, True) ; Do NOT close redis, But disable servers
				SetStatusIdle()
				SplashOff()
			EndIf
		EndIf
		; ----------------------------------------------------------
	ElseIf $tMB = 7 Then ; NO
		$tMsg1 = "Sending shutdown (DoExit) command to select servers."
		$aSplash = _Splash($tMsg1, 0, 500)
		SetStatusBusy("Stopping select server(s).", "Stop Server ")
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Or $i = $tServNo Then
				ControlSetText($aSplash, "", "Static1", $tMsg1 & @CRLF & @CRLF & "Server:" & _ServerNamingScheme($i, $aNamingScheme))
				GUICtrlSetData($LabelUtilReadyStatus, "Stop Server " & _ServerNamingScheme($i, $aNamingScheme))
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, "DoExit", "no", $aRCONResponseWaitms)
				LogWrite(" [Server] " & $tMsg1 & " Server:" & _ServerNamingScheme($i, $aNamingScheme))
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
				If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Or $i = $tServNo Then
					If ProcessExists($aServerPID[$i]) Then
						Local $tTime = TimerInit()
						$aErrorShutdown = 1
						SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, "DoExit", "no", 0)
						SendCTRLC($aServerPID[$i])
					EndIf
				EndIf
			Next
			If $aErrorShutdown = 1 Then
				Local $tDelay = 1000 - (TimerDiff($tTime))
				If $tDelay < 0 Then $tDelay = 0
				Sleep($tDelay)
				ControlSetText($aSplash, "", "Static1", "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . ." & @CRLF & @CRLF & "Countdown: " & ($aShutDnWait - $k))
				GUICtrlSetData($LabelUtilReadyStatus, "Stop Svr Cntdn " & ($aShutDnWait - $k))
				$aErrorShutdown = 0
			Else
				ExitLoop
			EndIf
		Next
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Or $i = $tServNo Then
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
	ElseIf $tMB = 2 Then ; CANCEL
		LogWrite(" [Remote RCON] Select server(s) shutdown CANCELED.")
		GUICtrlSetData($LabelUtilReadyStatus, "Stop Server CANCELED")
		_Splash("Select server(s) shutdown CANCELED.", 2000)
	EndIf
	SetStatusIdle()
EndFunc   ;==>SelectServersStop

Func SelectServersStart($tServNo = -1)
	LogWrite(" [Server] Start select servers requested by user (Start Server(s)).")
	$tMsg1 = "Starting select servers." & @CRLF & @CRLF
	$aSplash = _Splash($tMsg1, 0, 500)
	SetStatusBusy("Starting select server(s).", "Start Servers")
	Local $tFirstGrid = True
	For $i = 0 To ($aServerGridTotal - 1)
		If Not ProcessExists($aServerPID[$i]) And (_GUICtrlListView_GetItemChecked($wMainListViewWindow, $i) Or $i = $tServNo) Then ; And ($xStartGrid[$i] = "yes") Then
			If ($xLocalGrid[$i] = "yes") Then
;~ 				ControlSetText($aSplash, "", "Static1", "Starting server " & _ServerNamingScheme($i, $aNamingScheme))
;~ 				GUICtrlSetData($LabelUtilReadyStatus, "Start Server " & _ServerNamingScheme($i, $aNamingScheme))
				If $tFirstGrid = False Then
					Local $tDelay = Int($aServerStartDelay) + ($xGridStartDelay[$i])
					For $x = 0 To ($tDelay - 1)
						ControlSetText($aSplash, "", "Static1", "Starting server " & _ServerNamingScheme($i, $aNamingScheme) & " in " & ($tDelay - $x) & " seconds.")
						SetStatusBusy("Starting Server " & _ServerNamingScheme($i, $aNamingScheme) & " in " & ($tDelay - $x))
						Sleep(1000)
					Next
				Else
					$tFirstGrid = False
					ControlSetText($aSplash, "", "Static1", "Starting server " & _ServerNamingScheme($i, $aNamingScheme) & " in 1 seconds.")
					SetStatusBusy("Starting Server " & _ServerNamingScheme($i, $aNamingScheme) & " in 1")
					Sleep(1000)
				EndIf
				If $aServerMinimizedYN = "no" Then
					$aServerPID[$i] = Run($xServerStart[$i])
				Else
					$aServerPID[$i] = Run($xServerStart[$i], "", @SW_MINIMIZE)
				EndIf
				$xServerCPU[$i] = _ProcessUsageTracker_Create("", $aServerPID[$i])
				LogWrite(" [Server] Server " & _ServerNamingScheme($i, $aNamingScheme) & " started (PID: " & $aServerPID[$i] & ")]", " [Server " & _ServerNamingScheme($i, $aNamingScheme) & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
				$xStartGrid[$i] = "yes"
				IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", "yes")
			Else
				ControlSetText($aSplash, "", "Static1", "Server NOT started because it is not local: " & _ServerNamingScheme($i, $aNamingScheme))
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
	ElseIf $tReturn = "" Then ; Empty/Blank File
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
		ElseIf $tReturn = "" Then ; Empty/Blank File
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
					_Splash($tTxt)
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
	Local $tTmp1 = FileOpen($tFile) ; Open existing ServerPID File
	Local $tReturn1 = FileRead($tTmp1)
	FileClose($tTmp1)
	Local $tTmp2 = FileOpen($tFile & ".bak") ; Open existing ServerPID.bak File
	Local $tReturn2 = FileRead($tTmp2)
	FileClose($tTmp2)
	If $tTmp1 = -1 Then ; ServerPID file not exist
		LogWrite("", " [Util PID Check] Lastpidserver.tmp file not found.")
		$tReturn1 = $tReturn2
		$aNoExistingPID = True
		If $tTmp2 = -1 Then ; ServerPID.bak file not exist
			$tReturn[0] = "0"
			LogWrite("", " [Util PID Check] Lastpidserver.tmp.bak file not found.")
			$aNoExistingPID = True
		Else
			If $tReturn2 = "" Then ; Empty/Blank File
				$tReturn[0] = "0"
				LogWrite("", " [Util PID Check] Lastpidserver.tmp.bak contained no server PID data.")
				$aNoExistingPID = True
				FileDelete($tFile & ".bak")
			EndIf
		EndIf
	Else
		$aNoExistingPID = False
		If $tReturn1 = "" Then ; Empty/Blank File
			LogWrite("", " [Util PID Check] Lastpidserver.tmp file contained no server PID data.")
			$tReturn1 = $tReturn2
			If $tTmp2 = -1 Then ; File not exist
				$tReturn[0] = "0"
				LogWrite("", " [Util PID Check] Lastpidserver.tmp.bak file not found.")
				$aNoExistingPID = True
			Else
				If $tReturn2 = "" Then ; Empty/Blank File
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
					_Splash($tTxt)
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

Func _WinGetByPID($iPID, $iArray = 1) ; 0 Will Return 1 Base Array & 1 Will Return The First Window.
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

Func RespawnDinosCheck($sWDays, $sHours, $sMin)
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
EndFunc   ;==>RespawnDinosCheck

Func DestroyWildDinos()
	$aCMD = "destroywilddinos"
	For $i = 0 To ($aServerGridTotal - 1)
		If ProcessExists($aServerPID[$i]) Then
			SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aCMD, "yes", $aRCONResponseWaitms)
		EndIf
	Next
EndFunc   ;==>DestroyWildDinos

Func BatchFilesCreate($tSplash = 0, $tFolder = "0")
	If $tFolder = "0" Then $tFolder = $aBatFolder
	If $tSplash <> 0 Then ControlSetText($tSplash, "", "Static1", $aStartText & "Creating backup batch files.")
	DirRemove($tFolder, 1)
	DirCreate($tFolder)
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
	FileDelete($tFolder & "\Install_Atlas.bat")
	FileWrite($tFolder & "\Install_Atlas.bat", $tTxtValY)
	FileDelete($tFolder & "\Update_Atlas.bat")
	FileWrite($tFolder & "\Update_Atlas_Validate_Yes.bat", $tTxtValY)
	FileDelete($tFolder & "\Update_Atlas.bat")
	FileWrite($tFolder & "\Update_Atlas_Validate_No.bat", $tTxtValN)

	If FileExists($tFolder & "\Launch_Atlas All.bat") Then FileDelete($aBatFolder & "\Launch_Atlas All.bat")
	FileWriteLine($tFolder & "\Launch_Atlas All.bat", "start """ & $aUtilName & """ cmd /k Call " & $xServerRedis & @CRLF & "timeout /t 5" & @CRLF)
	For $i = 0 To ($aServerGridTotal - 1)
		If $xStartGrid[$i] = "yes" Then
			If FileExists($tFolder & "\Launch_Atlas_" & $xServergridx[$i] & $xServergridy[$i] & ".bat") Then FileDelete($aBatFolder & "\" & "Launch_Atlas_" & $xServergridx[$i] & $xServergridy[$i] & ".bat")
			FileWrite($tFolder & "\Launch_Atlas_" & $xServergridx[$i] & $xServergridy[$i] & ".bat", "Start """ & $aUtilName & """ " & $xServerStart[$i] & @CRLF & "Exit")
			FileWriteLine($tFolder & "\Launch_Atlas All.bat", "start """ & $aUtilName & """ cmd /k Call " & "Launch_Atlas_" & $xServergridx[$i] & $xServergridy[$i] & ".bat" & @CRLF & "timeout /t 1" & @CRLF)
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

Func GetPlayerCount($tSplash = 0, $tStartup = True, $aWriteLog = False) ; $tSplash = Splash handle, 0 = Do not show splash , ;$tStartup = If true, uses startup splash text. If false, uses standard text.
	If ((_DateDiff('s', $aTimeCheck6, _NowCalc())) < 300) Then
		Local $tServerStartDelayDoneTF = False ; False = Servers Startup Delay time has not lapsed
	Else
		Local $tServerStartDelayDoneTF = True ; True = Servers Startup Delay time has lapsed
	EndIf
	Local $aCMD = "listplayers"
	$tOnlinePlayerReady = True
	Global $tOnlinePlayers[4]
	Local $aErr = False
	Local $tUserLog[$aServerGridTotal]
	Local $tUserMsg[$aServerGridTotal]
	Local $tUserNoSteam[$aServerGridTotal]
	Local $aFailedString = " "
	$aServerReadyTF = False
	$tOnlinePlayers[0] = False
	$tOnlinePlayers[1] = ""
	$tOnlinePlayers[2] = ""
	$tOnlinePlayers[3] = ""
	SetStatusBusy("Scanning servers for online players.", "Check: Players")
	For $i = 0 To ($aServerGridTotal - 1)
		If ($xStartGrid[$i] = "yes") Or ($aPollRemoteServersYN = "yes" And $xLocalGrid[$i] = "no") Then
			GUICtrlSetData($LabelUtilReadyStatus, "Check: Players " & _ServerNamingScheme($i, $aNamingScheme))
			If $tStartup Then
				Local $tTxt = $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Preparing GUI. Getting server information." & @CRLF & "Checking online players on server " & _ServerNamingScheme($i, $aNamingScheme)
			Else
				Local $tTxt = "Checking online players on server " & _ServerNamingScheme($i, $aNamingScheme)
			EndIf
			If $tSplash > 0 Then
				ControlSetText($tSplash, "", "Static1", $tTxt)
				GUICtrlSetData($LabelUtilReadyStatus, "Check: Players " & _ServerNamingScheme($i, $aNamingScheme))
			EndIf
			If $aServerRCONIP = "" Then
				$mMsg = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aTelnetPass, $aCMD, "players", $aOnlinePlayerWaitms)
			Else
				$mMsg = SendRCON($aServerRCONIP, $xServerRCONPort[$i + 1], $aTelnetPass, $aCMD, "players", $aOnlinePlayerWaitms)
			EndIf
			If StringInStr($mMsg, "No Players Connected") <> 0 Then
				$aServerPlayers[$i] = 0
			Else
				If $aRCONError Then
					$aErr = True
					$aServerPlayers[$i] = -2
				Else
					$mMsg = StringReplace($mMsg, " ", "")
					$tUserLog[$i] = ""
					$tUserMsg[$i] = ""
					$tUserNoSteam[$i] = ""
					Local $aFailedString = " "
					Local $tUserAll = _StringBetween($mMsg, ".", ",")
					Local $tUserCnt = UBound($tUserAll)
					Local $tSteamAll[$tUserCnt + 1]
					Local $tUsers = _ArrayToString($tUserAll)
					Local $tSteamAll = _StringBetween($mMsg, ",", @CRLF)
;~ 					Local $tSteamID = _ArrayToString($tSteamAll)
					For $x = 0 To ($tUserCnt - 1)
						$tUserLog[$i] &= $tUserAll[$x] & "." & $tSteamAll[$x] & "|"
						$tUserMsg[$i] &= $tUserAll[$x] & " [" & $tSteamAll[$x] & "] "
						$tUserNoSteam[$i] &= $tUserAll[$x] & " "
					Next
					If $tUsers < 0 Then
						$aErr = True
						$aServerPlayers[$i] = -2
					Else
						$aServerPlayers[$i] = $tUserCnt
					EndIf
				EndIf
			EndIf
		Else
			$aServerPlayers[$i] = -2
		EndIf
	Next
	If $aErr Then
		$aFailedString = " Retry:"
		GUICtrlSetData($LabelUtilReadyStatus, "Recheck: Players")
		Sleep(1000)
		For $i = 0 To ($aServerGridTotal - 1)
			If ($xStartGrid[$i] = "yes") Or ($aPollRemoteServersYN = "yes" And $xLocalGrid[$i] = "no") And $aServerPlayers[$i] < 0 Then
				GUICtrlSetData($LabelUtilReadyStatus, "Recheck: Players " & _ServerNamingScheme($i, $aNamingScheme))
				If $tStartup Then
					Local $tTxt = $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Preparing GUI. Getting server information." & @CRLF & "Checking online players on server " & _ServerNamingScheme($i, $aNamingScheme)
				Else
					Local $tTxt = "Checking online players on server " & _ServerNamingScheme($i, $aNamingScheme)
				EndIf
				If $tSplash > 0 Then
					ControlSetText($tSplash, "", "Static1", $tTxt)
					GUICtrlSetData($LabelUtilReadyStatus, "Recheck: Players " & _ServerNamingScheme($i, $aNamingScheme))
				EndIf
				If $aServerRCONIP = "" Then
					$mMsg = SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aTelnetPass, $aCMD, "players", $aOnlinePlayerWaitms)
				Else
					$mMsg = SendRCON($aServerRCONIP, $xServerRCONPort[$i + 1], $aTelnetPass, $aCMD, "players", $aOnlinePlayerWaitms)
				EndIf
				If StringInStr($mMsg, "No Players Connected") <> 0 Then
					$aServerPlayers[$i] = 0
				Else
					If $aRCONError Then
						$aServerPlayers[$i] = -2
					Else
						$mMsg = StringReplace($mMsg, " ", "")
						Local $tUserAll = _StringBetween($mMsg, ".", ",")
						Local $tUserCnt = UBound($tUserAll)
						Local $tSteamAll[$tUserCnt + 1]
						Local $tUsers = _ArrayToString($tUserAll)
						Local $tSteamAll = _StringBetween($mMsg, ",", @CRLF)
;~ 						Local $tSteamID = _ArrayToString($tSteamAll)
						$tUserLog[$i] = ""
						$tUserMsg[$i] = ""
						$tUserNoSteam[$i] = ""
						For $x = 0 To ($tUserCnt - 1)
							$tUserLog[$i] &= $tUserAll[$x] & "." & $tSteamAll[$x] & "|"
							$tUserMsg[$i] &= $tUserAll[$x] & " [" & $tSteamAll[$x] & "] "
							$tUserNoSteam[$i] &= $tUserAll[$x] & " "
						Next
						If $tUsers < 0 Then
							$aServerPlayers[$i] = -2
						Else
							$aServerPlayers[$i] = $tUserCnt
						EndIf
					EndIf
				EndIf
			EndIf
		Next
	EndIf
	For $i = 0 To ($aServerGridTotal - 1)
		If ($xStartGrid[$i] = "yes") Or ($aPollRemoteServersYN = "yes" And $xLocalGrid[$i] = "no") Then
			If $aServerPlayers[$i] = 0 Then
				$tOnlinePlayers[1] = $tOnlinePlayers[1] & _ServerNamingScheme($i, $aNamingScheme) & "(0) "
				$tOnlinePlayers[2] = $tOnlinePlayers[2] & "Server " & _ServerNamingScheme($i, $aNamingScheme) & ": 0" & @CRLF
				$tOnlinePlayers[3] = $tOnlinePlayers[3] & "Server " & _ServerNamingScheme($i, $aNamingScheme) & ": 0" & @CRLF
			ElseIf $aServerPlayers[$i] >= 0 Then
				$tOnlinePlayers[1] = $tOnlinePlayers[1] & _ServerNamingScheme($i, $aNamingScheme) & "(" & $aServerPlayers[$i] & " " & $tUserLog[$i] & ") "
				$tOnlinePlayers[2] = $tOnlinePlayers[2] & "Server " & _ServerNamingScheme($i, $aNamingScheme) & ": " & $aServerPlayers[$i] & " " & $tUserMsg[$i] & @CRLF
				$tOnlinePlayers[3] = $tOnlinePlayers[3] & "Server " & _ServerNamingScheme($i, $aNamingScheme) & ": " & $aServerPlayers[$i] & " " & $tUserNoSteam[$i] & @CRLF
			ElseIf $aServerPlayers[$i] < 0 Then ; Error getting online players
				$tOnlinePlayers[1] = $tOnlinePlayers[1] & _ServerNamingScheme($i, $aNamingScheme) & "(-) "
				$tOnlinePlayers[2] = $tOnlinePlayers[2] & "Server " & _ServerNamingScheme($i, $aNamingScheme) & ": -" & @CRLF
				$tOnlinePlayers[3] = $tOnlinePlayers[3] & "Server " & _ServerNamingScheme($i, $aNamingScheme) & ": -" & @CRLF
			EndIf
		EndIf
	Next
	$tOnlinePlayers[1] &= " "
	If $aErr = 0 Then
		$aServerReadyTF = True
		$tServerStartDelayDoneTF = True
		$aTimeCheck6 = _DateAdd('n', -5, _NowCalc())
	Else
		If $tServerStartDelayDoneTF = False Then _Splash("Online Player Check." & @CRLF & @CRLF & "Waiting up to 5 minutes for servers to come online.", 3000)
	EndIf
	Local $tFile = $aFolderLog & $aUtilName & "_OnlineUserLog_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
	Local $tNumberOfLines = _FileCountLines($tFile)
	If $tNumberOfLines <> 0 Then
		Local $tReadLastLine = FileReadLine($tFile, $tNumberOfLines)
		Local $tLastOnlineArray = _StringBetween($tReadLastLine, "[Online] ", "  ")
		If @error Then
			Local $tLastOnlineString = "No entry"
		Else
			Local $tLastOnlineString = $tLastOnlineArray[0] & "  "
		EndIf
	Else
		Local $tLastOnlineString = ""
	EndIf
	If ($tLastOnlineString <> $tOnlinePlayers[1]) Or $aWriteLog Then
		$tOnlinePlayers[0] = True
		If $tServerStartDelayDoneTF Then
			If $aWriteLog Then
				LogWrite(" [Online Players] " & $tOnlinePlayers[1] & " [Manual Request]")
			Else
				LogWrite(" [Online Players] " & $tOnlinePlayers[1])
			EndIf
			If $tServerStartDelayDoneTF And $aWriteLog = False Then WriteOnlineLog("[Online] " & $tOnlinePlayers[1])
;~ 		If $tSplash = -2 Then
;~ 			MsgBox($MB_OK, $aUtilityVer, "ONLINE PLAYERS CHANGED!" & @CRLF & @CRLF & "Online players: " & @CRLF & $tOnlinePlayers[2], 10)
;~ 		EndIf
;~ 	Else
;~ 		If $tSplash = -2 Then
;~ 			MsgBox($MB_OK, $aUtilityVer, "No Change in online players: " & @CRLF & $tOnlinePlayers[2], 10)
;~ 			LogWrite("[Usr Ck] " & $tOnlinePlayers[1])
;~ 			WriteOnlineLog("[Usr Ck] " & $tOnlinePlayers[1])
		EndIf
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
;~ 	GUICtrlSetState($Players, $GUI_DISABLE)
;~ 	TrayItemSetState($iTrayPlayerCount, $TRAY_DISABLE)
	$aPlayerCountShowTF = True
	If $aServerOnlinePlayerYN = "no" Then
		_Splash("To show online players, " & @CRLF & "you must Enable Online Players Check/Log. . .", 3000)
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
EndFunc   ;==>ShowPlayerCount

Func _WM_SIZE($hWndGUI, $Msg, $wParam, $lParam)
	Local $iHeight, $iWidth
	$iWidth = BitAND($lParam, 0xFFFF) ; _WinAPI_LoWord
	$iHeight = BitShift($lParam, 16) ; _WinAPI_HiWord
	If ($hWndGUI = $wOnlinePlayers) Then
		_WinAPI_MoveWindow($wOnlinePlayers, 10, 10, $iWidth - 20, $iHeight - 20)
	ElseIf ($hWndGUI = $wGUIMainWindow) Then
		;_WinAPI_MoveWindow($wMainListViewWindow, 112, 64, $iWidth - 128, $iHeight - 204)
		_WinAPI_MoveWindow($wMainListViewWindow, 112, 90, $iWidth - 128, $iHeight - 230)
	EndIf
	Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_SIZE

Func ShowOnlinePlayersGUI()
	If $aServerOnlinePlayerYN = "yes" Then
		If $aPlayerCountShowTF Then
			If $aPlayerCountWindowTF = False Then
				$gOnlinePlayerWindow = GUICreate($aUtilName & " Online Players", $aGUIW, $aGUIH, -1, -1, BitOR($WS_SIZEBOX, $WS_MINIMIZEBOX))
				GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_OnlinePlayers_Close", $gOnlinePlayerWindow)
				$wOnlinePlayers = GUICtrlCreateEdit("", 0, 0, _WinAPI_GetClientWidth($gOnlinePlayerWindow), _WinAPI_GetClientHeight($gOnlinePlayerWindow), BitOR($ES_AUTOHSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL, $ES_READONLY)) ; Horizontal Scroll, NO wrap text)
				GUICtrlSetState($wOnlinePlayers, $GUI_FOCUS)
				GUIRegisterMsg($WM_SIZE, "_WM_SIZE")
				$aPlayerCountWindowTF = True
				GUISetState(@SW_SHOWNORMAL, $gOnlinePlayerWindow) ;Shows the GUI window
			EndIf
;~ 			WinSetOnTop($gOnlinePlayerWindow,"",1)
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

Func _ImageToGUIImageListResized($tGUICreate, $tFile, $tWidth = 16, $tHeight = 16) ; By Phoenix125.com
	_GDIPlus_Startup()
	Local $GDIpBmpLarge, $GDIpBmpResized, $GDIbmp, $tReturn
	$GDIpBmpLarge = _GDIPlus_ImageLoadFromFile($tFile) ;GDI+ image!
	$GDIpBmpResized = _GDIPlus_ImageResize($GDIpBmpLarge, $tWidth, $tHeight) ;GDI+ image
	$GDIbmp = _GDIPlus_BitmapCreateHBITMAPFromBitmap($GDIpBmpResized) ;GDI image!
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
;~ 	TrayItemSetState($iTrayShowGUI, $TRAY_DISABLE)
	For $i = 0 To ($aServerGridTotal - 1)
		If ProcessExists($aServerPID[$i]) Then
			Local $tAtlasProcessName = WinGetTitle(_WinGetByPID($aServerPID[$i]))
			ExitLoop
		Else
			Local $tAtlasProcessName = "ShooterGameServer.exe v0.0 ("
		EndIf
	Next
	Global $tAtlasVer = _ArrayToString(_StringBetween($tAtlasProcessName, "ShooterGameServer.exe ", " ("))
	Local $tTitle = $aUtilityVer & " | Atlas Version:" & $tAtlasVer & " | " & $aServerWorldFriendlyName
	#Region ### START Koda GUI section ### Form=G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Temp Work Files\atladkoda(b10-listview).kxf
	Global $wGUIMainWindow = GUICreate($tTitle, 1001, 701, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_MAXIMIZEBOX))
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_Main_Close", $wGUIMainWindow)
	GUISetIcon($aIconFile, 99)
	GUISetBkColor($cMWBackground)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	Global $RestartAllGrids = GUICtrlCreateGroup("Log", 112, 592, 873, 97) ; Previous(8, 592, 985, 97)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKHEIGHT)
	Global $LogTicker = GUICtrlCreateEdit("", 120, 608, 857, 73, BitOR($ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL)) ; Previous(16, 608, 969, 73)
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
	Local $MemStats = MemGetStats() ;Retrieves memory related information
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
	GUICtrlSetTip(-1, "Exit util and shut down all servers")
	Global $ExitDoNotShutDownServers = GUICtrlCreateButton("Exit: Do NOT shut down servers", 824, 16, 163, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_ExitShutDownN")
	GUICtrlSetTip(-1, "Exit util but leave all servers running")
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
	GUICtrlSetTip(-1, "Pause All " & $aUtilName & " functions (Servers will remain running)")
	Global $IconUpdate = GUICtrlCreateIcon($aIconFile, 205, 408, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_CheckForUtilUpdates")
	GUICtrlSetTip(-1, "Check for Updates for " & $aUtilName)
	Global $IconConfig = GUICtrlCreateIcon($aIconFile, 211, 440, 16, 24, 24)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_UtilConfig")
	GUICtrlSetTip(-1, $aUtilName & " Config")
;~ 	GUICtrlCreateGroup("", -99, -99, 1, 1)
;~ 	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	Local $tX = 8, $tY = 54 ; Starting Location
	Local $tGroupW = 89, $tButtonW = $tGroupW - 14, $tButtonH = 25 ; Default Group Dimensions

	Local $tButtons = 4, $tGroupH = (32 * $tButtons + 17)
	Global $ShowWindows = GUICtrlCreateGroup("Show Window", $tX, $tY, $tGroupW, $tGroupH) ; (8, 48, 89, 145)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	$tY += 16
	Global $ServerInfo = GUICtrlCreateButton("Tools", $tX + 8, $tY, $tButtonW, $tButtonH) ; (16, 64, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_Tools")
	GUICtrlSetTip(-1, "Open TOOLS window")
	$tY += 32
	Global $Players = GUICtrlCreateButton("Players", $tX + 8, $tY, $tButtonW, $tButtonH) ; (16, 96, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetState(-1, $GUI_ENABLE)
;~ 	If $aPlayerCountShowTF Then GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_Players")
	GUICtrlSetTip(-1, "Show Online Players Window")
	$tY += 32
	Global $Config = GUICtrlCreateButton("CONFIG", $tX + 8, $tY, $tButtonW, $tButtonH) ; (16, 128, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_Config")
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Display Util Config Window")
	$tY += 32
	Global $LogFile = GUICtrlCreateButton("Log/Ini Files", $tX + 8, $tY, $tButtonW, $tButtonH) ; (16, 160, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_LogFile")
	GUICtrlSetTip(-1, "Open Log, Server Summary, Online Players, and Default " & $aServerName & " Config Files")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	$tY += 40
	Local $tButtons = 6, $tGroupH = (32 * $tButtons + 17)
	Global $RestartAllGrid = GUICtrlCreateGroup("All Grids", $tX, $tY, $tGroupW, $tGroupH) ; Manual(8, 200, 89, 145)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	$tY += 16
	Global $SendRCONAll = GUICtrlCreateButton("Send RCON", $tX + 8, $tY, $tButtonW, $tButtonH) ; Manual(6, 216, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllSendRCON")
	GUICtrlSetTip(-1, "Send RCON Command to All Grids")
	$tY += 32
	Global $SendMsgAll = GUICtrlCreateButton("Send Msg", $tX + 8, $tY, $tButtonW, $tButtonH) ; Manual(16, 248, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllSendMsg")
	GUICtrlSetTip(-1, "Broadcast In Game Message to All Grids")
	$tY += 32
	Global $RemoteRestartAll = GUICtrlCreateButton("Rmt Restart", $tX + 8, $tY, $tButtonW, $tButtonH) ; Manual(16, 280, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllRmtRestart")
	GUICtrlSetTip(-1, "Initiate Remote Restart: Restart All Local Grid Servers with Message and Delay")
	$tY += 32
	Global $RestartNowAll = GUICtrlCreateButton("Restart NOW", $tX + 8, $tY, $tButtonW, $tButtonH) ; Manual(16, 312, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllRestartNow")
	GUICtrlSetTip(-1, "Restart All Local Grid Servers")
	$tY += 32
	Global $StopServerAll = GUICtrlCreateButton("Stop Servers", $tX + 8, $tY, $tButtonW, $tButtonH) ; Manual(16, 312, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_StopServerAll")
	GUICtrlSetTip(-1, "Stop All Grids With or Without Announcement")
	$tY += 32
	Global $StartServerAll = GUICtrlCreateButton("Start Servers", $tX + 8, $tY, $tButtonW, $tButtonH) ; Manual(16, 312, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_StartServerAll")
	GUICtrlSetTip(-1, "Start All Grids With or Without Announcement")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)

	$tY += 40
	Local $tButtons = 4, $tGroupH = (32 * $tButtons + 17)
	Global $SelectedGrids = GUICtrlCreateGroup("Selected Grids", $tX, $tY, $tGroupW, $tGroupH) ; (8, 352, 89, 145)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	$tY += 16
	Global $SendRCONSel = GUICtrlCreateButton("Send RCON", $tX + 8, $tY, $tButtonW, $tButtonH) ;(16, 368, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectSendRCON")
	GUICtrlSetTip(-1, "Send RCON Command to Selected Grids")
	$tY += 32
	Global $SendMsgSel = GUICtrlCreateButton("Send Msg", $tX + 8, $tY, $tButtonW, $tButtonH) ; (16, 400, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectSendMsg")
	GUICtrlSetTip(-1, "Send In Game Message to Selected Grids")
	$tY += 32
	Global $StartServers = GUICtrlCreateButton("Start Server(s)", $tX + 8, $tY, $tButtonW, $tButtonH) ; (16, 432, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectStartServers")
	GUICtrlSetTip(-1, "Start Selected Grids")
	$tY += 32
	Global $StopServers = GUICtrlCreateButton("Stop Server(s)", $tX + 8, $tY, $tButtonW, $tButtonH) ; (16, 464, 75, 25)
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

	Global $GUI_Main_B_SelectAll = GUICtrlCreateButton("Select All", 111, 56, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectAll")
	Global $GUI_Main_B_SelectNone = GUICtrlCreateButton("Select None", 191, 56, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectNone")
	Global $GUI_Main_B_Invert = GUICtrlCreateButton("Invert", 271, 56, 75, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_Invert")
	Global $GUI_Main_B_GridConfigurator = GUICtrlCreateButton("Grid Configurator", 677, 56, 100, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_GridConfigurator")
	GUICtrlSetTip(-1, "Open Grid Configurator Window. TIP: You can also click on server name in main window.")
	Global $GUI_Main_B_BackupMenu = GUICtrlCreateButton("Backup Menu", 782, 56, 100, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_BackupMenu")
	GUICtrlSetTip(-1, "Open Backup Window")
	Global $GUI_Main_B_EventScheduler = GUICtrlCreateButton("Event Scheduler", 887, 56, 100, 25)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_EventScheduler")
	GUICtrlSetTip(-1, "Open Event Scheduler Window")

	;	Global $wMainListViewWindow = _GUICtrlListView_Create($wGUIMainWindow, "", 112, 64, 873, 497, BitOR($LVS_NOLABELWRAP, $LVS_REPORT, $LVS_SHOWSELALWAYS, $LBS_EXTENDEDSEL, $LVS_NOSORTHEADER))
	Global $wMainListViewWindow = _GUICtrlListView_Create($wGUIMainWindow, "", 112, 90, 873, 460, BitOR($LVS_NOLABELWRAP, $LVS_REPORT, $LVS_SHOWSELALWAYS, $LBS_EXTENDEDSEL, $LVS_NOSORTHEADER))
	_GUICtrlListView_SetExtendedListViewStyle($wMainListViewWindow, BitOR($LVS_EX_GRIDLINES, $LVS_EX_SUBITEMIMAGES, $LVS_EX_CHECKBOXES, $LVS_EX_FULLROWSELECT, $LVS_EX_ONECLICKACTIVATE))
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
	Global $hImage = _GUIImageList_Create($tW1, $tH1, 5) ; Load ListView Icons into memory
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_toggle_on_left0.png", $tW1, $tH1) ; 0 - Yes toggle 0
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_toggle_off_left0.png", $tW1, $tH1) ; 1 - No toggle 0
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_button_green_left1.png", $tW1, $tH1) ; 2 - Red button 1
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_button_red_left1.png", $tW1, $tH1) ; 3 - Green button 1
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_check_green_left1.png", $tW1, $tH1) ; 4 - Green checkmark 1
	_ImageToGUIImageListResized($hImage, $aFolderTemp & "i_check_gray_left1.png", $tW1, $tH1) ; 5 - Gray checkmark 1
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
		$aMainLVW[$i][0] = "" ; $xStartGrid[$i] ; Checked YN
		If $xStartGrid[$i] <> "yes" Then
			$aMainLVW[$i][1] = "--" ; Local YN
		Else
			$aMainLVW[$i][1] = $xStartGrid[$i] ; Local YN
		EndIf
		If $xLocalGrid[$i] <> "yes" Then
			$aMainLVW[$i][2] = "yes" ; Local YN
			$aMainLVW[$i][3] = "--"
		Else
			$aMainLVW[$i][2] = "--" ; Local YN
			$aMainLVW[$i][3] = "yes"
		EndIf
		$aMainLVW[$i][4] = $xServerNames[$i] ; "Server " & $xServergridx[$i] & $xServergridy[$i] ; Server Name
		$aMainLVW[$i][5] = _ServerNamingScheme($i, $aNamingScheme) ; Grid
		If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) Then
			$aMainLVW[$i][6] = $aServerPlayers[$i] & " / " & $aServerMaxPlayers ; Online PLayers
		Else
			$aMainLVW[$i][6] = "-- / " & $aServerMaxPlayers ; Online PLayers
		EndIf
		If $xStartGrid[$i] = "yes" Then
			$aMainLVW[$i][7] = "--" ; CPU
;~ 			$aMainLVW[$i][8] = (Int($aServerMem[$i] / (1024 ^ 2))) & " MB" ; Memory
			Local $aMemTmp = ($aServerMem[$i] / (1024 ^ 2))
			$aMainLVW[$i][8] = _AddCommasDecimalNo($aMemTmp) & " MB" ; Memory
		Else
			$aMainLVW[$i][7] = "" ; CPU
			$aMainLVW[$i][8] = "" ; Memory
		EndIf
		$aMainLVW[$i][9] = $xServerAltSaveDir[$i] ; Folder
		$aMainLVW[$i][10] = $aServerPID[$i] ; PID
		If ProcessExists($aServerPID[$i]) Then
			$aMainLVW[$i][11] = "Running" ; Status
		Else
			If $xStartGrid[$i] = "yes" Then
				$aMainLVW[$i][11] = "CRASHED" ; Status
			Else
				If $xLocalGrid[$i] = "yes" Then
					$aMainLVW[$i][11] = "Disabled" ; Status
				Else
					$aMainLVW[$i][11] = "Offline" ; Status
					If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) And ($aServerOnlinePlayerYN = "yes") Then
						$aMainLVW[$i][11] = "Running" ; Status #008000
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

	For $i = 0 To ($aServerGridTotal - 1) ; Place icon for RUN column
		If $xStartGrid[$i] = "yes" Then
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 1, 0)
		Else
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 1, 1)
		EndIf
	Next
	For $i = 0 To ($aServerGridTotal - 1) ; Place icon for RUN column
		If $xLocalGrid[$i] = "yes" Then
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 2, 4)
		Else
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 3, 5)
		EndIf
	Next
	; -----------------------------------------------------------------------------------------------
	Global $aGUIListViewEX = _GUIListViewEx_Init($wMainListViewWindow, $aMainLVW, 0, 0, True, 32 + 1024)
	;	Global $aGUIListViewEX = _GUIListViewEx_Init($wMainListViewWindow, $aMainLVW, 0, 0, True, 2 + 32 + 1024)
	;	For $i = 0 To (UBound($aGUI_Main_Columns) - 1)
	_GUIListViewEx_SetEditStatus($aGUIListViewEX, "*", 0) ; 0 = Not editable
	;	Next
	Local $aSelCol[4] = [Default, $cSWBackground, Default, Default]
	_GUIListViewEx_SetDefColours($aGUIListViewEX, $aSelCol)
	For $i = 0 To ($aServerGridTotal - 1)
		If ProcessExists($aServerPID[$i]) Then ; RUNNING
			_GUIListViewEx_SetColour($aGUIListViewEX, $cSWRunning & ";", $i, 11)
		Else
			If $xStartGrid[$i] = "yes" Then ; CRASHED
				_GUIListViewEx_SetColour($aGUIListViewEX, $cSWCrashed & ";", $i, 11)
			Else
				If $xLocalGrid[$i] = "yes" Then ; DISABLED
					_GUIListViewEx_SetColour($aGUIListViewEX, $cSWDisabled & ";", $i, 11)
				Else ; OFFLINE
					_GUIListViewEx_SetColour($aGUIListViewEX, $cSWOffline & ";", $i, 11)
					If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) And ($aServerOnlinePlayerYN = "yes") Then ; REMOTE PLAYERS ONLINE
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
	Global $IconRefreshPlayers = GUICtrlCreateIcon($aIconFile, 205, 558, 567, 16, 16)
	GUICtrlSetResizing(-1, $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_IconRefreshPlayers")
	GUICtrlSetTip(-1, "Check for Online Players")
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
	GUICtrlSetOnEvent($aPollRemoteServersYN, "GUI_Main_CB_PollRemoteServers")
	If $aPollRemoteServersYN = "yes" Then
		GUICtrlSetState($gPollRemoteServersCB, $GUI_CHECKED)
	Else
		GUICtrlSetState($gPollRemoteServersCB, $GUI_UNCHECKED)
	EndIf
	Global $gPollRemoteServersLabel = GUICtrlCreateLabel("Poll Remote Servers", 310, 568, -1, -1)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	Global $LabelTotalPlayers = GUICtrlCreateLabel("Total Players: ", 432, 568, 71, 17)
	GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
;~ 	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	Global $TotalPlayersEdit = GUICtrlCreateEdit("", 504, 566, 35, 17, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
;~ 	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKBOTTOM + $GUI_DOCKSIZE)
	GUICtrlSetState($TotalPlayersEdit, $GUI_FOCUS)
	DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', '')
	GUICtrlSetData(-1, $aTotalPlayersOnline) ; & " / " & $aServerMaxPlayers)
	GUICtrlSetBkColor(-1, $cLWBackground)
	GUICtrlSetTip(-1, "Total Players Online")
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

Func GUI_Main_L_Column()
	;MsgBox(0, "Kim", "Column Selected")
EndFunc   ;==>GUI_Main_L_Column

; ------------------------------------------------------------------------------------------------------------
;      Update GUI Main GUI Window
; ------------------------------------------------------------------------------------------------------------

Func GUIUpdateQuick()
	Local $MemStats = MemGetStats()
	GUICtrlSetData($MemPercent, $MemStats[$MEM_LOAD] & "%")
	Local $tCPU = _CPUOverallUsageTracker_GetUsage($aCPUOverallTracker)
	GUICtrlSetData($CPUPercent, Int($tCPU) & "%")
	Local $tMainLVW[$aServerGridTotal][12]
	$aServerPI_Stripped = ResizeArray($aServerPID, $aServerGridTotal)
	$aServerMem = _GetMemArrayRawAvg($aServerPI_Stripped)
	Local $tTotalPlayers = 0
	Local $tTotalPlayerError = False
	Local $aHasRemoteServersTF = False
	For $i = 0 To ($aServerGridTotal - 1)
		If $xStartGrid[$i] <> "yes" Then
			$tMainLVW[$i][1] = "--" ; Local YN
		Else
			$tMainLVW[$i][1] = $xStartGrid[$i] ; Local YN
		EndIf
		If $xLocalGrid[$i] <> "yes" Then
			$aMainLVW[$i][2] = "yes" ; Local YN
			$aMainLVW[$i][3] = "--"
		Else
			$aMainLVW[$i][2] = "--" ; Local YN
			$aMainLVW[$i][3] = "yes"
		EndIf
		$tMainLVW[$i][4] = $xServerNames[$i] ; "Server " & $xServergridx[$i] & $xServergridy[$i] ; Server Name
		$tMainLVW[$i][5] = _ServerNamingScheme($i, $aNamingScheme) ; Grid
		If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) And $aServerOnlinePlayerYN = "yes" Then
			$tMainLVW[$i][6] = $aServerPlayers[$i] & " / " & $aServerMaxPlayers ; Online PLayers
		Else
			$tMainLVW[$i][6] = "-- / " & $aServerMaxPlayers ; Online PLayers
		EndIf
		If $xStartGrid[$i] = "yes" Then
			Local $tCPU = _ProcessUsageTracker_GetUsage($xServerCPU[$i])
			$tMainLVW[$i][7] = Round($tCPU, 1) & "%" ; CPU
			Local $aMemTmp = ($aServerMem[$i] / (1024 ^ 2))
			$tMainLVW[$i][8] = _AddCommasDecimalNo($aMemTmp) ; & " MB" ; Memory
		Else
			$tMainLVW[$i][7] = "" ; CPU
			$tMainLVW[$i][8] = "" ; Memory
		EndIf
		$tMainLVW[$i][9] = $xServerAltSaveDir[$i] ; Folder
		If ProcessExists($aServerPID[$i]) Then
			$tMainLVW[$i][11] = "Running" ; Status #008000
			$aCloseServerTF = False
			If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
				_GUIListViewEx_SetColour($aGUIListViewEX, $cSWRunning & ";", $i, 11)
			EndIf
		Else ; Server Not running
			$aServerPID[$i] = ""
			If $xStartGrid[$i] = "yes" Then
				If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
					If $aCloseServerTF Then
						$tMainLVW[$i][11] = "Starting" ; Status
						_GUIListViewEx_SetColour($aGUIListViewEX, $cSWStarting & ";", $i, 11)
						LogWrite(" Server [" & _ServerNamingScheme($i, $aNamingScheme) & "] PID [" & $aMainLVW[$i][10] & "] """ & $xServerNames[$i] & """ restarting.")
					Else
						$tMainLVW[$i][11] = "CRASHED" ; Status
						_GUIListViewEx_SetColour($aGUIListViewEX, $cSWCrashed & ";", $i, 11)
						LogWrite(" WARNING!!! Server [" & _ServerNamingScheme($i, $aNamingScheme) & "] PID [" & $aMainLVW[$i][10] & "] """ & $xServerNames[$i] & """ CRASHED, Restarting server")
					EndIf
				EndIf
			Else
				If $xLocalGrid[$i] = "yes" Then ; Local Server
					If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
						$tMainLVW[$i][11] = "Disabled" ; Status
						_GUIListViewEx_SetColour($aGUIListViewEX, $cSWDisabled & ";", $i, 11)
					EndIf
				Else ; Remote Server
					$aHasRemoteServersTF = True
					If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) And ($aServerOnlinePlayerYN = "yes") Then ; Remote Server with Online Players
						$tMainLVW[$i][11] = "Running" ; Status #008000
						If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
							_GUIListViewEx_SetColour($aGUIListViewEX, $cSWRunning & ";", $i, 11)
						EndIf
					Else ; Remote Server without ListPlayers response (offline)
						If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
							If $aPollRemoteServersYN = "yes" Then
								$tMainLVW[$i][11] = "Offline" ; Status
								_GUIListViewEx_SetColour($aGUIListViewEX, $cSWOffline & ";", $i, 11)
							Else
								$tMainLVW[$i][11] = "Disabled" ; Status
								_GUIListViewEx_SetColour($aGUIListViewEX, $cSWDisabled & ";", $i, 11)
							EndIf
						EndIf
					EndIf
				EndIf
			EndIf
		EndIf
		$tMainLVW[$i][10] = $aServerPID[$i] ; PID
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
			If $xStartGrid[$i] = "yes" Then
				_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 1, 0)
			Else
				_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 1, 1)
			EndIf
		EndIf
		If $tMainLVW[$i][2] <> $aMainLVW[$i][2] Then
			$aMainLVW[$i][2] = $tMainLVW[$i][2]
			If $xLocalGrid[$i] = "yes" Then
				_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 2, 4)
			Else
				_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 3, 5)
			EndIf
		EndIf
	Next
	$aTotalPlayersOnline = $tTotalPlayers
	For $i = 0 To ($aServerGridTotal - 1) ; Place icon for RUN column
		If $xLocalGrid[$i] = "yes" Then
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 2, 4)
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 3, 6)
		Else
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 3, 5)
			_GUICtrlListView_AddSubItem($wMainListViewWindow, $i, "", 2, 6)
		EndIf
	Next

	If $tTotalPlayerError Then $aTotalPlayersOnline = "--"
	GUICtrlSetData($TotalPlayersEdit, $aTotalPlayersOnline) ; & " / " & $aServerMaxPlayers) ; Players Edit Window
	If $tUtilUpdateAvailableTF Then
		GUICtrlSetImage($IconUpdate, $aIconFile, 216)
		GUICtrlSetTip($IconUpdate, $aUtilName & " update available")
	Else
		GUICtrlSetImage($IconUpdate, $aIconFile, 205)
		GUICtrlSetTip($IconUpdate, "Check for Updates for " & $aUtilName)
	EndIf

	For $i = 0 To ($aServerGridTotal - 1)
		If ProcessExists($aServerPID[$i]) Then
			Local $tAtlasProcessName = WinGetTitle(_WinGetByPID($aServerPID[$i]))
			ExitLoop
		Else
			Local $tAtlasProcessName = "ShooterGameServer.exe v0.0 ("
		EndIf
	Next
	If $tAtlasVer = "v0.0" Then
		$tAtlasVer = _ArrayToString(_StringBetween($tAtlasProcessName, "ShooterGameServer.exe ", " ("))
		Local $tTitle = $aUtilityVer & " | Atlas Version:" & $tAtlasVer & " | " & $aServerWorldFriendlyName
		WinSetTitle($wGUIMainWindow, "", $tTitle)
	EndIf
	If FileExists($aExportMainGUIGridFile) Then
		FileDelete($aExportMainGUIGridFile)
	EndIf
	_FileWriteFromArray($aExportMainGUIGridFile, $tMainLVW)
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
		Local $lWidth = 1000, $lHeight = 600 ; 906 , 555
		Global $LogWindow = GUICreate($aUtilityVer & " Logs & Full Config Files", $lWidth, $lHeight, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
		GUISetIcon($aIconFile, 99)
		GUISetBkColor($cMWBackground)
		GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_Log_Close", $LogWindow)
		$lLogTabWindow = GUICtrlCreateTab(8, 8, ($lWidth - 17), ($lHeight - 18)) ;  889, 537
		GUICtrlSetResizing(-1, $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		; ------------------------------------------------------------------------------------------------------------
		$lBasicTab = GUICtrlCreateTabItem("Basic Log")
		If $lDefaultTabNo = 1 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lBasicEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_MULTILINE)
		GUICtrlSetResizing($lBasicEdit, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor($lBasicEdit, $cFWBackground)
		_GUICtrlEdit_SetLimitText($lBasicEdit, 500000)
		Local $tFileOpen = FileOpen($aLogFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetData($lBasicEdit, $tTxt)
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
		If $lDefaultTabNo = 2 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lDetailedEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_MULTILINE)
		GUICtrlSetResizing($lDetailedEdit, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor($lDetailedEdit, $cFWBackground)
		_GUICtrlEdit_SetLimitText($lDetailedEdit, 500000)
		Local $tFileOpen = FileOpen($aLogDebugFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetData($lDetailedEdit, $tTxt)
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
		If $lDefaultTabNo = 3 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lOnlinePlayersEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_MULTILINE)
		GUICtrlSetResizing($lOnlinePlayersEdit, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor($lOnlinePlayersEdit, $cFWBackground)
		_GUICtrlEdit_SetLimitText($lOnlinePlayersEdit, 500000)
		Local $tFileOpen = FileOpen($aOnlinePlayerFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetData($lOnlinePlayersEdit, $tTxt)
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
		If $lDefaultTabNo = 4 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lServerSummaryEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_MULTILINE)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor($lServerSummaryEdit, $cFWBackground)
		_GUICtrlEdit_SetLimitText($lServerSummaryEdit, 500000)
		Local $tFileOpen = FileOpen($aServerSummaryFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetFont($lServerSummaryEdit, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetData($lServerSummaryEdit, $tTxt)
		Global $lServerSummaryBRefresh = GUICtrlCreateButton("Refresh", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_ServerSummary_B_Button")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; ------------------------------------------------------------------------------------------------------------
		$lConfigTab = GUICtrlCreateTabItem("AtlasServerUpdateUtility.ini")
		If $lDefaultTabNo = 5 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lConfigEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		GUICtrlSetResizing($lConfigEdit, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		_GUICtrlEdit_SetLimitText($lConfigEdit, 500000)
		GUICtrlSetBkColor($lConfigEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aIniFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetFont($lConfigEdit, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetData($lConfigEdit, $tTxt)
		Global $lConfigIniBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_Config_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lConfigINIBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_Config_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; ------------------------------------------------------------------------------------------------------------
		$lGridSelectTab = GUICtrlCreateTabItem("GridStartSelect.ini")
		If $lDefaultTabNo = 6 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lGridSelectEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		GUICtrlSetResizing($lGridSelectEdit, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		_GUICtrlEdit_SetLimitText($lGridSelectEdit, 500000)
		GUICtrlSetBkColor($lGridSelectEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aGridSelectFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetFont($lGridSelectEdit, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetData($lGridSelectEdit, $tTxt)
		Global $lGridStartSelectBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_GridSelect_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lGridStartSelectBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_GridSelect_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; ------------------------------------------------------------------------------------------------------------
		$lServerGridTab = GUICtrlCreateTabItem("ServerGrid.json")
		If $lDefaultTabNo = 7 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lServerGridEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		GUICtrlSetResizing($lServerGridEdit, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		_GUICtrlEdit_SetLimitText($lServerGridEdit, 999999)
		GUICtrlSetBkColor($lServerGridEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aConfigFull)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetFont($lServerGridEdit, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetData($lServerGridEdit, $tTxt)
		Global $lServerGridBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_ServerGrid_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lServerGridBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_ServerGrid_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; ------------------------------------------------------------------------------------------------------------
		$lDefaultGameTab = GUICtrlCreateTabItem("DefaultGame.ini")
		If $lDefaultTabNo = 8 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lDefaultGameEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		GUICtrlSetResizing($lDefaultGameEdit, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		_GUICtrlEdit_SetLimitText($lDefaultGameEdit, 500000)
		GUICtrlSetBkColor($lDefaultGameEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aDefaultGame)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetFont($lDefaultGameEdit, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetData($lDefaultGameEdit, $tTxt)
		Global $lDefaultGameBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultGame_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lDefaultGameBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultGame_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; ------------------------------------------------------------------------------------------------------------
		$lDefaultGUSTab = GUICtrlCreateTabItem("DefaultGUS.ini")
		If $lDefaultTabNo = 9 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lDefaultGUSEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		GUICtrlSetResizing($lDefaultGUSEdit, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		_GUICtrlEdit_SetLimitText($lDefaultGUSEdit, 500000)
		GUICtrlSetBkColor($lDefaultGUSEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aDefaultGUS)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetFont($lDefaultGUSEdit, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetData($lDefaultGUSEdit, $tTxt)
		Global $lDefaultGUSBSave = GUICtrlCreateButton("Save", 12, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultGUS_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $lDefaultGUSBReset = GUICtrlCreateButton("Reset", 92, 41, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_Log_DefaultGUS_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKTOP + $GUI_DOCKLEFT + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; ------------------------------------------------------------------------------------------------------------
		$lDefaultEngineTab = GUICtrlCreateTabItem("DefaultEngine.ini")
		If $lDefaultTabNo = 10 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lDefaultEngineEdit = GUICtrlCreateEdit("", 12, 73, ($lWidth - 25), ($lHeight - 90), $WS_HSCROLL + $WS_VSCROLL + $ES_WANTRETURN + $ES_MULTILINE)
		GUICtrlSetResizing($lDefaultEngineEdit, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		_GUICtrlEdit_SetLimitText($lDefaultEngineEdit, 500000)
		GUICtrlSetBkColor($lDefaultEngineEdit, $cFWBackground)
		Local $tFileOpen = FileOpen($aDefaultEngine)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetFont($lDefaultEngineEdit, 9, 400, 0, $fFWFixedFont)
		GUICtrlSetData($lDefaultEngineEdit, $tTxt)
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
	If WinExists($WizardWindowSelect) Then
;~ 		WinSetOnTop($WizardWindowSelect, "", 1)
	Else
		$WizardWindowSelect = GUICreate("AtlasServerUpdateUtility Setup Wizard", 906, 555, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
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
				Sleep(100)
			WEnd
			GUIDelete($WizardWindowSelect)
			$aExitGUIW1 = False
			If $aWizardSelect = 2 Then WizardExisting(1)
			If $aWizardSelect = 3 Then WizardNew()
		EndIf
	EndIf
EndFunc   ;==>WizardSelect
Func GUI_WizardSelect_Close()
	$aExitGUIW1 = True
	$aWizardSelect = 1
	If WinExists($wGUIMainWindow) Then
		GUIDelete($WizardWindowSelect)
		$aExitGUIW1 = False
	Else
		_ExitUtil()
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
	If WinExists($WizardWindowExist) Then
;~ 		WinSetOnTop($WizardWindowExist, "", 1)
	Else
		Global $aGUI_W2_LastTab = 0
		Global $aGUI_W2_T4_GridStartClicked = False
		Global $aGUI_W2_T6_ConfigClicked = False
		If WinExists($wGUIMainWindow) Then $aConfigSettingsImported = True
		$WizardWindowExist = GUICreate("AtlasServerUpdateUtility Setup Wizard", 906, 555, -1, -1)
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
		$Label6 = GUICtrlCreateLabel("Server AltSaveDirectoryName(s) (comma separated. Use same order as servers are listed in ServerGrid.json) ex.A1,A2,A3,B1,B2,B3,C1,C2,C3", 116, 257, 700, 17)
		Global $W2_T2_B_Folders = GUICtrlCreateButton("Enter Folders", 116, 361, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_W2_T2_B_Folders")
		Global $W2_T2_I_AltSaveDIR2 = GUICtrlCreateInput($aServerAltSaveDir, 200, 363, 541, 21)
		GUICtrlSetState(-1, $GUI_DISABLE)
		$Label8 = GUICtrlCreateLabel("Please select the naming scheme for the grid server folders:", 100, 129, 358, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
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
		GUICtrlSetOnEvent(-1, "GUI_W2_T3_R_Method1")
		Global $W2_T3_R_Method2 = GUICtrlCreateRadio("Custom Method 2: Enter RCON ports one-at-a-time using a new popup window for each server.", 100, 417, 600, 17)
		GUICtrlSetOnEvent(-1, "GUI_W2_T3_R_Method2")
		GUICtrlSetState(-1, $GUI_CHECKED)
		$Label9 = GUICtrlCreateLabel("Server RCON ports (comma separated. Use same order as servers are listed in ServerGrid.json", 116, 337, 447, 17)
		Global $W2_T3_B_Ports = GUICtrlCreateButton("Enter Ports", 116, 441, 75, 25)
		GUICtrlSetOnEvent(-1, "GUI_W2_T3_B_Ports")
		Global $W2_T3_I_RCONPorts2 = GUICtrlCreateInput("25710,25712,25714,25716,25718,25720,25722,25724,25726", 200, 443, 573, 21)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$Label10 = GUICtrlCreateLabel("Please select the entry method for the RCON ports for each grid server.", 100, 233, 422, 20)
		GUICtrlSetFont(-1, 10, 400, 0, "MS Sans Serif")
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
		If WinExists($wGUIMainWindow) Then
		Else
			While $aExitGUIW2 = False
				Sleep(100)
			WEnd
			GUIDelete($WizardWindowExist)
			$aExitGUIW2 = False
		EndIf
	EndIf
EndFunc   ;==>WizardExisting

Func GUI_WizardExist_Close()
	If WinExists($wGUIMainWindow) Then
		GUIDelete($WizardWindowExist)
	Else
		$aExitGUIW2 = True
	EndIf
	If $aSplashStartUp <> 0 Then
		$aSplashStartUp = _Splash($aStartText & @CRLF & "Setup Wizard Completed.", 1500, 475)
	EndIf
EndFunc   ;==>GUI_WizardExist_Close

Func GUI_W2_On_Tab()
	Switch GUICtrlRead($WizardTabWindow)
		Case 0 ; Tab 1 Atlas Folder
			GUI_W2_Last_Tab(0)
		Case 1 ; Tab 2 AltSaveDIR
			GUI_W2_Last_Tab(1)
			If $iIniRead Then
				If $aServerAltSaveSelect = "1" Then GUICtrlSetState($W2_T2_R_Default00, $GUI_CHECKED)
				If $aServerAltSaveSelect = "2" Then GUICtrlSetState($W2_T2_R_DefaultA1, $GUI_CHECKED)
				If $aServerAltSaveSelect = "3" Then
					If $aServerAltSaveDir = "" Then
						For $i = 0 To ($aServerGridTotal - 1)
							$aServerAltSaveDir &= $xServerAltSaveDir[$i] & ","
						Next
						$aServerAltSaveDir = RemoveTrailingComma($aServerAltSaveDir)
					Else
					EndIf
					GUICtrlSetState($W2_T2_R_Custom1, $GUI_CHECKED)
					GUICtrlSetData($W2_T2_I_AltSaveDIR, $aServerAltSaveDir)
					GUICtrlSetData($W2_T2_I_AltSaveDIR2, $aServerAltSaveDir)
				EndIf
			EndIf
		Case 2 ; Tab 3 RCON Ports
			GUI_W2_Last_Tab(2)
			If $aConfigSettingsImported Then
				If $iIniRead Then
					GUICtrlSetData($W2_T3_I_RCONPorts, $aServerRCONPort)
					GUICtrlSetData($W2_T3_I_RCONPorts2, $aServerRCONPort)
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
					GUICtrlSetData($W2_T3_I_RCONPorts2, $tRCONStr)
				EndIf
			EndIf
			If $iIniRead And ($aServerRCONImport = "yes") Then GUICtrlSetState($W2_T3_R_Import, $GUI_CHECKED)
		Case 3 ; Tab 4 Grid Start
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
		Case 4 ; Tab 5 Priority Settings
			GUI_W2_Last_Tab(4)
			If $iIniRead Then
				GUICtrlSetData($W2_T5_I_AdminPass, $aServerAdminPass)
				GUICtrlSetData($W2_T5_I_MaxPlayers, $aServerMaxPlayers)
				GUICtrlSetData($W2_T5_I_ReservedSlots, $aServerReservedSlots)
				GUICtrlSetData($W2_T5_I_AtlasExtraCMD, $aServerExtraCMD)
				GUICtrlSetData($W2_T5_I_SteamCMDExtraCMD, $aSteamExtraCMD)
				GUICtrlSetData($W2_T5_I_UpdateInterval, $aUpdateCheckInterval)
			EndIf
		Case 5 ; Tab 6 Review All Settings
			Local $tFileOpen = FileOpen($aIniFile)
			Local $tTxt = FileRead($tFileOpen)
			FileClose($tFileOpen)
			GUICtrlSetData($W2_T6_E_Config, $tTxt)
			GUI_W2_Last_Tab(5)
		Case 6 ; Tab 7 Finish
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
		If $tMB = 6 Then ; YES
			Local $tTxt = GUICtrlRead($W2_T4_E_GridStart)
			Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
			Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
			FileMove($aGridSelectFile, $tFile, 1)
			FileWrite($aGridSelectFile, $tTxt)
			_Splash($aUtilName & "GridStartSelect.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "GridStartSelect.ini_" & $tTime & ".bak", 3000, 525)
		ElseIf $tMB = 2 Then ; CANCEL
			GUI_W2_T4_B_Reset()
		EndIf
	EndIf
	If ($aGUI_W2_LastTab = 5) And ($aGUI_W2_T6_ConfigClicked = True) Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to AtlasServerUpdateUtility.ini?" & @CRLF & @CRLF & _
				"Click (YES) to Save" & @CRLF & _
				"Click (NO) to Skip" & @CRLF & _
				"Click (CANCEL) to Reset.", 10)
		If $tMB = 6 Then ; YES
			GUI_W2_T6_B_Save()
		ElseIf $tMB = 2 Then ; CANCEL
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
	_Splash("Importing settings from " & $aConfigFile & ".", 0, 475)
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
EndFunc   ;==>GUI_W2_T2_R_Custom2
Func GUI_W2_T2_B_Folders()
	SplashOff()
	GUICtrlSetState($W2_T2_R_Custom2, $GUI_CHECKED)
	Local $tTxt = ""
	For $i = 0 To ($aServerGridTotal - 1)
		$tInput = InputBox("AltSaveDIR " & $i + 1 & " of " & $aServerGridTotal, "AltSaveDIR for Server " & _ServerNamingScheme($i, $aNamingScheme) & ":", $xServerAltSaveDir[$i], "", 100, 130)
		If @error Then $tInput = $xServerAltSaveDir[$i]
		If $tInput = "" Then $tInput = "0"
		$xServerAltSaveDir[$i] = $tInput
		$tTxt &= $tInput & ","
	Next
	$aServerAltSaveDir = RemoveTrailingComma($tTxt)
	GUICtrlSetData($W2_T2_I_AltSaveDIR2, $aServerAltSaveDir)
	$aServerAltSaveSelect = 3
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", $aServerAltSaveSelect)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames (Use same order as listed in ServerGrid.json. Comma separated) ###", $aServerAltSaveDir)
EndFunc   ;==>GUI_W2_T2_B_Folders
Func GUI_W2_T2_I_AltSaveDIR()
	$aServerAltSaveSelect = 3
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames Pattern: (1) for 00,01,10,11 (2) for A1,A2,B1,B2 (3) Custom (Enter below) ###", $aServerAltSaveSelect)
	$aServerAltSaveDir = GUICtrlRead($W2_T2_I_AltSaveDIR)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames (Use same order as listed in ServerGrid.json. Comma separated) ###", $aServerAltSaveDir)
	GUICtrlSetState($W2_T2_R_Custom1, $GUI_CHECKED)
	$xServerAltSaveDir = StringSplit($aServerAltSaveDir, ",", 2)
	If $aServerGridTotal <> UBound($xServerAltSaveDir) And ($aServerWorldFriendlyName <> "TempXY") Then
		SplashOff()
		Local $aErrorMsg = " [CRITICAL ERROR!] The number of AltSaveDIRs does not match the number of grids listed in ServerGrid.json file." & @CRLF & "Number of Server AltSaveDIRs:" & (UBound($xServerAltSaveDir)) & ". Grid Total:" & $aServerGridTotal & @CRLF
		LogWrite($aErrorMsg)
		MsgBox($MB_OK, $aUtilityVer, $aErrorMsg)
	EndIf
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
	SplashOff()
	GUICtrlSetState($W2_T3_R_Method2, $GUI_CHECKED)
	Local $tTxt = ""
	For $i = 0 To ($aServerGridTotal - 1)
		$tInput = InputBox("RCON Port " & $i + 1 & " of " & $aServerGridTotal, "RCON Port for Server " & _ServerNamingScheme($i, $aNamingScheme) & ":", $xServerRCONPort[$i + 1], "", 100, 130)
		If @error Then $tInput = $xServerRCONPort[$i + 1]
		If $tInput = "" Then $tInput = "0"
		$xServerRCONPort[$i + 1] = $tInput
		$tTxt &= $tInput & ","
	Next
	$aServerRCONPort = RemoveTrailingComma($tTxt)
	$aServerRCONImport = "no"
	GUICtrlSetData($W2_T3_I_RCONPorts2, $aServerRCONPort)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server RCON Port(s) (comma separated, grid order as in ServerGrid.json, ignore if importing RCON ports) ###", $aServerRCONPort)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Import RCON ports from GameUserSettings.ini files? (yes/no) ###", $aServerRCONImport)
EndFunc   ;==>GUI_W2_T3_B_Ports
; TAB 4 -------------------------
Func GUI_W2_T4_B_Save()
	Local $tTxt = GUICtrlRead($W2_T4_E_GridStart)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
	FileMove($aGridSelectFile, $tFile, 1)
	FileWrite($aGridSelectFile, $tTxt)
	_Splash("GridStartSelect.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "GridStartSelect.ini_" & $tTime & ".bak", 3000, 525)
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
	_Splash($aUtilName & ".ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & ".ini_" & $tTime & ".bak", 3000, 525)
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
		$aSplashStartUp = _Splash($aStartText & @CRLF & "Setup Wizard Completed.", 1500, 475)
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
		$aSplashStartUp = _Splash($aStartText & @CRLF & "Setup Wizard Completed.", 1500, 475)
	EndIf
EndFunc   ;==>W2_T7_B_ExitRestartN

; ------------------------------------------------------------------------------------------------------------
;      Wizard New GUI Window
; ------------------------------------------------------------------------------------------------------------

Func WizardNew()
	SplashOff()
	If WinExists($WizardWindowNew) Then
;~ 		WinSetOnTop($WizardWindowNew, "", 1)
	Else
		#Region ### START Koda GUI section ### Form=G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Temp Work Files\atladkoda(lwiz-2 new)b1.kxf
		$WizardWindowNew = GUICreate("AtlasServerUpdateUtility Setup Wizard", 906, 555, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
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
	$tSplash = _Splash("Downloading and installing " & @CRLF & "SteamCMD and mcrcon.exe (if needed).", 0, 475)
	FileExistsFunc($tSplash)
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
	_Splash("Creating default GridStartSelect.ini file.", 0, 475)
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
;~ 		WinSetOnTop($ConfigEditWindow, "", 1)
	Else
		#Region ### START Koda GUI section ### Form=g:\game server files\autoit\atlasserverupdateutility\temp work files\atladkoda(configedit)b1.kxf
		Global $ConfigEditWindow = GUICreate($aUtilName & " Config Editor", 1001, 701, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME, $WS_MAXIMIZEBOX))
		GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_ConfigEdit_Close", $ConfigEditWindow)
		GUISetIcon($aIconFile, 99)
		GUISetBkColor($cMWBackground)
		Global $C_IniFailWindow = GUICtrlCreateEdit("", 8, 616, 985, 73, BitOR($ES_AUTOVSCROLL, $ES_READONLY, $ES_WANTRETURN, $WS_VSCROLL))
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKBOTTOM + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor(-1, $cLWBackground)
		Local $tFile = FileOpen($aIniFailFileBasic)
		Local $tFailFile = FileRead($tFile)
		FileClose($tFile)
		GUICtrlSetData(-1, $tFailFile)
		$Label1 = GUICtrlCreateLabel("Changes from last util start:", 8, 592, 250, 20)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		Global $C_B_Save = GUICtrlCreateButton("Save", 8, 8, 75, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
		GUICtrlSetOnEvent(-1, "C_B_Save")
		Global $C_B_Reset = GUICtrlCreateButton("Reset", 88, 8, 75, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
		GUICtrlSetOnEvent(-1, "C_B_Reset")
		Global $C_B_SaveResetShutDownN = GUICtrlCreateButton("Save and Restart Util (Leave Servers Running)", 208, 8, 299, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetOnEvent(-1, "C_B_SaveResetShutDownN")
		Global $ConifgINIEdit = GUICtrlCreateEdit("", 8, 40, 985, 545)
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor(-1, $cFWBackground)
		Local $tFileOpen = FileOpen($aIniFile)
		Local $tTxt = FileRead($tFileOpen)
		FileClose($tFileOpen)
		GUICtrlSetData(-1, $tTxt)
		Global $C_B_SaveResetShutDownY = GUICtrlCreateButton("Save and Restart Util (SHUT DOWN Servers)", 512, 8, 243, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
		GUICtrlSetOnEvent(-1, "C_B_SaveResetShutDownY")
		If WinExists($wGUIMainWindow) Then
			GUICtrlSetState($C_B_SaveResetShutDownY, $GUI_ENABLE)
		Else
			GUICtrlSetState($C_B_SaveResetShutDownY, $GUI_DISABLE)
		EndIf
		Global $C_B_ContinueNoRestartUtil = GUICtrlCreateButton("Continue WITHOUT Restarting Util", 800, 8, 195, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKSIZE)
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
			If $tSplash > 0 Then Global $aSplashStartUp = _Splash($aStartText, 0, 475)
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
	_Splash($aUtilName & ".ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & ".ini_" & $tTime & ".bak", 3000, 525)
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

Func ShowGUITools()
	If WinExists($wToolsWindow) Then
;~ 		WinSetOnTop($wToolsWindow, "", 1)
	Else
		$wToolsWindow = GUICreate("AtlasServerUpdateUtility Tools", 906, 555, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
		GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_Tools_Close", $wToolsWindow)
		GUISetIcon($aIconFile, 99)
		GUISetBkColor($cT1Background)
		$Group1 = GUICtrlCreateGroup("Group1", 192, -32, 1, 33)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$Group2 = GUICtrlCreateGroup("AtlasServerUpdateUtility Tools", 24, 24, 857, 505)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		Local $tButtonW = 155, $tButtonH = 33, $tLabelH = 20 ; Default Group Dimensions
		Local $tButtonX = 43, $tButtonY = 67, $tLabelX = $tButtonX + 165, $tLabelY = $tButtonY + 7 ; Starting Location
		; -----------------------------------
		Global $T1_B_SetupWizard = GUICtrlCreateButton("Setup Wizard", $tButtonX, $tButtonY, $tButtonW, $tButtonH)
		GUICtrlSetOnEvent(-1, "GUI_Tools_B_SetupWizard")
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		$T1_L_SetupWizard = GUICtrlCreateLabel("A tool to prepare the essential config paramaters.", $tLabelX, $tLabelY, 345, $tLabelH)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		$tButtonY += 48
		$tLabelY += 48
		Global $T1_B_AllPortsScanner = GUICtrlCreateButton("Network Conn. Viewer", $tButtonX, $tButtonY, $tButtonW, $tButtonH)
		GUICtrlSetOnEvent(-1, "GUI_Tools_B_NetworkConnectionsViewer")
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		$T1_L_AllPortsScanner = GUICtrlCreateLabel("Displays all ports/programs used by local computer.", $tLabelX, $tLabelY, 650, $tLabelH)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$tButtonY += 48
		$tLabelY += 48
		Global $T1_B_DuplicatePortChecker = GUICtrlCreateButton("Duplicate Port Checker", $tButtonX, $tButtonY, $tButtonW, $tButtonH)
		GUICtrlSetOnEvent(-1, "GUI_Tools_B_DuplicatePortChecker")
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		$T1_L_DuplicatePortChecker = GUICtrlCreateLabel("Check for duplicate ports assigned in the ServerGrid.json file and RCON ports.", $tLabelX, $tLabelY, 542, $tLabelH)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$tButtonY += 48
		$tLabelY += 48
		Global $T1_B_CreateBatchFiles = GUICtrlCreateButton("Create Batch Files", $tButtonX, $tButtonY, $tButtonW, $tButtonH)
		GUICtrlSetOnEvent(-1, "GUI_Tools_B_CreateBatchFiles")
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		$T1_L_DuplicatePortChecker = GUICtrlCreateLabel("Create batch files for starting and updating " & $aGameName & ".", $tLabelX, $tLabelY, 542, $tLabelH)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		$tButtonY += 48
		$tLabelY += 48
		Global $T1_B_CreateServerSummary = GUICtrlCreateButton("Create Server Summary", $tButtonX, $tButtonY, $tButtonW, $tButtonH)
		GUICtrlSetOnEvent(-1, "GUI_Tools_B_CreateServerSummary")
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		$T1_L_DuplicatePortChecker = GUICtrlCreateLabel("Create text file containing IP addresses, ports, and other server settings.", $tLabelX, $tLabelY, 542, $tLabelH)
		GUICtrlSetFont(-1, 10, 800, 0, "MS Sans Serif")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		; -----------------------------------
		GUISetState(@SW_SHOWNORMAL, $wToolsWindow)
		If WinExists($wGUIMainWindow) Then
		Else
			While $aExitGUIT1 = False
				Sleep(100)
			WEnd
			GUIDelete($wToolsWindow)
			$aExitGUIT1 = False
			If $aGUITools = 2 Then WizardExisting(1)
			If $aGUITools = 3 Then WizardNew()
		EndIf
	EndIf
EndFunc   ;==>ShowGUITools

; ------------------------------------------------------------------------------------------------------------

Func GUI_Tools_Close()
	$aExitGUIT1 = True
	$aGUITools = 1
	If WinExists($wGUIMainWindow) Then
		GUIDelete($wToolsWindow)
		$aExitGUIT1 = False
	EndIf
EndFunc   ;==>GUI_Tools_Close
Func GUI_Tools_B_SetupWizard()
	WizardSelect()
EndFunc   ;==>GUI_Tools_B_SetupWizard
Func GUI_Tools_B_DuplicatePortChecker()
	_CheckForDuplicatePorts()
EndFunc   ;==>GUI_Tools_B_DuplicatePortChecker
Func GUI_Tools_B_NetworkConnectionsViewer()
	_NetworkConnectionsViewer()
EndFunc   ;==>GUI_Tools_B_NetworkConnectionsViewer
Func GUI_Tools_B_CreateBatchFiles()
	$tSourceFolder = FileSelectFolder("Select folder", $aBatFolder, 1)
	If @error Then
		_Splash("Create batch files cancelled . . .", 2000)
	Else
		$tSplash = _Splash("Creating batch files . . .")
		BatchFilesCreate($tSplash, $tSourceFolder)
		_Splash("Batch files created.", 2000)
		ShellExecute($tSourceFolder)
	EndIf
EndFunc   ;==>GUI_Tools_B_CreateBatchFiles
Func GUI_Tools_B_CreateServerSummary()
	$tServerSummaryFile = FileSaveDialog("Select Filename and Folder for Server Summary", @ScriptDir, "Text files (*.txt)", BitOR($FD_PATHMUSTEXIST, $FD_PROMPTOVERWRITE), "Server_Summary.txt")
	If @error Then
		_Splash("Create server summary file cancelled . . .", 2000)
	Else
		$tSplash = _Splash("Creating server summary file . . .")
		MakeServerSummaryFile($tServerSummaryFile)
		_Splash("Server summary file created.", 2000)
		ShellExecute($tServerSummaryFile)
;~ 		Run("notepad.exe " & $tServerSummaryFile)
	EndIf
EndFunc   ;==>GUI_Tools_B_CreateServerSummary

; ------------------------------------------------------------------------------------------------------------

Func SelectFolder($tTxt, $tDefaultDIR = @ScriptDir)
	Opt("GUIOnEventMode", 0)
	Global $tSourceFolder = $tDefaultDIR
	Global $tSFTxt = $tTxt
	Global $aSFDone = False
	If WinExists($wSelectFolder) Then
		SplashOff()
		MsgBox($aUtilName, "Only one folder select window can be open at a time." & @CRLF & @CRLF & "Please close other window before opening this one.")
		Return True
	Else
		Global $wSelectFolder = GUICreate($aUtilName, 720, 120, -1, -1)
;~ 		GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_SelectFolder_Close", $wSelectFolder)
		Global $GUI_SF_I_SelectFolder = GUICtrlCreateInput($tDefaultDIR, 8, 40, 617, 21)
;~ 		GUICtrlSetOnEvent(-1, "GUI_SF_I_SelectFolder")
		Local $tLabelSelectFolder = GUICtrlCreateLabel($tSFTxt, 8, 16, 200, 17)
		Global $GUI_SF_B_SelectFolder = GUICtrlCreateButton("Select Folder", 632, 40, 75, 25)
;~ 		GUICtrlSetOnEvent(-1, "GUI_SF_B_SelectFolder")
		Global $GUI_SF_B_Done = GUICtrlCreateButton("Done", 8, 72, 75, 25)
;~ 		GUICtrlSetOnEvent(-1, "GUI_SF_B_Done")
		GUISetState(@SW_SHOW)
		Do
			$nMsg = GUIGetMsg()
			Switch $nMsg
				Case $GUI_EVENT_CLOSE
					$aSFDone = True
;~ 				Case GUI_SF_I_SelectFolder
				Case $GUI_SF_B_SelectFolder
					$tSourceFolder = FileSelectFolder($tTxt, $tDefaultDIR, 7, GUICtrlRead($GUI_SF_I_SelectFolder))
					If @error Then
						GUICtrlSetData($GUI_SF_I_SelectFolder, $tDefaultDIR)
					Else
						GUICtrlSetData($GUI_SF_I_SelectFolder, $tSourceFolder)
					EndIf
				Case $GUI_SF_B_Done
					$aSFDone = True
			EndSwitch
			Sleep(100)
		Until $aSFDone = True
		$aSFDone = False
		Opt("GUIOnEventMode", 1)
		If WinExists($wGUIMainWindow) Then
			GUIDelete($wSelectFolder)
			$aExitGUISF1 = False
		EndIf
		Return $tSourceFolder
	EndIf
EndFunc   ;==>SelectFolder

Func GUI_SelectFolder_Close()
	Opt("GUIOnEventMode", 1)
	$tSourceFolder = GUICtrlRead($GUI_SF_I_SelectFolder)
	$aExitGUISF1 = True
	$aSelectFolder = 1
	If WinExists($wGUIMainWindow) Then
		GUIDelete($wSelectFolder)
		$aExitGUISF1 = False
	EndIf
EndFunc   ;==>GUI_SelectFolder_Close
Func GUI_SF_I_SelectFolder()
EndFunc   ;==>GUI_SF_I_SelectFolder
Func GUI_SF_B_SelectFolder()
	$tSourceFolder = FileSelectFolder($tSFTxt, GUICtrlRead($GUI_SF_I_SelectFolder), 7, GUICtrlRead($GUI_SF_I_SelectFolder))
	If @error Then
		GUICtrlSetData($GUI_SF_I_SelectFolder, @ScriptDir)
	Else
		GUICtrlSetData($GUI_SF_I_SelectFolder, $tSourceFolder)
	EndIf
EndFunc   ;==>GUI_SF_B_SelectFolder
Func GUI_SF_B_Done()
	GUI_SelectFolder_Close()
EndFunc   ;==>GUI_SF_B_Done

Func GridConfiguratorGUI($tGridClicked)
	If WinExists($wGridConfig) Then
;~ 		WinSetOnTop($wGridConfig, "", 1)
	Else
		Global $tGridActive = $tGridClicked
		Global $tG_T1_EditClicked = False, $tG_T2_EditClicked = False, $tG_T3_EditClicked = False, $tG_T4_EditClicked = False, $tG_T5_EditClicked = False
		Global $tG_T6_EditClicked = False, $tG_T7_EditClicked = False, $tG_T8_EditClicked = False
		Global $G_LastTab = 0, $aLastGridActive = 0, $aCancelTF = False
		Local $gX = 0, $gY = 40
		Local $gBW = 27, $gBH = 25, $gBGapX = 1, $gBGapY = 1, $gBinaRow = 35 ; Grid Tab Button Width, Height, and gaps between buttons
		For $i = 0 To ($aServerGridTotal - 1)
			If Mod($i + 1, $gBinaRow) = 0 Then $gY += $gBH + $gBGapY ; Lowers tab window by number of grid tab rows.
		Next
;~ 		If $aServerGridTotal > 35 Then $gY += 30
;~ 		If $aServerGridTotal > 70 Then $gY += 30
		Global $wGridConfig = GUICreate("Grid Configurator", 1001, 561 + $gY, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_MAXIMIZEBOX, $WS_SIZEBOX, $WS_THICKFRAME, $WS_TABSTOP))
		GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_GridConfig_Close", $wGridConfig)
		GUISetIcon($aIconFile, 99)
		GUISetBkColor($cT1Background)
		; -------------------------------------------------------------------
		GUICtrlCreateTabItem("")
		Global $G_W_GridButtons[$aServerGridTotal]
		Local $tNamingScheme = $aNamingScheme
		If $tNamingScheme = 3 Then $tNamingScheme = 1
		Local $gBXstart = 8, $gBYstart = 8 ; First button starting point
		Local $gBXnow = $gBXstart, $gBYnow = $gBYstart
		For $i = 0 To ($aServerGridTotal - 1)
			$G_W_GridButtons[$i] = GUICtrlCreateButton(_ServerNamingScheme($i, $tNamingScheme), $gBXnow, $gBYnow, $gBW, $gBH)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
			GUICtrlSetOnEvent(-1, "G_W_GridTabClicked")
			If Mod($i + 1, $gBinaRow) = 0 Then
				$gBYnow += $gBH + $gBGapY ; Lowers tab window by number of grid tab rows.
				$gBXnow = $gBXstart
			Else
				$gBXnow += $gBW + $gBGapX
			EndIf
		Next
		; -------------------------------------------------------------------
		Global $G_GridConfig_Tab = GUICtrlCreateTab(8, $gY, 985, 553)
		GUICtrlSetOnEvent(-1, "G_On_Tab")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKLEFT + $GUI_DOCKTOP)
		Global $G_T1_T_Main = GUICtrlCreateTabItem("1 Main")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $G_T1_L_GridName = GUICtrlCreateLabel("", 76, $gY + 33, 802, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_L_GridNumber = GUICtrlCreateLabel("", 20, $gY + 33, 49, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_B_StartStopServer = GUICtrlCreateButton("", 20, $gY + 65, 107, 33)
		GUICtrlSetOnEvent(-1, "G_T1_B_StartStopServer")
		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_G_LocalRemote = GUICtrlCreateGroup("", 372, $gY + 57, 129, 41)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_R1_Local = GUICtrlCreateRadio("Local", 380, $gY + 73, 49, 17)
		GUICtrlSetOnEvent(-1, "G_T1_R1_Local")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_R1_Remote = GUICtrlCreateRadio("Remote", 436, $gY + 73, 57, 17)
		GUICtrlSetOnEvent(-1, "G_T1_R1_Remote")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		Local $G_T1_G_StartGrid = GUICtrlCreateGroup("", 140, $gY + 57, 225, 41, -1, $WS_EX_TRANSPARENT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_l2 = GUICtrlCreateLabel("Start Grid at Util Startup?", 148, $gY + 74, 121, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_R2_StartGridYes = GUICtrlCreateRadio("Yes", 276, $gY + 73, 41, 17)
		GUICtrlSetOnEvent(-1, "G_T1_R2_StartGridYes")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_R2_StartGridNo = GUICtrlCreateRadio("No", 324, $gY + 73, 33, 17)
		GUICtrlSetOnEvent(-1, "G_T1_R2_StartGridNo")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetState(-1, $GUI_HIDE)
		Local $G_T1_G_GridDelay = GUICtrlCreateGroup("", 508, $gY + 57, 363, 41)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_3 = GUICtrlCreateLabel("Additional delay this grid:", 716, $gY + 73, 120, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_4 = GUICtrlCreateLabel("seconds", 660, $gY + 73, 44, 17)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_AddedDelayGrid = GUICtrlCreateInput("", 836, $gY + 73, 25, 21, BitOR($ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "G_T1_I_AddedDelayGrid")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_1 = GUICtrlCreateLabel("All Grids Startup Delay", 516, $gY + 73, 109, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_BaseDelay = GUICtrlCreateInput("", 628, $gY + 70, 25, 21, BitOR($ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "G_T1_I_BaseDelay")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		GUICtrlSetState(-1, $GUI_HIDE)
		Local $G_T1_G_GridNameIP = GUICtrlCreateGroup("", 20, $gY + 105, 851, 105)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_5 = GUICtrlCreateLabel("Server Name", 36, $gY + 122, 66, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_ServerName = GUICtrlCreateInput("", 108, $gY + 121, 305, 21)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetOnEvent(-1, "G_T1_I_ServerName")
		Local $G_T1_L_2 = GUICtrlCreateLabel("IP Address", 49, $gY + 147, 55, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_IPAddress = GUICtrlCreateInput("", 108, $gY + 145, 305, 21)
		GUICtrlSetOnEvent(-1, "G_T1_I_IPAddress")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_34 = GUICtrlCreateLabel("AltSaveDIR", 731, $gY + 124, 60, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		If $aServerAltSaveSelect <> 3 Then GUICtrlSetState(-1, $GUI_DISABLE)
		Global $G_T1_I_AltSaveDIR = GUICtrlCreateInput("", 796, $gY + 121, 65, 21, BitOR($ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "G_T1_I_AltSaveDIR")
		If $aServerAltSaveSelect <> 3 Then GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_37 = GUICtrlCreateLabel("Query Port", 441, $gY + 124, 54, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_QueryPort = GUICtrlCreateInput("", 500, $gY + 121, 49, 21, BitOR($ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "G_T1_I_QueryPort")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_38 = GUICtrlCreateLabel("Game Port", 441, $gY + 148, 54, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_GamePort = GUICtrlCreateInput("", 500, $gY + 145, 49, 21, BitOR($ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "G_T1_I_GamePort")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_39 = GUICtrlCreateLabel("Seamless Port", 578, $gY + 124, 71, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_SeamlessPort = GUICtrlCreateInput("", 652, $gY + 121, 49, 21, BitOR($ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "G_T1_I_SeamlessPort")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_40 = GUICtrlCreateLabel("RCON Port", 591, $gY + 148, 57, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_RCONPort = GUICtrlCreateInput("", 652, $gY + 145, 49, 21, BitOR($ES_CENTER, $ES_NUMBER))
		GUICtrlSetOnEvent(-1, "G_T1_I_RCONPort")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_41 = GUICtrlCreateLabel("Commandline (All Grids)", 29, $gY + 179, 114, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_CommandlineAllGrids = GUICtrlCreateInput("", 148, $gY + 177, 265, 21)
		GUICtrlSetOnEvent(-1, "G_T1_I_CommandlineAllGrids")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Local $G_T1_L_42 = GUICtrlCreateLabel("Added Commandline (This Grid)", 446, $gY + 179, 152, 17, $SS_RIGHT)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_I_CommandlineThisGrid = GUICtrlCreateInput("", 604, $gY + 177, 257, 21)
		GUICtrlSetOnEvent(-1, "G_T1_I_CommandlineThisGrid")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		Local $G_T1_G_OpenFolder = GUICtrlCreateGroup(" Open Folder ", 880, $gY + 24, 101, 185)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_B_SaveFolder = GUICtrlCreateButton("Save Folder", 888, $gY + 48, 83, 25)
		GUICtrlSetOnEvent(-1, "G_T1_B_SaveFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetTip(-1, "(This Grid) Open Save Folder in Explorer")
		Global $G_T1_B_ConfigFolder = GUICtrlCreateButton("Config Folder", 888, $gY + 80, 83, 25)
		GUICtrlSetOnEvent(-1, "G_T1_B_ConfigFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetTip(-1, "(This Grid) Open Config Folder in Explorer")
		Global $G_T1_B_AtlasLogFolder = GUICtrlCreateButton($aGameName & " Log Folder", 888, $gY + 112, 83, 25)
		GUICtrlSetTip(-1, "(All Grids) Open " & $aGameName & " Log Folder in Explorer")
		GUICtrlSetOnEvent(-1, "G_T1_B_AtlasLogFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T1_B_ServerGrid = GUICtrlCreateButton("ServerGrid.json", 888, $gY + 144, 83, 25)
		GUICtrlSetTip(-1, "(All Grids) Open Folder Containing ServerGrid.json File in Explorer")
		GUICtrlSetOnEvent(-1, "G_T1_B_ServerGrid")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		; ---------------------------------------------------------------------------------------------
		Global $gParametersTF[16] = ["isHomeServer", "ServerPVE", "ClampHomeServerXP", "PVEDontReplicateLoggedOutPlayers", "PVPStructureDecay", "DontUseClaimFlags", "PVPStructureDecay", _
				"bUseSettlementClaims", "DisableStructurePlacementCollision", _
				"ShowMapPlayerLocation", "EnableHealthBars", "ServerCrosshair", "ShowFloatingDamangeText", "bDisableFogOfWar", "bAllowUnlimitedRespecs", "EnablePvPGamma"]
		Local $G_T1_G_Parameters = GUICtrlCreateGroup("", 20, $gY + 217, 961, 321)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH)
		GUICtrlSetBkColor($G_T1_B_StartStopServer, 0xD7DBDD) ; Gray
		Global $gParamTFMax = UBound($gParametersTF)
		Global $G_T1_L_ParametersTF[$gParamTFMax]
		Global $G_T1_I_ParametersTF[$gParamTFMax]
		Global $G_T1_I_ParamTFX[$gParamTFMax]
		Global $G_T1_I_ParamTFY[$gParamTFMax]

		Global $gParamTF_TF[$gParamTFMax]
		For $i = 0 To ($gParamTFMax - 1)
			$gParamTF_TF[$i] = False
		Next
;~ 	$gParamTF_TF[1] = True
		Local $gParamBaseY = $gY + 230
		Local $gParamColumn1x = 36 ; Sliders = 36, Labels = 68
		Local $gParamColumn2x = 324 ; Slider = 324, Labels = 356

		Local $gParamY = $gParamBaseY
		Local $gParamX = $gParamColumn1x
		For $i = 0 To ($gParamTFMax - 1)
			$G_T1_L_ParametersTF[$i] = GUICtrlCreateLabel($gParametersTF[$i], $gParamX + 32, $gParamY, 200, 17)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$G_T1_I_ParamTFX[$i] = $gParamX
			$G_T1_I_ParamTFY[$i] = $gParamY - 5
			If $gParamTF_TF[$i] Then
				$G_T1_I_ParametersTF[$i] = GUICtrlCreateIcon($aIconFile, 214, $G_T1_I_ParamTFX[$i], $G_T1_I_ParamTFY[$i], 24, 24)
			Else
				$G_T1_I_ParametersTF[$i] = GUICtrlCreateIcon($aIconFile, 215, $G_T1_I_ParamTFX[$i], $G_T1_I_ParamTFY[$i], 24, 24)
			EndIf
			GUICtrlSetOnEvent(-1, "G_W_ParamTFIconClicked")
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
			$gParamY += 24
			If $gParamY > 540 Then
				$gParamY = $gParamBaseY
				$gParamX = $gParamColumn2x
			EndIf
		Next
		; ---------------------------------------------------------------------------------------------
		Global $G_T1_B_DuplicateAllGrids = GUICtrlCreateButton("Duplicate to ALL Grids", 844, $gY + 233, 131, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetState(-1, $GUI_DISABLE)
		Global $G_T1_B_DuplicateSelectGrids = GUICtrlCreateButton("Duplicate to Select Grids", 844, $gY + 265, 131, 25)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetState(-1, $GUI_DISABLE)
		; ---------------------------------------------------------------------------------------------
		Global $gParametersEditLabel[10] = ["XPMultiplier", "TamingSpeedMultiplier", "HarvestHealthMultiplier", "ClampHomeServerXPLevel", _
				"TreasureGoldMultiplier", "PlayerCharacterHealthRecoveryMultiplier", "HarvestAmountMultiplier", "NoDiscoveriesMaxLevelUps", _
				"SettlementFlagResourceUpkeepMultiplier", "MatingIntervalMultiplier"]
		Global $gParametersEditValue[10] = ["1.0000", "1.0000", "1.0000", "1.0000", _
				"1.0000", "1.0000", "1.0000", "1.0000", _
				"1.0000", "1.0000"]

		Global $gParamEditMax = UBound($gParametersEditLabel)
		Global $G_T1_L_ParametersEdit[$gParamEditMax]
		Global $G_T1_I_ParametersEdit[$gParamEditMax]
		Local $gParamEditColumn1x = 600 ; Sliders = 36, Labels = 68
		Local $gParamEditColumn2x = 55 + $gParamEditColumn1x ; Slider = 324, Labels = 356

		Local $gParamY = $gParamBaseY
		Local $gParamX1 = $gParamEditColumn1x
		Local $gParamX2 = $gParamEditColumn2x
		For $i = 0 To ($gParamEditMax - 1)
			$G_T1_I_ParametersEdit[$i] = GUICtrlCreateInput($gParametersEditValue[$i], $gParamX1, $gParamY, 50, 17, $ES_RIGHT)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
			GUICtrlSetState(-1, $GUI_DISABLE)
			$G_T1_L_ParametersEdit[$i] = GUICtrlCreateLabel($gParametersEditLabel[$i], $gParamX2, $gParamY, 200, 17)
			GUICtrlSetOnEvent(-1, "G_W_ParamEditClicked")
			GUICtrlSetState(-1, $GUI_DISABLE)
			GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
			$gParamY += 24
		Next
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		GUICtrlSetState(-1, $GUI_DISABLE)
		; -------------------------------------------------------------------
		Global $G_T2_T_GUS = GUICtrlCreateTabItem("2 GameUserSettings.ini")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $G_T2_L_GridName = GUICtrlCreateLabel("", 76, $gY + 33, 802, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T2_L_GridNumber = GUICtrlCreateLabel("", 20, $gY + 33, 49, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T2_E_Edit = GUICtrlCreateEdit("", 20, $gY + 97, 961, 449)
		GUICtrlSetOnEvent(-1, "G_T2_E_EditGUS")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor(-1, $cFWBackground)
		_GUICtrlEdit_SetLimitText(-1, 999999)
		Local $tX = 20, $tW = 50, $tGap = 25
		Global $G_T2_B_Save = GUICtrlCreateButton("Save", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Click to save file: A backup will be made.")
		GUICtrlSetOnEvent(-1, "G_T2_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T2_B_Reset = GUICtrlCreateButton("Reset", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Reset Edit Window: Reload contents from file.")
		GUICtrlSetOnEvent(-1, "G_T2_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		Global $G_T2_B_Find = GUICtrlCreateButton("Find", $tX, $gY + 65, $tW, 25)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "G_T2_B_Find")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
;~ 	HotKeySet("^f", "G_T2_H_Find")
		$tX += $tW + 5
		Global $G_T2_B_Replace = GUICtrlCreateButton("Replace", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Text: New Window Asks for Text to be Replaced With New Text.")
		GUICtrlSetOnEvent(-1, "G_T2_B_Replace")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 110
		Global $G_T2_B_ClipboardCopy = GUICtrlCreateButton("Copy to Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Copy Edit Window To Clipboard")
		GUICtrlSetOnEvent(-1, "G_T2_B_ClipboardCopy")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T2_B_ClipboardPaste = GUICtrlCreateButton("Paste from Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Edit Window Content With Clipboard")
		GUICtrlSetOnEvent(-1, "G_T2_B_ClipboardPaste")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 75
		Global $G_T2_B_OpenFile = GUICtrlCreateButton("Open File", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open This File With Your Default Windows Text Editor")
		GUICtrlSetOnEvent(-1, "G_T2_B_OpenFile")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T2_B_OpenFolder = GUICtrlCreateButton("Open Folder", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open The Folder Containing This File in Windows Explorer")
		GUICtrlSetOnEvent(-1, "G_T2_B_OpenFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 85
		Global $G_T2_B_RestartUtil = GUICtrlCreateButton("Restart Util", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart This Utility Program: Servers Will Remain Running")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartUtil")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $cGGridButtonActive)
		$tX += $tW + 5
		Global $G_T2_B_RestartServers = GUICtrlCreateButton("Restart Servers", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart Servers: You will be asked whether to restart servers now OR use Remote Restart with announcements.")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartServers")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; -------------------------------------------------------------------
		Global $G_T3_T_Game = GUICtrlCreateTabItem("3 Game.ini")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $G_T3_L_GridName = GUICtrlCreateLabel("", 76, $gY + 33, 802, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T3_L_GridNumber = GUICtrlCreateLabel("", 20, $gY + 33, 49, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T3_E_Edit = GUICtrlCreateEdit("", 20, $gY + 97, 961, 449)
		GUICtrlSetOnEvent(-1, "G_T3_E_Edit")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor(-1, $cFWBackground)
		_GUICtrlEdit_SetLimitText(-1, 999999)
		Local $tX = 20, $tW = 50, $tGap = 25
		Global $G_T3_B_Save = GUICtrlCreateButton("Save", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Click to save file: A backup will be made.")
		GUICtrlSetOnEvent(-1, "G_T3_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T3_B_Reset = GUICtrlCreateButton("Reset", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Reset Edit Window: Reload contents from file.")
		GUICtrlSetOnEvent(-1, "G_T3_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		Global $G_T3_B_Find = GUICtrlCreateButton("Find", $tX, $gY + 65, $tW, 25)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "G_T3_B_Find")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
;~ 	HotKeySet("^f", "G_T3_H_Find")
		$tX += $tW + 5
		Global $G_T3_B_Replace = GUICtrlCreateButton("Replace", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Text: New Window Asks for Text to be Replaced With New Text.")
		GUICtrlSetOnEvent(-1, "G_T3_B_Replace")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 110
		Global $G_T3_B_ClipboardCopy = GUICtrlCreateButton("Copy to Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Copy Edit Window To Clipboard")
		GUICtrlSetOnEvent(-1, "G_T3_B_ClipboardCopy")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T3_B_ClipboardPaste = GUICtrlCreateButton("Paste from Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Edit Window Content With Clipboard")
		GUICtrlSetOnEvent(-1, "G_T3_B_ClipboardPaste")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 75
		Global $G_T3_B_OpenFile = GUICtrlCreateButton("Open File", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open This File With Your Default Windows Text Editor")
		GUICtrlSetOnEvent(-1, "G_T3_B_OpenFile")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T3_B_OpenFolder = GUICtrlCreateButton("Open Folder", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open The Folder Containing This File in Windows Explorer")
		GUICtrlSetOnEvent(-1, "G_T3_B_OpenFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 85
		Global $G_T3_B_RestartUtil = GUICtrlCreateButton("Restart Util", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart This Utility Program: Servers Will Remain Running")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartUtil")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $cGGridButtonActive)
		$tX += $tW + 5
		Global $G_T3_B_RestartServers = GUICtrlCreateButton("Restart Servers", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart Servers: You will be asked whether to restart servers now OR use Remote Restart with announcements.")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartServers")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; -------------------------------------------------------------------
		Global $G_T4_T_Engine = GUICtrlCreateTabItem("4 Engine.ini")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $G_T4_L_GridName = GUICtrlCreateLabel("", 76, $gY + 33, 802, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T4_L_GridNumber = GUICtrlCreateLabel("", 20, $gY + 33, 49, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T4_E_Edit = GUICtrlCreateEdit("", 20, $gY + 97, 961, 449)
		GUICtrlSetOnEvent(-1, "G_T4_E_Edit")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor(-1, $cFWBackground)
		_GUICtrlEdit_SetLimitText(-1, 999999)
		Local $tX = 20, $tW = 50, $tGap = 25
		Global $G_T4_B_Save = GUICtrlCreateButton("Save", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Click to save file: A backup will be made.")
		GUICtrlSetOnEvent(-1, "G_T4_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T4_B_Reset = GUICtrlCreateButton("Reset", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Reset Edit Window: Reload contents from file.")
		GUICtrlSetOnEvent(-1, "G_T4_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		Global $G_T4_B_Find = GUICtrlCreateButton("Find", $tX, $gY + 65, $tW, 25)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "G_T4_B_Find")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
;~ 	HotKeySet("^f", "G_T4_H_Find")
		$tX += $tW + 5
		Global $G_T4_B_Replace = GUICtrlCreateButton("Replace", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Text: New Window Asks for Text to be Replaced With New Text.")
		GUICtrlSetOnEvent(-1, "G_T4_B_Replace")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 110
		Global $G_T4_B_ClipboardCopy = GUICtrlCreateButton("Copy to Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Copy Edit Window To Clipboard")
		GUICtrlSetOnEvent(-1, "G_T4_B_ClipboardCopy")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T4_B_ClipboardPaste = GUICtrlCreateButton("Paste from Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Edit Window Content With Clipboard")
		GUICtrlSetOnEvent(-1, "G_T4_B_ClipboardPaste")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 75
		Global $G_T4_B_OpenFile = GUICtrlCreateButton("Open File", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open This File With Your Default Windows Text Editor")
		GUICtrlSetOnEvent(-1, "G_T4_B_OpenFile")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T4_B_OpenFolder = GUICtrlCreateButton("Open Folder", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open The Folder Containing This File in Windows Explorer")
		GUICtrlSetOnEvent(-1, "G_T4_B_OpenFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 85
		Global $G_T4_B_RestartUtil = GUICtrlCreateButton("Restart Util", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart This Utility Program: Servers Will Remain Running")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartUtil")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $cGGridButtonActive)
		$tX += $tW + 5
		Global $G_T4_B_RestartServers = GUICtrlCreateButton("Restart Servers", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart Servers: You will be asked whether to restart servers now OR use Remote Restart with announcements.")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartServers")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; -------------------------------------------------------------------
		Global $G_T5_T_ServerGrid = GUICtrlCreateTabItem("5 ServerGrid.json")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $G_T5_L_GridName = GUICtrlCreateLabel("", 76, $gY + 33, 802, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T5_L_GridNumber = GUICtrlCreateLabel("", 20, $gY + 33, 49, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T5_E_Edit = GUICtrlCreateEdit("", 20, $gY + 97, 961, 449)
		GUICtrlSetOnEvent(-1, "G_T5_E_Edit")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor(-1, $cFWBackground)
		_GUICtrlEdit_SetLimitText(-1, 999999)
		Local $tX = 20, $tW = 50, $tGap = 25
		Global $G_T5_B_Save = GUICtrlCreateButton("Save", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Click to save file: A backup will be made.")
		GUICtrlSetOnEvent(-1, "G_T5_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T5_B_Reset = GUICtrlCreateButton("Reset", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Reset Edit Window: Reload contents from file.")
		GUICtrlSetOnEvent(-1, "G_T5_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		Global $G_T5_B_Find = GUICtrlCreateButton("Find", $tX, $gY + 65, $tW, 25)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "G_T5_B_Find")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
;~ 	HotKeySet("^f", "G_T5_H_Find")
		$tX += $tW + 5
		Global $G_T5_B_Replace = GUICtrlCreateButton("Replace", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Text: New Window Asks for Text to be Replaced With New Text.")
		GUICtrlSetOnEvent(-1, "G_T5_B_Replace")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 110
		Global $G_T5_B_ClipboardCopy = GUICtrlCreateButton("Copy to Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Copy Edit Window To Clipboard")
		GUICtrlSetOnEvent(-1, "G_T5_B_ClipboardCopy")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T5_B_ClipboardPaste = GUICtrlCreateButton("Paste from Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Edit Window Content With Clipboard")
		GUICtrlSetOnEvent(-1, "G_T5_B_ClipboardPaste")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 75
		Global $G_T5_B_OpenFile = GUICtrlCreateButton("Open File", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open This File With Your Default Windows Text Editor")
		GUICtrlSetOnEvent(-1, "G_T5_B_OpenFile")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T5_B_OpenFolder = GUICtrlCreateButton("Open Folder", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open The Folder Containing This File in Windows Explorer")
		GUICtrlSetOnEvent(-1, "G_T5_B_OpenFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 85
		Global $G_T5_B_RestartUtil = GUICtrlCreateButton("Restart Util", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart This Utility Program: Servers Will Remain Running")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartUtil")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $cGGridButtonActive)
		$tX += $tW + 5
		Global $G_T5_B_RestartServers = GUICtrlCreateButton("Restart Servers", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart Servers: You will be asked whether to restart servers now OR use Remote Restart with announcements.")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartServers")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; -------------------------------------------------------------------
		Global $G_T6_T_Tab = GUICtrlCreateTabItem("6 DefaultGUS.ini")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $G_T6_L_GridName = GUICtrlCreateLabel("", 76, $gY + 33, 802, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T6_L_GridNumber = GUICtrlCreateLabel("", 20, $gY + 33, 49, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T6_E_Edit = GUICtrlCreateEdit("", 20, $gY + 97, 961, 449)
		GUICtrlSetOnEvent(-1, "G_T6_E_Edit")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor(-1, $cFWBackground)
		_GUICtrlEdit_SetLimitText(-1, 999999)
		Local $tX = 20, $tW = 50, $tGap = 25
		Global $G_T6_B_Save = GUICtrlCreateButton("Save", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Click to save file: A backup will be made.")
		GUICtrlSetOnEvent(-1, "G_T6_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T6_B_Reset = GUICtrlCreateButton("Reset", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Reset Edit Window: Reload contents from file.")
		GUICtrlSetOnEvent(-1, "G_T6_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		Global $G_T6_B_Find = GUICtrlCreateButton("Find", $tX, $gY + 65, $tW, 25)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "G_T6_B_Find")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
;~ 	HotKeySet("^f", "G_T6_H_Find")
		$tX += $tW + 5
		Global $G_T6_B_Replace = GUICtrlCreateButton("Replace", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Text: New Window Asks for Text to be Replaced With New Text.")
		GUICtrlSetOnEvent(-1, "G_T6_B_Replace")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 110
		Global $G_T6_B_ClipboardCopy = GUICtrlCreateButton("Copy to Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Copy Edit Window To Clipboard")
		GUICtrlSetOnEvent(-1, "G_T6_B_ClipboardCopy")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T6_B_ClipboardPaste = GUICtrlCreateButton("Paste from Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Edit Window Content With Clipboard")
		GUICtrlSetOnEvent(-1, "G_T6_B_ClipboardPaste")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 75
		Global $G_T6_B_OpenFile = GUICtrlCreateButton("Open File", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open This File With Your Default Windows Text Editor")
		GUICtrlSetOnEvent(-1, "G_T6_B_OpenFile")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T6_B_OpenFolder = GUICtrlCreateButton("Open Folder", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open The Folder Containing This File in Windows Explorer")
		GUICtrlSetOnEvent(-1, "G_T6_B_OpenFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 85
		Global $G_T6_B_RestartUtil = GUICtrlCreateButton("Restart Util", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart This Utility Program: Servers Will Remain Running")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartUtil")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $cGGridButtonActive)
		$tX += $tW + 5
		Global $G_T6_B_RestartServers = GUICtrlCreateButton("Restart Servers", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart Servers: You will be asked whether to restart servers now OR use Remote Restart with announcements.")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartServers")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; -------------------------------------------------------------------
		Global $G_T7_T_Tab = GUICtrlCreateTabItem("7 DefaultGame.ini")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $G_T7_L_GridName = GUICtrlCreateLabel("", 76, $gY + 33, 802, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T7_L_GridNumber = GUICtrlCreateLabel("", 20, $gY + 33, 49, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T7_E_Edit = GUICtrlCreateEdit("", 20, $gY + 97, 961, 449)
		GUICtrlSetOnEvent(-1, "G_T7_E_Edit")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor(-1, $cFWBackground)
		_GUICtrlEdit_SetLimitText(-1, 999999)
		Local $tX = 20, $tW = 50, $tGap = 25
		Global $G_T7_B_Save = GUICtrlCreateButton("Save", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Click to save file: A backup will be made.")
		GUICtrlSetOnEvent(-1, "G_T7_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T7_B_Reset = GUICtrlCreateButton("Reset", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Reset Edit Window: Reload contents from file.")
		GUICtrlSetOnEvent(-1, "G_T7_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		Global $G_T7_B_Find = GUICtrlCreateButton("Find", $tX, $gY + 65, $tW, 25)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "G_T7_B_Find")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
;~ 	HotKeySet("^f", "G_T7_H_Find")
		$tX += $tW + 5
		Global $G_T7_B_Replace = GUICtrlCreateButton("Replace", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Text: New Window Asks for Text to be Replaced With New Text.")
		GUICtrlSetOnEvent(-1, "G_T7_B_Replace")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 110
		Global $G_T7_B_ClipboardCopy = GUICtrlCreateButton("Copy to Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Copy Edit Window To Clipboard")
		GUICtrlSetOnEvent(-1, "G_T7_B_ClipboardCopy")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T7_B_ClipboardPaste = GUICtrlCreateButton("Paste from Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Edit Window Content With Clipboard")
		GUICtrlSetOnEvent(-1, "G_T7_B_ClipboardPaste")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 75
		Global $G_T7_B_OpenFile = GUICtrlCreateButton("Open File", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open This File With Your Default Windows Text Editor")
		GUICtrlSetOnEvent(-1, "G_T7_B_OpenFile")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T7_B_OpenFolder = GUICtrlCreateButton("Open Folder", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open The Folder Containing This File in Windows Explorer")
		GUICtrlSetOnEvent(-1, "G_T7_B_OpenFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 85
		Global $G_T7_B_RestartUtil = GUICtrlCreateButton("Restart Util", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart This Utility Program: Servers Will Remain Running")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartUtil")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $cGGridButtonActive)
		$tX += $tW + 5
		Global $G_T7_B_RestartServers = GUICtrlCreateButton("Restart Servers", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart Servers: You will be asked whether to restart servers now OR use Remote Restart with announcements.")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartServers")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; -------------------------------------------------------------------
		Global $G_T8_T_Tab = GUICtrlCreateTabItem("8 DefaultEngine.ini")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		Global $G_T8_L_GridName = GUICtrlCreateLabel("", 76, $gY + 33, 802, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T8_L_GridNumber = GUICtrlCreateLabel("", 20, $gY + 33, 49, 24)
		GUICtrlSetFont(-1, 12, 800, 0, "MS Sans Serif")
		GUICtrlSetColor(-1, 0x800000)
		GUICtrlSetBkColor(-1, 0xFFFFFF)
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		Global $G_T8_E_Edit = GUICtrlCreateEdit("", 20, $gY + 97, 961, 449)
		GUICtrlSetOnEvent(-1, "G_T8_E_Edit")
		GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKTOP + $GUI_DOCKHCENTER + $GUI_DOCKVCENTER)
		GUICtrlSetBkColor(-1, $cFWBackground)
		_GUICtrlEdit_SetLimitText(-1, 999999)
		Local $tX = 20, $tW = 50, $tGap = 25
		Global $G_T8_B_Save = GUICtrlCreateButton("Save", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Click to save file: A backup will be made.")
		GUICtrlSetOnEvent(-1, "G_T8_B_Save")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T8_B_Reset = GUICtrlCreateButton("Reset", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Reset Edit Window: Reload contents from file.")
		GUICtrlSetOnEvent(-1, "G_T8_B_Reset")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		Global $G_T8_B_Find = GUICtrlCreateButton("Find", $tX, $gY + 65, $tW, 25)
		GUICtrlSetState(-1, $GUI_DISABLE)
		GUICtrlSetOnEvent(-1, "G_T8_B_Find")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
;~ 	HotKeySet("^f", "G_T8_H_Find")
		$tX += $tW + 5
		Global $G_T8_B_Replace = GUICtrlCreateButton("Replace", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Text: New Window Asks for Text to be Replaced With New Text.")
		GUICtrlSetOnEvent(-1, "G_T8_B_Replace")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 110
		Global $G_T8_B_ClipboardCopy = GUICtrlCreateButton("Copy to Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Copy Edit Window To Clipboard")
		GUICtrlSetOnEvent(-1, "G_T8_B_ClipboardCopy")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T8_B_ClipboardPaste = GUICtrlCreateButton("Paste from Clipboard", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Replace Edit Window Content With Clipboard")
		GUICtrlSetOnEvent(-1, "G_T8_B_ClipboardPaste")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 75
		Global $G_T8_B_OpenFile = GUICtrlCreateButton("Open File", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open This File With Your Default Windows Text Editor")
		GUICtrlSetOnEvent(-1, "G_T8_B_OpenFile")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5
		Global $G_T8_B_OpenFolder = GUICtrlCreateButton("Open Folder", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Open The Folder Containing This File in Windows Explorer")
		GUICtrlSetOnEvent(-1, "G_T8_B_OpenFolder")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		$tX += $tW + 5 + $tGap
		$tW = 85
		Global $G_T8_B_RestartUtil = GUICtrlCreateButton("Restart Util", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart This Utility Program: Servers Will Remain Running")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartUtil")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		GUICtrlSetBkColor(-1, $cGGridButtonActive)
		$tX += $tW + 5
		Global $G_T8_B_RestartServers = GUICtrlCreateButton("Restart Servers", $tX, $gY + 65, $tW, 25)
		GUICtrlSetTip(-1, "Restart Servers: You will be asked whether to restart servers now OR use Remote Restart with announcements.")
		GUICtrlSetOnEvent(-1, "G_TA_B_RestartServers")
		GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP + $GUI_DOCKWIDTH + $GUI_DOCKHEIGHT)
		; ---------------------------------- Set States ----------------------------------
		G_T1_UpdateTab()
		; ---------------------------------- Set States ----------------------------------
		GUISetState(@SW_SHOW)
		If WinExists($wGUIMainWindow) Then
		Else
			While $aExitGUIG = False
				Sleep(100)
			WEnd
			GUIDelete($wGridConfig)
			$aExitGUIG = False
		EndIf
	EndIf
EndFunc   ;==>GridConfiguratorGUI
Func GUI_GridConfig_Close()
	$aExitGUIG = True
	If WinExists($wGUIMainWindow) Then
		GUIDelete($wGridConfig)
		$aExitGUIG = False
	EndIf
EndFunc   ;==>GUI_GridConfig_Close
Func G_On_Tab()
	Switch GUICtrlRead($G_GridConfig_Tab)
		Case 0 ; Tab 1 Main
			G_T1_UpdateTab()
			G_LastTab(0)
		Case 1 ; Tab 2 GameUserSettings.ini
			G_T2_UpdateTab()
			G_LastTab(1)
		Case 2 ; Tab 3 Game.ini
			G_T3_UpdateTab()
			G_LastTab(2)
		Case 3 ; Tab 4 Engine.ini
			G_T4_UpdateTab()
			G_LastTab(3)
		Case 4 ; Tab 5 ServerGrid.json
			G_T5_UpdateTab()
			G_LastTab(4)
		Case 5 ; Tab 6 DefaultGUS.ini
			G_T6_UpdateTab()
			G_LastTab(5)
		Case 6 ; Tab 7 DefaultGame.ini
			G_T7_UpdateTab()
			G_LastTab(6)
		Case 7 ; Tab 8 DefaultEngine.ini
			G_T8_UpdateTab()
			G_LastTab(7)
	EndSwitch
EndFunc   ;==>G_On_Tab
Func G_W_GridTabClicked()
	Local $tGID = @GUI_CtrlId
	Local $tCancelTF = G_LastTab($G_LastTab) ; Kim!
	For $i = 0 To ($aServerGridTotal - 1)
		If $tGID = $G_W_GridButtons[$i] Then
			$tGridActive = $i
			ExitLoop
		EndIf
	Next
	If $tCancelTF Or $aCancelTF Then
		$tGridActive = $aLastGridActive
	Else
		If $G_LastTab = 0 Then G_T1_UpdateTab()
		If $G_LastTab = 1 Then G_T2_UpdateTab()
		If $G_LastTab = 2 Then G_T3_UpdateTab()
		If $G_LastTab = 3 Then G_T4_UpdateTab()
		If $G_LastTab = 4 Then G_T5_UpdateTab()
		If $G_LastTab = 5 Then G_T6_UpdateTab()
		If $G_LastTab = 6 Then G_T7_UpdateTab()
		If $G_LastTab = 7 Then G_T8_UpdateTab()
		$aLastGridActive = $tGridActive
	EndIf
	G_UpdateGridTabs()
	$aLastGridActive = $tGridActive
EndFunc   ;==>G_W_GridTabClicked
Func G_LastTab($tTab)
	If $G_LastTab = 0 Then ; Tab 1 Main
	EndIf
	$aCancelTF = False
	If $G_LastTab = 1 Then ; Tab 2 GameUserSettings.ini
		If $tG_T2_EditClicked Then
			$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to GameUserSettings.ini?" & @CRLF & @CRLF & _
					"Click (YES) to save" & @CRLF & _
					"Click (NO) to discarge changes" & @CRLF & _
					"Click (CANCEL) to continue editing.", 10)
			If $tMB = 6 Then ; YES
				G_T2_B_Save()
				$tG_T2_EditClicked = False
			ElseIf $tMB = 7 Then ; NO
				G_T2_B_Reset()
				$tG_T2_EditClicked = False
			ElseIf $tMB = 2 Or $tMB = -1 Then ; CANCEL or TIMEOUT
				Local $tTxt = GUICtrlRead($G_T2_E_Edit)
				GUICtrlSetState($G_T2_T_GUS, $GUI_SHOW)
				GUICtrlSetData($G_T2_E_Edit, $tTxt)
				$tG_T2_EditClicked = True
				$aCancelTF = True
			EndIf
		EndIf
	EndIf
	If $G_LastTab = 2 Then     ; Tab 3 Game.ini
		If $tG_T3_EditClicked Then
			$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to Game.ini?" & @CRLF & @CRLF & _
					"Click (YES) to save" & @CRLF & _
					"Click (NO) to discarge changes" & @CRLF & _
					"Click (CANCEL) to continue editing.", 10)
			If $tMB = 6 Then ; YES
				G_T3_B_Save()
				$tG_T3_EditClicked = False
			ElseIf $tMB = 7 Then ; NO
				G_T3_B_Reset()
				$tG_T3_EditClicked = False
			ElseIf $tMB = 2 Or $tMB = -1 Then ; CANCEL or TIMEOUT
				Local $tTxt = GUICtrlRead($G_T3_E_Edit)
				GUICtrlSetState($G_T3_T_Game, $GUI_SHOW)
				GUICtrlSetData($G_T3_E_Edit, $tTxt)
				$tG_T3_EditClicked = True
				$aCancelTF = True
			EndIf
		EndIf
	EndIf
	If $G_LastTab = 3 Then     ; Tab 4 Engine.ini
		If $tG_T4_EditClicked Then
			$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to Engine.ini?" & @CRLF & @CRLF & _
					"Click (YES) to save" & @CRLF & _
					"Click (NO) to discarge changes" & @CRLF & _
					"Click (CANCEL) to continue editing.", 10)
			If $tMB = 6 Then ; YES
				G_T4_B_Save()
				$tG_T4_EditClicked = False
			ElseIf $tMB = 7 Then ; NO
				G_T4_B_Reset()
				$tG_T4_EditClicked = False
			ElseIf $tMB = 2 Or $tMB = -1 Then ; CANCEL or TIMEOUT
				Local $tTxt = GUICtrlRead($G_T4_E_Edit)
				GUICtrlSetState($G_T4_T_Engine, $GUI_SHOW)
				GUICtrlSetData($G_T4_E_Edit, $tTxt)
				$tG_T4_EditClicked = True
				$aCancelTF = True
			EndIf
		EndIf
	EndIf
	If $G_LastTab = 4 Then     ; Tab 5 ServerGrid.json
		If $tG_T5_EditClicked Then
			$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to ServerGrid.json?" & @CRLF & @CRLF & _
					"Click (YES) to save" & @CRLF & _
					"Click (NO) to discarge changes" & @CRLF & _
					"Click (CANCEL) to continue editing.", 10)
			If $tMB = 6 Then ; YES
				G_T5_B_Save()
				$tG_T5_EditClicked = False
			ElseIf $tMB = 7 Then ; NO
				G_T5_B_Reset()
				$tG_T5_EditClicked = False
			ElseIf $tMB = 2 Or $tMB = -1 Then ; CANCEL or TIMEOUT
				Local $tTxt = GUICtrlRead($G_T5_E_Edit)
				GUICtrlSetState($G_T5_T_ServerGrid, $GUI_SHOW)
				GUICtrlSetData($G_T5_E_Edit, $tTxt)
				$tG_T5_EditClicked = True
				$aCancelTF = True
			EndIf
		EndIf
	EndIf
	If $G_LastTab = 5 Then     ; Tab 6 DefaultGUS.ini
		If $tG_T6_EditClicked Then
			$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to DefaultGameUserSettings.ini?" & @CRLF & @CRLF & _
					"Click (YES) to save" & @CRLF & _
					"Click (NO) to discarge changes" & @CRLF & _
					"Click (CANCEL) to continue editing.", 10)
			If $tMB = 6 Then ; YES
				G_T6_B_Save()
				$tG_T6_EditClicked = False
			ElseIf $tMB = 7 Then ; NO
				G_T6_B_Reset()
				$tG_T6_EditClicked = False
			ElseIf $tMB = 2 Or $tMB = -1 Then ; CANCEL or TIMEOUT
				Local $tTxt = GUICtrlRead($G_T6_E_Edit)
				GUICtrlSetState($G_T6_T_Tab, $GUI_SHOW)
				GUICtrlSetData($G_T6_E_Edit, $tTxt)
				$tG_T6_EditClicked = True
				$aCancelTF = True
			EndIf
		EndIf
	EndIf
	If $G_LastTab = 6 Then     ; Tab 7 DefaultGame.ini
		If $tG_T7_EditClicked Then
			$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to DefaultGame.ini?" & @CRLF & @CRLF & _
					"Click (YES) to save" & @CRLF & _
					"Click (NO) to discarge changes" & @CRLF & _
					"Click (CANCEL) to continue editing.", 10)
			If $tMB = 6 Then ; YES
				G_T7_B_Save()
				$tG_T7_EditClicked = False
			ElseIf $tMB = 7 Then ; NO
				G_T7_B_Reset()
				$tG_T7_EditClicked = False
			ElseIf $tMB = 2 Or $tMB = -1 Then ; CANCEL or TIMEOUT
				Local $tTxt = GUICtrlRead($G_T7_E_Edit)
				GUICtrlSetState($G_T7_T_Tab, $GUI_SHOW)
				GUICtrlSetData($G_T7_E_Edit, $tTxt)
				$tG_T7_EditClicked = True
				$aCancelTF = True
			EndIf
		EndIf
	EndIf
	If $G_LastTab = 7 Then         ; Tab 8 DefaultEngine.ini
		If $tG_T8_EditClicked Then
			$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "Do you wish to save changes to DefaultEngine.ini?" & @CRLF & @CRLF & _
					"Click (YES) to save" & @CRLF & _
					"Click (NO) to discarge changes" & @CRLF & _
					"Click (CANCEL) to continue editing.", 10)
			If $tMB = 6 Then ; YES
				G_T8_B_Save()
				$tG_T8_EditClicked = False
			ElseIf $tMB = 7 Then ; NO
				G_T8_B_Reset()
				$tG_T8_EditClicked = False
			ElseIf $tMB = 2 Or $tMB = -1 Then ; CANCEL or TIMEOUT
				Local $tTxt = GUICtrlRead($G_T8_E_Edit)
				GUICtrlSetState($G_T8_T_Tab, $GUI_SHOW)
				GUICtrlSetData($G_T8_E_Edit, $tTxt)
				$tG_T8_EditClicked = True
				$aCancelTF = True
			EndIf
		EndIf
	EndIf
	$G_LastTab = $tTab
	Return $aCancelTF
EndFunc   ;==>G_LastTab
Func G_T1_UpdateTab()
	GUICtrlSetData($G_T1_L_GridNumber, "(" & _ServerNamingScheme($tGridActive, $aNamingScheme) & ")")
	GUICtrlSetData($G_T1_L_GridName, $xServerNames[$tGridActive])
	GUICtrlSetData($G_T1_I_AddedDelayGrid, $xGridStartDelay[$tGridActive])
	GUICtrlSetData($G_T1_I_BaseDelay, $aServerStartDelay)
	GUICtrlSetData($G_T1_I_ServerName, $xServerNames[$tGridActive])
	GUICtrlSetData($G_T1_I_IPAddress, $xServerIP[$tGridActive])
	GUICtrlSetData($G_T1_I_AltSaveDIR, $xServerAltSaveDir[$tGridActive])
	GUICtrlSetData($G_T1_I_QueryPort, $xServerport[$tGridActive])
	GUICtrlSetData($G_T1_I_GamePort, $xServergameport[$tGridActive])
	GUICtrlSetData($G_T1_I_SeamlessPort, $xServerseamlessDataPort[$tGridActive])
	GUICtrlSetData($G_T1_I_RCONPort, $xServerRCONPort[$tGridActive + 1])
	GUICtrlSetData($G_T1_I_CommandlineAllGrids, $aServerExtraCMD)
	GUICtrlSetData($G_T1_I_CommandlineThisGrid, $xServerGridExtraCMD[$tGridActive])
	G_UpdateStartGrid()
	G_UpdateRadioLocal()
	G_UpdateGridTabs()
	G_T1_B_StartStopServUpdate()
	For $i = 0 To ($gParamTFMax - 1)     ; Enable / Disable Icons in Parameters Window
		If $gParamTF_TF[$i] Then
			GUICtrlSetImage($G_T1_I_ParametersTF[$i], $aIconFile, 214)
		Else
			GUICtrlSetImage($G_T1_I_ParametersTF[$i], $aIconFile, 215)
		EndIf
	Next
EndFunc   ;==>G_T1_UpdateTab
Func G_UpdateGridTabs()
	For $i = 0 To ($aServerGridTotal - 1)
		If $i = $tGridActive Then
			GUICtrlSetBkColor($G_W_GridButtons[$i], $cGGridButtonActive)
		Else
			GUICtrlSetBkColor($G_W_GridButtons[$i], $cGGridButtonInactive)
		EndIf
	Next
EndFunc   ;==>G_UpdateGridTabs
Func G_UpdateRadioLocal()
	If $xLocalGrid[$tGridActive] = "yes" Then
		GUICtrlSetState($G_T1_R1_Local, $GUI_CHECKED)
		GUICtrlSetState($G_T1_R1_Remote, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($G_T1_R1_Local, $GUI_UNCHECKED)
		GUICtrlSetState($G_T1_R1_Remote, $GUI_CHECKED)
	EndIf
EndFunc   ;==>G_UpdateRadioLocal
Func G_UpdateStartGrid()
	If $xStartGrid[$tGridActive] = "yes" Then
		GUICtrlSetState($G_T1_R2_StartGridYes, $GUI_CHECKED)
		GUICtrlSetState($G_T1_R2_StartGridNo, $GUI_UNCHECKED)
	Else
		GUICtrlSetState($G_T1_R2_StartGridYes, $GUI_UNCHECKED)
		GUICtrlSetState($G_T1_R2_StartGridNo, $GUI_CHECKED)
	EndIf
EndFunc   ;==>G_UpdateStartGrid
; -------------------------------------------------------------------
Func G_TA_B_RestartUtil()
	_RestartUtil()
EndFunc   ;==>G_TA_B_RestartUtil
Func G_TA_B_RestartServers()
	LogWrite("", " [Server] Restart Server requested by user in Grid Configurator.")
	$bMsg = "Restart Servers Requested." & @CRLF & @CRLF & _
			"Click (YES) to restart servers WITH announcement" & @CRLF & _
			"(Initiate Remote Restart)" & @CRLF & _
			"Click (NO) to restart servers NOW" & @CRLF & _
			"Click (CANCEL) to cancel."
	SplashOff()
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, $bMsg, 30)
	If $tMB = 6 Then     ; (YES)
		F_RemoteRestart()
	ElseIf $tMB = 7 Then
		F_RestartNow(False)
	ElseIf $tMB = 2 Then
		LogWrite("", " [Server] Restart Server canceled by user.")
		_Splash("Restart cancelled.", 2000)
	ElseIf $tMB = -1 Then     ; Timeout
		LogWrite("", " [Server] Restart Server canceled by user.")
		_Splash("Restart cancelled.", 2000)
	EndIf
EndFunc   ;==>G_TA_B_RestartServers
Func G_T1_B_SaveFolder()
	ShellExecute($aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\")
EndFunc   ;==>G_T1_B_SaveFolder
Func G_T1_B_ConfigFolder()
	ShellExecute($aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\")
EndFunc   ;==>G_T1_B_ConfigFolder
Func G_T1_B_AtlasLogFolder()
	ShellExecute($aServerDirLocal & "\ShooterGame\Saved\Logs\")
EndFunc   ;==>G_T1_B_AtlasLogFolder
Func G_T1_B_ServerGrid()
	ShellExecute($aServerDirLocal & "\ShooterGame\")
EndFunc   ;==>G_T1_B_ServerGrid
Func G_W_ParamTFIconClicked()
	For $i = 0 To ($gParamTFMax - 1)
		If @GUI_CtrlId = $G_T1_I_ParametersTF[$i] Then
			If $gParamTF_TF[$i] Then
				GUICtrlSetImage($G_T1_I_ParametersTF[$i], $aIconFile, 215)
				$gParamTF_TF[$i] = False
			Else
				GUICtrlSetImage($G_T1_I_ParametersTF[$i], $aIconFile, 214)
				$gParamTF_TF[$i] = True
			EndIf
			_Splash("Coming Soon!" & @CRLF & "This section is disabled until" & @CRLF & "Grid Configurator Phase II is complete", 2000)     ; Kim!!!
			ExitLoop
		EndIf
	Next
EndFunc   ;==>G_W_ParamTFIconClicked
Func G_T1_B_StartStopServUpdate()
;~ 	If ProcessExists($aServerPID[$tGridActive]) And $xStartGrid[$tGridActive] = "yes" Then
	If ProcessExists($aServerPID[$tGridActive]) Then
		GUICtrlSetBkColor($G_T1_B_StartStopServer, 0xFF5858) ; Red
		GUICtrlSetData($G_T1_B_StartStopServer, "Stop Server")
	Else
		If $xLocalGrid[$tGridActive] = "yes" Then
			GUICtrlSetBkColor($G_T1_B_StartStopServer, 0x00FF00) ; Green
			GUICtrlSetData($G_T1_B_StartStopServer, "Start Server")
		Else
			GUICtrlSetBkColor($G_T1_B_StartStopServer, 0xD7DBDD) ; Gray
			GUICtrlSetData($G_T1_B_StartStopServer, "Remote Server")
		EndIf
	EndIf
EndFunc   ;==>G_T1_B_StartStopServUpdate
Func G_T1_B_StartStopServer()
	GUI_Main_B_SelectNone()
	G_T1_B_StartStopServUpdate()
	If GUICtrlRead($G_T1_B_StartStopServer) = "Start Server" Then
		If $xLocalGrid[$tGridActive] = "no" Then
			_Splash("ERROR! Cannot start server " & _ServerNamingScheme($tGridActive, $aNamingScheme) & "." & @CRLF & "It is set as a Remote server." & @CRLF & "To start, set it to LOCAL and try again.", 5000)
		Else
			SelectServersStart($tGridActive)
		EndIf
	ElseIf GUICtrlRead($G_T1_B_StartStopServer) = "Remote Server" Then
		_Splash("ERROR! Cannot start server " & _ServerNamingScheme($tGridActive, $aNamingScheme) & "." & @CRLF & "It is set as a Remote server. To start, set it to a local server then try again.", 5000)
	ElseIf GUICtrlRead($G_T1_B_StartStopServer) = "Stop Server" Then
		SelectServersStop($tGridActive)
	Else
	EndIf
	G_UpdateStartGrid()
	G_T1_B_StartStopServUpdate()
EndFunc   ;==>G_T1_B_StartStopServer
Func G_T1_R1_Local()
	$xLocalGrid[$tGridActive] = "yes"
	IniWrite($aGridSelectFile, $aGridIniTitle[1], "Is Server (" & $xServergridx[$tGridActive] & "," & $xServergridy[$tGridActive] & ") Local (yes/no)", $xLocalGrid[$tGridActive])
	G_UpdateRadioLocal()
	G_T1_B_StartStopServUpdate()
EndFunc   ;==>G_T1_R1_Local
Func G_T1_R1_Remote()
	$xLocalGrid[$tGridActive] = "no"
	IniWrite($aGridSelectFile, $aGridIniTitle[1], "Is Server (" & $xServergridx[$tGridActive] & "," & $xServergridy[$tGridActive] & ") Local (yes/no)", $xLocalGrid[$tGridActive])
	G_UpdateRadioLocal()
	G_T1_B_StartStopServUpdate()
	G_T1_R2_StartGridNo()
EndFunc   ;==>G_T1_R1_Remote
Func G_T1_R2_StartGridYes()
	$xStartGrid[$tGridActive] = "yes"
	IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$tGridActive] & "," & $xServergridy[$tGridActive] & ") (yes/no)", $xStartGrid[$tGridActive])
	G_UpdateStartGrid()
EndFunc   ;==>G_T1_R2_StartGridYes
Func G_T1_R2_StartGridNo()
	$xStartGrid[$tGridActive] = "no"
	IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$tGridActive] & "," & $xServergridy[$tGridActive] & ") (yes/no)", $xStartGrid[$tGridActive])
	G_UpdateStartGrid()
EndFunc   ;==>G_T1_R2_StartGridNo
Func G_T1_I_AddedDelayGrid()
	$xGridStartDelay[$tGridActive] = GUICtrlRead($G_T1_I_AddedDelayGrid)
	If $xGridStartDelay[$tGridActive] < 0 Then
		$xGridStartDelay[$tGridActive] = 0
		GUICtrlSetData($G_T1_I_AddedDelayGrid, $xGridStartDelay[$tGridActive])
	EndIf
	If $xGridStartDelay[$tGridActive] > 600 Then
		$xGridStartDelay[$tGridActive] = 600
		GUICtrlSetData($G_T1_I_AddedDelayGrid, $xGridStartDelay[$tGridActive])
	EndIf
	_BackupFile($aGridSelectFile)
	IniWrite($aGridSelectFile, $aGridIniTitle[3], "Additional startup delay Server (" & $xServergridx[$tGridActive] & "," & $xServergridy[$tGridActive] & ") (0-600)", $xGridStartDelay[$tGridActive])
EndFunc   ;==>G_T1_I_AddedDelayGrid
Func G_T1_I_BaseDelay()
	$aServerStartDelay = GUICtrlRead($G_T1_I_BaseDelay)
	If $aServerStartDelay < 0 Then
		$aServerStartDelay = 0
		GUICtrlSetData($G_T1_I_BaseDelay, $aServerStartDelay)
	ElseIf $aServerStartDelay > 600 Then
		$aServerStartDelay = 600
		GUICtrlSetData($G_T1_I_BaseDelay, $aServerStartDelay)
	EndIf
	_BackupFile($aIniFile)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Delay in seconds between grid server starts (0-600) ###", $aServerStartDelay)
EndFunc   ;==>G_T1_I_BaseDelay
Func G_T1_I_ServerName()
	Local $aTxtOld = $xServerNames[$tGridActive]
	$xServerNames[$tGridActive] = GUICtrlRead($G_T1_I_ServerName)
	Local $aTxtNew = $xServerNames[$tGridActive]
	Local $tParam = "name"
	Local $tLine = _ReplaceServerGrid($tParam, $aTxtOld, $aTxtNew, $xServergridx[$tGridActive], $xServergridy[$tGridActive], $aConfigFull, True)
	If $tLine = -1 Then
		$xServerNames[$tGridActive] = $aTxtOld
		_Splash("ERROR! Server Name not saved!" & @CRLF & @CRLF & "(Check if ServerGrid.json file is read-only)", 5000)
	EndIf
	GUICtrlSetData($G_T1_I_ServerName, $xServerNames[$tGridActive])
EndFunc   ;==>G_T1_I_ServerName
Func G_T1_I_IPAddress()
	Local $aTxtOld = $xServerIP[$tGridActive]
	$xServerIP[$tGridActive] = GUICtrlRead($G_T1_I_IPAddress)
	Local $aTxtNew = $xServerIP[$tGridActive]
	Local $tParam = "ip"
	Local $tLine = _ReplaceServerGrid($tParam, $aTxtOld, $aTxtNew, $xServergridx[$tGridActive], $xServergridy[$tGridActive], $aConfigFull, True)
	If $tLine = -1 Then
		$xServerIP[$tGridActive] = $aTxtOld
		_Splash("ERROR! Server IP not saved!" & @CRLF & @CRLF & "(Check if ServerGrid.json file is read-only)", 5000)
	EndIf
	GUICtrlSetData($G_T1_I_IPAddress, $xServerIP[$tGridActive])
EndFunc   ;==>G_T1_I_IPAddress
Func G_T1_I_AltSaveDIR()
	Local $aTxtOld = $xServerAltSaveDir[$tGridActive]
	$xServerAltSaveDir[$tGridActive] = GUICtrlRead($G_T1_I_AltSaveDIR)
	Local $aTxtNew = $xServerAltSaveDir[$tGridActive]
	_BackupFile($aIniFile)
	$aServerAltSaveDir = StringReplace($aServerAltSaveDir, $aTxtOld, $aTxtNew)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryNames (Use same order as listed in ServerGrid.json. Comma separated) ###", $aServerAltSaveDir)
	GUICtrlSetData($G_T1_I_AltSaveDIR, $xServerAltSaveDir[$tGridActive])
EndFunc   ;==>G_T1_I_AltSaveDIR
Func G_T1_I_QueryPort()
	Local $aTxtOld = $xServerport[$tGridActive]
	$xServerport[$tGridActive] = GUICtrlRead($G_T1_I_QueryPort)
	Local $aTxtNew = $xServerport[$tGridActive]
	Local $tParam = "port"
	Local $tLine = _ReplaceServerGrid($tParam, $aTxtOld, $aTxtNew, $xServergridx[$tGridActive], $xServergridy[$tGridActive], $aConfigFull, False)
	If $tLine = -1 Then
		$xServerport[$tGridActive] = $aTxtOld
		_Splash("ERROR! Query Port not saved!" & @CRLF & @CRLF & "(Check if ServerGrid.json file is read-only)", 5000)
	EndIf
	GUICtrlSetData($G_T1_I_QueryPort, $xServerport[$tGridActive])
EndFunc   ;==>G_T1_I_QueryPort
Func G_T1_I_GamePort()
	Local $aTxtOld = $xServergameport[$tGridActive]
	$xServergameport[$tGridActive] = GUICtrlRead($G_T1_I_GamePort)
	Local $aTxtNew = $xServergameport[$tGridActive]
	Local $tParam = "gamePort"
	Local $tLine = _ReplaceServerGrid($tParam, $aTxtOld, $aTxtNew, $xServergridx[$tGridActive], $xServergridy[$tGridActive], $aConfigFull, False)
	If $tLine = -1 Then
		$xServergameport[$tGridActive] = $aTxtOld
		_Splash("ERROR! Game Port not saved!" & @CRLF & @CRLF & "(Check if ServerGrid.json file is read-only)", 5000)
	EndIf
	GUICtrlSetData($G_T1_I_GamePort, $xServergameport[$tGridActive])
EndFunc   ;==>G_T1_I_GamePort
Func G_T1_I_SeamlessPort()
	Local $aTxtOld = $xServerseamlessDataPort[$tGridActive]
	$xServerseamlessDataPort[$tGridActive] = GUICtrlRead($G_T1_I_SeamlessPort)
	Local $aTxtNew = $xServerseamlessDataPort[$tGridActive]
	Local $tParam = "seamlessDataPort"
	Local $tLine = _ReplaceServerGrid($tParam, $aTxtOld, $aTxtNew, $xServergridx[$tGridActive], $xServergridy[$tGridActive], $aConfigFull, False)
	If $tLine = -1 Then
		$xServerseamlessDataPort[$tGridActive] = $aTxtOld
		_Splash("ERROR! SeamlessDataPort not saved!" & @CRLF & @CRLF & "(Check if ServerGrid.json file is read-only)", 5000)
	EndIf
	GUICtrlSetData($G_T1_I_SeamlessPort, $xServerseamlessDataPort[$tGridActive])
EndFunc   ;==>G_T1_I_SeamlessPort
Func G_T1_I_RCONPort()
	Local $aTxtOld = $xServerRCONPort[$tGridActive + 1]
	$xServerRCONPort[$tGridActive + 1] = GUICtrlRead($G_T1_I_RCONPort)
	Local $aTxtNew = $xServerRCONPort[$tGridActive + 1]
	If ($aServerRCONImport = "yes") Then
		Local $aFile = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\GameUserSettings.ini"
		Local $tBefore = "RCONPort=" & $aTxtOld
		_ReplaceStringFile($aFile, $tBefore, $aTxtNew)
	Else
		_BackupFile($aIniFile)
		$aServerRCONPort = StringReplace($aServerRCONPort, $aTxtOld, $aTxtNew)
		IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server RCON Port(s) (comma separated, grid order as in ServerGrid.json, ignore if importing RCON ports) ###", $aServerRCONPort)
	EndIf
	GUICtrlSetData($G_T1_I_RCONPort, $xServerRCONPort[$tGridActive + 1])
EndFunc   ;==>G_T1_I_RCONPort
Func G_T1_I_CommandlineAllGrids()
	$aServerExtraCMD = GUICtrlRead($G_T1_I_CommandlineAllGrids)
	_BackupFile($aIniFile)
	IniWrite($aIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " extra commandline parameters (ex.?serverpve-pve -NoCrashDialog) ###", $aServerExtraCMD)
EndFunc   ;==>G_T1_I_CommandlineAllGrids
Func G_T1_I_CommandlineThisGrid()
	$xServerGridExtraCMD[$tGridActive] = GUICtrlRead($G_T1_I_CommandlineThisGrid)
	_BackupFile($aGridSelectFile)
	IniWrite($aGridSelectFile, $aGridIniTitle[2], "Add to Commandline for Server (" & $xServergridx[$tGridActive] & "," & $xServergridy[$tGridActive] & ")", $xServerGridExtraCMD[$tGridActive])
EndFunc   ;==>G_T1_I_CommandlineThisGrid
; -------------------------------------------------------------------
Func G_T2_UpdateTab()
	GUICtrlSetData($G_T2_L_GridNumber, "(" & _ServerNamingScheme($tGridActive, $aNamingScheme) & ")")
	GUICtrlSetData($G_T2_L_GridName, $xServerNames[$tGridActive])
	Local $tFile = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\GameUserSettings.ini"
	Local $tFileRead = FileRead($tFile)
	GUICtrlSetData($G_T2_E_Edit, $tFileRead)
EndFunc   ;==>G_T2_UpdateTab
Func G_T2_E_EditGUS()
	$tG_T2_EditClicked = True
;~ 	GUICtrlSetBkColor($G_T2_B_Save, $cGGridSaveButtonActive)
EndFunc   ;==>G_T2_E_EditGUS
Func G_T2_B_Save()
;~ 	GUICtrlSetBkColor($G_T2_B_Save, $GUI_SS_DEFAULT_BUTTON)
	Local $tFileName = "GameUserSettings.ini"
	Local $tTxt = GUICtrlRead($G_T2_E_Edit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\" & $tFileName
	Local $tFileBackup = $tFileSource & "_" & $tTime & ".bak"
	FileMove($tFileSource, $tFileBackup, 1)
	FileWrite($tFileSource, $tTxt)
	_Splash($tFileName & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $tFileName & "_" & $tTime & ".bak", 2000, 525)
EndFunc   ;==>G_T2_B_Save
Func G_T2_B_Reset()
	Local $tFileName = "GameUserSettings.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\" & $tFileName
	Local $tTxt = FileRead($tFileSource)
	GUICtrlSetData($G_T2_E_Edit, $tTxt)
EndFunc   ;==>G_T2_B_Reset
Func G_T2_B_Replace()
	Local $tTxtBefore = InputBox($aUtilName, "Enter text to replace (before)", "", "", -1, 125)
	If $tTxtBefore = "" Then Return
	Local $tTxtAfter = InputBox($aUtilName, "Enter text to replace with (after)", "", "", -1, 125)
	$tMB = MsgBox($MB_OKCANCEL, "REPLACE TEXT", "Replace:" & $tTxtBefore & @CRLF & "With:" & $tTxtAfter)
	If $tMB = 1 Then ; OK
		Local $tTxt = GUICtrlRead($G_T2_E_Edit)
		Local $tTxt1 = StringReplace($tTxt, $tTxtBefore, $tTxtAfter)
		$tReplacements = @extended
		GUICtrlSetData($G_T2_E_Edit, $tTxt1)
		$tG_T2_EditClicked = True
		_Splash($tReplacements & " occurrences were replaced", 2000)
	Else
		_Splash("Replace canceled.", 1500)
	EndIf
EndFunc   ;==>G_T2_B_Replace
Func G_T2_B_ClipboardCopy()
	ClipPut(GUICtrlRead($G_T2_E_Edit))
	_Splash("Contents copied to clipboard", 750)
EndFunc   ;==>G_T2_B_ClipboardCopy
Func G_T2_B_ClipboardPaste()
	GUICtrlSetData($G_T2_E_Edit, ClipGet())
EndFunc   ;==>G_T2_B_ClipboardPaste
Func G_T2_B_OpenFile()
	Local $tFileName = "GameUserSettings.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\" & $tFileName
	ShellExecute($tFileSource)
EndFunc   ;==>G_T2_B_OpenFile
Func G_T2_B_OpenFolder()
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer"
	ShellExecute($tFileSource)
EndFunc   ;==>G_T2_B_OpenFolder
; -------------------------------------------------------------------
Func G_T3_UpdateTab()
	GUICtrlSetData($G_T3_L_GridNumber, "(" & _ServerNamingScheme($tGridActive, $aNamingScheme) & ")")
	GUICtrlSetData($G_T3_L_GridName, $xServerNames[$tGridActive])
	Local $tFile = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\Game.ini"
	Local $tFileRead = FileRead($tFile)
	GUICtrlSetData($G_T3_E_Edit, $tFileRead)
EndFunc   ;==>G_T3_UpdateTab
Func G_T3_E_Edit()
	$tG_T3_EditClicked = True
;~ 	GUICtrlSetBkColor($G_T3_B_Save, $cGGridSaveButtonActive)
EndFunc   ;==>G_T3_E_Edit
Func G_T3_B_Save()
;~ 	GUICtrlSetBkColor($G_T3_B_Save, $GUI_SS_DEFAULT_BUTTON)
	Local $tFileName = "Game.ini"
	Local $tTxt = GUICtrlRead($G_T3_E_Edit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\" & $tFileName
	Local $tFileBackup = $tFileSource & "_" & $tTime & ".bak"
	FileMove($tFileSource, $tFileBackup, 1)
	FileWrite($tFileSource, $tTxt)
	_Splash($tFileName & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $tFileName & "_" & $tTime & ".bak", 2000, 525)
EndFunc   ;==>G_T3_B_Save
Func G_T3_B_Reset()
	Local $tFileName = "Game.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\" & $tFileName
	Local $tTxt = FileRead($tFileSource)
	GUICtrlSetData($G_T3_E_Edit, $tTxt)
EndFunc   ;==>G_T3_B_Reset
Func G_T3_B_Replace()
	Local $tTxtBefore = InputBox($aUtilName, "Enter text to replace (before)", "", "", -1, 125)
	If $tTxtBefore = "" Then Return
	Local $tTxtAfter = InputBox($aUtilName, "Enter text to replace with (after)", "", "", -1, 125)
	$tMB = MsgBox($MB_OKCANCEL, "REPLACE TEXT", "Replace:" & $tTxtBefore & @CRLF & "With:" & $tTxtAfter)
	If $tMB = 1 Then ; OK
		Local $tTxt = GUICtrlRead($G_T3_E_Edit)
		Local $tTxt1 = StringReplace($tTxt, $tTxtBefore, $tTxtAfter)
		$tReplacements = @extended
		GUICtrlSetData($G_T3_E_Edit, $tTxt1)
		$tG_T3_EditClicked = True
		_Splash($tReplacements & " occurrences were replaced", 2000)
	Else
		_Splash("Replace canceled.", 1500)
	EndIf
EndFunc   ;==>G_T3_B_Replace
Func G_T3_B_ClipboardCopy()
	ClipPut(GUICtrlRead($G_T3_E_Edit))
	_Splash("Contents copied to clipboard", 750)
EndFunc   ;==>G_T3_B_ClipboardCopy
Func G_T3_B_ClipboardPaste()
	GUICtrlSetData($G_T3_E_Edit, ClipGet())
EndFunc   ;==>G_T3_B_ClipboardPaste
Func G_T3_B_OpenFile()
	Local $tFileName = "Game.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\" & $tFileName
	ShellExecute($tFileSource)
EndFunc   ;==>G_T3_B_OpenFile
Func G_T3_B_OpenFolder()
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer"
	ShellExecute($tFileSource)
EndFunc   ;==>G_T3_B_OpenFolder
; -------------------------------------------------------------------
Func G_T4_UpdateTab()
	GUICtrlSetData($G_T4_L_GridNumber, "(" & _ServerNamingScheme($tGridActive, $aNamingScheme) & ")")
	GUICtrlSetData($G_T4_L_GridName, $xServerNames[$tGridActive])
	Local $tFile = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\Engine.ini"
	Local $tFileRead = FileRead($tFile)
	GUICtrlSetData($G_T4_E_Edit, $tFileRead)
EndFunc   ;==>G_T4_UpdateTab
Func G_T4_E_Edit()
	$tG_T4_EditClicked = True
;~ 	GUICtrlSetBkColor($G_T4_B_Save, $cGGridSaveButtonActive)
EndFunc   ;==>G_T4_E_Edit
Func G_T4_B_Save()
;~ 	GUICtrlSetBkColor($G_T4_B_Save, $GUI_SS_DEFAULT_BUTTON)
	Local $tFileName = "Engine.ini"
	Local $tTxt = GUICtrlRead($G_T4_E_Edit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\" & $tFileName
	Local $tFileBackup = $tFileSource & "_" & $tTime & ".bak"
	FileMove($tFileSource, $tFileBackup, 1)
	FileWrite($tFileSource, $tTxt)
	_Splash($tFileName & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $tFileName & "_" & $tTime & ".bak", 2000, 525)
EndFunc   ;==>G_T4_B_Save
Func G_T4_B_Reset()
	Local $tFileName = "Engine.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\" & $tFileName
	Local $tTxt = FileRead($tFileSource)
	GUICtrlSetData($G_T4_E_Edit, $tTxt)
EndFunc   ;==>G_T4_B_Reset
Func G_T4_B_Replace()
	Local $tTxtBefore = InputBox($aUtilName, "Enter text to replace (before)", "", "", -1, 125)
	If $tTxtBefore = "" Then Return
	Local $tTxtAfter = InputBox($aUtilName, "Enter text to replace with (after)", "", "", -1, 125)
	$tMB = MsgBox($MB_OKCANCEL, "REPLACE TEXT", "Replace:" & $tTxtBefore & @CRLF & "With:" & $tTxtAfter)
	If $tMB = 1 Then ; OK
		Local $tTxt = GUICtrlRead($G_T4_E_Edit)
		Local $tTxt1 = StringReplace($tTxt, $tTxtBefore, $tTxtAfter)
		$tReplacements = @extended
		GUICtrlSetData($G_T4_E_Edit, $tTxt1)
		$tG_T4_EditClicked = True
		_Splash($tReplacements & " occurrences were replaced", 2000)
	Else
		_Splash("Replace canceled.", 1500)
	EndIf
EndFunc   ;==>G_T4_B_Replace
Func G_T4_B_ClipboardCopy()
	ClipPut(GUICtrlRead($G_T4_E_Edit))
	_Splash("Contents copied to clipboard", 750)
EndFunc   ;==>G_T4_B_ClipboardCopy
Func G_T4_B_ClipboardPaste()
	GUICtrlSetData($G_T4_E_Edit, ClipGet())
EndFunc   ;==>G_T4_B_ClipboardPaste
Func G_T4_B_OpenFile()
	Local $tFileName = "Engine.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer\" & $tFileName
	ShellExecute($tFileSource)
EndFunc   ;==>G_T4_B_OpenFile
Func G_T4_B_OpenFolder()
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Saved\" & $xServerAltSaveDir[$tGridActive] & "\Config\WindowsServer"
	ShellExecute($tFileSource)
EndFunc   ;==>G_T4_B_OpenFolder
 - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
Func G_T5_UpdateTab()
	GUICtrlSetData($G_T5_L_GridNumber, "(" & _ServerNamingScheme($tGridActive, $aNamingScheme) & ")")
	GUICtrlSetData($G_T5_L_GridName, $xServerNames[$tGridActive])
	Local $tFile = $aServerDirLocal & "\ShooterGame\ServerGrid.json"
	Local $tFileRead = FileRead($tFile)
	GUICtrlSetData($G_T5_E_Edit, $tFileRead)
EndFunc   ;==>G_T5_UpdateTab
Func G_T5_E_Edit()
	$tG_T5_EditClicked = True
;~ 	GUICtrlSetBkColor($G_T5_B_Save, $cGGridSaveButtonActive)
EndFunc   ;==>G_T5_E_Edit
Func G_T5_B_Save()
;~ 	GUICtrlSetBkColor($G_T5_B_Save, $GUI_SS_DEFAULT_BUTTON)
	Local $tFileName = "ServerGrid.json"
	Local $tTxt = GUICtrlRead($G_T5_E_Edit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\" & $tFileName
	Local $tFileBackup = $tFileSource & "_" & $tTime & ".bak"
	FileMove($tFileSource, $tFileBackup, 1)
	FileWrite($tFileSource, $tTxt)
	_Splash($tFileName & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $tFileName & "_" & $tTime & ".bak", 2000, 525)
EndFunc   ;==>G_T5_B_Save
Func G_T5_B_Reset()
	Local $tFileName = "ServerGrid.json"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\" & $tFileName
	Local $tTxt = FileRead($tFileSource)
	GUICtrlSetData($G_T5_E_Edit, $tTxt)
EndFunc   ;==>G_T5_B_Reset
Func G_T5_B_Replace()
	Local $tTxtBefore = InputBox($aUtilName, "Enter text to replace (before)", "", "", -1, 125)
	If $tTxtBefore = "" Then Return
	Local $tTxtAfter = InputBox($aUtilName, "Enter text to replace with (after)", "", "", -1, 125)
	$tMB = MsgBox($MB_OKCANCEL, "REPLACE TEXT", "Replace:" & $tTxtBefore & @CRLF & "With:" & $tTxtAfter)
	If $tMB = 1 Then ; OK
		Local $tTxt = GUICtrlRead($G_T5_E_Edit)
		Local $tTxt1 = StringReplace($tTxt, $tTxtBefore, $tTxtAfter)
		$tReplacements = @extended
		GUICtrlSetData($G_T5_E_Edit, $tTxt1)
		$tG_T5_EditClicked = True
		_Splash($tReplacements & " occurrences were replaced", 2000)
	Else
		_Splash("Replace canceled.", 1500)
	EndIf
EndFunc   ;==>G_T5_B_Replace
Func G_T5_B_Find() ; Kim !!!
	$tTxt = InputBox($aUtilName, "Enter text to find", "", "", -1, 125)
	If $tTxt = "" Then
	Else
		Local $tTxt1 = GUICtrlRead($G_T5_E_Edit)
		$tTxtPos = StringInStr($tTxt1, $tTxt)
		If $tTxtPos = 0 Then
			_Splash("Text not found", 1000)
		Else
			MsgBox(0, "Kim", "PosStart:" & $tTxtPos & " PosEnd:" & $tTxtPos + StringLen($tTxt) & " Len:" & StringLen($tTxt))
			_GUICtrlEdit_SetSel($G_T5_E_Edit, $tTxtPos, $tTxtPos + StringLen($tTxt))
			_GUICtrlEdit_Scroll($G_T5_E_Edit, $SB_SCROLLCARET)
			_GUICtrlEdit_SetSel($G_T5_E_Edit, $tTxtPos, $tTxtPos + StringLen($tTxt))
			_GUICtrlEdit_Scroll($G_T5_E_Edit, $SB_SCROLLCARET)
		EndIf
	EndIf
EndFunc   ;==>G_T5_B_Find
Func G_T5_B_ClipboardCopy()
	ClipPut(GUICtrlRead($G_T5_E_Edit))
	_Splash("Contents copied to clipboard", 750)
EndFunc   ;==>G_T5_B_ClipboardCopy
Func G_T5_B_ClipboardPaste()
	GUICtrlSetData($G_T5_E_Edit, ClipGet())
EndFunc   ;==>G_T5_B_ClipboardPaste
Func G_T5_B_OpenFile()
	Local $tFileName = "ServerGrid.json"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\" & $tFileName
	ShellExecute($tFileSource)
EndFunc   ;==>G_T5_B_OpenFile
Func G_T5_B_OpenFolder()
	Local $tFileSource = $aServerDirLocal & "\ShooterGame"
	ShellExecute($tFileSource)
EndFunc   ;==>G_T5_B_OpenFolder
; -------------------------------------------------------------------
Func G_T6_UpdateTab()
	GUICtrlSetData($G_T6_L_GridNumber, "(" & _ServerNamingScheme($tGridActive, $aNamingScheme) & ")")
	GUICtrlSetData($G_T6_L_GridName, $xServerNames[$tGridActive])
	Local $tFile = $aServerDirLocal & "\ShooterGame\Config\DefaultGameUserSettings.ini"
	Local $tFileRead = FileRead($tFile)
	GUICtrlSetData($G_T6_E_Edit, $tFileRead)
EndFunc   ;==>G_T6_UpdateTab
Func G_T6_E_Edit()
	$tG_T6_EditClicked = True
;~ 	GUICtrlSetBkColor($G_T6_B_Save, $cGGridSaveButtonActive)
EndFunc   ;==>G_T6_E_Edit
Func G_T6_B_Save()
;~ 	GUICtrlSetBkColor($G_T6_B_Save, $GUI_SS_DEFAULT_BUTTON)
	Local $tFileName = "DefaultGameUserSettings.ini"
	Local $tTxt = GUICtrlRead($G_T6_E_Edit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config\" & $tFileName
	Local $tFileBackup = $tFileSource & "_" & $tTime & ".bak"
	FileMove($tFileSource, $tFileBackup, 1)
	FileWrite($tFileSource, $tTxt)
	_Splash($tFileName & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $tFileName & "_" & $tTime & ".bak", 2000, 525)
EndFunc   ;==>G_T6_B_Save
Func G_T6_B_Reset()
	Local $tFileName = "DefaultGameUserSettings.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config\" & $tFileName
	Local $tTxt = FileRead($tFileSource)
	GUICtrlSetData($G_T6_E_Edit, $tTxt)
EndFunc   ;==>G_T6_B_Reset
Func G_T6_B_Replace()
	Local $tTxtBefore = InputBox($aUtilName, "Enter text to replace (before)", "", "", -1, 125)
	If $tTxtBefore = "" Then Return
	Local $tTxtAfter = InputBox($aUtilName, "Enter text to replace with (after)", "", "", -1, 125)
	$tMB = MsgBox($MB_OKCANCEL, "REPLACE TEXT", "Replace:" & $tTxtBefore & @CRLF & "With:" & $tTxtAfter)
	If $tMB = 1 Then ; OK
		Local $tTxt = GUICtrlRead($G_T6_E_Edit)
		Local $tTxt1 = StringReplace($tTxt, $tTxtBefore, $tTxtAfter)
		$tReplacements = @extended
		GUICtrlSetData($G_T6_E_Edit, $tTxt1)
		$tG_T6_EditClicked = True
		_Splash($tReplacements & " occurrences were replaced", 2000)
	Else
		_Splash("Replace canceled.", 1500)
	EndIf
EndFunc   ;==>G_T6_B_Replace
Func G_T6_B_ClipboardCopy()
	ClipPut(GUICtrlRead($G_T6_E_Edit))
	_Splash("Contents copied to clipboard", 750)
EndFunc   ;==>G_T6_B_ClipboardCopy
Func G_T6_B_ClipboardPaste()
	GUICtrlSetData($G_T6_E_Edit, ClipGet())
EndFunc   ;==>G_T6_B_ClipboardPaste
Func G_T6_B_OpenFile()
	Local $tFileName = "DefaultGameUserSettings.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config\" & $tFileName
	ShellExecute($tFileSource)
EndFunc   ;==>G_T6_B_OpenFile
Func G_T6_B_OpenFolder()
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config"
	ShellExecute($tFileSource)
EndFunc   ;==>G_T6_B_OpenFolder
; -------------------------------------------------------------------
Func G_T7_UpdateTab()
	GUICtrlSetData($G_T7_L_GridNumber, "(" & _ServerNamingScheme($tGridActive, $aNamingScheme) & ")")
	GUICtrlSetData($G_T7_L_GridName, $xServerNames[$tGridActive])
	Local $tFile = $aServerDirLocal & "\ShooterGame\Config\DefaultGame.ini"
	Local $tFileRead = FileRead($tFile)
	GUICtrlSetData($G_T7_E_Edit, $tFileRead)
EndFunc   ;==>G_T7_UpdateTab
Func G_T7_E_Edit()
	$tG_T7_EditClicked = True
;~ 	GUICtrlSetBkColor($G_T7_B_Save, $cGGridSaveButtonActive)
EndFunc   ;==>G_T7_E_Edit
Func G_T7_B_Save()
;~ 	GUICtrlSetBkColor($G_T7_B_Save, $GUI_SS_DEFAULT_BUTTON)
	Local $tFileName = "DefaultGame.ini"
	Local $tTxt = GUICtrlRead($G_T7_E_Edit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config\" & $tFileName
	Local $tFileBackup = $tFileSource & "_" & $tTime & ".bak"
	FileMove($tFileSource, $tFileBackup, 1)
	FileWrite($tFileSource, $tTxt)
	_Splash($tFileName & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $tFileName & "_" & $tTime & ".bak", 2000, 525)
EndFunc   ;==>G_T7_B_Save
Func G_T7_B_Reset()
	Local $tFileName = "DefaultGame.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config\" & $tFileName
	Local $tTxt = FileRead($tFileSource)
	GUICtrlSetData($G_T7_E_Edit, $tTxt)
EndFunc   ;==>G_T7_B_Reset
Func G_T7_B_Replace()
	Local $tTxtBefore = InputBox($aUtilName, "Enter text to replace (before)", "", "", -1, 125)
	If $tTxtBefore = "" Then Return
	Local $tTxtAfter = InputBox($aUtilName, "Enter text to replace with (after)", "", "", -1, 125)
	$tMB = MsgBox($MB_OKCANCEL, "REPLACE TEXT", "Replace:" & $tTxtBefore & @CRLF & "With:" & $tTxtAfter)
	If $tMB = 1 Then ; OK
		Local $tTxt = GUICtrlRead($G_T7_E_Edit)
		Local $tTxt1 = StringReplace($tTxt, $tTxtBefore, $tTxtAfter)
		$tReplacements = @extended
		GUICtrlSetData($G_T7_E_Edit, $tTxt1)
		$tG_T7_EditClicked = True
		_Splash($tReplacements & " occurrences were replaced", 2000)
	Else
		_Splash("Replace canceled.", 1500)
	EndIf
EndFunc   ;==>G_T7_B_Replace
Func G_T7_B_ClipboardCopy()
	ClipPut(GUICtrlRead($G_T7_E_Edit))
	_Splash("Contents copied to clipboard", 750)
EndFunc   ;==>G_T7_B_ClipboardCopy
Func G_T7_B_ClipboardPaste()
	GUICtrlSetData($G_T7_E_Edit, ClipGet())
EndFunc   ;==>G_T7_B_ClipboardPaste
Func G_T7_B_OpenFile()
	Local $tFileName = "DefaultGame.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config\" & $tFileName
	ShellExecute($tFileSource)
EndFunc   ;==>G_T7_B_OpenFile
Func G_T7_B_OpenFolder()
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config"
	ShellExecute($tFileSource)
EndFunc   ;==>G_T7_B_OpenFolder
; -------------------------------------------------------------------
Func G_T8_UpdateTab()
	GUICtrlSetData($G_T8_L_GridNumber, "(" & _ServerNamingScheme($tGridActive, $aNamingScheme) & ")")
	GUICtrlSetData($G_T8_L_GridName, $xServerNames[$tGridActive])
	Local $tFile = $aServerDirLocal & "\ShooterGame\Config\DefaultEngine.ini"
	Local $tFileRead = FileRead($tFile)
	GUICtrlSetData($G_T8_E_Edit, $tFileRead)
EndFunc   ;==>G_T8_UpdateTab
Func G_T8_E_Edit()
	$tG_T8_EditClicked = True
;~ 	GUICtrlSetBkColor($G_T8_B_Save, $cGGridSaveButtonActive)
EndFunc   ;==>G_T8_E_Edit
Func G_T8_B_Save()
;~ 	GUICtrlSetBkColor($G_T8_B_Save, $GUI_SS_DEFAULT_BUTTON)
	Local $tFileName = "DefaultEngine.ini"
	Local $tTxt = GUICtrlRead($G_T8_E_Edit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config\" & $tFileName
	Local $tFileBackup = $tFileSource & "_" & $tTime & ".bak"
	FileMove($tFileSource, $tFileBackup, 1)
	FileWrite($tFileSource, $tTxt)
	_Splash($tFileName & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $tFileName & "_" & $tTime & ".bak", 2000, 525)
EndFunc   ;==>G_T8_B_Save
Func G_T8_B_Reset()
	Local $tFileName = "DefaultEngine.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config\" & $tFileName
	Local $tTxt = FileRead($tFileSource)
	GUICtrlSetData($G_T8_E_Edit, $tTxt)
EndFunc   ;==>G_T8_B_Reset
Func G_T8_B_Replace()
	Local $tTxtBefore = InputBox($aUtilName, "Enter text to replace (before)", "", "", -1, 125)
	If $tTxtBefore = "" Then Return
	Local $tTxtAfter = InputBox($aUtilName, "Enter text to replace with (after)", "", "", -1, 125)
	$tMB = MsgBox($MB_OKCANCEL, "REPLACE TEXT", "Replace:" & $tTxtBefore & @CRLF & "With:" & $tTxtAfter)
	If $tMB = 1 Then ; OK
		Local $tTxt = GUICtrlRead($G_T8_E_Edit)
		Local $tTxt1 = StringReplace($tTxt, $tTxtBefore, $tTxtAfter)
		$tReplacements = @extended
		GUICtrlSetData($G_T8_E_Edit, $tTxt1)
		$tG_T8_EditClicked = True
		_Splash($tReplacements & " occurrences were replaced", 2000)
	Else
		_Splash("Replace canceled.", 1500)
	EndIf
EndFunc   ;==>G_T8_B_Replace
Func G_T8_B_ClipboardCopy()
	ClipPut(GUICtrlRead($G_T8_E_Edit))
	_Splash("Contents copied to clipboard", 750)
EndFunc   ;==>G_T8_B_ClipboardCopy
Func G_T8_B_ClipboardPaste()
	GUICtrlSetData($G_T8_E_Edit, ClipGet())
EndFunc   ;==>G_T8_B_ClipboardPaste
Func G_T8_B_OpenFile()
	Local $tFileName = "DefaultEngine.ini"
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config\" & $tFileName
	ShellExecute($tFileSource)
EndFunc   ;==>G_T8_B_OpenFile
Func G_T8_B_OpenFolder()
	Local $tFileSource = $aServerDirLocal & "\ShooterGame\Config"
	ShellExecute($tFileSource)
EndFunc   ;==>G_T8_B_OpenFolder
; -------------------------------------------------------------------
Func _ReplaceServerGrid($tParamter, $tTxtToReplace, $tTxtToReplaceWith, $tGridX = -1, $tGridY = -1, $tFileLoad = -1, $tQuotesTF = -1) ; (Par, TxtOld, TxtNew, X, Y, File, QuoteTF)
	If $tGridX = -1 Then $tGridX = $xServergridx[$tGridActive]
	If $tGridY = -1 Then $tGridY = $xServergridy[$tGridActive]
	If $tFileLoad = -1 Then $tFileLoad = $aConfigFull
	If $tQuotesTF = -1 Then $tQuotesTF = True
	Local $tXFound = False, $tYFound = False, $tReturn = 0 ; (no error)
	Local $xfile, $tXFound = False, $tYFound = False, $tReturn = 0 ; (no error)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFileSave = StringTrimRight($tFileLoad, 4) & $tTime & ".json"
	_FileReadToArray($tFileLoad, $xfile, 0)
	Local $tTxtGridX = "      ""gridX"": " & $tGridX & ","
	Local $tTxtGridY = "      ""gridY"": " & $tGridY & ","
	If $tQuotesTF Then
		Local $tTxtToFind = "      """ & $tParamter & """: """ & $tTxtToReplace & ""","
	Else
		Local $tTxtToFind = "      """ & $tParamter & """: " & $tTxtToReplace & ","
	EndIf
	For $i = 0 To (UBound($xfile) - 1)
		If $xfile[$i] = $tTxtGridX Then $tXFound = True
		If $tXFound And $xfile[$i] = $tTxtGridY Then $tYFound = True
		If $tXFound And $tYFound And $xfile[$i] = $tTxtToFind Then ExitLoop
	Next
	If $i > (UBound($xfile) - 5) Then
		$tReturn = -1
	Else
		$tReturn = $i
		$xfile[$i] = StringReplace($xfile[$i], $tTxtToReplace, $tTxtToReplaceWith)
		_BackupFile($tFileLoad, $xfile, True, True)
	EndIf
	Return $tReturn
EndFunc   ;==>_ReplaceServerGrid
Func _BackupFile($tFile, $tNewTxt = "", $tSplashTF = True, $tIsArrayTF = False)
	; Creates backup with timstamp
	Local $tTxt, $tPos, $tExt, $tNoExt, $tTime, $tFileSave, $tFolderOnly, $tFileOnly
	For $tC = 1 To StringLen($tFile)
		$tTxt = StringRight($tFile, $tC)
		If StringInStr($tTxt, ".") = 0 Then
		Else
			$tNoExt = StringTrimRight($tFile, $tC)
			$tExt = StringTrimLeft($tTxt, 1)
			ExitLoop
		EndIf
	Next
	If StringLen($tFile) = $tC Then Return "ERROR-No . found"
	For $tC = 1 To StringLen($tFile)
		$tTxt = StringRight($tFile, $tC)
		If StringInStr($tTxt, "\") = 0 Then
		Else
			$tFolderOnly = StringTrimRight($tFile, $tC)
			$tFileOnly = StringTrimLeft($tTxt, 1)
			ExitLoop
		EndIf
	Next
	If StringLen($tFile) = $tC Then Return "ERROR-No \ found"
	$tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
;~ 	$tFileSave = $tNoExt & "_" & $tTime & "." & $tExt
	$tFileSave = $tFile & "_" & $tTime & ".bak"
	If $tNewTxt <> "" Then
		FileMove($tFile, $tFileSave, 1)
		If $tIsArrayTF = False Then
			FileWrite($tFile, $tNewTxt)
		Else
			_FileWriteFromArray($tFile, $tNewTxt)
		EndIf
	Else
		FileCopy($tFile, $tFileSave)
	EndIf
	LogWrite("", " [FILE] " & $tFileOnly & " updated. Backup created:" & $tFileOnly & "." & $tExt & "_" & $tTime & ".bak")
	If $tSplashTF Then _Splash($tFileOnly & " updated." & @CRLF & @CRLF & "Backup created:" & @CRLF & $tFileOnly & "." & $tExt & "_" & $tTime & ".bak", 1500)
	Return $tFileSave
EndFunc   ;==>_BackupFile
Func _ReplaceStringFile($tFile, $tTxtToReplace, $tTxtToReplaceWith)
	; Takes $tTxtToReplace (RCON=5710) and changes it to $tTxtToReplaceWith (1234) to be RCON=1234
	Local $tTxt, $tPos, $tExt, $tNoExt, $tTime, $tFileSave, $tFolderOnly, $tFileOnly
	Local $xfile, $tXFound = False, $tYFound = False, $tReturn = 0 ; (no error)
	For $tC = 1 To StringLen($tTxtToReplace)
		$tTxt = StringRight($tTxtToReplace, $tC)
		If StringInStr($tTxt, "=") = 0 Then
		Else
			$tParameter = StringTrimRight($tTxtToReplace, $tC)
;~ 			$tExt = StringTrimLeft($tTxt, 1)
			ExitLoop
		EndIf
	Next
	_FileReadToArray($tFile, $xfile, 0)
	For $i = 0 To (UBound($xfile) - 1)
		If StringInStr($xfile[$i], $tParameter) = 0 Then
		Else
			$tPos = $i
			ExitLoop
		EndIf
	Next
	For $tC = 1 To StringLen($tFile)
		$tTxt = StringRight($tFile, $tC)
		If StringInStr($tTxt, "\") = 0 Then
		Else
			$tFolderOnly = StringTrimRight($tFile, $tC)
			$tFileOnly = StringTrimLeft($tTxt, 1)
			ExitLoop
		EndIf
	Next
	LogWrite("", " [FILE] Changed Parameter in Server " & _ServerNamingScheme($tGridActive, $aNamingScheme) & " [" & $tFileOnly & "] From:" & $tTxtToReplace & " to " & $tParameter & "=" & $tTxtToReplaceWith)
	$xfile[$tPos] = $tParameter & "=" & $tTxtToReplaceWith
	_BackupFile($tFile, $xfile, True, True)
EndFunc   ;==>_ReplaceStringFile

; ------------------------------------------------------------------------------------------------------------------------------------------
; ========================================================= User_Defined_Functions =========================================================
; ------------------------------------------------------------------------------------------------------------------------------------------

Func _GetMemArrayRawAvg($Pid)
	Local $tMem[UBound($Pid)], $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2")
	If @error Then Return 0
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PerfRawData_PerfProc_Process", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) Then
		For $objItem In $colItems
			For $x = 0 To (UBound($Pid) - 1)
;~ 				If $pid[$x] = $objItem.IDProcess Then $tMem[$x] = (($objItem.WorkingSetPrivate + $objItem.WorkingSet) / 2) ; Average
				If $Pid[$x] = $objItem.IDProcess Then $tMem[$x] = ($objItem.WorkingSetPrivate)     ; Working Set Private
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

; ------------------------------------------------------------------------------------------------------------

Func _NetworkConnectionsViewer()
	; NETWORK CONNECTIONS VIEWER https://www.autoitscript.com/forum/topic/105150-network-connections-viewer/
	;.......script written by trancexx (trancexx at yahoo dot com)
	Run(@ScriptDir & "\NetworkConnectionsViewer.exe")
EndFunc   ;==>_NetworkConnectionsViewer

;~ #include-once
Func _GUIListViewEx_Globals()
	; #INDEX# ============================================================================================================
	; Title .........: GUIListViewEx
	; AutoIt Version : 3.3.10 +
	; Language ......: English
	; Description ...: Permits insertion, deletion, moving, dragging, sorting, editing and colouring of items within ListViews
	; Remarks .......: - It is important to use _GUIListViewEx_Close when a enabled ListView is deleted to free the memory used
	;                    by the $aGLVEx_Data array which shadows the ListView contents.
	;                  - _GUIListViewEx_EventMonitor must be placed in the script idel loop if editing or using colour
	;                  - Windows message handlers required:
	;                     - WM_NOTIFY: All UDF functions
	;                     - WM_MOUSEMOVE and WM_LBUTTONUP: Only needed if dragging
	;                     - WM_SYSCOMMAND: Permits immediate [X] GUI closure while editing
	;                  - If the script already has WM_NOTIFY, WM_MOUSEMOVE, WM_LBUTTONUP or WM_SYSCOMMAND handlers then only set
	;                    unregistered messages in _GUIListViewEx_MsgRegister and call the relevant _GUIListViewEx_WM_#####_Handler
	;                    from within the existing handler
	;                  - Uses 2 undocumented functions within GUIListView UDF to set and colour insert mark (thanks rover)
	;                  - Enabling user colours significantly slows ListView redrawing
	; Author ........: Melba23
	; Credits .......: martin (basic drag code), Array.au3 authors (array functions), KaFu and ProgAndy (font function)
	;                  LarsJ (colouring code)
	; ====================================================================================================================

	;#AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w- 4 -w 5 -w 6 -w- 7

	; #INCLUDES# =========================================================================================================
;~ #include <GuiListView.au3>
;~ #include <GUIImageList.au3>
;~ #include <WinAPISys.au3>

	; #GLOBAL VARIABLES# =================================================================================================
	; Array to hold registered ListView data
	Global $aGLVEx_Data[1][26] = [[0, 0, -1, "", -1, -1, -1, -1, _WinAPI_GetSystemMetrics(2), False, _
			 -1, -1, False, "", 0, True, 0, -1, -1, 0, 0, 0, 0, "08"]]
	; [0][0]  = ListView Count      [n][0]  = ListView handle
	; [0][1]  = Active Index        [n][1]  = Native ListView ControlID / 0
	; [0][2]  = Active Column       [n][2]  = Shadow array
	; [0][3]  = Row Depth           [n][3]  = Shadow array count element (0/1) & 2D return (+ 2)
	; [0][4]  = Curr ToolTip Row    [n][4]  = Sort status
	; [0][5]  = Curr ToolTip Col    [n][5]  = Drag image flag
	; [0][6]  = Prev ToolTip Row    [n][6]  = Checkbox array flag
	; [0][7]  = Prev ToolTip Col    [n][7]  = Editable columns data
	; [0][8]  = VScrollbar width    [n][8]  = Editable header flag
	; [0][9]  = SysClose flag       [n][9]  = Continue edit on click flag
	; [0][10] = RtClick Row         [n][10] = Item depth for scrolling
	; [0][11] = RtClick Col         [n][11] = Do not "select all" on edit flag
	; [0][12] = Colour Handler Flag [n][12] = Drag/drop status flag
	; [0][13] = Active Colour Array [n][13] = Header drag style flag
	; [0][14] = Curr Redraw Handle  [n][14] = Edit width array
	; [0][15] = Allow Redraw Flag   [n][15] = ToolTip column range
	; [0][16] = KeyCode             [n][16] = ToolTip display time
	; [0][17] = Active Row          [n][17] = ToolTip mode
	; [0][18] = Active Column       [n][18] = Colour array
	; [0][19] = Sort Flag           [n][19] - Colour flag
	; [0][20] = Curr header handle  [n][20] - Active row
	; [0][21] = Curr header font    [n][21] - Active column
	; [0][22] = Colour redraw flag  [n][22] - Single cell flag
	; [0][23] = Start edit keycode  [n][23] - Default user colours
	; [0][24] = Separator char      [n][24] - Header colour flag (handle)
	;                               [n][25] - Header data array

	; Variables for UDF handlers
	Global $hGLVEx_SrcHandle, $cGLVEx_SrcID, $iGLVEx_SrcIndex, $aGLVEx_SrcArray, $aGLVEx_SrcColArray
	Global $hGLVEx_TgtHandle, $cGLVEx_TgtID, $iGLVEx_TgtIndex, $aGLVEx_TgtArray, $aGLVEx_TgtColArray
	Global $iGLVEx_Dragging = 0, $iGLVEx_DraggedIndex, $hGLVEx_DraggedImage = 0, $sGLVEx_DragEvent
	Global $iGLVEx_InsertIndex = -1, $iGLVEx_LastY, $fGLVEx_BarUnder
	; Variables for UDF edit
	Global $hGLVEx_Editing, $cGLVEx_EditID = 9999, $fGLVEx_EditClickFlag = 0, $fGLVEx_HeaderEdit = False
	; Flags for user selection indication
	Global $fGLVEx_SelChangeFlag = 0, $fGLVEx_UserSelFlag = 0
	; Predefined user colours [Normal text, normal field, selected cell text, selected cell field] - BGR
	Global $aGLVEx_DefColours[4] = ["0x000000", "0xFEFEFE", "0xFFFFFF", "0xCC6600"]
EndFunc   ;==>_GUIListViewEx_Globals

; #CURRENT# ==========================================================================================================
; _GUIListViewEx_Init:                  Enables UDF functions for the ListView and sets various flags
; _GUIListViewEx_Close:                 Disables all UDF functions for the specified ListView and clears all memory used
; _GUIListViewEx_SetActive:             Set specified ListView as active for non-specific UDF functions
; _GUIListViewEx_GetActive:             Get index number of active ListView for non-specific UDF functions
; _GUIListViewEx_ReadToArray:           Creates an array from the current ListView content to be loaded in _Init function
; _GUIListViewEx_ReturnArray:           Returns an array of the current content, checkbox state, colour of the ListView
; _GUIListViewEx_SaveListView:          Saves ListView header data, ListView content, checkbox state and colour data to file
; _GUIListViewEx_LoadListView:          Loads ListView header data, ListView content, checkbox state and colour data from file
; _GUIListViewEx_Up:                    Moves selected row(s) in active ListView up 1 row
; _GUIListViewEx_Down:                  Moves selected row(s) in active ListView down 1 row
; _GUIListViewEx_Insert:                Inserts data in row below selected row in active ListView
; _GUIListViewEx_InsertSpec:            Inserts data in specified row in specified ListView
; _GUIListViewEx_Delete:                Deletes selected row(s) in active ListView
; _GUIListViewEx_DeleteSpec:            Deletes specified row(s) in specified ListView
; _GUIListViewEx_InsertCol:             Inserts blank column to right of selected column in active ListView
; _GUIListViewEx_InsertColSpec:         Inserts specified blank column in specified ListView
; _GUIListViewEx_DeleteCol:             Deletes selected column in active ListView
; _GUIListViewEx_DeleteColSpec:         Deletes specified column in specified ListView
; _GUIListViewEx_SortCol:               Sort specified column in specified ListView
; _GUIListViewEx_SetEditStatus:         Sets edit on doubleclick mode for specified column(s)
; _GUIListViewEx_SetEditKey:            Sets key(s) required to begin edit of selected item
; _GUIListViewEx_EditItem:              Manual edit of specified ListView item
; _GUIListViewEx_EditWidth:             Set required widths for column edit/combo when editing
; _GUIListViewEx_ChangeItem:            Programatic change of specified ListView item
; _GUIListViewEx_LoadHdrData:           Sets header title, text and back colour (if enabled), and sets edit mode (if enabled)
; _GUIListViewEx_EditHeader:            Manual edit of specified ListView header
; _GUIListViewEx_LoadColour:            Uses array to set text/back colours for user colour enabled ListViews
; _GUIListViewEx_SetDefColours:         Sets default colours for user colour/single cell select enabled ListViews
; _GUIListViewEx_SetColour:             Sets text and/or back colour for user colour enabled ListViews
; _GUIListViewEx_BlockReDraw:           Prevents ListView redrawing during looped Insert/Delete/Change calls
; _GUIListViewEx_UserSort:              Sets user defined function to sort specified columns
; _GUIListViewEx_GetLastSelItem:   Get last selected item in active or specified ListView
; _GUIListViewEx_ContextPos:            Returns LV index and row/col of last right click
; _GUIListViewEx_ToolTipInit:           Defines column(s) which will display a tooltip when clicked
; _GUIListViewEx_EventMonitor:          Check for edit, sort, drag/drop and tooltip events - auto colour redraw - returns event results
; _GUIListViewEx_MsgRegister:           Registers Windows messages required for the UDF
; _GUIListViewEx_WM_NOTIFY_Handler:     Windows message handler for WM_NOTIFY - needed for all UDF functions
; _GUIListViewEx_WM_MOUSEMOVE_Handler:  Windows message handler for WM_MOUSEMOVE - needed for drag
; _GUIListViewEx_WM_LBUTTONUP_Handler:  Windows message handler for WM_LBUTTONUP - needed for drag
; _GUIListViewEx_WM_SYSCOMMAND_Handler: Windows message handler for WM_SYSCOMMAND - speeds GUI closure when editing
; ====================================================================================================================

; #INTERNAL_USE_ONLY#=================================================================================================
; __GUIListViewEx_ExpandRange:      Expands ranges into an array of values
; __GUIListViewEx_HighLight:        Highlights specified ListView item and ensures it is visible
; __GUIListViewEx_GetLVFont:        Gets font details for ListView to be edited
; __GUIListViewEx_EditProcess:      Runs ListView editing process
; __GUIListViewEx_EditCoords:       Ensures item in view then locates and sizes edit control
; __GUIListViewEx_ReWriteLV:        Deletes all ListView content and refills to match array
; __GUIListViewEx_GetLVCoords:      Gets screen coords for ListView
; __GUIListViewEx_GetCursorWnd:     Gets handle of control under the mouse cursor
; __GUIListViewEx_Array_Add:        Adds a specified value at the end of an array
; __GUIListViewEx_Array_Insert:     Adds a value at the specified index of an array
; __GUIListViewEx_Array_Delete:     Deletes a specified index from an array
; __GUIListViewEx_Array_Swap:       Swaps specified elements within an array
; __GUIListViewEx_ToolTipHide:      Called by Adlib to hide tooltip displayed by _GUIListViewEx_ToolTipShow
; __GUIListViewEx_MakeString:       Convert data/check/colour arrays to strings for saving
; __GUIListViewEx_MakeArray:        Convert data/check/colour strings to arrays for loading
; __GUIListViewEx_ColSort:          Sort columns even if colour enabled
; __GUIListViewEx_RedrawWindow:     Redraw ListView after update
; __GUIListViewEx_CheckUserEditKey: Check keys pressed in ListView
; ====================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Init
; Description ...: Enables UDF functions for the ListView and sets various flags
; Syntax.........: _GUIListViewEx_Init($hLV, [$aArray = ""[, $iStart = 0[, $iColour[, $fImage[, $iAdded]]]]])
; Parameters ....: $hLV       - Handle or ControlID of ListView
;                  $aArray    - Name of array used to fill ListView.  "" for empty ListView
;                  $iStart    - 0 = ListView data starts in [0] element of array (default)
;                               1 = Count in [0] element
;                  $iColour   - RGB colour for insert mark (default = black)
;                  $fImage    - True  = Shadow image of dragged item when dragging
;                               False = No shadow image (default)
;                  $iAdded    - 0       - No added features (default).  To get added features add any of the following values
;                               + 1     - Sortable by clicking on column headers
;                               + 2     - Do not "select all" when editing item text
;                               + 4     - Continue edit within same ListView by triple mouse-click on editable column
;                               + 8     - Headers editable by Ctrl-click (only if column editable)
;                               + 16    - User coloured header
;                               + 32    - User coloured items
;                               + 64    - No external drag
;                               + 128   - No external drop
;                               + 256   - No delete on external drag/drop
;                               + 512   - No internal or external drag/drop
;                               + 1024  - Single cell highlight (forces single row selection)
; Requirement(s).: v3.3.10 +
; Return values .: Index number of ListView for use in other GUIListViewEx functions
; Author ........: Melba23
; Modified ......:
; Remarks .......: - If the ListView is the only one enabled, it is automatically set as active
;                  - If no array is passed a shadow array is created automatically
;                  - The $iStart parameter determines if a count element will be returned by other GUIListViewEx functions
;                  - The _GUIListViewEx_ReadToArray function will read an existing ListView into an array
;                  - Only first item of a multiple selection is shadow imaged when dragging (API limitation)
;                  - Use the _GUIListViewEx_SetEditStatus function to make columns editable
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Init($hLV, $aArray = "", $iStart = 0, $iColour = 0, $fImage = False, $iAdded = 0)

	Local $iLV_Index = 0

	; See if there is a blank line available in the array
	For $i = 1 To $aGLVEx_Data[0][0]
		If $aGLVEx_Data[$i][0] = 0 Then
			$iLV_Index = $i
			ExitLoop
		EndIf
	Next
	; If no blank line found then increase array size
	If $iLV_Index = 0 Then
		$aGLVEx_Data[0][0] += 1
		ReDim $aGLVEx_Data[$aGLVEx_Data[0][0] + 1][UBound($aGLVEx_Data, 2)]
		$iLV_Index = $aGLVEx_Data[0][0]
	EndIf

	; Store ListView handle and ControlID (if it exists)
	If IsHWnd($hLV) Then
		$aGLVEx_Data[$iLV_Index][0] = $hLV
		$aGLVEx_Data[$iLV_Index][1] = 0
	Else
		$aGLVEx_Data[$iLV_Index][0] = GUICtrlGetHandle($hLV)
		$aGLVEx_Data[$iLV_Index][1] = $hLV
	EndIf

	; Store separator char
	$aGLVEx_Data[0][24] = Opt("GUIDataSeparatorChar")

	; Store ListView content in shadow array
	$aGLVEx_Data[$iLV_Index][2] = _GUIListViewEx_ReadToArray($hLV, 1)

	;Set no selected row or column
	$aGLVEx_Data[$iLV_Index][20] = -1
	$aGLVEx_Data[$iLV_Index][21] = -1

	; Store array count flag
	$aGLVEx_Data[$iLV_Index][3] = $iStart
	; Store 1D/2D array return type flag
	If IsArray($aArray) Then
		If UBound($aArray, 0) = 2 Then $aGLVEx_Data[$iLV_Index][3] += 2
	EndIf

	; Create and store editable array
	Local $aEditable[4][UBound($aGLVEx_Data[$iLV_Index][2], 2)]
	$aGLVEx_Data[$iLV_Index][7] = $aEditable

	; Set insert mark colour after conversion to BGR
	_GUICtrlListView_SetInsertMarkColor($hLV, BitOR(BitShift(BitAND($iColour, 0x000000FF), -16), BitAND($iColour, 0x0000FF00), BitShift(BitAND($iColour, 0x00FF0000), 16)))
	; If drag image required
	If $fImage Then
		$aGLVEx_Data[$iLV_Index][5] = 1
	EndIf

	; If sortable, store sort array
	If BitAND($iAdded, 1) Then
		Local $aLVSortState[_GUICtrlListView_GetColumnCount($hLV)]
		$aGLVEx_Data[$iLV_Index][4] = $aLVSortState
	Else
		$aGLVEx_Data[$iLV_Index][4] = 0
	EndIf

	; If do not "select all" on opening edit
	If BitAND($iAdded, 2) Then
		; Set flag
		$aGLVEx_Data[$iLV_Index][11] = 1
	EndIf

	; If continue edit on click
	If BitAND($iAdded, 4) Then
		; Set flag
		$aGLVEx_Data[$iLV_Index][9] = 1
	EndIf

	; If header editable on Ctrl-click set flag
	If BitAND($iAdded, 8) Then
		$aGLVEx_Data[$iLV_Index][8] = 1
	EndIf

	; Create default header data array
	Local $iCols = _GUICtrlListView_GetColumnCount($hLV)
	Local $aHdrData[4][$iCols], $aRet
	; If user coloured headers
	If BitAND($iAdded, 16) Then
		; Get header handle to act as flag
		Local $hHeader = _GUICtrlListView_GetHeader($hLV)
		$aGLVEx_Data[$iLV_Index][24] = $hHeader
		; Read in current header titles
		For $i = 0 To $iCols - 1
			$aRet = _GUICtrlListView_GetColumn($hLV, $i)
			$aHdrData[0][$i] = $aRet[5]
		Next
	EndIf
	; Store array
	$aGLVEx_Data[$iLV_Index][25] = $aHdrData

	; Load default colours
	$aGLVEx_Data[$iLV_Index][23] = $aGLVEx_DefColours
	; If user coloured items
	If BitAND($iAdded, 32) Then
		Local $aColArray = $aGLVEx_Data[$iLV_Index][2]
		For $i = 1 To UBound($aColArray, 1) - 1
			For $j = 0 To UBound($aColArray, 2) - 1
				$aColArray[$i][$j] = ";"
			Next
		Next
		$aGLVEx_Data[$iLV_Index][18] = $aColArray
		; Set user colour flag
		$aGLVEx_Data[$iLV_Index][19] = 1
	EndIf

	; If no external drag
	If BitAND($iAdded, 64) Then
		$aGLVEx_Data[$iLV_Index][12] = 1
	EndIf

	; If no external drop
	If BitAND($iAdded, 128) Then
		$aGLVEx_Data[$iLV_Index][12] += 2
	EndIf

	; If no delete on external drag/drop
	If BitAND($iAdded, 256) Then
		$aGLVEx_Data[$iLV_Index][12] += 4
	EndIf

	; If no drag/drop
	If BitAND($iAdded, 512) Then
		$aGLVEx_Data[$iLV_Index][12] += 8 + 2     ; Force no external drop
	EndIf

	; If single cell selection
	If BitAND($iAdded, 1024) Then
		; Force single selection style
		Local $iStyle = _WinAPI_GetWindowLong($aGLVEx_Data[$iLV_Index][0], $GWL_STYLE)
		_WinAPI_SetWindowLong($aGLVEx_Data[$iLV_Index][0], $GWL_STYLE, BitOR($iStyle, $LVS_SINGLESEL))
		; Set flag
		$aGLVEx_Data[$iLV_Index][22] = 1
		; Load default colours
		$aGLVEx_Data[$iLV_Index][23] = $aGLVEx_DefColours
	EndIf

	;  If checkbox extended style
	If BitAND(_GUICtrlListView_GetExtendedListViewStyle($hLV), 4) Then     ; $LVS_EX_CHECKBOXES
		$aGLVEx_Data[$iLV_Index][6] = 1
	EndIf

	;  If header drag extended style
	If BitAND(_GUICtrlListView_GetExtendedListViewStyle($hLV), 0x00000010) Then     ; $LVS_EX_HEADERDRAGDROP
		$aGLVEx_Data[$iLV_Index][13] = 1
	EndIf

	; Measure item depth for scroll - if empty reset when filled later
	Local $aRect = _GUICtrlListView_GetItemRect($aGLVEx_Data[$iLV_Index][0], 0)
	$aGLVEx_Data[$iLV_Index][10] = $aRect[3] - $aRect[1]

	; If only 1 current ListView then activate
	Local $iListView_Count = 0
	For $i = 1 To $iLV_Index
		If $aGLVEx_Data[$i][0] Then $iListView_Count += 1
	Next
	If $iListView_Count = 1 Then _GUIListViewEx_SetActive($iLV_Index)

	; Return ListView index
	Return $iLV_Index

EndFunc   ;==>_GUIListViewEx_Init

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Close
; Description ...: Disables all UDF functions for the specified ListView and clears all memory used
; Syntax.........: _GUIListViewEx_Close($iLV_Index)
; Parameters ....: $iLV_Index - Index number of ListView to close as returned by _GUIListViewEx_Init
;                            0 (default) = Closes all ListViews
; Requirement(s).: v3.3.10 +
; Return values .: Success: 1
;                  Failure: 0 and @error set to 1 - Invalid index number
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Close($iLV_Index = 0)

	Local $iEditKeyCode

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, 0)

	If $iLV_Index = 0 Then
		; Reinitialise data array - retaining selected edit key
		$iEditKeyCode = $aGLVEx_Data[0][23]
		Global $aGLVEx_Data[1][UBound($aGLVEx_Data, 2)] = [[0, 0, -1, "", -1, -1, -1, -1, _WinAPI_GetSystemMetrics(2), False, _
				 -1, -1, False, "", 0, True, 0, -1, -1, 0, 0, 0, 0, $iEditKeyCode]]
		; Note delimiter character reset when ListView next initialised
	Else
		; Reset all data for ListView
		For $i = 0 To UBound($aGLVEx_Data, 2) - 1
			$aGLVEx_Data[$iLV_Index][$i] = 0
		Next

		; Cancel active index if set to this ListView
		If $aGLVEx_Data[0][1] = $iLV_Index Then
			$aGLVEx_Data[0][1] = 0
		EndIf

	EndIf

	Return 1

EndFunc   ;==>_GUIListViewEx_Close

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_SetActive
; Description ...: Set specified ListView as active for non-specific UDF functions
; Syntax.........: _GUIListViewEx_SetActive($iLV_Index)
; Parameters ....: $iLV_Index - Index number of ListView as returned by _GUIListViewEx_Init
;                  An index of 0 clears any current setting
; Requirement(s).: v3.3.10 +
; Return values .: Success: Returns previous active index number, 0 = no previously active ListView
;                  Failure: -1 and @error set to 1 - Invalid index number
; Author ........: Melba23
; Modified ......:
; Remarks .......: ListViews can also be activated by clicking on them
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_SetActive($iLV_Index)

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, -1)

	Local $iCurr_Index = $aGLVEx_Data[0][1]

	If $iLV_Index Then
		; Store index of specified ListView
		$aGLVEx_Data[0][1] = $iLV_Index
		; Set values for specified ListView
		$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
		$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]
	Else
		; Clear active index
		$aGLVEx_Data[0][1] = 0
		$hGLVEx_SrcHandle = 0
		$cGLVEx_SrcID = 0
	EndIf

	Return $iCurr_Index

EndFunc   ;==>_GUIListViewEx_SetActive

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_GetActive
; Description ...: Get index number of ListView active for non-specific UDF functions
; Syntax.........: _GUIListViewEx_GetActive()
; Parameters ....: None
; Requirement(s).: v3.3.10 +
; Return values .: Success: Index number as returned by _GUIListViewEx_Init, 0 = no active ListView
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_GetActive()

	Return $aGLVEx_Data[0][1]

EndFunc   ;==>_GUIListViewEx_GetActive

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_ReadToArray
; Description ...: Creates an array from the current ListView content to be loaded in _Init function
; Syntax.........: _GUIListViewEx_ReadToArray($hLV[, $iCount = 0])
; Parameters ....: $hLV    - ControlID or handle of ListView
;                  $iCount - 0 (default) = ListView data starts in [0] element of array, 1 = Count in [0] element
; Requirement(s).: v3.3.10 +
; Return values .: Success: 2D array of current ListView content
;                           Empty string if ListView empty and no count element
;                  Failure: Returns null string and sets @error as follows:
;                           1 = Invalid ListView ControlID or handle
; Author ........: Melba23
; Modified ......:
; Remarks .......: - Note that this function requires the handle/ControlID of the ListView, not the UDF index
;                  - If returned array is used in _GUIListViewEx_Init the $iStart parameters must match in the 2 functions
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_ReadToArray($hLV, $iStart = 0)

	Local $aLVArray = "", $aRow

	; Use the ListView handle
	If Not IsHWnd($hLV) Then
		$hLV = GUICtrlGetHandle($hLV)
		If Not IsHWnd($hLV) Then
			Return SetError(1, 0, "")
		EndIf
	EndIf
	; Get ListView row count
	Local $iRows = _GUICtrlListView_GetItemCount($hLV)
	; Get ListView column count
	Local $iCols = _GUICtrlListView_GetColumnCount($hLV)
	; Check for empty ListView with no count
	If ($iRows + $iStart <> 0) And $iCols <> 0 Then
		; Create 2D array to hold ListView content and add count - count overwritten if not needed
		Local $aLVArray[$iRows + $iStart][$iCols] = [[$iRows]]
		; Read ListView content into array
		For $i = 0 To $iRows - 1
			; Read the row content
			$aRow = _GUICtrlListView_GetItemTextArray($hLV, $i)
			For $j = 1 To $aRow[0]
				; Add to the ListView content array
				$aLVArray[$i + $iStart][$j - 1] = $aRow[$j]
			Next
		Next
	Else
		Local $aLVArray[1][1] = [[0]]
	EndIf
	; Return array or empty string
	Return $aLVArray

EndFunc   ;==>_GUIListViewEx_ReadToArray

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_ReturnArray
; Description ...: Returns an array reflecting the current content of an activated ListView
; Syntax.........: _GUIListViewEx_ReturnArray($iLV_Index[, $iMode])
; Parameters ....: $iLV_Index - Index number of ListView as returned by _GUIListViewEx_Init
;                  $iMode  - 0 = Content of ListView
;                            1 - State of the checkboxes
;                            2 - User colours (if initialised)
;                            3 - Content of ListView forced to 2D for saving
;                            4 - ListView header titles
;                            5 - Header colours (if initialised)
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of current ListView content - _GUIListViewEx_Init parameters determine:
;                               For modes 0/1:
;                                   Count in [0]/[0][0] element if $iStart = 1 when intialised
;                                   1D/2D array type - as array used to initialise
;                                   If no array passed then single col => 1D; multiple column => 2D
;                               For mode 2/3
;                                   Always 0-based 2D array
;                               For mode 4/5
;                                   Always 0-based 1D array
;                  Failure: Returns empty string and sets @error as follows:
;                               1 = Invalid index number
;                               2 = Empty array (no items in ListView)
;                               3 = $iMode set to 1 but no checkbox style
;                               4 = $iMode set to 2 but user colours not initialised
;                               5 = $iMode set to 5 but header colours not initialised
;                               6 = Invalid $iMode
; Author ........: Melba23
; Modified ......:
; Remarks .......: Colours returned as "text;back" - empty values use default colours
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_ReturnArray($iLV_Index, $iMode = 0)

	; Check valid index
	If $iLV_Index < 1 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, "")
	; Get ListView handle
	Local $hLV = $aGLVEx_Data[$iLV_Index][0]
	; Get column order
	Local $aColOrder = StringSplit(_GUICtrlListView_GetColumnOrder($hLV), $aGLVEx_Data[0][24])
	; Extract array and get size
	Local $aData_Colour = $aGLVEx_Data[$iLV_Index][2]
	Local $iDim_1 = UBound($aData_Colour, 1), $iDim_2 = UBound($aData_Colour, 2)
	Local $aCheck[$iDim_1], $aHeader[$iDim_2], $aHdrData

	; Adjust array depending on mode required
	Switch $iMode
		Case 0, 3     ; Content
			; Array already filled

		Case 1     ; Checkbox state
			If $aGLVEx_Data[$iLV_Index][6] Then
				For $i = 1 To $iDim_1 - 1
					$aCheck[$i] = _GUICtrlListView_GetItemChecked($hLV, $i - 1)
				Next
				; Remove count element if required
				If BitAND($aGLVEx_Data[$iLV_Index][3], 1) = 0 Then
					; Delete count element
					__GUIListViewEx_Array_Delete($aCheck, 0)
				EndIf
				Return $aCheck
			Else
				Return SetError(3, 0, "")
			EndIf

		Case 2     ; Colour values
			If $aGLVEx_Data[$iLV_Index][19] Then
				; Load colour array
				$aData_Colour = $aGLVEx_Data[$iLV_Index][18]
				; Convert to RGB
				For $i = 0 To UBound($aData_Colour, 1) - 1
					For $j = 0 To UBound($aData_Colour, 2) - 1
						$aData_Colour[$i][$j] = StringRegExpReplace($aData_Colour[$i][$j], "0x(.{2})(.{2})(.{2})", "0x$3$2$1")
					Next
				Next
				$aData_Colour[0][0] = $iDim_1 - 1
			Else
				Return SetError(4, 0, "")
			EndIf

		Case 4     ; Headers
			If $aGLVEx_Data[$iLV_Index][24] Then
				; Header colour enabled, so read from header data
				$aHdrData = $aGLVEx_Data[$iLV_Index][25]
				For $i = 0 To $iDim_2 - 1
					$aHeader[$i] = $aHdrData[0][$i]
				Next
			Else
				; Read normal headers
				Local $aRet
				For $i = 0 To $iDim_2 - 1
					$aRet = _GUICtrlListView_GetColumn($hLV, $i)
					$aHeader[$i] = $aRet[5]
				Next
			EndIf

		Case 5     ; Header colours
			If $aGLVEx_Data[$iLV_Index][24] Then
				; Header colour enabled, so read from header data
				$aHdrData = $aGLVEx_Data[$iLV_Index][25]
				For $i = 0 To $iDim_2 - 1
					$aHeader[$i] = $aHdrData[1][$i]
				Next
			Else
				Return SetError(5, 0, "")
			EndIf

		Case Else
			Return SetError(6, 0, "")
	EndSwitch

	; Check if columns can be reordered
	If $aGLVEx_Data[$iLV_Index][13] Then
		Switch $iMode
			Case 0, 2, 3     ; 2D data/colour array
				; Create temp array
				Local $aData_Colour_Ordered[$iDim_1][$iDim_2]
				; Fill temp array in correct column order
				$aData_Colour_Ordered[0][0] = $aData_Colour[0][0]
				For $i = 1 To $iDim_1 - 1
					For $j = 0 To $iDim_2 - 1
						$aData_Colour_Ordered[$i][$j] = $aData_Colour[$i][$aColOrder[$j + 1]]
					Next
				Next
				; Reset main and delete temp
				$aData_Colour = $aData_Colour_Ordered
				$aData_Colour_Ordered = ""

			Case 4, 5     ; 1D header array
				; Create return array
				Local $aHeader_Ordered[$iDim_2]
				; Fill return array in correct column order
				For $i = 0 To $iDim_2 - 1
					$aHeader_Ordered[$i] = $aHeader[$aColOrder[$i + 1]]
				Next
				; Return reordered array
				Return $aHeader_Ordered
		EndSwitch
	Else
		; No reordering
		If $iMode = 4 Then
			; Return header array
			Return $aHeader
		EndIf
	EndIf

	; Remove count element of array if required - always for colour return
	Local $iCount = 1
	If BitAND($aGLVEx_Data[$iLV_Index][3], 1) = 0 Or $iMode = 2 Then
		$iCount = 0
		; Delete count element
		__GUIListViewEx_Array_Delete($aData_Colour, 0, True)
	EndIf

	; Now check if 1D array to be returned - always 2D for colour return and forced content
	If BitAND($aGLVEx_Data[$iLV_Index][3], 2) = 0 And $iMode < 2 Then
		If UBound($aData_Colour, 1) = 0 Then
			Local $aData_Colour[0]
		Else
			; Get number of 2D elements
			Local $iCols = UBound($aData_Colour, 2)
			; Create 1D array - count will be overwritten if not needed
			Local $aData_Colour_1D[UBound($aData_Colour)] = [$aData_Colour[0][0]]
			; Fill with concatenated lines
			For $i = $iCount To UBound($aData_Colour_1D) - 1
				Local $aLine = ""
				For $j = 0 To $iCols - 1
					$aLine &= $aData_Colour[$i][$j] & $aGLVEx_Data[0][24]
				Next
				$aData_Colour_1D[$i] = StringTrimRight($aLine, 1)
			Next
			; Reset array
			$aData_Colour = $aData_Colour_1D
		EndIf
	EndIf

	; Return array
	Return $aData_Colour

EndFunc   ;==>_GUIListViewEx_ReturnArray

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_SaveListView
; Description ...: Saves ListView header data, ListView content, checkbox state and colour data to file
; Syntax.........: _GUIListViewEx_SaveListView($iLV_Index, $sFileName)
; Parameters ....: $iLV_Index    - Index number of ListView as returned by _GUIListViewEx_Init
;                  $sFileName - File in which to save data
; Requirement(s).: v3.3.10 +
; Return values .: Success: 1
;                  Failure: 0 and sets @error as follows:
;                               1 = Invalid index number
;                               2 = File not written - @extended set:
;                                   1 = File not opened
;                                   2 = Data not written
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_SaveListView($iLV_Index, $sFileName)

	; Check valid index
	If $iLV_Index < 1 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, 0)

	; Get ListView parameters
	Local $hLV_Handle = $aGLVEx_Data[$iLV_Index][0]
	Local $iStart = BitAND($aGLVEx_Data[$iLV_Index][3], 1)

	; Get header data
	Local $sHeader = "", $aRet
	If $aGLVEx_Data[$iLV_Index][24] Then
		; Header colour enabled, so also read from header data
		Local $aHdrData = $aGLVEx_Data[$iLV_Index][25]
		; Create string
		For $i = 0 To _GUICtrlListView_GetColumnCount($hLV_Handle) - 1
			$aRet = _GUICtrlListView_GetColumn($hLV_Handle, $i)
			$sHeader &= $aHdrData[0][$i] & @CR & $aRet[4] & @CR & $aHdrData[1][$i] & @CR & $aHdrData[2][$i] & @CR & $aHdrData[3][$i] & @LF
		Next
	Else
		; Read normal headers and add blank unused elements
		For $i = 0 To _GUICtrlListView_GetColumnCount($hLV_Handle) - 1
			$aRet = _GUICtrlListView_GetColumn($hLV_Handle, $i)
			$sHeader &= $aRet[5] & @CR & $aRet[4] & @CR & @CR & @CR & @LF
		Next
	EndIf
	$sHeader = StringTrimRight($sHeader, 1)
	; Get data/check/colour content
	Local $aData = _GUIListViewEx_ReturnArray($iLV_Index, 3)     ; Force 2D return
	If $iStart Then
		_ArrayDelete($aData, 0)
	EndIf
	Local $aCheck = _GUIListViewEx_ReturnArray($iLV_Index, 1)
	If $iStart Then
		_ArrayDelete($aCheck, 0)
	EndIf
	Local $aColour = _GUIListViewEx_ReturnArray($iLV_Index, 2)

	; Get edit data
	Local $aEditable = $aGLVEx_Data[$iLV_Index][7]

	; Get sort data
	Local $aSortable = $aGLVEx_Data[$iLV_Index][4]

	; Convert to strings
	Local $sData = "", $sCheck = "", $sColour = "", $sEditable = "", $sSortable = ""
	If IsArray($aData) Then
		$sData = __GUIListViewEx_MakeString($aData)
	EndIf
	If IsArray($aCheck) Then
		$sCheck = __GUIListViewEx_MakeString($aCheck)
	EndIf
	If IsArray($aColour) Then
		$sColour = __GUIListViewEx_MakeString($aColour)
	EndIf
	If IsArray($aEditable) Then
		$sEditable = __GUIListViewEx_MakeString($aEditable)
	EndIf
	If IsArray($aSortable) Then
		$sSortable = __GUIListViewEx_MakeString($aSortable)
	EndIf

	; Write data to file
	Local $iError = 0
	Local $hFile = FileOpen($sFileName, $FO_OVERWRITE)
	If @error Then
		$iError = 1
	Else
		FileWrite($hFile, $sHeader & ChrW(0xEF0F) & $sData & ChrW(0xEF0F) & $sCheck & ChrW(0xEF0F) & $sColour & ChrW(0xEF0F) & $sEditable & ChrW(0xEF0F) & $sSortable)
		If @error Then
			$iError = 2
		EndIf
	EndIf
	FileClose($hFile)

	If $iError Then Return SetError(2, $iError, 0)

	Return 1

EndFunc   ;==>_GUIListViewEx_SaveListView

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_LoadListView
; Description ...: Loads ListView header data, ListView content, checkbox state and colour data from file
; Syntax.........: _GUIListViewEx_LoadListView($iLV_Index, $sFileName[, $iDims = 2])
; Parameters ....: $iLV_Index    - Index number of ListView as returned by _GUIListViewEx_Init
;                  $sFileName - File from which to load data
;                  $iDims     - Force 1/2D return array - normally set by initialising array
; Requirement(s).: v3.3.10 +
; Return values .: Success: 1
;                  Failure: 0 and sets @error as follows:
;                               1 = Invalid index number
;                               2 = Invalid $iDims parameter
;                               3 = File not read
;                               4 = No data to load
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_LoadListView($iLV_Index, $sFileName, $iDims = 2)

	; Check valid index
	If $iLV_Index < 1 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, 0)
	; Check valid $iDims parameter
	Switch $iDims
		Case 1, 2
			; OK
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch

	; Get ListView parameters
	Local $hLV_Handle = $aGLVEx_Data[$iLV_Index][0]
	Local $cLV_CID = $aGLVEx_Data[$iLV_Index][1]
	Local $iStart = BitAND($aGLVEx_Data[$iLV_Index][3], 1)

	; Read content
	Local $sContent = FileRead($sFileName)
	If @error Then Return SetError(3, 0, 0)

	; Split into separate sections
	Local $aSplit = StringSplit($sContent, ChrW(0xEF0F), $STR_ENTIRESPLIT)

	; Check there is data to load
	If $aSplit[1] = "" Then Return SetError(4, 0, 0)

	; Convert to arrays
	Local $aHeader = __GUIListViewEx_MakeArray($aSplit[1])
	Local $aData = __GUIListViewEx_MakeArray($aSplit[2])
	Local $aCheck = __GUIListViewEx_MakeArray($aSplit[3])
	Local $aColour = __GUIListViewEx_MakeArray($aSplit[4])
	Local $aEditable = __GUIListViewEx_MakeArray($aSplit[5])
	Local $aSortable = __GUIListViewEx_MakeArray($aSplit[6])

	; If required, convert data and colour arrays into 2D for load
	If UBound($aData, 0) = 1 Then
		Local $aTempData[UBound($aData)][1]
		Local $aTempCol[UBound($aData)][1]
		For $i = 0 To UBound($aData) - 1
			$aTempData[$i][0] = $aData[$i]
			$aTempCol[$i][0] = $aColour[$i]
		Next
		$aData = $aTempData
		$aColour = $aTempCol
	EndIf

	; Reset header data if required
	If $aGLVEx_Data[$iLV_Index][24] Then
		; Create and fill header data array
		Local $aHdrData[4][UBound($aHeader, 2)]
		For $i = 0 To UBound($aHeader) - 1
			$aHdrData[0][$i] = $aHeader[$i][0]
			$aHdrData[1][$i] = $aHeader[$i][2]
			$aHdrData[2][$i] = $aHeader[$i][3]
			$aHdrData[3][$i] = $aHeader[$i][4]
		Next
		; Store array
		$aGLVEx_Data[$iLV_Index][25] = $aHdrData
	EndIf

	; Set no colour redraw flag and prevent any normal redraw
	$aGLVEx_Data[0][12] = 1
	$aGLVEx_Data[0][15] = False
	_GUICtrlListView_BeginUpdate($hLV_Handle)

	; Clear current content of ListView
	_GUICtrlListView_DeleteAllItems($hLV_Handle)

	; Check correct number of columns
	Local $iCol_Count = _GUICtrlListView_GetColumnCount($hLV_Handle)
	If $iCol_Count < UBound($aHeader) Then
		; Add columns
		For $i = $iCol_Count To UBound($aHeader) - 1
			_GUICtrlListView_AddColumn($hLV_Handle, "", 100)
		Next
	EndIf
	If $iCol_Count > UBound($aHeader) Then
		; Delete columns
		For $i = $iCol_Count To UBound($aHeader) Step -1
			_GUICtrlListView_DeleteColumn($hLV_Handle, $i)
		Next
	EndIf

	; Reset header titles and widths
	For $i = 0 To UBound($aHeader) - 1
		_GUICtrlListView_SetColumn($hLV_Handle, $i, $aHeader[$i][0], $aHeader[$i][1])
	Next

	; Load ListView content
	If $cLV_CID Then
		; Native ListView
		Local $sLine, $iLastCol = UBound($aData, 2) - 1
		For $i = 0 To UBound($aData) - 1
			$sLine = ""
			For $j = 0 To $iLastCol
				$sLine &= $aData[$i][$j] & "|"
			Next
			GUICtrlCreateListViewItem(StringTrimRight($sLine, 1), $cLV_CID)
		Next
	Else
		; UDF ListView
		_GUICtrlListView_AddArray($hLV_Handle, $aData)
	EndIf

	_GUICtrlListView_EndUpdate($hLV_Handle)

	; Add required count row to shadow array
	_ArrayInsert($aData, 0, UBound($aData))
	; Store content array
	$aGLVEx_Data[$iLV_Index][2] = $aData
	; Store editable array
	$aGLVEx_Data[$iLV_Index][7] = $aEditable
	; Store sortable array
	$aGLVEx_Data[$iLV_Index][4] = $aSortable

	; Set 1/2D return flag as required
	$aGLVEx_Data[$iLV_Index][3] = $iStart + (($iDims = 2) ? (2) : (0))

	; Reset checkboxes if required
	If IsArray($aCheck) Then
		; Reset checkboxes
		For $i = 0 To UBound($aCheck) - 1
			If $aCheck[$i] = "True" Then
				_GUICtrlListView_SetItemChecked($hLV_Handle, $i, True)
			EndIf
		Next
	EndIf

	; Clear no colour redraw flag and allow normal redraw
	$aGLVEx_Data[0][12] = 0
	$aGLVEx_Data[0][15] = True

	; Reset data colours if required
	If $aGLVEx_Data[$iLV_Index][19] Then
		If IsArray($aColour) Then
			; Load colour
			_GUIListViewEx_LoadColour($iLV_Index, $aColour)
		Else
			; Create empty array
			$aColour = $aData
			For $i = 0 To UBound($aData) - 1
				For $j = 0 To UBound($aData, 2) - 1
					$aColour[$i][$j] = ";"
				Next
			Next
			$aGLVEx_Data[$iLV_Index][18] = $aColour
		EndIf
	EndIf

	; Redraw ListView
	__GUIListViewEx_RedrawWindow($iLV_Index)

	; Set active
	$aGLVEx_Data[0][1] = $iLV_Index

	Return 1

EndFunc   ;==>_GUIListViewEx_LoadListView

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Up
; Description ...: Moves selected item(s) in active ListView up 1 row
; Syntax.........: _GUIListViewEx_Up()
; Parameters ....: None
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of active ListView with count in [0] element
;                  Failure: Returns "" and sets @error as follows:
;                      1 = No ListView active
;                      2 = No item selected
;                      3 = Item already at top
; Author ........: Melba23
; Modified ......:
; Remarks .......: If multiple items are selected, only the top consecutive block is moved
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Up()

	Local $iGLVExMove_Index, $iGLVEx_Moving = 0

	; Set data for active ListView
	Local $iLV_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iLV_Index = 0 Then Return SetError(1, 0, 0)

	; Load active ListView details
	$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
	$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]
	Local $fCheckBox = $aGLVEx_Data[$iLV_Index][6]

	; Copy array for manipulation
	$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
	$aGLVEx_SrcColArray = $aGLVEx_Data[$iLV_Index][18]

	; Create Local array for checkboxes (if no checkboxes makes no difference)
	Local $aCheck_Array[UBound($aGLVEx_SrcArray)]
	For $i = 1 To UBound($aCheck_Array) - 1
		$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $i - 1)
	Next

	; Check for selected items
	Local $iIndex
	; Check if colour single cell selection enabled
	If $aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22] Then
		; Use stored value
		$iIndex = $aGLVEx_Data[$iLV_Index][20]
	Else
		; Check actual values
		$iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_SrcHandle)
	EndIf
	If $iIndex == "" Then
		Return SetError(2, 0, "")
	EndIf
	Local $aIndex = StringSplit($iIndex, "|")
	$iGLVExMove_Index = $aIndex[1]
	; Check if item is part of a multiple selection
	If $aIndex[0] > 1 Then
		; Check for consecutive items
		For $i = 1 To $aIndex[0] - 1
			If $aIndex[$i + 1] = $aIndex[1] + $i Then
				$iGLVEx_Moving += 1
			Else
				ExitLoop
			EndIf
		Next
	Else
		$iGLVExMove_Index = $aIndex[1]
	EndIf

	; Check not top item
	If $iGLVExMove_Index < 1 Then
		__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, 0)
		Return SetError(3, 0, "")
	EndIf

	; Remove all highlighting
	_GUICtrlListView_SetItemSelected($hGLVEx_SrcHandle, -1, False)

	; Set no redraw flag - prevents problems while colour arrays are updated
	$aGLVEx_Data[0][12] = True

	; Move consecutive items
	For $iIndex = $iGLVExMove_Index To $iGLVExMove_Index + $iGLVEx_Moving
		; Swap array elements
		__GUIListViewEx_Array_Swap($aGLVEx_SrcArray, $iIndex, $iIndex + 1)
		__GUIListViewEx_Array_Swap($aCheck_Array, $iIndex, $iIndex + 1)
		__GUIListViewEx_Array_Swap($aGLVEx_SrcColArray, $iIndex, $iIndex + 1)
	Next

	; Amend stored row
	$aGLVEx_Data[$iLV_Index][20] -= 1

	; Rewrite ListView
	__GUIListViewEx_ReWriteLV($hGLVEx_SrcHandle, $aGLVEx_SrcArray, $aCheck_Array, $iLV_Index, $fCheckBox)

	; Set highlight
	For $i = 0 To $iGLVEx_Moving
		__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, $iGLVExMove_Index + $i - 1)
	Next

	; Store amended array
	$aGLVEx_Data[$iLV_Index][2] = $aGLVEx_SrcArray
	$aGLVEx_Data[$iLV_Index][18] = $aGLVEx_SrcColArray
	; Delete copied array
	$aGLVEx_SrcArray = 0
	$aGLVEx_SrcColArray = 0

	; Clear no redraw flag
	$aGLVEx_Data[0][12] = False

	; If colour used or single cell selection
	__GUIListViewEx_RedrawWindow($iLV_Index)

	; Return amended array
	Return _GUIListViewEx_ReturnArray($iLV_Index)

EndFunc   ;==>_GUIListViewEx_Up

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Down
; Description ...: Moves selected item(s) in active ListView down 1 row
; Syntax.........: _GUIListViewEx_Down()
; Parameters ....: None
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of active ListView with count in [0] element
;                  Failure: Returns "" and sets @error as follows:
;                      1 = No ListView active
;                      2 = No item selected
;                      3 = Item already at bottom
; Author ........: Melba23
; Modified ......:
; Remarks .......: If multiple items are selected, only the bottom consecutive block is moved
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Down()

	Local $iGLVExMove_Index, $iGLVEx_Moving = 0

	; Set data for active ListView
	Local $iLV_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iLV_Index = 0 Then Return SetError(1, 0, 0)

	; Load active ListView details
	$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
	$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]
	Local $fCheckBox = $aGLVEx_Data[$iLV_Index][6]

	; Copy array for manipulation
	$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
	$aGLVEx_SrcColArray = $aGLVEx_Data[$iLV_Index][18]

	; Create Local array for checkboxes (if no checkboxes makes no difference)
	Local $aCheck_Array[UBound($aGLVEx_SrcArray)]
	For $i = 1 To UBound($aCheck_Array) - 1
		$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $i - 1)
	Next

	; Check for selected items
	Local $iIndex
	; Check if colour or single cell selection enabled
	If $aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22] Then
		; Use stored value
		$iIndex = $aGLVEx_Data[$iLV_Index][20]
	Else
		; Check actual values
		$iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_SrcHandle)
	EndIf
	If $iIndex == "" Then
		Return SetError(2, 0, "")
	EndIf
	Local $aIndex = StringSplit($iIndex, "|")
	; Check if item is part of a multiple selection
	If $aIndex[0] > 1 Then
		$iGLVExMove_Index = $aIndex[$aIndex[0]]
		; Check for consecutive items
		For $i = 1 To $aIndex[0] - 1
			If $aIndex[$aIndex[0] - $i] = $aIndex[$aIndex[0]] - $i Then
				$iGLVEx_Moving += 1
			Else
				ExitLoop
			EndIf
		Next
	Else
		$iGLVExMove_Index = $aIndex[1]
	EndIf

	; Remove all highlighting
	_GUICtrlListView_SetItemSelected($hGLVEx_SrcHandle, -1, False)

	; Check not last item
	If $iGLVExMove_Index = _GUICtrlListView_GetItemCount($hGLVEx_SrcHandle) - 1 Then
		__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, $iIndex)
		Return SetError(3, 0, "")
	EndIf

	; Set no redraw flag - prevents problems while colour arrays are updated
	$aGLVEx_Data[0][12] = True

	; Move consecutive items
	For $iIndex = $iGLVExMove_Index To $iGLVExMove_Index - $iGLVEx_Moving Step -1
		; Swap array elements
		__GUIListViewEx_Array_Swap($aGLVEx_SrcArray, $iIndex + 1, $iIndex + 2)
		__GUIListViewEx_Array_Swap($aCheck_Array, $iIndex + 1, $iIndex + 2)
		__GUIListViewEx_Array_Swap($aGLVEx_SrcColArray, $iIndex + 1, $iIndex + 2)
	Next

	; Amend stored row
	$aGLVEx_Data[$iLV_Index][20] += 1

	; Rewrite ListView
	__GUIListViewEx_ReWriteLV($hGLVEx_SrcHandle, $aGLVEx_SrcArray, $aCheck_Array, $iLV_Index, $fCheckBox)

	; Set highlight
	For $i = 0 To $iGLVEx_Moving
		__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, $iGLVExMove_Index - $iGLVEx_Moving + $i + 1)
	Next

	; Store amended array
	$aGLVEx_Data[$iLV_Index][2] = $aGLVEx_SrcArray
	$aGLVEx_Data[$iLV_Index][18] = $aGLVEx_SrcColArray
	; Delete copied array
	$aGLVEx_SrcArray = 0
	$aGLVEx_SrcColArray = 0

	; Clear no redraw flag
	$aGLVEx_Data[0][12] = False

	; If colour used or single cell selection
	__GUIListViewEx_RedrawWindow($iLV_Index)

	; Return amended array
	Return _GUIListViewEx_ReturnArray($iLV_Index)

EndFunc   ;==>_GUIListViewEx_Down

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Insert
; Description ...: Inserts data just below selected item in active ListView - if no selection, data added at end
; Syntax.........: _GUIListViewEx_Insert($vData[, $fMultiRow = False[, $fRetainWidth = False]])
; Parameters ....: $vData        - Data to insert, can be in array or delimited string format
;                  $fMultiRow    - (Optional) If $vData is a 1D array:
;                                     - False (default) - elements added as subitems to a single row
;                                     - True - elements added as rows containing a single item
;                                  Ignored if $vData is a single item or a 2D array
;                  $fRetainWidth - (Optional) True  = native ListView column width is retained on insert
;                                  False = native ListView columns expand to fit data (default)
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of current ListView content with count in [0] element
;                  Failure: If no ListView active then returns "" and sets @error to 1
; Author ........: Melba23
; Modified ......:
; Remarks .......: - New data is inserted after the selected item.  If no item is selected then the data is added at
;                  the end of the ListView.  If multiple items are selected, the data is inserted after the first
;                  - $vData can be passed in string or array format - it is automatically transformed if required
;                  - $vData as single item - item added to all columns
;                  - $vData as 1D array - see $fMultiRow above
;                  - $vData as 2D array - added as rows/columns
;                  - Native ListViews automatically expand subitem columns to fit inserted data.  Setting the
;                  $fRetainWidth parameter resets the original width after insertion
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Insert($vData, $fMultiRow = False, $fRetainWidth = False)

	;Local $vInsert

	; Set data for active ListView
	Local $iLV_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iLV_Index = 0 Then Return SetError(1, 0, "")

	; Check for selected items
	Local $iIndex
	; Check if colour or single cell selection enabled
	If $aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22] Then
		; Use stored value
		$iIndex = $aGLVEx_Data[$iLV_Index][20]
	Else
		; Check actual values
		$iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_SrcHandle)
	EndIf
	Local $iInsert_Index = $iIndex
	; If no selection
	If $iIndex == "" Then $iInsert_Index = -1

	; Check for multiple selections
	If StringInStr($iIndex, "|") Then
		Local $aIndex = StringSplit($iIndex, "|")
		; Use first selection
		$iIndex = $aIndex[1]
		; Cancel all other selections
		For $i = 2 To $aIndex[0]
			_GUICtrlListView_SetItemSelected($hGLVEx_SrcHandle, $aIndex[$i], False)
		Next
	EndIf

	Local $vRet = _GUIListViewEx_InsertSpec($iLV_Index, $iInsert_Index + 1, $vData, $fMultiRow, $fRetainWidth)

	Return SetError(@error, 0, $vRet)

EndFunc   ;==>_GUIListViewEx_Insert

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_InsertSpec
; Description ...: Inserts data in specified row in specified ListView
; Syntax.........: _GUIListViewEx_InsertSpec($iLV_Index, $iRow, $vData[, $fMultiRow = False[, $fRetainWidth = False]])
; Parameters ....: $iLV_Index    - Index of ListView as returned by _GUIListViewEx_Init
;                  $iRow         - Row which will be inserted - setting -1 adds at end
;                  $vData        - Data to insert, can be in array or delimited string format
;                  $fMultiRow    - (Optional) If $vData is a 1D array:
;                                     - False (default) - elements added as subitems to a single row
;                                     - True - elements added as rows containing a single item
;                                  Ignored if $vData is a single item or a 2D array
;                  $fRetainWidth - (Optional) True  = native ListView column width is retained on insert
;                                  False = native ListView columns expand to fit data (default)
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of specified ListView content with count in [0] element
;                  Failure: Returns "" and sets @error to 1
; Author ........: Melba23
; Modified ......:
; Remarks .......: - New data is inserted after the specified row.
;                  - $vData can be passed in string or array format - it is automatically transformed if required
;                  - $vData as single item - item added to all columns
;                  - $vData as 1D array - see $fMultiRow above
;                  - $vData as 2D array - added as rows/columns
;                  - Native ListViews automatically expand subitem columns to fit inserted data.  Setting the
;                  - $fRetainWidth parameter resets the original width after insertion
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_InsertSpec($iLV_Index, $iRow, $vData, $fMultiRow = False, $fRetainWidth = False)

	Local $vInsert

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, "")

	; Load active ListView details
	$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
	$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]
	Local $fCheckBox = $aGLVEx_Data[$iLV_Index][6]

	; Copy array for manipulation
	$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
	$aGLVEx_SrcColArray = $aGLVEx_Data[$iLV_Index][18]

	; Create Local array for checkboxes (if no checkboxes makes no difference)
	Local $aCheck_Array[UBound($aGLVEx_SrcArray)]
	For $i = 1 To UBound($aCheck_Array) - 1
		$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $i - 1)
	Next

	; If empty array insert at 0
	If $aGLVEx_SrcArray[0][0] = 0 Then $iRow = 0
	; Get data into array format for insert
	If IsArray($vData) Then
		$vInsert = $vData
	Else
		Local $aData = StringSplit($vData, $aGLVEx_Data[0][24])
		Switch $aData[0]
			Case 1
				$vInsert = $aData[1]
			Case Else
				Local $vInsert[$aData[0]]
				For $i = 0 To $aData[0] - 1
					$vInsert[$i] = $aData[$i + 1]
				Next
		EndSwitch
	EndIf

	; Set no redraw flag - prevents problems while colour arrays are updated
	$aGLVEx_Data[0][12] = True

	; Insert data into arrays
	If $iRow = -1 Then
		__GUIListViewEx_Array_Add($aGLVEx_SrcArray, $vInsert, $fMultiRow)
		__GUIListViewEx_Array_Add($aCheck_Array, $vInsert, $fMultiRow)
		__GUIListViewEx_Array_Add($aGLVEx_SrcColArray, ";", $fMultiRow)
	Else
		__GUIListViewEx_Array_Insert($aGLVEx_SrcArray, $iRow + 1, $vInsert, $fMultiRow)
		__GUIListViewEx_Array_Insert($aCheck_Array, $iRow + 1, $vInsert, $fMultiRow)
		__GUIListViewEx_Array_Insert($aGLVEx_SrcColArray, $iRow + 1, ";", $fMultiRow)
	EndIf

	; If Loop No Redraw flag set
	If $aGLVEx_Data[0][15] Then
		; Rewrite ListView
		__GUIListViewEx_ReWriteLV($hGLVEx_SrcHandle, $aGLVEx_SrcArray, $aCheck_Array, $iLV_Index, $fCheckBox, $fRetainWidth)
	EndIf

	; Set highlight
	If $iRow = -1 Then
		__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, _GUICtrlListView_GetItemCount($hGLVEx_SrcHandle) - 1)
	Else
		__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, $iRow)
	EndIf

	; Store amended array
	$aGLVEx_Data[$iLV_Index][2] = $aGLVEx_SrcArray
	$aGLVEx_Data[$iLV_Index][18] = $aGLVEx_SrcColArray
	; Delete copied array
	$aGLVEx_SrcArray = 0
	$aGLVEx_SrcColArray = 0

	; Clear no redraw flag
	$aGLVEx_Data[0][12] = False

	; If colour used or single cell selection
	__GUIListViewEx_RedrawWindow($iLV_Index)

	; Return amended array
	Return _GUIListViewEx_ReturnArray($iLV_Index)

EndFunc   ;==>_GUIListViewEx_InsertSpec

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_Delete
; Description ...: Deletes selected row(s) in active ListView
; Syntax.........: _GUIListViewEx_Delete([$vRange = ""])
; Parameters ....: $vRange - items to delete.  if no parameter passed any selected items are deleted
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of active ListView content with count in [0] element
;                  Failure: Returns "" and sets @error as follows:
;                      1 = No ListView active
;                      2 = No row selected
;                      3 = No items to delete
; Author ........: Melba23
; Modified ......:
; Remarks .......: If multiple items are selected, all are deleted
;                  $vRange must be semicolon-delimited with hypenated consecutive values.
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_Delete($vRange = "")

	; Set data for active ListView
	Local $iLV_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iLV_Index = 0 Then Return SetError(1, 0, "")

	Local $vRet = _GUIListViewEx_DeleteSpec($iLV_Index, $vRange)

	Return SetError(@error, 0, $vRet)

EndFunc   ;==>_GUIListViewEx_Delete

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_DeleteSpec
; Description ...: Deletes specified row(s) in specified ListView
; Syntax.........: _GUIListViewEx_DeleteSpec($iLV_Index, $vRange = "")
; Parameters ....: $iLV_Index - Index of ListView as returned by _GUIListViewEx_Init
;                  $vRange    - Items to delete.
;                                   If no parameter passed any selected items are deleted
;                                   If -1 passed last row is deleted
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of specified ListView content with count in [0] element
;                  Failure: Returns "" and sets @error as follows:
;                      1 = Invalid ListView index
;                      2 = No row selected if no range passed
;                      3 = No items to delete
;                      4 = Invaid range parameter
; Author ........: Melba23
; Modified ......:
; Remarks .......: If multiple items are selected, all are deleted
;                  $vRange must be semicolon-delimited with hypenated consecutive values.
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_DeleteSpec($iLV_Index, $vRange = "")

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, "")

	; Load active ListView details
	$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
	If UBound($hGLVEx_SrcHandle) = 1 Then Return SetError(3, 0, "")
	$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]
	Local $fCheckBox = $aGLVEx_Data[$iLV_Index][6]

	; Copy array for manipulation
	$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
	$aGLVEx_SrcColArray = $aGLVEx_Data[$iLV_Index][18]

	; Create Local array for checkboxes (if no checkboxes makes no difference)
	Local $aCheck_Array[UBound($aGLVEx_SrcArray)]
	For $i = 1 To UBound($aCheck_Array) - 1
		$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $i - 1)
	Next

	If $vRange = "-1" Then
		$vRange = UBound($aGLVEx_SrcArray) - 2
	EndIf

	Local $iIndex, $aIndex

	; Check for range
	If String($vRange) <> "" Then
		$aIndex = __GUIListViewEx_ExpandRange($vRange, $iLV_Index, 0)     ; Rows not columns
		If @error Then Return SetError(4, 0, 0)
	Else
		; Check if colour or single cell selection enabled
		If $aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22] Then
			; Use stored value
			$iIndex = $aGLVEx_Data[$iLV_Index][20]
		Else
			; Check actual values
			$iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_SrcHandle)
		EndIf

		If $iIndex == "" Then
			Return SetError(2, 0, "")
		EndIf
		; Extract all selected items
		$aIndex = StringSplit($iIndex, $aGLVEx_Data[0][24])
	EndIf

	For $i = 1 To $aIndex[0]
		; Remove highlighting from items
		_GUICtrlListView_SetItemSelected($hGLVEx_SrcHandle, $i, False)
	Next

	; Set no redraw flag - prevents problems while colour arrays are updated
	$aGLVEx_Data[0][12] = True

	; Delete elements from array - start from bottom
	For $i = $aIndex[0] To 1 Step -1
		; Check element exists in array
		If $aIndex[$i] <= UBound($aGLVEx_SrcArray) - 2 Then
			__GUIListViewEx_Array_Delete($aGLVEx_SrcArray, $aIndex[$i] + 1)
			__GUIListViewEx_Array_Delete($aCheck_Array, $aIndex[$i] + 1)
			__GUIListViewEx_Array_Delete($aGLVEx_SrcColArray, $aIndex[$i] + 1)
		EndIf
	Next

	; If Loop No Redraw flag set
	If $aGLVEx_Data[0][15] Then
		; Rewrite ListView
		__GUIListViewEx_ReWriteLV($hGLVEx_SrcHandle, $aGLVEx_SrcArray, $aCheck_Array, $iLV_Index, $fCheckBox)
		; Set highlight
		If $aIndex[1] = 0 Then
			__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, 0)
		Else
			__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, $aIndex[1] - 1)
		EndIf
	EndIf

	; Store amended array
	$aGLVEx_Data[$iLV_Index][2] = $aGLVEx_SrcArray
	$aGLVEx_Data[$iLV_Index][18] = $aGLVEx_SrcColArray
	; Delete copied array
	$aGLVEx_SrcArray = 0
	$aGLVEx_SrcColArray = 0

	; Clear no redraw flag
	$aGLVEx_Data[0][12] = False

	; If colour used or single cell selection
	__GUIListViewEx_RedrawWindow($iLV_Index)

	; Return amended array
	Return _GUIListViewEx_ReturnArray($iLV_Index)

EndFunc   ;==>_GUIListViewEx_DeleteSpec

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_InsertCol
; Description ...: Inserts blank column to right of selected column in active ListView
; Syntax.........: _GUIListViewEx_InsertCol([$sTitle = ""[, $iWidth = 50]])
; Parameters ....: $sTitle - (Optional) Title of column - default none
;                  $iWidth - (Optional) Width of new column - default = 50
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of active ListView content with count in [0] element
;                  Failure: If no ListView active then returns "" and sets @error to 1
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_InsertCol($sTitle = "", $iWidth = 50)

	; Set data for active ListView
	Local $iLV_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iLV_Index = 0 Then Return SetError(1, 0, "")

	; Pass active column
	Local $vRet = _GUIListViewEx_InsertColSpec($iLV_Index, $aGLVEx_Data[0][2] + 1, $sTitle, $iWidth)

	Return SetError(@error, 0, $vRet)

EndFunc   ;==>_GUIListViewEx_InsertCol

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_InsertColSpec
; Description ...: Inserts specified blank column in specified ListView
; Syntax.........: _GUIListViewEx_InsertColSpec($iLV_Index[, $iCol = -1[, $sTitle = ""[, $iWidth = 50]]])
; Parameters ....: $iLV_Index - Index of ListView as returned by _GUIListViewEx_Init
;                  $iCol      - (Optional) Column to be be inserted - default -1 adds at right
;                  $sTitle    - (Optional) Title of column - default none
;                  $iWidth    - (Optional) Width of new column - default = 50
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of active ListView content with count in [0] element
;                  Failure: Empty string sets @error to
;                      1 = Invalid ListView index
;                      2 = invalid column
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_InsertColSpec($iLV_Index, $iCol = -1, $sTitle = "", $iWidth = 75)

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, "")

	; Load active ListView details
	$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
	$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]
	Local $fCheckBox = $aGLVEx_Data[$iLV_Index][6]
	Local $fColourEnabled = $aGLVEx_Data[$iLV_Index][19]
	Local $fHdrColourEnabled = $aGLVEx_Data[$iLV_Index][24], $aHdrData

	; Copy arrays for manipulation
	$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
	If $fColourEnabled Then
		$aGLVEx_SrcColArray = $aGLVEx_Data[$iLV_Index][18]
	EndIf
	Local $aEditable = $aGLVEx_Data[$iLV_Index][7]
	Local $aHdrData[4][UBound($aGLVEx_SrcArray, 2)]
	If $fHdrColourEnabled Then
		$aHdrData = $aGLVEx_Data[$iLV_Index][25]
	EndIf

	; Check if valid column
	Local $iMax_Col = UBound($aGLVEx_SrcArray, 2) - 1
	If $iCol = -1 Then $iCol = $iMax_Col + 1
	If $iCol < 0 Or $iCol > $iMax_Col + 1 Then Return SetError(2, 0, "")

	; Create Local array for checkboxes (if no checkboxes makes no difference)
	Local $aCheck_Array[UBound($aGLVEx_SrcArray)]
	For $i = 1 To UBound($aCheck_Array) - 1
		$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $i - 1)
	Next

	; Set no redraw flag - prevents problems while colour arrays are updated
	$aGLVEx_Data[0][12] = True

	; Add column to array
	ReDim $aGLVEx_SrcArray[UBound($aGLVEx_SrcArray)][UBound($aGLVEx_SrcArray, 2) + 1]
	If $fColourEnabled Then
		ReDim $aGLVEx_SrcColArray[UBound($aGLVEx_SrcColArray)][UBound($aGLVEx_SrcColArray, 2) + 1]
	EndIf
	; Move data and blank new column
	For $i = 0 To UBound($aGLVEx_SrcArray) - 1
		For $j = UBound($aGLVEx_SrcArray, 2) - 2 To $iCol Step -1
			$aGLVEx_SrcArray[$i][$j + 1] = $aGLVEx_SrcArray[$i][$j]
			If $fColourEnabled Then
				$aGLVEx_SrcColArray[$i][$j + 1] = $aGLVEx_SrcColArray[$i][$j]
			EndIf
		Next
		$aGLVEx_SrcArray[$i][$iCol] = ""
		If $fColourEnabled Then
			$aGLVEx_SrcColArray[$i][$iCol] = ";"
		EndIf
	Next

	; And now for the editable columns and header data (fixed number of rows)
	ReDim $aEditable[4][UBound($aEditable, 2) + 1]
	ReDim $aHdrData[4][UBound($aHdrData, 2) + 1]
	For $i = 0 To 3
		For $j = UBound($aEditable, 2) - 2 To $iCol Step -1
			$aEditable[$i][$j + 1] = $aEditable[$i][$j]
			$aHdrData[$i][$j + 1] = $aHdrData[$i][$j]
		Next
		$aEditable[$i][$iCol] = ""
	Next
	; Set new column title with default data
	$aHdrData[0][$iCol] = $sTitle
	$aHdrData[1][$iCol] = ";"
	$aHdrData[2][$iCol] = ""
	$aHdrData[3][$iCol] = 0

	; Store amended arrays
	$aGLVEx_Data[$iLV_Index][2] = $aGLVEx_SrcArray
	If $fColourEnabled Then
		$aGLVEx_Data[$iLV_Index][18] = $aGLVEx_SrcColArray
	EndIf
	$aGLVEx_Data[$iLV_Index][7] = $aEditable
	If $fHdrColourEnabled Then
		$aGLVEx_Data[$iLV_Index][25] = $aHdrData
	EndIf

	; Add column to ListView
	_GUICtrlListView_InsertColumn($hGLVEx_SrcHandle, $iCol, $sTitle, $iWidth)

	; If Loop No Redraw flag set
	If $aGLVEx_Data[0][15] Then
		; Rewrite ListView
		__GUIListViewEx_ReWriteLV($hGLVEx_SrcHandle, $aGLVEx_SrcArray, $aCheck_Array, $iLV_Index, $fCheckBox)
	EndIf

	; Clear no redraw flag
	$aGLVEx_Data[0][12] = False

	; If colour used or single cell selection
	__GUIListViewEx_RedrawWindow($iLV_Index)

	; Delete copied array
	$aGLVEx_SrcArray = 0
	$aGLVEx_SrcColArray = 0

	; Reset sort array
	Local $aLVSortState[_GUICtrlListView_GetColumnCount($hGLVEx_SrcHandle)]
	$aGLVEx_Data[$iLV_Index][4] = $aLVSortState

	; Return amended array
	Return _GUIListViewEx_ReturnArray($iLV_Index)

EndFunc   ;==>_GUIListViewEx_InsertColSpec

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_DeleteCol
; Description ...: Deletes selected column in active ListView
; Syntax.........: _GUIListViewEx_DeleteCol()
; Parameters ....: None
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of active ListView content with count in [0] element
;                  Failure: If no ListView active then returns "" and sets @error to 1
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_DeleteCol()

	; Set data for active ListView
	Local $iLV_Index = $aGLVEx_Data[0][1]
	; If no ListView active then return
	If $iLV_Index = 0 Then Return SetError(1, 0, "")

	; Delete active column
	Local $vRet = _GUIListViewEx_DeleteColSpec($iLV_Index, $aGLVEx_Data[0][2])

	Return SetError(@error, 0, $vRet)

EndFunc   ;==>_GUIListViewEx_DeleteCol

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_DeleteColSpec
; Description ...: Deletes specified column in specified ListView
; Syntax.........: _GUIListViewEx_DeleteCol($iLV_Index[, $iCol = -1])
; Parameters ....: $iLV_Index - Index of ListView as returned by _GUIListViewEx_Init
;                  $iCol      - (Optional) Column to delete - default -1 deletes rightmost column
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array of active ListView content with count in [0] element
;                  Failure: Empty string and sets @error to
;                      1 = Invalid ListView index
;                      2 = Invalid column
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_DeleteColSpec($iLV_Index, $iCol = -1)

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, "")

	; Load active ListView details
	$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
	$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]
	Local $fCheckBox = $aGLVEx_Data[$iLV_Index][6]
	Local $fColourEnabled = $aGLVEx_Data[$iLV_Index][19]
	Local $fHdrColourEnabled = $aGLVEx_Data[$iLV_Index][24]

	; Copy array for manipulation
	$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
	If $fColourEnabled Then
		$aGLVEx_SrcColArray = $aGLVEx_Data[$iLV_Index][18]
	EndIf
	Local $aEditable = $aGLVEx_Data[$iLV_Index][7]
	Local $aHdrData[4][UBound($aGLVEx_SrcArray, 2)]
	If $fHdrColourEnabled Then
		$aHdrData = $aGLVEx_Data[$iLV_Index][25]
	EndIf

	; Check if valid column
	Local $iMax_Col = UBound($aGLVEx_SrcArray, 2) - 1
	If $iCol = -1 Then $iCol = $iMax_Col
	If $iCol < 0 Or $iCol > $iMax_Col Then Return SetError(2, 0, "")

	; Create Local array for checkboxes (if no checkboxes makes no difference)
	Local $aCheck_Array[UBound($aGLVEx_SrcArray)]
	For $i = 1 To UBound($aCheck_Array) - 1
		$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $i - 1)
	Next

	; Set no redraw flag - prevents problems while colour arrays are updated
	$aGLVEx_Data[0][12] = True

	; Move data
	For $i = 0 To UBound($aGLVEx_SrcArray) - 1
		For $j = $iCol To UBound($aGLVEx_SrcArray, 2) - 2
			$aGLVEx_SrcArray[$i][$j] = $aGLVEx_SrcArray[$i][$j + 1]
			If $fColourEnabled Then
				$aGLVEx_SrcColArray[$i][$j] = $aGLVEx_SrcColArray[$i][$j + 1]
			EndIf
		Next
	Next
	; Resize arrays
	ReDim $aGLVEx_SrcArray[UBound($aGLVEx_SrcArray)][UBound($aGLVEx_SrcArray, 2) - 1]
	If $fColourEnabled Then
		ReDim $aGLVEx_SrcColArray[UBound($aGLVEx_SrcColArray)][UBound($aGLVEx_SrcColArray, 2) - 1]
	EndIf
	; And now for the editable columns and header data (fixed number of rows)
	For $i = 0 To 3
		For $j = $iCol To UBound($aEditable, 2) - 2
			$aEditable[$i][$j] = $aEditable[$i][$j + 1]
			$aHdrData[$i][$j] = $aHdrData[$i][$j + 1]
		Next
	Next
	ReDim $aEditable[4][UBound($aEditable, 2) - 1]
	ReDim $aHdrData[4][UBound($aHdrData, 2) - 1]

	; Delete column from ListView
	_GUICtrlListView_DeleteColumn($hGLVEx_SrcHandle, $iCol)

	; Store amended arrays
	$aGLVEx_Data[$iLV_Index][2] = $aGLVEx_SrcArray
	If $fColourEnabled Then
		$aGLVEx_Data[$iLV_Index][18] = $aGLVEx_SrcColArray
	EndIf
	$aGLVEx_Data[$iLV_Index][7] = $aEditable
	If $fHdrColourEnabled Then
		$aGLVEx_Data[$iLV_Index][25] = $aHdrData
	EndIf

	; If Loop No Redraw flag set
	If $aGLVEx_Data[0][15] Then
		; Rewrite ListView
		__GUIListViewEx_ReWriteLV($hGLVEx_SrcHandle, $aGLVEx_SrcArray, $aCheck_Array, $iLV_Index, $fCheckBox)
	EndIf

	; Clear no redraw flag
	$aGLVEx_Data[0][12] = False

	; If colour used or single cell selection
	__GUIListViewEx_RedrawWindow($iLV_Index)

	; Delete copied array
	$aGLVEx_SrcArray = 0
	$aGLVEx_SrcColArray = 0

	; Reset sort array
	Local $aLVSortState[_GUICtrlListView_GetColumnCount($hGLVEx_SrcHandle)]
	$aGLVEx_Data[$iLV_Index][4] = $aLVSortState

	; Return amended array
	Return _GUIListViewEx_ReturnArray($iLV_Index)

EndFunc   ;==>_GUIListViewEx_DeleteColSpec

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_SortCol
; Description ...: Sort specified column in specified ListView
; Syntax.........: _GUIListViewEx_SortCol($iLV_Index[, $iCol = -1])
; Parameters ....: $iLV_Index - Index of ListView as returned by _GUIListViewEx_Init
;                  $iCol      - (Optional) Column to sort - default -1 sorts active column
; Requirement(s).: v3.3.10 +
; Return values .: Success: 1
;                  Failure: 0 and sets @error to
;                      1 = Invalid ListView index
;                      2 = Invalid column
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_SortCol($iLV_Index, $iCol = -1)

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, 0)

	; Load array
	Local $aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
	; Check if valid column
	Local $iMax_Col = UBound($aGLVEx_SrcArray, 2) - 1
	If $iCol = -1 Then
		; Use active column
		$iCol = $aGLVEx_Data[$iLV_Index][21]
	EndIf
	If $iCol < 0 Or $iCol > $iMax_Col Then Return SetError(2, 0, 0)

	; Load current ListView sort state array
	Local $aLVSortState = $aGLVEx_Data[$iLV_Index][4]
	; Sort column
	__GUIListViewEx_ColSort($aGLVEx_Data[$iLV_Index][0], $iLV_Index, $aLVSortState, $iCol)

	Return 1

EndFunc   ;==>_GUIListViewEx_SortCol

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_SetEditStatus
; Description ...: Sets edit on doubleclick mode for specified column(s)
; Syntax.........: _GUIListViewEx_SetEditStatus($iLV_Index, $vCol [, $iMode = 1 , $vParam1 = Default [, $vParam2 = Default]]])
; Parameters ....: $iLV_Index - Index number of ListView as returned by _GUIListViewEx_Init
;                  $vCol      - Column of ListView to set (string or single number)
;                                   All columns: "*"
;                                   Range string example: "1;2;5-6;8-9;10" - expanded automatically
;                  $iMode     - 0 = Not editable
;                                   $vParam1 & $vParam2 ignored
;                  $iMode     - 1 = Editable using manual input
;                                   $vParam1 = 0: (default) Standard text edit
;                                              1: Add UpDown
;                                   $vParam2 = Only used if $vParam set to 1
;                                              Delimited string: "Min value|Max value|0/1" - final value 1 = UpDown wrap
;                  $iMode     - 2 = Editable using combo
;                                   $vParam1 = Content of combo - either delimited string or 0-based array
;                                   $vParam2 = 0: editable combo (default); 1: readonly
;                                                + 2 - Combo list automatically drops down on edit
;                  $iMode     - 3 = Editable using date control
;                                   $vParam1 = Preselected date (yyyy\MM\dd) - default current date. Trailing # for auto dropdown
;                                   $vParam2 = Required display format for DTP control (see below) - default system date setting
;                  $iMode     - 9 = Editable with user-defined function
;                                   $vParam1 = Function as object
; Requirement(s).: v3.3.10 +
; Return values .: Success: 1
;                  Failure: 0 and sets @error as follows:
;                           1 - Invalid ListView Index
;                           2 - Invalid column parameter
;                           3 - Invalid mode
;                           4 - Invalid $vParam1/2 - @extended set as follows
;                               11 = Mode 1: $vParam1 invalid
;                               12 = Mode 1: $vParam2 invalid
;                               21 = Mode 2: $vParam1 not string or array
;                               22 = Mode 2: $vParam2 not boolean
;                               31 = Mode 3: $vParam1 date string incorrectly formatted
;                               91 = Mode 9: $vParam1 not function
; Author ........: Melba23
; Modified ......:
; Remarks .......: - Overrides all previous edit settings for the specified column(s).
;                  - Columns are non-editable by default so function only required to set editable columns
;                  - {ENTER} accepts edit - {TAB} accepts and moves to next cell if EditMode allows
;                  - {ESCAPE} abandons edit, and possibly all text edits if EditMode negative
;                  - Ctrl-{LEFT}{RIGHT}{UP}{DOWN} moves to next cell if EditMode allows
;                        - Accepts input for manual text
;                        - Abandons input for combo and date (because they use arrow keys to modify their data)
;                  - Display format string for date control uses any of following plus required punctuation/spacing:
;                       "d"    - One/two digit day
;                       "dd"   - Two digit day padded with leading zero if required
;                       "ddd"  - 3-char weekday abbreviation
;                       "dddd" - Full weekday name
;                       "h"    - One/two digit hour - 12-hour format
;                       "hh"   - Two digit hour padded with leading zero if required - 12-hour format
;                       "H"    - One/two digit hour - 24-hour format
;                       "HH"   - Two digit hour padded with leading zero if required - 24 hour format
;                       "m"    - One/two digit minute
;                       "mm"   - Two digit minute padded with leading zero if required
;                       "M"    - One/two digit month number
;                       "MM"   - Two digit month number padded with leading zero if required
;                       "MMM"  - 3-char month abbreviation
;                       "MMMM" - Full month name
;                       "t"    - One letter AM/PM abbreviation
;                       "tt"   - Two letter AM/PM abbreviation
;                       "yy"   - Last two digits of year
;                       "yyyy" - Full year
;                   - User-defined function must accept 4 (and only 4) parameters:
;                       ListView handle, ListView index within the UDF, clicked row, clicked column
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_SetEditStatus($iLV_Index, $vCol, $iMode = 1, $vParam1 = Default, $vParam2 = Default)

	; Check valid index
	If $iLV_Index < 1 Or $iLV_Index > $aGLVEx_Data[0][0] Then
		Return SetError(1, 0, 0)
	EndIf

	; Check column index
	Local $aRange = __GUIListViewEx_ExpandRange($vCol, $iLV_Index)
	If @error Then Return SetError(2, 0, 0)

	; Extract editable array
	Local $aEditable = $aGLVEx_Data[$iLV_Index][7]

	Switch $iMode
		Case 0, 1     ; Not editable/editable
			If $vParam1 = Default Then $vParam1 = 0
			If $vParam2 = Default Then $vParam2 = ""
			Switch $vParam1
				Case 0
					If $vParam2 Then
						Return SetError(4, 12, 0)
					EndIf
				Case 1
					If $vParam2 And Not StringRegExp($vParam2, "^\d+\|\d+\|(0|1)$") Then
						Return SetError(4, 12, 0)
					EndIf
				Case Else
					Return SetError(4, 11, 0)
			EndSwitch

			For $i = 1 To $aRange[0]
				; Set/clear status and clear any other edit data
				$aEditable[0][$aRange[$i]] = $iMode
				$aEditable[1][$aRange[$i]] = $vParam1
				$aEditable[2][$aRange[$i]] = $vParam2
			Next

		Case 2
			If Not (IsArray($vParam1) Or IsString($vParam1)) Then
				Return SetError(4, 21, 0)
			EndIf
			If $vParam2 = Default Then $vParam2 = 0
			Switch $vParam2
				Case 0 To 3
					;
				Case Else
					Return SetError(4, 22, 0)
			EndSwitch
			For $i = 1 To $aRange[0]
				; Set status and combo data/format
				$aEditable[0][$aRange[$i]] = 2
				$aEditable[1][$aRange[$i]] = $vParam1
				$aEditable[2][$aRange[$i]] = $vParam2
			Next

		Case 3
			If $vParam1 = Default Then
				$vParam1 = ""
			EndIf
			If Not StringRegExp($vParam1, "^(\d{4}\/\d{2}\/\d{2})?#?$") Then
				Return SetError(4, 31, 0)
			EndIf
			If $vParam2 = Default Then
				$vParam2 = ""
			EndIf
			For $i = 1 To $aRange[0]
				; Set status and date default/format
				$aEditable[0][$aRange[$i]] = 3
				$aEditable[1][$aRange[$i]] = $vParam1
				$aEditable[2][$aRange[$i]] = $vParam2
			Next

		Case 9
			If Not IsFunc($vParam1) Then
				Return SetError(4, 91, 0)
			EndIf
			For $i = 1 To $aRange[0]
				; Set flag
				$aEditable[0][$aRange[$i]] = 9
				$aEditable[1][$aRange[$i]] = $vParam1
			Next

		Case Else
			Return SetError(3, 0, 0)
	EndSwitch

	; Store amended array
	$aGLVEx_Data[$iLV_Index][7] = $aEditable

	; Show success
	Return 1

EndFunc   ;==>_GUIListViewEx_SetEditStatus

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_SetEditKey
; Description ...: Sets key(s) required to begin edit of selected item
; Syntax.........: _GUIListViewEx_SetEditKey([$sKey = Default])
; Parameters ....: $sKey - String of key(s): 0/1/2 modifiers (^ = Ctrl, ! = Alt) plus single main key code from _IsPressed
;                          Default - reset default key = BackSpace
; Requirement(s).: v3.3.10 +
; Return values .: Success: 1
;                  Failure: 0 and sets @error as follows:
;                           1 - Invalid string
; Author ........: Melba23
; Modified ......:
; Remarks .......: Shift key not available as modifier
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_SetEditKey($sKey = Default)

	; Check for default reset
	If $sKey = Default Then
		$aGLVEx_Data[0][23] = "08"
		Return 1
	EndIf
	; Check string format
	If Not StringRegExp($sKey, "(?i)^([!^]){0,2}([0-9a-f]{2})$") Then
		Return SetError(1, 0, 0)
	EndIf
	; Replace modifier(s) and store code
	$aGLVEx_Data[0][23] = StringReplace(StringReplace($sKey, "^", "11;"), "!", "12;")
	Return 1

EndFunc   ;==>_GUIListViewEx_SetEditKey

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_EditItem
; Description ...: Open ListView items for editing programatically
; Syntax.........: _GUIListViewEx_EditItem($iLV_Index, $iRow, $iCol[, $iEditMode = 0[, $iDelta_X = 0[, $iDelta_Y = 0]]])
; Parameters ....: $iLV_Index - Index number of ListView as returned by _GUIListViewEx_Init
;                  $iRow      - Zero-based row of item to edit
;                  $iCol      - Zero-based column of item to edit
;                  $iEditMode - Only used if using Edit control:
;                                    Return after single edit - 0 (default)
;                                    {TAB} and arrow keys move to next item - 2-digit code (row mode/column mode)
;                                        1 = Reaching edge terminates edit process
;                                        2 = Reaching edge remains in place
;                                        3 = Reaching edge loops to opposite edge
;                               	     Positive value = ESC abandons current edit only, previous edits remain
;                                        Negative value = ESC resets all edits in current session
;                               Ignored if using Combo control - return after single edit
;                  $iDelta_X  - Permits fine adjustment of edit control in X axis if needed
;                  $iDelta_Y  - Permits fine adjustment of edit control in Y axis if needed
; Requirement(s).: v3.3.10 +
; Return values .: Success: 2D array of items edited
;                              - Total number of edits in [0][0] element, with each edit following:
;                              - [zero-based row][zero-based column][original content][new content]
;                           @extended set depending on key used to end edit:
;							   - True = {ENTER} pressed
;							   - False = {ESC} pressed
;                  Failure: Sets @error as follows:
;                           1 - Invalid ListView Index
;                           2 - ListView not editable
;                           3 - Invalid row
;                           4 - Invalid column
;                           5 - Invalid edit mode
; Author ........: Melba23
; Modified ......:
; Remarks .......: - Once edit started, all other script activity is suspended as explained for _GUIListViewEx_EditOnClick
;                  - Returned array allows for verification of new value - _GUIListViewEx_ChangeItem can reset original
;                  - @extended value can be used to determine if to continue in a loop post-edit
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_EditItem($iLV_Index, $iRow, $iCol, $iEditMode = 0, $iDelta_X = 0, $iDelta_Y = 0)

	; Activate the ListView
	_GUIListViewEx_SetActive($iLV_Index)
	If @error Then
		Return SetError(1, 0, "")
	EndIf
	; Check row and col values
	Local $iMax = _GUICtrlListView_GetItemCount($hGLVEx_SrcHandle)
	If $iRow < 0 Or $iRow > $iMax - 1 Then
		Return SetError(3, 0, "")
	EndIf
	$iMax = _GUICtrlListView_GetColumnCount($hGLVEx_SrcHandle)
	If $iCol < 0 Or $iCol > $iMax - 1 Then
		Return SetError(4, 0, "")
	EndIf
	; Check edit mode parameter
	Switch Abs($iEditMode)
		Case 0, 11, 12, 13, 21, 22, 23, 31, 32, 33     ; Single edit or both axes set to valid parameter
			; Allow
		Case Else
			Return SetError(5, 0, "")
	EndSwitch
	; Declare location array
	Local $aLocation[2] = [$iRow, $iCol]
	; Start edit - force text edit type
	Local $aEdited = __GUIListViewEx_EditProcess($iLV_Index, $aLocation, $iDelta_X, $iDelta_Y, $iEditMode, True)
	; Check if edits occurred
	If $aEdited[0][0] = 0 Then
		$aEdited = ""
	EndIf
	; Determine key used to exit
	Local $iKeyCode = @extended
	; Wait until return key no longer pressed
	_WinAPI_GetAsyncKeyState($iKeyCode)
	While _WinAPI_GetAsyncKeyState($iKeyCode)
		Sleep(10)
	WEnd
	; Unselect row
	_GUICtrlListView_SetItemSelected($aGLVEx_Data[$iLV_Index][0], -1, False)
	; Set extended value
	SetExtended(($iKeyCode = 0x0D) ? (True) : (False))
	; Return result array
	Return $aEdited

EndFunc   ;==>_GUIListViewEx_EditItem

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_EditWidth
; Description ...: Set required widths for column edit/combo when editing
; Syntax.........: _GUIListViewEx_EditWidth($iLV_Index, $aWidth)
; Parameters ....: $iLV_Index - Index number of ListView as returned by _GUIListViewEx_Init
;                  $aWidth    - Zero-based 1D array of required edit/combo widths where array index = column
;                               0/Default/empty = use actual column width
; Requirement(s).: v3.3.10 +
; Return values .: Success: 1
;                  Failure: 0 and sets @error as follows:
;                           1 - Invalid ListView Index
;                           2 - Invalid $aWidth array
; Author ........: Melba23
; Modified ......:
; Remarks .......: - $aWidth will be ReDimmed to match columns - all values converted to Number datatype.
;                  - Negative value resizes read-only combo edit control, otherwise only dropdown resized.
;                  - Actual column width used if wider than set value
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_EditWidth($iLV_Index, $aWidth)

	; Check valid index
	If $iLV_Index < 1 Or $iLV_Index > $aGLVEx_Data[0][0] Then
		Return SetError(1, 0, 0)
	EndIf
	; Check valid array
	If (Not IsArray($aWidth)) Or (UBound($aWidth, 0) <> 1) Then Return SetError(2, 0, 0)
	; Resize array
	ReDim $aWidth[_GUICtrlListView_GetColumnCount($aGLVEx_Data[$iLV_Index][0])]
	; Store array
	$aGLVEx_Data[$iLV_Index][14] = $aWidth

EndFunc   ;==>_GUIListViewEx_EditWidth

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_ChangeItem
; Description ...: Change ListView item content programatically
; Syntax.........: _GUIListViewEx_ChangeItem($iLV_Index, $iRow, $iCol, $vValue)
; Parameters ....: $iLV_Index - Index number of ListView as returned by _GUIListViewEx_Init
;                  $iRow      - Zero-based row of item to change
;                  $iCol      - Zero-based column of item to change
;                  $vValue    - Content to place in ListView item
; Requirement(s).: v3.3.10 +
; Return values .: Success: Success: Array of current ListView content as returned by _GUIListViewEx_ReturnArray
;                  Failure: Sets @error as follows:
;                           1 - Invalid ListView Index
;                           2 - Deprecated
;                           3 - Invalid row
;                           4 - Invalid column
; Author ........: Melba23
; Modified ......:
; Remarks .......: This function will change content even if column is not editable
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_ChangeItem($iLV_Index, $iRow, $iCol, $vValue)

	; Activate the ListView
	_GUIListViewEx_SetActive($iLV_Index)
	If @error Then
		Return SetError(1, 0, "")
	EndIf
	; Check row and col values
	Local $iMax = _GUICtrlListView_GetItemCount($hGLVEx_SrcHandle)
	If $iRow < 0 Or $iRow > $iMax - 1 Then
		Return SetError(3, 0, "")
	EndIf
	$iMax = _GUICtrlListView_GetColumnCount($hGLVEx_SrcHandle)
	If $iCol < 0 Or $iCol > $iMax - 1 Then
		Return SetError(4, 0, "")
	EndIf
	; Load array
	Local $aData_Array = $aGLVEx_Data[$iLV_Index][2]
	; Amend item text
	_GUICtrlListView_SetItemText($hGLVEx_SrcHandle, $iRow, $vValue, $iCol)
	; Amend array element
	$aData_Array[$iRow + 1][$iCol] = $vValue
	; Store amended array
	$aGLVEx_Data[$iLV_Index][2] = $aData_Array

	; If colour used or single cell selection
	__GUIListViewEx_RedrawWindow($iLV_Index)

	; Return changed array
	Return _GUIListViewEx_ReturnArray($iLV_Index)

EndFunc   ;==>_GUIListViewEx_ChangeItem

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_LoadHdrData
; Description ...: Sets header title, text and back colour (if enabled), edit mode (if enabled), and width resizing mode
; Syntax.........: _GUIListViewEx_LoadHdrData($iLV_Index, $aHdrData)
; Parameters ....: $iLV_Index - Index of ListView
;                  $aColArray - 0-based 4-row 2D array containing titles, semicolon delimited colour strings in RGB hex, edit settings, resize settings
;                                 [0][ColIndex] = Title - only needed if headers colour enabled
;                                 [1][ColIndex] = Colour strings in RGB hex - only if header colour enabled
;                                                    "text;back"          = both colours set
;                                                    "text;" or ";back"   = one colour set
;                                                    ";" or "" or Default = use default colours
;                                 [2][ColIndex] = Empty string or Default = Edit header as text
;                                                 Delimited string        = Edit header with combo - leading @TAB = read only
;                                 [3][ColIndex] = 0                = column resizable
;                                                 Positive integer = fixed width required
;                                                 Default          = fix at current width
; Requirement(s).: v3.3.10 +
; Return values .: Success: Returns 1
;                  Failure: Returns 0 and sets @error as follows:
;                      1 = Invalid index
;                      2 = Invalid array - @extended set as follows:
;                                            0 - Array not 2D
;                                            1 - Not 4 rows
;                                            2 - Incorrect number of columns
;                      3 = Header colour not enabled but colour set
;                      4 = Invalid colour string
; Author ........: Melba23
; Modified ......:
; Remarks .......: Column resize values forced to positive integers - non-numeric values converted to 0
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_LoadHdrData($iLV_Index, $aHdrData)

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, 0)
	; Check array
	If UBound($aHdrData, 0) <> 2 Then
		Return SetError(2, 0, 0)
	EndIf
	If UBound($aHdrData) <> 4 Then
		Return SetError(2, 1, 0)
	EndIf
	If UBound($aHdrData, 2) <> UBound($aGLVEx_Data[$iLV_Index][2], 2) Then
		Return SetError(2, 2, 0)
	EndIf
	; Convert colours to BGR
	Local $sColSet, $aColSplit
	For $i = 0 To UBound($aHdrData, 2) - 1

		; Check titles
		If $aHdrData[0][$i] = Default Then
			$aHdrData[0][$i] = ""
		EndIf

		; Convert colours to BGR
		$sColSet = $aHdrData[1][$i]
		; Force empty colour to ;
		If $sColSet = "" Or $sColSet = Default Then
			$sColSet = ";"
		EndIf
		; Check valid colour string
		If Not StringRegExp($sColSet, "^(\Q0x\E[0-9A-Fa-f]{6})?;(\Q0x\E[0-9A-Fa-f]{6})?$") Then
			Return SetError(4, 0, 0)
		EndIf
		$aColSplit = StringSplit($sColSet, ";")
		; Convert colours to BGR
		For $j = 1 To 2
			; If colour set check header colour enabled
			If $aColSplit[$j] And Not $aGLVEx_Data[$iLV_Index][24] Then
				Return SetError(3, 0, 0)
			Else
				$aColSplit[$j] = StringRegExpReplace($aColSplit[$j], "0x(.{2})(.{2})(.{2})", "0x$3$2$1")
			EndIf
		Next
		; Reset to converted colour
		$aHdrData[1][$i] = $aColSplit[1] & ";" & $aColSplit[2]

		; Check edit parameters
		If $aHdrData[2][$i] = Default Then
			$aHdrData[2][$i] = ""
		EndIf

		; Check resize parameters
		If $aHdrData[3][$i] = Default Then
			$aHdrData[3][$i] = _GUICtrlListView_GetColumnWidth($aGLVEx_Data[$iLV_Index][0], $i)
		Else
			$aHdrData[3][$i] = Abs(Number($aHdrData[3][$i]))
		EndIf

	Next

	; Store header data
	$aGLVEx_Data[$iLV_Index][25] = $aHdrData

	; Force redraw
	__GUIListViewEx_RedrawWindow($iLV_Index, True)

	Return 1

EndFunc   ;==>_GUIListViewEx_LoadHdrData

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_EditHeader
; Description ...: Manual edit of specified ListView header
; Syntax.........: _GUIListViewEx_EditHeader([$iLV_Index = Default[, $iCol = Default[, $iDelta_X = 0[, $iDelta_Y = 0]]]])
; Parameters ....: $iLV_Index - Index number of ListView as returned by _GUIListViewEx_Init - default active ListView
;                  $iCol      - Zero-based column of header to edit
;                  $iDelta_X  - Permits fine adjustment of edit control in X axis if needed
;                  $iDelta_Y  - Permits fine adjustment of edit control in Y axis if needed
; Requirement(s).: v3.3.10 +
; Return values .: Success: Array: 2D array [column][original header text][new header text]
;                  Failure: Empty string and sets @error as follows:
;                           1 - Invalid ListView Index
;                           2 - ListView headers not editable
;                           3 - Invalid column
; Author ........: Melba23
; Modified ......:
; Remarks .......: - Once edit started, all other script activity is suspended until following occurs:
;                      {ENTER}  = Current edit confirmed and editing ended
;                      {ESCAPE} or click on other control = Current edit cancelled and editing ended
;                  - Note this function will alter a header even if the column is not editable
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_EditHeader($iLV_Index = Default, $iCol = Default, $iDelta_X = 0, $iDelta_Y = 0)

	Local $aRet = ""

	If $iLV_Index = Default Then
		$iLV_Index = $aGLVEx_Data[0][1]
	EndIf
	; Activate the ListView
	_GUIListViewEx_SetActive($iLV_Index)
	If @error Then
		Return SetError(1, 0, $aRet)
	EndIf

	Local $hLV_Handle = $aGLVEx_Data[$iLV_Index][0]
	Local $cLV_CID = $aGLVEx_Data[$iLV_Index][1]

	; Check ListView headers are editable
	If $aGLVEx_Data[$iLV_Index][8] = "" Then
		Return SetError(2, 0, $aRet)
	EndIf
	; Check col value
	If $iCol = Default Then
		$iCol = $aGLVEx_Data[0][2]
	EndIf
	Local $iMax = _GUICtrlListView_GetColumnCount($hLV_Handle)
	If $iCol < 0 Or $iCol > $iMax - 1 Then
		Return SetError(3, 0, $aRet)
	EndIf

	Local $tLVPos = DllStructCreate("struct;long X;long Y;endstruct")
	; Get position of ListView within GUI client area
	__GUIListViewEx_GetLVCoords($hLV_Handle, $tLVPos)
	; Get ListView client area to allow for scrollbars
	Local $aLVClient = WinGetClientSize($hLV_Handle)
	; Get ListView font details
	Local $aLV_FontDetails = __GUIListViewEx_GetLVFont($hLV_Handle)
	; Disable ListView
	WinSetState($hLV_Handle, "", @SW_DISABLE)
	; Load header data
	Local $aHdrData = $aGLVEx_Data[$iLV_Index][25]
	; Get current text of header
	Local $aColData, $sHeaderOrgText
	; Check if header colour enabled
	If $aGLVEx_Data[$iLV_Index][24] Then
		$sHeaderOrgText = $aHdrData[0][$iCol]
	Else
		$aColData = _GUICtrlListView_GetColumn($hLV_Handle, $iCol)
		$sHeaderOrgText = $aColData[5]
	EndIf
	; Get required edit coords for 0 item
	Local $aLocation[2] = [0, $iCol]
	Local $aEdit_Coords = __GUIListViewEx_EditCoords($hLV_Handle, $cLV_CID, $aLocation, $tLVPos, $aLVClient[0] - 5, $iDelta_X, $iDelta_Y)
	; Now get header size and adjust coords for header
	Local $hHeader = _GUICtrlListView_GetHeader($hLV_Handle)
	Local $aHeader_Pos = WinGetPos($hHeader)
	$aEdit_Coords[0] -= 2
	$aEdit_Coords[1] -= $aHeader_Pos[3]
	$aEdit_Coords[3] = $aHeader_Pos[3]

	Local $hCombo, $hTemp_Edit, $hTemp_List, $hTemp_Combo, $sCombo_Data

	; Check edit mode
	If $aHdrData[2][$iCol] Then     ; Combo
		$sCombo_Data = $aHdrData[2][$iCol]
		; Create temporary combo
		If StringLeft($sCombo_Data, 1) = @TAB Then     ; Read only combo
			$cGLVEx_EditID = GUICtrlCreateCombo("", $aEdit_Coords[0], $aEdit_Coords[1], $aEdit_Coords[2], $aEdit_Coords[3], 0x00200043)     ; $CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL
			$sCombo_Data = StringTrimLeft($sCombo_Data, 1)
		Else     ; Normal combo
			$cGLVEx_EditID = GUICtrlCreateCombo("", $aEdit_Coords[0], $aEdit_Coords[1], $aEdit_Coords[2], $aEdit_Coords[3], 0x00200042)     ; $CBS_DROPDOWN, $CBS_AUTOHSCROLL, $WS_VSCROLL
		EndIf
		GUICtrlSetData($cGLVEx_EditID, $sCombo_Data)
		; Get combo data
		$hCombo = GUICtrlGetHandle($cGLVEx_EditID)
		Local $tInfo = DllStructCreate("dword Size;struct;long EditLeft;long EditTop;long EditRight;long EditBottom;endstruct;" & _
				"struct;long BtnLeft;long BtnTop;long BtnRight;long BtnBottom;endstruct;dword BtnState;hwnd hCombo;hwnd hEdit;hwnd hList")
		Local $iInfo = DllStructGetSize($tInfo)
		DllStructSetData($tInfo, "Size", $iInfo)
		_SendMessage($hCombo, 0x164, 0, $tInfo, 0, "wparam", "struct*")     ; $CB_GETCOMBOBOXINFO
		$hTemp_Edit = DllStructGetData($tInfo, "hEdit")
		$hTemp_List = DllStructGetData($tInfo, "hList")
		$hTemp_Combo = DllStructGetData($tInfo, "hCombo")
	Else     ; Edit
		; Create temporary edit
		$cGLVEx_EditID = GUICtrlCreateEdit($sHeaderOrgText, $aEdit_Coords[0], $aEdit_Coords[1], $aEdit_Coords[2], $aEdit_Coords[3], 0)
		$hTemp_Edit = GUICtrlGetHandle($cGLVEx_EditID)
	EndIf
	; Set font size
	GUICtrlSetFont($cGLVEx_EditID, $aLV_FontDetails[0], Default, Default, $aLV_FontDetails[1])
	; Give keyboard focus
	_WinAPI_SetFocus($hTemp_Edit)
	; Check "select all" flag state
	If Not $aGLVEx_Data[$iLV_Index][11] Then
		GUICtrlSendMsg($cGLVEx_EditID, 0xB1, 0, -1)     ; $EM_SETSEL
	EndIf

	Local $tMouseClick = DllStructCreate($tagPOINT)

	; Valid keys to action (ENTER, ESC)
	Local $aKeys[2] = [0x0D, 0x1B]
	; Clear key code flag
	Local $iKey_Code = 0
	Local $fCombo_State = False
	; Prevent GUI closure on ESC as needed to exit edit
	Local $iOldESC = Opt("GUICloseOnESC", 0)

	; Wait for a key press
	While 1
		; Check for SYSCOMMAND Close Event
		If $aGLVEx_Data[0][9] Then
			$aGLVEx_Data[0][9] = False
			ExitLoop
		EndIf
		; Check for valid key or mouse button pressed or combo open/close
		For $i = 0 To 1
			_WinAPI_GetAsyncKeyState($aKeys[$i])
			If _WinAPI_GetAsyncKeyState($aKeys[$i]) Then
				; Set key pressed flag
				$iKey_Code = $aKeys[$i]
				ExitLoop 2
			EndIf
		Next
		; Temp input loses focus
		If _WinAPI_GetFocus() <> $hTemp_Edit Then
			ExitLoop
		EndIf
		; Check for mouse pressed outside edit
		_WinAPI_GetAsyncKeyState(0x01)
		If _WinAPI_GetAsyncKeyState(0x01) Then
			; Look for clicks outside edit/combo control
			DllStructSetData($tMouseClick, "x", MouseGetPos(0))
			DllStructSetData($tMouseClick, "y", MouseGetPos(1))
			Switch _WinAPI_WindowFromPoint($tMouseClick)
				Case $hTemp_Combo, $hTemp_Edit, $hTemp_List
					; Over edit/combo
				Case Else
					ExitLoop
			EndSwitch
			; Wait for mouse button release
			_WinAPI_GetAsyncKeyState(0x01)
			While _WinAPI_GetAsyncKeyState(0x01)
				Sleep(10)
			WEnd
		EndIf
		If $hCombo Then
			; Check for dropdown open and close
			Switch _SendMessage($hCombo, 0x157)     ; $CB_GETDROPPEDSTATE
				Case 0
					; If opened and closed
					If $fCombo_State = True Then
						; If no content
						If GUICtrlRead($cGLVEx_EditID) = "" Then
							; Ignore
							$fCombo_State = False
						Else
							; Act as if Enter pressed
							$iKey_Code = 0x0D
							ExitLoop
						EndIf
					EndIf
				Case 1
					; Set flag if opened
					If Not $fCombo_State Then
						$fCombo_State = True
					EndIf
			EndSwitch
		EndIf
		; Save CPU
		Sleep(10)
	WEnd
	; Action keypress
	Switch $iKey_Code
		Case 0x0D
			; Change column header text
			Local $sHeaderNewText = GUICtrlRead($cGLVEx_EditID)
			If $sHeaderNewText <> $sHeaderOrgText Then
				; Check if header colour enabled
				If $aGLVEx_Data[$iLV_Index][24] Then
					$aHdrData[0][$iCol] = $sHeaderNewText
					$aGLVEx_Data[$iLV_Index][25] = $aHdrData
				Else
					_GUICtrlListView_SetColumn($hLV_Handle, $iCol, $sHeaderNewText)
				EndIf
				Local $aRet[1][3] = [[$iCol, $sHeaderOrgText, $sHeaderNewText]]
			EndIf
		Case Else
			; Return empty string
			$aRet = ""
	EndSwitch
	; Wait until key no longer pressed
	_WinAPI_GetAsyncKeyState($iKey_Code)
	While _WinAPI_GetAsyncKeyState($iKey_Code)
		Sleep(10)
	WEnd

	; Reset user value
	Opt("GUICloseOnESC", $iOldESC)
	; Delete Edit
	GUICtrlDelete($cGLVEx_EditID)
	; Reenable ListView
	WinSetState($hLV_Handle, "", @SW_ENABLE)

	Return $aRet

EndFunc   ;==>_GUIListViewEx_EditHeader

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_LoadColour
; Description ...: Uses array to set text and back colour for a user colour enabled ListView
; Syntax.........: _GUIListViewEx_LoadColour($iLV_Index, $aColArray)
; Parameters ....: $iLV_Index - Index of ListView
;                  $aColArray - 0-based 2D array containing colour strings in RGB hex
;                                    "text;back"        = both user colours set
;                                    "text;" or ";back" = one user colour set
;                                    ";" or ""          = default colours
; Requirement(s).: v3.3.10 +
; Return values .: Success: Returns 1
;                  Failure: Returns 0 and sets @error as follows:
;                      1 = Invalid index
;                      2 = ListView not user colour enabled
;                      3 = Array not 2D (@extended = 0) or not correct size for LV (@extended = 1)
;                      4 = Invalid colour string in array
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_LoadColour($iLV_Index, $aColArray)

	Local $sColSet

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, 0)
	; Check ListView is user colour enabled
	If Not $aGLVEx_Data[$iLV_Index][19] Then
		Return SetError(2, 0, 0)
	EndIf
	If UBound($aColArray, 0) <> 2 Then
		Return SetError(3, 0, 0)
	EndIf

	; Add a 0-line to match the stored data array
	_ArrayInsert($aColArray, 0)
	; Compare sizes
	If (UBound($aColArray) <> UBound($aGLVEx_Data[$iLV_Index][2])) Or (UBound($aColArray, 2) <> UBound($aGLVEx_Data[$iLV_Index][2], 2)) Then
		Return SetError(3, 1, 0)
	EndIf
	; Convert all colours to BGR
	For $i = 1 To UBound($aColArray, 1) - 1
		For $j = 0 To UBound($aColArray, 2) - 1
			$sColSet = $aColArray[$i][$j]
			If $sColSet = "" Then
				$sColSet = ";"
				$aColArray[$i][$j] = ";"
			EndIf
			If Not StringRegExp($sColSet, "^(\Q0x\E[0-9A-Fa-f]{6})?;(\Q0x\E[0-9A-Fa-f]{6})?$") Then
				Return SetError(4, 0, 0)
			EndIf
			$aColArray[$i][$j] = StringRegExpReplace($sColSet, "0x(.{2})(.{2})(.{2})", "0x$3$2$1")
		Next
	Next
	$aGLVEx_Data[$iLV_Index][18] = $aColArray

	Return 1

EndFunc   ;==>_GUIListViewEx_LoadColour

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_SetDefColours
; Description ...: Sets default colours for user colour/single cell select enabled ListViews
; Syntax.........: _GUIListViewEx_SetDefColours($aDefCols)
; Parameters ....: $aDefCols - 1D 4-element array of hex RGB default colour strings
;                                (Normal text, Normal field, Selected text, Selected field)
; Requirement(s).: v3.3.10 +
; Return values .: Success: Returns 1
;                  Failure: Returns 0 and sets @error as follows:
;                      1 = Invalid index
;                      2 = Not user colour or single cell selection enabled
;                      3 = Invalid array
;                      4 - Invalid colour
; Author ........: Melba23
; Modified ......:
; Remarks .......: Setting an element to Default resets the original default colour
;                  Setting an element to "" maintains current default colour
;                  Normal colours are used for all non-user coloured ListView items
;                  Selected colours used for row/single cell selection
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_SetDefColours($iLV_Index, $aDefCols)

	; Check valid index
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, 0)
	; Check colour or single cell enabled
	If Not ($aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22]) Then Return SetError(2, 0, 0)
	; Check valid array
	If Not IsArray($aDefCols) Or UBound($aDefCols) <> 4 Or UBound($aDefCols, 0) <> 1 Then Return SetError(3, 0, 0)

	; Load current colours
	Local $aCurCols = $aGLVEx_Data[$iLV_Index][23]
	; Loop through array
	Local $sCol
	For $i = 0 To 3
		If $aDefCols[$i] = Default Then
			; Reset default colour
			$aDefCols[$i] = $aGLVEx_DefColours[$i]
		ElseIf $aDefCols[$i] = "" Then
			; Maintain current colour
			$aDefCols[$i] = $aCurCols[$i]
		Else
			Switch Number($aDefCols[$i])
				; Check valid colour
				Case 0 To 0xFFFFFF
					; Convert to BGR
					$sCol = '0x' & StringMid($aDefCols[$i], 7, 2) & StringMid($aDefCols[$i], 5, 2) & StringMid($aDefCols[$i], 3, 2)
					; Save in array
					$aDefCols[$i] = $sCol
				Case Else
					Return SetError(4, 0, 0)
			EndSwitch
		EndIf
	Next
	; Store array
	$aGLVEx_Data[$iLV_Index][23] = $aDefCols

	; Force reload of redraw colour array
	__GUIListViewEx_RedrawWindow($iLV_Index, True)

	Return 1

EndFunc   ;==>_GUIListViewEx_SetDefColours

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_SetColour
; Description ...: Sets text and/or back colour for a user colour enabled ListView item
; Syntax.........: _GUIListViewEx_SetColour($iLV_Index, $sColSet, $iRow, $iCol)
; Parameters ....: $iLV_Index - Index of ListView
;                  $sColSet   - Colour string in RGB hex (0xRRGGBB)
;                                   "text;back"        = both user colours set
;                                   "text;" or ";back" = one user colour set, no change to other
;                                   ";" or ""          = reset both to default colours
;                  $iRow      - Row index (0-based)
;                  $iCol      - Column index (0-based)
; Requirement(s).: v3.3.10 +
; Return values .: Success: Returns 1
;                  Failure: Returns 0 and sets @error as follows:
;                      1 = Invalid index
;                      2 = Not user colour enabled
;                      3 = Invalid colour
;                      4 - Invalid row/col
; Author ........: Melba23
; Modified ......:
; Remarks .......:
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_SetColour($iLV_Index, $sColSet, $iRow, $iCol)

	; Activate the ListView
	_GUIListViewEx_SetActive($iLV_Index)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	; Check ListView is user colour enabled
	If Not $aGLVEx_Data[$iLV_Index][19] Then
		Return SetError(2, 0, 0)
	EndIf
	; Check colour
	If $sColSet = "" Then
		$sColSet = ";"
	EndIf
	; Check for default colour setting and set flag
	Local $fDefCol = (($sColSet = ";") ? (True) : (False))
	; Check for valid colour strings
	If Not StringRegExp($sColSet, "^(\Q0x\E[0-9A-Fa-f]{6})?;(\Q0x\E[0-9A-Fa-f]{6})?$") Then
		Return SetError(3, 0, 0)
	EndIf
	; Load current array
	Local $aColArray = $aGLVEx_Data[$iLV_Index][18]
	; Check position exists in ListView
	If $iRow < 0 Or $iCol < 0 Or $iRow > UBound($aColArray) - 2 Or $iCol > UBound($aColArray, 2) - 1 Then
		Return SetError(4, 0, 0)
	EndIf
	; Current colour
	Local $aCurrSplit = StringSplit($aColArray[$iRow + 1][$iCol], ";")
	; New colour
	Local $aNewSplit = StringSplit($sColSet, ";")
	; Replace if required
	For $i = 1 To 2
		If $aNewSplit[$i] Then
			; Convert to BGR
			$aCurrSplit[$i] = '0x' & StringMid($aNewSplit[$i], 7, 2) & StringMid($aNewSplit[$i], 5, 2) & StringMid($aNewSplit[$i], 3, 2)
		EndIf
		If $fDefCol Then
			; Reset default
			$aCurrSplit[$i] = ""
		EndIf
	Next
	; Store new colour
	$aColArray[$iRow + 1][$iCol] = $aCurrSplit[1] & ";" & $aCurrSplit[2]
	; Store amended array
	$aGLVEx_Data[$iLV_Index][18] = $aColArray

	; Force reload of redraw colour array
	$aGLVEx_Data[0][14] = 0
	; Redraw listView item to show colour
	_GUICtrlListView_RedrawItems($aGLVEx_Data[$iLV_Index][0], $iRow, $iRow)

	Return 1

EndFunc   ;==>_GUIListViewEx_SetColour

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_BlockReDraw
; Description ...: Prevents ListView redrawing during looped Insert/Delete/Change calls
; Syntax.........: _GUIListViewEx_BlockReDraw($iLV_Index, $fMode)
; Parameters ....: $iLV_Index - Index number of ListView as returned by _GUIListViewEx_Init
;                  $fMode     - True  = Prevent redrawing during Insert/Delete/Change calls
;                             - False = Allow future redrawing and force a redraw
; Requirement(s).: v3.3.10 +
; Return values .: Success: 1
;                  Failure: 0 and sets @error as follows:
;                           1 - Invalid ListView Index
;                           2 - Invalid $fMode
; Author ........: Melba23
; Modified ......:
; Remarks .......: Allows multiple items to be inserted/deleted/changed programatically without redrawing the ListView
;                  after each call. When block removed, ListView is redrawn to update with new content
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_BlockReDraw($iLV_Index, $bMode)

	; Check valid index
	If $iLV_Index < 1 Or $iLV_Index > $aGLVEx_Data[0][0] Then
		Return SetError(1, 0, 0)
	EndIf
	Switch $bMode
		Case True
			; Clear redraw flag
			$aGLVEx_Data[0][15] = False

		Case False
			; Set redraw flag
			$aGLVEx_Data[0][15] = True
			; Force ListView redraw to current content
			Local $aData_Array = $aGLVEx_Data[$iLV_Index][2]
			Local $aCheck_Array[UBound($aData_Array)]
			For $i = 1 To UBound($aCheck_Array) - 1
				$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $i - 1)
			Next
			__GUIListViewEx_ReWriteLV($aGLVEx_Data[$iLV_Index][0], $aData_Array, $aCheck_Array, $iLV_Index, $aGLVEx_Data[$iLV_Index][6])

		Case Else
			Return SetError(2, 0, 0)
	EndSwitch
	Return 1

EndFunc   ;==>_GUIListViewEx_BlockReDraw

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_UserSort
; Description ...: Sets user defined sort function for specified columns
; Syntax.........: _GUIListViewEx_UserSort($iLV_Index, $vCol [, $hFunc = -1])
; Parameters ....: $iLV_Index - Index number of ListView as returned by _GUIListViewEx_Init
;                  $vCol      - Column of ListView to set (string or single number)
;                                   All columns: "*"
;                                   Range string example: "1;2;5-6;8-9;10" - expanded automatically
;                  $hFunc     - User function as object - set to -1 for no sort (default)
; Requirement(s).: v3.3.10 +
; Return values .: Success: 1
;                  Failure: 0 and sets @error as follows:
;                             1 - Invalid ListView Index
;                             2 - ListView not sortable
;                             3 - Invalid column parameter
;                             4 - Invalid function object
; Author ........: Melba23
; Modified ......:
; Remarks .......: If function not specified for a column then default sort function used (standard _ArraySort)
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_UserSort($iLV_Index, $vCol, $hFunc = -1)

	; Check valid index
	If $iLV_Index < 1 Or $iLV_Index > $aGLVEx_Data[0][0] Then
		Return SetError(1, 0, 0)
	EndIf
	; Check if ListView sortable
	If Not (IsArray($aGLVEx_Data[$iLV_Index][4])) Then
		Return SetError(2, 0, 0)
	EndIf
	; Check column index
	Local $aRange = __GUIListViewEx_ExpandRange($vCol, $iLV_Index)
	If @error Then Return SetError(3, 0, 0)
	; Check function object (or none)
	If Not ($hFunc = -1) And Not (IsFunc($hFunc)) Then
		Return SetError(4, 0, 0)
	EndIf

	; Extract, amend and store editable array
	Local $aEditable = $aGLVEx_Data[$iLV_Index][7]
	For $i = 1 To $aRange[0]
		$aEditable[3][$aRange[$i]] = $hFunc
	Next
	$aGLVEx_Data[$iLV_Index][7] = $aEditable

	Return 1

EndFunc   ;==>_GUIListViewEx_UserSort

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_GetLastSelItem
; Description ...: Get last selected item in active or specified ListView
; Syntax.........: _GUIListViewEx_GetLastSelItem($iLV_Index = 0)
; Parameters ....: $iLV_Index - Index of ListView as returned by _GUIListViewEx_Init
;                                 0 = currently active ListView (default)
; Requirement(s).: v3.3.10 +
; Return values .: Success: Delimited string ListViewIndex|Row|Col
;                  Failure: Returns "" and sets @error as follows:
;                      1 = No ListView currently active
;                      2 = Invalid index
;                      3 = No item yet selected in active or specified ListView
; Author ........: Melba23
; Modified ......:
; Remarks .......: If multiple items are selected, only the last selected is returned
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_GetLastSelItem($iLV_Index = 0)

	; Check valid index
	Switch $iLV_Index
		Case 1 To $aGLVEx_Data[0][0]
			; Valid index
		Case 0, Default
			; Get active ListView
			$iLV_Index = _GUIListViewEx_GetActive()
			; If no ListView active
			If $iLV_Index = 0 Then Return SetError(1, 0, "")
		Case Else
			Return SetError(2, 0, "")
	EndSwitch

	; Read last selected item
	Local $iRow = $aGLVEx_Data[$iLV_Index][20]
	Local $iCol = $aGLVEx_Data[$iLV_Index][21]
	; Check selection has been made
	If $iRow = -1 Or $iCol = -1 Then Return SetError(3, 0, "")
	; Return selection details
	Return $iLV_Index & "|" & $iRow & "|" & $iCol

EndFunc   ;==>_GUIListViewEx_GetLastSelItem

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_ContextPos
; Description ...: Returns index and row/col of last right click
; Syntax.........: _GUIListViewEx_ContextPos()
; Parameters ....: None
; Requirement(s).: v3.3.10 +
; Return values .: Success: Returns 3 element array: [ListView_index, Row, Column]
; Author ........: Melba23
; Modified ......:
; Remarks .......: Allows user colours to be set via a context menu
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_ContextPos()

	Local $aPos[3] = [$aGLVEx_Data[0][1], $aGLVEx_Data[0][10], $aGLVEx_Data[0][11]]
	Return $aPos

EndFunc   ;==>_GUIListViewEx_ContextPos

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_ToolTipInit
; Description ...: Defines column(s) which will display a tooltip when clicked
; Syntax.........: _GUIListViewEx_ToolTipInit($iLV_Index, $vRange [, $iTime = 1000 ], $iMode = 1]])
; Parameters ....: $iLV_Index - Index of ListView holding columns
;                  $vRange    - Range of columns - see remarks
;                  $iTime     - Time for tooltip to display (default = 1000)
;                  $iMode     - Display: 1 (default) = cell content, 2 = 0 column
; Requirement(s).: v3.3.10 +
; Return values .: Success: Returns 1
;                  Failure: Returns 0 and sets @error as follows:
;                      1 = Invalid index
;                      2 = Invalid range
;                      3 = Invalid time
; Author ........: Melba23
; Modified ......:
; Remarks .......: - Function is designed to show:
;                      Mode 1: ListView content if column is too narrow for data within
;                      Mode 2: 0 column data to allow for row identification when ListView right scrolled
;                  - $vRange is a string containing the rows which show tooltips.
;                      It can be a single number or a range separated by a hyphen (-).
;                      Multiple items are separated by a semi-colon (;).
;                      "*" = all columns
;                  - _GUIListViewEx_EventMonitor must be placed in the script idle loop for the tooltips to display
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_ToolTipInit($iLV_Index, $vRange, $iTime = 1000, $iMode = 1)

	; Check valid parameters
	If $iLV_Index < 0 Or $iLV_Index > $aGLVEx_Data[0][0] Then Return SetError(1, 0, 0)
	Local $aRange = __GUIListViewEx_ExpandRange($vRange, $iLV_Index)
	If @error Then Return SetError(2, 0, 0)
	If Not IsInt($iTime) Then Return SetError(3, 0, 0)

	; Store data
	$aGLVEx_Data[$iLV_Index][15] = $aRange
	$aGLVEx_Data[$iLV_Index][16] = $iTime
	$aGLVEx_Data[$iLV_Index][17] = $iMode

	Return 1

EndFunc   ;==>_GUIListViewEx_ToolTipInit

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_EventMonitor
; Description ...: Check for edit, sort, drag/drop and tooltip events - auto colour redraw - returns event results
; Syntax.........: _GUIListViewEx_EventMonitor([$iEditMode = 0[, $iDelta_X = 0[, $iDelta_Y = 0]]])
; Parameters ....: $iEditMode - Only used if editing cells as simple text:
;                                    Return after single edit - 0 (default)
;                                    {TAB} and ctrl-arrow keys move to next item - 2-digit code (row mode/column mode)
;                                        0 = Cannot move
;                                        1 = Reaching edge terminates edit process
;                                        2 = Reaching edge remains in place
;                                        3 = Reaching edge loops to opposite edge
;                               	     Positive value = ESC abandons current edit only, previous edits remain
;                                        Negative value = ESC resets all edits in current session
;                  $iDelta_X  - Permits fine adjustment of edit control in X axis if needed
;                  $iDelta_Y  - Permits fine adjustment of edit control in Y axis if needed
; Requirement(s).: v3.3.10 +
; Return values .: Success:
;                  No UDF events detected: Empty string and @extended set to 0
;                  Return value is not an empty string, while @extended indicates type of event detected
;                    @extended = 1 - Cell(s) edit event
;                                      Returns 2D array of items edited
;                                          - Total number of edits in [0][0] element, with each edit following:
;                                          - [zero-based row][zero-based column][original content][new content]
;                                2 - Header edit event
;                                      Returns single row 2D array
;                                          - [column edited][original header text][new header text]
;                                3 - ListView sort event
;                                      Returns index number of newly sorted ListView
;                                4 - Drag/drop event
;                                      Returns colon-separated index numbers of "drag" and "drop" ListViews
;                                5-8 (Not used at present)
;                                9 - User selection change event
;                                      Returns 3-element 1D array
;                                          - [ListView index, zero-based row, zero-based col]
;                  Failure: Sets @error as follows when editing:
;                      1 - Invalid EditMode parameter
;                      2 - Empty ListView
;                      3 - Column not editable
; Author ........: Melba23
; Modified ......:
; Remarks .......: - This function must be placed within the script idle loop.
;                  - Editing cells:
;                      - Using edit mode 1-3:
;                        - Once item edit process started, all other script activity is suspended until following occurs:
;                          {ENTER}  = Current edit confirmed and editing process ended
;                          {ESCAPE} = Current or all edits cancelled and editing process ended
;                          If $iEditMode non-zero then {TAB} and ctrl-arrow keys =
;                              For edit controls: Current edit confirmed & continue editing
;                              For cother controls: Current edit cancelled & continue editing
;                          If using Edit control:
;                              Click outside edit = Editing process ends and
;                                  If $iAdded + 4 : Current edit accepted
;                                  Else           : Current edit cancelled
;                          If using Combo control:
;                              Combo actioned     = Combo selection accepted and editing process ended
;                              Click outside edit = Edit process ended and editing process ended
;                          If using DTP control:
;                              only {ENTER} & {ESCAPE} will end edit
;                        The function only returns an array after an edit process launched by a double-click.  If no
;                        double-click has occurred, the function returns an empty string.  The user should check that a
;                        valid array is present before attempting to access it.
;                    - Using edit mode 9
;                        The function will return the same return values as set by the user-defined function
;                    - If "continue edit on triple click elsewhere" ($iAdded = 4) option is set when ListView intitiated
;                      the function returns an array after each edit.
;                  - Editing header
;                      Only {ENTER}, {ESCAPE} and mouse click are actioned - single edit only
;                  - Returned array allows verification of new value(s) and _GUIListViewEx_ChangeItem can reset original value
;=====================================================================================================================
Func _GUIListViewEx_EventMonitor($iEditMode = 0, $iDelta_X = 0, $iDelta_Y = 0)

	Local $aRet, $vRet, $iLV_Index, $iError

	; Check for a cell Edit double click event
	If $fGLVEx_EditClickFlag <> 0 Then

		; Set active ListView
		$iLV_Index = $fGLVEx_EditClickFlag
		$aGLVEx_Data[0][1] = $iLV_Index

		; Clear flag
		$fGLVEx_EditClickFlag = 0

		; Check Type parameter
		Switch Abs($iEditMode)
			Case 0, 01, 02, 03, 10, 11, 12, 13, 20, 21, 22, 23, 30, 31, 32, 33     ; Single edit or both axes set to valid parameter
				; Allow
			Case Else
				Return SetError(1, 0, "")
		EndSwitch

		; Get clicked item info
		Local $aLocation[2] = [$aGLVEx_Data[0][17], $aGLVEx_Data[0][18]]
		; Check valid row
		If $aLocation[0] = -1 Then
			Return SetError(2, 0, "")
		EndIf
		; Check for valid editable column
		Local $aEditable = $aGLVEx_Data[$iLV_Index][7]
		; If column not selected as mouse not used...
		If $aLocation[1] = -1 Then
			; ...find first editable column
			For $i = 0 To UBound($aEditable, 2) - 1
				If $aEditable[0][$i] <> 0 Then
					$aLocation[1] = $i
					$aGLVEx_Data[0][18] = $i
					ExitLoop
				EndIf
			Next
		EndIf

		Switch $aEditable[0][$aLocation[1]]
			Case 0     ; Not editable
				Return SetError(3, 0, "")

			Case 9     ; User-defined function
				; Extract user function
				Local $hUserFunction = $aEditable[1][$aLocation[1]]
				; Pass function 4 parameters (LV handle, UDF LV index, row, col)
				$vRet = $hUserFunction($hGLVEx_SrcHandle, $iLV_Index, $aLocation[0], $aLocation[1])
				; Return function return values
				Return SetError(@error, @extended, $vRet)

			Case Else
				; Start edit
				$aRet = __GUIListViewEx_EditProcess($iLV_Index, $aLocation, $iDelta_X, $iDelta_Y, $iEditMode)
				$iError = @error
				; Check if edits occurred
				If IsArray($aRet) And $aRet[0][0] Then
					; Return result array
					Return SetError($iError, 1, $aRet)
				Else
					; Return empty string
					Return SetError($iError, 1, "")
				EndIf
		EndSwitch
	EndIf

	; Check for a header Edit Ctrl-click
	If $fGLVEx_HeaderEdit Then
		; Clear the flag
		$fGLVEx_HeaderEdit = False
		; Wait until mouse button released as click occurs outside the control or Ctrl key still pressed
		_WinAPI_GetAsyncKeyState(0x01)
		While _WinAPI_GetAsyncKeyState(0x01) Or _WinAPI_GetAsyncKeyState(0x11)
			Sleep(10)
		WEnd
		; Edit header using the default values set by the handler
		$aRet = _GUIListViewEx_EditHeader()
		$iError = @error
		; Check for edit
		If IsArray($aRet) Then
			; Return result array
			Return SetError($iError, 2, $aRet)
		Else
			; Return empty string
			Return SetError($iError, 2, "")
		EndIf
	EndIf

	; Check for a Sort event
	If $aGLVEx_Data[0][19] Then
		; Save Sort event return
		$vRet = $aGLVEx_Data[0][19]
		; Clear flag
		$aGLVEx_Data[0][19] = ""
		;Check for colour event
		If $aGLVEx_Data[0][22] = 1 Then
			; Redraw ListView and reset flag
			__GUIListViewEx_RedrawWindow($vRet, True)
			$aGLVEx_Data[0][22] = 0
		EndIf
		Return SetError(0, 3, $vRet)
	EndIf

	; Check for a Drag event
	If $sGLVEx_DragEvent Then
		$vRet = $sGLVEx_DragEvent
		; Clear flag
		$sGLVEx_DragEvent = ""
		;Check for colour event
		If $aGLVEx_Data[0][22] Then
			; Redraw ListView(s) and reset flag
			Local $aIndex = StringSplit($vRet, ":")
			__GUIListViewEx_RedrawWindow($aIndex[1], True)
			If $aIndex[2] <> $aIndex[1] Then
				__GUIListViewEx_RedrawWindow($aIndex[2], True)
			EndIf
			$aGLVEx_Data[0][22] = 0
		EndIf

		; Return drag/drop index string
		Return SetError(0, 4, $vRet)
	EndIf

	; Check if tooltips initiated
	Local $iMode = $aGLVEx_Data[$aGLVEx_Data[0][1]][17]
	If $iMode Then
		$iLV_Index = $aGLVEx_Data[0][1]
		Local $fToolTipCol = False
		; Get active cell if single cell selection
		If $aGLVEx_Data[$iLV_Index][21] Then
			$aGLVEx_Data[0][4] = $aGLVEx_Data[0][17]
			$aGLVEx_Data[0][5] = $aGLVEx_Data[0][18]
		EndIf
		; If new item clicked
		If $aGLVEx_Data[0][4] <> $aGLVEx_Data[0][6] Or $aGLVEx_Data[0][5] <> $aGLVEx_Data[0][7] Then
			; Check range
			If $aGLVEx_Data[$iLV_Index][15] = "*" Then
				$fToolTipCol = True
			Else
				If IsArray($aGLVEx_Data[$iLV_Index][15]) Then
					Local $vRange = $aGLVEx_Data[$iLV_Index][15]
					For $i = 1 To $vRange[0]
						; If initiated column
						If $aGLVEx_Data[0][2] = $vRange[$i] Then
							$fToolTipCol = True
							ExitLoop
						EndIf
					Next
				EndIf
			EndIf
		EndIf
		If $fToolTipCol Then
			; Read all row text
			Local $aItemText = _GUICtrlListView_GetItemTextArray($aGLVEx_Data[$iLV_Index][0], $aGLVEx_Data[0][4])
			If Not @error Then
				Local $sText
				Switch $iMode
					Case 1
						$sText = $aItemText[$aGLVEx_Data[0][5] + 1]
					Case 2
						$sText = $aItemText[1]
				EndSwitch
				; Create ToolTip
				ToolTip($sText)
				; Set up clearance
				AdlibRegister("__GUIListViewEx_ToolTipHide", $aGLVEx_Data[$iLV_Index][16])
				; Store location to prevent repeat showing
				$aGLVEx_Data[0][6] = $aGLVEx_Data[0][4]
				$aGLVEx_Data[0][7] = $aGLVEx_Data[0][5]
			EndIf
		EndIf
	EndIf

	; Check for selection change
	If $fGLVEx_SelChangeFlag Then
		; Get selecton data
		Local $aRetArray[3] = [$fGLVEx_SelChangeFlag, $aGLVEx_Data[0][17], $aGLVEx_Data[0][18]]
		; Clear flag
		$fGLVEx_SelChangeFlag = 0
		; Check if user selection
		If $fGLVEx_UserSelFlag Then
			; Clear flag
			$fGLVEx_UserSelFlag = 0
			; Return selection data
			Return SetError(0, 9, $aRetArray)
		EndIf
	EndIf

	; If no events
	Return SetError(0, 0, "")

EndFunc   ;==>_GUIListViewEx_EventMonitor

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_MsgRegister
; Description ...: Registers Windows messages required for the UDF
; Syntax.........: _GUIListViewEx_MsgRegister([$fNOTIFY = True, [$fMOUSEMOVE = True, [$fLBUTTONUP = True, [ $fSYSCOMMAND = True]]]])
; Parameters ....: $fNOTIFY     - True = Register WM_NOTIFY message
;                  $fMOUSEMOVE  - True = Register WM_MOUSEMOVE message
;                  $fLBUTTONUP  - True = Register WM_LBUTTONUP message
;                  $fSYSCOMMAND - True = Register WM_SYSCOMAMND message
; Requirement(s).: v3.3.10 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If message handlers already registered, then call the relevant handler function from within that handler
;                  WM_NOTIFY handler required for all UDF functions
;                  WM_MOUSEMOVE and WM_LBUTTONUP handlers required for drag
;                  WM_SYSCOMMAND required for single click [X] GUI closure while editing
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_MsgRegister($fNOTIFY = True, $fMOUSEMOVE = True, $fLBUTTONUP = True, $fSYSCOMMAND = True)

	; Register required messages
	If $fNOTIFY Then GUIRegisterMsg(0x004E, "_GUIListViewEx_WM_NOTIFY_Handler")     ; $WM_NOTIFY
	If $fMOUSEMOVE Then GUIRegisterMsg(0x0200, "_GUIListViewEx_WM_MOUSEMOVE_Handler")     ; $WM_MOUSEMOVE
	If $fLBUTTONUP Then GUIRegisterMsg(0x0202, "_GUIListViewEx_WM_LBUTTONUP_Handler")     ; $WM_LBUTTONUP
	If $fSYSCOMMAND Then GUIRegisterMsg(0x0112, "_GUIListViewEx_WM_SYSCOMMAND_Handler")     ; $WM_SYSCOMMAND

EndFunc   ;==>_GUIListViewEx_MsgRegister

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_WM_NOTIFY_Handler
; Description ...: Windows message handler for WM_NOTIFY
; Syntax.........: _GUIListViewEx_WM_NOTIFY_Handler()
; Requirement(s).: v3.3.10 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If a WM_NOTIFY handler already registered, then call this function from within that handler
;                  If user colours are enabled, the handler return value must be returned on handler exit
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_WM_NOTIFY_Handler($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam

	Local $dwDrawStage, $iCol, $aHdrData

	; Struct = $tagNMHDR and "int Item;int SubItem" from $tagNMLISTVIEW
	Local $tStruct = DllStructCreate("hwnd;uint_ptr;int_ptr;int;int", $lParam)
	If @error Then Return

	Local $hLV = DllStructGetData($tStruct, 1)
	Local $iItem = DllStructGetData($tStruct, 4)
	Local $iCode = BitAND(DllStructGetData($tStruct, 3), 0xFFFFFFFF)

	; Deal with drawing quickly
	If $iCode = -12 Then     ; $NM_CUSTOMDRAW

		; Prevent redraw if still changing ListView arrays
		If $aGLVEx_Data[0][12] Then Return

		; Check if enabled ListView
		For $iLV_Index = 1 To $aGLVEx_Data[0][0]
			If $aGLVEx_Data[$iLV_Index][0] = DllStructGetData($tStruct, 1) Then
				ExitLoop
			EndIf
		Next

		; It is an enabled ListView
		If $iLV_Index <= $aGLVEx_Data[0][0] Then

			Local Static $aDefCols = $aGLVEx_DefColours

			; Check if ListView to be redrawn has changed
			If $aGLVEx_Data[0][14] <> DllStructGetData($tStruct, 1) Then
				; Store new handle
				$aGLVEx_Data[0][14] = DllStructGetData($tStruct, 1)
				If $aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22] Then
					; Copy new colour array
					$aGLVEx_Data[0][13] = $aGLVEx_Data[$iLV_Index][18]
					; Set new default colours
					$aDefCols = $aGLVEx_Data[$iLV_Index][23]
				EndIf
			EndIf
			; If colour or single cell selection
			If $aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22] Then
				Local $tNMLVCUSTOMDRAW = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
				$dwDrawStage = DllStructGetData($tNMLVCUSTOMDRAW, "dwDrawStage")
				Switch $dwDrawStage     ; Holds a value that specifies the drawing stage
					Case 1     ; $CDDS_PREPAINT
						; Before the paint cycle begins
						Return 32     ; $CDRF_NOTIFYITEMDRAW - Notify the parent window of any item-related drawing operations

					Case 65537     ; $CDDS_ITEMPREPAINT
						; Before painting an item
						Return 32     ; $CDRF_NOTIFYSUBITEMDRAW - Notify the parent window of any subitem-related drawing operations

					Case 196609     ; BitOR($CDDS_ITEMPREPAINT, $CDDS_SUBITEM)
						; Before painting a subitem
						$iItem = DllStructGetData($tNMLVCUSTOMDRAW, "dwItemSpec")     ; Row index
						Local $iSubItem = DllStructGetData($tNMLVCUSTOMDRAW, "iSubItem")     ; Column index
						; Check if selected row
						Local $bSelColour = False
						If $iItem = $aGLVEx_Data[$iLV_Index][20] Then
							; If single sel also check for column
							If $aGLVEx_Data[$iLV_Index][22] Then
								If $iSubItem = $aGLVEx_Data[$iLV_Index][21] Then
									$bSelColour = True
								EndIf
							Else
								$bSelColour = True
							EndIf
						EndIf
						; Set default colours
						Local $iTextColour = $aDefCols[0]
						Local $iBackColour = $aDefCols[1]
						; Set selected colours if required
						If $bSelColour Then
							; Set selected item colours
							$iTextColour = $aDefCols[2]
							$iBackColour = $aDefCols[3]
						Else
							; If colour enabled
							If $aGLVEx_Data[$iLV_Index][19] Then
								; Check for user colours
								If StringInStr(($aGLVEx_Data[0][13])[$iItem + 1][$iSubItem], ";") Then
									; Get required user colours
									Local $aSplitColour = StringSplit(($aGLVEx_Data[0][13])[$iItem + 1][$iSubItem], ";")
									If $aSplitColour[1] Then $iTextColour = $aSplitColour[1]
									If $aSplitColour[2] Then $iBackColour = $aSplitColour[2]
								EndIf
							EndIf
						EndIf

						; Set required colours
						DllStructSetData($tNMLVCUSTOMDRAW, "ClrText", $iTextColour)
						DllStructSetData($tNMLVCUSTOMDRAW, "ClrTextBk", $iBackColour)
						Return 2     ; $CDRF_NEWFONT must be returned after changing font or colors
				EndSwitch
			EndIf

		Else

			; Check if colour enabled header
			For $iLV_Index = 1 To $aGLVEx_Data[0][0]
				If DllStructGetData($tStruct, 1) = $aGLVEx_Data[$iLV_Index][24] Then
					ExitLoop
				EndIf
			Next
			; It is a colour enabled header
			If $iLV_Index <= $aGLVEx_Data[0][0] Then

				Local $tNMCustomDraw = DllStructCreate($tagNMLVCUSTOMDRAW, $lParam)
				Local $hDC = DllStructGetData($tNMCustomDraw, "hdc")

				; Check if ListView to be redrawn has changed
				If $aGLVEx_Data[0][20] <> DllStructGetData($tStruct, 1) Then
					; Store new handle
					$aGLVEx_Data[0][20] = DllStructGetData($tStruct, 1)
					; Get header font
					Local $hFont = _SendMessage(DllStructGetData($tStruct, 1), 0x0031)     ; $WM_GETFONT
					Local $hObject = _WinAPI_SelectObject($hDC, $hFont)
					Local $tLogFont = DllStructCreate($tagLOGFONT)
					; Get header font
					_WinAPI_GetObject($hFont, DllStructGetSize($tLogFont), DllStructGetPtr($tLogFont))
					_WinAPI_SelectObject($hDC, $hObject)
					_WinAPI_ReleaseDC(DllStructGetData($tStruct, 1), $hDC)
					; Set to medium weight
					DllStructSetData($tLogFont, "Weight", 600)     ; $FW_SEMIBOLD
					; Store font handle
					$aGLVEx_Data[0][21] = _WinAPI_CreateFontIndirect($tLogFont)
				EndIf

				; Check drawing stage
				$dwDrawStage = DllStructGetData($tNMCustomDraw, "dwDrawStage")
				Switch $dwDrawStage
					Case 1     ; $CDDS_PREPAINT ; Before the paint cycle begins
						Return 32     ; $CDRF_NOTIFYITEMDRAW ; Notify parent window of coming item related drawing operations

					Case 65537     ; $CDDS_ITEMPREPAINT ; Before an item is drawn: Default painting (frames and background)
						Return 0x00000010     ; $CDRF_NOTIFYPOSTPAINT ; Notify parent window of coming post item related drawing operations

					Case 0x00010002     ; $CDDS_ITEMPOSTPAINT ; After an item is drawn: Custom painting
						Local $iColumnIndex = DllStructGetData($tNMCustomDraw, "dwItemSpec")     ; Column
						$aHdrData = $aGLVEx_Data[$iLV_Index][25]     ; Header data
						Local $aColSplit = StringSplit($aHdrData[1][$iColumnIndex], ";")
						; Set default colours
						Local $aHdrDefCols = $aGLVEx_Data[$iLV_Index][23]
						Local $iHdrTextColour, $iHdrBackColour
						; Set user or default colours
						If $aColSplit[1] == "" Then
							$iHdrTextColour = $aHdrDefCols[0]
						Else
							$iHdrTextColour = $aColSplit[1]
						EndIf
						If $aColSplit[2] == "" Then
							$iHdrBackColour = $aHdrDefCols[1]
						Else
							$iHdrBackColour = $aColSplit[2]
						EndIf
						; Set header section size
						Local $tRECT = DllStructCreate($tagRECT)
						DllStructSetData($tRECT, 1, DllStructGetData($tNMCustomDraw, 6) + 1)
						DllStructSetData($tRECT, 2, DllStructGetData($tNMCustomDraw, 7) + 1)
						DllStructSetData($tRECT, 3, DllStructGetData($tNMCustomDraw, 8) - 2)
						DllStructSetData($tRECT, 4, DllStructGetData($tNMCustomDraw, 9) - 2)
						; Set transparent background
						_WinAPI_SetBkMode($hDC, 1)     ; $TRANSPARENT
						; Set text font and colour
						_WinAPI_SelectObject($hDC, $aGLVEx_Data[0][21])
						_WinAPI_SetTextColor($hDC, $iHdrTextColour)
						; Set and draw back colour
						Local $hBrush = _WinAPI_CreateSolidBrush($iHdrBackColour)
						_WinAPI_FillRect($hDC, $tRECT, $hBrush)
						; Write text
						If $iColumnIndex < _GUICtrlListView_GetColumnCount($aGLVEx_Data[$iLV_Index][0]) Then
							; Get column alignment
							Local $aRet = _GUICtrlListView_GetColumn($aGLVEx_Data[$iLV_Index][0], $iColumnIndex)
							Local $iColAlign = 2 * $aRet[0]
							_WinAPI_DrawText($hDC, $aHdrData[0][$iColumnIndex], $tRECT, $iColAlign)
						EndIf
						Return 2     ; $CDRF_NEWFONT must be returned after changing font or colors
				EndSwitch
			EndIf
		EndIf

	Else     ; Not a drawing message

		; Flag to indicate use of Edit HotKey
		Local $fEditHotKey = False

		; Check if enabled ListView
		For $iLV_Index = 1 To $aGLVEx_Data[0][0]
			If $aGLVEx_Data[$iLV_Index][0] = DllStructGetData($tStruct, 1) Then
				ExitLoop
			EndIf
		Next

		Local $iRow

		; It is an enabled ListView
		If $iLV_Index <= $aGLVEx_Data[0][0] Then

			; Check if changed from current ListView
			If $iLV_Index <> $aGLVEx_Data[0][1] Then
				; Reset current index and row/column data
				$aGLVEx_Data[0][1] = $iLV_Index
				$aGLVEx_Data[0][17] = $aGLVEx_Data[$iLV_Index][20]
				$aGLVEx_Data[0][18] = $aGLVEx_Data[$iLV_Index][21]
			EndIf

			; Check message
			Switch $iCode

				Case $LVN_BEGINSCROLL

					; if editing then abandon
					If $cGLVEx_EditID <> 9999 Then
						; Delete temp edit control and set placeholder
						GUICtrlDelete($cGLVEx_EditID)
						$cGLVEx_EditID = 9999
						; Reactivate ListView
						WinSetState($hGLVEx_Editing, "", @SW_ENABLE)
					EndIf

				Case $LVN_BEGINDRAG

					; Check if drag permitted for this ListView
					If Not BitAND($aGLVEx_Data[$iLV_Index][12], 8) Then

						; Set values for this ListView
						$aGLVEx_Data[0][1] = $iLV_Index

						; Store source & target ListView data for eventual inter-LV drag
						$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
						$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]
						$iGLVEx_SrcIndex = $iLV_Index
						$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
						$hGLVEx_TgtHandle = $hGLVEx_SrcHandle
						$cGLVEx_TgtID = $cGLVEx_SrcID
						$iGLVEx_TgtIndex = $iGLVEx_SrcIndex
						$aGLVEx_TgtArray = $aGLVEx_SrcArray

						; Copy array for manipulation
						$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]

						; Set drag image flag
						Local $fImage = $aGLVEx_Data[$iLV_Index][5]

						; Check if Native or UDF and set focus
						If $cGLVEx_SrcID Then
							GUICtrlSetState($cGLVEx_SrcID, 256)     ; $GUI_FOCUS
						Else
							_WinAPI_SetFocus($hGLVEx_SrcHandle)
						EndIf

						; Get dragged item index
						$iGLVEx_DraggedIndex = DllStructGetData($tStruct, 4)     ; Item
						; Set dragged item count
						$iGLVEx_Dragging = 1

						; Check for selected items
						Local $iIndex
						; Check if colour or single cell selection enabled
						If $aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22] Then
							; Use stored value
							$iIndex = $aGLVEx_Data[$iLV_Index][20]
						Else
							; Check actual values
							$iIndex = _GUICtrlListView_GetSelectedIndices($hGLVEx_SrcHandle)
						EndIf
						; Check if item is part of a multiple selection
						If StringInStr($iIndex, $iGLVEx_DraggedIndex) And StringInStr($iIndex, "|") Then
							; Extract all selected items
							Local $aIndex = StringSplit($iIndex, "|")
							For $i = 1 To $aIndex[0]
								If $aIndex[$i] = $iGLVEx_DraggedIndex Then ExitLoop
							Next
							; Now check for consecutive items
							If $i <> 1 Then     ; Up
								For $j = $i - 1 To 1 Step -1
									; Consecutive?
									If $aIndex[$j] <> $aIndex[$j + 1] - 1 Then ExitLoop
									; Adjust dragged index to this item
									$iGLVEx_DraggedIndex -= 1
									; Increase number to drag
									$iGLVEx_Dragging += 1
								Next
							EndIf
							If $i <> $aIndex[0] Then     ; Down
								For $j = $i + 1 To $aIndex[0]
									; Consecutive
									If $aIndex[$j] <> $aIndex[$j - 1] + 1 Then ExitLoop
									; Increase number to drag
									$iGLVEx_Dragging += 1
								Next
							EndIf
						Else     ; Either no selection or only a single
							; Set flag
							$iGLVEx_Dragging = 1
						EndIf

						; Remove all highlighting
						_GUICtrlListView_SetItemSelected($hGLVEx_SrcHandle, -1, False)

						; Create drag image
						If $fImage Then
							Local $aImageData = _GUICtrlListView_CreateDragImage($hGLVEx_SrcHandle, $iGLVEx_DraggedIndex)
							$hGLVEx_DraggedImage = $aImageData[0]
							_GUIImageList_BeginDrag($hGLVEx_DraggedImage, 0, 0, 0)
						EndIf

					EndIf

				Case $LVN_COLUMNCLICK, -2     ; $NM_CLICK

					; Set values for active ListView
					$aGLVEx_Data[0][1] = $iLV_Index
					$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
					$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]
					; Get and store row index
					$iRow = DllStructGetData($tStruct, 4)
					$aGLVEx_Data[0][4] = $iRow
					$aGLVEx_Data[0][17] = $iRow
					$aGLVEx_Data[$iLV_Index][20] = $iRow
					; Get and store column index
					$iCol = DllStructGetData($tStruct, 5)
					; Tooltip use
					$aGLVEx_Data[0][2] = $iCol
					; Normal use
					$aGLVEx_Data[0][5] = $iCol
					$aGLVEx_Data[0][18] = $iCol
					$aGLVEx_Data[$iLV_Index][21] = $iCol
					; If a column was clicked
					If $iCode = $LVN_COLUMNCLICK Then
						; Load editable column array
						Local $aEditable = $aGLVEx_Data[$iLV_Index][7]

						; Scroll column into view
						; Get X coord of first item in column
						Local $aRect = _GUICtrlListView_GetSubItemRect($hGLVEx_SrcHandle, 0, $iCol)
						; Get col width
						Local $aLV_Pos = WinGetPos($hGLVEx_SrcHandle)
						; Scroll to left edge if all column not in view
						If $aRect[0] < 0 Or $aRect[2] > $aLV_Pos[2] - $aGLVEx_Data[0][8] Then     ; Reduce by scrollbar width
							_GUICtrlListView_Scroll($hGLVEx_SrcHandle, $aRect[0], 0)
						EndIf

						; Look for Ctrl key pressed
						_WinAPI_GetAsyncKeyState(0x11)
						If _WinAPI_GetAsyncKeyState(0x11) Then
							; Check column is editable
							If $aEditable[0][$iCol] Then
								; Set header edit flag
								$fGLVEx_HeaderEdit = True
							EndIf
						Else
							; If ListView sortable
							If IsArray($aGLVEx_Data[$iLV_Index][4]) Then
								; Load array
								$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
								; Load current ListView sort state array
								Local $aLVSortState = $aGLVEx_Data[$iLV_Index][4]
								; Sort the ListView - passing a possible user sort function
								__GUIListViewEx_ColSort($hGLVEx_SrcHandle, $iLV_Index, $aLVSortState, $iCol, $aEditable[3][$iCol])
								; Store new ListView sort state array
								$aGLVEx_Data[$iLV_Index][4] = $aLVSortState
								; Reread listview items into array
								Local $iDim2 = UBound($aGLVEx_SrcArray, 2) - 1
								For $j = 1 To $aGLVEx_SrcArray[0][0]
									For $k = 0 To $iDim2
										$aGLVEx_SrcArray[$j][$k] = _GUICtrlListView_GetItemText($hGLVEx_SrcHandle, $j - 1, $k)
									Next
								Next
								; Store amended array
								$aGLVEx_Data[$iLV_Index][2] = $aGLVEx_SrcArray
								; Delete array
								$aGLVEx_SrcArray = 0
							EndIf
						EndIf
					Else
						; It was a mouseclick so set user selection flag
						$fGLVEx_UserSelFlag = 1
					EndIf

				Case $LVN_KEYDOWN

					; Determine which key pressed
					Local $tKey = DllStructCreate($tagNMHDR & ";WORD KeyCode", $lParam)
					; Store key value
					$aGLVEx_Data[0][16] = DllStructGetData($tKey, "KeyCode")
					; Check if manual edit key(s) pressed
					If __GUIListViewEx_CheckUserEditKey() Then
						; Set flag to show HotKey pressed and so struct does not give valid row/column
						$fEditHotKey = True
						ContinueCase
					EndIf

					; If single cell selection
					If $aGLVEx_Data[$iLV_Index][22] Then
						; Remove selected state
						_GUICtrlListView_SetItemSelected($hLV, $aGLVEx_Data[0][17], False)
						; Act on left/right keys
						Switch $aGLVEx_Data[0][16]
							Case 37     ; Left
								; Adjust column and prevent overrun
								If $aGLVEx_Data[0][18] > 0 Then $aGLVEx_Data[0][18] -= 1
								; Store new column
								$aGLVEx_Data[$iLV_Index][21] = $aGLVEx_Data[0][18]
								; Redraw row
								_GUICtrlListView_RedrawItems($hLV, $aGLVEx_Data[0][17], $aGLVEx_Data[0][17])
								; Set user selection and change flags
								$fGLVEx_UserSelFlag = 1
								$fGLVEx_SelChangeFlag = $iLV_Index

							Case 39     ; Right
								If $aGLVEx_Data[0][18] < _GUICtrlListView_GetColumnCount($hLV) - 1 Then $aGLVEx_Data[0][18] += 1
								$aGLVEx_Data[$iLV_Index][21] = $aGLVEx_Data[0][18]
								_GUICtrlListView_RedrawItems($hLV, $aGLVEx_Data[0][17], $aGLVEx_Data[0][17])
								; Set user selection and change flags
								$fGLVEx_UserSelFlag = 1
								$fGLVEx_SelChangeFlag = $iLV_Index

						EndSwitch
					EndIf

				Case -3     ; $NM_DBLCLK

					; Set values for active ListView
					$aGLVEx_Data[0][1] = $iLV_Index
					$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
					; Set active cell if valid struct - keypress does not set row/column fields
					If Not $fEditHotKey Then
						; Store doubleclicked item row and column
						$iRow = DllStructGetData($tStruct, 4)
						$aGLVEx_Data[0][17] = $iRow
						$aGLVEx_Data[$iLV_Index][20] = $iRow
						$iCol = DllStructGetData($tStruct, 5)
						$aGLVEx_Data[0][18] = $iCol
						$aGLVEx_Data[$iLV_Index][21] = $iCol
					EndIf
					; Copy array for manipulation
					$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
					; Set editing flag
					$fGLVEx_EditClickFlag = $iLV_Index

				Case $LVN_ITEMCHANGED

					; Remove selection state if colour or single cell selection
					If $aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22] Then
						_GUICtrlListView_SetItemSelected($hLV, $iItem, False)
					EndIf
					; If a key was used to change selection need to reset active row
					If $aGLVEx_Data[0][16] <> 0 Then
						; Check key used
						Switch $aGLVEx_Data[0][16]
							Case 38     ; Up
								If $aGLVEx_Data[0][17] > 0 Then $aGLVEx_Data[0][17] -= 1
								$aGLVEx_Data[$iLV_Index][20] = $aGLVEx_Data[0][17]
								; Set user selection flag
								$fGLVEx_UserSelFlag = 1

							Case 40     ; Down
								If $aGLVEx_Data[0][17] < _GUICtrlListView_GetItemCount($hLV) - 1 Then $aGLVEx_Data[0][17] += 1
								$aGLVEx_Data[$iLV_Index][20] = $aGLVEx_Data[0][17]
								; Set user selection flag
								$fGLVEx_UserSelFlag = 1

						EndSwitch
						; Clear key flag
						$aGLVEx_Data[0][16] = 0
					Else
						; If mouse button pressed
						_WinAPI_GetAsyncKeyState(0x01)
						If _WinAPI_GetAsyncKeyState(0x01) Then
							; Determine position of mouse within ListView
							Local $aMPos = MouseGetPos()
							Local $tPoint = DllStructCreate("int X;int Y")
							DllStructSetData($tPoint, "X", $aMPos[0])
							DllStructSetData($tPoint, "Y", $aMPos[1])
							_WinAPI_ScreenToClient($hLV, $tPoint)
							Local $aCurPos[2] = [DllStructGetData($tPoint, "X"), DllStructGetData($tPoint, "Y")]
							; Check for cell under mouse
							Local $aHitTest = _GUICtrlListView_SubItemHitTest($hLV, $aCurPos[0], $aCurPos[1])
							; If click on valid cell
							If $aHitTest[0] > -1 And $aHitTest[1] > -1 And $aHitTest[0] = $iItem Then
								; Redraw previously selected row
								If $aGLVEx_Data[0][17] <> $iItem Then _GUICtrlListView_RedrawItems($hLV, $aGLVEx_Data[0][17], $aGLVEx_Data[0][17])
								; Set new row and column
								$aGLVEx_Data[0][17] = $aHitTest[0]
								$aGLVEx_Data[0][18] = $aHitTest[1]
								$aGLVEx_Data[$iLV_Index][20] = $aGLVEx_Data[0][17]
								$aGLVEx_Data[$iLV_Index][21] = $aGLVEx_Data[0][18]
								; Redraw newly selected row
								_GUICtrlListView_RedrawItems($hLV, $iItem, $iItem)
							EndIf

							; Set user selection flag
							$fGLVEx_UserSelFlag = 1

						EndIf
					EndIf

					; Set selection change flag
					$fGLVEx_SelChangeFlag = $iLV_Index

				Case -5     ; $NM_RCLICK

					; Set active ListView
					$aGLVEx_Data[0][1] = $iLV_Index
					; Get position of right click within Listview
					$aGLVEx_Data[0][10] = DllStructGetData($tStruct, 4)
					$aGLVEx_Data[0][11] = DllStructGetData($tStruct, 5)
					; Redraw last selected row
					_GUICtrlListView_RedrawItems($hLV, $aGLVEx_Data[0][17], $aGLVEx_Data[0][17])
					; Set new active cell
					$aGLVEx_Data[0][17] = DllStructGetData($tStruct, 4)
					$aGLVEx_Data[0][18] = DllStructGetData($tStruct, 5)
					$aGLVEx_Data[$iLV_Index][20] = $aGLVEx_Data[0][17]
					$aGLVEx_Data[$iLV_Index][21] = $aGLVEx_Data[0][18]
					; Redraw newly selected row
					_GUICtrlListView_RedrawItems($hLV, $aGLVEx_Data[0][17], $aGLVEx_Data[0][17])
			EndSwitch
		Else

			; Check if header of enabled ListView
			For $iLV_Index = 1 To $aGLVEx_Data[0][0]
				If DllStructGetData($tStruct, 1) = _GUICtrlListView_GetHeader($aGLVEx_Data[$iLV_Index][0]) Then
					ExitLoop
				EndIf
			Next

			If $iLV_Index <= $aGLVEx_Data[0][0] Then
				; Create header data struct
				Local $tNMHEADER = DllStructCreate($tagNMHEADER, $lParam)
				$iCol = DllStructGetData($tNMHEADER, "Item")

				Switch $iCol
					Case 0 To _GUICtrlListView_GetColumnCount($aGLVEx_Data[$iLV_Index][0]) - 1
						; Load header data
						$aHdrData = $aGLVEx_Data[$iLV_Index][25]
						; Check if valid data
						If IsArray($aHdrData) And UBound($aHdrData, 2) Then
							; Check header resizing status
							Local $iHdrResize = $aHdrData[3][$iCol]
							Switch $iCode
								Case -306, -326     ; $HDN_BEGINTRACK(W)
									If $iHdrResize Then
										; Prevent resizing
										Return True
									Else
										; Allow resizing
										Return False
									EndIf
								Case -305, -325     ; $HDN_DIVIDERDBLCLICK(W)
									If $iHdrResize Then
										; Instant resize of column to fixed width
										_GUICtrlListView_SetColumnWidth($aGLVEx_Data[$iLV_Index][0], $iCol, $iHdrResize)
										; Redraw header
										_WinAPI_RedrawWindow(DllStructGetData($tStruct, 1))
									EndIf
							EndSwitch
						EndIf
				EndSwitch
			EndIf
		EndIf
	EndIf

EndFunc   ;==>_GUIListViewEx_WM_NOTIFY_Handler

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_WM_MOUSEMOVE_Handler
; Description ...: Windows message handler for WM_NOTIFY
; Syntax.........: _GUIListViewEx_WM_MOUSEMOVE_Handler()
; Requirement(s).: v3.3.10 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If a WM_MOUSEMOVE handler already registered, then call this function from within that handler
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_WM_MOUSEMOVE_Handler($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam

	Local $iVertScroll

	If $iGLVEx_Dragging = 0 Then
		Return "GUI_RUNDEFMSG"
	EndIf

	; Get item depth to make sure scroll is enough to get next item into view
	If $aGLVEx_Data[$aGLVEx_Data[0][1]][10] Then
		$iVertScroll = $aGLVEx_Data[$aGLVEx_Data[0][1]][10]
	Else
		Local $aRect = _GUICtrlListView_GetItemRect($hGLVEx_SrcHandle, 0)
		$iVertScroll = $aRect[3] - $aRect[1]
	EndIf

	; Get window under mouse cursor
	Local $hCurrent_Wnd = __GUIListViewEx_GetCursorWnd()

	; If not over the current tgt ListView
	If $hCurrent_Wnd <> $hGLVEx_TgtHandle Then

		; Check if external drag permitted
		If BitAND($aGLVEx_Data[$iGLVEx_TgtIndex][12], 1) Then
			Return "GUI_RUNDEFMSG"
		EndIf

		; Is it another initiated ListView
		For $i = 1 To $aGLVEx_Data[0][0]
			If $aGLVEx_Data[$i][0] = $hCurrent_Wnd Then
				; Check if external drop permitted
				If BitAND($aGLVEx_Data[$i][12], 2) Then
					Return "GUI_RUNDEFMSG"
				EndIf
				; Check same column count for Src and Tgt ListViews
				If _GUICtrlListView_GetColumnCount($hGLVEx_SrcHandle) = _GUICtrlListView_GetColumnCount($hCurrent_Wnd) Then
					; Compatible so switch to new target
					; Clear insert mark in current tgt ListView
					_GUICtrlListView_SetInsertMark($hGLVEx_TgtHandle, -1, True)
					; Set data for new tgt ListView
					$hGLVEx_TgtHandle = $hCurrent_Wnd
					$cGLVEx_TgtID = $aGLVEx_Data[$i][1]
					$iGLVEx_TgtIndex = $i
					$aGLVEx_TgtArray = $aGLVEx_Data[$i][2]
					$aGLVEx_Data[0][3] = $aGLVEx_Data[$i][10]     ; Set item depth
					; No point in looping further
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

	; Get current mouse Y coord
	Local $iCurr_Y = BitShift($lParam, 16)

	; Set insert mark to correct side of items depending on sense of movement when cursor within range
	If $iGLVEx_InsertIndex <> -1 Then
		If $iGLVEx_LastY = $iCurr_Y Then
			Return "GUI_RUNDEFMSG"
		ElseIf $iGLVEx_LastY > $iCurr_Y Then
			$fGLVEx_BarUnder = False
			_GUICtrlListView_SetInsertMark($hGLVEx_TgtHandle, $iGLVEx_InsertIndex, False)
		Else
			$fGLVEx_BarUnder = True
			_GUICtrlListView_SetInsertMark($hGLVEx_TgtHandle, $iGLVEx_InsertIndex, True)
		EndIf
	EndIf

	; Store current Y coord
	$iGLVEx_LastY = $iCurr_Y

	; Get ListView item under mouse
	Local $aLVHit = _GUICtrlListView_HitTest($hGLVEx_TgtHandle)
	Local $iCurr_Index = $aLVHit[0]

	; If mouse is above or below ListView then scroll ListView
	If $iCurr_Index = -1 Then
		If $fGLVEx_BarUnder Then
			_GUICtrlListView_Scroll($hGLVEx_TgtHandle, 0, $iVertScroll)
		Else
			_GUICtrlListView_Scroll($hGLVEx_TgtHandle, 0, -$iVertScroll)
		EndIf
		Sleep(10)
	EndIf

	; Check if over same item
	If $iGLVEx_InsertIndex <> $iCurr_Index Then
		; Show insert mark on current item
		_GUICtrlListView_SetInsertMark($hGLVEx_TgtHandle, $iCurr_Index, $fGLVEx_BarUnder)
		; Store current item
		$iGLVEx_InsertIndex = $iCurr_Index
	EndIf

	Return "GUI_RUNDEFMSG"

EndFunc   ;==>_GUIListViewEx_WM_MOUSEMOVE_Handler

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_WM_LBUTTONUP_Handler
; Description ...: Windows message handler for WM_NOTIFY
; Syntax.........: _GUIListViewEx_WM_LBUTTONUP_Handler()
; Requirement(s).: v3.3.10 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If a WM_LBUTTONUP handler already registered, then call this function from within that handler
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_WM_LBUTTONUP_Handler($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $wParam, $lParam

	If Not $iGLVEx_Dragging Then
		Return "GUI_RUNDEFMSG"
	EndIf

	; Get item count
	Local $iMultipleItems = $iGLVEx_Dragging - 1

	; Reset flag
	$iGLVEx_Dragging = 0

	; Check for valid insert index (set to -1 if dropping into empty space)
	If $iGLVEx_InsertIndex = -1 Then
		; Set to bottom
		$iGLVEx_InsertIndex = _GUICtrlListView_GetItemCount($hGLVEx_TgtHandle) - 1
	EndIf

	; Get window under mouse cursor
	Local $hCurrent_Wnd = __GUIListViewEx_GetCursorWnd()

	; Abandon if mouse not within tgt ListView
	If $hCurrent_Wnd <> $hGLVEx_TgtHandle Then
		; Clear insert mark
		_GUICtrlListView_SetInsertMark($hGLVEx_TgtHandle, -1, True)
		; Reset highlight to original items in Src ListView
		For $i = 0 To $iMultipleItems
			__GUIListViewEx_HighLight($hGLVEx_TgtHandle, $cGLVEx_TgtID, $iGLVEx_DraggedIndex + $i)
		Next
		; Delete copied arrays
		$aGLVEx_SrcArray = 0
		$aGLVEx_TgtArray = 0
		Return
	EndIf

	; Clear insert mark
	_GUICtrlListView_SetInsertMark($hGLVEx_TgtHandle, -1, True)

	; Clear drag image
	If $hGLVEx_DraggedImage Then
		_GUIImageList_DragLeave($hGLVEx_SrcHandle)
		_GUIImageList_EndDrag()
		_GUIImageList_Destroy($hGLVEx_DraggedImage)
		$hGLVEx_DraggedImage = 0
	EndIf

	; Dropping within same ListView
	If $hGLVEx_SrcHandle = $hGLVEx_TgtHandle Then
		; Determine position to insert
		If $fGLVEx_BarUnder Then
			If $iGLVEx_DraggedIndex > $iGLVEx_InsertIndex Then $iGLVEx_InsertIndex += 1
		Else
			If $iGLVEx_DraggedIndex < $iGLVEx_InsertIndex Then $iGLVEx_InsertIndex -= 1
		EndIf

		; Check not dropping on dragged item(s)
		Switch $iGLVEx_InsertIndex
			Case $iGLVEx_DraggedIndex To $iGLVEx_DraggedIndex + $iMultipleItems
				; Reset highlight to original items
				For $i = 0 To $iMultipleItems
					__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, $iGLVEx_DraggedIndex + $i)
				Next
				; Delete copied arrays
				$aGLVEx_SrcArray = 0
				$aGLVEx_TgtArray = 0
				Return
		EndSwitch

		; Create Local array for checkboxes (if no checkboxes makes no difference)
		Local $aCheck_Array[UBound($aGLVEx_SrcArray)]
		For $i = 1 To UBound($aCheck_Array) - 1
			$aCheck_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $i - 1)
		Next

		; Create Local array for dragged items checkbox state
		Local $aCheckDrag_Array[$iMultipleItems + 1]

		; Create Local colour array
		$aGLVEx_SrcColArray = $aGLVEx_Data[$iGLVEx_SrcIndex][18]
		Local $bUserCol = ((IsArray($aGLVEx_SrcColArray)) ? (True) : (False))

		; Amend arrays
		; Get data from dragged element(s)
		If $iMultipleItems Then
			; Multiple dragged elements
			Local $aInsertData[$iMultipleItems + 1]
			Local $aColData[$iMultipleItems + 1]
			Local $aItemData[UBound($aGLVEx_SrcArray, 2)]
			For $i = 0 To $iMultipleItems
				; Data
				For $j = 0 To UBound($aGLVEx_SrcArray, 2) - 1
					$aItemData[$j] = $aGLVEx_SrcArray[$iGLVEx_DraggedIndex + 1 + $i][$j]
				Next
				$aInsertData[$i] = $aItemData
				; Colours if required
				If $bUserCol Then
					For $j = 0 To UBound($aGLVEx_SrcColArray, 2) - 1
						$aItemData[$j] = $aGLVEx_SrcColArray[$iGLVEx_DraggedIndex + 1 + $i][$j]
					Next
					$aColData[$i] = $aItemData
				EndIf
				; Checkboxes
				$aCheckDrag_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $iGLVEx_DraggedIndex + $i)
			Next
		Else
			; Single dragged element
			Local $aInsertData[1]
			Local $aColData[1]
			Local $aItemData[UBound($aGLVEx_SrcArray, 2)]
			For $i = 0 To UBound($aGLVEx_SrcArray, 2) - 1
				$aItemData[$i] = $aGLVEx_SrcArray[$iGLVEx_DraggedIndex + 1][$i]
			Next
			$aInsertData[0] = $aItemData
			If $bUserCol Then
				For $i = 0 To UBound($aGLVEx_SrcColArray, 2) - 1
					$aItemData[$i] = $aGLVEx_SrcColArray[$iGLVEx_DraggedIndex + 1][$i]
				Next
				$aColData[0] = $aItemData
			EndIf
			$aCheckDrag_Array[0] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $iGLVEx_DraggedIndex)
		EndIf

		; Set no redraw flag - prevents problems while colour arrays are updated
		$aGLVEx_Data[0][12] = True

		; Delete dragged element(s) from arrays
		For $i = 0 To $iMultipleItems
			__GUIListViewEx_Array_Delete($aGLVEx_SrcArray, $iGLVEx_DraggedIndex + 1)
			__GUIListViewEx_Array_Delete($aCheck_Array, $iGLVEx_DraggedIndex + 1)
			If $bUserCol Then __GUIListViewEx_Array_Delete($aGLVEx_SrcColArray, $iGLVEx_DraggedIndex + 1)
		Next

		; Amend insert positon for multiple items deleted above
		If $iGLVEx_DraggedIndex < $iGLVEx_InsertIndex Then
			$iGLVEx_InsertIndex -= $iMultipleItems
		EndIf

		; Re-insert dragged element(s) into array
		For $i = $iMultipleItems To 0 Step -1
			__GUIListViewEx_Array_Insert($aGLVEx_SrcArray, $iGLVEx_InsertIndex + 1, $aInsertData[$i])
			__GUIListViewEx_Array_Insert($aCheck_Array, $iGLVEx_InsertIndex + 1, $aCheckDrag_Array[$i])
			If $bUserCol Then __GUIListViewEx_Array_Insert($aGLVEx_SrcColArray, $iGLVEx_InsertIndex + 1, $aColData[$i], False, False)
		Next

		; Rewrite ListView to match array
		__GUIListViewEx_ReWriteLV($hGLVEx_SrcHandle, $aGLVEx_SrcArray, $aCheck_Array, $iGLVEx_SrcIndex)

		; Set highlight to inserted item(s)
		For $i = 0 To $iMultipleItems
			__GUIListViewEx_HighLight($hGLVEx_SrcHandle, $cGLVEx_SrcID, $iGLVEx_InsertIndex + $i)
		Next

		; Store amended array
		$aGLVEx_Data[$aGLVEx_Data[0][1]][2] = $aGLVEx_SrcArray
		$aGLVEx_Data[$iGLVEx_SrcIndex][18] = $aGLVEx_SrcColArray

	Else     ; Dropping in another ListView

		; Check checkbox status
		Local $bCheckbox = (($aGLVEx_Data[$iGLVEx_SrcIndex][6] And $aGLVEx_Data[$iGLVEx_TgtIndex][6]) ? (True) : (False))

		; Determine position to insert
		If $fGLVEx_BarUnder Then
			$iGLVEx_InsertIndex += 1
		EndIf

		; Colour arrays for manipulation
		$aGLVEx_SrcColArray = $aGLVEx_Data[$iGLVEx_SrcIndex][18]
		Local $bUserColSrc = ((IsArray($aGLVEx_SrcColArray)) ? (True) : (False))
		$aGLVEx_TgtColArray = $aGLVEx_Data[$iGLVEx_TgtIndex][18]
		Local $bUserColTgt = ((IsArray($aGLVEx_TgtColArray)) ? (True) : (False))

		; Create Local arrays for checkboxes (if no checkboxes makes no difference)
		Local $aCheck_SrcArray[UBound($aGLVEx_SrcArray)]
		For $i = 1 To UBound($aCheck_SrcArray) - 1
			$aCheck_SrcArray[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $i - 1)
		Next
		Local $aCheck_TgtArray[UBound($aGLVEx_TgtArray)]
		For $i = 1 To UBound($aCheck_TgtArray) - 1
			$aCheck_TgtArray[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_TgtHandle, $i - 1)
		Next

		; Create Local array for dragged items checkbox state
		Local $aCheckDrag_Array[$iMultipleItems + 1]

		; Amend arrays
		; Get data from dragged element(s)
		If $iMultipleItems Then
			; Multiple dragged elements
			Local $aInsertData[$iMultipleItems + 1]
			Local $aColData[$iMultipleItems + 1]
			Local $aItemData[UBound($aGLVEx_SrcArray, 2)]
			For $i = 0 To $iMultipleItems
				; Data
				For $j = 0 To UBound($aGLVEx_SrcArray, 2) - 1
					$aItemData[$j] = $aGLVEx_SrcArray[$iGLVEx_DraggedIndex + 1 + $i][$j]
				Next
				$aInsertData[$i] = $aItemData
				; Colours if required
				If $bUserColTgt Then
					For $j = 0 To UBound($aGLVEx_SrcArray, 2) - 1
						If $bUserColSrc Then
							$aItemData[$j] = $aGLVEx_SrcColArray[$iGLVEx_DraggedIndex + 1 + $i][$j]
						Else
							$aItemData[$j] = ";"
						EndIf
					Next
					$aColData[$i] = $aItemData
				EndIf
				; Checkboxes
				$aCheckDrag_Array[$i] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $iGLVEx_DraggedIndex + $i)
			Next
		Else
			; Single dragged element
			Local $aInsertData[1]
			Local $aColData[1]
			Local $aItemData[UBound($aGLVEx_SrcArray, 2)]
			For $i = 0 To UBound($aGLVEx_SrcArray, 2) - 1
				$aItemData[$i] = $aGLVEx_SrcArray[$iGLVEx_DraggedIndex + 1][$i]
			Next
			$aInsertData[0] = $aItemData
			If $bUserColTgt Then
				For $i = 0 To UBound($aGLVEx_SrcArray, 2) - 1
					If $bUserColSrc Then
						$aItemData[$i] = $aGLVEx_SrcColArray[$iGLVEx_DraggedIndex + 1][$i]
					Else
						$aItemData[$i] = ";"
					EndIf
				Next
				$aColData[0] = $aItemData
			EndIf
			$aCheckDrag_Array[0] = _GUICtrlListView_GetItemChecked($hGLVEx_SrcHandle, $iGLVEx_DraggedIndex)
		EndIf

		; Set no redraw flag - prevents problems while colour arrays are updated
		$aGLVEx_Data[0][12] = True

		; Delete dragged element(s) from source array
		If Not BitAND($aGLVEx_Data[$iGLVEx_SrcIndex][12], 4) Then
			For $i = 0 To $iMultipleItems
				__GUIListViewEx_Array_Delete($aGLVEx_SrcArray, $iGLVEx_DraggedIndex + 1)
				__GUIListViewEx_Array_Delete($aCheck_SrcArray, $iGLVEx_DraggedIndex + 1, $aCheckDrag_Array[$i])
				If $bUserColSrc Then __GUIListViewEx_Array_Delete($aGLVEx_SrcColArray, $iGLVEx_DraggedIndex + 1)
			Next
		EndIf

		; Check if insert index is valid
		If $iGLVEx_InsertIndex < 0 Then
			$iGLVEx_InsertIndex = _GUICtrlListView_GetItemCount($hGLVEx_TgtHandle)
		EndIf

		; Insert dragged element(s) into target array
		For $i = $iMultipleItems To 0 Step -1
			__GUIListViewEx_Array_Insert($aGLVEx_TgtArray, $iGLVEx_InsertIndex + 1, $aInsertData[$i])
			__GUIListViewEx_Array_Insert($aCheck_TgtArray, $iGLVEx_InsertIndex + 1, $aCheckDrag_Array[$i])
			If $bUserColTgt Then __GUIListViewEx_Array_Insert($aGLVEx_TgtColArray, $iGLVEx_InsertIndex + 1, $aColData[$i], False, False)
		Next

		; Rewrite ListViews to match arrays
		__GUIListViewEx_ReWriteLV($hGLVEx_SrcHandle, $aGLVEx_SrcArray, $aCheck_SrcArray, $iGLVEx_SrcIndex, $bCheckbox)
		__GUIListViewEx_ReWriteLV($hGLVEx_TgtHandle, $aGLVEx_TgtArray, $aCheck_TgtArray, $iGLVEx_TgtIndex, $bCheckbox)

		; Set highlight to inserted item(s)
		_GUIListViewEx_SetActive($iGLVEx_TgtIndex)
		For $i = 0 To $iMultipleItems
			__GUIListViewEx_HighLight($hGLVEx_TgtHandle, $cGLVEx_TgtID, $iGLVEx_InsertIndex + $i)
		Next

		; Store amended arrays
		$aGLVEx_Data[$iGLVEx_SrcIndex][2] = $aGLVEx_SrcArray
		$aGLVEx_Data[$iGLVEx_SrcIndex][18] = $aGLVEx_SrcColArray
		$aGLVEx_Data[$iGLVEx_TgtIndex][2] = $aGLVEx_TgtArray
		$aGLVEx_Data[$iGLVEx_TgtIndex][18] = $aGLVEx_TgtColArray

	EndIf

	; Delete copied arrays
	$aGLVEx_SrcArray = 0
	$aGLVEx_TgtArray = 0
	$aGLVEx_SrcColArray = 0
	$aGLVEx_TgtColArray = 0

	; Set DragEvent details
	$sGLVEx_DragEvent = $iGLVEx_SrcIndex & ":" & $iGLVEx_TgtIndex
	; Set colour redraw flag
	$aGLVEx_Data[0][22] = 1

	; Clear no redraw flag
	$aGLVEx_Data[0][12] = False

	; If colour used or single cell selection
	__GUIListViewEx_RedrawWindow($iGLVEx_SrcIndex)
	If $hGLVEx_TgtHandle <> $hGLVEx_SrcHandle Then
		__GUIListViewEx_RedrawWindow($iGLVEx_TgtIndex)
	EndIf

EndFunc   ;==>_GUIListViewEx_WM_LBUTTONUP_Handler

; #FUNCTION# =========================================================================================================
; Name...........: _GUIListViewEx_WM_SYSCOMMAND_Handler
; Description ...: Windows message handler for WM_SYSCOMMAND
; Syntax.........: _GUIListViewEx_WM_SYSCOMMAND_Handler()
; Requirement(s).: v3.3.10 +
; Return values .: None
; Author ........: Melba23
; Modified ......:
; Remarks .......: If a WM_SYSCOMMAND handler already registered, then call this function from within that handler
; Example........: Yes
;=====================================================================================================================
Func _GUIListViewEx_WM_SYSCOMMAND_Handler($hWnd, $iMsg, $wParam, $lParam)

	#forceref $hWnd, $iMsg, $lParam, $lParam

	; Check correct event from ListView GUI
	If $hWnd = _WinAPI_GetParent($hGLVEx_SrcHandle) And $wParam = 0xF060 Then     ; $SC_CLOSE
		$aGLVEx_Data[0][9] = True
	EndIf

EndFunc   ;==>_GUIListViewEx_WM_SYSCOMMAND_Handler

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_ExpandRange
; Description ...: Expands ranges into an array of values - $iMode determines if columns or rows
; Author ........: Melba23
; Modified ......:
; ===============================================================================================================================
Func __GUIListViewEx_ExpandRange($vRange, $iLV_Index, $iMode = 1)

	; Check for valid range string
	If StringRegExp($vRange, "[^*0-9-;]") <> 0 Then
		Return SetError(1, 0, 0)
	EndIf

	; Get column/row count and create an array
	Local $iCount
	If $iMode = 1 Then
		$iCount = _GUICtrlListView_GetColumnCount($aGLVEx_Data[$iLV_Index][0])
	Else
		$iCount = _GUICtrlListView_GetItemCount($aGLVEx_Data[$iLV_Index][0])
	EndIf
	Local $aRet[$iCount + 1]

	; Strip any whitespace
	$vRange = StringStripWS($vRange, 8)
	; Check if "all"
	If $vRange = "*" Then
		$aRet[0] = $iCount
		For $i = 1 To $iCount
			$aRet[$i] = $i - 1
		Next
	Else
		; Check if there are ranges to be expanded
		If StringInStr($vRange, "-") Then
			; Parse string
			Local $aSplit_1, $aSplit_2, $iNumber
			; Split on ";"
			$aSplit_1 = StringSplit($vRange, ";")
			$vRange = ""
			; Check each element
			For $i = 1 To $aSplit_1[0]
				; Try and split on "-"
				$aSplit_2 = StringSplit($aSplit_1[$i], "-")
				; Add first value in all cases
				$vRange &= $aSplit_2[1] & ";"
				; If a valid range
				If ($aSplit_2[0]) > 1 Then
					; Check valid range
					If (Number($aSplit_2[2]) > Number($aSplit_2[1])) Then
						; Add the full range
						$iNumber = $aSplit_2[1]
						Do
							$iNumber += 1
							$vRange &= $iNumber & ";"
						Until $iNumber = $aSplit_2[2]
					Else
						Return SetError(1, 0, 0)
					EndIf
				EndIf
			Next
		EndIf
		; Split string into array
		Local $aSplit = StringSplit($vRange, ";")
		; Check for valid elements
		For $i = 1 To $aSplit[0]
			If $aSplit[$i] Then
				$aRet[0] += 1
				$aRet[$aRet[0]] = $aSplit[$i]
			EndIf
		Next
		; Remove empty elements
		ReDim $aRet[$aRet[0] + 1]
	EndIf
	; Return array of range values
	Return $aRet

EndFunc   ;==>__GUIListViewEx_ExpandRange

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_HighLight
; Description ...: Highlights first item and ensures visible, second item has highlight removed
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_HighLight($hLVHandle, $cLV_CID, $iIndexA, $iIndexB = -1)

	; Check if Native or UDF and set focus
	If $cLV_CID Then
		GUICtrlSetState($cLV_CID, 256)     ; $GUI_FOCUS
	Else
		_WinAPI_SetFocus($hLVHandle)
	EndIf
	; Cancel highlight on other item - needed for multisel listviews
	If $iIndexB <> -1 Then _GUICtrlListView_SetItemSelected($hLVHandle, $iIndexB, False)
	; Set highlight to inserted item and ensure in view
	_GUICtrlListView_SetItemState($hLVHandle, $iIndexA, $LVIS_SELECTED, $LVIS_SELECTED)
	_GUICtrlListView_EnsureVisible($hLVHandle, $iIndexA)

EndFunc   ;==>__GUIListViewEx_HighLight

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_GetLVFont
; Description ...: Gets font details for ListView to be edited
; Author ........: Based on _GUICtrlGetFont by KaFu & Prog@ndy
; Modified ......: Melba23
; ===============================================================================================================================
Func __GUIListViewEx_GetLVFont($hLVHandle)

	Local $iError = 0, $aFontDetails[2] = [Default, Default]

	; Check handle
	If Not IsHWnd($hLVHandle) Then
		$hLVHandle = GUICtrlGetHandle($hLVHandle)
	EndIf
	If Not IsHWnd($hLVHandle) Then
		$iError = 1
	Else
		Local $hFont = _SendMessage($hLVHandle, 0x0031)     ; WM_GETFONT
		If Not $hFont Then
			$iError = 2
		Else
			Local $hDC = _WinAPI_GetDC($hLVHandle)
			Local $hObjOrg = _WinAPI_SelectObject($hDC, $hFont)
			Local $tFONT = DllStructCreate($tagLOGFONT)
			Local $aRet = DllCall('gdi32.dll', 'int', 'GetObjectW', 'ptr', $hFont, 'int', DllStructGetSize($tFONT), 'ptr', DllStructGetPtr($tFONT))
			If @error Or $aRet[0] = 0 Then
				$iError = 3
			Else
				; Get font size
				$aFontDetails[0] = Round((-1 * DllStructGetData($tFONT, 'Height')) * 72 / _WinAPI_GetDeviceCaps($hDC, 90), 1)     ; $LOGPIXELSY = 90 => DPI aware
				; Now look for font name
				$aRet = DllCall("gdi32.dll", "int", "GetTextFaceW", "handle", $hDC, "int", 0, "ptr", 0)
				Local $iCount = $aRet[0]
				Local $tBuffer = DllStructCreate("wchar[" & $iCount & "]")
				Local $pBuffer = DllStructGetPtr($tBuffer)
				$aRet = DllCall("Gdi32.dll", "int", "GetTextFaceW", "handle", $hDC, "int", $iCount, "ptr", $pBuffer)
				If @error Then
					$iError = 4
				Else
					$aFontDetails[1] = DllStructGetData($tBuffer, 1)     ; FontFacename
				EndIf
			EndIf
			_WinAPI_SelectObject($hDC, $hObjOrg)
			_WinAPI_ReleaseDC($hLVHandle, $hDC)
		EndIf
	EndIf

	Return SetError($iError, 0, $aFontDetails)

EndFunc   ;==>__GUIListViewEx_GetLVFont

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_EditProcess
; Description ...: Runs ListView editing process
; Author ........: Melba23
; Modified ......:
; ===============================================================================================================================
Func __GUIListViewEx_EditProcess($iLV_Index, $aLocation, $iDelta_X, $iDelta_Y, $iEditMode, $iForce = False)

	Local $hTemp_Combo = 9999, $hTemp_Edit = 9999, $hTemp_List = 9999, $iKey_Code, $fCombo_State, $aSplit, $sInsert
	Local $iEditType, $fEdit, $fCombo, $fRead_Only, $fAuto_Drop, $fDTP, $fClick_Move = False, $cUpDown, $hUpDown

	; Force ListView GUI to become current GUI for control creation and store previous GUI handle
	Local $hPrevCurrGUI = GUISwitch(_WinAPI_GetParent($hGLVEx_SrcHandle))

	; Unselect item
	_GUICtrlListView_SetItemSelected($hGLVEx_SrcHandle, $aLocation[0], False)

	; Declare return array
	Local $aEdited[1][4] = [[0]]     ; [[Number of edited items, blank, blank, blank]]

	; Load active ListView details
	$hGLVEx_SrcHandle = $aGLVEx_Data[$iLV_Index][0]
	$cGLVEx_SrcID = $aGLVEx_Data[$iLV_Index][1]

	; Store handle of ListView concerned
	$hGLVEx_Editing = $hGLVEx_SrcHandle
	Local $cEditingID = $cGLVEx_SrcID

	; Valid keys to action ; TAB, ENTER, ESC, left/right/up/down arrows
	Local $aKeys[7] = [0x09, 0x0D, 0x1B, 0x25, 0x27, 0x26, 0x28]

	; Set Reset-on-ESC mode
	Local $fReset_Edits = False
	If $iEditMode < 0 Then
		$fReset_Edits = True
		$iEditMode = Abs($iEditMode)
	EndIf

	; Set row/col edit mode - default single edit
	Local $iEditRow = 0, $iEditCol = 0
	If $iEditMode Then
		; Separate axis settings - force leading 0 if required
		$aSplit = StringSplit(StringFormat("%02s", $iEditMode), "")
		$iEditRow = $aSplit[1]
		$iEditCol = $aSplit[2]
	EndIf

	; Extract editable array
	Local $aEditable = $aGLVEx_Data[$iLV_Index][7]

	; Check if edit to move on click
	If $aGLVEx_Data[$iLV_Index][9] Then
		$fClick_Move = True
	EndIf

	Local $tLVPos = DllStructCreate("struct;long X;long Y;endstruct")
	; Get position of ListView within GUI client area
	__GUIListViewEx_GetLVCoords($hGLVEx_Editing, $tLVPos)
	; Get ListView client area to allow for scrollbars
	Local $aLVClient = WinGetClientSize($hGLVEx_Editing)
	; Get ListView font details
	Local $aLV_FontDetails = __GUIListViewEx_GetLVFont($hGLVEx_Editing)
	; Disable ListView
	WinSetState($hGLVEx_Editing, "", @SW_DISABLE)

	; Load edit width data array
	Local $aWidth = ($aGLVEx_Data[$iLV_Index][14])
	; Create dummy array if required
	If Not IsArray($aWidth) Then Local $aWidth[_GUICtrlListView_GetColumnCount($aGLVEx_Data[$iLV_Index][0])]

	; Define variables
	Local $iWidth, $fExitLoop, $tMouseClick = DllStructCreate($tagPOINT)
	; Set default mousecoordmode
	Local $iOldMouseOpt = Opt("MouseCoordMode", 1)
	; Prevent GUI closure on ESC as needed to exit edit
	Local $iOldESC = Opt("GUICloseOnESC", 0)
	; Wait for mouse button release
	_WinAPI_GetAsyncKeyState(0x01)
	While _WinAPI_GetAsyncKeyState(0x01)
		Sleep(10)
	WEnd

	; Start the edit loop
	While 1

		; Clear all type flags
		$fEdit = False
		$fCombo = False
		$fRead_Only = False
		$fAuto_Drop = False
		$fDTP = False

		; Determine type of control required for this cell and extract data if required
		$iEditType = $aEditable[0][$aLocation[1]]
		Switch $iEditType
			Case 0, 1     ; Edit
				$fEdit = True
				If $iForce Then
					$iEditType = 1     ; Force text edit if called by _GUIListViewEx_EditItem
				EndIf

			Case 2     ; Combo
				$fCombo = True
				Local $sCombo_Data = $aEditable[1][$aLocation[1]]
				$fRead_Only = (BitAND($aEditable[2][$aLocation[1]], 1) = 1)
				$fAuto_Drop = (BitAND($aEditable[2][$aLocation[1]], 2) = 2)

			Case 3     ; DTP
				$fDTP = True
				Local $sDTP_Default = $aEditable[1][$aLocation[1]]
				If StringRight($sDTP_Default, 1) = "#" Then
					$sDTP_Default = StringTrimRight($sDTP_Default, 1)
					$fAuto_Drop = True
				EndIf
				If $sDTP_Default = Default Then
					$sDTP_Default = @YEAR & "/" & @MON & "/" & @MDAY
				EndIf
				Local $sDTP_Format = $aEditable[2][$aLocation[1]]
				If $sDTP_Format = Default Then
					$sDTP_Format = ""
				EndIf
		EndSwitch

		; Read current text of clicked item
		Local $sItemOrgText = _GUICtrlListView_GetItemText($hGLVEx_Editing, $aLocation[0], $aLocation[1])
		; Ensure item is visible and get required edit coords
		Local $aEdit_Pos = __GUIListViewEx_EditCoords($hGLVEx_Editing, $cEditingID, $aLocation, $tLVPos, $aLVClient[0] - 5, $iDelta_X, $iDelta_Y)
		; Get required edit width - force to number so non-digits are set to 0
		$iWidth = Number($aWidth[$aLocation[1]])
		; Alter edit/combo width if required value less than current width
		If $iWidth > $aEdit_Pos[2] Then
			If $fRead_Only Then     ; Only adjust read-only combo edit width if value is negative
				If $iWidth < 0 Then
					$aEdit_Pos[2] = Abs($iWidth)
				EndIf
			Else     ; Always adjust for if manual input accepted
				$aEdit_Pos[2] = Abs($iWidth)
			EndIf
		EndIf

		; Create control
		Switch $iEditType
			Case 1     ; Edit
				; Create temporary edit - get handle, set font size, give keyboard focus and select all text
				$cGLVEx_EditID = GUICtrlCreateInput($sItemOrgText, $aEdit_Pos[0], $aEdit_Pos[1], $aEdit_Pos[2], $aEdit_Pos[3], 128)     ; $ES_AUTOHSCROLL
				$hTemp_Edit = GUICtrlGetHandle($cGLVEx_EditID)
				; Check if UpDown required
				If $aEditable[1][$aLocation[1]] = 1 Then
					Local $iWrap = -1     ; Default no wrap
					; Check if limits to be applied
					If $aEditable[2][$aLocation[1]] Then
						$aSplit = StringSplit($aEditable[2][$aLocation[1]], "|")
						; Check valid syntax
						If UBound($aSplit) = 4 Then
							$iWrap = (($aSplit[3] = 1) ? (0x05) : (-1))     ; ($UDS_ALIGNRIGHT, $UDS_WRAP), (Default)
						EndIf
					EndIf
					; Create UpDowm
					$cUpDown = GUICtrlCreateUpdown($cGLVEx_EditID, $iWrap)
					$hUpDown = GUICtrlGetHandle($cUpDown)
					; Check for limits
					If UBound($aSplit) = 4 Then
						GUICtrlSetLimit($cUpDown, $aSplit[2], $aSplit[1])
					EndIf
					; Ensure visible
					_WinAPI_RedrawWindow($hUpDown)
				EndIf

			Case 2     ; Combo
				; Create temporary combo - get handle, set font size, give keyboard focus
				If $fRead_Only Then
					$cGLVEx_EditID = GUICtrlCreateCombo("", $aEdit_Pos[0], $aEdit_Pos[1], $aEdit_Pos[2], $aEdit_Pos[3], 0x00200043)     ; $CBS_DROPDOWNLIST, $CBS_AUTOHSCROLL, $WS_VSCROLL
					; Set existing content as default for read-only
					GUICtrlSetData($cGLVEx_EditID, $sCombo_Data, $sItemOrgText)
				Else
					$cGLVEx_EditID = GUICtrlCreateCombo("", $aEdit_Pos[0], $aEdit_Pos[1], $aEdit_Pos[2], $aEdit_Pos[3], 0x00200042)     ; $CBS_DROPDOWN, $CBS_AUTOHSCROLL, $WS_VSCROLL
					; Do NOT set existing content as default only for editable
					GUICtrlSetData($cGLVEx_EditID, $sCombo_Data)
				EndIf

				Local $tInfo = DllStructCreate("dword Size;struct;long EditLeft;long EditTop;long EditRight;long EditBottom;endstruct;" & _
						"struct;long BtnLeft;long BtnTop;long BtnRight;long BtnBottom;endstruct;dword BtnState;hwnd hCombo;hwnd hEdit;hwnd hList")
				Local $iInfo = DllStructGetSize($tInfo)
				DllStructSetData($tInfo, "Size", $iInfo)
				Local $hCombo = GUICtrlGetHandle($cGLVEx_EditID)
				; Set readonly combo dropped width if required
				If $fRead_Only And Abs($iWidth) > $aEdit_Pos[2] Then
					_SendMessage($hCombo, 0x160, Abs($iWidth))     ; $CB_SETDROPPEDWIDTH
				EndIf
				; Get combo data
				_SendMessage($hCombo, 0x164, 0, $tInfo, 0, "wparam", "struct*")     ; $CB_GETCOMBOBOXINFO
				$hTemp_Edit = DllStructGetData($tInfo, "hEdit")
				$hTemp_List = DllStructGetData($tInfo, "hList")
				$hTemp_Combo = DllStructGetData($tInfo, "hCombo")

			Case 3     ; DTP
				; Create temp date picker
				$cGLVEx_EditID = GUICtrlCreateDate($sDTP_Default, $aEdit_Pos[0], $aEdit_Pos[1], $aEdit_Pos[2], $aEdit_Pos[3])
				$hTemp_Edit = GUICtrlGetHandle($cGLVEx_EditID)
				; Set format if required
				If $sDTP_Format Then
					GUICtrlSendMsg($cGLVEx_EditID, 0x1032, 0, $sDTP_Format)     ; $DTM_SETFORMATW
				EndIf

		EndSwitch

		; Set font
		GUICtrlSetFont($cGLVEx_EditID, $aLV_FontDetails[0], Default, Default, $aLV_FontDetails[1])

		; Set focus to editing control
		_WinAPI_SetFocus($hTemp_Edit)
		; Check "select all" flag state
		If Not $aGLVEx_Data[$iLV_Index][11] Then
			GUICtrlSendMsg($cGLVEx_EditID, 0xB1, 0, -1)     ; $EM_SETSEL
		EndIf
		; Check for auto "drop-down" combo
		If $fAuto_Drop Then
			Switch $iEditType
				Case 2
					_SendMessage($hCombo, 0x14F, True)     ; $$CB_SHOWDROPDOWN
				Case 3
					_SendMessage($hTemp_Edit, 0x0201, 1, $aEdit_Pos[2] - 10)     ; WM_LBUTTONDOWN
			EndSwitch
		EndIf

		; Copy array for manipulation
		$aGLVEx_SrcArray = $aGLVEx_Data[$iLV_Index][2]
		; Clear key code flag
		$iKey_Code = 0
		; Set combo down/up flag depending on initial state
		$fCombo_State = (($fAuto_Drop) ? (True) : (False))

		; Wait for a key press or combo down/up
		While 1

			; Clear flag
			$fExitLoop = False

			; Check for SYSCOMMAND Close Event
			If $aGLVEx_Data[0][9] Then
				$fExitLoop = True
				$aGLVEx_Data[0][9] = False
			EndIf

			; Mouse pressed
			_WinAPI_GetAsyncKeyState(0x01)
			If _WinAPI_GetAsyncKeyState(0x01) Then
				; Look for clicks outside edit/combo control
				DllStructSetData($tMouseClick, "x", MouseGetPos(0))
				DllStructSetData($tMouseClick, "y", MouseGetPos(1))
				Switch _WinAPI_WindowFromPoint($tMouseClick)
					Case $hTemp_Combo, $hTemp_Edit, $hTemp_List, $hUpDown
						; Over edit/combo
					Case Else
						; Ignore if using date control
						If Not $fDTP Then
							$fExitLoop = True
						EndIf
				EndSwitch
				; Wait for mouse button release
				_WinAPI_GetAsyncKeyState(0x01)
				While _WinAPI_GetAsyncKeyState(0x01)
					Sleep(10)
				WEnd
			EndIf

			; Exit loop
			If $fExitLoop Then
				; If standard edit control
				If $fEdit Then
					; Set appropriate behaviour
					If $fClick_Move Then
						$iKey_Code = 0x02     ; Confirm edit and move to next cell
					Else
						$iKey_Code = 0x01     ; Abandon editing process
					EndIf
				EndIf
				ExitLoop
			EndIf

			If $fCombo Then

				; Check for dropdown open and close
				Switch _SendMessage($hCombo, 0x157)     ; $CB_GETDROPPEDSTATE

					Case 0
						; If opened and closed
						If $fCombo_State = True Then
							; If no content
							If GUICtrlRead($cGLVEx_EditID) = "" Then
								; Ignore
								$fCombo_State = False
							Else
								; Act as if Enter pressed
								$iKey_Code = 0x0D
								ExitLoop
							EndIf
						EndIf

					Case 1
						; Set flag if opened
						If Not $fCombo_State Then
							$fCombo_State = True
						EndIf

				EndSwitch
			EndIf

			; Check for valid key pressed
			For $i = 0 To 2     ; TAB, ENTER, ESC
				_WinAPI_GetAsyncKeyState($aKeys[$i])
				If _WinAPI_GetAsyncKeyState($aKeys[$i]) Then
					; Set key pressed flag
					$iKey_Code = $aKeys[$i]
					ExitLoop 2
				EndIf
			Next
			For $i = 3 To 6     ; l/r/u/d with ctrl pressed
				_WinAPI_GetAsyncKeyState($aKeys[$i])
				If _WinAPI_GetAsyncKeyState($aKeys[$i]) And _WinAPI_GetAsyncKeyState(0x11) Then
					; Set key pressed flag
					$iKey_Code = $aKeys[$i]
					ExitLoop 2
				EndIf
			Next

			; Temp input lost focus
			If _WinAPI_GetFocus() <> $hTemp_Edit Then
				ExitLoop
			EndIf

			; Save CPU
			Sleep(10)
		WEnd

		; Check if edit to be confirmed
		Switch $iKey_Code
			Case 0x25, 0x26, 0x27, 0x28     ; arrow keys
				; If not standard edit control then abandon edit
				If $fEdit Then
					ContinueCase
				EndIf

			Case 0x02, 0x09, 0x0D     ; Mouse (with Click_Move), TAB, ENTER
				; Read edit content
				Local $sItemNewText = GUICtrlRead($cGLVEx_EditID)
				; Check replacement required
				If $sItemNewText <> $sItemOrgText Then
					; Amend item text
					_GUICtrlListView_SetItemText($hGLVEx_Editing, $aLocation[0], $sItemNewText, $aLocation[1])
					; Amend array element
					$aGLVEx_SrcArray[$aLocation[0] + 1][$aLocation[1]] = $sItemNewText
					; Store amended array
					$aGLVEx_Data[$iLV_Index][2] = $aGLVEx_SrcArray
					; Add item data to return array
					$aEdited[0][0] += 1
					ReDim $aEdited[$aEdited[0][0] + 1][4]
					; Save location & original content
					$aEdited[$aEdited[0][0]][0] = $aLocation[0]
					$aEdited[$aEdited[0][0]][1] = $aLocation[1]
					$aEdited[$aEdited[0][0]][2] = $sItemOrgText
					$aEdited[$aEdited[0][0]][3] = $sItemNewText
				EndIf
		EndSwitch

		; Delete temporary edit and set place holder
		GUICtrlDelete($cGLVEx_EditID)
		GUICtrlDelete($cUpDown)
		$cGLVEx_EditID = 9999
		; Reset user mousecoord mode
		Opt("MouseCoordMode", $iOldMouseOpt)

		; Check edit mode
		If $iEditMode = 0 Then     ; Single edit
			; Exit edit process
			ExitLoop
		Else
			Switch $iKey_Code
				Case 0x02
					$iKey_Code = 0x01
					ContinueCase

				Case 0x00, 0x01, 0x0D     ; Edit lost focus, mouse button outside edit, ENTER pressed
					; Wait until key/button no longer pressed
					_WinAPI_GetAsyncKeyState($iKey_Code)
					While _WinAPI_GetAsyncKeyState($iKey_Code)
						Sleep(10)
					WEnd
					; Exit Edit process
					ExitLoop

				Case 0x1B     ; ESC pressed
					; Check Reset-on-ESC mode
					If $fReset_Edits Then
						; Reset previous confirmed edits starting with most recent
						For $i = $aEdited[0][0] To 1 Step -1
							_GUICtrlListView_SetItemText($hGLVEx_Editing, $aEdited[$i][0], $aEdited[$i][2], $aEdited[$i][1])
							Switch UBound($aGLVEx_SrcArray, 0)
								Case 1
									$aSplit = StringSplit($aGLVEx_SrcArray[$aEdited[$i][0] + 1], $aGLVEx_Data[0][24])
									$aSplit[$aEdited[$i][1] + 1] = $aEdited[$i][2]
									$sInsert = ""
									For $j = 1 To $aSplit[0]
										$sInsert &= $aSplit[$j] & $aGLVEx_Data[0][24]
									Next
									$aGLVEx_SrcArray[$aEdited[$i][0] + 1] = StringTrimRight($sInsert, 1)

								Case 2
									$aGLVEx_SrcArray[$aEdited[$i][0] + 1][$aEdited[$i][1]] = $aEdited[$i][2]
							EndSwitch
						Next
						; Store amended array
						$aGLVEx_Data[$iLV_Index][2] = $aGLVEx_SrcArray
						; Empty return array as no edits were made
						Local $aEdited[1][4] = [[0]]
					EndIf
					; Wait until key no longer pressed
					_WinAPI_GetAsyncKeyState(0x1B)
					While _WinAPI_GetAsyncKeyState(0x1B)
						Sleep(10)
					WEnd
					; Exit Edit process
					ExitLoop

				Case 0x09, 0x27     ; TAB or right arrow
					While 1
						If $iEditCol <> 0 Then
							; Set next column
							$aLocation[1] += 1
							; Check column exists
							If $aLocation[1] = _GUICtrlListView_GetColumnCount($hGLVEx_Editing) Then
								; Does not exist so check required action
								Switch $iEditCol
									Case 1
										; Exit edit process
										ExitLoop 2
									Case 2
										; Stay on same location
										$aLocation[1] -= 1
										ExitLoop
									Case 3
										; Loop
										$aLocation[1] = 0
								EndSwitch
							EndIf
							; Check this column is editable
							If $aEditable[0][$aLocation[1]] <> 0 Then
								; Editable column
								ExitLoop
							Else
								; Not editable column
								ExitLoop 2
							EndIf
						Else
							; End edit
							ExitLoop 2
						EndIf
					WEnd

				Case 0x25     ; Left arrow
					While 1
						If $iEditCol <> 0 Then
							$aLocation[1] -= 1
							If $aLocation[1] < 0 Then
								Switch $iEditCol
									Case 1
										ExitLoop 2
									Case 2
										$aLocation[1] += 1
										ExitLoop
									Case 3
										$aLocation[1] = _GUICtrlListView_GetColumnCount($hGLVEx_Editing) - 1
								EndSwitch
							EndIf
							; Check this column is editable
							If $aEditable[0][$aLocation[1]] <> 0 Then
								ExitLoop
							Else
								ExitLoop 2
							EndIf
						Else
							; End edit
							ExitLoop 2
						EndIf
					WEnd

				Case 0x28     ; Down key
					While 1
						If $iEditRow <> 0 Then
							; Set next row
							$aLocation[0] += 1
							; Check column exists
							If $aLocation[0] = _GUICtrlListView_GetItemCount($hGLVEx_Editing) Then
								; Does not exist so check required action
								Switch $iEditRow
									Case 1
										; Exit edit process
										ExitLoop 2
									Case 2
										; Stay on same location
										$aLocation[0] -= 1
										ExitLoop
									Case 3
										; Loop
										$aLocation[0] = -1
								EndSwitch
							Else
								; All rows editable
								ExitLoop
							EndIf
						Else
							; End edit
							ExitLoop 2
						EndIf
					WEnd

				Case 0x26     ; Up key
					While 1
						If $iEditRow <> 0 Then
							$aLocation[0] -= 1
							If $aLocation[0] < 0 Then
								Switch $iEditRow
									Case 1
										ExitLoop 2
									Case 2
										$aLocation[0] += 1
										ExitLoop
									Case 3
										$aLocation[0] = _GUICtrlListView_GetItemCount($hGLVEx_Editing)
								EndSwitch
							Else
								ExitLoop
							EndIf
						Else
							; End edit
							ExitLoop 2
						EndIf
					WEnd
			EndSwitch
			; Wait until key no longer pressed
			_WinAPI_GetAsyncKeyState($iKey_Code)
			While _WinAPI_GetAsyncKeyState($iKey_Code)
				Sleep(10)
			WEnd
			; Continue edit loop on next item
		EndIf
	WEnd
	; Delete copied array
	$aGLVEx_SrcArray = 0
	; Reenable ListView
	WinSetState($hGLVEx_Editing, "", @SW_ENABLE)
	; Reselect item
	_GUICtrlListView_SetItemState($hGLVEx_Editing, $aLocation[0], $LVIS_SELECTED, $LVIS_SELECTED)

	; Set extended to key value
	SetExtended($iKey_Code)
	; Reset user value
	Opt("GUICloseOnESC", $iOldESC)

	; Reset current GUI to previous handle
	GUISwitch($hPrevCurrGUI)

	; Reset focus to the ListView
	_WinAPI_SetFocus($hGLVEx_Editing)

	; Return array
	Return $aEdited

EndFunc   ;==>__GUIListViewEx_EditProcess

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_EditCoords
; Description ...: Ensures item in view then locates and sizes edit control
; Author ........: Melba23
; Modified ......:
; ===============================================================================================================================
Func __GUIListViewEx_EditCoords($hLV_Handle, $cLV_CID, $aLocation, $tLVPos, $iLVWidth, $iDelta_X, $iDelta_Y)

	; Declare array to hold return data
	Local $aEdit_Data[4]
	; Ensure row visible
	_GUICtrlListView_EnsureVisible($hLV_Handle, $aLocation[0])
	; Get size of item
	Local $aRect = _GUICtrlListView_GetSubItemRect($hLV_Handle, $aLocation[0], $aLocation[1])
	; Set required edit height
	$aEdit_Data[3] = $aRect[3] - $aRect[1] + 1
	; Set required edit width
	$aEdit_Data[2] = _GUICtrlListView_GetColumnWidth($hLV_Handle, $aLocation[1])
	; Ensure column visible - scroll to left edge if all column not in view
	If $aRect[0] < 0 Or $aRect[2] > $iLVWidth Then
		_GUICtrlListView_Scroll($hLV_Handle, $aRect[0], 0)
		; Redetermine item coords
		$aRect = _GUICtrlListView_GetSubItemRect($hLV_Handle, $aLocation[0], $aLocation[1])
		; Check available column width and limit if required
		If $aRect[0] + $aEdit_Data[2] > $iLVWidth Then
			$aEdit_Data[2] = $iLVWidth - $aRect[0]
		EndIf
	EndIf
	; Adjust Y coord if Native ListView
	If $cLV_CID Then
		$iDelta_Y += 1
	EndIf
	; Determine screen coords for edit control
	$aEdit_Data[0] = DllStructGetData($tLVPos, "X") + $aRect[0] + $iDelta_X + 2
	$aEdit_Data[1] = DllStructGetData($tLVPos, "Y") + $aRect[1] + $iDelta_Y

	; Return edit data
	Return $aEdit_Data

EndFunc   ;==>__GUIListViewEx_EditCoords

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_ReWriteLV
; Description ...: Deletes all ListView content and refills to match array
; Author ........: Melba23
; Modified ......:
; ===============================================================================================================================
Func __GUIListViewEx_ReWriteLV($hLVHandle, ByRef $aLV_Array, ByRef $aCheck_Array, $iLV_Index, $fCheckBox = True, $fRetainWidth = True)

	Local $iVertScroll, $iColCount
	Local $iLV_CID = $aGLVEx_Data[$iLV_Index][1]

	; Get item depth
	If $aGLVEx_Data[$iLV_Index][10] Then
		$iVertScroll = $aGLVEx_Data[$iLV_Index][10]
	Else
		; If not already set then ListView was empty so determine
		Local $aRect = _GUICtrlListView_GetItemRect($hLVHandle, 0)
		$aGLVEx_Data[$iLV_Index][10] = $aRect[3] - $aRect[1]
		; If still empty set a placeholder for this instance
		If $iVertScroll = 0 Then
			; And make sure scroll is likely to be enough to get next item into view
			$iVertScroll = 20
		EndIf
	EndIf

	; Get top item
	Local $iTopIndex_Org = _GUICtrlListView_GetTopIndex($hLVHandle)

	; If native ListView column width to be retained then save column widths - normally widened if data too wide for existing width
	If $fRetainWidth And $iLV_CID Then
		$iColCount = _GUICtrlListView_GetColumnCount($hGLVEx_SrcHandle)
		; Store column widths
		Local $aCol_Width[$iColCount]
		For $i = 1 To $iColCount - 1
			$aCol_Width[$i] = _GUICtrlListView_GetColumnWidth($hGLVEx_SrcHandle, $i)
		Next
	EndIf

	_GUICtrlListView_BeginUpdate($hLVHandle)

	; Empty ListView
	_GUICtrlListView_DeleteAllItems($hLVHandle)

	; Check array to fill ListView
	If UBound($aLV_Array, 2) Then

		; Remove count line from stored array
		Local $aArray = $aLV_Array
		_ArrayDelete($aArray, 0)

		; Load ListView content
		Local $cLV_CID = $aGLVEx_Data[$iLV_Index][1]
		If $cLV_CID Then
			; Native ListView
			Local $sLine, $iLastCol = UBound($aArray, 2) - 1
			For $i = 0 To UBound($aArray) - 1
				$sLine = ""
				For $j = 0 To $iLastCol
					$sLine &= $aArray[$i][$j] & "|"
				Next
				GUICtrlCreateListViewItem(StringTrimRight($sLine, 1), $cLV_CID)
			Next
		Else
			; UDF ListView
			_GUICtrlListView_AddArray($hLVHandle, $aArray)
		EndIf

		; Reset checkbox if required
		For $i = 1 To $aLV_Array[0][0]
			If $fCheckBox And $aCheck_Array[$i] Then
				_GUICtrlListView_SetItemChecked($hLVHandle, $i - 1)
			EndIf
		Next

		; Now scroll to same place or max possible
		Local $iTopIndex_Curr = _GUICtrlListView_GetTopIndex($hLVHandle)
		While $iTopIndex_Curr < $iTopIndex_Org
			_GUICtrlListView_Scroll($hLVHandle, 0, $iVertScroll)
			; If scroll had no effect then max scroll up
			If _GUICtrlListView_GetTopIndex($hLVHandle) = $iTopIndex_Curr Then
				ExitLoop
			Else
				; Reset current top index
				$iTopIndex_Curr = _GUICtrlListView_GetTopIndex($hLVHandle)
			EndIf
		WEnd
	EndIf

	; Reset column widths if needed
	If $fRetainWidth And $iLV_CID Then
		For $i = 1 To $iColCount - 1
			$aCol_Width[$i] = _GUICtrlListView_SetColumnWidth($hGLVEx_SrcHandle, $i, $aCol_Width[$i])
		Next
	EndIf

	_GUICtrlListView_EndUpdate($hLVHandle)

EndFunc   ;==>__GUIListViewEx_ReWriteLV

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_GetLVCoords
; Description ...: Gets screen coords for ListView
; Author ........: Melba23
; Modified ......:
; ===============================================================================================================================
Func __GUIListViewEx_GetLVCoords($hLV_Handle, ByRef $tLVPos)

	; Get handle of ListView parent
	Local $aWnd = DllCall("user32.dll", "hwnd", "GetParent", "hwnd", $hLV_Handle)
	Local $hWnd = $aWnd[0]
	; Get position of ListView within GUI client area
	Local $aLVPos = WinGetPos($hLV_Handle)
	DllStructSetData($tLVPos, "X", $aLVPos[0])
	DllStructSetData($tLVPos, "Y", $aLVPos[1])
	_WinAPI_ScreenToClient($hWnd, $tLVPos)

EndFunc   ;==>__GUIListViewEx_GetLVCoords

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_GetCursorWnd
; Description ...: Gets handle of control under the mouse cursor
; Author ........: Melba23
; Modified ......:
; ===============================================================================================================================
Func __GUIListViewEx_GetCursorWnd()

	Local $iOldMouseOpt = Opt("MouseCoordMode", 1)
	Local $tMPos = DllStructCreate("struct;long X;long Y;endstruct")
	DllStructSetData($tMPos, "X", MouseGetPos(0))
	DllStructSetData($tMPos, "Y", MouseGetPos(1))
	Opt("MouseCoordMode", $iOldMouseOpt)
	Return _WinAPI_WindowFromPoint($tMPos)

EndFunc   ;==>__GUIListViewEx_GetCursorWnd

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_Array_Add
; Description ...: Adds a specified value at the end of an existing 1D or 2D array.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_Array_Add(ByRef $avArray, $vAdd, $fMultiRow = False, $bCount = True)

	; Get size of the Array to modify
	Local $iIndex_Max = UBound($avArray)
	Local $iAdd_Dim

	; Get type of array
	Switch UBound($avArray, 0)
		Case 1     ; Checkbox array
			If UBound($vAdd, 0) = 2 Or $fMultiRow Then     ; 2D or 1D as rows
				$iAdd_Dim = UBound($vAdd, 1)
				ReDim $avArray[$iIndex_Max + $iAdd_Dim]
			Else     ; 1D as columns
				ReDim $avArray[$iIndex_Max + 1]
			EndIf

		Case 2     ; Data array
			; Get column count of data array
			Local $iDim2 = UBound($avArray, 2)
			If UBound($vAdd, 0) = 2 Then     ; 2D add
				; Redim the Array
				$iAdd_Dim = UBound($vAdd, 1)
				ReDim $avArray[$iIndex_Max + $iAdd_Dim][$iDim2]
				$avArray[0][0] += $iAdd_Dim
				; Add new elements
				Local $iAdd_Max = UBound($vAdd, 2)
				For $i = 0 To $iAdd_Dim - 1
					For $j = 0 To $iDim2 - 1
						; If Insert array is too small to fill Array then continue with blanks
						If $j > $iAdd_Max - 1 Then
							$avArray[$iIndex_Max + $i][$j] = ""
						Else
							$avArray[$iIndex_Max + $i][$j] = $vAdd[$i][$j]
						EndIf
					Next
				Next

			ElseIf $fMultiRow Then     ; 1D add as rows
				; Redim the Array
				$iAdd_Dim = UBound($vAdd, 1)
				ReDim $avArray[$iIndex_Max + $iAdd_Dim][$iDim2]
				$avArray[0][0] += $iAdd_Dim
				; Add new elements
				For $i = 0 To $iAdd_Dim - 1
					$avArray[$iIndex_Max + $i][0] = $vAdd[$i]
				Next

			Else     ; 1D add as columns
				; Redim the Array
				ReDim $avArray[$iIndex_Max + 1][$iDim2]
				If $bCount Then
					$avArray[0][0] += 1
				EndIf
				; Add new elements
				If IsArray($vAdd) Then
					; Get size of Insert array
					Local $vAdd_Max = UBound($vAdd)
					For $j = 0 To $iDim2 - 1
						; If Insert array is too small to fill Array then continue with blanks
						If $j > $vAdd_Max - 1 Then
							$avArray[$iIndex_Max][$j] = ""
						Else
							$avArray[$iIndex_Max][$j] = $vAdd[$j]
						EndIf
					Next
				Else
					; Fill Array with variable
					For $j = 0 To $iDim2 - 1
						$avArray[$iIndex_Max][$j] = $vAdd
					Next
				EndIf
			EndIf

	EndSwitch

EndFunc   ;==>__GUIListViewEx_Array_Add

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_Array_Insert
; Description ...: Adds a value at the specified index of a 1D or 2D array.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_Array_Insert(ByRef $avArray, $iIndex, $vInsert, $fMultiRow = False, $bCount = True)

	; Get size of the Array to modify
	Local $iIndex_Max = UBound($avArray)
	Local $iInsert_Dim = UBound($vInsert, 1)

	; Get type of array
	Switch UBound($avArray, 0)
		Case 1     ; Checkbox array
			If UBound($vInsert, 0) = 2 Or $fMultiRow Then     ; 2D or 1D as rows
				; Resize array
				ReDim $avArray[$iIndex_Max + $iInsert_Dim]

				; Move down all elements below the new index
				For $i = $iIndex_Max + $iInsert_Dim - 1 To $iIndex + 1 Step -1
					$avArray[$i] = $avArray[$i - 1]
				Next

			Else     ; 1D as columns

				; Resize array
				ReDim $avArray[$iIndex_Max + 1]

				; Move down all elements below the new index
				For $i = $iIndex_Max To $iIndex + 1 Step -1
					$avArray[$i] = $avArray[$i - 1]
				Next

				; Insert dragged element state
				$avArray[$iIndex] = $vInsert

			EndIf

		Case 2     ; Data array
			; If at end of array
			If $iIndex > $iIndex_Max - 1 Then
				__GUIListViewEx_Array_Add($avArray, $vInsert, $fMultiRow, $bCount)
				Return
			EndIf
			; Get column count of data array
			Local $iDim2 = UBound($avArray, 2)
			If UBound($vInsert, 0) = 2 Then     ; 2D insert
				; Redim the Array
				$iInsert_Dim = UBound($vInsert, 1)
				ReDim $avArray[$iIndex_Max + $iInsert_Dim][$iDim2]
				If $bCount Then
					$avArray[0][0] += $iInsert_Dim
				EndIf
				; Move down all elements below the new index
				For $i = $iIndex_Max + $iInsert_Dim - 1 To $iIndex + $iInsert_Dim Step -1
					For $j = 0 To $iDim2 - 1
						$avArray[$i][$j] = $avArray[$i - $iInsert_Dim][$j]
					Next
				Next
				; Add new elements
				Local $iInsert_Max = UBound($vInsert, 2)
				For $i = 0 To $iInsert_Dim - 1
					For $j = 0 To $iDim2 - 1
						; If Insert array is too small to fill Array then continue with blanks
						If $j > $iInsert_Max - 1 Then
							$avArray[$iIndex + $i][$j] = ""
						Else
							$avArray[$iIndex + $i][$j] = $vInsert[$i][$j]
						EndIf
					Next
				Next

			ElseIf $fMultiRow Then     ; 1D insert as rows
				; Redim the Array
				$iInsert_Dim = UBound($vInsert, 1)
				ReDim $avArray[$iIndex_Max + $iInsert_Dim][$iDim2]
				$avArray[0][0] += $iInsert_Dim
				; Move down all elements below the new index
				For $i = $iIndex_Max + $iInsert_Dim - 1 To $iIndex + $iInsert_Dim Step -1
					For $j = 0 To $iDim2 - 1
						$avArray[$i][$j] = $avArray[$i - $iInsert_Dim][$j]
					Next
				Next
				; Add new items
				For $i = 0 To $iInsert_Dim - 1
					$avArray[$iIndex + $i][0] = $vInsert[$i]
				Next

			Else     ; 1D insert as columns
				; Redim the Array
				ReDim $avArray[$iIndex_Max + 1][$iDim2]
				$avArray[0][0] += 1
				; Move down all elements below the new index
				For $i = $iIndex_Max To $iIndex + 1 Step -1
					For $j = 0 To $iDim2 - 1
						$avArray[$i][$j] = $avArray[$i - 1][$j]
					Next
				Next
				; Insert new elements
				If IsArray($vInsert) Then
					; Get size of Insert array
					Local $vInsert_Max = UBound($vInsert)
					For $j = 0 To $iDim2 - 1
						; If Insert array is too small to fill Array then continue with blanks
						If $j > $vInsert_Max - 1 Then
							$avArray[$iIndex][$j] = ""
						Else
							$avArray[$iIndex][$j] = $vInsert[$j]
						EndIf
					Next
				Else
					; Fill Array with variable
					For $j = 0 To $iDim2 - 1
						$avArray[$iIndex][$j] = $vInsert
					Next
				EndIf
			EndIf

	EndSwitch

EndFunc   ;==>__GUIListViewEx_Array_Insert

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_Array_Delete
; Description ...: Deletes a specified index from an existing 1D or 2D array.
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_Array_Delete(ByRef $avArray, $iIndex, $bDelCount = False)

	; Get size of the Array to modify
	Local $iIndex_Max = UBound($avArray)
	If $iIndex_Max = 0 Then Return

	; Get type of array
	Switch UBound($avArray, 0)
		Case 1     ; Checkbox array
			; Move up all elements below the new index
			For $i = $iIndex To $iIndex_Max - 2
				$avArray[$i] = $avArray[$i + 1]
			Next
			; Redim the Array
			ReDim $avArray[$iIndex_Max - 1]

		Case 2     ; Data array
			; Get size of second dimension
			Local $iDim2 = UBound($avArray, 2)
			; Move up all elements below the new index
			For $i = $iIndex To $iIndex_Max - 2
				For $j = 0 To $iDim2 - 1
					$avArray[$i][$j] = $avArray[$i + 1][$j]
				Next
			Next
			; Redim the Array
			ReDim $avArray[$iIndex_Max - 1][$iDim2]
			; If count element not being deleted
			If Not $bDelCount Then
				$avArray[0][0] -= 1
			EndIf

	EndSwitch

EndFunc   ;==>__GUIListViewEx_Array_Delete

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_Array_Swap
; Description ...: Swaps specified elements within a 1D or 2D array
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_Array_Swap(ByRef $avArray, $iIndex1, $iIndex2)

	Local $vTemp

	; Get type of array
	Switch UBound($avArray, 0)
		Case 1
			; Swap the elements via a temp variable
			$vTemp = $avArray[$iIndex1]
			$avArray[$iIndex1] = $avArray[$iIndex2]
			$avArray[$iIndex2] = $vTemp

		Case 2
			; Get size of second dimension
			Local $iDim2 = UBound($avArray, 2)
			; Swap the elements via a temp variable
			For $i = 0 To $iDim2 - 1
				$vTemp = $avArray[$iIndex1][$i]
				$avArray[$iIndex1][$i] = $avArray[$iIndex2][$i]
				$avArray[$iIndex2][$i] = $vTemp
			Next
	EndSwitch

	Return 0

EndFunc   ;==>__GUIListViewEx_Array_Swap

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_ToolTipHide
; Description ...: Called by Adlib to hide a tooltip displayed by _GUIListViewEx_ToolTipShow
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_ToolTipHide()
	; Cancel Adlib
	AdlibUnRegister("__GUIListViewEx_ToolTipHide")
	; Clear tooltip
	ToolTip("")
EndFunc   ;==>__GUIListViewEx_ToolTipHide

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_MakeString
; Description ...: Convert data/check/colour arrays to strings for saving
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_MakeString($aArray)

	If Not IsArray($aArray) Then Return SetError(1, 0, "")

	Local $sRet = ""
	Local $sDelim_Col = @CR
	Local $sDelim_Row = @LF

	Switch UBound($aArray, $UBOUND_DIMENSIONS)
		Case 1
			For $i = 0 To UBound($aArray, $UBOUND_ROWS) - 1
				$sRet &= $aArray[$i] & $sDelim_Row
			Next
			Return StringTrimRight($sRet, StringLen($sDelim_Col))

		Case 2
			For $i = 0 To UBound($aArray, $UBOUND_ROWS) - 1
				For $j = 0 To UBound($aArray, $UBOUND_COLUMNS) - 1
					$sRet &= $aArray[$i][$j] & $sDelim_Col
				Next
				$sRet = StringTrimRight($sRet, StringLen($sDelim_Col)) & $sDelim_Row
			Next
			Return StringTrimRight($sRet, StringLen($sDelim_Row))

		Case Else
			Return SetError(2, 0, "")
	EndSwitch

EndFunc   ;==>__GUIListViewEx_MakeString

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_MakeArray
; Description ...: Convert data/check/colour strings to arrays for loading
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_MakeArray($sString)

	If $sString = "" Then Return SetError(1, 0, "")

	Local $aRetArray, $aRows, $aItems
	Local $sRowDelimiter = @LF
	Local $sColDelimiter = @CR

	If StringInStr($sString, $sColDelimiter) Then
		; 2D array
		$aRows = StringSplit($sString, $sRowDelimiter)
		; Get column count
		StringReplace($aRows[1], $sColDelimiter, "")
		; Create array
		Local $aRetArray[$aRows[0]][@extended + 1]
		; Fill array
		For $i = 1 To $aRows[0]
			$aItems = StringSplit($aRows[$i], $sColDelimiter)
			For $j = 1 To $aItems[0]
				$aRetArray[$i - 1][$j - 1] = $aItems[$j]
			Next
		Next
	Else
		; 1D array
		$aRetArray = StringSplit($sString, $sRowDelimiter, $STR_NOCOUNT)
	EndIf

	Return $aRetArray

EndFunc   ;==>__GUIListViewEx_MakeArray

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_ColSort
; Description ...: Sort columns even if colour enabled
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_ColSort($hLV, $iLV_Index, ByRef $vSortSense, $iCol, $hUserSortFunction = 0, $bToggleSense = True)

	Local $aListViewContent = $aGLVEx_Data[$iLV_Index][2]
	Local $aColourSettings = $aGLVEx_Data[$iLV_Index][18]
	; Check there are items to sort
	Local $iItemCount = $aListViewContent[0][0]
	If $iItemCount Then
		; Set sort order
		Local $iDescending = 0
		If UBound($vSortSense) Then
			$iDescending = $vSortSense[$iCol]
		Else
			$iDescending = $vSortSense
		EndIf
		; Get column count
		Local $iColumnCount = UBound($aListViewContent, 2)
		; Check if colour enabled
		Local $fColourEnabled = ((IsArray($aGLVEx_Data[$iLV_Index][18])) ? (True) : (False))
		If $fColourEnabled Then
			; ReDim data to add columns for index value, ItemParam and colour settings
			ReDim $aListViewContent[UBound($aListViewContent)][($iColumnCount * 2) + 2]
			; Add colour data to array
			For $i = 1 To $iItemCount
				For $j = 0 To $iColumnCount - 1
					$aListViewContent[$i][$iColumnCount + $j + 2] = $aColourSettings[$i][$j]
				Next
			Next
		Else
			; ReDim data to add coluns for index value and ItemParam
			ReDim $aListViewContent[UBound($aListViewContent)][$iColumnCount + 2]
		EndIf
		; Determine indices for index and param elements
		Local Enum $iIndexValue = $iColumnCount, $iItemParam
		; Get selected items
		Local $sSelectedItems = _GUICtrlListView_GetSelectedIndices($hLV)
		Local $aSelectedItems
		If $sSelectedItems = "" Then
			; If no selection (colour enabled) then use stored value
			Local $aSelectedItems[2] = [1, $aGLVEx_Data[0][17]]
		Else
			$aSelectedItems = StringSplit($sSelectedItems, Opt('GUIDataSeparatorChar'))
		EndIf
		; Get checked items
		Local $aCheckedItems[$iItemCount + 1] = [0]
		For $i = 0 To $iItemCount - 1
			If _GUICtrlListView_GetItemChecked($hLV, $i) Then
				$aCheckedItems[0] += 1
				$aCheckedItems[$aCheckedItems[0]] = $i
			EndIf
		Next
		ReDim $aCheckedItems[$aCheckedItems[0] + 1]
		; Clear current focused and selected items and save item data in array
		Local $iFocused = -1
		For $i = 0 To $iItemCount - 1
			If $iFocused = -1 Then
				If _GUICtrlListView_GetItemFocused($hLV, $i) Then $iFocused = $i
			EndIf
			_GUICtrlListView_SetItemSelected($hLV, $i, False)
			_GUICtrlListView_SetItemChecked($hLV, $i, False)
			; Store index and param values
			$aListViewContent[$i + 1][$iIndexValue] = $i
			$aListViewContent[$i + 1][$iItemParam] = _GUICtrlListView_GetItemParam($hLV, $i)
		Next

		; Check which sort function to use on the clicked column within the array
		If IsFunc($hUserSortFunction) Then
			; Pass user function the standard 5 parameters
			; (ByRef LV content array, Descending variable, Start = 1 , End = 0, Column to sort)
			$hUserSortFunction($aListViewContent, $iDescending, 1, 0, $iCol)
		ElseIf $hUserSortFunction = -1 Then
			; Do nothing
		Else
			; Use standard sort function
			_ArraySort($aListViewContent, $iDescending, 1, 0, $iCol)
		EndIf

		; Enter the sorted ListView data
		For $i = 1 To $iItemCount     ; Rows
			For $j = 0 To $iColumnCount - 1     ; Columns
				_GUICtrlListView_SetItemText($hLV, $i - 1, $aListViewContent[$i][$j], $j)
				; Reset the colour array if colour enabled
				If $fColourEnabled Then
					$aColourSettings[$i][$j] = $aListViewContent[$i][$iColumnCount + $j + 2]
				EndIf
			Next
			; Reset item param
			_GUICtrlListView_SetItemParam($hLV, $i - 1, $aListViewContent[$i][$iItemParam])
			; Reset selected states
			For $j = 1 To $aSelectedItems[0]
				If $aListViewContent[$i][$iIndexValue] = $aSelectedItems[$j] Then
					$aGLVEx_Data[0][17] = $i - 1
					$aGLVEx_Data[$iLV_Index][20] = $i - 1
					If Not ($aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22]) Then
						If $aListViewContent[$i - 1][$iIndexValue] = $iFocused Then
							_GUICtrlListView_SetItemSelected($hLV, $i - 1, True, True)
						Else
							_GUICtrlListView_SetItemSelected($hLV, $i - 1, True)
						EndIf
						ExitLoop
					EndIf
				EndIf
			Next
			; Reset checked states
			For $j = 1 To $aCheckedItems[0]
				If $aListViewContent[$i][$iIndexValue] = $aCheckedItems[$j] Then
					_GUICtrlListView_SetItemChecked($hLV, $i - 1, True)
					ExitLoop
				EndIf
			Next
		Next
		; Check automatic sort sense toggle and adjust if required
		If $bToggleSense Then
			If UBound($vSortSense) Then
				$vSortSense[$iCol] = Not $iDescending
			Else
				$vSortSense = Not $iDescending
			EndIf
		EndIf

		; ReDim content array to remove additional columns
		ReDim $aListViewContent[UBound($aListViewContent)][$iColumnCount]
		; Store sorted arrays
		$aGLVEx_Data[$iLV_Index][2] = $aListViewContent
		$aGLVEx_Data[$iLV_Index][18] = $aColourSettings

		; Set flags using ListView index
		$aGLVEx_Data[0][19] = $iLV_Index     ; SortEvent
		$aGLVEx_Data[0][22] = 1     ; ColourEvent

	EndIf

EndFunc   ;==>__GUIListViewEx_ColSort

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_RedrawWindow
; Description ...: Redraw ListView after update
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_RedrawWindow($iLV_Index, $fForce = False)

	; Force redraw if colour used or single cell selection
	If $fForce Or $aGLVEx_Data[$iLV_Index][19] Or $aGLVEx_Data[$iLV_Index][22] Then
		; Force reload of redraw colour array
		$aGLVEx_Data[0][14] = 0
		; If Redraw flag set
		If $aGLVEx_Data[0][15] Then
			; Redraw ListView
			_WinAPI_RedrawWindow($aGLVEx_Data[$iLV_Index][0])
		EndIf
	EndIf

EndFunc   ;==>__GUIListViewEx_RedrawWindow

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........: __GUIListViewEx_CheckUserEditKey
; Description ...: Check keys pressed in ListView
; Author ........: Melba23
; Remarks .......:
; ===============================================================================================================================
Func __GUIListViewEx_CheckUserEditKey()

	Local $aKey = StringSplit($aGLVEx_Data[0][23], ";"), $iKeyValue
	; Set flag
	Local $fCheck = True
	; Check if keys required are pressed
	For $i = 1 To $aKey[0]
		; Convert to number
		$iKeyValue = Dec($aKey[$i])
		If Not _WinAPI_GetAsyncKeyState($iKeyValue) Then
			; Required key not pressed so clear flag
			$fCheck = False
			; No point in looking further
			ExitLoop
		EndIf
	Next

	Return $fCheck

EndFunc   ;==>__GUIListViewEx_CheckUserEditKey



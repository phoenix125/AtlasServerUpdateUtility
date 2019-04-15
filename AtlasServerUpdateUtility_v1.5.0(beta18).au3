#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\phoenix.ico
#AutoIt3Wrapper_Outfile=Builds\AtlasServerUpdateUtility_v1.5.0(beta18).exe
#AutoIt3Wrapper_Res_Comment=By Phoenix125 based on Dateranoth's ConanServerUtility v3.3.0-Beta.3
#AutoIt3Wrapper_Res_Description=Atlas Dedicated Server Update Utility
#AutoIt3Wrapper_Res_Fileversion=1.5.0.8
#AutoIt3Wrapper_Res_ProductName=AtlasServerUpdateUtility
#AutoIt3Wrapper_Res_ProductVersion=v1.5.0
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
#include <TrayConstants.au3> ; Required for the $TRAY_ICONSTATE_SHOW constant.
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
#include "GUIListViewEx.au3" ; EXTERNAL: GUIListViewEX

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

;~ Opt("MustDeclareVars", 1)
; All Servers
$aUtilVerStable = "v1.4.7" ; (2019-03-14)
$aUtilVerBeta = "v1.5.0(beta18)" ; (2019-04-14)

$aUtilName = "AtlasServerUpdateUtility"
$aServerEXE = "ShooterGameServer.exe"
$aConfigFile = "ServerGrid.json"
$aExperimentalString = "latest_experimental"
$aServerVer = 0
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
$aWebsite = "http://www.phoenix125.com/AtlasServerUpdateUtil.html"
Global $aIniFailFile = @ScriptDir & "\___INI_FAIL_VARIABLES___.txt"
Local $aServerSummaryFile = @ScriptDir & "\_SERVER_SUMMARY_.txt"
Global $aUtilUpdateFile = @ScriptDir & "\__UTIL_UPDATE_AVAILABLE___.txt"
Global $aFirstModBoot = True
Global $aModMsgInGame[10]
Global $aModMsgDiscord[10]
Global $aModMsgTwitch[10]
Global $aFirstBoot = True
Local $aFirstStartDiscordAnnounce = True
Global $aCloseRedis = True
Global $aShowUpdate = False
Global $aPIDRedisFile = $aFolderTemp & $aUtilName & "_lastpidredis.tmp"
Global $aPIDServerFile = $aFolderTemp & $aUtilName & "_lastpidserver.tmp"
Global $aUtilCFGFile = $aFolderTemp & $aUtilName & "_cfg.ini"
Global $aFolderLog = @ScriptDir & "\_Log\"
Global $aSteamCMDDir = @ScriptDir & "\SteamCMD"
Global $aGridSelectFile = @ScriptDir & "\" & $aUtilName & "GridStartSelect.ini"
;Global $aGridLocalFile = @ScriptDir & "\" & $aUtilName & "GridLocalSelect.ini"
Global $aSteamUpdateNow = False
Global $aOnlinePlayerLast = ""
Global $aRCONError = False
Global $aServerReadyTF = False
$aServerReadyOnce = True
Global $aNoExistingPID = True
Global $aGUIW = 500
Global $aGUIH = 250
Global $aPlayerCountShowTF = True
Global $aPlayerCountWindowTF = False
Global $iEdit = 0
Global $gOnlinePlayerWindow = 0
Global $tOnlinePlayerReady = False
;Global $aGUIClear = False
Global $aShowGUI = True
Global $aGUIMainActive = False
;~ Global $aFirstModCheck = False
Global $aGUILogWindowText = ""
Global $aGUIReady = False
Global $MainWindow, $gOnlinePlayerWindow = 9999 ; Predeclare GUI variables with dummy values to prevent firing the Case statements
Global $sGridIniReWrite = False
Global $LabelUtilReadyStatus = 0
Global $LogWindow = 99999

;Atlas Only
$aServerRedisCmd = "redis-server.exe"
$aServerRedisDir = "\AtlasTools\RedisDatabase"
;$aServerPIDRedis = "0"
Global $aServersMax = 400
Global $xTelnetCMD[$aServersMax]
Global $xServerStart[$aServersMax]
Global $aServerPID[$aServersMax]
Global $yServerAltSaveDir[$aServersMax]
Global $xServerModList[50]
Global $aServerModList = ""
Global $xServerGridExtraCMD[$aServersMax]
Global $xServerCrashNumber[$aServersMax]
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

; **** Temp
Global $aTotalPlayersOnline = "0"

$aUsePuttytel = "yes"
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
Global $aTimeCheck0 = _NowCalc()
Global $aTimeCheck1 = _NowCalc()
Global $aTimeCheck2 = _NowCalc()
Global $aTimeCheck3 = _NowCalc()
Global $aTimeCheck4 = _NowCalc()
; Global $aTimeCheck5 = _NowCalc()
; Global $aTimeCheck6 = _NowCalc()
Global $aTimeCheck7 = _NowCalc()
Global $aTimeCheck8 = _NowCalc()
$aBeginDelayedShutdown = 0
Global $aUpdateVerify = "no"
$aFailCount = 0
$aShutdown = 0
$aAnnounceCount1 = 0
$aErrorShutdown = 0

#EndRegion ;**** Global Variables ****

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
LogWrite(" ============================ " & $aUtilName & " " & $aUtilVersion & " Started ============================")
_FileWriteToLine($aIniFile, 3, "Version  :  " & $aUtilityVer, True)
Global $aStartText = $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF
Global $aSplashStartUp = SplashTextOn($aUtilName, $aStartText, 475, 110, -1, -1, $DLG_MOVEABLE, "")
;~ SplashTextOn($aUtilName, $aStartText, 400, 110, -1, -1, $DLG_MOVEABLE, "")
DirCreate($aFolderTemp)
DirCreate($aFolderLog)
FileDelete($aServerBatchFile)
FileWrite($aServerBatchFile, "@echo off" & @CRLF & "START """ & $aUtilName & """ """ & @ScriptDir & "\" & $aUtilName & "_" & $aUtilVersion & ".exe""" & @CRLF & "EXIT")
; ----------- Temporary until enough time has passed for most users to have updated
If FileExists(@ScriptDir & "\" & $aUtilName & "_lastpidredis.tmp") Then FileMove(@ScriptDir & "\" & $aUtilName & "_lastpidredis.tmp", $aPIDRedisFile)
If FileExists(@ScriptDir & "\" & $aUtilName & "_lastpidserver.tmp") Then FileMove(@ScriptDir & "\" & $aUtilName & "_lastpidserver.tmp", $aPIDServerFile)
FileMove(@ScriptDir & "\mod_*.tmp", $aFolderTemp & "*.*", 1)
FileMove(@ScriptDir & "\*.log*", $aFolderLog & "*.*", 1)
; ----------- Temporary until enough time has passed for most users to have updated
ReadCFG($aUtilCFGFile)
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from " & $aIniFile & ".")
;~ SplashTextOn($aUtilName, $aStartText & "Importing settings from " & $aIniFile & ".", 400, 110, -1, -1, $DLG_MOVEABLE, "")
ReadUini($aIniFile, $aLogFile)
Global $aConfigFull = $aServerDirLocal & "\ShooterGame\" & $aConfigFile
Global $aDefaultGame = $aServerDirLocal & "\ShooterGame\Config\DefaultGame.ini"
Global $aDefaultGUS = $aServerDirLocal & "\ShooterGame\Config\DefaultGameUserSettings.ini"
Global $aDefaultEngine = $aServerDirLocal & "\ShooterGame\Config\DefaultEngine.ini"

ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Checking for running server and redis processes.")
;~ SplashTextOn($aUtilName, $aStartText & "Checking for running server and redis processes.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
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

If $aUpdateUtil = "yes" And $aUtilReboot = "no" And ((_DateDiff('n', $aCFGLastUpdate, _NowCalc())) >= $aUpdateCheckInterval) Then
	UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName, $aSplashStartUp)
EndIf

; Atlas
;~ ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from " & $aConfigFile & ".")
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from " & $aConfigFile & ".")
;~ SplashTextOn($aUtilName, $aStartText & "Importing settings from " & $aConfigFile & ".", 400, 110, -1, -1, $DLG_MOVEABLE, "")
ImportConfig($aServerDirLocal, $aConfigFile)
;If $aServerRCONImport = "yes" Then
;	$aServerRCONPort=ImportRCON($aServerDirLocal, $xServerAltSaveDir, $aServerGridTotal)
;EndIf
$aTelnetPass = $aServerAdminPass

;~ For $i = 0 to ($aServerGridTotal - 1)
;~ 	If

If $aServerAltSaveDir = "" Then
	Global $xServerAltSaveDir[$aServerGridTotal]
	For $i = 0 To ($aServerGridTotal - 1)
		$xServerAltSaveDir[$i] = $xServergridx[$i] & $xServergridy[$i]
	Next
;~ 		Global $xServerAltSaveDir = ""
Else
	Global $xServerAltSaveDir = StringSplit($aServerAltSaveDir, ",", 2)
EndIf
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Importing settings from GridStartSelect.ini")
;~ SplashTextOn($aUtilName, $aStartText & "Importing settings from GridStartSelect.ini", 400, 110, -1, -1, $DLG_MOVEABLE, "")
GridStartSelect($aGridSelectFile, $aLogFile)

If $aServerUseRedis = "yes" Then
	$aServerPIDRedis = PIDReadRedis($aPIDRedisFile, $aSplashStartUp)
Else
	$aServerPIDRedis = ""
EndIf
$aServerPID = PIDReadServer($aPIDServerFile, $aSplashStartUp)

;~ $aServerPID = ResizeArray($aServerPID, $aServerGridTotal)
;~ $xServerStart = ResizeArray($xServerStart, $aServerGridTotal)
;~ $yServerAltSaveDir = ResizeArray($yServerAltSaveDir, $aServerGridTotal)
;~ $xTelnetCMD = ResizeArray($xTelnetCMD, $aServerGridTotal)

Global $aServerPlayers[$aServerGridTotal]

ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Preparing server startup scripts.")
;~ SplashTextOn($aUtilName, $aStartText & "Preparing server startup scripts.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
;~ If $xServerAltSaveDir = "" Then
;~ 	For $i = 0 To ($aServerGridTotal - 1)
;~ 		$yServerAltSaveDir[$i] = $xServergridx[$i] & $xServergridy[$i]
;~ 	Next
;~ 	If $aServerRCONImport = "yes" Then
;~ 		$xServerRCONPort = ImportRCON($aServerDirLocal, $yServerAltSaveDir, $aServerGridTotal, $xStartGrid)
;~ 	EndIf
;~ Else
If ($aServerRCONImport = "yes") Then
	$xServerRCONPort = ImportRCON($aServerDirLocal, $xServerAltSaveDir, $aServerGridTotal, $xStartGrid)
EndIf
;~ EndIf

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

If ($sInGameAnnounce = "yes") Or ($aTelnetCheckYN = "yes") Or ($aEnableRCON = "yes") Then
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
;~ 	SplashOff()
Else
	$aServerModCMD = ""
EndIf
$aFirstModBoot = False
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Preparing server start files.")
;~ SplashTextOn($aUtilName, $aStartText & "Preparing server start files.", 400, 110, -1, -1, $DLG_MOVEABLE, "")

;~ If $xServerAltSaveDir = "" Then
;~ 	For $i = 0 To ($aServerGridTotal - 1)
;~ 		$xServerStart[$i] = """" & $aServerDirFull & "\" & $aServerEXE & """ Ocean?ServerX=" & $xServergridx[$i] & "?ServerY=" & $xServergridy[$i] & "?AltSaveDirectoryName=" & $xServergridx[$i] & $xServergridy[$i] & "?ServerAdminPassword=" & $aServerAdminPass & "?MaxPlayers=" & $aServerMaxPlayers & "?ReservedPlayerSlots=" & $aServerReservedSlots & "?QueryPort=" & $xServerport[$i] & "?Port=" & $xServergameport[$i] & "?SeamlessIP=" & $xServerIP[$i] & $aServerMultiHomeFull & $xTelnetCMD[$i] & $aServerExtraCMD & $aServerModCMD
;~ 		If ($xStartGrid[$i] = "yes") Then
;~ 			LogWrite("", " Imported from " & $aConfigFile & ": Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " Port:" & $xServergameport[$i] & " GamePort:" & $xServerport[$i] & " SeamlessIP:" & $xServerIP[$i] & " RCONPort:" & $xServerRCONPort[$i + 1] & " Folder:" & $xServergridx[$i] & $xServergridy[$i])
;~ 		EndIf
;~ 		$yServerAltSaveDir[$i] = $xServergridx[$i] & $xServergridy[$i]
;~ 	Next
;~ Else
For $i = 0 To ($aServerGridTotal - 1)
	$xServerStart[$i] = """" & $aServerDirFull & "\" & $aServerEXE & """ Ocean?ServerX=" & $xServergridx[$i] & "?ServerY=" & $xServergridy[$i] & "?AltSaveDirectoryName=" & _
			$xServerAltSaveDir[$i] & "?ServerAdminPassword=" & $aServerAdminPass & "?MaxPlayers=" & $aServerMaxPlayers & "?ReservedPlayerSlots=" & $aServerReservedSlots & "?QueryPort=" & _
			$xServerport[$i] & "?Port=" & $xServergameport[$i] & "?SeamlessIP=" & $xServerIP[$i] & $aServerMultiHomeFull & $xTelnetCMD[$i] & $xServerGridExtraCMD[$i] & $aServerExtraCMD & $aServerModCMD
	If ($xStartGrid[$i] = "yes") Then
		LogWrite("", " Imported from " & $aConfigFile & ": Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " Port:" & $xServergameport[$i] & " GamePort:" & $xServerport[$i] & " SeamlessIP:" & $xServerIP[$i] & " RCONPort:" & $xServerRCONPort[$i + 1] & " Folder:" & $xServerAltSaveDir[$i])
	EndIf
Next
;~ EndIf
;If $aServerRCONImport = "yes" Then
;	$xServerRCONPort=ImportRCON($aServerDirLocal, $zServerAltSaveDir, $aServerGridTotal)
;EndIf

; Generic
;$aSteamCMDDir = $aServerDirLocal & "\SteamCMD"
Global $aSteamAppFile = $aServerDirLocal & "\steamapps\appmanifest_" & $aSteamAppID & ".acf"

If $aUtilReboot = "no" Then
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Checking for existance of external files.")
;~ 	SplashTextOn($aUtilName, $aStartText & "Checking for existance of external files.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	FileExistsFunc()
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Checking for existance of external scripts (if enabled).")
;~ 	SplashTextOn($aUtilName, $aStartText & "Checking for existance of external scripts (if enabled).", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	ExternalScriptExist()
EndIf

If $aRemoteRestartUse = "yes" Then
	ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Initializing Remote Restart.")
;~ 	SplashTextOn($aUtilName, $aStartText & "Initializing Remote Restart.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
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
;SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Preparing initial update check.", 400, 110, -1, -1, $DLG_MOVEABLE, "")

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
;~ SplashTextOn($aUtilName, $aStartText & "Starting servers.", 400, 110, -1, -1, $DLG_MOVEABLE, "")

If Not ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
	$aBeginDelayedShutdown = 0
	$aServerPIDRedis = ""
	$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir)
	PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
	;	If $xDebug Then
	LogWrite(" [Redis started (PID: " & $aServerPIDRedis & ")]", " [Redis started (PID: " & $aServerPIDRedis & ")] " & $xServerRedis)
	;	Else
	;		LogWrite(" [Redis started (PID: " & $aServerPIDRedis & ")]")
	;	EndIf
	;$aTimeCheck5 = _NowCalc()
EndIf
For $i = 0 To ($aServerGridTotal - 1)
	;	If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) And ($xStartGrid[$i] = "yes") Then
	If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) Then
		;		If $i = 0 Then
		;			$aSteamEXE = $aSteamCMDDir & "\steamcmd.exe +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 " & $aSteamExtraCMD & "+login anonymous +force_install_dir """ & $aServerDirLocal & """ +app_update " & $aSteamAppID
		;			If ($aValidate = "yes") Then
		;				$aSteamEXE = $aSteamEXE & " validate"
		;			EndIf
		;			$aSteamEXE = $aSteamEXE & " +quit"
		;			If $xDebug Then
		;				LogWrite(" [Running SteamCMD update] " & $aSteamEXE)
		;			Else
		;				LogWrite(" [Running SteamCMD update]")
		;			EndIf
		;			RunWait($aSteamEXE)
		;			SplashOff()
		;		EndIf
		If $xStartGrid[$i] = "yes" Then
			ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Starting server " & $xServergridx[$i] & $xServergridy[$i])
			$aServerPID[$i] = Run($xServerStart[$i])
			Sleep($aServerStartDelay * 1000)
			;			If $xDebug Then
			LogWrite(" [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")]", " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
			;			Else
			;				LogWrite(" [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")]")
			;			EndIf
		Else
			LogWrite(" [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " -*NOT*- STARTED] because it is set to ""no"" in " & $aGridSelectFile)
		EndIf
	EndIf
Next
PIDSaveServer($aServerPID, $aPIDServerFile)

If $aUtilReboot = "yes" Then
	$aUtilReboot = "no"
	IniWrite($aUtilCFGFile, "CFG", "aUtilReboot", $aUtilReboot)
EndIf

#EndRegion ;**** Startup Checks. Initial Log, Read INI, Check for Correct Paths, Check Remote Restart is bound to port. ****

#Region ;**** Tray Menu ****
ControlSetText($aSplashStartUp, "", "Static1", $aStartText & "Preparing GUI. Getting server information.")
;~ SplashTextOn($aUtilName, $aStartText & "Preparing GUI. Getting server information.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
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

SplashOff()
Local $tMsg = "BETA VERSION notice!" & @CRLF & _
		"- The main window updates every 10 seconds." & @CRLF & _
		"- Online Player Count updates independently." & @CRLF & _
		"- The CPU% is not functional yet." & @CRLF & _
		"- COMING SOON! Adjust server settings by clicking on main window." & @CRLF & _
		"- Some buttons temporarily open files in Notepad. Soon, they will be integrated into this program." & @CRLF & @CRLF & _
		"- Please report any problems to Discord or email: kim@kim125.com"
MsgBox(0, $aUtilName, $tMsg, 15)
AdlibRegister("RunUtilUpdate", 28800000)
Local $aSliderPrev = GUICtrlRead($UpdateIntervalSlider)
$aServerCheck = TimerInit()
Global $lLogTabWindow = 0, $lBasicEdit = 0, $lDetailedEdit = 0, $lOnlinePlayersEdit = 0, $lServerSummaryEdit = 0, $lConfigEdit = 0, $lGridSelectEdit = 0, $lServerGridEdit = 0, $lDefaultGameEdit = 0, $lDefaultGUSEdit = 0, $lDefaultEngineEdit = 0
While True ;**** Loop Until Closed ****
;~ 	_GUIListViewEx_EventMonitor()
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

	#CS
		Switch TrayGetMsg()
		Case $iTrayShowGUI
		$aShowGUI = True
		$aGUIMainActive = False
		ShowMainGUI()
		Case $iTrayShowConfig
		;TrayShowConfig()
		Case $iTrayAbout
		MsgBox($MB_SYSTEMMODAL, $aUtilName, $aUtilName & @CRLF & "Version: " & $aUtilVersion & @CRLF & @CRLF & "Install Path: " & @ScriptDir & @CRLF & @CRLF & "Discord: http://discord.gg/EU7pzPs" & @CRLF & "Website: http://www.phoenix125.com", 15)
		Case $iTrayUpdateUtilCheck
		F_UpdateUtilCheck()
		Case $iTrayUpdateUtilPause
		F_UpdateUtilPause()
		Case $iTraySendMessage
		F_SendMessage()
		Case $iTraySendRCON
		F_SendRCON()
		Case $iTrayUpdateServCheck
		F_UpdateServCheck()
		Case $iTrayUpdateServPause
		TrayUpdateServPause()
		Case $iTrayUpdateServUnPause
		TrayUpdateServUnPause()
		Case $iTrayPlayerCount
		F_ShowPlayerCount()
		Case $iTrayPlayerCheckPause
		TrayShowPlayerCheckPause()
		Case $iTrayPlayerCheckUnPause
		TrayShowPlayerCheckUnPause()
		Case $iTrayRemoteRestart
		F_RemoteRestart()
		Case $iTrayRestartNow
		F_RestartNow()
		Case $iTrayExitCloseY
		F_ExitCloseY()
		Case $iTrayExitCloseN
		F_ExitCloseN()
		EndSwitch
		;	Switch GUIGetMsg()
		;		Case $GUI_EVENT_CLOSE
		;			GUIDelete()
		;			$aPlayerCountWindowTF = False
		;			$aPlayerCountShowTF = False
		;	EndSwitch

		;~ 	$nMsg = GUIGetMsg()
		;~ 	Switch $nMsg
		Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
		;Exit
		GUIDelete()
		$aShowGUI = False
		$aGUIMainActive = False
		;		Case $MainWindow
		Case $ServerInfo
		Run("notepad.exe """ & $aServerSummaryFile & """")
		Case $Players
		F_ShowPlayerCount()
		Case $Config
		Run("notepad.exe " & $aIniFile)
		Case $LogFile
		Run("notepad.exe " & $aLogFile)
		Case $ExitShutDownServers
		F_ExitCloseY()
		Case $ExitDoNotShutDownServers
		F_ExitCloseN()
		Case $IconDiscord
		Run(@ComSpec & " /c " & "start http://discord.gg/EU7pzPs", "")
		Case $IconForum
		Run(@ComSpec & " /c " & "start http://phoenix125.createaforum.com/index.php", "")
		Case $IconHelp
		Run(@ComSpec & " /c " & "start http://www.phoenix125.com/AtlasHelp.html", "")
		Case $IconPhoenix
		Run(@ComSpec & " /c " & "start " & $aWebsite, "")
		Case $IconPhoenixMain
		Run(@ComSpec & " /c " & "start " & $aWebsite, "")
		Case $IconInfo
		MsgBox($MB_SYSTEMMODAL, $aUtilName, $aUtilName & @CRLF & "Version: " & $aUtilVersion & @CRLF & @CRLF & "Install Path: " & @ScriptDir & @CRLF & @CRLF & "Discord: http://discord.gg/EU7pzPs" & @CRLF & "Website: http://www.phoenix125.com", 15)
		Case $IconPause
		F_UpdateUtilPause()
		Case $IconUpdate
		F_UpdateUtilCheck()
		Case $UpdateMods
		;		Case $UpdateIntervalSlider
		Case $UpdateAtlas
		F_UpdateServCheck()
		Case $RemoteRestartAll
		F_RemoteRestart()
		Case $RestartNowAll
		F_RestartNow()
		Case $SendRCONAll
		F_SendRCON()
		Case $SendMsgAll
		F_SendMessage()
		Case $SendRCONSel
		F_SendRCON()
		Case $SendMsgSel
		F_SendMessage()
		Case $StartServers
		Case $StopServers
		EndSwitch
	#ce

	If TimerDiff($aServerCheck) > 10000 Then
		TraySetToolTip("Server process check in progress...")
		TraySetIcon($aIconFile, 201)
		GUICtrlSetImage($IconReady, $aIconFile, 203)
		GUICtrlSetData($LabelUtilReadyStatus, "Updating Server Info")

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
							CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
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
			$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir)
			;			If $xDebug Then
			LogWrite(" [Redis started (PID: " & $aServerPIDRedis & ")]", " [Redis started (PID: " & $aServerPIDRedis & ")] " & $xServerRedis)
			;			Else
			;				LogWrite(" [Redis started (PID: " & $aServerPIDRedis & ")]")
			;			EndIf
			;$aTimeCheck5 = _NowCalc()
		EndIf
		SplashOff()
		; ------------------------------
		For $i = 0 To ($aServerGridTotal - 1)
			If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) Then ; And ($xStartGrid[$i] = "yes") Then
				;			If $i = 0 Then
				;				If ((_DateDiff('n', $aTimeCheck6, _NowCalc())) < 8) Then
				;					If $aSteamFailCount > 2 Then
				;						$aErrorMsg = "!!! CRITICAL ERROR !!! Server STOPPED." & @CRLF & @CRLF & "SteamCMD update and/or the first grid server failed three times in a row." & @CRLF & _
				;								"Check your server config. You may need to backup your data, delete your " & $aGameName & " folder, rerun this utility to reinstall your server files, then restore your data."
				;						LogWrite(" [WARNING] " & $aErrorMsg)
				;						MsgBox($MB_OK, $aUtilityVer, $aErrorMsg)
				;						CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
				;						Exit
				;					Else
				;						$aSteamFailCount = $aSteamFailCount + 1
				;					EndIf
				;				Else
				;					$aSteamFailCount = 0
				;				EndIf
				;				;SteamcmdDelete($aSteamCMDDir)
				;				$aSteamEXE = $aSteamCMDDir & "\steamcmd.exe +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 " & $aSteamExtraCMD & " +login anonymous +force_install_dir """ & $aServerDirLocal & """ +app_update " & $aSteamAppID
				;				;If ($aValidate = "yes") Or ($aUpdateVerify = "yes") Then
				;				If ($aValidate = "yes") Then
				;					;			$aUpdateVerify = "no"
				;					$aSteamEXE = $aSteamEXE & " validate"
				;				EndIf
				;				If ((_DateDiff('n', $aTimeCheck5, _NowCalc())) >= 1) Then
				;					$aTimeCheck5 = _NowCalc()
				;				Else
				;					$aFailCount = $aFailCount + 1
				;				EndIf
				;				;If $aServerVer = 1 Then
				;				;	$aSteamEXE = $aSteamEXE & " -" & $aExperimentalString
				;				;EndIf
				;				$aSteamEXE = $aSteamEXE & " +quit"
				;				If $xDebug Then
				;					LogWrite(" [Running SteamCMD update] " & $aSteamEXE)
				;				Else
				;					LogWrite(" [Running SteamCMD update]")
				;				EndIf
				;				RunWait($aSteamEXE)
				;				$aTimeCheck6 = _NowCalc()
				;				SplashOff()
				;			EndIf
				;Sleep(5000)

				If $xStartGrid[$i] = "yes" Then
					$aServerPID[$i] = Run($xServerStart[$i])
					;					If $xDebug Then
					LogWrite(" [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")]", " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
					;					Else
					;						LogWrite(" [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")]")
					;					EndIf
					Sleep($aServerStartDelay * 1000)
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
				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
			EndIf
			;		EndIf
			$aTimeCheck2 = _NowCalc()
		EndIf
		#EndRegion ;**** Restart Server Every X Days and X Hours & Min****

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
			GUICtrlSetImage($IconReady, $aIconFile, 203)
			GUICtrlSetData($LabelUtilReadyStatus, "Check: Mod Update")
			CheckMod($aServerModList, $aSteamCMDDir, $aServerDirLocal, 0, False)
			GUICtrlSetData($LabelUtilReadyStatus, "Idle")
			GUICtrlSetImage($IconReady, $aIconFile, 204)
		EndIf
		If ($aCheckForUpdate = "yes") And ((_DateDiff('n', $aTimeCheck0, _NowCalc())) >= $aUpdateCheckInterval) And ($aBeginDelayedShutdown = 0) Then
			GUICtrlSetImage($IconReady, $aIconFile, 203)
			GUICtrlSetData($LabelUtilReadyStatus, "Check: Server Update")
;~ 			Local $bRestart = UpdateCheck(False)
			UpdateCheck(False, 0, False)
			GUICtrlSetData($LabelUtilReadyStatus, "Idle")
			GUICtrlSetImage($IconReady, $aIconFile, 204)
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
					SplashTextOn($aUtilName & ": " & $aServerName, "Daily server request. Restarting server . . .", 350, 50, -1, -1, $DLG_MOVEABLE, "")
					RunExternalScriptDaily()
				EndIf
				If $aRebootReason = "update" Then
					SplashTextOn($aUtilName & ": " & $aServerName, "New server update. Restarting server . . .", 350, 50, -1, -1, $DLG_MOVEABLE, "")
					RunExternalScriptUpdate()
				EndIf
				If $aRebootReason = "remoterestart" Then
					SplashTextOn($aUtilName & ": " & $aServerName, "Remote Restart request. Restarting server . . .", 350, 50, -1, -1, $DLG_MOVEABLE, "")
					RunExternalRemoteRestart()
				EndIf
				If $sInGameAnnounce = "yes" Then
					SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $sInGame10SecondMessage)
					Sleep(10000)
				EndIf
				CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)

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
		TraySetToolTip($aIconFile)
		TraySetIcon($aIconFile, 99)
		GUICtrlSetImage($IconReady, $aIconFile, 204)
		GUICtrlSetData($LabelUtilReadyStatus, "Idle")
	EndIf
	Sleep(100)
WEnd

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Define GUI Functions
Func GUI_Main_Close()
	GUISetState(@SW_HIDE, $GUIMainWindow)
	;	GUIDelete($MainWindow)
	$aShowGUI = False
	$aGUIMainActive = False
	TrayItemSetState($iTrayShowGUI, $TRAY_ENABLE)
EndFunc   ;==>GUI_Main_Close
Func GUI_Main_B_ServerInfo()
	LogWindow(4)
EndFunc   ;==>GUI_Main_B_ServerInfo
Func GUI_Main_B_Players()
	F_ShowPlayerCount()
EndFunc   ;==>GUI_Main_B_Players
Func GUI_Main_B_Config()
	LogWindow(5)
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
	F_ShowConfig()
EndFunc   ;==>GUI_Main_I_UtilConfig
Func GUI_Main_B_ModUpdates()
	F_ModUpdate()
EndFunc   ;==>GUI_Main_B_ModUpdates
Func GUI_Main_B_UpdateGame()
	F_UpdateServCheck()
EndFunc   ;==>GUI_Main_B_UpdateGame
Func GUI_Main_B_AllRmtRestart()
	F_RemoteRestart()
EndFunc   ;==>GUI_Main_B_AllRmtRestart
Func GUI_Main_B_AllRestartNow()
	F_RestartNow()
EndFunc   ;==>GUI_Main_B_AllRestartNow
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
	GUISetState(@SW_SHOWNORMAL, $GUIMainWindow)
	;	ShowMainGUI()
EndFunc   ;==>Tray_ShowGUI
Func Tray_ShowConfig()
	F_ShowConfig()
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
	Local $aFile = $aFolderLog & $aUtilName & "_Log_" & StringRegExpReplace($lBasicDDate[$i], "/", "-") & ".txt"
	Local $tTxt = FileRead($aFile)
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
	Local $aFile = $aFolderLog & $aUtilName & "_LogFull_" & StringRegExpReplace($lDetailedDDate[$i], "/", "-") & ".txt"
	Local $tTxt = FileRead($aFile)
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
	Local $aFile = $aFolderLog & $aUtilName & "_OnlineUserLog_" & StringRegExpReplace($lOnlinePlayersDDate[$i], "/", "-") & ".txt"
	Local $tTxt = FileRead($aFile)
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
	_GUICtrlRichEdit_SetText($lServerSummaryEdit, FileRead($aServerSummaryFile))
	SetFont($lServerSummaryEdit, $fFWFixedFont)
;~ 			_GUICtrlRichEdit_SetSel($lServerSummaryEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lServerSummaryEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lServerSummaryEdit) ; deselect all
;~ 		ControlSend("", "", $lServerSummaryEdit, "^+{Home}")
EndFunc   ;==>GUI_Log_ServerSummary_B_Button
Func GUI_Log_Config_B_Save()
;~ 	Local $tTxt = GUICtrlRead($lConfigEdit)
	Local $tTxt = _GUICtrlRichEdit_GetText($lConfigEdit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aIniFile & "_" & $tTime & ".bak"
	FileMove($aIniFile, $tFile, 1)
	FileWrite($aIniFile, $tTxt)
	SplashTextOn($aUtilName, $aUtilName & ".ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "_" & $tTime & ".bak", 475, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_Config_B_Save
Func GUI_Log_Config_B_Reset()
	_GUICtrlRichEdit_SetText($lConfigEdit, FileRead($aIniFile))
	SetFont($lConfigEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lConfigEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lConfigEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lConfigEdit) ; deselect all
EndFunc   ;==>GUI_Log_Config_B_Reset
Func GUI_Log_GridSelect_B_Save()
	Local $tTxt = _GUICtrlRichEdit_GetText($lGridSelectEdit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aGridSelectFile & "_" & $tTime & ".bak"
	FileMove($aGridSelectFile, $tFile, 1)
	FileWrite($aGridSelectFile, $tTxt)
	SplashTextOn($aUtilName, $aUtilName & "GridStartSelect.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aUtilName & "GridStartSelect.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_GridSelect_B_Save
Func GUI_Log_GridSelect_B_Reset()
	_GUICtrlRichEdit_SetText($lGridSelectEdit, FileRead($aGridSelectFile))
	SetFont($lGridSelectEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lGridSelectEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lGridSelectEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lGridSelectEdit) ; deselect all
EndFunc   ;==>GUI_Log_GridSelect_B_Reset
Func GUI_Log_ServerGrid_B_Save()
	Local $tTxt = _GUICtrlRichEdit_GetText($lServerGridEdit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aConfigFull & "_" & $tTime & ".bak"
	FileMove($aConfigFull, $tFile, 1)
	FileWrite($aConfigFull, $tTxt)
	SplashTextOn($aUtilName, $aConfigFile & " updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & $aConfigFile & "_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_ServerGrid_B_Save
Func GUI_Log_ServerGrid_B_Reset()
	_GUICtrlRichEdit_SetText($lServerGridEdit, FileRead($aConfigFull))
	SetFont($lServerGridEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lServerGridEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lServerGridEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lServerGridEdit) ; deselect all
;~ 		ControlSend("","", $lServerGridEdit, "^+{Home}")
EndFunc   ;==>GUI_Log_ServerGrid_B_Reset
Func GUI_Log_DefaultGame_B_Save()
	Local $tTxt = _GUICtrlRichEdit_GetText($lDefaultGameEdit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aDefaultGame & "_" & $tTime & ".bak"
	FileMove($aDefaultGame, $tFile, 1)
	FileWrite($aDefaultGame, $tTxt)
	SplashTextOn($aUtilName, "DefaultGame.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & "DefaultGame.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_DefaultGame_B_Save
Func GUI_Log_DefaultGame_B_Reset()
	_GUICtrlRichEdit_SetText($lDefaultGameEdit, FileRead($aDefaultGame))
	SetFont($lDefaultGameEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lDefaultGameEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lDefaultGameEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lDefaultGameEdit) ; deselect all
;~ 		ControlSend("","", $lDefaultGameEdit, "^+{Home}")
EndFunc   ;==>GUI_Log_DefaultGame_B_Reset
Func GUI_Log_DefaultGUS_B_Save()
	Local $tTxt = _GUICtrlRichEdit_GetText($lDefaultGUSEdit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aDefaultGUS & "_" & $tTime & ".bak"
	FileMove($aDefaultGUS, $tFile, 1)
	FileWrite($aDefaultGUS, $tTxt)
	SplashTextOn($aUtilName, "DefaultGameUserSettings.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & "DefaultGameUserSettings.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_DefaultGUS_B_Save
Func GUI_Log_DefaultGUS_B_Reset()
	_GUICtrlRichEdit_SetText($lDefaultGUSEdit, FileRead($aDefaultGUS))
	SetFont($lDefaultGUSEdit, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_SetSel($lDefaultGUSEdit, 0, -1) ; select all
;~ 		_GUICtrlRichEdit_SetFont($lDefaultGUSEdit, 9, $fFWFixedFont)
;~ 		_GUICtrlRichEdit_Deselect($lDefaultGUSEdit) ; deselect all
;~ 		ControlSend("","", $lDefaultGUSEdit, "^+{Home}")
EndFunc   ;==>GUI_Log_DefaultGUS_B_Reset
Func GUI_Log_DefaultEngine_B_Save()
	Local $tTxt = _GUICtrlRichEdit_GetText($lDefaultEngineEdit)
	Local $tTime = @YEAR & "-" & @MON & "-" & @MDAY & "_" & @HOUR & "-" & @MIN
	Local $tFile = $aDefaultEngine & "_" & $tTime & ".bak"
	FileMove($aDefaultEngine, $tFile, 1)
	FileWrite($aDefaultEngine, $tTxt)
	SplashTextOn($aUtilName, "DefaultEngine.ini updated." & @CRLF & @CRLF & "Backup created: " & @CRLF & "DefaultEngine.ini_" & $tTime & ".bak", 525, 110, -1, -1, $DLG_MOVEABLE, "")
	Sleep(3000)
	SplashOff()
EndFunc   ;==>GUI_Log_DefaultEngine_B_Save
Func GUI_Log_DefaultEngine_B_Reset()
	_GUICtrlRichEdit_SetText($lDefaultEngineEdit, FileRead($aDefaultEngine))
	SetFont($lDefaultEngineEdit, $fFWFixedFont)
EndFunc   ;==>GUI_Log_DefaultEngine_B_Reset

Func SetFont($tID, $tFont, $tSize = 9)
	_GUICtrlRichEdit_SetSel($tID, 0, -1) ; select all
	_GUICtrlRichEdit_SetFont($tID, $tSize, $tFont)
;~ 	_GUICtrlRichEdit_Deselect($tID) ; deselect all
;~ 	_GUICtrlRichEdit_Deselect($tID) ; deselect all
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
	GUICtrlSetImage($IconReady, $aIconFile, 203)
	GUICtrlSetData($LabelUtilReadyStatus, "Check: Mod Update")
	CheckMod($aServerModList, $aSteamCMDDir, $aServerDirLocal, 0, True)
	GUICtrlSetData($LabelUtilReadyStatus, "Idle")
	GUICtrlSetImage($IconReady, $aIconFile, 204)
	SplashOff()
EndFunc   ;==>F_ModUpdate

#Region ;**** INI Settings - User Variables ****

Func ReadUini($sIniFile, $sLogFile)
	If FileExists($aIniFailFile) Then
		FileDelete($aIniFailFile)
	EndIf
	Local $iIniError = ""
	Local $iIniFail = 0
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
	Global $aServerAdminPass = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Admin password ###", $iniCheck)
	Global $aServerMaxPlayers = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Max players ###", $iniCheck)
	Global $aServerReservedSlots = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Reserved slots ###", $iniCheck)
	Global $aServerRCONImport = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Import RCON ports from GameUserSettings.ini files? (yes/no) ###", $iniCheck)
	Global $aServerRCONIP = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "RCON IP (ex. 127.0.0.1 - Leave BLANK for server IP) ###", $iniCheck)
	Global $aServerRCONPort = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server RCON Port(s) (comma separated, grid order as in ServerGrid.json, ignore if importing RCON ports) ###", $iniCheck)
	Global $aServerAltSaveDir = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryName(s) (comma separated. Use same order as listed in ServerGrid.json. Leave blank for default 00,01,10, etc) ###", $iniCheck)
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
	Global $aCheckForUpdate = IniRead($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Check for server updates? (yes/no) ###", $iniCheck)
	Global $aUpdateCheckInterval = IniRead($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Update check interval in Minutes (05-59) ###", $iniCheck)
	;
	Global $aRestartDaily = IniRead($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Use scheduled restarts? (yes/no) ###", $iniCheck)
	Global $aRestartDays = IniRead($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $iniCheck)
	Global $bRestartHours = IniRead($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart hours (comma separated 00-23 ex.04,16) ###", $iniCheck)
	Global $bRestartMin = IniRead($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart minute (00-59) ###", $iniCheck)
	;
	Global $sAnnounceNotifyDaily = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before DAILY reboot (comma separated 0-60) ###", $iniCheck)
	Global $sAnnounceNotifyUpdate = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before UPDATES reboot (comma separated 0-60) ###", $iniCheck)
	Global $sAnnounceNotifyRemote = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before REMOTE RESTART reboot (comma separated 0-60) ###", $iniCheck)
	Global $sAnnounceNotifyModUpdate = IniRead($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before MOD UPDATE reboot (comma separated 0-60) ###", $iniCheck)
	;
	Global $sInGameAnnounce = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires telnet) (yes/no) ###", $iniCheck)
	Global $sInGameDailyMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement DAILY (\m - minutes) ###", $iniCheck)
	Global $sInGameUpdateMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $iniCheck)
	Global $sInGameRemoteRestartMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $iniCheck)
	Global $sInGameModUpdateMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement MOD UPDATE (\m - minutes, \x - Mod ID) ###", $iniCheck)
	Global $sInGame10SecondMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement 10 seconds before reboot ###", $iniCheck)
	;
	Global $sUseDiscordBotDaily = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for DAILY reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotUpdate = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for UPDATE reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotRemoteRestart = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for REMOTE RESTART reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotModUpdate = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for MOD UPDATE reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotServersUpYN = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message when all servers are back online (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotFirstAnnouncement = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for first ANNOUNCEMENT only? (reduces bot spam)(yes/no) ###", $iniCheck)
	;Global $sUseDiscordBotAppendServer - IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Append server name to beginning of messages? (yes/no) ###", $iniCheck)
	Global $sDiscordDailyMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $iniCheck)
	Global $sDiscordUpdateMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $iniCheck)
	Global $sDiscordRemoteRestartMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $iniCheck)
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
	Global $sUseTwitchBotModUpdate = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for MOD UPDATE reboot? (yes/no) ###", $iniCheck)
	Global $sUseTwitchFirstAnnouncement = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for first announcement only? (reduces bot spam)(yes/no) ###", $iniCheck)
	Global $sTwitchDailyMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $iniCheck)
	Global $sTwitchUpdateMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $iniCheck)
	Global $sTwitchRemoteRestartMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $iniCheck)
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
	;	Global $aLogHoursBetweenRotate = IniRead($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hours between log rotations ###", $iniCheck)
	;
	Global $aEnableRCON = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable RCON? Required for clean shutdown (yes/no) ###", $iniCheck)
	;	Global $aRCONSaveDelaySec = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Delay between saveworld and quit commands during shutdown in seconds (5-120) ###", $iniCheck)
	Global $aValidate = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Validate files with SteamCMD update? (yes/no) ###", $iniCheck)
	Global $aUpdateSource = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "For update checks, use (0)SteamCMD or (1)SteamDB.com ###", $iniCheck)
	Global $aUpdateUtil = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Check for " & $aUtilName & " updates? (yes/no) ###", $iniCheck)
	Global $aUtilBetaYN = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", $aUtilName & " version: (0)Stable, (1)Beta ###", $iniCheck)
	Global $aUsePuttytel = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Use puttytel for telnet client? (yes/no) ###", $iniCheck)
	Global $sObfuscatePass = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide passwords in log files? (yes/no) ###", $iniCheck)
	Global $aExternalScriptHideYN = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide external scripts when executed? (if yes, scripts may not execute properly) (yes/no) ###", $iniCheck)
	;	Global $aDebug = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable debug to output more log detail? (yes/no) ###", $iniCheck)

	If $iniCheck = $aServerDirLocal Then
		$aServerDirLocal = "D:\Game Servers\" & $aGameName & " Dedicated Server"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerDirLocal, "
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
	If $iniCheck = $aSteamExtraCMD Then
		$aSteamExtraCMD = ""
		$iIniFail += 1
		$iIniError = $iIniError & "SteamExtraCMD, "
	EndIf
	If $iniCheck = $aServerExtraCMD Then
		$aServerExtraCMD = "-log -server -servergamelog -NoBattlEye"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerExtraCMD, "
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
	If $iniCheck = $aServerAltSaveDir Then
		$aServerAltSaveDir = ""
		$iIniFail += 1
		$iIniError = $iIniError & "ServerAltSaveDir, "
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
		$aUpdateUtil = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "UpdateUtil, "
	EndIf
	If $iniCheck = $aUtilBetaYN Then
		$aUtilBetaYN = "1"
		$iIniFail += 1
		$iIniError = $iIniError & "UtilBetaYN, "
	EndIf
	If ($aUpdateSource = "1") And ($aUpdateCheckInterval < 30) Then
		$aUpdateCheckInterval = 30
		LogWrite(" [Update] NOTICE: SteamDB will ban your IP if you check too often. Update check interval set to 30 minutes")
		$iIniFail += 1
		$iIniError = $iIniError & "NOTICE: SteamDB will ban your IP if you check too often. Update check interval set to 30 minutes, "
	EndIf
	;	If $iniCheck = $aDebug Then
	;		$aDebug = "yes"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "Debug, "
	;	EndIf
	If $iIniFail > 0 Then
		iniFileCheck($sIniFile, $iIniFail, $iIniError)
	EndIf
	If $bDiscordBotUseTTS = "yes" Then
		$bDiscordBotUseTTS = True
	Else
		$bDiscordBotUseTTS = False
	EndIf
	Global $aDelayShutdownTime = 0
	If ($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes") Then
		$aDelayShutdownTime = $sAnnounceNotifyDaily
	EndIf
	;	If $aDebug = "yes" Then
	;		Global $xDebug = True ; This enables Debugging. Outputs more information to log file.
	;	Else
	;		Global $xDebug = False
	;	EndIf
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
		Global $aRemoteCnt = Int($aRemoteTime[0])
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
	LogWrite("", " . . . Server Folder = " & $aServerDirLocal)
	LogWrite("", " . . . SteamCMD Folder = " & $aSteamCMDDir)
	;	If ($sInGameAnnounce = "yes") Or ($aTelnetCheckYN = "yes") And ($aTelnetRequired = "1") Then
	;		LogWrite("RCON/Telnet Required", "RCON/Telnet required for in-game announcements and ROCN/Telnet KeepAlive checks. RCON/Telnet enabled and set to port: " & $aTelnetPort & ".")
	;	EndIf

EndFunc   ;==>ReadUini

Func iniFileCheck($sIniFile, $iIniFail, $iIniError)
	If FileExists($sIniFile) Then
		Local $aMyDate, $aMyTime
		_DateTimeSplit(_NowCalc(), $aMyDate, $aMyTime)
		Local $iniDate = StringFormat("%04i.%02i.%02i.%02i%02i", $aMyDate[1], $aMyDate[2], $aMyDate[3], $aMyTime[1], $aMyTime[2])
		FileMove($sIniFile, $sIniFile & "_" & $iniDate & ".bak", 1)
		UpdateIni($sIniFile)
		;		FileWriteLine($aIniFailFile, _NowCalc() & " INI MISMATCH: Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini. Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		Local $iIniErrorCRLF = StringRegExpReplace($iIniError, ", ", @CRLF & @TAB)
		FileWriteLine($aIniFailFile, _NowCalc() & @CRLF & " ---------- Parameters missing or changed ----------" & @CRLF & @CRLF & @TAB & $iIniErrorCRLF)
		LogWrite(" INI MISMATCH: Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini. Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		LogWrite(" INI MISMATCH: Parameters missing: " & $iIniFail)
		SplashOff()
		MsgBox(4096, "INI MISMATCH", "INI FILE WAS UPDATED." & @CRLF & "Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini:" & @CRLF & @CRLF & $iIniError & @CRLF & @CRLF & _
				"Backup created and all existing settings transfered to new INI." & @CRLF & @CRLF & "Please modify INI and restart." & @CRLF & @CRLF & "File created: ___INI_FAIL_VARIABLES___.txt" & @CRLF & @CRLF & _
				"Click OK to continue to run program.")
		Run("notepad " & $aIniFailFile, @WindowsDir)
;~ 		Exit
	Else
		UpdateIni($sIniFile)
		SplashOff()
		MsgBox(4096, "Default INI File Created", "Please Modify Default Values and Restart Program." & @CRLF & @CRLF & "IF NEW DEDICATED SERVER INSTALL:" & @CRLF & " - Once the server is installed and running," & @CRLF & _
				"Rt-Click on " & $aUtilName & " icon and shutdown server." & @CRLF & " - Then modify the server files and restart this utility.")
		LogWrite(" Default INI File Created . . Please Modify Default Values and Restart Program.")
		Exit
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
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryName(s) (comma separated. Use same order as listed in ServerGrid.json. Leave blank for default 00,01,10, etc) ###", $aServerAltSaveDir)
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
	IniWrite($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Check for server updates? (yes/no) ###", $aCheckForUpdate)
	IniWrite($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Update check interval in minutes (05-59) ###", $aUpdateCheckInterval)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Use scheduled restarts? (yes/no) ###", $aRestartDaily)
	IniWrite($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###", $aRestartDays)
	IniWrite($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart hours (comma separated 00-23 ex.04,16) ###", $bRestartHours)
	IniWrite($sIniFile, " --------------- SCHEDULED RESTARTS --------------- ", "Restart minute (00-59) ###", $bRestartMin)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before DAILY reboot (comma separated 0-60) ###", $sAnnounceNotifyDaily)
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before UPDATES reboot (comma separated 0-60) ###", $sAnnounceNotifyUpdate)
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before REMOTE RESTART reboot (comma separated 0-60) ###", $sAnnounceNotifyRemote)
	IniWrite($sIniFile, " --------------- ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement _ minutes before MOD UPDATE reboot (comma separated 0-60) ###", $sAnnounceNotifyModUpdate)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires telnet) (yes/no) ###", $sInGameAnnounce)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement DAILY (\m - minutes) ###", $sInGameDailyMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $sInGameUpdateMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $sInGameRemoteRestartMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement MOD UPDATE (\m - minutes, \x - Mod ID) ###", $sInGameModUpdateMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement 10 seconds before reboot ###", $sInGame10SecondMessage)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for DAILY reboot? (yes/no) ###", $sUseDiscordBotDaily)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for UPDATE reboot? (yes/no) ###", $sUseDiscordBotUpdate)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for REMOTE RESTART reboot? (yes/no) ###", $sUseDiscordBotRemoteRestart)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for MOD UPDATE reboot? (yes/no) ###", $sUseDiscordBotModUpdate)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message when all servers are back online (yes/no) ###", $sUseDiscordBotServersUpYN)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for first announcement only? (reduces bot spam)(yes/no) ###", $sUseDiscordBotFirstAnnouncement)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $sDiscordDailyMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $sDiscordUpdateMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $sDiscordRemoteRestartMessage)
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
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for MOD UPDATE reboot? (yes/no) ###", $sUseTwitchBotModUpdate)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for first announcement only? (reduces bot spam)(yes/no) ###", $sUseTwitchFirstAnnouncement)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $sTwitchDailyMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $sTwitchUpdateMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $sTwitchRemoteRestartMessage)
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
	;	IniWrite($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hours between log rotations ###", $aLogHoursBetweenRotate)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Validate files with SteamCMD update? (yes/no) ###", $aValidate)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable RCON? Required for clean shutdown (yes/no) ###", $aEnableRCON)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Delay between saveworld and quit commands during shutdown in seconds (5-120) ###", $aRCONSaveDelaySec)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "For update checks, use (0)SteamCMD or (1)SteamDB.com ###", $aUpdateSource)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Check for " & $aUtilName & " updates? (yes/no) ###", $aUpdateUtil)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", $aUtilName & " version: (0)Stable, (1)Beta ###", $aUtilBetaYN)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Use puttytel for telnet client? (yes/no)", $aUsePuttytel)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide passwords in log files? (yes/no) ###", $sObfuscatePass)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide external scripts when executed? (if yes, scripts may not execute properly) (yes/no) ###", $aExternalScriptHideYN)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable debug to output more log detail? (yes/no) ###", $aDebug)

EndFunc   ;==>UpdateIni
#EndRegion ;**** INI Settings - User Variables ****

Func ReadCFG($sIniFile)
	Local $iIniFail = 0
	Local $iniCheck = ""
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
	If $iniCheck = $aCFGLastVersion Then
		$aCFGLastVersion = $aUtilVersion
		$iIniFail += 1
	EndIf
	If $iIniFail > 0 Then
		IniWrite($sIniFile, "CFG", "aUtilReboot", $aUtilReboot)
		IniWrite($sIniFile, "CFG", "aUtilLastClose", $aUtilLastClose)
		IniWrite($sIniFile, "CFG", "aCFGLastUpdate", $aCFGLastUpdate)
		IniWrite($sIniFile, "CFG", "aCFGLastVersion", $aCFGLastVersion)
	EndIf
EndFunc   ;==>ReadCFG

Func CFGLastClose()
	IniWrite($aUtilCFGFile, "CFG", "aUtilLastClose", _NowCalc())
EndFunc   ;==>CFGLastClose

Func CFGUtilReboot($i = True)
	IniWrite($sIniFile, "CFG", "aUtilReboot", $i)
EndFunc   ;==>CFGUtilReboot

Func RunUtilUpdate()
	UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName)
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
		;				"Click (NO) to exit utility but leave servers and redis still running." & @CRLF & _
		;				"Click (CANCEL) to cancel and resume utility.", 15)
		;		$Shutdown = MsgBox(4100, "Shut Down?", "Do you wish to shutdown Server " & $aServerName & "?", 60)
		; ----------------------------------------------------------
		If $Shutdown = 6 Then ; YES
			LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
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
			LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
			$aCloseRedis = False
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
;~ 			If $aServerUseRedis = "yes" Then
;~ 				PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
;~ 			EndIf
			MsgBox(4096, $aUtilityVer, $aMsg, 20)
			LogWrite(" " & $aUtilityVer & " Stopped by User")
			Exit
			; ----------------------------------------------------------
		ElseIf $Shutdown = 2 Then
			;			SplashTextOn($aUtilName, "Shutdown canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			;			Sleep(2000)
			LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
			CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
;~ 			If $aRemoteRestartUse = "yes" Then
;~ 				TCPShutdown()
;~ 			EndIf
			PIDSaveServer($aServerPID, $aPIDServerFile)
			PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
			MsgBox(4096, $aUtilityVer, $aMsg, 20)
			LogWrite(" " & $aUtilityVer & " Stopped by User")
			; ----------------------------------------------------------
		EndIf
	Else
		;		LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
		;		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
		;		SplashOff()
		;		If ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
		;			LogWrite(" [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
		;			ProcessClose($aServerPIDRedis)
		;		EndIf
		;		If $aRemoteRestartUse = "yes" Then
		;			TCPShutdown()
		;		EndIf
		;		MsgBox(4096, $aUtilityVer, $aMsg, 20)
		;		LogWrite(" " & $aUtilityVer & " Stopped by User")
		;		Exit
	EndIf
EndFunc   ;==>Gamercide
#EndRegion ; **** Gamercide Shutdown Protocol ****

; -----------------------------------------------------------------------------------------------------------------------

Func CloseServer($ip, $port, $pass)
	If $aFirstBoot Then
		Global $aSplashCloseServer = 0
	Else
		Global $aSplashCloseServer = SplashTextOn($aUtilName & ": " & $aServerName, "Sending shutdown command to server(s) . . .", 550, 100, -1, -1, $DLG_MOVEABLE, "")
	EndIf
	CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, $aSplashCloseServer)
	ControlSetText($aSplashCloseServer, "", "Static1", "Sending shutdown command to server(s) . . .")
	$aServerReadyOnce = True
	$aServerReadyTF = False
	$aShutdown = 1
	$aFailCount = 0
	;$aRebootServerDelay = True
	;	Local $aRCONSaveDelaySleep = $aRCONSaveDelaySec * 1000
	LogWrite(" --------- Server(s) shutdown sequence beginning ---------")
	;	SplashTextOn($aUtilName, "Server shutdown sequence beginning." & @CRLF & "Saving world(s) with " & $aRCONSaveDelaySec & " second delay before shutting down.", 500, 75, -1, -1, $DLG_MOVEABLE, "")
	;	SendRCON($aServerIP, $aServer00RCONPort, $aServerAdminPass, $aRCONSaveGameCMD)
	;	Sleep($aRCONSaveDelaySleep)
	For $i = 0 To ($aServerGridTotal - 1)
		If ($xStartGrid[$i] = "yes") Then
			If ProcessExists($aServerPID[$i]) Then
				$aErrorShutdown = 1
				ControlSetText($aSplashCloseServer, "", "Static1", "Sending shutdown command to server: " & $xServergridx[$i] & $xServergridy[$i])
;~ 				SplashTextOn($aUtilName & ": " & $aServerName, "Sending shutdown command to server: " & $xServergridx[$i] & $xServergridy[$i], 550, 75, -1, -1, $DLG_MOVEABLE, "")
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aRCONShutdownCMD)
				Sleep(1000 * $aServerShutdownDelay)
			EndIf
		EndIf
	Next
	;SendRCON($aServerIP, $aServer00RCONPort, $aServerAdminPass, $aRCONShutdownCMD)
	;	SplashTextOn($aUtilName & ": " & $aServerName, "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . .", 550, 75, -1, -1, $DLG_MOVEABLE, "")
	;	Sleep(10000)
	;	SplashOff()
	$aErrorShutdown = 0
	LogWrite(" Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . .")
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
;~ 			SplashTextOn($aUtilName & ": " & $aServerName, "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . ." & @CRLF & @CRLF & "Countdown: " & ($aShutDnWait - $k), 550, 100, -1, -1, $DLG_MOVEABLE, "")
			ControlSetText($aSplashCloseServer, "", "Static1", "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . ." & @CRLF & @CRLF & "Countdown: " & ($aShutDnWait - $k))
			$aErrorShutdown = 0
		Else
			ExitLoop
		EndIf
	Next

	;	If ProcessExists($aServerPID[0]) Then
	;		SplashTextOn($aUtilName & ": " & $aServerName, "Server(s) still saving or not shutting down properly. . . " & @CRLF & "Waiting 30 more seconds for server(s) to finish saving world . . .", 550, 75, -1, -1, $DLG_MOVEABLE, "")
	;		Sleep(30000)
	;	EndIf

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
	;		If FileExists($aPIDRedisFile) Then
	;			FileDelete($aPIDRedisFile)
	;		EndIf
	If FileExists($aPIDServerFile) Then
		FileDelete($aPIDServerFile)
	EndIf
	If $aServerUseRedis = "yes" Then
		If $aCloseRedis Then
		Else
			PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
		EndIf
		$aCloseRedis = True
	EndIf
	;If ProcessExists($aServerPIDRedis) Then
	;	If ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
	;		LogWrite(" [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
	;		ProcessClose($aServerPIDRedis)
	;	EndIf

	;	If ProcessExists($aServerPIDRedis) Then
	;		LogWrite(" [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
	;		ProcessClose($aServerPIDRedis)
	;	EndIf
	LogWrite(" --------------- Server(s) shutdown sequence completed ----------")
	If $aSteamUpdateNow Then
		SteamUpdate($aSteamExtraCMD, $aSteamCMDDir, $aValidate)
	EndIf
	$aShutdown = 0
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
	;Global $xServerseamlessDataPort[100]
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
			;		$xServerseamlessDataPort[0] = "48018"
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

		;Local $kServerseamlessDataPort = "seamlessDataPort"
		Local $sConfigPathOpen = FileOpen($sConfigPath, 0)
		Local $sConfigRead = FileRead($sConfigPathOpen)
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
		;$xServerseamlessDataPort = _StringBetween($sConfigRead, """" & $kServerseamlessDataPort & """: ", ",")
		;Global $aServerseamlessDataPort = _ArrayToString($xServerseamlessDataPort)
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
Func GridStartSelect($sGridFile, $sLogFile)
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
	If $iIniFail > 0 Or $sGridIniReWrite Then
		GridFileStartCheck($sGridFile, $iIniFail, $iIniError)
	EndIf
EndFunc   ;==>GridStartSelect
Func GridFileStartCheck($sGridFile, $iIniFail, $tIniError)
	If FileExists($sGridFile) Then
		Local $aMyDate, $aMyTime
		_DateTimeSplit(_NowCalc(), $aMyDate, $aMyTime)
		Local $iniDate = StringFormat("%04i.%02i.%02i.%02i%02i", $aMyDate[1], $aMyDate[2], $aMyDate[3], $aMyTime[1], $aMyTime[2])
		FileMove($sGridFile, $sGridFile & "_" & $iniDate & ".bak", 1)
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
		SplashOff()
		Run("notepad " & $sGridFile, @WindowsDir)
		MsgBox(4096, $aUtilityVer, "Default GridStartSelect.ini file created." & @CRLF & @CRLF & "If you plan to run all grid servers, no change is needed. " & @CRLF & @CRLF & "If you want to only run selected grid servers or have remote servers, please modify the default values and restart program.")
		LogWrite(" Default " & $sGridFile & " file created. If you want to only run selected grid server(s), please modify the default values and restart program.")
		Exit
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

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Fail Count Announce ****
Func FailCountRun()
	LogWrite(" [--== CRITICAL ERROR! ==-- ] The " & $aGameName & " Dedicated Server (" & $aServerEXE & ") failed to start at least twice within 1 minute. Please check " & $aGameName & " config files and " & $aUtilName & ".ini file")
	CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
	MsgBox($MB_OK, $aUtilityVer, "[CRITICAL ERROR!] The " & $aGameName & " Dedicated Server (" & $aServerEXE & ") failed to start at least twice within 1 minute. " & @CRLF & @CRLF & "Please check " & $aGameName & " config files and " & $aUtilName & ".ini file and restart " & $aUtilName & ".")
	Exit
EndFunc   ;==>FailCountRun
#EndRegion ;**** Fail Count Announce ****

#Region ;**** Function to Send Message to Discord ****
Func _Discord_ErrFunc($oError)
	;	LogWrite(" [" & $aServerName & " (PID: " & $aServerPID & ")] Error: 0x" & Hex($oError.number) & " While Sending Discord Bot Message.")
	LogWrite(" [" & $aServerName & " Error: 0x" & Hex($oError.number) & " While Sending Discord Bot Message.")
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
		;		Local $sResponseText = ""
		;		If Not $xDebug Then
		LogWrite(" [Discord Bot] Message sent: " & $sBotMessage, " [Discord Bot] Message Status Code {" & $oStatusCode & "} " & "Message Response: " & $oHTTPOST.ResponseText)
		;		Else
		;			$sResponseText = "Message Response: " & $oHTTPOST.ResponseText
		;			LogWrite(" [Discord Bot] Message Status Code {" & $oStatusCode & "} " & "Message Response: " & $oHTTPOST.ResponseText)
		;		EndIf
	Next
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
	LogWrite(" [RCON In-Game Message Sent] " & $mMessage, "no") ; "no" = do not write to debug log file
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
				If $tMB = 6 Then
					$bUpdateRequired = True
					$aSteamUpdateNow = True
					$aUpdateVerify = "yes"
					RunExternalScriptUpdate()
					$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
					SteamcmdDelete($aSteamCMDDir)
					CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
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
					CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
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
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)

	ElseIf Not $aInstalledVersion[0] Then
		LogWrite(" [Update] Something went wrong retrieving Installed Version. Running update with -validate. (This is normal for new install)")
		SplashTextOn($aUtilName, "Something went wrong retrieving Installed Version." & @CRLF & "(This is normal for new install)" & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 450, 175, -1, -1, $DLG_MOVEABLE, "")
		$bUpdateRequired = True
		$aSteamUpdateNow = True
		$aUpdateVerify = "yes"
		RunExternalScriptUpdate()
		$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
		SteamcmdDelete($aSteamCMDDir)
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)

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
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
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
		LogWrite(" [Update] Using SteamDB " & $aBranch & " branch. Latest version: " & $hBuildID)
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
	RunWait($aSteamUpdateCheck, $aSteamCMDDir, @SW_MINIMIZE)
	Local Const $sFilePath = $sCmdDir & "\" & $sAppInfoTemp
	;	Local Const $sFilePath = $sCmdDir & "\app_info.tmp"
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
		Local $aAppInfo = StringSplit($sFileRead, '"buildid"', 1)

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
	EndIf
	Return $aReturn
EndFunc   ;==>GetInstalledVersion
#EndRegion ;**** Functions to Check for Update ****

; -----------------------------------------------------------------------------------------------------------------------

#Region	 ;**** Restart Server Scheduling Scripts ****
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

#EndRegion ;**** Restart Server Scheduling Scripts ****

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

#Region ;**** PassCheck - Checks if received password matches any of the known passwords ****
Func PassCheck($sPass, $sPassString)
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
#EndRegion ;**** PassCheck - Checks if received password matches any of the known passwords ****

#Region ;**** ObfPass - Obfuscates password string for logging
Func ObfPass($sObfPassString)
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
#EndRegion ;**** ObfPass - Obfuscates password string for logging

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

#Region ;**** Function to get IP from Restart Client ****
Func _TCP_Server_ClientIP($hSocket)
	Local $pSocketAddress, $aReturn
	$pSocketAddress = DllStructCreate("short;ushort;uint;char[8]")
	$aReturn = DllCall("ws2_32.dll", "int", "getpeername", "int", $hSocket, "ptr", DllStructGetPtr($pSocketAddress), "int*", DllStructGetSize($pSocketAddress))
	If @error Or $aReturn[0] <> 0 Then Return $hSocket
	$aReturn = DllCall("ws2_32.dll", "str", "inet_ntoa", "int", DllStructGetData($pSocketAddress, 3))
	If @error Then Return $hSocket
	$pSocketAddress = 0
	Return $aReturn[0]
EndFunc   ;==>_TCP_Server_ClientIP
#EndRegion ;**** Function to get IP from Restart Client ****

#Region ;**** Function to Check Request from Browser and return restart string if request is valid****
Func CheckHTTPReq($sRequest, $sKey = "restart")
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
#EndRegion ;**** Function to Check Request from Browser and return restart string if request is valid****

#Region ;**** Function to Check for Multiple Password Failures****
Func MultipleAttempts($sRemoteIP, $bFailure = False, $bSuccess = False)
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
#EndRegion ;**** Function to Check for Multiple Password Failures****

#Region ;**** Uses other Functions to check connection, verify request is valid, verify restart code is correct, gather IP, and send proper message back to User depending on request received****
Func _RemoteRestart($vMSocket, $sCodes, $sKey, $sHideCodes, $sServIP, $sName, $bDebug = True)
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

Func LogWrite($msg, $msgdebug = "blank")
	$aLogFile = $aFolderLog & $aUtilName & "_Log_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
	$aLogDebugFile = $aFolderLog & $aUtilName & "_LogFull_" & @YEAR & "-" & @MON & "-" & @MDAY & ".txt"
	If $msg <> "" Then
		FileWriteLine($aLogFile, _NowCalc() & $msg)
		$aGUILogWindowText = _NowTime(5) & $msg & @CRLF & StringLeft($aGUILogWindowText, 10000)
		If $aGUIReady Then GUICtrlSetData($LogTicker, $aGUILogWindowText)
	EndIf
	If $msgdebug <> "no" Then
		If $msgdebug = "blank" Then
			FileWriteLine($aLogDebugFile, _NowCalc() & $msg)
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

#EndRegion ;**** Uses other Functions to check connection, verify request is valid, verify restart code is correct, gather IP, and send proper message back to User depending on request received****

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
Func FileExistsFunc()
	Local $sFileExists = FileExists($aSteamCMDDir & "\steamcmd.exe")
	If $sFileExists = 0 Then
		InetGet("https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip", @ScriptDir & "\steamcmd.zip", 0)
		DirCreate($aSteamCMDDir) ; to extract to
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
			DirCreate(@ScriptDir) ; to extract to
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

#Region ;**** Download and install mod updates ****
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
	For $i = 1 To $aMods[0]
		$aMods[$i] = StringStripWS($aMods[$i], 8)
		Local $aLatestTime = GetLatestModUpdateTime($aMods[$i], $tShow)
		$aModName[$i] = $aLatestTime[3]
		Local $aInstalledTime = GetInstalledModUpdateTime($sServerDir, $aMods[$i], $aModName[$i], $tShow)
		Local $bStopUpdate = False
		If Not $aLatestTime[0] Or Not $aLatestTime[1] Then
			$xError = True
			SplashOff()
			Local $aErrorMsg = "Something went wrong downloading update information for mod [" & $aMods[$i] & "] If running Windows Server, Disable ""IE Enhanced Security Configuration"" for Administrators (via Server Manager > Local Server > IE Enhanced Security Configuration)."
			LogWrite(" [Mod] " & $aErrorMsg)
;~ 			If $aFirstModCheck Then
			If $tShow Then
				MsgBox($MB_OK, $aUtilityVer, $aErrorMsg, 5)
			EndIf
			$aSplashStartUp = SplashTextOn($aUtilName, $aStartText, 475, 110, -1, -1, $DLG_MOVEABLE, "")
		ElseIf Not $aInstalledTime[0] Then
			$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, 0, $i) ;No Manifest. Download First Mod
			If $bStopUpdate Then ExitLoop
		ElseIf Not $aInstalledTime[1] Then
			$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, 1, $i) ;Mod does not exists. Download
			If $bStopUpdate Then ExitLoop
		ElseIf $aInstalledTime[1] And (StringCompare($aLatestTime[2], $aInstalledTime[2]) <> 0) Then
			$xError = True
			$bStopUpdate = UpdateMod($aMods[$i], $aModName[$i], $sSteamCmdDir, $sServerDir, 2, $i) ;Mod Out of Date. Update.
			If $bStopUpdate Then ExitLoop
		EndIf
	Next
;~ 	$aFirstModCheck = False
;~ 	SplashTextOn($aUtilName, $aUtilName & " " & $aUtilVersion & " started." & @CRLF & @CRLF & "Mod update check complete.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	;	WriteModList($sServerDir)
	If ($aBeginDelayedShutdown <> 1) And ($xError = False) Then
		LogWrite(" [Mod] Mods are Up to Date.")
	EndIf
EndFunc   ;==>CheckMod

Func GetLatestModUpdateTime($sMod, $sShow)
	Local $aReturn[4] = [False, False, "", ""]
	Local Const $sFilePath = $aFolderTemp & "mod_" & $sMod & "_latest_ver.tmp"
	Local $zModName = ""
	;	If $xDebug Then
	LogWrite("", " [Mod] Checking for mod update: http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
	;	EndIf
	;	$sFileRead = _HTTP_ResponseText("http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
	$sFileRead = _INetGetSource("http://steamcommunity.com/sharedfiles/filedetails/changelog/" & $sMod)
	If @error Then
		$aReturn[0] = False
	Else
		$aReturn[0] = True ;File Exists
		Local $aAppInfo = StringSplit($sFileRead, 'Update:', 1)
		If UBound($aAppInfo) >= 3 Then
			$aAppInfo = StringSplit($aAppInfo[2], '">', 1)
		EndIf
		If UBound($aAppInfo) >= 2 Then
			$aAppInfo = StringSplit($aAppInfo[1], 'id="', 1)
		EndIf
		If UBound($aAppInfo) >= 2 And StringRegExp($aAppInfo[2], '^\d+$') Then
			$aReturn[1] = True ;Successfully Read numerical value at positition expected
			$aReturn[2] = $aAppInfo[2] ;Return Value Read
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
	SplashTextOn($aUtilName, " Mod " & $sMod & " " & $sModName & @CRLF & " update released or new mod." & @CRLF & "Downloading and installing mod update.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	Local $aModScript = @ScriptDir & "\AtlasModDownloader.exe  --modids " & $sMod & " --steamcmd """ & $sSteamCmdDir & """ --workingdir """ & $sServerDir & """"
	;	If $xDebug Then
	LogWrite(" [Mod] Mod " & $sMod & " " & $sModName & " update released or new mod found. Downloading and installing mod.", " [Mod] Mod " & $sMod & " " & $sModName & " update released or new mod found. Downloading and installing mod:" & $aModScript)
	;	Else
	;		LogWrite(" [Mod] Mod " & $sMod & " " & $sModName & " update released or new mod found. Downloading and installing mod.")
	;	EndIf
	$aModMsgInGame = AnnounceReplaceModID($sMod, $sModMsgInGame, $sAnnounceNotifyModUpdate, $sModNo)
	$aModMsgDiscord = AnnounceReplaceModID($sMod, $sModMsgDiscord, $sAnnounceNotifyModUpdate, $sModNo)
	$aModMsgTwitch = AnnounceReplaceModID($sMod, $sModMsgTwitch, $sAnnounceNotifyModUpdate, $sModNo)

	RunWait($aModScript)
	If FileExists($sSteamCmdDir & "\steamapps\workshop\" & $aModAppWorkshop) Then
		FileMove($sSteamCmdDir & "\steamapps\workshop\" & $aModAppWorkshop, $aFolderTemp & "mod_" & $sMod & "_appworkshop.tmp", 1)
	EndIf
	$aRebootReason = "mod"
	$aBeginDelayedShutdown = 1
	RunExternalScriptMod()
	SplashOff()

	;	If ProcessExists("steamcmd.exe") And FileExists($sSteamCmdDir & "\inuse.tmp") Then
	;		LogWrite("A different Script is currently using SteamCMD in this directory. Skipping Mod " & $sMod & " Update for Now")
	;		$bReturn = True ;Tell Previous Function to Exit Loop.
	;	ElseIf ProcessExists($g_sConanPID) Then
	;		LogWrite("Mod Update Found but Server is Currently Running.")
	;		If ($sUseDiscordBotScheduled = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotScheduled = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($g_sUseInGameScheduled = "yes") Or ($g_sUseInGameUpdate = "yes") Then
	;			Global $aBotMsg = $sAnnounceModUpdateMessage
	;			$g_iBeginDelayedShutdown = 1
	;		Else
	;			CloseServer()
	;		EndIf
	;		$bReturn = True ;Tell Previous Function to Exit Loop.
	;	Else
	;		FileWriteLine($sSteamCmdDir & "\inuse.tmp", "Conan Server Utility Using SteamCMD to Update Mod. If Steam Command is not running, delete this file.")
	;		Local Const $sModManifest = "\steamapps\workshop\appworkshop_440900.acf"
	;		If FileExists($sSteamCmdDir & $sModManifest) Then
	;			FileMove($sSteamCmdDir & $sModManifest, $sSteamCmdDir & $sModManifest & ".BAK")
	;		EndIf
	;		If FileExists($sServerDir & $sModManifest) Then
	;			FileMove($sServerDir & $sModManifest, $sSteamCmdDir & $sModManifest, 1 + 8)
	;		EndIf
	;		RunWait("" & $sSteamCmdDir & "\steamcmd.exe +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +workshop_download_item 440900 " & $sMod & " +exit")
	;		If FileExists($sSteamCmdDir & "\steamapps\workshop\content\440900\" & $sMod) Then
	;			UpdateModNameList($sSteamCmdDir, $sMod)
	;			FileMove($sSteamCmdDir & "\steamapps\workshop\content\440900\" & $sMod & "\*.pak", $sServerDir & "\ConanSandbox\Mods\", 1 + 8)
	;			DirRemove($sSteamCmdDir & "\steamapps\workshop\content\440900\" & $sMod, 1)
	;		EndIf
	;		If FileExists($sSteamCmdDir & $sModManifest) Then
	;			FileMove($sSteamCmdDir & $sModManifest, $sServerDir & "\steamapps\workshop\appworkshop_440900.acf", 1 + 8)
	;		EndIf
	;		Switch $iReason
	;			Case 0
	;				LogWrite("No mod manifest existed. Downloaded First Mod " & $sMod & " to create Manifest. Should only see this once.")
	;			Case 1
	;				LogWrite("Mod " & $sMod & " did not exist. Downloaded.")
	;			Case 2
	;				LogWrite("Mod " & $sMod & " was out of date. Updated")
	;		EndSwitch
	;		$bReturn = False ;Tell Previous To Continue.
	;		Local $hTimeOutTimer = TimerInit()
	;		While FileExists($sSteamCmdDir & "\inuse.tmp")
	;			FileDelete($sSteamCmdDir & "\inuse.tmp")
	;			If @error Then ExitLoop
	;			If TimerDiff($hTimeOutTimer) > 10000 Then ExitLoop
	;		WEnd
	;	EndIf
	;
	Return $bReturn
EndFunc   ;==>UpdateMod
#EndRegion ;**** Functions to Check for Mod Updates ****

#Region ;**** Check for Server Utility Update ****
Func UtilUpdate($tLink, $tDL, $tUtil, $tUtilName, $tSplash = 0)
	Local $tTxt = $aStartText & "Checking for " & $tUtilName & " updates."
	If $tSplash > 0 Then
		ControlSetText($tSplash, "", "Static1", $tTxt)
	Else
		SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
	EndIf
;~ 		SplashTextOn($aUtilName, $aStartText & "Checking for " & $tUtilName & " updates.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	Local $tVer[2]
	;	$sFilePath = @ScriptDir & "\" & $aUtilName & "_latest_ver.tmp"
	;	If FileExists($sFilePath) Then
	;		FileDelete($sFilePath)
	;	EndIf
	;	InetGet($tLink, $sFilePath, 1)
	;	$hFileRead = _HTTP_ResponseText($tLink)
	$hFileRead = _INetGetSource($tLink)

	;	Local $hFileOpen = FileOpen($sFilePath, 0)
	If @error Then
		LogWrite(" [UTIL] " & $tUtilName & " update check failed to download latest version: " & $tLink)
		If $aShowUpdate Then
			Local $tTxt = $aStartText & $aUtilName & " update check failed." & @CRLF & "Please try again later."
			If $tSplash > 0 Then
				ControlSetText($tSplash, "", "Static1", $tTxt)
			Else
				SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			EndIf
			Sleep(2000)
;~ 			SplashTextOn($aUtilName, $aUtilName & " update check failed." & @CRLF & "Please try again later.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			$aShowUpdate = False
		EndIf
	Else
		;		Local $hFileRead = FileRead($hFileOpen)
		$tVer = StringSplit($hFileRead, "^", 2)
		If $tVer[0] = $tUtil Then
			;If $xDebug Then
			LogWrite(" [UTIL] " & $tUtilName & " up to date. Version: " & $tVer[0] & " , Notes: " & $tVer[1])
			If FileExists($aUtilUpdateFile) Then
				FileDelete($aUtilUpdateFile)
			EndIf
			;Else
			;LogWrite(" [UTIL] " & $tUtilName & " up to date.")
			;Endif
			If $aShowUpdate Then
				Local $tTxt = $aStartText & $aUtilName & " up to date . . ."
				If $tSplash > 0 Then
					ControlSetText($tSplash, "", "Static1", $tTxt)
				Else
					SplashTextOn($aUtilName, $tTxt, 400, 110, -1, -1, $DLG_MOVEABLE, "")
				EndIf
				Sleep(2000)
;~ 				SplashTextOn($aUtilName, $aUtilName & " up to date . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
				$aShowUpdate = False
			EndIf
		Else
			LogWrite(" [UTIL] New " & $aUtilName & " update available. Installed version: " & $tUtil & ", Latest version: " & $tVer[0] & ", Notes: " & $tVer[1])
			FileWrite($aUtilUpdateFile, _NowCalc() & " [UTIL] New " & $aUtilName & " update available. Installed version: " & $tUtil & ", Latest version: " & $tVer[0] & ", Notes: " & $tVer[1])
			SplashOff()
			$tVer[1] = ReplaceReturn($tVer[1])
			;			$tMB = MsgBox($MB_OKCANCEL, $aUtilityVer, "New " & $aUtilName & " update available. " & @CRLF & "Installed version: " & $tUtil & @CRLF & "Latest version: " & $tVer[0] & @CRLF & @CRLF & _
			;					"Notes: " & @CRLF & $tVer[1] & @CRLF & @CRLF & _
			;					"Click (OK) to download update to " & @CRLF & @ScriptDir & @CRLF & _
			;					"Click (CANCEL), or wait 30 seconds, to close this window.", 30)
			$tMB = MsgBox($MB_YESNOCANCEL, $aUtilityVer, "New " & $aUtilName & " update available. " & @CRLF & "Installed version: " & $tUtil & @CRLF & "Latest version: " & $tVer[0] & @CRLF & @CRLF & _
					"Notes: " & @CRLF & $tVer[1] & @CRLF & @CRLF & _
					"Click (YES) to download update to " & @CRLF & @ScriptDir & @CRLF & _
					"Click (NO) to stop checking for updates." & @CRLF & _
					"Click (CANCEL) to skip this update check.", 15)
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
					$tMB = MsgBox($MB_OKCANCEL, $aUtilityVer, "Download failed . . . " & @CRLF & "Go to """ & $tLink & """ to download latest version." & @CRLF & @CRLF & "Click (OK), (CANCEL), or wait 15 seconds, to resume current version.", 15)
				Else
					SplashOff()
					$tMB = MsgBox($MB_OKCANCEL, $aUtilityVer, "Download complete. . . " & @CRLF & @CRLF & "Click (OK) to run new version (servers will remain running) OR" & @CRLF & "Click (CANCEL), or wait 15 seconds, to resume current version.", 15)
					If $tMB = 1 Then
						LogWrite(" [" & $aServerName & "] Util Shutdown - Initiated by User to run update.")
						CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
						PIDSaveServer($aServerPID, $aPIDServerFile)
						PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
						Run(@ScriptDir & "\" & $tUtilName & "_" & $tVer[0] & ".exe")
						Exit
					EndIf
				EndIf
			ElseIf $tMB = 7 Then
				$aUpdateUtil = "no"
				IniWrite($aIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Check for " & $aUtilName & " updates? (yes/no) ###", "no")
				LogWrite(" [UTIL] " & "Utility update check disabled. To enable update check, change [Check for Updates ###=yes] in the .ini.")
				SplashTextOn($aUtilName, "Utility update check disabled." & @CRLF & "To enable update check, change [Check for Updates ###=yes] in the .ini.", 500, 110, -1, -1, $DLG_MOVEABLE, "")
				Sleep(5000)
			ElseIf $tMB = 2 Then
				LogWrite(" [UTIL] Utility update check canceled by user. Resuming utility . . .")
				SplashTextOn($aUtilName, "Utility update check canceled by user." & @CRLF & "Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
				Sleep(2000)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>UtilUpdate
#EndRegion ;**** Check for Server Utility Update ****

Func ReplaceReturn($tMsg0)
	If StringInStr($tMsg0, "|") = "0" Then
	Else
		Return StringReplace($tMsg0, "|", @CRLF)
	EndIf
EndFunc   ;==>ReplaceReturn

Func ReplaceSpace($tMsg0)
	If StringInStr($tMsg0, "%") = "0" Then
	Else
		Return StringReplace($tMsg0, "%", Chr(32))
	EndIf
EndFunc   ;==>ReplaceSpace

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
				", SeamlessIP:" & $xServerIP[$i] & ", RCON:" & $xServerRCONPort[$i + 1] & ", DIR:" & $xServerAltSaveDir[$i] & ", PID:" & $aServerPID[$i])
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
				"  Remote Reset Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/?" & $aRemoteRestartKey & "=" & $aRemoteRestartCode & @CRLF & _
				"    Remote Reset WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/?" & $aRemoteRestartKey & "=" & $aRemoteRestartCode & @CRLF & @CRLF & _
				"RCON Broadcast Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & _
				"  RCON Broadcast WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@broadcast%Admin%Says%Hi" & @CRLF & @CRLF & _
				"  RCON Command Local Link: http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)" & @CRLF & _
				"    RCON Command WAN Link: http://" & $aWAN & ":" & $aRemoteRestartPort & "/" & $aServerAdminPass & "@[command] (no brackets)")
	Else
		FileWriteLine($aServerSummaryFile, _
				"  Remote Reset Local Link: http://" & @CRLF & _
				"    Remote Reset WAN Link: http://" & @CRLF & @CRLF & _
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

Func F_ExitCloseN()
	LogWrite(" [" & $aServerName & "] Utility exit without server shutdown initiated by user (Exit: Do NOT Shut Down Servers).")
	;	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Do you wish to close this utility?" & @CRLF & "(all servers and redis will remain running)" & @CRLF & @CRLF & _
	;			"Click (YES) to close this utility." & @CRLF & _
	;			"Click (NO) or (CANCEL) to cancel.", 15)
	;	If $tMB = 6 Then ; (YES)
	SplashOff()
	MsgBox(4096, $aUtilityVer, "Thank you for using " & $aUtilName & "." & @CRLF & @CRLF & "SERVERS AND REDIS ARE STILL RUNNING ! ! !" & @CRLF & @CRLF & _
			"Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
			"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com", 20)
	LogWrite(" " & $aUtilityVer & " Stopped by User")
	PIDSaveServer($aServerPID, $aPIDServerFile)
	PIDSaveRedis($aServerPIDRedis, $aPIDRedisFile)
	CFGLastClose()
	CloseTCP($aRemoteRestartIP, $aRemoteRestartPort, 0)
;~ 	If $aRemoteRestartUse = "yes" Then
;~ 		TCPShutdown()
;~ 	EndIf
	Exit
	;	Else
	;		SplashTextOn($aUtilName, "Shutdown canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	;		Sleep(2000)
	;	EndIf
EndFunc   ;==>F_ExitCloseN

Func F_ExitCloseY()
	LogWrite(" [" & $aServerName & "] Utility exit with server shutdown initiated by user (Exit: Shut Down Servers).")
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
	If $tMB = 6 Then ; (YES)
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
		SplashOff()
		If ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
			LogWrite(" [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
			ProcessClose($aServerPIDRedis)
			If FileExists($aPIDRedisFile) Then
				FileDelete($aPIDRedisFile)
			EndIf
		EndIf
		SplashOff()
		MsgBox(4096, $aUtilityVer, "Thank you for using " & $aUtilName & "." & @CRLF & "Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
				"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com", 20)
		LogWrite(" " & $aUtilityVer & " Stopped by User")
		LogWrite(" " & $aUtilityVer & " Stopped")
		SplashOff()
		;		If FileExists($aPIDRedisFile) Then
		;			FileDelete($aPIDRedisFile)
		;		EndIf
		;		If FileExists($aPIDServerFile) Then
		;			FileDelete($aPIDServerFile)
		;		EndIf
		CFGLastClose()
		Exit
		; ----------------------------------------------------------
	ElseIf $tMB = 7 Then ; NO
		Local $aMsg = "Thank you for using " & $aUtilName & "." & @CRLF & "Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & _
				"Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com"
		LogWrite(" [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
		$aCloseRedis = False
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
		SplashOff()
		MsgBox(4096, $aUtilityVer, $aMsg, 20)
		LogWrite(" " & $aUtilityVer & " Stopped by User")
		Exit
		; ----------------------------------------------------------
	Else
		SplashTextOn($aUtilName, "Shutdown canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
		Sleep(2000)
	EndIf
EndFunc   ;==>F_ExitCloseY

Func F_RestartNow()
	LogWrite(" [Server] Restart Server Now requested by user (Restart Server Now) Redis will remain running.")
	$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "Do you wish to Restart Server Now?" & @CRLF & @CRLF & _
			"Click (YES) to Restart Server Now." & @CRLF & _
			"Click (NO) or (CANCEL) to cancel.", 15)
	If $tMB = 6 Then ; (YES)
		;		If $aBeginDelayedShutdown = 0 Then
		LogWrite(" [Server] Restart Server Now request initiated by user.")
		$aCloseRedis = False
		CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
		;		EndIf
	Else
		LogWrite(" [Server] Restart Server Now request canceled by user.")
		SplashTextOn($aUtilName, "Restart Server Now canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
		Sleep(2000)
	EndIf
	SplashOff()
EndFunc   ;==>F_RestartNow

Func F_RemoteRestart()
	LogWrite(" [Remote Restart] Remote Restart requested by user (Initiate Remote Restart).")
	If $aRemoteRestartUse <> "yes" Then
		$tMB = MsgBox($MB_YESNOCANCEL, $aUtilName, "You must enable Remote Restart in the " & $aUtilName & ".ini." & @CRLF & @CRLF & _
				"Would you like to enable it? (Port:" & $aRemoteRestartPort & ")" & @CRLF & _
				"Click (YES) to enable Remote Restart. A utility restart will be required (including shutting down all servers. COMING SOON, this will not be required)" & @CRLF & _
				"Click (NO) or (CANCEL) to skip.", 15)
		If $tMB = 6 Then ; (YES)
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
		If $tMB = 6 Then ; (YES)
			If $aBeginDelayedShutdown = 0 Then
				LogWrite(" [Remote Restart] Remote Restart request initiated by user.")
				If ($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes") Then
					$aRebootReason = "remoterestart"
					$aBeginDelayedShutdown = 1
					$aTimeCheck0 = _NowCalc()
				Else
					RunExternalRemoteRestart()
					$aCloseRedis = False
					CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
				EndIf
			EndIf
		Else
			LogWrite(" [Remote Restart] Remote Restart request canceled by user.")
			SplashTextOn($aUtilName, "Remote Restart canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		EndIf
	EndIf
EndFunc   ;==>F_RemoteRestart

Func F_UpdateUtilCheck()
	LogWrite(" [Update] " & $aUtilName & " update check requested by user (Check for Updates).")
	$aShowUpdate = True
	UtilUpdate($aServerUpdateLinkVerUse, $aServerUpdateLinkDLUse, $aUtilVersion, $aUtilName)
EndFunc   ;==>F_UpdateUtilCheck

Func F_UpdateServCheck()
	SplashOff()
	SplashTextOn($aUtilName, "Checking for server updates.", 400, 110, -1, -1, $DLG_MOVEABLE, "")
	GUICtrlSetImage($IconReady, $aIconFile, 203)
	GUICtrlSetData($LabelUtilReadyStatus, "Check: Server Update")
	UpdateCheck(True)
	GUICtrlSetData($LabelUtilReadyStatus, "Idle")
	GUICtrlSetImage($IconReady, $aIconFile, 204)
	SplashOff()
	;	LogWrite(" [Update] " & $aUtilName & " update check requested by user (Check for Updates).")
	;	$aShowUpdate = True
	;	UtilUpdate($aServerUpdateLinkBeta, $aServerUpdateLinkBeta, $aUtilVersion, $aUtilName)
EndFunc   ;==>F_UpdateServCheck

Func F_SendMessage($tAllorSel = "ask")
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
				If _GUICtrlListView_GetItemChecked($MainListViewWindow, $i) Then
					SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
				EndIf
			Next
			SplashTextOn($aUtilName, "Broadcast Message sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		EndIf
	EndIf
	SplashOff()
EndFunc   ;==>F_SendMessage

Func F_SendRCON($tAllorSel = "ask")
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
		$tMsg = InputBox($aUtilName, "Enter RCON command to send to all servers", "", "", 400, 125)
		If $tMsg = "" Then
			LogWrite(" [Remote RCON] Send RCON command canceled by user.")
			SplashTextOn($aUtilName, "Send RCON command canceled. Resuming utility . . .", 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		Else
			LogWrite(" [Remote RCON] Sending RCON command to all servers: " & $tMsg)
			SplashTextOn($aUtilName, "Sending RCON command to ALL servers. " & $tMsg, 5)
			For $i = 0 To ($aServerGridTotal - 1)
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
			Next
			SplashTextOn($aUtilName, "RCON command sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
			Sleep(2000)
		EndIf
	ElseIf $tAllorSel = "sel" Then
		$tMsg = InputBox($aUtilName, "Enter RCON command to send to selected servers", "", "", 400, 125)
		LogWrite(" [Remote RCON] Sending RCON command to selected servers:" & $tMsg)
		SplashTextOn($aUtilName, "Sending RCON command to selected servers. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
		For $i = 0 To ($aServerGridTotal - 1)
			If _GUICtrlListView_GetItemChecked($MainListViewWindow, $i) Then
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $tMsg, "no")
			EndIf
		Next
		SplashTextOn($aUtilName, "RCON command sent. " & $tMsg, 400, 110, -1, -1, $DLG_MOVEABLE, "")
		Sleep(2000)
	EndIf
	SplashOff()
EndFunc   ;==>F_SendRCON

Func SelectServersStop()
	LogWrite(" [Remote RCON] Send shutdown (DoExit) command to select servers requested by user (Stop Server(s)).")
	$tMsg1 = "Sending shutdown (DoExit) command to select servers."
	$aSplash = SplashTextOn($aUtilName, $tMsg1, 500, 110, -1, -1, $DLG_MOVEABLE, "")
	For $i = 0 To ($aServerGridTotal - 1)
		If _GUICtrlListView_GetItemChecked($MainListViewWindow, $i) Then
			ControlSetText($aSplash, "", "Static1", $tMsg1 & @CRLF & @CRLF & "Server IP:" & $xServerIP[$i] & " , Port:" & $xServerRCONPort[$i + 1])
			SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, "DoExit", "no")
			LogWrite($tMsg1 & " [Server] " & $tMsg1 & " IP:" & $xServerIP[$i] & " , Port:" & $xServerRCONPort[$i + 1])
			$xStartGrid[$i] = "no"
			$aGridSomeDisable = True
			IniWrite($aGridSelectFile, $aGridIniTitle[0], "Start Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ") (yes/no)", "no")
			$aServerPID[$i] = ""
		EndIf
	Next
	ControlSetText($aSplash, "", "Static1", $tMsg1 & "Shutdown command sent.")
	Sleep(2000)
	SplashOff()
EndFunc   ;==>SelectServersStop

Func SelectServersStart()
	LogWrite(" [Server] Start select servers requested by user (Start Server(s)).")
	$tMsg1 = "Starting select servers." & @CRLF & @CRLF
	$aSplash = SplashTextOn($aUtilName, $tMsg1, 500, 110, -1, -1, $DLG_MOVEABLE, "")
	For $i = 0 To ($aServerGridTotal - 1)
		If Not ProcessExists($aServerPID[$i]) And _GUICtrlListView_GetItemChecked($MainListViewWindow, $i) Then ; And ($xStartGrid[$i] = "yes") Then
			If ($xLocalGrid[$i] = "yes") Then
				ControlSetText($aSplash, "", "Static1", "Starting server " & $xServergridx[$i] & $xServergridy[$i])
				$aServerPID[$i] = Run($xServerStart[$i])
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
EndFunc   ;==>SelectServersStart

Func PIDSaveRedis($tPID, $tFile)
	If FileExists($tFile) Then
		FileDelete($tFile)
	EndIf
	FileWrite($tFile, $tPID)
EndFunc   ;==>PIDSaveRedis
Func PIDSaveServer($tPID, $tFile)
	If FileExists($tFile) Then
		FileDelete($tFile)
	EndIf
	Local $tTmp = _ArrayToString($tPID)
	FileWrite($tFile, $tTmp)
EndFunc   ;==>PIDSaveServer
Func PIDReadRedis($tFile, $tSplash = 0)
	;	If FileExists($tFile) Then
	Local $tTmp = FileOpen($tFile)
	If $tTmp = -1 Then
		$tReturn = "0"
		LogWrite("", " Existing Redis Server NOT running or file not found.")
	ElseIf $tTmp = "" Then ; Empty/Blank File
		$tReturn = "0"
		FileDelete($tFile)
		LogWrite("", " Existing Redis Server file corrupt. File deleted.")
	Else
		$tReturn = FileRead($tTmp)
		FileClose($tTmp)
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
	;	If FileExists($tFile) Then
	Local $tReturn[$aServersMax]
	Local $tTmp = FileOpen($tFile)
	If $tTmp = -1 Then ; File not exist
		$tReturn[0] = "0"
		LogWrite("", " Existing Grid Server(s) NOT running or file not found.")
		$aNoExistingPID = True
	Else
		$aNoExistingPID = False
		$tReturn1 = FileRead($tTmp)
		FileClose($tTmp)
		If $tReturn1 = "" Then ; Empty/Blank File
			$tReturn[0] = "0"
			LogWrite("", " Existing Grid Server(s) file corrupt. File Deleted.")
			$aNoExistingPID = True
			FileDelete($tFile)
		Else
;~ 			Local $tString = ""
			$dReturn = StringSplit($tReturn1, "|", 2)
			$tReturn = ResizeArray($dReturn, $aServersMax)
;~ 			For $i = 0 To UBound($tReturn - 1)
;~ 			For $i = 0 To ($aServersMax - 1)
;~ 				If $tReturn[$i] = "" Then
;~ 					Local $n = ($i - 1)
;~ 					ExitLoop
;~ 				EndIf
;~ 				$tString = $tString & $tReturn[$i] & ","
;~ 			Next
			Local $tPID = ""
			Local $tFound = 0
;~ 			For $i = 0 To $n
			For $i = 0 To $aServerGridTotal
				If ProcessExists($tReturn[$i]) Then
					LogWrite(" Server PID(" & $tReturn[$i] & ") found.")
					$tPID = $tPID & $tReturn[$i] & ","
					$tFound += 1
				Else
					LogWrite(" -ERROR- Server PID(" & $tReturn[$i] & ") NOT found. Server will be restarted.")
					$tReturn[$i] = ""
					$aNoExistingPID = True
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

Func SteamUpdate($aSteamExtraCMD, $aSteamCMDDir, $tValidateINI)
	SplashOff()
	$aSteamUpdateNow = False
	$aSteamEXE = $aSteamCMDDir & "\steamcmd.exe +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 " & $aSteamExtraCMD & "+login anonymous +force_install_dir """ & $aServerDirLocal & """ +app_update " & $aSteamAppID
	If ($tValidateINI = "yes") Or ($aUpdateVerify = "yes") Then
		$aSteamEXE = $aSteamEXE & " validate"
	EndIf
	$aSteamEXE = $aSteamEXE & " +quit"
	;	If $xDebug Then
	LogWrite(" [Running SteamCMD update]", " [Running SteamCMD update] " & $aSteamEXE)
	;	Else
	;		LogWrite(" [Running SteamCMD update]")
	;	EndIf
	RunWait($aSteamEXE)
	SplashOff()
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
	TraySetToolTip("Scanning servers for online players.")
	TraySetIcon($aIconFile, 201)
	GUICtrlSetImage($IconReady, $aIconFile, 203) ; Busy Icon
	GUICtrlSetData($LabelUtilReadyStatus, "Check: Players")
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
					For $x = 0 To ($tUserCnt - 1)
						$tUserLog = $tUserLog & $tUserAll[$x] & "." & $tSteamAll[$x] & "|"
						$tUserMsg = $tUserMsg & $tUserAll[$x] & " [" & $tSteamAll[$x] & "], "
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
						$tOnlinePlayers[3] = $tOnlinePlayers[3] & "Server " & $xServergridx[$i] & $xServergridy[$i] & ": " & $tUserCnt & " " & $tUserMsg & @CRLF
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
	TraySetToolTip($aIconFile)
	TraySetIcon($aIconFile, 99)
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
	;		Local $iEdit = GUICtrlCreateEdit(_DateTimeFormat(_NowCalc(), 0) & @CRLF & $tOnlinePlayers[2], 0, 0, 500, $aGUIH, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_READONLY), $WS_EX_STATICEDGE)
	;		GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
	;		GUICtrlSetLimit(-1, 0xFFFFFF)
	;		ControlClick($gOnlinePlayerWindow, "", $iEdit)
	;		GUISetState(@SW_SHOW) ;Shows the GUI window
	;	EndIf

EndFunc   ;==>ShowPlayerCount

Func ShowOnlinePlayersGUI()
	If $aServerOnlinePlayerYN = "yes" Then
		If $aPlayerCountShowTF Then
			;			If $iEdit <> 0 Then
			;				GUICtrlSetData($iEdit, "", 1)
			;			EndIf

			If $aPlayerCountWindowTF = False Then
				$gOnlinePlayerWindow = GUICreate($aUtilName & " Online Players", $aGUIW, $aGUIH, -1, -1, $WS_SIZEBOX)
				GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_OnlinePlayers_Close", $gOnlinePlayerWindow)
				$iEdit = GUICtrlCreateEdit("", 0, 0, _WinAPI_GetClientWidth($gOnlinePlayerWindow), _WinAPI_GetClientHeight($gOnlinePlayerWindow), BitOR($ES_AUTOHSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL, $ES_READONLY)) ; Horizontal Scroll, NO wrap text
				GUICtrlSetState($iEdit, $GUI_FOCUS)
				DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', '')
				;				GUICtrlSetResizing(-1, $GUI_DOCKAUTO)
				;				GUICtrlSetLimit(-1, 0xFFFFFF)
				$aPlayerCountWindowTF = True
				GUISetState(@SW_SHOWNORMAL, $gOnlinePlayerWindow) ;Shows the GUI window

			EndIf
			If $tOnlinePlayerReady Then
				;				If $aGUIClear Then
				;				GUICtrlSetData($gOnlinePlayerWindow, "")
				;					$aGUIClear = False
				;				EndIf
				;				$iEdit = GUICtrlCreateEdit(_DateTimeFormat(_NowCalc(), 0) & @CRLF & $tOnlinePlayers[2], 0, 0, $aGUIW, $aGUIH, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_READONLY), $WS_EX_STATICEDGE)
				;				GUICtrlSetData($iEdit, "")
				GUICtrlSetData($iEdit, _DateTimeFormat(_NowCalc(), 0) & @CRLF & $tOnlinePlayers[2])
				;				$iEdit = GUICtrlCreateEdit(_DateTimeFormat(_NowCalc(), 0) & @CRLF & $tOnlinePlayers[2], 0, 0, _WinAPI_GetClientWidth($gOnlinePlayerWindow), _WinAPI_GetClientHeight($gOnlinePlayerWindow), BitOR($ES_AUTOHSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL, $ES_READONLY)) ; Horizontal Scroll, NO wrap text
			Else
				;				$iEdit = GUICtrlCreateEdit(_DateTimeFormat(_NowCalc(), 0) & @CRLF & "Waiting for first Online Player check.", 0, 0, 0, 0, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_READONLY), $WS_EX_STATICEDGE)
				;				$iEdit = GUICtrlCreateEdit(_DateTimeFormat(_NowCalc(), 0) & @CRLF & "Waiting for first Online Player check.", 0, 0, $aGUIW, $aGUIH, BitOR($ES_AUTOVSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_VSCROLL, $WS_HSCROLL, $ES_READONLY), $WS_EX_STATICEDGE)
				GUICtrlSetData($iEdit, _DateTimeFormat(_NowCalc(), 0) & @CRLF & "Waiting for first Online Player check.")
				;				$iEdit = GUICtrlCreateEdit(_DateTimeFormat(_NowCalc(), 0) & @CRLF & "Waiting for first Online Player check.", 0, 0, _WinAPI_GetClientWidth($gOnlinePlayerWindow), _WinAPI_GetClientHeight($gOnlinePlayerWindow), BitOR($ES_AUTOHSCROLL, $ES_NOHIDESEL, $ES_WANTRETURN, $WS_HSCROLL, $WS_VSCROLL, $ES_READONLY)) ; Horizontal Scroll, NO wrap text
				;				$aGUIClear = True
			EndIf
			;			ControlClick($gOnlinePlayerWindow, "", $iEdit)
			;			GUISetState(@SW_SHOW) ;Shows the GUI window
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

Func ShowMainGUI($tSplash = 0)
;~ 	$aServerPID = ResizeArray($aServerPID)
	Global $aServerPI_Stripped = ResizeArray($aServerPID, $aServerGridTotal)
	Global $aServerMem = _GetMemArrayRawAvg($aServerPI_Stripped)
	$aGUIMainActive = True
	TrayItemSetState($iTrayShowGUI, $TRAY_DISABLE)
	#Region ### START Koda GUI section ### Form=G:\Game Server Files\AutoIT\AtlasServerUpdateUtility\Temp Work Files\atladkoda(b10-listview).kxf
	Global $GUIMainWindow = GUICreate($aUtilityVer, 1001, 701, -1, -1, $GUI_SS_DEFAULT_GUI)
	GUISetOnEvent($GUI_EVENT_CLOSE, "GUI_Main_Close", $GUIMainWindow)
	GUISetIcon($aIconFile, 99)
	GUISetBkColor($cMWBackground)
	Global $ShowWindows = GUICtrlCreateGroup("Show Window", 8, 48, 89, 145)
	Global $ServerInfo = GUICtrlCreateButton("Server Info", 16, 64, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_ServerInfo")
	GUICtrlSetTip(-1, "Display Server Summary Window")
	Global $Players = GUICtrlCreateButton("Players", 16, 96, 75, 25)
	If $aPlayerCountShowTF Then GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_Players")
	GUICtrlSetTip(-1, "Display Online Players Window")
	Global $Config = GUICtrlCreateButton("CONFIG", 16, 128, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_Config")
	GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
	GUICtrlSetTip(-1, "Display Config Window")
	Global $LogFile = GUICtrlCreateButton("Log/Ini Files", 16, 160, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_LogFile")
	GUICtrlSetTip(-1, "Display Latest Log File")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $RestartAllGrids = GUICtrlCreateGroup("Log", 8, 592, 985, 97)
	GUICtrlSetResizing(-1, $GUI_DOCKAUTO + $GUI_DOCKLEFT + $GUI_DOCKRIGHT + $GUI_DOCKBOTTOM)
	Global $LogTicker = GUICtrlCreateEdit("", 16, 608, 969, 73, BitOR($ES_AUTOVSCROLL, $ES_READONLY, $WS_VSCROLL))
	GUICtrlSetState($LogTicker, $GUI_FOCUS)
	DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', '')
	GUICtrlSetData(-1, $aGUILogWindowText)
	GUICtrlSetBkColor(-1, $cLWBackground)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $Header = GUICtrlCreateGroup("", 8, 0, 985, 49)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT + $GUI_DOCKTOP)
	$LabelMEM = GUICtrlCreateLabel("Mem: ", 292, 10, 33, 17)
	GUICtrlSetColor(-1, $cMWMemCPU)
	$LabelCPU = GUICtrlCreateLabel("CPU:", 293, 27, 29, 17)
	GUICtrlSetColor(-1, $cMWMemCPU)
	Local $MemStats = MemGetStats() ;Retrieves memory related information
	Global $MemPercent = GUICtrlCreateLabel($MemStats[$MEM_LOAD] & "%", 323, 11, 20, 17)
	GUICtrlSetColor(-1, $cMWMemCPU)
	Global $CPUPercent = GUICtrlCreateLabel("%", 322, 27, 24, 17)
	GUICtrlSetColor(-1, $cMWMemCPU)
	Global $ServerHeading = GUICtrlCreateLabel($aUtilityVer, 45, 15, 225, 28)
	GUICtrlSetFont(-1, 14, 800, 0, "MS Sans Serif")
	GUICtrlSetColor(-1, $cMWMemCPU)
	GUICtrlSetResizing(-1, $GUI_DOCKLEFT)
	Global $ExitShutDownServers = GUICtrlCreateButton("Exit: SHUT DOWN servers", 664, 16, 155, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_ExitShutDownY")
	Global $ExitDoNotShutDownServers = GUICtrlCreateButton("Exit: Do NOT shut down servers", 824, 16, 163, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_ExitShutDownN")
	Global $IconDiscord = GUICtrlCreateIcon($aIconFile, 209, 600, 16, 24, 24)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_DiscordServer")
	GUICtrlSetTip(-1, "Discord Server")
	Global $IconForum = GUICtrlCreateIcon($aIconFile, 208, 536, 16, 24, 24)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_DiscussionForum")
	GUICtrlSetTip(-1, "Discussion Forum")
	Global $IconHelp = GUICtrlCreateIcon($aIconFile, 213, 504, 16, 24, 24)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_Help")
	GUICtrlSetTip(-1, "Help")
	Global $IconPhoenix = GUICtrlCreateIcon($aIconFile, 99, 568, 16, 24, 24)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_MainWebpage")
	GUICtrlSetTip(-1, "Main Webpage")
	Global $IconPhoenixMain = GUICtrlCreateIcon($aIconFile, 99, 16, 16, 24, 24)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_MainWebpage")
	GUICtrlSetTip(-1, "Main Webpage")
	Global $IconInfo = GUICtrlCreateIcon($aIconFile, 207, 632, 16, 24, 24)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_About")
	GUICtrlSetTip(-1, "About")
	Global $IconPause = GUICtrlCreateIcon($aIconFile, 206, 376, 16, 24, 24)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_Pause")
	GUICtrlSetTip(-1, "Pause All AtlasServerUpdateUtility functions (Servers will remain running)")
	Global $IconUpdate = GUICtrlCreateIcon($aIconFile, 205, 408, 16, 24, 24)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_CheckForUtilUpdates")
	GUICtrlSetTip(-1, "Check for Updates for AtlasServerUpdateUtility")
	Global $IconConfig = GUICtrlCreateIcon($aIconFile, 211, 440, 16, 24, 24)
	GUICtrlSetOnEvent(-1, "GUI_Main_I_UtilConfig")
	GUICtrlSetTip(-1, "AtlasServerUpdateUtility Config")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $Update = GUICtrlCreateGroup("Update", 8, 504, 89, 89)
	Global $UpdateMods = GUICtrlCreateButton("Update Mods", 16, 552, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_ModUpdates")
	GUICtrlSetTip(-1, "Check for Mod Updates")
	Global $UpdateAtlas = GUICtrlCreateButton("Update Atlas", 16, 520, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_UpdateGame")
	GUICtrlSetTip(-1, "Check for Atlas Updates")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $RestartAllGrid = GUICtrlCreateGroup("All Grids", 8, 200, 89, 145)
	Global $RemoteRestartAll = GUICtrlCreateButton("Rmt Restart", 16, 280, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllRmtRestart")
	GUICtrlSetTip(-1, "Initiate Remote Restart: Restart All Local Grid Servers with Message and Delay")
	Global $RestartNowAll = GUICtrlCreateButton("Restart NOW", 16, 312, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllRestartNow")
	GUICtrlSetTip(-1, "Restart All Local Grid Servers")
	Global $SendRCONAll = GUICtrlCreateButton("Send RCON", 16, 216, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllSendRCON")
	GUICtrlSetTip(-1, "Send RCON Message to All Grids")
	Global $SendMsgAll = GUICtrlCreateButton("Send Msg", 16, 248, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_AllSendMsg")
	GUICtrlSetTip(-1, "Broadcast In Game Message to All Grids")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $MainListViewWindow = _GUICtrlListView_Create($GUIMainWindow, "", 112, 64, 873, 497, BitOR($LVS_NOLABELWRAP, $LVS_REPORT, $LVS_SINGLESEL))
	_GUICtrlListView_SetExtendedListViewStyle($MainListViewWindow, BitOR($LVS_EX_GRIDLINES, $LVS_EX_SUBITEMIMAGES, $LVS_EX_CHECKBOXES))
	_GUICtrlListView_SetBkColor($MainListViewWindow, $cSWBackground)
	_GUICtrlListView_SetTextBkColor($MainListViewWindow, $cSWBackground)
	GUICtrlSetFont(-1, 9, 400, 0, "MS Sans Serif")
	Global $aGUI_Main_Columns[12] = ["", "Run", "Local", "Rmt", "Server Name", "Grid", "Players", "CPU %", "Mem MB", "Folder", "PID", "Status"]
	Global $aGUI_Main_Widths[12] = [21, 32, 38, 38, 320, 35, 60, 50, 60, 60, 60, 70]
	For $i = 0 To (UBound($aGUI_Main_Columns) - 1)
		_GUICtrlListView_InsertColumn($MainListViewWindow, $i, $aGUI_Main_Columns[$i], $aGUI_Main_Widths[$i])
		_GUICtrlListView_JustifyColumn($MainListViewWindow, $i, 2)
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
	_GUICtrlListView_SetImageList($MainListViewWindow, $hImage, 1)

	Global $aMainLVW[$aServerGridTotal][12]
	For $i = 0 To ($aServerGridTotal - 1)
		$aMainLVW[$i][0] = "" ; $xStartGrid[$i] ; Checked YN
		If $xStartGrid[$i] <> "yes" Then
			$aMainLVW[$i][1] = "--" ; Local YN
		Else
			$aMainLVW[$i][1] = $xStartGrid[$i] ; Local YN
		EndIf
		If $xStartGrid[$i] <> "yes" Then
			$aMainLVW[$i][2] = "--" ; Local YN
		Else
			$aMainLVW[$i][2] = $xStartGrid[$i] ; Local YN
		EndIf
		If $xStartGrid[$i] = "yes" Then ; Remote YN
			$aMainLVW[$i][3] = "--"
		Else
			$aMainLVW[$i][3] = "yes"
		EndIf
		$aMainLVW[$i][4] = $xServerNames[$i] ; "Server " & $xServergridx[$i] & $xServergridy[$i] ; Server Name
		$aMainLVW[$i][5] = $xServergridx[$i] & $xServergridy[$i] ; Grid
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
		_GUICtrlListView_AddItem($MainListViewWindow, "", 0)
		For $x = 4 To 11
			_GUICtrlListView_AddSubItem($MainListViewWindow, $i, $aMainLVW[$i][$x], $x)
		Next
	Next

	For $i = 0 To ($aServerGridTotal - 1) ; Place icon for RUN column
		If $xStartGrid[$i] = "yes" Then
			_GUICtrlListView_AddSubItem($MainListViewWindow, $i, "", 1, 0)
		Else
			_GUICtrlListView_AddSubItem($MainListViewWindow, $i, "", 1, 1)
		EndIf
	Next
	For $i = 0 To ($aServerGridTotal - 1) ; Place icon for RUN column
		If $xLocalGrid[$i] = "yes" Then
			_GUICtrlListView_AddSubItem($MainListViewWindow, $i, "", 2, 4)
		Else
			_GUICtrlListView_AddSubItem($MainListViewWindow, $i, "", 3, 5)
;~ 				_GUICtrlListView_AddSubItem($MainListViewWindow, $i, "", 2, 3)
		EndIf
	Next

	; -----------------------------------------------------------------------------------------------

	Global $aGUIListViewEX = _GUIListViewEx_Init($MainListViewWindow, $aMainLVW, 0, 0, True, 2 + 32 + 1024)
	For $i = 0 To (UBound($aGUI_Main_Columns) - 1)
		_GUIListViewEx_SetEditStatus($aGUIListViewEX, $i) ; Default = standard text edit
	Next
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
	Global $UpdateIntervalSlider = GUICtrlCreateSlider(848, 565, 102, 21, BitOR($GUI_SS_DEFAULT_SLIDER, $TBS_NOTICKS))
	GUICtrlSetOnEvent(-1, "GUI_Main_S_UpdateIntervalSlider")
	GUICtrlSetLimit(-1, 600, 30)
	GUICtrlSetData(-1, $aServerOnlinePlayerSec)
	GUICtrlSetTip(-1, "Seconds: 30-600")
	GUICtrlSetBkColor(-1, $cMWBackground)
	Global $UpdateIntervalEdit = GUICtrlCreateEdit("", 952, 568, 33, 17, BitOR($ES_CENTER, $ES_WANTRETURN))
	GUICtrlSetOnEvent(-1, "GUI_Main_E_UpdateIntervalEdit")
	GUICtrlSetData(-1, $aServerOnlinePlayerSec)
	GUICtrlSetBkColor(-1, $cSWBackground)
	GUICtrlSetTip(-1, "Seconds: 30-600")
	Global $gPollOnlinePlayers = GUICtrlCreateCheckbox("Poll Online Players", 580, 564)
	GUICtrlSetOnEvent(-1, "GUI_Main_CB_PollOnlinePLayers")
	If $aServerOnlinePlayerYN = "yes" Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	Else
		GUICtrlSetState(-1, $GUI_UNCHECKED)
	EndIf
	Global $IconReady = GUICtrlCreateIcon($aIconFile, 204, 113, 563, 24, 24)
	Global $LabelUtilReadyStatus = GUICtrlCreateLabel("Idle", 144, 568, 120, 17)
	Global $gPollRemoteServersCB = GUICtrlCreateCheckbox("Poll Remote Servers", 295, 564)
;~ 	Global $gPollRemoteServersCB = GUICtrlCreateCheckbox(" ", 295, 564)
;~ 	Global $gPollRemoteServersLabel = GUICtrlCreateLabel("Poll Remote Servers", 310, 568, -1, -1, $WS_EX_TOPMOST)
	Global $gPollRemoteServersLabel = GUICtrlCreateLabel("Poll Remote Servers", 310, 568, -1, -1)
	GUICtrlSetOnEvent(-1, "GUI_Main_CB_PollRemoteServers")
	If $aPollRemoteServersYN = "yes" Then
		GUICtrlSetState(-1, $GUI_CHECKED)
	Else
		GUICtrlSetState(-1, $GUI_UNCHECKED)
	EndIf
	Global $LabelTotalPlayers = GUICtrlCreateLabel("Total Players: ", 432, 568, 71, 17)
	Global $TotalPlayersEdit = GUICtrlCreateEdit("", 504, 566, 57, 17, BitOR($ES_CENTER, $ES_READONLY))
	GUICtrlSetState($TotalPlayersEdit, $GUI_FOCUS)
	DllCall('user32.dll', 'int', 'HideCaret', 'hwnd', '')
;~ 	$aTotalPlayersOnline = _ArraySum($aServerPlayers)
	GUICtrlSetData(-1, $aTotalPlayersOnline & " / " & $aServerMaxPlayers)
	GUICtrlSetBkColor(-1, $cLWBackground)
	GUICtrlSetTip(-1, "Total Players Online")
;~ 		Global $LabelDblClick = GUICtrlCreateLabel("Dbl-Click to Change Value", 255, 568, 163, 17)
;~ 		GUICtrlSetFont(-1, 8, 800, 0, "MS Sans Serif")
;~ 		GUICtrlSetColor(-1, $cSWTextHL2)
;~ 		GUICtrlCreateGroup("", -99, -99, 1, 1)
	Global $SelectedGrids = GUICtrlCreateGroup("Selected Grids", 8, 352, 89, 145)
	Global $SendRCONSel = GUICtrlCreateButton("Send RCON", 16, 368, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectSendRCON")
	GUICtrlSetTip(-1, "Send RCON Message to Selected Grids")
	Global $SendMsgSel = GUICtrlCreateButton("Send Msg", 16, 400, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectSendMsg")
	GUICtrlSetTip(-1, "Send In Game Message to Selected Grids")
	Global $StartServers = GUICtrlCreateButton("Start Server(s)", 16, 432, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectStartServers")
	GUICtrlSetTip(-1, "Start Selected Grids")
	Global $StopServers = GUICtrlCreateButton("Stop Server(s)", 16, 464, 75, 25)
	GUICtrlSetOnEvent(-1, "GUI_Main_B_SelectStopServers")
	GUICtrlSetTip(-1, "Stop Selected Grids")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	#EndRegion ### END Koda GUI section ###

	If $aServerOnlinePlayerYN = "yes" Then
		$aOnlinePlayers = GetPlayerCount($tSplash)
		GUICtrlSetData($LabelUtilReadyStatus, "Idle")
	EndIf
	GUIUpdateQuick()
	If $aShowGUI Then
		GUISetState(@SW_SHOWNORMAL, $GUIMainWindow)
	Else
		GUISetState(@SW_HIDE, $GUIMainWindow)
	EndIf
	If $aServerOnlinePlayerYN = "yes" Then
		ShowPlayerCount()
	EndIf
	GUICtrlSetImage($IconReady, $aIconFile, 204)
	GUICtrlSetData($LabelUtilReadyStatus, "Idle")
;~ 	GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY_Main_UpdateIntervalSlider')    ; **** WM_NOTIFY SLIDER
EndFunc   ;==>ShowMainGUI

Func GUIUpdateQuick()
	Local $MemStats = MemGetStats()
	GUICtrlSetData($MemPercent, $MemStats[$MEM_LOAD] & "%")
;~ 	$LabelCPU = GUICtrlCreateLabel("CPU:", 293, 27, 29, 17)
;~ 	$CPUPercent = GUICtrlCreateLabel("%", 322, 27, 24, 17)
	Local $tMainLVW[$aServerGridTotal][12]
	$aServerPI_Stripped = ResizeArray($aServerPID, $aServerGridTotal)
	$aServerMem = _GetMemArrayRawAvg($aServerPI_Stripped)
	Local $tTotalPlayers = 0
	Local $tTotalPlayerError = False
	Local $aHasRemoteServersTF = False
	For $i = 0 To ($aServerGridTotal - 1)
;~ 		$tMainLVW[$i][0] = "" ; $xStartGrid[$i] ; Checked YN
		If $xStartGrid[$i] <> "yes" Then
			$tMainLVW[$i][1] = "--" ; Local YN
		Else
			$tMainLVW[$i][1] = $xStartGrid[$i] ; Local YN
		EndIf
		If $xStartGrid[$i] <> "yes" Then
			$tMainLVW[$i][2] = "--" ; Local YN
		Else
			$tMainLVW[$i][2] = $xStartGrid[$i] ; Local YN
		EndIf
;~ 		If $xStartGrid[$i] = "yes" Then ; Remote YN
;~ 			$tMainLVW[$i][3] = "--"
;~ 		Else
;~ 			$tMainLVW[$i][3] = "yes"
;~ 		EndIf
		$tMainLVW[$i][4] = $xServerNames[$i] ; "Server " & $xServergridx[$i] & $xServergridy[$i] ; Server Name
		$tMainLVW[$i][5] = $xServergridx[$i] & $xServergridy[$i] ; Grid
		If (UBound($aServerPlayers) = $aServerGridTotal) And ($aServerPlayers[$i] > -1) And $aServerOnlinePlayerYN = "yes" Then
			$tMainLVW[$i][6] = $aServerPlayers[$i] & " / " & $aServerMaxPlayers ; Online PLayers
		Else
			$tMainLVW[$i][6] = "-- / " & $aServerMaxPlayers ; Online PLayers
		EndIf

		If $xStartGrid[$i] = "yes" Then
			$tMainLVW[$i][7] = "--" ; CPU
			;			$tMainLVW[$i][8] = (Int($aServerMem[$i] / (1024 ^ 2))) & " MB" ; Memory
			Local $aMemTmp = ($aServerMem[$i] / (1024 ^ 2))
			$tMainLVW[$i][8] = _AddCommasDecimalNo($aMemTmp) ; & " MB" ; Memory
;~ 			$aMainLVW[$i][8] = _AddCommasDecimalNo($aServerMem[$i] / (1024 ^ 2)) & " MB" ; Memory
		Else
			$tMainLVW[$i][7] = "" ; CPU
			$tMainLVW[$i][8] = "" ; Memory
		EndIf
;~ 		$tMainLVW[$i][7] = "--" ; CPU
;~ 		Local $aMem=ProcessGetStats($aServerPID[$i],0)
;~ 		$tMainLVW[$i][8] = $aServerMem[$i] ; Memory
		$tMainLVW[$i][9] = $xServerAltSaveDir[$i] ; Folder
		$tMainLVW[$i][10] = $aServerPID[$i] ; PID

		If ProcessExists($aServerPID[$i]) Then
			$tMainLVW[$i][11] = "Running" ; Status #008000
			If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
				_GUIListViewEx_SetColour($aGUIListViewEX, $cSWRunning & ";", $i, 11)
			EndIf
		Else ; Server Not running
			If $xStartGrid[$i] = "yes" Then
				If $tMainLVW[$i][11] <> $aMainLVW[$i][11] Then
					$tMainLVW[$i][11] = "CRASHED" ; Status
					_GUIListViewEx_SetColour($aGUIListViewEX, $cSWCrashed & ";", $i, 11)
					LogWrite(" WARNING!!! Server [" & $xServergridx[$i] & $xServergridy[$i] & "] PID [" & $aMainLVW[$i][10] & "] """ & $xServerNames[$i] & """ CRASHED, Restarting server")
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
		For $x = 4 To 11
			If $tMainLVW[$i][$x] <> $aMainLVW[$i][$x] Then
				$aMainLVW[$i][$x] = $tMainLVW[$i][$x]
				_GUICtrlListView_SetItemText($MainListViewWindow, $i, $aMainLVW[$i][$x], $x)
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
				_GUICtrlListView_AddSubItem($MainListViewWindow, $i, "", 1, 0)
			Else
				_GUICtrlListView_AddSubItem($MainListViewWindow, $i, "", 1, 1)
			EndIf
;~ 		Next
		EndIf
		If $tMainLVW[$i][2] <> $aMainLVW[$i][2] Then
			$aMainLVW[$i][2] = $tMainLVW[$i][2]
;~ 		For $i = 0 To ($aServerGridTotal - 1) ; Place icon for RUN column
			If $xLocalGrid[$i] = "yes" Then
				_GUICtrlListView_AddSubItem($MainListViewWindow, $i, "", 2, 4)
			Else
				_GUICtrlListView_AddSubItem($MainListViewWindow, $i, "", 3, 5)
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
;~ 	GUICtrlSetData($TotalPlayersEdit, "275 / 220") ; Players Edit Window   KIM!!!!
	GUICtrlSetData($TotalPlayersEdit, $aTotalPlayersOnline & " / " & $aServerMaxPlayers) ; Players Edit Window

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
;~ 		_GUICtrlTab_SetBkColor($LogWindow, $lBasicTab, $cFWTabBackground)
;~     GUICtrlSetBkColor(-1, $cFWTabBackground)
		If $lDefaultTabNo = 1 Then GUICtrlSetState(-1, $GUI_SHOW)
		Global $lBasicEdit = _GUICtrlRichEdit_Create($LogWindow, "", 12, 73, ($lWidth - 25), ($lHeight - 90), $ES_READONLY + $WS_HSCROLL + $WS_VSCROLL + $ES_MULTILINE)
		_GUICtrlRichEdit_SetLimitOnText($lBasicEdit, 500000)
		_GUICtrlRichEdit_SetBkColor($lBasicEdit, $cFWBackground)
		_GUICtrlRichEdit_SetText($lBasicEdit, FileRead($aLogFile))
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
		_GUICtrlRichEdit_SetText($lDetailedEdit, FileRead($aLogDebugFile))
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
		_GUICtrlRichEdit_SetText($lOnlinePlayersEdit, FileRead($aOnlinePlayerFile))
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
		_GUICtrlRichEdit_SetText($lServerSummaryEdit, FileRead($aServerSummaryFile))
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
		_GUICtrlRichEdit_SetText($lConfigEdit, FileRead($aIniFile))
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
		_GUICtrlRichEdit_SetText($lGridSelectEdit, FileRead($aGridSelectFile))
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
		_GUICtrlRichEdit_SetText($lServerGridEdit, FileRead($aConfigFull))
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
		_GUICtrlRichEdit_SetText($lDefaultGameEdit, FileRead($aDefaultGame))
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
		_GUICtrlRichEdit_SetText($lDefaultGUSEdit, FileRead($aDefaultGUS))
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
		_GUICtrlRichEdit_SetText($lDefaultEngineEdit, FileRead($aDefaultEngine))
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

Func _GetMemArrayRawAvg($pid)
	Local $tMem[UBound($pid)], $wbemFlagReturnImmediately = 0x10, $wbemFlagForwardOnly = 0x20
	$objWMIService = ObjGet("winmgmts:\\localhost\root\CIMV2")
	If @error Then Return 0
	$colItems = $objWMIService.ExecQuery("SELECT * FROM Win32_PerfRawData_PerfProc_Process", "WQL", $wbemFlagReturnImmediately + $wbemFlagForwardOnly)
	If IsObj($colItems) Then
		For $objItem In $colItems
			For $x = 0 To (UBound($pid) - 1)
;~ 				If $pid[$x] = $objItem.IDProcess Then $tMem[$x] = (($objItem.WorkingSetPrivate + $objItem.WorkingSet) / 2) ; Average
				If $pid[$x] = $objItem.IDProcess Then $tMem[$x] = ($objItem.WorkingSetPrivate) ; Working Set Private
			Next
		Next
		Return $tMem
	EndIf
	Return 0
EndFunc   ;==>_GetMemArrayRawAvg

#Region ; **** CPU Usage Code Section **** by Ascend4nt.  Visit https://sites.google.com/site/ascend4ntscode/performancecounters-pdh
Global $_PDHPCA_bInit = False, $_PDHPCA_aCounters
Func _PDH_ProcessAllInit($sExtraCounters = "", $sModifiers = "", $sSep = ';')
	If $_PDHPCA_bInit Then Return True
	If $sExtraCounters <> "" Then
		$sExtraCounters = 784 & $sSep & $sExtraCounters
	Else
		$sExtraCounters = 784
	EndIf
	If $sModifiers <> "" Then
		$sModifiers = 0 & $sSep & $sModifiers
	Else
		$sModifiers = 0
	EndIf
	$_PDHPCA_aCounters = _PDH_ObjectBaseCreate(230, "", $sExtraCounters, $sModifiers, $sSep)
	If @error Then Return SetError(@error, @extended, False)
	$_PDHPCA_bInit = True
	Return True
EndFunc   ;==>_PDH_ProcessAllInit
Func _PDH_ProcessAllUnInit()
	If Not $_PDHPCA_bInit Then Return True
	If Not _PDH_ObjectBaseDestroy($_PDHPCA_aCounters) Then Return SetError(@error, @extended, False)
	$_PDHPCA_bInit = False
	Return True
EndFunc   ;==>_PDH_ProcessAllUnInit
Func _PDH_ProcessAllAddCounters($sExtraCounters, $sModifiers = "", $sSep = ';')
	If Not $_PDHPCA_bInit Then Return SetError(1, 0, False)
	If Not _PDH_ObjectBaseAddCounters($_PDHPCA_aCounters, $sExtraCounters, $sModifiers, $sSep) Then Return SetError(@error, @extended, False)
	Return True
EndFunc   ;==>_PDH_ProcessAllAddCounters
Func _PDH_ProcessAllRemoveCounters($sKillPCs, $sSep = ';')
	If Not $_PDHPCA_bInit Then Return SetError(1, 0, False)
	If Not _PDH_ObjectBaseRemoveCounters($_PDHPCA_aCounters, $sKillPCs, $sSep, 3) Then Return SetError(@error, @extended, False)
	Return True
EndFunc   ;==>_PDH_ProcessAllRemoveCounters
Func _PDH_ProcessAllCollectQueryData()
	If Not $_PDHPCA_bInit Then Return SetError(1, 0, False)
	If Not _PDH_ObjectBaseCollectQueryData($_PDHPCA_aCounters) Then Return SetError(@error, @extended, False)
	Return True
EndFunc   ;==>_PDH_ProcessAllCollectQueryData
Func _PDH_ProcessAllUpdateCounters()
	If Not $_PDHPCA_bInit Or Not IsArray($_PDHPCA_aCounters) Then Return SetError(1, 0, "")
	Local $aProcessList, $aRet, $iFailSafe, $stCounterBuffer, $pBuffer
	For $iFailSafe = 1 To 3
		$_PDHOC_iLookupFileTime = _WinTime_GetSystemTimeAsLocalFileTime()
		If Not _PDH_CollectQueryData($_PDHPCA_aCounters[1][0], True) Then Return SetError(@error, @extended, "")
		$aProcessList = ProcessList()
		If @error Then Return SetError(10, @error, "")
		$aRet = DllCall($_PDH_hDLLHandle, "long", "PdhGetFormattedCounterArrayW", "ptr", $_PDHPCA_aCounters[2][2], "dword", 0x8400, "dword*", 0, "dword*", 0, "ptr", 0)
		If @error Then Return SetError(2, @error, "")
		If $aRet[0] <> 0x800007D2 And Not ($aRet[0] = 0 And $aRet[3] And @OSVersion = "WIN_2000") Then
			$_PDH_iLastError = $aRet[0]
			_PDH_DebugWrite("PdhGetFormattedCounterArrayW 1st call unsuccessful, return:" & Hex($_PDH_iLastError) & ", sz:" & $aRet[3] & @CRLF)
			Return SetError(3, $_PDH_iLastError, "")
		EndIf
		If $aProcessList[0][0] = ($aRet[4] - 1) Then ExitLoop
	Next
	If $iFailSafe > 3 Then Return SetError(11, 0, "")
	ReDim $aProcessList[$aProcessList[0][0] + 2][$_PDHPCA_aCounters[1][3] + 1]
	$stCounterBuffer = DllStructCreate("ubyte[" & $aRet[3] & ']')
	$pBuffer = DllStructGetPtr($stCounterBuffer)
	If Not __PDH_ObjectBaseCounterGetValues($_PDHPCA_aCounters, 2, $aRet[3], $pBuffer, $aProcessList, $aRet[4], 0) Then Return SetError(@error, @extended, "")
	$aProcessList[1][0] = "Idle"
	$aProcessList[$aRet[4]][0] = "Total"
	For $i = 3 To $_PDHPCA_aCounters[1][3] + 1
		__PDH_ObjectBaseCounterGetValues($_PDHPCA_aCounters, $i, $aRet[3], $pBuffer, $aProcessList, $aRet[4], $i - 1)
		If @error Then $aProcessList[0][$i - 1] = -1
	Next
	Return $aProcessList
EndFunc   ;==>_PDH_ProcessAllUpdateCounters
Global $_PDHOC_iLookupFileTime
Global Const $PDH_TIME_CONVERSION = 0x80000000
Func _PDH_ObjectBaseCreate($vCounter, $sPCName = "", $sAddCounters = "", $sModifiers = "", $sSep = ';', $sWildcardReplace = "")
	If Not $_PDH_bInit Then Return SetError(16, 0, "")
	Dim $aObjArr[2][4]
	If StringIsDigit($vCounter) Then
		$aObjArr[0][0] = Number($vCounter)
		$vCounter = _PDH_GetCounterNameByIndex($vCounter, $sPCName)
	Else
		$aObjArr[0][0] = _PDH_GetCounterIndex($vCounter, $sPCName)
	EndIf
	If $vCounter = "" Then Return SetError(1, 0, "")
	$aObjArr[0][1] = $sWildcardReplace
	$aObjArr[1][1] = $sPCName & '\' & $vCounter & "(*)\"
	$aObjArr[1][2] = $sPCName
	$aObjArr[1][3] = 0
	$aObjArr[1][0] = _PDH_GetNewQueryHandle()
	If @error Then Return SetError(@error, @extended, "")
	If $sAddCounters = "" Or _PDH_ObjectBaseAddCounters($aObjArr, $sAddCounters, $sModifiers, $sSep) Then Return $aObjArr
	Local $iErr = @error, $iExt = @extended
	_PDH_FreeQueryHandle($aObjArr[1][0])
	Return SetError($iErr, $iExt, "")
EndFunc   ;==>_PDH_ObjectBaseCreate
Func _PDH_ObjectBaseDestroy(ByRef $aObjArr)
	If Not IsArray($aObjArr) Then Return SetError(1, 0, False)
	If IsPtr($aObjArr[1][0]) Then _PDH_FreeQueryHandle($aObjArr[1][0])
	$aObjArr = ""
	Return True
EndFunc   ;==>_PDH_ObjectBaseDestroy
Func _PDH_ObjectBaseAddCounters(ByRef $aObjArr, $sExtraCounters, $sModifiers = "", $sSep = ';')
	If Not IsArray($aObjArr) Or $sExtraCounters = "" Then Return SetError(1, 0, False)
	Local $i, $iVal = 0, $iNewIndex, $aNewOCs, $iAdded = 0, $iExtraOCs = 0, $iModifiers = 1, $sInstanceName, $sPath
	$aNewOCs = StringSplit($sExtraCounters, $sSep, 1)
	$iExtraOCs = $aNewOCs[0]
	If $sModifiers <> "" Then
		$aModifiers = StringSplit($sModifiers, $sSep, 1)
		$iModifiers = $aModifiers[0]
		$iVal = $aModifiers[1]
		If $iModifiers > 1 And $iModifiers <> $iExtraOCs Then
			ReDim $aModifiers[$iExtraOCs + 1]
		EndIf
	EndIf
	ReDim $aObjArr[$aObjArr[1][3] + 2 + $iExtraOCs][4]
	$iNewIndex = 1
	For $i = $aObjArr[1][3] + 2 To $aObjArr[1][3] + $iExtraOCs + 1
		If StringIsDigit($aNewOCs[$iNewIndex]) Then
			$aObjArr[$i][0] = Number($aNewOCs[$iNewIndex])
			$aObjArr[$i][1] = _PDH_GetCounterNameByIndex($aNewOCs[$iNewIndex], $aObjArr[1][2])
		Else
			$aObjArr[$i][0] = _PDH_GetCounterIndex($aNewOCs[$iNewIndex], $aObjArr[1][2])
			$aObjArr[$i][1] = $aNewOCs[$iNewIndex]
		EndIf
		$sPath = $aObjArr[1][1] & $aObjArr[$i][1]
		If $aObjArr[0][1] <> "" Then $sPath = StringReplace($sPath, '*', $aObjArr[0][1])
		$aObjArr[$i][2] = _PDH_AddCounter($aObjArr[1][0], $sPath)
		If @error Then
			Local $iErr = @error, $iExt = @extended
			For $i = 0 To $iAdded - 1
				_PDH_RemoveCounter($aObjArr[$i + $aObjArr[1][3] + 2][2])
			Next
			ReDim $aObjArr[$aObjArr[1][3] + 2][4]
			Return SetError($iErr, $iExt, False)
		EndIf
		If $iModifiers > 1 Then
			$aObjArr[$i][3] = $aModifiers[$iNewIndex]
		Else
			$aObjArr[$i][3] = $iVal
		EndIf
		$iAdded += 1
		$iNewIndex += 1
	Next
	$aObjArr[1][3] += $iExtraOCs
	Return True
EndFunc   ;==>_PDH_ObjectBaseAddCounters
Func _PDH_ObjectBaseRemoveCounters(ByRef $aObjArr, $sKillOCs, $sSep = ';', $iStart = 2)
	If Not IsArray($aObjArr) Or $sKillOCs = "" Or $iStart < 2 Or $iStart > $aObjArr[1][3] + 1 Then Return SetError(1, 0, False)
	Local $i, $i2, $bKill = False, $aKillOCs, $iMoveTo, $aNewArr, $iKillTotal = 0
	$aKillOCs = StringSplit($sKillOCs, $sSep, 1)
	$aNewArr = $aObjArr
	$iMoveTo = $iStart
	For $i = $iStart To $aObjArr[1][3] + 1
		For $i2 = 1 To $aKillOCs[0]
			If StringIsDigit($aKillOCs[$i2]) Then
				If $aObjArr[$i][0] <> $aKillOCs[$i2] Then ContinueLoop
			Else
				If $aObjArr[$i][1] <> $aKillOCs[$i2] Then ContinueLoop
			EndIf
			$bKill = True
			ExitLoop
		Next
		If $bKill Then
			_PDH_DebugWrite("Removing Counter #" & $aObjArr[$i][0] & ", Counter name: '" & $aObjArr[$i][1] & "' Handle:" & $aObjArr[$i][2])
			_PDH_RemoveCounter($aObjArr[$i][2])
			$iKillTotal += 1
			$bKill = False
		Else
			$aNewArr[$iMoveTo][0] = $aObjArr[$i][0]
			$aNewArr[$iMoveTo][1] = $aObjArr[$i][1]
			$aNewArr[$iMoveTo][2] = $aObjArr[$i][2]
			$aNewArr[$iMoveTo][3] = $aObjArr[$i][3]
			$iMoveTo += 1
		EndIf
	Next
	If $iKillTotal = 0 Then Return True
	_PDH_DebugWrite("Total killed:" & $iKillTotal & " (out of " & $aKillOCs[0] & "), $iMoveTo=" & $iMoveTo & " Current array size:" & $aObjArr[1][3] + 2 & ", new array size:" & $iMoveTo)
	ReDim $aNewArr[$iMoveTo][4]
	$aNewArr[1][3] -= $iKillTotal
	$aObjArr = $aNewArr
	Return SetExtended($iKillTotal, True)
EndFunc   ;==>_PDH_ObjectBaseRemoveCounters
Func _PDH_ObjectBaseCollectQueryData(ByRef $aObjArr)
	If Not IsArray($aObjArr) Or $aObjArr[1][3] = 0 Then Return SetError(1, 0, "")
	If Not _PDH_CollectQueryData($aObjArr[1][0]) Then Return SetError(@error, @extended, False)
	Return True
EndFunc   ;==>_PDH_ObjectBaseCollectQueryData
Func _PDH_ObjectBaseUpdateCounters(ByRef $aObjArr, $iIndex = -1)
	If Not IsArray($aObjArr) Or $aObjArr[1][3] = 0 Or $iIndex + 1 >= $aObjArr[1][3] Then Return SetError(1, 0, "")
	$_PDHOC_iLookupFileTime = _WinTime_GetSystemTimeAsLocalFileTime()
	If Not _PDH_CollectQueryData($aObjArr[1][0]) Then Return SetError(@error, @extended, "")
	If $aObjArr[0][1] <> "" Then
		Local $iVal
		Dim $aValues[$aObjArr[1][3] - 1]
		If $iIndex < 0 Then
			For $i = 0 To $aObjArr[1][3] - 1
				$aValues[$i] = _PDH_UpdateCounter($aObjArr[1][0], $aObjArr[$i + 2][2], "", True)
			Next
			Return $aValues
		Else
			$iVal = _PDH_UpdateCounter($aObjArr[1][0], $aObjArr[$iIndex + 2][2], "", True)
			If @error Then Return SetError(@error, @extended, "")
			Return $iVal
		EndIf
	EndIf
	Local $aRet, $stCounterBuffer, $pBuffer
	$aRet = DllCall($_PDH_hDLLHandle, "long", "PdhGetFormattedCounterArrayW", "ptr", $aObjArr[2][2], "dword", 0x8400, "dword*", 0, "dword*", 0, "ptr", 0)
	If @error Then Return SetError(2, @error, "")
	If $aRet[0] <> 0x800007D2 And Not ($aRet[0] = 0 And $aRet[3] And @OSVersion = "WIN_2000") Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWrite("PdhGetFormattedCounterArrayW 1st call unsuccessful, return:" & Hex($_PDH_iLastError) & ", sz:" & $aRet[3] & @CRLF)
		Return SetError(3, $_PDH_iLastError, "")
	EndIf
	Dim $aCounterArr[$aRet[4] + 1][$aObjArr[1][3] + 1]
	$aCounterArr[0][0] = $aRet[4]
	$stCounterBuffer = DllStructCreate("ubyte[" & $aRet[3] & ']')
	$pBuffer = DllStructGetPtr($stCounterBuffer)
	For $i = 2 To $aObjArr[1][3] + 1
		__PDH_ObjectBaseCounterGetValues($aObjArr, $i, $aRet[3], $pBuffer, $aCounterArr, $aRet[4], $i - 1)
		If @error Then $aCounterArr[0][$i - 1] = -1
	Next
	Return $aCounterArr
EndFunc   ;==>_PDH_ObjectBaseUpdateCounters
Func __PDH_ObjectBaseCounterGetValues(ByRef $aObjArr, $iRow, $iBufSize, $pOCBuffer, ByRef $aCounterArr, $iNumCounters, $iColIndex)
	Local $aRet = DllCall($_PDH_hDLLHandle, "long", "PdhGetFormattedCounterArrayW", "ptr", $aObjArr[$iRow][2], "dword", 0x8400, "dword*", $iBufSize, "dword*", 0, "ptr", $pOCBuffer)
	If @error Then Return SetError(2, @error, False)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWrite("PdhGetFormattedCounterArrayW 2nd call unsuccessful, return:" & Hex($_PDH_iLastError) & ", sz:" & $aRet[3] & ", #counters:" & $aRet[4])
		Return SetError(4, $_PDH_iLastError, False)
	EndIf
	If $aRet[3] <> $iBufSize Then Return SetError(5, 0, False)
	If $aRet[4] <> $iNumCounters Then Return SetError(6, 0, False)
	Local $stCountValueItem, $iCountValueSz = DllStructGetSize(DllStructCreate("ptr;long;dword;int64"))
	Local $iUTC2LocalDelta, $iVal, $iDivisor, $bTimeConv = False
	Local $pPointer = $pOCBuffer
	$iDivisor = $aObjArr[$iRow][3]
	If BitAND($iDivisor, 0x80000000) Then $bTimeConv = True
	$iDivisor = BitAND($iDivisor, 0x7FFFFFFF)
	If $bTimeConv Then $iUTC2LocalDelta = _WinTime_GetUTCToLocalFileTimeDelta()
	For $i = 1 To $aRet[4]
		$stCountValueItem = DllStructCreate("ptr;long;dword;int64", $pPointer)
		$pPointer += $iCountValueSz
		$iVal = DllStructGetData($stCountValueItem, 4)
		If $bTimeConv Then
			$iVal = $_PDHOC_iLookupFileTime - ($iVal * 10000000) + $iUTC2LocalDelta
		ElseIf $iDivisor Then
			$iVal = Round($iVal / $iDivisor)
		EndIf
		If $iColIndex Then
			If $iColIndex = 1 Then $aCounterArr[$i][0] = __PDH_StringGetNullTermMemStr(DllStructGetData($stCountValueItem, 1))
			$aCounterArr[$i][$iColIndex] = $iVal
			ContinueLoop
		ElseIf $aObjArr[0][0] = 230 Then
			If $iVal And $aCounterArr[$i][1] <> $iVal Then
				$aCounterArr[$i][0] = "?"
				_PDH_DebugWrite("Process ID mismatch found at index " & $i & ", Counter PID:" & $iVal & ", ProcessList ID:" & $aCounterArr[$i][1] & ", name:" & $aCounterArr[$i][0])
			EndIf
		EndIf
	Next
	Return True
EndFunc   ;==>__PDH_ObjectBaseCounterGetValues
Global $_PDH_hDLLHandle = -1, $_PDH_bInit = False, $_PDH_iLastError = 0
Global $_PDH_aInvalidHandles[1] = [0]
Global $_PDH_REG_MODIFIED, $_PDH_RESTORE_REG
Global $_PDH_iCPUCount
Global $PDH_DEBUGLOG = 1
Func _PDH_RegistryCheck($sPCName = '')
	If __PDH_RegistryToggle(-1, $sPCName) Then Return True
	Return SetError(@error, @extended, False)
EndFunc   ;==>_PDH_RegistryCheck
Func _PDH_RegistryEnable($sPCName = '')
	Local $vRet = __PDH_RegistryToggle(1, $sPCName)
	Return SetError(@error, @extended, $vRet)
EndFunc   ;==>_PDH_RegistryEnable
Func _PDH_RegistryDisable($sPCName = '')
	Local $vRet = __PDH_RegistryToggle(0, $sPCName)
	Return SetError(@error, @extended, $vRet)
EndFunc   ;==>_PDH_RegistryDisable
Func _PDH_Init($bForceCountersOn = False, $bRestoreRegStateOnExit = False)
	If $_PDH_bInit Then Return True
	$_PDH_REG_MODIFIED = 0
	$_PDH_RESTORE_REG = 0
	If Not __PDH_RegistryToggle(-1) Then
		If Not $bForceCountersOn Or Not IsAdmin() Then Return SetError(16, 0, False)
		If Not __PDH_RegistryToggle(1) Then Return SetError(@error, @extended, False)
		$_PDH_REG_MODIFIED = 1
		If $bRestoreRegStateOnExit Then $_PDH_RESTORE_REG = 1
	EndIf
	$_PDH_hDLLHandle = DllOpen("pdh.dll")
	If $_PDH_hDLLHandle = -1 Then
		If $_PDH_RESTORE_REG Then
			If Not __PDH_RegistryToggle(0) Then Return SetError(@error, @extended, False)
		EndIf
		Return SetError(32, 0, False)
	EndIf
	Local $aRet = DllCall("kernel32.dll", "dword", "GetActiveProcessorCount", "word", 0xFFFF)
	If Not @error Then
		$_PDH_iCPUCount = $aRet[0]
	Else
		$_PDH_iCPUCount = _WinAPI_GetSystemInfo(6)
		If @error Then
			$_PDH_iCPUCount = EnvGet("NUMBER_OF_PROCESSORS")
			If $_PDH_iCPUCount = "" Then
				$_PDH_iCPUCount = 1
			Else
				$_PDH_iCPUCount = Int($_PDH_iCPUCount)
			EndIf
		EndIf
	EndIf
	_PDH_DebugWrite("CPU count result:" & $_PDH_iCPUCount)
	$_PDH_bInit = True
	OnAutoItExitRegister("_PDH_UnInit")
	Return True
EndFunc   ;==>_PDH_Init
Func _PDH_UnInit($hPDHQueryHandle = -1)
	If Not $_PDH_bInit Then Return True
	If @NumParams Then _PDH_FreeQueryHandle($hPDHQueryHandle)
	DllClose($_PDH_hDLLHandle)
	If $_PDH_RESTORE_REG Then __PDH_RegistryToggle(0)
	$_PDH_hDLLHandle = -1
	$_PDH_bInit = False
	OnAutoItExitUnRegister("_PDH_UnInit")
	Return
EndFunc   ;==>_PDH_UnInit
Func _PDH_ReloadDLL($hPDHQueryHandle = -1)
	If Not $_PDH_bInit Then
		If Not _PDH_Init() Then Return SetError(@error, @extended, False)
	Else
		_PDH_FreeQueryHandle($hPDHQueryHandle)
	EndIf
	DllClose($_PDH_hDLLHandle)
	__PDH_ForceFreeDLL('pdh.dll', 999)
	$_PDH_hDLLHandle = DllOpen("pdh.dll")
	If $_PDH_hDLLHandle = -1 Then
		_PDH_UnInit($hPDHQueryHandle)
		Return SetError(32, 0, False)
	EndIf
	Return True
EndFunc   ;==>_PDH_ReloadDLL
Func _PDH_ValidatePath($sCounterPath)
	Local $aRet, $tErr, $hPDHDLL
	If Not IsString($sCounterPath) Then Return SetError(1, 0, False)
	If Not $_PDH_bInit Then
		$hPDHDLL = "pdh.dll"
	Else
		$hPDHDLL = $_PDH_hDLLHandle
	EndIf
	If StringLeft($sCounterPath, 1) = ':' Then
		$sCounterPath = __PDH_LocalizeCounter($sCounterPath)
		If @error Then Return SetError(@error, 0, "")
		_PDH_DebugWrite("Localized counter (from non-localized string):" & $sCounterPath)
	EndIf
	$aRet = DllCall($_PDH_hDLLHandle, "long", "PdhValidatePathW", "wstr", $sCounterPath)
	If @error Then
		$tErr = @error
		_PDH_DebugWriteErr("Path '" & $sCounterPath & "' caused a DLL-Call error")
		Return SetError(2, $tErr, False)
	EndIf
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("Path '" & $sCounterPath & "', per PdhValidatePathW, is invalid (or has too many wildcards)! [Return code: " & Hex($_PDH_iLastError) & ']')
		Return SetExtended($_PDH_iLastError, False)
	EndIf
	Return True
EndFunc   ;==>_PDH_ValidatePath
Func _PDH_ConnectMachine($sPCName)
	If Not $_PDH_bInit Then Return SetError(16, 0, False)
	If Not IsString($sPCName) Or $sPCName = "" Then Return SetError(1, 0, False)
	Local $aRet = DllCall($_PDH_hDLLHandle, "long", "PdhConnectMachineW", "wstr", $sPCName)
	If @error Then Return SetError(2, @error, False)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("Machine '" & $sPCName & "' was not able to be connected to. [Return code: " & Hex($_PDH_iLastError) & ']')
		Return SetError(3, $_PDH_iLastError, False)
	EndIf
	Return True
EndFunc   ;==>_PDH_ConnectMachine
Func _PDH_BrowseCounters($sTitle = "", $hWnd = 0, $iDetailLvl = 4, $bAllowRemotePCs = True, $bAllowMultipleSel = False, $bAllowCostlyObjects = False)
	Local $hPDHDLL, $aRet, $iBCFlags, $hPDHBCCallback, $sReturnStr = "", $aReturnArr[2]
	Local $stCounterSelectBuffer, $stBrowseDlgConfig, $stTitle
	If Not $_PDH_bInit Then
		$hPDHDLL = "pdh.dll"
	Else
		$hPDHDLL = $_PDH_hDLLHandle
	EndIf
	$iBCFlags = 1 + 4 + 16
	If Not $bAllowRemotePCs Then $iBCFlags += 8
	If $bAllowCostlyObjects Then $iBCFlags += 256
	$stCounterSelectBuffer = DllStructCreate("byte[131072]")
	$stBrowseDlgConfig = DllStructCreate("dword;hwnd;ptr;ptr;dword;ptr;dword_ptr;long;dword;ptr")
	DllStructSetData($stBrowseDlgConfig, 1, $iBCFlags)
	DllStructSetData($stBrowseDlgConfig, 2, $hWnd)
	DllStructSetData($stBrowseDlgConfig, 4, DllStructGetPtr($stCounterSelectBuffer))
	DllStructSetData($stBrowseDlgConfig, 5, 2048)
	Switch $iDetailLvl
		Case 1
			$iDetailLvl = 0x64
		Case 2
			$iDetailLvl = 0xC8
		Case 3
			$iDetailLvl = 0x012C
		Case Else
			$iDetailLvl = 0x0190
	EndSwitch
	DllStructSetData($stBrowseDlgConfig, 9, $iDetailLvl)
	If $sTitle = '' Then $sTitle = "Browse Performance Counters"
	$stTitle = DllStructCreate("wchar[" & (StringLen($sTitle) + 1) & ']')
	DllStructSetData($stTitle, 1, $sTitle)
	DllStructSetData($stBrowseDlgConfig, 10, DllStructGetPtr($stTitle))
	$aRet = DllCall($hPDHDLL, "long", "PdhBrowseCountersW", "ptr", DllStructGetPtr($stBrowseDlgConfig))
	If @error Then Return SetError(2, @error, '')
	If $aRet[0] Then
		If $aRet[0] = 0x800007D9 Then
			_PDH_DebugWriteErr("_PDH_Browse_Counters Dialog Cancelled, returning empty string")
			Return ''
		EndIf
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhBrowseCountersW non-zero error code:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, '')
	EndIf
	$sReturnStr = StringReplace(StringReplace(BinaryToString(DllStructGetData($stCounterSelectBuffer, 1), 2), ChrW(0) & ChrW(0), ''), ChrW(0), @LF)
	If StringRight($sReturnStr, 1) = @LF Then $sReturnStr = StringTrimRight($sReturnStr, 1)
	_PDH_DebugWrite("Selected Counter(s) from _PDH_Browse_Counters:" & @CRLF & $sReturnStr)
	If $sReturnStr = '' Then Return SetError(-1, 0, '')
	$aReturnArr = StringSplit($sReturnStr, @LF, 1)
	If $bAllowMultipleSel Then Return $aReturnArr
	Return $aReturnArr[1]
EndFunc   ;==>_PDH_BrowseCounters
Func _PDH_GetCounterList($sCounterWildcardPath, $bReturnAsString = False)
	Local $aRet, $stExpandedPathList
	Local $hPDHDLL, $iBufSize, $sCounterList, $aCounterList[1] = [0]
	If Not IsString($sCounterWildcardPath) Then Return SetError(1, 0, $aCounterList)
	If Not $_PDH_bInit Then
		$hPDHDLL = "pdh.dll"
	Else
		$hPDHDLL = $_PDH_hDLLHandle
	EndIf
	_PDH_DebugWrite("_PDH_GetCounterList() call, $sCounterWildcardPath='" & $sCounterWildcardPath & "', PDH DLL 'handle' (or just 'pdh.dll'):" & $hPDHDLL)
	If StringLeft($sCounterWildcardPath, 1) = ':' Then
		$sCounterWildcardPath = __PDH_LocalizeCounter($sCounterWildcardPath)
		If @error Then Return SetError(@error, 0, "")
		_PDH_DebugWrite("Localized *wildcard* counter (from non-localized string):" & $sCounterWildcardPath)
	EndIf
	$aRet = DllCall($hPDHDLL, "long", "PdhExpandWildCardPathW", "ptr", ChrW(0), "wstr", $sCounterWildcardPath, "ptr", ChrW(0), "dword*", $iBufSize, "dword", 0)
	If @error Then Return SetError(2, @error, $aCounterList)
	If $aRet[0] <> 0x800007D2 Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhExpandWildCardPathW 1st call unsuccessful, return:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, $aCounterList)
	EndIf
	$iBufSize = $aRet[4]
	If @OSVersion = "WIN_2000" Or StringLeft(@OSVersion, 6) = "WIN_XP" Then $iBufSize += 1
	$stExpandedPathList = DllStructCreate("byte[" & ($iBufSize * 2) & ']')
	$aRet = DllCall($hPDHDLL, "long", "PdhExpandWildCardPathW", "ptr", ChrW(0), "wstr", $sCounterWildcardPath, "ptr", DllStructGetPtr($stExpandedPathList), "dword*", $iBufSize, "dword", 0)
	If @error Then Return SetError(2, @error, $aCounterList)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhExpandWildCardPathW 2nd call unsuccessful, return:" & Hex($_PDH_iLastError))
		If $aRet[0] = 0x800007D2 Then
			_PDH_DebugWriteErr("PdhExpandWildCardPathW 2nd call returned 'PDH_MORE_DATA'. 1st reported Bufsize:" & $iBufSize & ", 2nd call's Bufsize:" & $aRet[4])
		EndIf
		Return SetError(4, $_PDH_iLastError, $aCounterList)
	EndIf
	$sCounterList = BinaryToString(DllStructGetData($stExpandedPathList, 1), 2)
	If StringRegExp($sCounterList, "\*(\)|\\|/|$)") Then
		_PDH_DebugWriteErr("There are still * wildcards left after a call to PdhExpandWildCardPathW!" & @CRLF & "Original wildcard path:" & $sCounterWildcardPath)
		Return SetError(1, 0, $aCounterList)
	EndIf
	Local $iStrip = 0
	If StringRight($sCounterList, 1) = ChrW(0) Then $iStrip = 1
	If StringMid($sCounterList, $iBufSize - 1, 1) = ChrW(0) Then $iStrip += 1
	If $bReturnAsString Then
		Return StringTrimRight($sCounterList, $iStrip)
	Else
		$aCounterList = StringSplit(StringTrimRight($sCounterList, $iStrip), ChrW(0), 1)
		If Not @error Then
			_PDH_DebugWrite("_PDH_GetCounterList() call success, returning a " & $aCounterList[0] & "-element array")
			Return $aCounterList
		Else
			Dim $aCounterList[1]
			$aCounterList[0] = 0
			_PDH_DebugWriteErr("PdhExpandWildCardPathW data invalid")
			Return SetError(5, 0, $aCounterList)
		EndIf
	EndIf
EndFunc   ;==>_PDH_GetCounterList
Func _PDH_GetNewQueryHandle($iUserInfo = 0)
	If Not $_PDH_bInit Then
		If Not _PDH_Init() Then Return SetError(@error, 0, 0)
	EndIf
	Local $aRet = DllCall($_PDH_hDLLHandle, "long", "PdhOpenQueryW", "ptr", 0, "dword_ptr", $iUserInfo, "ptr*", Ptr(0))
	If @error Then Return SetError(2, @error, 0)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("_PDH_GetNewQueryHandle call returned with PDH error:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, 0)
	EndIf
	_PDH_DebugWrite("_PDH_GetNewQueryHandle Call succeeded, return:" & $aRet[0] & ",param1:" & $aRet[1] & ",param2:" & $aRet[2] & ",handle:" & $aRet[3])
	Return $aRet[3]
EndFunc   ;==>_PDH_GetNewQueryHandle
Func _PDH_FreeQueryHandle(ByRef $hPDHQueryHandle)
	If Not IsPtr($hPDHQueryHandle) Then Return SetError(1, 0, False)
	If Not $_PDH_bInit Then Return SetError(16, 0, False)
	Local $aRet = DllCall($_PDH_hDLLHandle, "long", "PdhCloseQuery", "ptr", $hPDHQueryHandle)
	If @error Then Return SetError(2, @error, False)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhCloseQuery DLL call unsuccessful for handle: " & Hex($hPDHQueryHandle) & ", return:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, False)
	EndIf
	$hPDHQueryHandle = 0
	Return True
EndFunc   ;==>_PDH_FreeQueryHandle
Func _PDH_AddCounter($hPDHQueryHandle, $sCounterPath, $iUserInfo = 0)
	If Not $_PDH_bInit Then Return SetError(16, 0, 0)
	If Not IsPtr($hPDHQueryHandle) Then Return SetError(1, 0, 0)
	If StringLeft($sCounterPath, 1) = ':' Then
		$sCounterPath = __PDH_LocalizeCounter($sCounterPath)
		If @error Then Return SetError(@error, 0, "")
		_PDH_DebugWrite("Localized counter (from non-localized string):" & $sCounterPath)
	EndIf
	Local $aRet = DllCall($_PDH_hDLLHandle, "long", "PdhAddCounterW", "ptr", $hPDHQueryHandle, "wstr", $sCounterPath, "dword_ptr", $iUserInfo, "ptr*", Ptr(0))
	If @error Then Return SetError(2, @error, 0)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhAddCounterW error [path:'" & $sCounterPath & "'], return:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, 0)
	EndIf
	_PDH_DebugWrite("PdhAddCounterW success for path '" & $sCounterPath & "', handle:" & $aRet[4])
	Return $aRet[4]
EndFunc   ;==>_PDH_AddCounter
Func _PDH_AddCountersByArray($hPDHQueryHandle, Const ByRef $aCounterArray, $iStart = 0, $iEnd = -1, $iBottomRows = 0, $iColumns = 0)
	Local $iFailures = 0, $iReturnIndex, $aCountersReturn[1][2] = [[0, 0]]
	If Not $_PDH_bInit Then Return SetError(16, 0, $aCountersReturn)
	If Not IsArray($aCounterArray) Or UBound($aCounterArray, 0) > 1 Or $iBottomRows < 0 Or $iColumns < 0 Then Return SetError(1, 0, $aCountersReturn)
	If Not IsPtr($hPDHQueryHandle) Then Return SetError(1, 0, $aCountersReturn)
	If $iEnd = -1 Then $iEnd = UBound($aCounterArray) - 1
	If $iStart < 0 Or $iStart > $iEnd Or $iEnd > UBound($aCounterArray) - 1 Then Return SetError(1, 0, $aCountersReturn)
	Dim $aCountersReturn[$iEnd - $iStart + 1 + $iBottomRows][2 + $iColumns]
	If $iBottomRows Then $aCountersReturn[0][0] = $iEnd - $iStart + 1
	$iReturnIndex = $iBottomRows
	For $i = $iStart To $iEnd
		$aCountersReturn[$iReturnIndex][0] = $aCounterArray[$i]
		$aCountersReturn[$iReturnIndex][1] = _PDH_AddCounter($hPDHQueryHandle, $aCounterArray[$i])
		If @error Then $iFailures += 1
		$iReturnIndex += 1
	Next
	If $iFailures = ($iEnd - $iStart + 1) Then
		Dim $aCountersReturn[1][2]
		$aCountersReturn[0][0] = 0
		Return SetError(8, $iFailures, $aCountersReturn)
	EndIf
	Return SetExtended($iFailures, $aCountersReturn)
EndFunc   ;==>_PDH_AddCountersByArray
Func _PDH_AddCountersByMultiStr($hPDHQueryHandle, Const ByRef $sMultiStr, $sSepChar, $iBottomRows = 0, $iColumns = 0)
	Local $aCounterList[1][2] = [[0, 0]]
	If Not IsString($sMultiStr) Then Return SetError(1, 0, $aCounterList)
	$aCounterList = StringSplit($sMultiStr, $sSepChar, 1)
	If Not @error Then
		_PDH_DebugWrite("_PDH_AddCountersByMultiStr() StringSplit() success, returning a " & $aCounterList[0] & "-element array")
		Return _PDH_AddCountersByArray($hPDHQueryHandle, $aCounterList, 1, -1, $iBottomRows, $iColumns)
	Else
		Dim $aCounterList[1][2]
		$aCounterList[0][0] = 0
		_PDH_DebugWriteErr("_PDH_AddCountersByMultiStr() StringSplit() resulted in no data (invalid param)")
		Return SetError(1, 0, $aCounterList)
	EndIf
EndFunc   ;==>_PDH_AddCountersByMultiStr
Func _PDH_AddCountersByWildcardPath($hPDHQueryHandle, $sCounterWildcardPath, $iBottomRows = 0, $iColumns = 0)
	If Not $_PDH_bInit Then Return SetError(16, 0, False)
	If Not IsPtr($hPDHQueryHandle) Then Return SetError(1, 0, False)
	Local $aCountersReturn[1][2] = [[0, 0]]
	_PDH_DebugWrite("_PDH_AddCountersByWildcardPath called")
	Local $aCounterList = _PDH_GetCounterList($sCounterWildcardPath)
	If @error Or $aCounterList[0] = 0 Then
		Local $iErr = @error, $iExt = @extended
		_PDH_DebugWriteErr("_PDH_AddCountersByWildcardPath call to PDH_GetCounterList failed")
		Return SetError($iErr, $iExt, $aCountersReturn)
	EndIf
	_PDH_DebugWrite("_PDH_AddCountersByWildcardPath call to PDH_GetCounterList succeeded, now returning _PDH_AddCountersByArray")
	$aCountersReturn = _PDH_AddCountersByArray($hPDHQueryHandle, $aCounterList, 1, -1, $iBottomRows, $iColumns)
	Return SetError(@error, @extended, $aCountersReturn)
EndFunc   ;==>_PDH_AddCountersByWildcardPath
Func _PDH_RemoveCounter(ByRef $hPDHCounterHandle)
	If Not $_PDH_bInit Then Return SetError(16, 0, False)
	If Not IsPtr($hPDHCounterHandle) Then Return SetError(1, 0, False)
	_PDH_DebugWrite("_PDH_RemoveCounter called w/ Counter Handle (" & $hPDHCounterHandle & ')')
	Local $aRet = DllCall($_PDH_hDLLHandle, "long", "PdhRemoveCounter", "ptr", $hPDHCounterHandle)
	If @error Then Return SetError(2, @error, False)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhRemoveCounter error, return:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, False)
	EndIf
	$hPDHCounterHandle = 0
	Return True
EndFunc   ;==>_PDH_RemoveCounter
Func _PDH_CounterNameToNonLocalStr($sCounterPath, $bKeepPCName = False)
	Local $aCounterElements, $sNeutralStr
	$aCounterElements = StringRegExp($sCounterPath, "(\\\\[^\\]+)?\\([^\\\(]+)?(\([^\)]+\))?\\(.*)", 1)
	If @error Then Return SetError(1, 0, "")
	$aCounterElements[1] = _PDH_GetCounterIndex($aCounterElements[1], $aCounterElements[0])
	If @error Then Return SetError(@error, @extended, "")
	$aCounterElements[3] = _PDH_GetCounterIndex($aCounterElements[3], $aCounterElements[0])
	If @error Then Return SetError(@error, @extended, "")
	$sNeutralStr = ':' & $aCounterElements[1] & '\' & $aCounterElements[3] & '\' & $aCounterElements[2]
	If $bKeepPCName And $aCounterElements[0] <> "" Then $sNeutralStr &= StringTrimLeft($aCounterElements[0], 1)
	Return $sNeutralStr
EndFunc   ;==>_PDH_CounterNameToNonLocalStr
Func _PDH_GetCounterNameByIndex($iIndex, $sPCName = "")
	Local $hPDHDLL, $aRet, $sMachineParamType, $vMachineParam
	If Not $_PDH_bInit Then
		$hPDHDLL = "pdh.dll"
	Else
		$hPDHDLL = $_PDH_hDLLHandle
	EndIf
	_PDH_DebugWrite("_PDH_GetCounterNameByIndex() call, Index:" & $iIndex & " [optional] Machine Name:" & $sPCName & ", PDH DLL 'handle' (or just 'pdh.dll'):" & $hPDHDLL)
	$vMachineParam = StringRegExpReplace($sPCName, "(\\\\[^\\]+)?(\\?.*)", "$1")
	If $vMachineParam = "" Then
		$vMachineParam = 0
		$sMachineParamType = "ptr"
	Else
		_PDH_DebugWrite("_PDH_GetCounterNameByIndex Machine name: " & $vMachineParam)
		$sMachineParamType = "wstr"
	EndIf
	$aRet = DllCall($hPDHDLL, "long", "PdhLookupPerfNameByIndexW", $sMachineParamType, $vMachineParam, "dword", $iIndex, "wstr", "", "dword*", 65536)
	If @error Then Return SetError(2, @error, "")
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("_PDH_GetCounterNameByIndex non-zero error code:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, "")
	EndIf
	Return $aRet[3]
EndFunc   ;==>_PDH_GetCounterNameByIndex
Func _PDH_GetCounterIndex($sCounterOrObject, $sPCName = "")
	Local $hPDHDLL, $aRet, $sMachineParamType
	If Not $_PDH_bInit Then
		$hPDHDLL = "pdh.dll"
	Else
		$hPDHDLL = $_PDH_hDLLHandle
	EndIf
	_PDH_DebugWrite("_PDHGetCounterIndex() call, Counter or Object Name:'" & $sCounterOrObject & "', Machine Name (optional):'" & $sPCName & "', PDH DLL 'handle' (or just 'pdh.dll'):" & $hPDHDLL)
	If $sPCName = "" Then
		$sPCName = 0
		$sMachineParamType = "ptr"
	Else
		$sMachineParamType = "wstr"
	EndIf
	$aRet = DllCall($hPDHDLL, "long", "PdhLookupPerfIndexByNameW", $sMachineParamType, $sPCName, "wstr", $sCounterOrObject, "dword*", 0)
	If @error Then Return SetError(2, @error, -1)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("_PDHGetCounterIndex non-zero error code:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, -1)
	EndIf
	_PDH_DebugWrite("_PDHGetCounterIndex results: Index:" & $aRet[3])
	Return $aRet[3]
EndFunc   ;==>_PDH_GetCounterIndex
Func _PDH_GetCounterInfo($hPDHCounterHandle)
	If Not $_PDH_bInit Then Return SetError(16, 0, "")
	If Not IsPtr($hPDHCounterHandle) Then Return SetError(1, 0, "")
	Local $aRet, $iBufSize
	Local $stCounterBuffer, $stCounterInfo
	$aRet = DllCall($_PDH_hDLLHandle, "long", "PdhGetCounterInfoW", "ptr", $hPDHCounterHandle, "bool", True, "dword*", 0, "ptr", 0)
	If @error Then Return SetError(2, @error, "")
	If ($aRet[0] And $aRet[0] <> 0x800007D2) Or ($aRet[0] = 0 And $aRet[3] = 0) Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhGetCounterInfoW 1st call unsuccessful, return:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, "")
	EndIf
	$iBufSize = $aRet[3]
	$stCounterBuffer = DllStructCreate("byte[" & $iBufSize & "]")
	$aRet = DllCall($_PDH_hDLLHandle, "long", "PdhGetCounterInfoW", "ptr", $hPDHCounterHandle, "bool", True, "dword*", $iBufSize, "ptr", DllStructGetPtr($stCounterBuffer))
	If @error Then Return SetError(2, @error, "")
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhGetCounterInfoW 2nd call unsuccessful, return:" & Hex($_PDH_iLastError))
		Return SetError(4, $_PDH_iLastError, "")
	EndIf
	_PDH_DebugWrite("PdhGetCounterInfoW 2nd call successful, 1st Reported BufSize:" & $iBufSize & ", Return Size (should match)" & $aRet[3])
	Local $tagPDH_COUNTER_INFO = "dword;dword;dword;long;long;long;dword_ptr;dword_ptr;ptr;ptr;ptr;ptr;ptr;dword;ptr"
	If Not @AutoItX64 Then $tagPDH_COUNTER_INFO &= ";dword Filler"
	$tagPDH_COUNTER_INFO &= ";ptr ExplainText"
	$stCounterInfo = DllStructCreate($tagPDH_COUNTER_INFO, DllStructGetPtr($stCounterBuffer))
	Dim $aCounterInfo[14]
	$aCounterInfo[0] = DllStructGetData($stCounterInfo, 2)
	For $i = 1 To 5
		$aCounterInfo[$i] = DllStructGetData($stCounterInfo, $i + 3)
	Next
	For $i = 6 To 10
		$aCounterInfo[$i] = __PDH_StringGetNullTermMemStr(DllStructGetData($stCounterInfo, $i + 3))
	Next
	$aCounterInfo[11] = DllStructGetData($stCounterInfo, 14)
	$aCounterInfo[12] = __PDH_StringGetNullTermMemStr(DllStructGetData($stCounterInfo, 15))
	$aCounterInfo[13] = __PDH_StringGetNullTermMemStr(DllStructGetData($stCounterInfo, "ExplainText"))
	Return $aCounterInfo
EndFunc   ;==>_PDH_GetCounterInfo
Func _PDH_CollectQueryData($hPDHQueryHandle, $bSkipChecks = False)
	If Not $bSkipChecks Then
		If Not $_PDH_bInit Then Return SetError(16, 0, False)
		If Not IsPtr($hPDHQueryHandle) Then Return SetError(1, 0, False)
	EndIf
	Local $aRet = DllCall($_PDH_hDLLHandle, "long", "PdhCollectQueryData", "ptr", $hPDHQueryHandle)
	If @error Then Return SetError(2, @error, False)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhCollectQueryData error, return:" & Hex($_PDH_iLastError))
		Return SetError(3, $_PDH_iLastError, False)
	EndIf
	Return True
EndFunc   ;==>_PDH_CollectQueryData
Func _PDH_UpdateCounter($hPDHQueryHandle, $hPDHCounterHandle, $sCounterPath = "", $bGrabValueOnly = False)
	If Not $_PDH_bInit Then Return SetError(16, 0, -1)
	If Not IsPtr($hPDHCounterHandle) Then Return SetError(1, 0, -1)
	If Not $bGrabValueOnly Then
		If Not IsPtr($hPDHQueryHandle) Then Return SetError(1, 0, -1)
		If Not _PDH_CollectQueryData($hPDHQueryHandle, True) Then Return SetError(@error, @extended, -1)
	EndIf
	Local $stCounterValue = DllStructCreate("long;int64")
	Local $aRet = DllCall($_PDH_hDLLHandle, "long", "PdhGetFormattedCounterValue", "ptr", $hPDHCounterHandle, "dword", 0x8400, "dword*", 0, "ptr", DllStructGetPtr($stCounterValue))
	If @error Then Return SetError(2, @error, -1)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		If $aRet[0] = 0xC0000BC6 And DllStructGetData($stCounterValue, 1) = 0x800007D1 Then
			_PDH_DebugWriteErr("Invalid Data (invalid handle) message for Handle:" & $hPDHCounterHandle & ", Path [if passed]:" & $sCounterPath)
			Return SetError(-1, $_PDH_iLastError, -1)
		EndIf
		_PDH_DebugWriteErr("Error Calling PdhGetFormattedCounterValue for Handle:" & $hPDHCounterHandle & ", Path [if passed]:" & $sCounterPath & ", Return:" & Hex($_PDH_iLastError))
		Return SetError(4, $_PDH_iLastError, -1)
	EndIf
	If $sCounterPath = -2 Or ($sCounterPath <> "" And StringRegExp($sCounterPath, "(:23(0|2)\\6|(Thread|Process)\([^%]+%)", 0)) Then Return Round(DllStructGetData($stCounterValue, 2) / $_PDH_iCPUCount)
	Return DllStructGetData($stCounterValue, 2)
EndFunc   ;==>_PDH_UpdateCounter
Func _PDH_UpdateWildcardCounter($hPDHQueryHandle, $hPDHCounterHandle, $sCounterWildcardPath = "", $bGrabValueOnly = False)
	Local $aValueArray[1][2] = [[0, 0]]
	If Not $_PDH_bInit Then Return SetError(16, 0, $aValueArray)
	If Not IsPtr($hPDHCounterHandle) Then Return SetError(1, 0, $aValueArray)
	If Not $bGrabValueOnly Then
		If Not IsPtr($hPDHQueryHandle) Then Return SetError(1, 0, $aValueArray)
		If Not _PDH_CollectQueryData($hPDHQueryHandle, True) Then Return SetError(@error, @extended, $aValueArray)
	EndIf
	Local $aRet, $stCounterBuffer, $stCountValueItem, $iCountValueSz, $pPointer, $iDivisor = 0
	$aRet = DllCall($_PDH_hDLLHandle, "long", "PdhGetFormattedCounterArrayW", "ptr", $hPDHCounterHandle, "dword", 0x8400, "dword*", 0, "dword*", 0, "ptr", 0)
	If @error Then Return SetError(2, @error, $aValueArray)
	If $aRet[0] <> 0x800007D2 And Not ($aRet[0] = 0 And $aRet[3] And @OSVersion = "WIN_2000") Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhGetFormattedCounterArrayW 1st call unsuccessful, return:" & Hex($_PDH_iLastError) & ", sz:" & $aRet[3])
		Return SetError(3, $_PDH_iLastError, $aValueArray)
	EndIf
	_PDH_DebugWrite("Required buffer size after 1st PdhGetFormattedCounterArrayW call:" & $aRet[3] & " bytes, #counters:" & $aRet[4])
	$stCounterBuffer = DllStructCreate("byte[" & $aRet[3] & ']')
	$aRet = DllCall($_PDH_hDLLHandle, "long", "PdhGetFormattedCounterArrayW", "ptr", $hPDHCounterHandle, "dword", 0x8400, "dword*", $aRet[3], "dword*", 0, "ptr", DllStructGetPtr($stCounterBuffer))
	If @error Then Return SetError(2, @error, $aValueArray)
	If $aRet[0] Then
		$_PDH_iLastError = $aRet[0]
		_PDH_DebugWriteErr("PdhGetFormattedCounterArrayW 2nd call unsuccessful, return:" & Hex($_PDH_iLastError) & ", sz:" & $aRet[3] & ", #counters:" & $aRet[4])
		Return SetError(4, $_PDH_iLastError, $aValueArray)
	EndIf
	Dim $aValueArray[$aRet[4] + 1][2] = [[$aRet[4], 0]]
	If $sCounterWildcardPath = -2 Or ($sCounterWildcardPath <> "" And StringRegExp($sCounterWildcardPath, "(:23(0|2)\\6|(Thread|Process)\([^%]+%)", 0)) Then
		$iDivisor = $_PDH_iCPUCount
	ElseIf $sCounterWildcardPath = -3 Then
		$iDivisor = 1024
	ElseIf $sCounterWildcardPath = -4 Then
		$iDivisor = 1048576
	EndIf
	$iCountValueSz = DllStructGetSize(DllStructCreate("ptr;long;dword;int64"))
	$pPointer = DllStructGetPtr($stCounterBuffer, 1)
	For $i = 1 To $aRet[4]
		$stCountValueItem = DllStructCreate("ptr;long;dword;int64", $pPointer)
		$aValueArray[$i][0] = __PDH_StringGetNullTermMemStr(DllStructGetData($stCountValueItem, 1))
		$aValueArray[$i][1] = DllStructGetData($stCountValueItem, 4)
		If $iDivisor Then $aValueArray[$i][1] = Round($aValueArray[$i][1] / $iDivisor)
		$pPointer += $iCountValueSz
	Next
	Return $aValueArray
EndFunc   ;==>_PDH_UpdateWildcardCounter
Func _PDH_UpdateCounters($hPDHQueryHandle, ByRef $aPDHCountersArray, $iHandleIndex, $iCountIndex, $iStrIndex = -1, $iDeltaIndex = -1, $iStart = 1, $iEnd = -1, $bFirstCall = False)
	Dim $_PDH_aInvalidHandles[1] = [0]
	If Not IsArray($aPDHCountersArray) Or UBound($aPDHCountersArray, 0) < 2 Then Return SetError(1, 0, False)
	Local $iArrayColumns, $aRet, $stCounterValue, $iNewVal, $iChangesCount = 0, $iDivisor = 0
	$iArrayColumns = UBound($aPDHCountersArray, 2)
	If $iHandleIndex < 0 Or $iHandleIndex > $iArrayColumns Or $iCountIndex < 0 Or $iCountIndex > $iArrayColumns Or $iStrIndex > $iArrayColumns Or $iDeltaIndex > $iArrayColumns Then Return SetError(1, 0, False)
	If $iEnd = -1 Then $iEnd = UBound($aPDHCountersArray) - 1
	If $iStart < 0 Or $iStart > $iEnd Or $iEnd > UBound($aPDHCountersArray) - 1 Then Return SetError(1, 0, False)
	If Not _PDH_CollectQueryData($hPDHQueryHandle, False) Then Return SetError(@error, @extended, False)
	Dim $_PDH_aInvalidHandles[UBound($aPDHCountersArray) + 1]
	$_PDH_aInvalidHandles[0] = 0
	$stCounterValue = DllStructCreate("long;int64")
	If $iStrIndex = -2 Then
		$iDivisor = $_PDH_iCPUCount
	ElseIf $iStrIndex = -3 Then
		$iDivisor = 1024
	ElseIf $iStrIndex = -4 Then
		$iDivisor = 1048576
	EndIf
	For $i = $iStart To $iEnd
		If IsPtr($aPDHCountersArray[$i][$iHandleIndex]) Then
			$aRet = DllCall($_PDH_hDLLHandle, "long", "PdhGetFormattedCounterValue", "ptr", $aPDHCountersArray[$i][$iHandleIndex], "dword", 0x8400, "dword*", 0, "ptr", DllStructGetPtr($stCounterValue))
			If @error Then
				If $iStrIndex >= 0 Then
					_PDH_DebugWriteErr("DLL Call error (" & @error & ") at item(" & $aPDHCountersArray[$i][$iStrIndex] & ") (index #" & $i & ")")
				Else
					_PDH_DebugWriteErr("DLL Call error (" & @error & ") at index #" & $i & ", Handle:" & $aPDHCountersArray[$i][$iHandleIndex])
				EndIf
			ElseIf $aRet[0] Then
				$_PDH_iLastError = $aRet[0]
				If $aRet[0] = 0xC0000BC6 And DllStructGetData($stCounterValue, 1) = 0x800007D1 Then
					$_PDH_aInvalidHandles[0] += 1
					If $iStrIndex >= 0 Then
						_PDH_DebugWriteErr("Invalid Data (invalid handle) message for (" & $aPDHCountersArray[$i][$iStrIndex] & "), Total Invalids this call:" & $_PDH_aInvalidHandles[0])
						$aPDHCountersArray[$i][$iStrIndex] = "[Dead Counter Handle]:" & $aPDHCountersArray[$i][$iStrIndex]
					Else
						_PDH_DebugWriteErr("Invalid data message at index #" & $i & ", Handle:" & $aPDHCountersArray[$i][$iHandleIndex])
					EndIf
					_PDH_RemoveCounter($aPDHCountersArray[$i][$iHandleIndex])
					_PDH_DebugWriteErr("_PDH_RemoveCounter() call completed (for PDH error 'PDH_INVALID_DATA (0xC0000BC6)')")
					$_PDH_aInvalidHandles[$_PDH_aInvalidHandles[0]] = $i
					$aPDHCountersArray[$i][$iHandleIndex] = 0
					$aPDHCountersArray[$i][$iCountIndex] = 0
					If $iDeltaIndex >= 0 Then $aPDHCountersArray[$i][$iDeltaIndex] = -1
				Else
					If $iStrIndex >= 0 Then
						_PDH_DebugWriteErr("Error Calling PdhGetFormattedCounterValue for (" & $aPDHCountersArray[$i][$iStrIndex] & "), Return:" & Hex($_PDH_iLastError) & " CStatus:" & Hex(DllStructGetData($stCounterValue, 1)))
					Else
						_PDH_DebugWriteErr("Error calling PdhGetFormattedCounterValue at index #" & $i & ", Handle:" & $aPDHCountersArray[$i][$iHandleIndex] & ", Return:" & Hex($_PDH_iLastError) & " CStatus:" & Hex(DllStructGetData($stCounterValue, 1)))
					EndIf
				EndIf
			Else
				$iNewVal = DllStructGetData($stCounterValue, 2)
				If DllStructGetData($stCounterValue, 1) Then _PDH_DebugWriteErr("PdhGetFormattedCounterValue non-0 status for handle #" & $i & ":" & Hex(DllStructGetData($stCounterValue, 1)))
				If $iDivisor Then
					$iNewVal = Round($iNewVal / $iDivisor)
				ElseIf $iStrIndex >= 0 And StringRegExp($aPDHCountersArray[$i][$iStrIndex], "(:23(0|2)\\6|(Thread|Process)\([^%]+%)", 0) Then
					$iNewVal = Round($iNewVal / $_PDH_iCPUCount)
				EndIf
				If $aPDHCountersArray[$i][$iCountIndex] <> $iNewVal And Not $bFirstCall Then
					$iChangesCount += 1
					If $iDeltaIndex >= 0 Then $aPDHCountersArray[$i][$iDeltaIndex] = $iNewVal - $aPDHCountersArray[$i][$iCountIndex]
				Else
					If $iDeltaIndex >= 0 Then $aPDHCountersArray[$i][$iDeltaIndex] = 0
				EndIf
				$aPDHCountersArray[$i][$iCountIndex] = $iNewVal
			EndIf
		ElseIf $iDeltaIndex >= 0 And $aPDHCountersArray[$i][$iDeltaIndex] = -1 Then
			$aPDHCountersArray[$i][$iDeltaIndex] = 0
			$iChangesCount += 1
		EndIf
	Next
	ReDim $_PDH_aInvalidHandles[$_PDH_aInvalidHandles[0] + 1]
	$_PDH_aInvalidHandles[0] = $_PDH_aInvalidHandles[0]
	Return SetError($_PDH_aInvalidHandles[0], $iChangesCount, True)
EndFunc   ;==>_PDH_UpdateCounters
Func _PDH_GetCounterValueByPath($hPDHQueryHandle, $sCounterPath)
	If Not $_PDH_bInit Then Return SetError(16, 0, -1)
	Local $tErr, $bNewQueryHandleCreated = False
	If Not IsPtr($hPDHQueryHandle) Then
		$hPDHQueryHandle = _PDH_GetNewQueryHandle()
		If @error Then Return SetError(@error, 1, -1)
		$bNewQueryHandleCreated = True
	EndIf
	Local $hPDHCounterHandle = _PDH_AddCounter($hPDHQueryHandle, $sCounterPath)
	If @error Then
		$tErr = @error
		If $bNewQueryHandleCreated Then _PDH_FreeQueryHandle($hPDHQueryHandle)
		Return SetError($tErr, 0, -1)
	EndIf
	Local $iVal = _PDH_UpdateCounter($hPDHQueryHandle, $hPDHCounterHandle, $sCounterPath)
	$tErr = @error
	If $bNewQueryHandleCreated Then
		_PDH_FreeQueryHandle($hPDHQueryHandle)
	Else
		_PDH_RemoveCounter($hPDHCounterHandle)
	EndIf
	Return SetError($tErr, 0, $iVal)
EndFunc   ;==>_PDH_GetCounterValueByPath
Func _PDH_DebugWrite($sString, $bAddCRLF = True, $bErr = False)
	If $PDH_DEBUGLOG < 2 Then Return
	If $bAddCRLF Then $sString &= @CRLF
	ConsoleWrite($sString)
EndFunc   ;==>_PDH_DebugWrite
Func _PDH_DebugWriteErr($sString, $bAddCRLF = True)
	If $PDH_DEBUGLOG < 1 Then Return
	If $bAddCRLF Then $sString &= @CRLF
	ConsoleWriteError($sString)
EndFunc   ;==>_PDH_DebugWriteErr
Func __PDH_ForceFreeDLL($sDLLName, $iDecCount = 1)
	If Not IsString($sDLLName) Or $sDLLName = '' Then Return SetError(1, 0, 0)
	Local $aRet
	For $i = 1 To $iDecCount
		$aRet = DllCall('kernel32.dll', "handle", "GetModuleHandleW", "wstr", $sDLLName)
		If @error Then Return SetError(2, @error, 0)
		If $aRet[0] = 0 Then
			$aRet = DllCall('kernel32.dll', 'dword', 'GetLastError')
			If @error Then Return SetError(2, @error, 0)
			If $aRet[0] = 126 Then ExitLoop
			Return SetError(3, 0, 0)
		EndIf
		$aRet = DllCall('kernel32.dll', "bool", "FreeLibrary", "handle", $aRet[0])
		If @error Then Return SetError(2, @error, 0)
		If Not $aRet[0] Then Return SetError(3, 0, 0)
	Next
	_PDH_DebugWrite("__PDH_ForceFreeDLL() call succeeded for '" & $sDLLName & "', " & $i & " iterations")
	Return True
EndFunc   ;==>__PDH_ForceFreeDLL
Func __PDH_RegistryToggle($bEnable, $sPCName = '')
	If Not IsString($sPCName) Then Return SetError(1, 0, False)
	If $sPCName <> '' Then $sPCName &= '\'
	Local $PDH_RegValues[3][3] = [[$sPCName & "HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Perflib", ''], [$sPCName & "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfOS\Performance", ''], [$sPCName & "HKEY_LOCAL_MACHINE\SYSTEM\CurrentControlSet\Services\PerfProc\Performance", '']]
	Local Const $PDH_DisableValue = "Disable Performance Counters"
	Local $iSetVal, $iErr = 0, $iChanged = 0
	If $bEnable Then
		$iSetVal = 0
	Else
		$iSetVal = 1
	EndIf
	For $i = 0 To 2
		$PDH_RegValues[$i][1] = RegRead($PDH_RegValues[$i][0], $PDH_DisableValue)
		If @error Then $PDH_RegValues[$i][1] = 0
		If ($bEnable And $PDH_RegValues[$i][1] And IsInt($PDH_RegValues[$i][1])) Or ($bEnable = 0 And $PDH_RegValues[$i][1] = 0) Then
			If $bEnable = -1 Then
				_PDH_DebugWriteErr("Performance Counters disabled, Registry Key: '" & $PDH_RegValues[$i][0] & "'")
				Return SetError(-1, 0, False)
			EndIf
			RegWrite($PDH_RegValues[$i][0], $PDH_DisableValue, "REG_DWORD", $iSetVal)
			$iErr = @error
			If $iErr Then ExitLoop
			$iChanged += 1
		EndIf
	Next
	If $bEnable = -1 Then Return 1
	If $iErr Then
		For $i = 0 To 2
			If ($bEnable And $PDH_RegValues[$i][1] And IsInt($PDH_RegValues[$i][1])) Or ($bEnable = 0 And $PDH_RegValues[$i][1] = 0) Then
				RegWrite($PDH_RegValues[$i][0], $PDH_DisableValue, "REG_DWORD", $PDH_RegValues[$i][1])
			EndIf
		Next
		Return SetError(16, $iErr, False)
	EndIf
	Return SetExtended($iChanged, True)
EndFunc   ;==>__PDH_RegistryToggle
Func __PDH_LocalizeCounter($sNonLocalizedCounter)
	Local $aSplitPath, $sPCName = ""
	$aSplitPath = StringSplit(StringTrimLeft($sNonLocalizedCounter, 1), "\", 0)
	If @error Or $aSplitPath[0] < 3 Then Return SetError(7, 0, "")
	If $aSplitPath[0] > 3 And $aSplitPath[4] <> "" Then $sPCName = '\\' & $aSplitPath[4]
	Return $sPCName & '\' & _PDH_GetCounterNameByIndex(Int($aSplitPath[1]), $sPCName) & $aSplitPath[3] & '\' & _PDH_GetCounterNameByIndex(Int($aSplitPath[2]), $sPCName)
EndFunc   ;==>__PDH_LocalizeCounter
Func __PDH_StringGetNullTermMemStr($pStringPtr)
	If Not IsPtr($pStringPtr) Or $pStringPtr = 0 Then Return SetError(1, 0, "")
	Local $aRet = DllCall("kernel32.dll", "int", "lstrlenW", "ptr", $pStringPtr)
	If @error Then Return SetError(2, @error, "")
	If $aRet[0] = 0 Then Return ""
	Local $stString = DllStructCreate("wchar[" & $aRet[0] & "]", $pStringPtr)
	Return SetExtended($aRet[0], DllStructGetData($stString, 1))
EndFunc   ;==>__PDH_StringGetNullTermMemStr
;~ Func _WinAPI_GetSystemInfo($iInformation = -1)
;~ 	If $iInformation <> -1 And ($iInformation < 1 Or $iInformation > 10) Then Return SetError(1, 0, -1)
;~ 	Local $aRet, $stSystemInfo = DllStructCreate("ushort;short;dword;ptr;ptr;ulong_ptr;dword;dword;dword;short;short")
;~ 	If Not @AutoItX64 And @OSArch <> "X86" Then
;~ 		$aRet = DllCall("kernel32.dll", "none", "GetNativeSystemInfo", "ptr", DllStructGetPtr($stSystemInfo))
;~ 	Else
;~ 		$aRet = DllCall("kernel32.dll", "none", "GetSystemInfo", "ptr", DllStructGetPtr($stSystemInfo))
;~ 	EndIf
;~ 	If @error Then Return SetError(2, @error, -1)
;~ 	If $iInformation <> -1 Then
;~ 		If $iInformation = 1 Then Return DllStructGetData($stSystemInfo, 1)
;~ 		Return DllStructGetData($stSystemInfo, $iInformation + 1)
;~ 	EndIf
;~ 	Local $aSysInfo[10]
;~ 	$aSysInfo[0] = DllStructGetData($stSystemInfo, 1)
;~ 	For $i = 1 To 9
;~ 		$aSysInfo[$i] = DllStructGetData($stSystemInfo, $i + 2)
;~ 	Next
;~ 	Return $aSysInfo
;~ EndFunc   ;==>_WinAPI_GetSystemInfo










#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\phoenix_5Vq_icon.ico
#AutoIt3Wrapper_Outfile=Builds\AtlasServerUpdateUtility_v1.2.5.exe
#AutoIt3Wrapper_Res_Comment=By Phoenix125 based on Dateranoth's ConanServerUtility v3.3.0-Beta.3
#AutoIt3Wrapper_Res_Description=Atlas Dedicated Server Update Utility
#AutoIt3Wrapper_Res_Fileversion=1.2.5.0
#AutoIt3Wrapper_Res_ProductName=AtlasServerUpdateUtility
#AutoIt3Wrapper_Res_ProductVersion=v1.2.5
#AutoIt3Wrapper_Res_CompanyName=http://www.Phoenix125.com
#AutoIt3Wrapper_Res_LegalCopyright=http://www.Phoenix125.com
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Run_Tidy=y
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/mo
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

;**** Directives created by AutoIt3Wrapper_GUI ****

#include <Date.au3>
#include <Process.au3>
#include <StringConstants.au3>
#include <String.au3>
#include <IE.au3>
#include <Array.au3>
#include <MsgBoxConstants.au3>
#include <File.au3>
#include <Inet.au3>

; All Servers
$aUtilVersion = "v1.2.5" ; (2019-02-24)
$aUtilName = "AtlasServerUpdateUtility"
$aGameName = "Atlas"
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

;Atlas Only
$aServerRedisCmd = "redis-server.exe"
$aServerRedisDir = "\AtlasTools\RedisDatabase"
$aServerPIDRedis = "0"
Global $xTelnetCMD[100]
Global $xServerStart[100]
Global $aServerPID[100]
Global $yServerAltSaveDir[100]
Global $xServerModList[20]
Global Const $aGridFile = @ScriptDir & "\" & $aUtilName & "GridStartSelect.ini"

$aUsePuttytel = "yes"
$aTelnetCheckYN = "no"
$aTelnetCheckSec = "300"
$aTelnetPort = "27520"
$aTelnetPass = "TeLneT_PaSsWoRd"
$aServerVer = "0"
$aServerIP = "127.0.0.1"


#Region ;**** Global Variables ****
Global Const $aIniFile = @ScriptDir & "\" & $aUtilName & ".ini"
Global Const $aUtilityVer = $aUtilName & " " & $aUtilVersion
Global Const $aLogFile = @ScriptDir & "\" & $aUtilName & ".log"
Global $aTimeCheck0 = _NowCalc()
Global $aTimeCheck1 = _NowCalc()
Global $aTimeCheck2 = _NowCalc()
Global $aTimeCheck3 = _NowCalc()
Global $aTimeCheck4 = _NowCalc()
Global $aTimeCheck5 = _NowCalc()
$aBeginDelayedShutdown = 0
$aUpdateVerify = "no"
$aFailCount = 0
$aShutdown = 0
$aAnnounceCount1 = 0
$aErrorShutdown = 0
#EndRegion ;**** Global Variables ****

; -----------------------------------------------------------------------------------------------------------------------
#Region ;**** Startup Checks. Initial Log, Read INI, Check for Correct Paths, Check Remote Restart is bound to port. ****
OnAutoItExitRegister("Gamercide")
SplashTextOn($aUtilName, $aUtilName & " started.", 400, 100, -1, -1, $DLG_MOVEABLE, "")
FileWriteLine($aLogFile, _NowCalc() & " ============================ " & $aUtilName & " " & $aUtilVersion & " Started ============================")
SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Importing settings from " & $aIniFile & ".", 400, 100, -1, -1, $DLG_MOVEABLE, "")
ReadUini($aIniFile, $aLogFile)

; Atlas
SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Importing settings from " & $aConfigFile & ".", 400, 100, -1, -1, $DLG_MOVEABLE, "")
ImportConfig($aServerDirLocal, $aConfigFile)
;If $aServerRCONImport = "yes" Then
;	$aServerRCONPort=ImportRCON($aServerDirLocal, $xServerAltSaveDir, $aServerGridTotal)
;EndIf
$aTelnetPass = $aServerAdminPass

SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Importing settings from " & $aGridFile & ".", 400, 100, -1, -1, $DLG_MOVEABLE, "")
GridStartSelect($aGridFile, $aLogFile)

SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Preparing server startup scripts.", 400, 100, -1, -1, $DLG_MOVEABLE, "")
If $xServerAltSaveDir = "" Then
	For $i = 0 To ($aServerGridTotal - 1)
		$yServerAltSaveDir[$i] = "a" & $xServergridx[$i] & $xServergridy[$i]
	Next
	If $aServerRCONImport = "yes" Then
		$xServerRCONPort = ImportRCON($aServerDirLocal, $yServerAltSaveDir, $aServerGridTotal, $xStartGrid)
	EndIf
Else
	If ($aServerRCONImport = "yes") Then
		$xServerRCONPort = ImportRCON($aServerDirLocal, $xServerAltSaveDir, $aServerGridTotal, $xStartGrid)
	EndIf
EndIf

If ($sInGameAnnounce = "yes") Or ($aTelnetCheckYN = "yes") Or ($aEnableRCON = "yes") And ($aServerWorldFriendlyName <> "TempXY") Then ; "TempXY" indicates temp settings set to complete a fresh install of Atlas files.
	If $aServerGridTotal <> (UBound($xServerRCONPort) - 1) Then
		SplashOff()
		Local $aErrorMsg = "[CRITICAL ERROR!] The number of grids does not match the number of RCON ports listed in " & $aUtilName & ".ini." & @CRLF & "Grid Total:" & $aServerGridTotal & ". Number of RCON entries:" & (UBound($xServerRCONPort) - 1) & @CRLF & "Example: Server RCON Port(s) (comma separated, grid order left-to-right ) ###: 57510,57512,57514,57516" & @CRLF & @CRLF & "Please correct the RCON entries in " & $aUtilName & ".ini file and restart " & $aUtilName & "."
		FileWriteLine($aLogFile, _NowCalc() & $aErrorMsg)
		MsgBox($MB_OK, $aUtilName, $aErrorMsg)
		Exit
	EndIf
EndIf

If $aServerGridTotal <> (UBound($xServerAltSaveDir)) And ($xServerAltSaveDir <> "") And ($aServerWorldFriendlyName <> "TempXY") Then
	SplashOff()
	Local $aErrorMsg = "[CRITICAL ERROR!] The number of grids does not match the number of AltSaveDirectoryNames listed in " & $aUtilName & ".ini." & @CRLF & "Grid Total:" & $aServerGridTotal & ". Number of Server AltSaveDirectoryName entries:" & (UBound($xServerAltSaveDir)) & @CRLF & "Example: Server AltSaveDirectoryName(s) (comma separated. Leave blank for default a00 a01 a10, etc) ###" & @CRLF & @CRLF & "Please correct the AltSaveDirectoryName entries in " & $aUtilName & ".ini file and restart " & $aUtilName & "."
	FileWriteLine($aLogFile, _NowCalc() & $aErrorMsg)
	MsgBox($MB_OK, $aUtilName, $aErrorMsg)
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
$xServerRedis = """" & $aServerDirLocal & $aServerRedisDir & "\" & $aServerRedisCmd & """ """ & $aServerDirLocal & $aServerRedisDir & "\" & $aServerRedisConfig & """"

If $xServerAltSaveDir = "" Then
	For $i = 0 To ($aServerGridTotal - 1)
		$xServerStart[$i] = """" & $aServerDirFull & "\" & $aServerEXE & """ Ocean?ServerX=" & $xServergridx[$i] & "?ServerY=" & $xServergridy[$i] & "?AltSaveDirectoryName=a" & $xServergridx[$i] & $xServergridy[$i] & "?ServerAdminPassword=" & $aServerAdminPass & "?MaxPlayers=" & $aServerMaxPlayers & "?ReservedPlayerSlots=" & $aServerReservedSlots & "?QueryPort=" & $xServerport[$i] & "?Port=" & $xServergameport[$i] & "?SeamlessIP=" & $xServerIP[$i] & $aServerMultiHomeFull & $xTelnetCMD[$i] & $aServerExtraCMD
		If ($xStartGrid[$i] = "yes") Or $xDebug Then
			FileWriteLine($aLogFile, _NowCalc() & " Imported from ServerGrid.json: Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " Port:" & $xServergameport[$i] & " GamePort:" & $xServerport[$i] & " SeamlessIP:" & $xServerIP[$i] & " RCONPort:" & $xServerRCONPort[$i + 1] & " Folder:a" & $xServergridx[$i] & $xServergridy[$i])
		EndIf
		$yServerAltSaveDir[$i] = "a" & $xServergridx[$i] & $xServergridy[$i]
	Next
Else
	For $i = 0 To ($aServerGridTotal - 1)
		$xServerStart[$i] = """" & $aServerDirFull & "\" & $aServerEXE & """ Ocean?ServerX=" & $xServergridx[$i] & "?ServerY=" & $xServergridy[$i] & "?AltSaveDirectoryName=" & $xServerAltSaveDir[$i] & "?ServerAdminPassword=" & $aServerAdminPass & "?MaxPlayers=" & $aServerMaxPlayers & "?ReservedPlayerSlots=" & $aServerReservedSlots & "?QueryPort=" & $xServerport[$i] & "?Port=" & $xServergameport[$i] & "?SeamlessIP=" & $xServerIP[$i] & $aServerMultiHomeFull & $xTelnetCMD[$i] & $aServerExtraCMD
		If ($xStartGrid[$i] = "yes") Or $xDebug Then
			FileWriteLine($aLogFile, _NowCalc() & " Imported from ServerGrid.json: Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " Port:" & $xServergameport[$i] & " GamePort:" & $xServerport[$i] & " SeamlessIP:" & $xServerIP[$i] & " RCONPort:" & $xServerRCONPort[$i + 1] & " Folder:" & $xServerAltSaveDir[$i])
		EndIf
	Next
EndIf
;If $aServerRCONImport = "yes" Then
;	$xServerRCONPort=ImportRCON($aServerDirLocal, $zServerAltSaveDir, $aServerGridTotal)
;EndIf

; Generic
;$aSteamCMDDir = $aServerDirLocal & "\SteamCMD"
Global $aSteamAppFile = $aServerDirLocal & "\steamapps\appmanifest_" & $aSteamAppID & ".acf"

SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Checking for existance of external files.", 400, 100, -1, -1, $DLG_MOVEABLE, "")
FileExistsFunc()
SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Checking for existance of external scripts (if enabled).", 400, 100, -1, -1, $DLG_MOVEABLE, "")
ExternalScriptExist()

;SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Importing settings from " & $aGridFile & ".", 400, 100, -1, -1, $DLG_MOVEABLE, "")
;GridStartSelect($aGridFile, $aLogFile)

If $aRemoteRestartUse = "yes" Then
	SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Initializing Remote Restart.", 400, 100, -1, -1, $DLG_MOVEABLE, "")
	TCPStartup()
	Local $aRemoteRestartSocket = TCPListen($aRemoteRestartIP, $aRemoteRestartPort, 100)
	If $aRemoteRestartSocket = -1 Then
		MsgBox(0x0, "TCP Error", "Could not bind to [" & $aRemoteRestartIP & "] Check server IP or disable Remote Restart in INI")
		FileWriteLine($aLogFile, _NowCalc() & " Remote Restart Enabled. Could not bind to " & $aRemoteRestartIP & ":" & $aRemoteRestartPort)
		Exit
	Else
		If $sObfuscatePass = "no" Then
			FileWriteLine($aLogFile, _NowCalc() & " Remote Restart enabled. Listening for restart request at http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/?" & $aRemoteRestartKey & "=" & $aRemoteRestartCode)
		Else
			FileWriteLine($aLogFile, _NowCalc() & " Remote Restart enabled. Listening for restart request at http://" & $aRemoteRestartIP & ":" & $aRemoteRestartPort & "/?[key]=[password]")
		EndIf
	EndIf
EndIf

FileWriteLine($aLogFile, _NowCalc() & " Running initial update check . . ")

$aFirstBoot = True
;SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Preparing initial update check.", 400, 100, -1, -1, $DLG_MOVEABLE, "")
Local $bRestart = UpdateCheck()
$aFirstBoot = False
If $bRestart Then
	SteamcmdDelete($aSteamCMDDir)
	$aBeginDelayedShutdown = 1
EndIf

If Not ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
	$aBeginDelayedShutdown = 0
	$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir)
	If $xDebug Then
		FileWriteLine($aLogFile, _NowCalc() & " [Redis started (PID: " & $aServerPIDRedis & ")] " & $xServerRedis)
	Else
		FileWriteLine($aLogFile, _NowCalc() & " [Redis started (PID: " & $aServerPIDRedis & ")]")

	EndIf
	$aTimeCheck5 = _NowCalc()
EndIf
For $i = 0 To ($aServerGridTotal - 1)
	;	If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) And ($xStartGrid[$i] = "yes") Then
	If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) Then
		If $i = 0 Then
			$aSteamEXE = $aSteamCMDDir & "\steamcmd.exe +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir """ & $aServerDirLocal & """ +app_update " & $aSteamAppID
			If ($aValidate = "yes") Then
				$aSteamEXE = $aSteamEXE & " validate"
			EndIf
			$aSteamEXE = $aSteamEXE & " +quit"
			If $xDebug Then
				FileWriteLine($aLogFile, _NowCalc() & " [Running SteamCMD update] " & $aSteamEXE)
			Else
				FileWriteLine($aLogFile, _NowCalc() & " [Running SteamCMD update]")
			EndIf
			RunWait($aSteamEXE)
			SplashOff()
		EndIf
		If $xStartGrid[$i] = "yes" Then
			$aServerPID[$i] = Run($xServerStart[$i])
			If $xDebug Then
				FileWriteLine($aLogFile, _NowCalc() & " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
			Else
				FileWriteLine($aLogFile, _NowCalc() & " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")]")
			EndIf
		Else
			FileWriteLine($aLogFile, _NowCalc() & " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " -*NOT*- STARTED] because it is set to ""no"" in " & $aGridFile)
		EndIf
	EndIf
	Sleep($aServerStartDelay * 1000)
Next

#EndRegion ;**** Startup Checks. Initial Log, Read INI, Check for Correct Paths, Check Remote Restart is bound to port. ****

While True ;**** Loop Until Closed ****
	#Region ;**** Listen for Remote Restart Request ****
	If $aRemoteRestartUse = "yes" Then
		Local $sRestart = _RemoteRestart($aRemoteRestartSocket, $aRemoteRestartCode, $aRemoteRestartKey, $sObfuscatePass, $aRemoteRestartIP, $aServerName, $xDebug)
		Switch @error
			Case 0
				;If ProcessExists($aServerPID) And ($aBeginDelayedShutdown = 0) Then
				If $aBeginDelayedShutdown = 0 Then
					FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & "] " & $sRestart)
					If ($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes") Then
						$aRebootReason = "remoterestart"
						$aBeginDelayedShutdown = 1
						$aTimeCheck0 = _NowCalc
					Else
						RunExternalRemoteRestart()
						CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
					EndIf
				EndIf
			Case 1 To 4
				FileWriteLine($aLogFile, _NowCalc() & " " & $sRestart & @CRLF)
		EndSwitch
	EndIf
	#EndRegion ;**** Listen for Remote Restart Request ****

	#Region ;**** Keep Server Alive Check. ****
	If Not ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
		$aBeginDelayedShutdown = 0
		$aServerPIDRedis = Run($xServerRedis, $aServerDirLocal & $aServerRedisDir)
		If $xDebug Then
			FileWriteLine($aLogFile, _NowCalc() & " [Redis started (PID: " & $aServerPIDRedis & ")] " & $xServerRedis)
		Else
			FileWriteLine($aLogFile, _NowCalc() & " [Redis started (PID: " & $aServerPIDRedis & ")]")

		EndIf
		$aTimeCheck5 = _NowCalc()
	EndIf
	SplashOff()
	; ------------------------------

	For $i = 0 To ($aServerGridTotal - 1)
		If Not ProcessExists($aServerPID[$i]) And ($aShutdown = 0) And ($xStartGrid[$i] = "yes") Then
			If $i = 0 Then
				;SteamcmdDelete($aSteamCMDDir)
				$aSteamEXE = $aSteamCMDDir & "\steamcmd.exe +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir """ & $aServerDirLocal & """ +app_update " & $aSteamAppID
				;If ($aValidate = "yes") Or ($aUpdateVerify = "yes") Then
				If ($aValidate = "yes") Then
					;			$aUpdateVerify = "no"
					$aSteamEXE = $aSteamEXE & " validate"
				EndIf
				If ((_DateDiff('n', $aTimeCheck5, _NowCalc())) >= 1) Then
					$aTimeCheck5 = _NowCalc()
				Else
					$aFailCount = $aFailCount + 1
				EndIf
				;If $aServerVer = 1 Then
				;	$aSteamEXE = $aSteamEXE & " -" & $aExperimentalString
				;EndIf
				$aSteamEXE = $aSteamEXE & " +quit"
				If $xDebug Then
					FileWriteLine($aLogFile, _NowCalc() & " [Running SteamCMD update] " & $aSteamEXE)
				Else
					FileWriteLine($aLogFile, _NowCalc() & " [Running SteamCMD update]")
				EndIf
				RunWait($aSteamEXE)
				SplashOff()
			EndIf
			;Sleep(5000)

			If $xStartGrid[$i] = "yes" Then
				$aServerPID[$i] = Run($xServerStart[$i])
				If $xDebug Then
					FileWriteLine($aLogFile, _NowCalc() & " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")] " & $xServerStart[$i])
				Else
					FileWriteLine($aLogFile, _NowCalc() & " [Server " & $xServergridx[$i] & "," & $xServergridy[$i] & " started (PID: " & $aServerPID[$i] & ")]")
				EndIf
			EndIf
		EndIf
	Next

	; ------------------------------
	;	If $aServerQnty > 1 Then
	;		If Not ProcessExists($aServerPID10) And $aShutdown = 0 Then
	;			If ((_DateDiff('n', $aTimeCheck5, _NowCalc())) >= 1) Then
	;				$aTimeCheck5 = _NowCalc()
	;			Else
	;				$aFailCount = $aFailCount + 1
	;			EndIf
	;			Sleep(10000)
	;			$aServerPID10 = Run($xServer10)
	;			If $xDebug Then
	;				FileWriteLine($aLogFile, _NowCalc() & " [Server 10 started (PID: " & $aServerPID10 & ")] " & $xServer10)
	;			Else
	;				FileWriteLine($aLogFile, _NowCalc() & " [Server 10 started (PID: " & $aServerPID10 & ")]")
	;			EndIf
	;		EndIf
	;	EndIf
	;	If $aServerQnty > 2 Then
	;		If Not ProcessExists($aServerPID01) And $aShutdown = 0 Then
	;			If ((_DateDiff('n', $aTimeCheck5, _NowCalc())) >= 1) Then
	;				$aTimeCheck5 = _NowCalc()
	;			Else
	;				$aFailCount = $aFailCount + 1
	;			EndIf
	;			Sleep(15000)
	;			$aServerPID01 = Run($xServer01, $aServerDirFull)
	;			If $xDebug Then
	;				FileWriteLine($aLogFile, _NowCalc() & " [Server 01 started (PID: " & $aServerPID01 & ")] " & $xServer01)
	;			Else
	;				FileWriteLine($aLogFile, _NowCalc() & " [Server 01 started (PID: " & $aServerPID01 & ")]")
	;			EndIf
	;		EndIf
	;	EndIf
	;	If $aServerQnty > 3 Then
	;		If Not ProcessExists($aServerPID11) And $aShutdown = 0 Then
	;			If ((_DateDiff('n', $aTimeCheck5, _NowCalc())) >= 1) Then
	;				$aTimeCheck5 = _NowCalc()
	;			Else
	;				$aFailCount = $aFailCount + 1
	;			EndIf
	;			Sleep(20000)
	;			$aServerPID11 = Run($xServer11, $aServerDirFull)
	;			If $xDebug Then
	;				FileWriteLine($aLogFile, _NowCalc() & " [Server 11 started (PID: " & $aServerPID11 & ")] " & $xServer11)
	;			Else
	;				FileWriteLine($aLogFile, _NowCalc() & " [Server 11 started (PID: " & $aServerPID11 & ")]")
	;			EndIf
	;			Sleep(1000)
	;		EndIf
	;	EndIf
	;	If $aFailCount = 3 Then
	;		FailCountRun()
	;	EndIf
	#EndRegion ;**** Keep Server Alive Check. ****

	#Region ;**** Restart Server Every X Days and X Hours & Min****
	If (($aRestartDaily = "yes") And ((_DateDiff('n', $aTimeCheck2, _NowCalc())) >= 1) And (DailyRestartCheck($aRestartDays, $aRestartHours, $aRestartMin)) And ($aBeginDelayedShutdown = 0)) Then
		;		If ProcessExists($aServerPID) Then
		;		Local $MEM = ProcessGetStats($aServerPID, 0)
		;		FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & "] Work Memory:" & $MEM[0] & " Peak Memory:" & $MEM[1] & " - Daily restart requested by " & $aUtilName & ".")
		FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & "] - Daily restart requested by " & $aUtilName & ".")
		If $aDelayShutdownTime Not = 0 Then
			$aBeginDelayedShutdown = 1
			$aRebootReason = "daily"
			$aTimeCheck0 = _NowCalc
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
	;				FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & " (PID: " & $aServerPID & ")] Server not responding to telnet. Restarting server.")
	;			EndIf
	;			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
	;		Else
	;			If $xDebug Then
	;				FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & " (PID: " & $aServerPID & ")] Server responded to telnet inquiry.")
	;			EndIf
	;		EndIf
	;	EndIf
	;	#EndRegion ;**** KeepServerAlive Telnet Check ****

	#Region ;**** Check for Update every X Minutes ****
	If ($aCheckForUpdate = "yes") And ((_DateDiff('n', $aTimeCheck0, _NowCalc())) >= $aUpdateCheckInterval) And ($aBeginDelayedShutdown = 0) Then
		Local $bRestart = UpdateCheck()
		If $bRestart And (($sUseDiscordBotDaily = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotDaily = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes")) Then
			$aBeginDelayedShutdown = 1
			$aRebootReason = "update"
		ElseIf $bRestart Then
			RunExternalScriptUpdate()
			;			SteamcmdDelete($aSteamCMDDir)
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
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
				SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, "FINAL WARNING! Rebooting server in 10 seconds...")
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

	#Region ;**** Rotate Logs ****
	If (_DateDiff('h', $aTimeCheck4, _NowCalc()) >= 1) Then
		If Not FileExists($aLogFile) Then
			FileWriteLine($aLogFile, $aTimeCheck4 & " Log File Created")
			FileSetTime($aLogFile, @YEAR & @MON & @MDAY, 1)
		EndIf
		Local $aLogFileTime = FileGetTime($aLogFile, 1)
		Local $logTimeSinceCreation = _DateDiff('h', $aLogFileTime[0] & "/" & $aLogFileTime[1] & "/" & $aLogFileTime[2] & " " & $aLogFileTime[3] & ":" & $aLogFileTime[4] & ":" & $aLogFileTime[5], _NowCalc())
		If $logTimeSinceCreation >= $aLogHoursBetweenRotate Then
			RotateFile($aLogFile, $aLogQuantity)
		EndIf
		$aTimeCheck4 = _NowCalc()
	EndIf
	#EndRegion ;**** Rotate Logs ****

	Sleep(1000)
WEnd

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** INI Settings - User Variables ****

Func ReadUini($sIniFile, $sLogFile)
	Local $iIniError = ""
	Local $iIniFail = 0
	Local $iniCheck = ""
	Local $aChar[3]
	For $i = 1 To 13
		$aChar[0] = Chr(Random(97, 122, 1)) ;a-z
		$aChar[1] = Chr(Random(48, 57, 1)) ;0-9
		$iniCheck &= $aChar[Random(0, 1, 1)]
	Next
	Global $aServerName = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server name (for announcements and logs only) ###", $iniCheck)
	Global $aServerDirLocal = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " DIR ###", $iniCheck)
	;Global $aServerVer = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Version (0-Stable,1-Experimental) ###", $iniCheck)
	Global $aServerExtraCMD = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " extra commandline parameters (ex.?serverpve-pve -serverpassword) ###", $iniCheck)
	;	Global $aServerIP = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server IP ###", $iniCheck)
	Global $aServerMultiHomeIP = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server multi-home IP (Leave blank to disable) ###", $iniCheck)
	Global $aSteamCMDDir = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD DIR ###", $iniCheck)
	Global $aSteamExtraCMD = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD extra commandline parameters (ex. -latest_experimental) ###", $iniCheck)
	;Global $aServerSaveDir = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Gamesave directory name ###", $iniCheck)
	Global $aServerAdminPass = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Admin password ###", $iniCheck)
	Global $aServerMaxPlayers = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Max players ###", $iniCheck)
	Global $aServerReservedSlots = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Reserved slots ###", $iniCheck)
	Global $aServerRCONImport = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Import RCON ports from GameUserSettings.ini files? (yes/no) ###", $iniCheck)
	Global $aServerRCONPort = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server RCON Port(s) (comma separated, grid order left-to-right, ignore if importing RCON ports) ###", $iniCheck)
	Global $aServerAltSaveDir = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryName(s) (comma separated. List same order as listed in ServerGrid.json. Leave blank for default a00,a01,a10, etc) ###", $iniCheck)
	;MOD Global $aServerModYN = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Use this util to install mods and check for mod updates (as listed in ServerGrid.json)? (yes/no) ###", $iniCheck)
	;	Global $aServerModList = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Mod number(s) (comma separated) ###", $iniCheck)
	Global $aServerUseRedis = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Autostart and keep-alive redis-server.exe? Use NO to manage redis-server.exe yourself (yes/no) ###", $iniCheck)
	Global $aServerRedisConfig = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Redis-server config file (must be in \AtlasTools\RedisDatabase dir) (Ignore if NO to autostart above) ###", $iniCheck)
	Global $aServerStartDelay = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Delay in seconds between grid server starts (1-60) ###", $iniCheck)
	Global $aShutDnWait = IniRead($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Seconds allowed for GameSave before taskkilling servers during reboots (10-600) ###", $iniCheck)

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
	Global $aCheckForUpdate = IniRead($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Check for updates? (yes/no) ###", $iniCheck)
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
	;
	Global $sInGameAnnounce = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires telnet) (yes/no) ###", $iniCheck)
	Global $sInGameDailyMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement DAILY (\m - minutes) ###", $iniCheck)
	Global $sInGameUpdateMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $iniCheck)
	Global $sInGameRemoteRestartMessage = IniRead($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $iniCheck)
	;
	Global $sUseDiscordBotDaily = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for DAILY reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotUpdate = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for UPDATE reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotRemoteRestart = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for REMOTE RESTART reboot? (yes/no) ###", $iniCheck)
	Global $sUseDiscordBotFirstAnnouncement = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for first ANNOUNCEMENT only? (reduces bot spam)(yes/no) ###", $iniCheck)
	;Global $sUseDiscordBotAppendServer - IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Append server name to beginning of messages? (yes/no) ###", $iniCheck)
	Global $sDiscordDailyMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $iniCheck)
	Global $sDiscordUpdateMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $iniCheck)
	Global $sDiscordRemoteRestartMessage = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $iniCheck)
	Global $sDiscordWebHookURLs = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "WebHook URL ###", $iniCheck)
	Global $sDiscordBotName = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Bot Name ###", $iniCheck)
	Global $bDiscordBotUseTTS = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Use TTS? (yes/no) ###", $iniCheck)
	Global $sDiscordBotAvatar = IniRead($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Bot Avatar Link ###", $iniCheck)
	;
	Global $sUseTwitchBotDaily = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for DAILY reboot? (yes/no) ###", $iniCheck)
	Global $sUseTwitchBotUpdate = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for UPDATE reboot? (yes/no) ###", $iniCheck)
	Global $sUseTwitchBotRemoteRestart = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for REMOTE RESTART reboot? (yes/no) ###", $iniCheck)
	Global $sUseTwitchFirstAnnouncement = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for first announcement only? (reduces bot spam)(yes/no) ###", $iniCheck)
	Global $sTwitchDailyMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $iniCheck)
	Global $sTwitchUpdateMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $iniCheck)
	Global $sTwitchRemoteRestartMessage = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $iniCheck)
	Global $sTwitchNick = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Nick ###", $iniCheck)
	Global $sChatOAuth = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "ChatOAuth ###", $iniCheck)
	Global $sTwitchChannels = IniRead($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Channels ###", $iniCheck)
	;
	Global $aExecuteExternalScript = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Execute external script BEFORE update? (yes/no) ###", $iniCheck)
	Global $aExternalScriptDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Script directory ###", $iniCheck)
	Global $aExternalScriptName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Script filename ###", $iniCheck)
	;
	Global $aExternalScriptValidateYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Execute external script AFTER update but BEFORE server start? (yes/no) ###", $iniCheck)
	Global $aExternalScriptValidateDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Script directory ###", $iniCheck)
	Global $aExternalScriptValidateName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Script filename ###", $iniCheck)
	;
	Global $aExternalScriptUpdateYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Execute external script for server update restarts? (yes/no) ###", $iniCheck)
	Global $aExternalScriptUpdateDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Script directory ###", $iniCheck)
	Global $aExternalScriptUpdateFileName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Script filename ###", $iniCheck)
	;
	Global $aExternalScriptDailyYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Execute external script for daily server restarts? (yes/no) ###", $iniCheck)
	Global $aExternalScriptDailyDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Script directory ###", $iniCheck)
	Global $aExternalScriptDailyFileName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Script filename ###", $iniCheck)
	;
	Global $aExternalScriptAnnounceYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Execute external script when first restart announcement is made? (yes/no) ###", $iniCheck)
	Global $aExternalScriptAnnounceDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Script directory ###", $iniCheck)
	Global $aExternalScriptAnnounceFileName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Script filename ###", $iniCheck)
	;
	Global $aExternalScriptRemoteYN = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Execute external script during restart when a remote restart request is made? (yes/no) ###", $iniCheck)
	Global $aExternalScriptRemoteDir = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Script directory ###", $iniCheck)
	Global $aExternalScriptRemoteFileName = IniRead($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Script filename ###", $iniCheck)
	;
	Global $aLogRotate = IniRead($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Rotate log files? (yes/no) ###", $iniCheck)
	Global $aLogQuantity = IniRead($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Number of logs ###", $iniCheck)
	Global $aLogHoursBetweenRotate = IniRead($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hours between log rotations ###", $iniCheck)
	;
	Global $aEnableRCON = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable RCON? Required for clean shutdown (yes/no) ###", $iniCheck)
	;	Global $aRCONSaveDelaySec = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Delay between saveworld and quit commands during shutdown in seconds (5-120) ###", $iniCheck)
	Global $aValidate = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Validate files with SteamCMD update? (yes/no) ###", $iniCheck)
	Global $aUpdateSource = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "For update checks, use (0)SteamCMD or (1)SteamDB.com ###", $iniCheck)
	Global $aUsePuttytel = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Use puttytel for telnet client? (yes/no) ###", $iniCheck)
	Global $sObfuscatePass = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide passwords in log files? (yes/no) ###", $iniCheck)
	Global $aExternalScriptHideYN = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide external scripts when executed? (if yes, scripts may not execute properly) (yes/no) ###", $iniCheck)
	Global $aDebug = IniRead($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable debug to output more log detail? (yes/no) ###", $iniCheck)

	If $iniCheck = $aServerDirLocal Then
		$aServerDirLocal = "D:\Game Servers\" & $aGameName & " Dedicated Server"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerDirLocal, "
	EndIf
	If $iniCheck = $aSteamCMDDir Then
		$aSteamCMDDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\SteamCMD"
		$iIniFail += 1
		$iIniError = $iIniError & "SteamCMDDir, "
	EndIf
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
	If $iniCheck = $aServerName Then
		$aServerName = $aGameName
		$iIniFail += 1
		$iIniError = $iIniError & "GameName, "
	EndIf
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
	If StringLeft($aServerExtraCMD, 1) <> "?" Then
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

	;MOD	If $iniCheck = $aServerModYN Then
	;		$aServerModYN = "yes"
	;		$iIniFail += 1
	;		$iIniError = $iIniError & "ServerModYN, "
	;	EndIf
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

	If $iniCheck = $aServerStartDelay Then
		$aServerStartDelay = "5"
		$iIniFail += 1
		$iIniError = $iIniError & "ServerStartDelay, "
	ElseIf $aServerStartDelay < 1 Then
		$aServerStartDelay = 1
	ElseIf $aServerStartDelay > 60 Then
		$aServerStartDelay = 60
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
		$aRemoteRestartIP = "192.168.1.10"
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
	If $iniCheck = $aLogRotate Then
		$aLogRotate = "yes"
		$iIniFail += 1
		$iIniError = $iIniError & "LogRotate, "
	EndIf
	If $iniCheck = $aLogQuantity Then
		$aLogQuantity = "10"
		$iIniFail += 1
		$iIniError = $iIniError & "LogQuantity, "
	EndIf
	If $iniCheck = $aLogHoursBetweenRotate Then
		$aLogHoursBetweenRotate = "24"
		$iIniFail += 1
		$iIniError = $iIniError & "LogHoursBetweenRotate, "
	ElseIf $aLogHoursBetweenRotate < 1 Then
		$aLogHoursBetweenRotate = 1
	EndIf
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
	If ($aUpdateSource = "1") And ($aUpdateCheckInterval < 30) Then
		$aUpdateCheckInterval = 30
		FileWriteLine($aLogFile, _NowCalc() & "NOTICE: SteamDB will ban your IP if you check too often. Update check interval set to 30 minutes")
		$iIniError = $iIniError & "UpdateCheckInterval, "
	EndIf
	If $iniCheck = $aDebug Then
		$aDebug = "no"
		$iIniFail += 1
		$iIniError = $iIniError & "Debug, "
	EndIf
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
	If $aDebug = "yes" Then
		Global $xDebug = True ; This enables Debugging. Outputs more information to log file.
	Else
		Global $xDebug = False
	EndIf
	FileWriteLine($aLogFile, _NowCalc() & " Importing settings from " & $aUtilName & ".ini.")

	$aServerDirLocal = RemoveInvalidCharacters($aServerDirLocal)
	$aServerDirLocal = RemoveTrailingSlash($aServerDirLocal)
	$aSteamCMDDir = RemoveInvalidCharacters($aSteamCMDDir)
	$aSteamCMDDir = RemoveTrailingSlash($aSteamCMDDir)
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

	If $aServerRCONImport = "no" Then
		Global $xServerRCONPort = StringSplit($aServerRCONPort, ",")
	EndIf
	If $aServerAltSaveDir = "" Then
		Global $xServerAltSaveDir = ""
	Else
		Global $xServerAltSaveDir = StringSplit($aServerAltSaveDir, ",", 2)
	EndIf
	If $sUseDiscordBotRemoteRestart = "yes" Or $sUseDiscordBotDaily = "yes" Or $sUseDiscordBotUpdate = "yes" Or $sUseTwitchBotRemoteRestart = "yes" Or $sUseTwitchBotDaily = "yes" Or $sUseTwitchBotUpdate = "yes" Or $sInGameAnnounce = "yes" Then
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
		Global $aDelayShutdownTime = Int($aDailyTime[$aDailyCnt])
		DailyRestartOffset($bRestartHours, $bRestartMin, $aDelayShutdownTime)
	Else
		Global $aDelayShutdownTime = 0
	EndIf

	If $xDebug Then
		FileWriteLine($aLogFile, _NowCalc() & " . . . Server Folder = " & $aServerDirLocal)
		FileWriteLine($aLogFile, _NowCalc() & " . . . SteamCMD Folder = " & $aSteamCMDDir)
	Else
	EndIf
	;	If ($sInGameAnnounce = "yes") Or ($aTelnetCheckYN = "yes") And ($aTelnetRequired = "1") Then
	;		FileWriteLine($aLogFile, _NowCalc() & "RCON/Telnet Required", "RCON/Telnet required for in-game announcements and ROCN/Telnet KeepAlive checks. RCON/Telnet enabled and set to port: " & $aTelnetPort & ".")
	;	EndIf

EndFunc   ;==>ReadUini

Func iniFileCheck($sIniFile, $iIniFail, $iIniError)
	If FileExists($sIniFile) Then
		Local $aMyDate, $aMyTime
		_DateTimeSplit(_NowCalc(), $aMyDate, $aMyTime)
		Local $iniDate = StringFormat("%04i.%02i.%02i.%02i%02i", $aMyDate[1], $aMyDate[2], $aMyDate[3], $aMyTime[1], $aMyTime[2])
		FileMove($sIniFile, $sIniFile & "_" & $iniDate & ".bak", 1)
		UpdateIni($sIniFile)
		FileWriteLine($aLogFile, _NowCalc() & " INI MISMATCH: Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini. Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		FileWriteLine($aLogFile, _NowCalc() & " INI MISMATCH: Parameters missing: " & $iIniError)
		SplashOff()
		MsgBox(4096, "INI MISMATCH", "Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini:" & @CRLF & " - " & $iIniError & @CRLF & "Backup created and all existing settings transfered to new INI." & @CRLF & @CRLF & "Please modify INI and restart.")
		Exit
	Else
		UpdateIni($sIniFile)
		SplashOff()
		MsgBox(4096, "Default INI File Created", "Please Modify Default Values and Restart Program." & @CRLF & @CRLF & "IF NEW DEDICATED SERVER INSTALL:" & @CRLF & " - Once the server is installed and running," & @CRLF & "Rt-Click on " & $aUtilName & " icon and shutdown server." & @CRLF & " - Then modify the server files and restart this utility.")
		FileWriteLine($aLogFile, _NowCalc() & " Default INI File Created . . Please Modify Default Values and Restart Program.")
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
	FileWriteLine($sIniFile, "( - !!! - Other server information imported from ServerGrid.json - !!! - )")
	FileWriteLine($sIniFile, "(If ServerGrid.json is not found, Atlas can still be downloaded and installed)")
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server name (for announcements and logs only) ###", $aServerName)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " DIR ###", $aServerDirLocal)
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Version (0-Stable,1-Experimental)", $aServerVer)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", $aGameName & " extra commandline parameters (ex.?serverpve-pve -serverpassword) ###", $aServerExtraCMD)
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server IP ###", $aServerIP)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server multi-home IP (Leave blank to disable) ###", $aServerMultiHomeIP)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD DIR ###", $aSteamCMDDir)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "SteamCMD extra commandline parameters (ex. -latest_experimental) ###", $aSteamExtraCMD)
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Gamesave directory name", $aServerSaveDir)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Admin password ###", $aServerAdminPass)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Max players ###", $aServerMaxPlayers)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Reserved slots ###", $aServerReservedSlots)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Import RCON ports from GameUserSettings.ini files? (yes/no) ###", $aServerRCONImport)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server RCON Port(s) (comma separated, grid order left-to-right, ignore if importing RCON ports) ###", $aServerRCONPort)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Server AltSaveDirectoryName(s) (comma separated. List same order as listed in ServerGrid.json. Leave blank for default a00,a01,a10, etc) ###", $aServerAltSaveDir)
	;MOD IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Use this util to install mods and check for mod updates (as listed in ServerGrid.json)? (yes/no) ###", $aServerModYN)
	;	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Mod number(s) (comma separated) ###", $aServerModList)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Autostart and keep-alive redis-server.exe? Use NO to manage redis-server.exe yourself (yes/no) ###", $aServerUseRedis)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Redis-server config file (must be in \AtlasTools\RedisDatabase dir) (Ignore if NO to autostart above) ###", $aServerRedisConfig)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Delay in seconds between grid server starts (1-60) ###", $aServerStartDelay)
	IniWrite($sIniFile, " --------------- GAME SERVER CONFIGURATION --------------- ", "Seconds allowed for GameSave before taskkilling servers during reboots (10-600) ###", $aShutDnWait)

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
	IniWrite($sIniFile, " --------------- CHECK FOR UPDATE --------------- ", "Check for updates? (yes/no) ###", $aCheckForUpdate)
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
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announce messages in-game? (Requires telnet) (yes/no) ###", $sInGameAnnounce)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement DAILY (\m - minutes) ###", $sInGameDailyMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $sInGameUpdateMessage)
	IniWrite($sIniFile, " --------------- IN-GAME ANNOUNCEMENT CONFIGURATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $sInGameRemoteRestartMessage)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for DAILY reboot? (yes/no) ###", $sUseDiscordBotDaily)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for UPDATE reboot? (yes/no) ###", $sUseDiscordBotUpdate)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for REMOTE RESTART reboot? (yes/no) ###", $sUseDiscordBotRemoteRestart)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Send Discord message for first announcement only? (reduces bot spam)(yes/no) ###", $sUseDiscordBotFirstAnnouncement)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $sDiscordDailyMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $sDiscordUpdateMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $sDiscordRemoteRestartMessage)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "WebHook URL ###", $sDiscordWebHookURLs)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Bot Name ###", $sDiscordBotName)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Use TTS? (yes/no) ###", $bDiscordBotUseTTS)
	IniWrite($sIniFile, " --------------- DISCORD INTEGRATION --------------- ", "Bot Avatar Link ###", $sDiscordBotAvatar)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for DAILY reboot? (yes/no) ###", $sUseTwitchBotDaily)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for UPDATE reboot? (yes/no) ###", $sUseTwitchBotUpdate)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for REMOTE RESTART reboot? (yes/no) ###", $sUseTwitchBotRemoteRestart)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Send Twitch message for first announcement only? (reduces bot spam)(yes/no) ###", $sUseTwitchFirstAnnouncement)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement DAILY (\m - minutes) ###", $sTwitchDailyMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement UPDATES (\m - minutes) ###", $sTwitchUpdateMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Announcement REMOTE RESTART (\m - minutes) ###", $sTwitchRemoteRestartMessage)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Nick ###", $sTwitchNick)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "ChatOAuth ###", $sChatOAuth)
	IniWrite($sIniFile, " --------------- TWITCH INTEGRATION --------------- ", "Channels ###", $sTwitchChannels)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Execute external script BEFORE update? (yes/no) ###", $aExecuteExternalScript)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Script directory ###", $aExternalScriptDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START --------------- ", "1-Script filename ###", $aExternalScriptName)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Execute external script AFTER update but BEFORE server start? (yes/no) ###", $aExternalScriptValidateYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Script directory ###", $aExternalScriptValidateDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START --------------- ", "2-Script filename ###", $aExternalScriptValidateName)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Execute external script for server update restarts? (yes/no) ###", $aExternalScriptUpdateYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Script directory ###", $aExternalScriptUpdateDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER *UPDATE* --------------- ", "3-Script filename ###", $aExternalScriptUpdateFileName)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Execute external script for daily server restarts? (yes/no) ###", $aExternalScriptDailyYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Script directory ###", $aExternalScriptDailyDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR *DAILY* SERVER RESTART --------------- ", "4-Script filename ###", $aExternalScriptDailyFileName)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Execute external script when first restart announcement is made? (yes/no) ###", $aExternalScriptAnnounceYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Script directory ###", $aExternalScriptAnnounceDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT WHEN FIRST RESTART ANNOUNCEMENT IS MADE --------------- ", "5-Script filename ###", $aExternalScriptAnnounceFileName)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Execute external script during restart when a remote restart request is made? (yes/no) ###", $aExternalScriptRemoteYN)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Script directory ###", $aExternalScriptRemoteDir)
	IniWrite($sIniFile, " --------------- EXECUTE EXTERNAL SCRIPT DURING RESTART WHEN REMOTE RESTART REQUEST IS MADE --------------- ", "6-Script filename ###", $aExternalScriptRemoteFileName)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Rotate log files? (yes/no) ###", $aLogRotate)
	IniWrite($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Number of logs ###", $aLogQuantity)
	IniWrite($sIniFile, " --------------- LOG FILE OPTIONS --------------- ", "Hours between log rotations ###", $aLogHoursBetweenRotate)
	FileWriteLine($sIniFile, @CRLF)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Validate files with SteamCMD update? (yes/no) ###", $aValidate)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable RCON? Required for clean shutdown (yes/no) ###", $aEnableRCON)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Delay between saveworld and quit commands during shutdown in seconds (5-120) ###", $aRCONSaveDelaySec)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "For update checks, use (0)SteamCMD or (1)SteamDB.com ###", $aUpdateSource)
	;	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Use puttytel for telnet client? (yes/no)", $aUsePuttytel)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide passwords in log files? (yes/no) ###", $sObfuscatePass)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Hide external scripts when executed? (if yes, scripts may not execute properly) (yes/no) ###", $aExternalScriptHideYN)
	IniWrite($sIniFile, " --------------- " & StringUpper($aUtilName) & " MISC OPTIONS --------------- ", "Enable debug to output more log detail? (yes/no) ###", $aDebug)

EndFunc   ;==>UpdateIni
#EndRegion ;**** INI Settings - User Variables ****

; -----------------------------------------------------------------------------------------------------------------------


#Region ; **** Gamercide Shutdown Protocol ****
Func Gamercide()
	If @exitMethod <> 1 Then
		$Shutdown = MsgBox(4100, "Shut Down?", "Do you wish to shutdown Server " & $aServerName & "?", 60)
		If $Shutdown = 6 Then
			FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & "] Server Shutdown - Initiated by User when closing " & $aUtilityVer & " Script")
			CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
		EndIf
		SplashOff()
		MsgBox(4096, $aUtilName, "Thank you for using " & $aUtilName & "." & @CRLF & "Please report any problems or comments to: " & @CRLF & "Discord: http://discord.gg/EU7pzPs or " & @CRLF & "Forum: http://phoenix125.createaforum.com/index.php. " & @CRLF & @CRLF & "Visit http://www.Phoenix125.com", 20)
		FileWriteLine($aLogFile, _NowCalc() & " " & $aUtilityVer & " Stopped by User")
	Else
		FileWriteLine($aLogFile, _NowCalc() & " " & $aUtilityVer & " Stopped")
	EndIf
	If $aRemoteRestartUse = "yes" Then
		TCPShutdown()
	EndIf
	SplashOff()
	Exit
EndFunc   ;==>Gamercide
#EndRegion ; **** Gamercide Shutdown Protocol ****

; -----------------------------------------------------------------------------------------------------------------------

Func CloseServer($ip, $port, $pass)
	SplashTextOn($aUtilName & ": " & $aServerName, "Sending shutdown command to server(s) . . .", 550, 75, -1, -1, $DLG_MOVEABLE, "")
	$aShutdown = 1
	$aFailCount = 0
	;	Local $aRCONSaveDelaySleep = $aRCONSaveDelaySec * 1000
	FileWriteLine($aLogFile, _NowCalc() & " --------- Server(s) shutdown sequence beginning ---------")
	;	SplashTextOn($aUtilName, "Server shutdown sequence beginning." & @CRLF & "Saving world(s) with " & $aRCONSaveDelaySec & " second delay before shutting down.", 500, 75, -1, -1, $DLG_MOVEABLE, "")
	;	SendRCON($aServerIP, $aServer00RCONPort, $aServerAdminPass, $aRCONSaveGameCMD)
	FileWriteLine($aLogFile, _NowCalc() & " Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . .")
	;	Sleep($aRCONSaveDelaySleep)
	For $i = 0 To ($aServerGridTotal - 1)
		If ($xStartGrid[$i] = "yes") Then
			SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aRCONShutdownCMD)
		EndIf
	Next
	;SendRCON($aServerIP, $aServer00RCONPort, $aServerAdminPass, $aRCONShutdownCMD)
	;	SplashTextOn($aUtilName & ": " & $aServerName, "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . .", 550, 75, -1, -1, $DLG_MOVEABLE, "")
	;	Sleep(10000)
	;	SplashOff()
	$aErrorShutdown = 0
	For $k = 1 To $aShutDnWait
		For $i = 0 To ($aServerGridTotal - 1)
			If ProcessExists($aServerPID[$i]) Then
				$aErrorShutdown = 1
				SendRCON($xServerIP[$i], $xServerRCONPort[$i + 1], $aServerAdminPass, $aRCONShutdownCMD)
			EndIf
		Next
		If $aErrorShutdown = 1 Then
			Sleep(950)
			SplashTextOn($aUtilName & ": " & $aServerName, "Waiting up to " & $aShutDnWait & " seconds for server(s) to finish saving world . . ." & @CRLF & @CRLF & "Countdown: " & ($aShutDnWait - $k), 550, 100, -1, -1, $DLG_MOVEABLE, "")
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
			FileWriteLine($aLogFile, _NowCalc() & " [Server (PID: " & $aServerPID[$i] & ")] Warning: Shutdown failed. Killing Process")
			ProcessClose($aServerPID[$i])
		EndIf
	Next
	If ($aErrorShutdown = 1) And ($aServerMultiHomeIP <> "") Then
		SplashOff()
		MsgBox($MB_OK, $aUtilName, "[Shutdown Error] The server(s) did not shut down properly." & @CRLF & "- Try removing the IP in: " & @CRLF & "[Server multi-home IP (Leave blank to disable) ###]" & @CRLF & "in " & $aUtilName & ".ini. " & @CRLF & @CRLF & "(This message will disappear in 20 seconds)", 20)
	EndIf
	;If ProcessExists($aServerPIDRedis) Then
	If ProcessExists($aServerPIDRedis) And $aServerUseRedis = "yes" Then
		FileWriteLine($aLogFile, _NowCalc() & " [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
		ProcessClose($aServerPIDRedis)
	EndIf

	;	If ProcessExists($aServerPIDRedis) Then
	;		FileWriteLine($aLogFile, _NowCalc() & " [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
	;		ProcessClose($aServerPIDRedis)
	;	EndIf
	FileWriteLine($aLogFile, _NowCalc() & " --------------- Server(s) shutdown sequence completed ----------")
	$aShutdown = 0
EndFunc   ;==>CloseServer

; -----------------------------------------------------------------------------------------------------------------------

#Region ;****  Get data from ServerGrid.json ****
Func ImportConfig($tServerDirLocal, $tConfigFile)
	Local Const $sConfigPath = $tServerDirLocal & "\ShooterGame\" & $tConfigFile
	FileWriteLine($aLogFile, _NowCalc() & " Importing settings from " & $sConfigPath)
	Global $xServergridx[100]
	Global $xServergridy[100]
	Global $xServerport[100]
	Global $xServergameport[100]
	;Global $xServerseamlessDataPort[100]
	Global $xServerIP[100]
	Local $sFileExists = FileExists($sConfigPath)
	If $sFileExists = 0 Then
		FileWriteLine($aLogFile, _NowCalc() & " !!! ERROR !!! Could not find " & $sConfigPath)
		SplashOff()
		$aContinue = MsgBox($MB_YESNO, $aConfigFile & " Not Found", "Could not find " & $sConfigPath & "." & @CRLF & "(This is normal for New Install) " & @CRLF & @CRLF & "Do you wish to continue with installation?", 60)
		If $aContinue = 7 Then
			FileWriteLine($aLogFile, _NowCalc() & " !!! ERROR !!! Could not find " & $sConfigPath & ". Program terminated by user.")
			Exit
		Else
			SplashTextOn($aUtilName, "Using temporary settings to complete the download and installation of " & $aGameName & " dedicated server." & @CRLF & @CRLF & "Once installation is complete, please exit " & $aUtilName & ", copy your files into the server folder, and rerun " & $aUtilName & ".", 500, 175, -1, -1, $DLG_MOVEABLE, "")
			Global $aServerWorldFriendlyName = "TempXY"
			$xServerIP[0] = "127.0.0.1"
			$xServergridx[0] = "0"
			$xServergridy[0] = "0"
			$xServerport[0] = "48011"
			$xServergameport[0] = "48015"
			;		$xServerseamlessDataPort[0] = "48018"
			$xtotalGridsX = 1
			$xtotalGridsY = 1

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

		;Local $kServerseamlessDataPort = "seamlessDataPort"
		Local $sConfigPathOpen = FileOpen($sConfigPath, 0)
		Local $sConfigRead = FileRead($sConfigPathOpen)
		Local $sConfigReadServer = _ArrayToString(_StringBetween($sConfigRead, """servers"": [", "    }" & @CRLF & "  ],"))
		;Local $sConfigRead3 = StringRegExpReplace($sConfigRead4, """", "}")
		;Local $sConfigRead2 = StringRegExpReplace($sConfigRead3, "\t", "")
		;Local $sConfigRead1 = StringRegExpReplace($sConfigRead2, "  ", "")
		;Local $sConfigRead = StringRegExpReplace($sConfigRead1, " value=", "value=")

		; Items with Quotes
		Global $aServerModList = _StringBetween($sConfigRead, """" & $kServerModList & """: """, """,")
		Local $xServerWorldFriendlyName = _StringBetween($sConfigRead, """" & $kServerWorldFriendlyName & """: """, """,")
		$aServerWorldFriendlyName = _ArrayToString($xServerWorldFriendlyName)
		$xServerIP = _StringBetween($sConfigReadServer, """" & $kServerip & """: """, """,")
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
	;MOD	If $aServerModList = "" Then
	;		$aServerModYN = "no"
	;	Else
	;		$xServerModList = StringSplit($aServerModList, ",")
	;	EndIf
	Global $aServerGridTotal = Int($xtotalGridsX) * Int($xtotalGridsY)

EndFunc   ;==>ImportConfig
#EndRegion ;****  Get data from ServerGrid.json ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;****  Get data from GameUserSettings.ini ****
Func ImportRCON($zServerDirLocal, $zServerAltSaveDir, $zServerGridTotal, $zStartGrid)
	Local $tFilePath[$zServerGridTotal + 1]
	Global $hRCON[$zServerGridTotal + 1]
	$hRCON[0] = $zServerGridTotal
	FileWriteLine($aLogFile, _NowCalc() & " Importing RCON ports from GameUserSettings.ini files")
	For $i = 1 To ($zServerGridTotal)
		;	FileWriteLine($aLogFile, _NowCalc() & " Import grid " & $i & "? " & $zStartGrid[$i - 1]) ;KIM!!!
		If ($zStartGrid[$i - 1] = "yes") Then
			$tFilePath[$i] = $zServerDirLocal & "\ShooterGame\Saved\" & $zServerAltSaveDir[$i - 1] & "\Config\WindowsServer\GameUserSettings.ini"
			Local $sFileExists = FileExists($tFilePath[$i])
			If ($sFileExists = 0) And ($aServerWorldFriendlyName <> "TempXY") Then
				Local $aErrorMsg = "!!! ERROR !!! Could not find " & $tFilePath[$i] & "."
				FileWriteLine($aLogFile, _NowCalc() & $aErrorMsg)
				SplashOff()
				MsgBox($MB_OK, $aUtilName, $aErrorMsg & @CRLF & "Please ensure your AltSaveFolders is correct in " & $aUtilName & ".ini and restart " & $aUtilName & ".")
				;$hRCON[0] = False
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
						FileWriteLine($aLogFile, _NowCalc() & $aErrorMsg)
						SplashOff()
						MsgBox($MB_OK, $aUtilName, $aErrorMsg & @CRLF & "Please add RCONEnabled=True and RCONPort=[port] to GameUserSettings.ini" & @CRLF & "OR add RCON ports to " & $aUtilName & ".ini and restart " & $aUtilName & ".")
						;$hRCON[0] = False
						Exit
					EndIf
					If $xDebug Then
						FileWriteLine($aLogFile, _NowCalc() & " Server: " & $i & " , RCON Port:" & $hRCON[$i])
					EndIf
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
		$xStartGrid[$i] = IniRead($sGridFile, " --------------- RUN THE FOLLOWING GRID SERVER(S) (yes/no) --------------- ", "Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ")", $iniCheck)
		If $iniCheck = $xStartGrid[$i] Then
			$xStartGrid[$i] = "yes"
			$iIniFail += 1
			;		$iIniError = $iIniError & $xStartGrid[$i] & ", "
		EndIf
	Next
	If $iIniFail > 0 Then
		GridFileCheck($sGridFile, $iIniFail)
	EndIf
EndFunc   ;==>GridStartSelect

Func GridFileCheck($sGridFile, $iIniFail)
	If FileExists($sGridFile) Then
		Local $aMyDate, $aMyTime
		_DateTimeSplit(_NowCalc(), $aMyDate, $aMyTime)
		Local $iniDate = StringFormat("%04i.%02i.%02i.%02i%02i", $aMyDate[1], $aMyDate[2], $aMyDate[3], $aMyTime[1], $aMyTime[2])
		FileMove($sGridFile, $sGridFile & "_" & $iniDate & ".bak", 1)
		UpdateGrid($sGridFile)
		FileWriteLine($aLogFile, _NowCalc() & " " & $sGridFile & " needs updating. Found " & $iIniFail & " server change(s). Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		;		FileWriteLine($aLogFile, _NowCalc() & " " & $sGridFile & " needs updating. Parameters missing: " & $iIniError)
		SplashOff()
		MsgBox(4096, $aUtilName, " " & $sGridFile & " needs updating. Found " & $iIniFail & " server change(s). " & @CRLF & "Backup created and all existing settings transfered to new INI." & @CRLF & @CRLF & "Please modify INI and restart.")
		Exit
	Else
		UpdateGrid($sGridFile)
		SplashOff()
		MsgBox(4096, $aUtilName, "Default " & $sGridFile & " file created." & @CRLF & @CRLF & "If you plan to run all grid server(s), no change is needed. " & @CRLF & @CRLF & "If you want to only run selected grid server(s), please modify the default values and restart program.")
		FileWriteLine($aLogFile, _NowCalc() & " Default " & $sGridFile & " file created. If you want to only run selected grid server(s), please modify the default values and restart program.")
		Exit
	EndIf
EndFunc   ;==>GridFileCheck

Func UpdateGrid($sGridFile)
	;	FileWriteLine($sIniFile, "[ --------------- " & StringUpper($aUtilName) & " INFORMATION --------------- ]")
	For $i = 0 To ($aServerGridTotal - 1)
		IniWrite($sGridFile, " --------------- RUN THE FOLLOWING GRID SERVER(S) (yes/no) --------------- ", "Server (" & $xServergridx[$i] & "," & $xServergridy[$i] & ")", $xStartGrid[$i])
	Next
EndFunc   ;==>UpdateGrid
#EndRegion ;**** Start Server Selection ****


; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Fail Count Announce ****
Func FailCountRun()
	FileWriteLine($aLogFile, _NowCalc() & " [--== CRITICAL ERROR! ==-- ] The " & $aGameName & " Dedicated Server (" & $aServerEXE & ") failed to start at least twice within 1 minute. Please check " & $aGameName & " config files and " & $aUtilName & ".ini file")
	CloseServer($aServerIP, $aTelnetPort, $aTelnetPass)
	MsgBox($MB_OK, $aUtilName, "[CRITICAL ERROR!] The " & $aGameName & " Dedicated Server (" & $aServerEXE & ") failed to start at least twice within 1 minute. " & @CRLF & @CRLF & "Please check " & $aGameName & " config files and " & $aUtilName & ".ini file and restart " & $aUtilName & ".")
	Exit
EndFunc   ;==>FailCountRun
#EndRegion ;**** Fail Count Announce ****

#Region ;**** Function to Send Message to Discord ****
Func _Discord_ErrFunc($oError)
	;	FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & " (PID: " & $aServerPID & ")] Error: 0x" & Hex($oError.number) & " While Sending Discord Bot Message.")
	FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & " Error: 0x" & Hex($oError.number) & " While Sending Discord Bot Message.")
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
EndFunc   ;==>SendDiscordMsg
#EndRegion ;**** Function to Send Message to Discord ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Send In-Game Message via MCRCON ****
Func SendInGame($mIP, $mPort, $mPass, $mMessage)

	For $i = 0 To ($aServerGridTotal - 1)
		Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $xServerIP[$i] & ' -P ' & $xServerRCONPort[$i + 1] & ' -p ' & $mPass & " """ & $aRCONBroadcastCMD & " " & $mMessage & """"
		If $xDebug Then
			FileWriteLine($aLogFile, _NowCalc() & " [RCON In-Game Message] " & $aMCRCONcmd)
		EndIf
		;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
		Run($aMCRCONcmd, @ScriptDir, @SW_HIDE)
	Next

	If $xDebug Then
	Else
		FileWriteLine($aLogFile, _NowCalc() & " [RCON In-Game Message Sent] " & $mMessage)
	EndIf


	;	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & " """ & $aRCONBroadcastCMD & " " & $mMessage & """"
	;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)


	;	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $aServerIP & ' -P ' & $aServer00RCONPort & ' -p ' & $mPass & " """ & $aRCONBroadcastCMD & " " & $mMessage & """"
	;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
	;	If $xDebug Then
	;		FileWriteLine($aLogFile, _NowCalc() & " [RCON In-Game Message] " & $aMCRCONcmd)
	;	Else
	;		FileWriteLine($aLogFile, _NowCalc() & " [RCON In-Game Message Sent] " & $mMessage)
	;	EndIf
EndFunc   ;==>SendInGame
#EndRegion ;**** Send In-Game Message via MCRCON ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Send RCON Command via MCRCON ****
Func SendRCON($mIP, $mPort, $mPass, $mCommand)
	;	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $aServerIP & ' -P ' & $aServer00RCONPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	;RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
	;For $i = 0 to ($aServerGridTotal - 1)
	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
	Run($aMCRCONcmd, @ScriptDir, @SW_HIDE)
	If $aErrorShutdown = 0 Then
		If $xDebug Then
			FileWriteLine($aLogFile, _NowCalc() & " [RCON] " & $aMCRCONcmd)
		Else
			FileWriteLine($aLogFile, _NowCalc() & " [RCON] Port:" & $mIP & ". Command:" & $mCommand)
		EndIf
	EndIf

	;	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
	;	If $xDebug Then
	;		FileWriteLine($aLogFile, _NowCalc() & " [RCON] " & $aMCRCONcmd)
	;	Else
	;		FileWriteLine($aLogFile, _NowCalc() & " [RCON] Port:" & $mPort & ". Command:" & $mCommand)
	;	EndIf
	;	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
EndFunc   ;==>SendRCON
#EndRegion ;**** Send RCON Command via MCRCON ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Functions to Check for Update ****

Func UpdateCheck()
	Local $bUpdateRequired = False
	If $aUpdateSource = "1" Then
		If $aFirstBoot Then
			SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Acquiring latest buildid from SteamDB.", 400, 100, -1, -1, $DLG_MOVEABLE, "")
		EndIf
		Local $aLatestVersion = GetLatestVerSteamDB($aSteamAppID, $aServerVer)
	Else
		If $aFirstBoot Then
			SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Acquiring latest buildid from SteamCMD.", 400, 100, -1, -1, $DLG_MOVEABLE, "")
		EndIf
		Local $aLatestVersion = GetLatestVersion($aSteamCMDDir)
	EndIf
	If $aFirstBoot Then
		SplashTextOn($aUtilName, $aUtilName & " started." & @CRLF & @CRLF & "Retrieving installed version buildid.", 400, 100, -1, -1, $DLG_MOVEABLE, "")
	EndIf
	Local $aInstalledVersion = GetInstalledVersion($aServerDirFull)
	SplashOff()
	If ($aLatestVersion[0] And $aInstalledVersion[0]) Then
		If StringCompare($aLatestVersion[1], $aInstalledVersion[1]) = 0 Then
			FileWriteLine($aLogFile, _NowCalc() & " Server is Up to Date. Installed Version: " & $aInstalledVersion[1])
		Else
			FileWriteLine($aLogFile, _NowCalc() & " Server is Out of Date! Installed Version: " & $aInstalledVersion[1] & " Latest Version: " & $aLatestVersion[1])
			Global $aUpdateVerify = "yes"
			RunExternalScriptUpdate()
			$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
			Local $sManifestExists = FileExists($aSteamAppFile)
			If $sManifestExists = 1 Then
				FileMove($aSteamAppFile, $aServerDirLocal & "\steamapps\appmanifest_" & $aSteamAppID & "_" & $TimeStamp & ".acf", 1)
				If $xDebug Then
					FileWriteLine($aLogFile, _NowCalc() & " Notice: """ & $aSteamAppFile & """ renamed to ""appmanifest_" & $aSteamAppID & "_" & $TimeStamp & ".acf""")
				EndIf
			EndIf
		EndIf
	ElseIf Not $aLatestVersion[0] And Not $aInstalledVersion[0] Then
		FileWriteLine($aLogFile, _NowCalc() & " Something went wrong retrieving Latest & Installed Versions. Running update with -validate")
		SplashTextOn($aUtilName, "Something went wrong retrieving Latest & Installed Versions." & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 500, 125, -1, -1, $DLG_MOVEABLE, "")
		$bUpdateRequired = True
	ElseIf Not $aInstalledVersion[0] Then
		FileWriteLine($aLogFile, _NowCalc() & " Something went wrong retrieving Installed Version. Running update with -validate. (This is normal for new install)")
		SplashTextOn($aUtilName, "Something went wrong retrieving Installed Version." & @CRLF & "(This is normal for new install)" & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 450, 175, -1, -1, $DLG_MOVEABLE, "")
		$bUpdateRequired = True
	ElseIf Not $aLatestVersion[0] Then
		FileWriteLine($aLogFile, _NowCalc() & " Something went wrong retrieving Latest Version. Running update with -validate")
		SplashTextOn($aUtilName, "Something went wrong retrieving Latest Version." & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 450, 125, -1, -1, $DLG_MOVEABLE, "") 5
		$bUpdateRequired = True
	EndIf
	Return $bUpdateRequired
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
	FileWrite(@ScriptDir & "\SteamDB.tmp", $aSteamDB)

	Local Const $sFilePath = @ScriptDir & "\SteamDB.tmp"
	Local $hFileOpen = FileOpen($sFilePath, 0)
	Local $hFileRead1 = FileRead($hFileOpen)
	If $hFileOpen = -1 Then
		$aReturn[0] = False
	Else
		Local $hBuildID = _ArrayToString(_StringBetween($hFileRead1, "buildid:</i> <b>", "</b></li><li><i>timeupdated"))
		FileWriteLine($aLogFile, _NowCalc() & " [Update Check] Using SteamDB " & $aBranch & " branch. Latest version: " & $hBuildID)
	EndIf
	FileClose($hFileOpen)
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
	EndIf
	$aReturn[0] = True
	$aReturn[1] = $hBuildID
	Return $aReturn
	If $hBuildID < 100000 Then
		MsgBox($mb_ok, "ERROR", "Error retrieving buildid via SteamDB website. THIS IS NORMAL for first run. Please visit " & $aURL & " in Internet Explorer to authorize your PC or use SteamCMD for updates." & @CRLF & "! Press OK to close " & $aUtilName & " !")
	EndIf
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
		$aReturn[0] = False
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
			If $xDebug And $aServerVer = 0 Then
				FileWriteLine($aLogFile, _NowCalc() & " Update Check via Stable Branch. Latest version: " & $hBuildID)
			EndIf
			If $xDebug And $aServerVer = 1 Then
				FileWriteLine($aLogFile, _NowCalc() & " Update Check via Experimental Branch. Latest version: " & $hBuildID)
			EndIf
			FileClose($hFileOpen)
			If FileExists($sFilePath) Then
				FileDelete($sFilePath)
			EndIf
		Else
			$aReturn[0] = False
			FileWriteLine($aLogFile, _NowCalc() & " [Update Check] SteamCMD update check returned a FAILURE. Skipping this update check.")
			FileClose($hFileOpen)
		EndIf
	EndIf
	$aReturn[0] = True
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

Func RunExternalScriptDaily()
	If $aExternalScriptDailyYN = "yes" Then
		FileWriteLine($aLogFile, _NowCalc() & " Executing DAILY restart external script " & $aExternalScriptDailyDir & "\" & $aExternalScriptDailyFileName)
		If $aExternalScriptHideYN = "yes" Then
			Run($aExternalScriptDailyDir & '\' & $aExternalScriptDailyFileName, $aExternalScriptDailyDir, @SW_HIDE)
		Else
			Run($aExternalScriptDailyDir & '\' & $aExternalScriptDailyFileName, $aExternalScriptDailyDir)
		EndIf
		;					FileWriteLine($aLogFile, _NowCalc() & " External DAILY restart script finished. Continuing server start.")
	EndIf
EndFunc   ;==>RunExternalScriptDaily

Func RunExternalScriptAnnounce()
	If $aExternalScriptAnnounceYN = "yes" Then
		FileWriteLine($aLogFile, _NowCalc() & " Executing FIRST ANNOUNCEMENT external script " & $aExternalScriptAnnounceDir & "\" & $aExternalScriptAnnounceFileName)
		If $aExternalScriptHideYN = "yes" Then
			Run($aExternalScriptAnnounceDir & '\' & $aExternalScriptAnnounceFileName, $aExternalScriptAnnounceDir, @SW_HIDE)
		Else
			Run($aExternalScriptAnnounceDir & '\' & $aExternalScriptAnnounceFileName, $aExternalScriptAnnounceDir)
		EndIf
		;					FileWriteLine($aLogFile, _NowCalc() & " External DAILY restart script finished. Continuing server start.")
	EndIf
EndFunc   ;==>RunExternalScriptAnnounce

Func RunExternalRemoteRestart()
	If $aExternalScriptRemoteYN = "yes" Then
		FileWriteLine($aLogFile, _NowCalc() & " Executing REMOTE RESTART external script " & $aExternalScriptRemoteDir & "\" & $aExternalScriptRemoteFileName)
		If $aExternalScriptHideYN = "yes" Then
			Run($aExternalScriptRemoteDir & '\' & $aExternalScriptRemoteFileName, $aExternalScriptRemoteDir, @SW_HIDE)
		Else
			Run($aExternalScriptRemoteDir & '\' & $aExternalScriptRemoteFileName, $aExternalScriptRemoteDir)
		EndIf
		;					FileWriteLine($aLogFile, _NowCalc() & " External REMOTE RESTART script finished. Continuing server start.")
	EndIf
EndFunc   ;==>RunExternalRemoteRestart

Func RunExternalScriptUpdate()
	If $aExternalScriptUpdateYN = "yes" Then
		FileWriteLine($aLogFile, _NowCalc() & " Executing Script When Restarting For Server Update: " & $aExternalScriptUpdateDir & "\" & $aExternalScriptUpdateFileName)
		If $aExternalScriptHideYN = "yes" Then
			Run($aExternalScriptUpdateDir & '\' & $aExternalScriptUpdateFileName, $aExternalScriptUpdateDir, @SW_HIDE)
		Else
			Run($aExternalScriptUpdateDir & '\' & $aExternalScriptUpdateFileName, $aExternalScriptUpdateDir)
		EndIf
		;					FileWriteLine($aLogFile, _NowCalc() & " Executing Script When Restarting For Server Update Finished. Continuing Server Start.")
	EndIf
EndFunc   ;==>RunExternalScriptUpdate

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
				FileWriteLine($aLogFile, _NowCalc() & " External BEFORE update script execution disabled - Could not find " & $aExternalScriptDir & "\" & $aExternalScriptName)
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
				FileWriteLine($aLogFile, _NowCalc() & " External AFTER update script execution disabled - Could not find " & $aExternalScriptValidateDir & "\" & $aExternalScriptValidateName)
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
				FileWriteLine($aLogFile, _NowCalc() & " External DAILY restart script execution disabled - Could not find " & $aExternalScriptDailyDir & "\" & $aExternalScriptDailyFileName)
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
				FileWriteLine($aLogFile, _NowCalc() & " External UPDATE restart script execution disabled - Could not find " & $aExternalScriptUpdateDir & "\" & $aExternalScriptUpdateFileName)
			EndIf
		EndIf
	EndIf
	If $aExternalScriptAnnounceYN = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptAnnounceDir & "\" & $aExternalScriptAnnounceFileName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External DAILY restart script not found", "Could not find " & $aExternalScriptAnnounceDir & "\" & $aExternalScriptAnnounceFileName & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExternalScriptDailyYN = "no"
				FileWriteLine($aLogFile, _NowCalc() & " External DAILY restart script execution disabled - Could not find " & $aExternalScriptAnnounceDir & "\" & $aExternalScriptAnnounceFileName)
			EndIf
		EndIf
	EndIf
	If $aExternalScriptRemoteYN = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptRemoteDir & "\" & $aExternalScriptRemoteFileName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External DAILY restart script not found", "Could not find " & $aExternalScriptRemoteDir & "\" & $aExternalScriptRemoteFileName & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExternalScriptDailyYN = "no"
				FileWriteLine($aLogFile, _NowCalc() & " External DAILY restart script execution disabled - Could not find " & $aExternalScriptRemoteDir & "\" & $aExternalScriptRemoteFileName)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>ExternalScriptExist

#Region ;**** Adjust restart time for announcement delay ****
Func DailyRestartOffset($bHour0, $sMin, $sTime)
	If $bRestartMin - $sTime < 0 Then
		Local $bHour1 = -1
		Local $bHour2 = ""
		Local $bHour3 = StringSplit($bHour0, ",")
		For $bRestartHours = 1 To $bHour3[0]
			$bHour1 = StringStripWS($bHour3[$bRestartHours], 8) - 1
			If Int($bHour1) = -1 Then
				$bHour1 = 23
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

#Region ;**** Remove invalid characters ****
Func RemoveInvalidCharacters($aString)
	Local $bString = StringRegExpReplace($aString, "[\x3D\x22\x3B\x3C\x3E\x3F\x25\x27\x7C]", "")
	If $aString = $bString Then
	Else
		FileWriteLine($aLogFile, _NowCalc() & " [ERROR] Invalid character found in " & $aIniFile & ". Changed parameter from """ & $aString & """ to """ & $bString & """.")
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
	$aPassFailure[(UBound($aPassFailure, 1) - 1)][2] = _NowCalc
	Return SetError(0, 0, "IP Added to List")
EndFunc   ;==>MultipleAttempts
#EndRegion ;**** Function to Check for Multiple Password Failures****

#Region ;**** Uses other Functions to check connection, verify request is valid, verify restart code is correct, gather IP, and send proper message back to User depending on request received****
Func _RemoteRestart($vMSocket, $sCodes, $sKey, $sHideCodes, $sServIP, $sName, $bDebug)
	Local $vConnectedSocket = TCPAccept($vMSocket)
	If $vConnectedSocket >= 0 Then
		Local $sRecvIP = _TCP_Server_ClientIP($vConnectedSocket)
		Local $sRECV = TCPRecv($vConnectedSocket, 512)
		Local $iError = 0
		Local $iExtended = 0
		If @error = 0 Then
			Local $sRecvPass = CheckHTTPReq($sRECV, $sKey)
			If @error = 0 Then
				Local $sCheckMaxAttempts = MultipleAttempts($sRecvIP)
				If @error = 1 Then
					TCPSend($vConnectedSocket, "HTTP/1.1 429 Too Many Requests" & @CRLF & "Retry-After: 600" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
					TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>" & $sName & " Remote Restart</title></head><body><h1>429 Too Many Requests</h1><p>You tried to Restart " & $sName & " 15 times in a row.<BR>" & $sCheckMaxAttempts & "</body></html>")
					If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
					Return SetError(1, 0, "Restart ATTEMPT by Remote Host: " & $sRecvIP & " | Wrong Code was entered 15 times. User must wait 10 minutes before trying again.")
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
					Return SetError(0, 0, "Restart Requested by Remote Host: " & $sRecvIP & " | User: " & $aPassCompare[1] & " | Pass: " & $aPassCompare[2])
				Else
					TCPSend($vConnectedSocket, "HTTP/1.1 403 Forbidden" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
					TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>" & $sName & " Remote Restart</title></head><body><h1>403 Forbidden</h1><p>You are not allowed to restart " & $sName & ".<BR> Attempt from <b>" & $sRecvIP & "</b> has been logged.</body></html>")
					If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
					$sCheckMaxAttempts = MultipleAttempts($sRecvIP, True, False)
					Return SetError(1, 0, "Restart ATTEMPT by Remote Host: " & $sRecvIP & " | Unknown Restart Code: " & $sRecvPass)
				EndIf
			Else
				$iError = @error
				$iExtended = @extended
				TCPSend($vConnectedSocket, "HTTP/1.1 404 Not Found" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
				TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>404 Not Found</title></head><body><h1>404 Not Found.</h1></body></html>")
				If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
				If $iError = 1 Then
					If Not $bDebug Then
						$sRECV = "Enable Debug to Log Full TCP Request"
					Else
						$sRECV = "Full TCP Request: " & @CRLF & $sRECV
					EndIf
					Return SetError(2, 0, "Invalid Restart Request by: " & $sRecvIP & ". Should be in the format of GET /?" & $sKey & "=user_pass HTTP/x.x | " & $sRECV)
				Else
					;This Shouldn't Happen
					Return SetError(3, 0, "CheckHTTPReq Failed with Error: " & $iError & " Extended: " & $iExtended & " [" & $sRecvPass & "]")
				EndIf
			EndIf
		Else
			$iError = @error
			$iExtended = @extended
			TCPSend($vConnectedSocket, "HTTP/1.1 400 Bad Request" & @CRLF & "Connection: close" & @CRLF & "Content-Type: text/html; charset=iso-8859-1" & @CRLF & "Cache-Control: no-cache" & @CRLF & "Server: " & $sServIP & @CRLF & @CRLF)
			TCPSend($vConnectedSocket, "<!DOCTYPE HTML><html><head><link rel='icon' href='data:;base64,iVBORw0KGgo='><title>400 Bad Request</title></head><body><h1>400 Bad Request.</h1></body></html>")
			If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
			Return SetError(4, 0, "TCPRecv Failed to Complete with Error: " & $iError & " Extended: " & $iExtended)
		EndIf
	EndIf
	Return SetError(-1, 0, "No Connection")
	If $vConnectedSocket <> -1 Then TCPCloseSocket($vConnectedSocket)
EndFunc   ;==>_RemoteRestart
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
	DirRemove($sCmdDir & "\package", 1)
	DirRemove($sCmdDir & "\steamapps", 1)
	;		InetGet("https://steamcdn-a.akamaihd.net/client/installer/steamcmd.zip", @ScriptDir & "\steamcmd.zip", 0)
	;		DirCreate($bSteamCMDDir) ; to extract to
	;		_ExtractZip(@ScriptDir & "\steamcmd.zip", "", "steamcmd.exe", $bSteamCMDDir)
	;		FileDelete(@ScriptDir & "\steamcmd.zip")
	;		FileWriteLine($aLogFile, _NowCalc() & " Running SteamCMD. [steamcmd.exe +quit]")
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
		FileWriteLine($aLogFile, _NowCalc() & " Running SteamCMD. [steamcmd.exe +quit]")
		RunWait("" & $aSteamCMDDir & "\steamcmd.exe +quit", @SW_MINIMIZE)
		If Not FileExists($aSteamCMDDir & "\steamcmd.exe") Then
			MsgBox(0x0, "SteamCMD Not Found", "Could not find steamcmd.exe at " & $aSteamCMDDir)
			Exit
		EndIf
	EndIf

	If ($sInGameAnnounce = "yes") Then
		Local $sFileExists = FileExists(@ScriptDir & "\mcrcon.exe")
		If $sFileExists = 0 Then
			FileWriteLine($aLogFile, _NowCalc() & " Downloaded and installed mcrcon.exe")
			InetGet("https://github.com/Tiiffi/mcrcon/releases/download/v0.0.5/mcrcon-0.0.5-windows.zip", @ScriptDir & "\mcrcon.zip", 0)
			DirCreate(@ScriptDir) ; to extract to
			_ExtractZip(@ScriptDir & "\mcrcon.zip", "", "mcrcon.exe", @ScriptDir)
			FileDelete(@ScriptDir & "\mcrcon.zip")
			If Not FileExists(@ScriptDir & "\mcrcon.exe") Then
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
Func UpdateMods()
	$xServerModList
	$aSteamCMDDir
	$aServerModDIR = $aServerDirLocal & "\ShooterGame\Content\Mods\"
	$aServerModAppworkshopSource = $aSteamCMDDir & "\steamapps\workshop\"
	$aServerModAppworkshopDest = $aServerDirLocal & "\steamapps\workshop\"
	Atlas_Mod_Downloader.exe








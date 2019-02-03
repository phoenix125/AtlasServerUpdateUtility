#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=Resources\phoenix_5Vq_icon.ico
#AutoIt3Wrapper_Outfile=Builds\AtlasServerUpdateUtility_beta.Exe
#AutoIt3Wrapper_Res_Comment=By Phoenix125 based on Dateranoth's 7dServerUtility v3.3.0-Beta.3
#AutoIt3Wrapper_Res_Description=Atlas Dedicated Server Update Utility (b23)
#AutoIt3Wrapper_Res_Fileversion=v0.0.1
#AutoIt3Wrapper_Res_ProductName=AtlasServerUpdateUtility
#AutoIt3Wrapper_Res_ProductVersion=v0.0.1
#AutoIt3Wrapper_Res_CompanyName=http://www.Phoenix125.com
#AutoIt3Wrapper_Res_LegalCopyright=http://www.Phoenix125.com
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
$aUtilVersion = "v0.1" ; (2019-01-26)
$aUtilName = "AtlasServerUpdateUtility"
$aGameName = "Atlas"
$aServerEXE = "ShooterGameServer.exe"
$aExperimentalString = "latest_experimental"
$aServerVer = 0
Global $aSteamAppID = "1006030"
Global $aSteamDBURLPublic = "https://steamdb.info/app/" & $aSteamAppID & "/depots/?branch=public"
Global $aSteamDBURLExperimental = "https://steamdb.info/app/" & $aSteamAppID & "/depots/?branch=public"

;Atlas Only
$aServerRedisCmd = "redis-server.exe"
$aServerRedisDir = "\AtlasTools\RedisDatabase"
$aServerPIDRedis = "0"
$aServerPID00 = "0"
$aServerPID10 = "0"
$aServerPID01 = "0"
$aServerPID11 = "0"
$aServer00RCONPort = "0"
$aServer10RCONPort = "0"
$aServer01RCONPort = "0"
$aServer11RCONPort = "0"
$aTelnetCMD00 = ""
$aTelnetCMD01 = ""
$aTelnetCMD10 = ""
$aTelnetCMD11 = ""
$aServerMultiHomeIP = "192.168.1.15"
$aRCONSaveGameCMD = "cheat saveworld"
$aRCONShutdownCMD = "cheat quit"
$aShutdown = 0

$aUsePuttytel = "yes"
$aTelnetCheck = "no"
$aTelnetCheckSec = "300"
$aTelnetPort = "27520"
$aTelnetPass = "TeLneT_PaSsWoRd"
$aServerVer = "0"


#Region ;**** Global Variables ****
Global Const $aIniFile = @ScriptDir & "\" & $aUtilName & ".ini"
Global Const $aUtilityVer = $aUtilName & " " & $aUtilVersion
Global Const $aLogFile = @ScriptDir & "\" & $aUtilName & ".log"
Global $aTimeCheck0 = _NowCalc()
Global $aTimeCheck1 = _NowCalc()
Global $aTimeCheck2 = _NowCalc()
Global $aTimeCheck3 = _NowCalc()
Global $aTimeCheck4 = _NowCalc()
$aBeginDelayedShutdown = 0
$aUpdateVerify = "no"

#EndRegion ;**** Global Variables ****

; -----------------------------------------------------------------------------------------------------------------------
#Region ;**** Startup Checks. Initial Log, Read INI, Check for Correct Paths, Check Remote Restart is bound to port. ****
OnAutoItExitRegister("Gamercide")
SplashTextOn($aUtilName, $aUtilName & " started.", 400, 50, -1, -1, $DLG_MOVEABLE, "")
FileWriteLine($aLogFile, _NowCalc() & " ============================ " & $aUtilName & " " & $aUtilVersion & " Started ============================")
ReadUini($aIniFile, $aLogFile)

; Atlas
$aTelnetPass = $aServerAdminPass

If ($sInGameAnnounce = "yes") Or ($aTelnetCheck = "yes") Or ($aEnableRCON = "yes") Then
	$aTelnetCMD00 = "?RCONEnabled=True?RCONPort=" & $aServer00RCONPort
	$aTelnetCMD10 = "?RCONEnabled=True?RCONPort=" & $aServer10RCONPort
	$aTelnetCMD01 = "?RCONEnabled=True?RCONPort=" & $aServer01RCONPort
	$aTelnetCMD11 = "?RCONEnabled=True?RCONPort=" & $aServer11RCONPort
EndIf
If Not $aServerMultiHomeIP = "" Then
	$aServerMultiHomeFull = "?MultiHome=" & $aServerMultiHomeIP
Else
$aServerMultiHomeFull = ""
EndIf
$aServerDirFull = $aServerDirLocal & "\ShooterGame\Binaries\Win64"
$xServerRedis = """" & $aServerDirLocal & $aServerRedisDir & "\" & $aServerRedisCmd & """ """ & $aServerDirLocal & $aServerRedisDir & "\redis.conf"""
$xServer00 = """" & $aServerDirFull & "\" & $aServerEXE & """ Ocean?ServerX=0?ServerY=0?AltSaveDirectoryName=" & $aServer00Folder & "?ServerAdminPassword=" & $aServerAdminPass & "?MaxPlayers=" & $aServerMaxPlayers & "?ReservedPlayerSlots=" & $aServerReservedSlots & "?QueryPort=" & $aServer00QueryPort & "?Port=" & $aServer00Port & "?SeamlessIP=" & $aServerIP & $aServerMultiHomeFull & $aTelnetCMD00 & " " & $aServerExtraCMD & " """
$xServer10 = """" & $aServerDirFull & "\" & $aServerEXE & """ Ocean?ServerX=1?ServerY=0?AltSaveDirectoryName=" & $aServer10Folder & "?ServerAdminPassword=" & $aServerAdminPass & "?MaxPlayers=" & $aServerMaxPlayers & "?ReservedPlayerSlots=" & $aServerReservedSlots & "?QueryPort=" & $aServer10QueryPort & "?Port=" & $aServer10Port & "?SeamlessIP=" & $aServerIP & $aServerMultiHomeFull & $aTelnetCMD10 & " " & $aServerExtraCMD & " """
$xServer01 = """" & $aServerDirFull & "\" & $aServerEXE & """ Ocean?ServerX=0?ServerY=1?AltSaveDirectoryName=" & $aServer01Folder & "?ServerAdminPassword=" & $aServerAdminPass & "?MaxPlayers=" & $aServerMaxPlayers & "?ReservedPlayerSlots=" & $aServerReservedSlots & "?QueryPort=" & $aServer01QueryPort & "?Port=" & $aServer01Port & "?SeamlessIP=" & $aServerIP & $aServerMultiHomeFull & $aTelnetCMD01 & " " & $aServerExtraCMD & " """
$xServer11 = """" & $aServerDirFull & "\" & $aServerEXE & """ Ocean?ServerX=1?ServerY=1?AltSaveDirectoryName=" & $aServer11Folder & "?ServerAdminPassword=" & $aServerAdminPass & "?MaxPlayers=" & $aServerMaxPlayers & "?ReservedPlayerSlots=" & $aServerReservedSlots & "?QueryPort=" & $aServer11QueryPort & "?Port=" & $aServer11Port & "?SeamlessIP=" & $aServerIP & $aServerMultiHomeFull & $aTelnetCMD11 & " " & $aServerExtraCMD & " """

; Generic
$aSteamCMDDir = $aServerDirLocal & "\SteamCMD"
Global $aSteamAppFile = $aServerDirLocal & "\steamapps\appmanifest_" & $aSteamAppID & ".acf"

FileExistsFunc()
RemoteRestartUse()

FileWriteLine($aLogFile, _NowCalc() & " Running initial update check . . ")
Local $bRestart = UpdateCheck()
If $bRestart Then
	$aBeginDelayedShutdown = 1
EndIf

#EndRegion ;**** Startup Checks. Initial Log, Read INI, Check for Correct Paths, Check Remote Restart is bound to port. ****

While True ;**** Loop Until Closed ****
	#Region ;**** Listen for Remote Restart Request ****
	If $aRemoteRestartUse = "yes" Then
		Local $sRestart = _RemoteRestart($aRemoteRestartPort, $aRemoteRestartCode, $aRemoteRestartKey, $sObfuscatePass, $aServerIP, $aServerName, $aDebug)
		Switch @error
			Case 0

				If ProcessExists($aServerPID) And ($aBeginDelayedShutdown = 0) Then
					FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & "] " & $sRestart)
					$aBeginDelayedShutdown = 1
					$aTimeCheck0 = _NowCalc
				EndIf
			Case 1 To 4
				FileWriteLine($aLogFile, _NowCalc() & " " & $sRestart & @CRLF)
		EndSwitch
	EndIf
	#EndRegion ;**** Listen for Remote Restart Request ****

	#Region ;**** Keep Server Alive Check. ****
	If Not ProcessExists($aServerPIDRedis) Then
		$aBeginDelayedShutdown = 0
		$aSteamEXE = $aSteamCMDDir & "\steamcmd.exe +@ShutdownOnFailedCommand 1 +@NoPromptForPassword 1 +login anonymous +force_install_dir """ & $aServerDirLocal & """ +app_update " & $aSteamAppID

		If ($aValidate = "yes") Or ($aUpdateVerify = "yes") Then
			$aUpdateVerify = "no"
			$aSteamEXE = $aSteamEXE & " validate"
		EndIf
		If $aServerVer = 1 Then
			$aSteamEXE = $aSteamEXE & " -" & $aExperimentalString
		EndIf
		$aSteamEXE = $aSteamEXE & " +quit"
		If $aDebug Then
			FileWriteLine($aLogFile, _NowCalc() & " [Running SteamCMD update] " & $aSteamEXE)
		Else
			FileWriteLine($aLogFile, _NowCalc() & " [Running SteamCMD update]")
		EndIf
		RunWait($aSteamEXE)
		SplashOff()

		$aServerPIDRedis = Run($xServerRedis,$aServerDirLocal & $aServerRedisDir)
		If $aDebug Then
			FileWriteLine($aLogFile, _NowCalc() & " [Redis started (PID: " & $aServerPIDRedis & ")] " & $xServerRedis)
		Else
			FileWriteLine($aLogFile, _NowCalc() & " [Redis started (PID: " & $aServerPIDRedis & ")]")

		EndIf
	EndIf
	SplashOff()
	If Not ProcessExists($aServerPID00) And $aShutdown = 0 Then
		Sleep(5000)
		$aServerPID00 = Run($xServer00)
		If $aDebug Then
			FileWriteLine($aLogFile, _NowCalc() & " [Server 00 started (PID: " & $aServerPID00 & ")] " & $xServer00)
		Else
			FileWriteLine($aLogFile, _NowCalc() & " [Server 00 started (PID: " & $aServerPID00 & ")]")
		EndIf
	EndIf
	If $aServerQnty > 1 Then
		If Not ProcessExists($aServerPID10) And $aShutdown = 0  Then
			Sleep(10000)
			$aServerPID10 = Run($xServer10)
			If $aDebug Then
				FileWriteLine($aLogFile, _NowCalc() & " [Server 10 started (PID: " & $aServerPID10 & ")] " & $xServer10)
			Else
				FileWriteLine($aLogFile, _NowCalc() & " [Server 10 started (PID: " & $aServerPID10 & ")]")
			EndIf
		EndIf
	EndIf
	If $aServerQnty > 2 Then
		If Not ProcessExists($aServerPID01) And $aShutdown = 0  Then
			Sleep(15000)
			$aServerPID01 = Run($xServer01, $aServerDirFull)
			If $aDebug Then
				FileWriteLine($aLogFile, _NowCalc() & " [Server 01 started (PID: " & $aServerPID01 & ")] " & $xServer01)
			Else
				FileWriteLine($aLogFile, _NowCalc() & " [Server 01 started (PID: " & $aServerPID01 & ")]")
			EndIf
		EndIf
	EndIf
	If $aServerQnty > 3 Then
		If Not ProcessExists($aServerPID11) And $aShutdown = 0  Then
			Sleep(20000)
			$aServerPID11 = Run($xServer11, $aServerDirFull)
			If $aDebug Then
				FileWriteLine($aLogFile, _NowCalc() & " [Server 11 started (PID: " & $aServerPID11 & ")] " & $xServer11)
			Else
				FileWriteLine($aLogFile, _NowCalc() & " [Server 11 started (PID: " & $aServerPID11 & ")]")
			EndIf
			Sleep(1000)
		EndIf
	EndIf
	#EndRegion ;**** Keep Server Alive Check. ****

	#Region ;**** Restart Server Every X Days and X Hours & Min****
	If (($aRestartDaily = "yes") And ((_DateDiff('n', $aTimeCheck2, _NowCalc())) >= 1) And (DailyRestartCheck($aRestartDays, $aRestartHours, $aRestartMin)) And ($aBeginDelayedShutdown = 0)) Then
		FileWriteLine($aLogFile, _NowCalc() & " [Daily Restart Requested . . .]")
		Global $aBotMsg = $sAnnounceScheduledMessage
		$aBeginDelayedShutdown = 1
		$aTimeCheck0 = _NowCalc()
		$aTimeCheck2 = _NowCalc()
	EndIf
	#EndRegion ;**** Restart Server Every X Days and X Hours & Min****

	#Region ;**** Check for Update every X Minutes ****
	If ((_DateDiff('n', $aTimeCheck0, _NowCalc())) >= $aUpdateCheckInterval) And ($aBeginDelayedShutdown = 0) Then
		Local $bRestart = UpdateCheck()
		If $bRestart Then
			$aBeginDelayedShutdown = 1
			;	ElseIf $bRestart Then
			;	CloseServer()
		EndIf
		$aTimeCheck0 = _NowCalc()
	EndIf
	#EndRegion ;**** Check for Update every X Minutes ****

	If ($sUseDiscordBotScheduled = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotScheduled = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes") Then
		If $aBeginDelayedShutdown = 1 Then
			FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & " Bot in Use] Delaying Shutdown for " & $aDelayShutdownTime & " minutes. Notifying Channel")
			Local $sShutdownMessage = $aServerName & ": " & $aBotMsg & " Restarting in " & $aDelayShutdownTime & " minutes..."
			Local $sInGameMsg = """WARNING! Server restarting in 1 minute....""" & @CRLF
			Local $sInGameMsgDaily = """WARNING! " & $sAnnounceScheduledMessage & ". Server restarting in " & $aDelayShutdownTime & " minutes...""" & @CRLF
			Local $sInGameMsgUpdate = """WARNING! " & $sAnnounceUpdateMessage & ". Server restarting in " & $aDelayShutdownTime & " minutes...""" & @CRLF
			Local $sInGameMsgRemoteRestart = """WARNING! " & $sAnnounceRemoteRestartMessage & ". Server restarting in " & $aBeginDelayedShutdown & " minutes...""" & @CRLF
			If $aBotMsg = $sAnnounceScheduledMessage Then
				If $sInGameAnnounce = "yes" Then
					SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $sInGameMsgDaily)
				EndIf
				If $sUseDiscordBotScheduled = "yes" Then
					SendDiscordMsg($sDiscordWebHookURLs, $sShutdownMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
				EndIf
				If $sUseTwitchBotScheduled = "yes" Then
					TwitchMsgLog($sShutdownMessage)
				EndIf
			EndIf

			If $aBotMsg = $sAnnounceRemoteRestartMessage Then
				If $sInGameAnnounce = "yes" Then
					SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $sInGameMsgRemoteRestart)
				EndIf
				If $sUseDiscordBotUpdate = "yes" Then
					SendDiscordMsg($sDiscordWebHookURLs, $sShutdownMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
				EndIf
				If $sUseTwitchBotUpdate = "yes" Then
					TwitchMsgLog($sShutdownMessage)
				EndIf
			EndIf

			If $aBotMsg = $sAnnounceUpdateMessage Then
				If $sInGameAnnounce = "yes" Then
					SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $sInGameMsgUpdate)
				EndIf
				If $sUseDiscordBotUpdate = "yes" Then
					SendDiscordMsg($sDiscordWebHookURLs, $sShutdownMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
				EndIf
				If $sUseTwitchBotUpdate = "yes" Then
					TwitchMsgLog($sShutdownMessage)
				EndIf
			EndIf

			$aBeginDelayedShutdown = 2
			$aTimeCheck0 = _NowCalc()
		ElseIf ($aBeginDelayedShutdown >= 2 And ((_DateDiff('n', $aTimeCheck0, _NowCalc())) >= $aDelayShutdownTime)) Then
			$aBeginDelayedShutdown = 0
			$aTimeCheck0 = _NowCalc()
			CloseServer()
		ElseIf $aBeginDelayedShutdown = 2 And ((_DateDiff('n', $aTimeCheck0, _NowCalc())) >= ($aDelayShutdownTime - 1)) Then
			Local $sShutdownMessage = $aServerName & " Restarting in 1 minute. Final Warning"
			If ($aBotMsg = $sAnnounceScheduledMessage) Or ($aBotMsg = $sAnnounceRemoteRestartMessage) Or ($aBotMsg = $sAnnounceUpdateMessage) Then
				If $sInGameAnnounce = "yes" Then
					SendInGame($aServerIP, $aTelnetPort, $aTelnetPass, $sInGameMsg)
				EndIf
				If $sUseDiscordBotScheduled = "yes" Then
					SendDiscordMsg($sDiscordWebHookURLs, $sShutdownMessage, $sDiscordBotName, $bDiscordBotUseTTS, $sDiscordBotAvatar)
				EndIf
				If $sUseTwitchBotScheduled = "yes" Then
					TwitchMsgLog($sShutdownMessage)
				EndIf
			EndIf
			$aBeginDelayedShutdown = 3
		EndIf
	Else
		$aBeginDelayedShutdown = 0
	EndIf
	#EndRegion ;**** Announce to In Game, Twitch, Discord ****

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
	Local $iIniFail = 0
	Local $iniCheck = ""
	Local $aChar[3]
	For $i = 1 To 13
		$aChar[0] = Chr(Random(97, 122, 1)) ;a-z
		$aChar[1] = Chr(Random(48, 57, 1)) ;0-9
		$iniCheck &= $aChar[Random(0, 1, 1)]
	Next
	Global $aServerName = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server name (for announcements and logs only)", $iniCheck)
	Global $aServerDirLocal = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server directory (No trailing slash)", $iniCheck)
;	Global $aServerVer = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Version (0-Stable,1-Experimental)", $iniCheck)
	Global $aServerExtraCMD = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Extra commandine parameters for server.exe (ex. -serverpassword)", $iniCheck)
	Global $aServerIP = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server IP", $iniCheck)
;	Global $aServerMultiHomeIP = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server multi-home IP (local IP ex. 192.168.1.10. Leave blank to disable)", $iniCheck)
	Global $aSteamCMDDir = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "SteamCMD directory (No trailing slash)", $iniCheck)
	Global $aSteamExtraCMD = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Extra commandine parameters for SteamCMD (ex. -latest_experimental)", $iniCheck)
;	Global $aServerSaveDir = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Gamesave directory name", $iniCheck)
	Global $aServerAdminPass = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Admin password", $iniCheck)
	Global $aServerMaxPlayers = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Max players", $iniCheck)
	Global $aServerReservedSlots = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Reserved slots", $iniCheck)
	Global $aServerQnty = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Number of servers/grids (1-4)", $iniCheck)
	Global $aServer00Port = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 1 (0,0) port", $iniCheck)
	Global $aServer00QueryPort = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 1 (0,0) query port", $iniCheck)
	Global $aServer00RCONPort = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 1 (0,0) RCON port", $iniCheck)
	Global $aServer00Folder = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 1 (0,0) save folder name", $iniCheck)
	Global $aServer10Port = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 2 (1,0) port", $iniCheck)
	Global $aServer10QueryPort = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 2 (1,0) query port", $iniCheck)
	Global $aServer10RCONPort = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 2 (1,0) RCON port", $iniCheck)
	Global $aServer10Folder = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 2 (1,0) save folder name", $iniCheck)
	Global $aServer01Port = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 3 (0,1) port", $iniCheck)
	Global $aServer01QueryPort = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 3 (0,1) query port", $iniCheck)
	Global $aServer01RCONPort = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 3 (0,1) RCON port", $iniCheck)
	Global $aServer01Folder = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 3 (0,1) save folder name", $iniCheck)
	Global $aServer11Port = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 4 (1,1) port", $iniCheck)
	Global $aServer11QueryPort = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 4 (1,1) query port", $iniCheck)
	Global $aServer11RCONPort = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 4 (1,1) RCON port", $iniCheck)
	Global $aServer11Folder = IniRead($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 4 (1,1) save folder name", $iniCheck)
	;	Global $aTelnetCheck = IniRead($sIniFile, " ---------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE ---------- ", "Use RCON/telnet to check if server is alive? (yes/no)", $iniCheck)
	;	Global $aTelnetCheckSec = IniRead($sIniFile, " ---------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE ---------- ", "RCON/Telnet check interval in seconds (30-900)", $iniCheck)
	;	Global $aTelnetPort = IniRead($sIniFile, " ---------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE ---------- ", "RCON/Telnet port", $iniCheck)
	;	Global $aTelnetPass = IniRead($sIniFile, " ---------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE ---------- ", "RCON/Telnet password", $iniCheck)
	Global $aExMemRestart = IniRead($sIniFile, " ---------- RESTART ON EXCESSIVE MEMORY USE ---------- ", "Restart on excessive memory use? (yes/no)", $iniCheck)
	Global $aExMem = IniRead($sIniFile, " ---------- RESTART ON EXCESSIVE MEMORY USE ---------- ", "Excessive memory amount?", $iniCheck)
	Global $aRemoteRestartUse = IniRead($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Use Remote Restart? (yes/no)", $iniCheck)
	Global $aRemoteRestartIP = IniRead($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Server Local IP (ex. 192.168.1.10)", $iniCheck)
	Global $aRemoteRestartPort = IniRead($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Restart Port", $iniCheck)
	Global $aRemoteRestartKey = IniRead($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Restart Key", $iniCheck)
	Global $aRemoteRestartCode = IniRead($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Restart Code", $iniCheck)
	Global $aCheckForUpdate = IniRead($sIniFile, " ---------- CHECK FOR UPDATE ---------- ", "Check for updates? (yes/no)", $iniCheck)
	Global $aUpdateCheckInterval = IniRead($sIniFile, " ---------- CHECK FOR UPDATE ---------- ", "Update check interval in Minutes (05-59)", $iniCheck)
	Global $aRestartDaily = IniRead($sIniFile, " ---------- SCHEDULED RESTARTS ---------- ", "Use scheduled restarts? (yes/no)", $iniCheck)
	Global $aRestartDays = IniRead($sIniFile, " ---------- SCHEDULED RESTARTS ---------- ", "Restart days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6)", $iniCheck)
	Global $aRestartHours = IniRead($sIniFile, " ---------- SCHEDULED RESTARTS ---------- ", "Restart hours (comma separated 00-23 ex.04,16)", $iniCheck)
	Global $aRestartMin = IniRead($sIniFile, " ---------- SCHEDULED RESTARTS ---------- ", "Restart minute (00-59)", $iniCheck)
	Global $sAnnounceScheduledMessage = IniRead($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Announcement message: Scheduled", $iniCheck)
	Global $sAnnounceUpdateMessage = IniRead($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Announcement message: Updates", $iniCheck)
	Global $sAnnounceRemoteRestartMessage = IniRead($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Announcement message: Remote Restart", $iniCheck)
	Global $sAnnounceNotifyTime = IniRead($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Announcement minutes before restart", $iniCheck)
	Global $sInGameAnnounce = IniRead($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Send in-game message for restarts? Requires RCON/Telnet (yes/no)", $iniCheck)
	Global $sUseDiscordBotScheduled = IniRead($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Send Discord message for scheduled restarts? (yes/no)", $iniCheck)
	Global $sUseDiscordBotUpdate = IniRead($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Send Discord message for update restarts? (yes/no)", $iniCheck)
	Global $sUseDiscordBotRemoteRestart = IniRead($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Send Discord message for Remote Restart restarts? (yes/no)", $iniCheck)
	Global $sDiscordWebHookURLs = IniRead($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "WebHook URL", $iniCheck)
	Global $sDiscordBotName = IniRead($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Bot Name", $iniCheck)
	Global $bDiscordBotUseTTS = IniRead($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Use TTS? (yes/no)", $iniCheck)
	Global $sDiscordBotAvatar = IniRead($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Bot Avatar Link", $iniCheck)
	Global $sUseTwitchBotScheduled = IniRead($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Send Twitch message for scheduled restarts? (yes/no)", $iniCheck)
	Global $sUseTwitchBotUpdate = IniRead($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Send Twitch message for update restarts? (yes/no)", $iniCheck)
	Global $sUseTwitchBotRemoteRestart = IniRead($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Send Twitch message for Remote Restart restarts? (yes/no)", $iniCheck)
	Global $sTwitchNick = IniRead($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Nick", $iniCheck)
	Global $sChatOAuth = IniRead($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "ChatOAuth", $iniCheck)
	Global $sTwitchChannels = IniRead($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Channels", $iniCheck)
	Global $aExecuteExternalScript = IniRead($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START ---------- ", "1-Execute external script BEFORE update? (yes/no)", $iniCheck)
	Global $aExternalScriptDir = IniRead($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START ---------- ", "1-Script directory", $iniCheck)
	Global $aExternalScriptName = IniRead($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START ---------- ", "1-Script filename", $iniCheck)
	Global $aExecuteExternalScriptValidate = IniRead($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START ---------- ", "2-Execute external script AFTER update but BEFORE server start? (yes/no)", $iniCheck)
	Global $aExternalScriptDirValidate = IniRead($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START ---------- ", "2-Script directory", $iniCheck)
	Global $aExternalScriptNameValidate = IniRead($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START ---------- ", "2-Script filename", $iniCheck)
	Global $aExternalScriptUpdate = IniRead($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER UPDATE ---------- ", "3-Execute external script for server update restarts? (yes/no)", $iniCheck)
	Global $aExternalScriptUpdateDir = IniRead($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER UPDATE ---------- ", "3-Script directory", $iniCheck)
	Global $aExternalScriptUpdateFileName = IniRead($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER UPDATE ---------- ", "3-Script filename", $iniCheck)
	Global $aLogRotate = IniRead($sIniFile, " ---------- LOG FILE OPTIONS ---------- ", "Rotate log files? (yes/no)", $iniCheck)
	Global $aLogQuantity = IniRead($sIniFile, " ---------- LOG FILE OPTIONS ---------- ", "Number of logs", $iniCheck)
	Global $aLogHoursBetweenRotate = IniRead($sIniFile, " ---------- LOG FILE OPTIONS ---------- ", "Hours between log rotations", $iniCheck)
	Global $aEnableRCON = IniRead($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Enable RCON? (yes/no)", $iniCheck)
	Global $aRCONSaveDelaySec = IniRead($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Delay between saveworld and quit commands during shutdown in seconds (5-120)", $iniCheck)
	Global $aValidate = IniRead($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Validate files with SteamCMD update? (yes/no)", $iniCheck)
	Global $aUpdateSource = IniRead($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "For update checks, use (0-SteamCMD or 1-SteamDB.com)", $iniCheck)
	Global $aUsePuttytel = IniRead($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Use puttytel for telnet client? (puttytel is more reliable but has popup windows) (yes/no)", $iniCheck)
	Global $sObfuscatePass = IniRead($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Hide passwords in log files? (yes/no)", $iniCheck)
	Global $aDebug = IniRead($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Enable debug to output more log detail? (yes/no)", $iniCheck)

	If $iniCheck = $aServerDirLocal Then
		$aServerDirLocal = "D:\Game Servers\" & $aGameName & " Dedicated Server"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aSteamCMDDir Then
		$aSteamCMDDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\SteamCMD"
		$iIniFail += 1
	EndIf
	;	If $iniCheck = $aServerVer Then
	;		$aServerVer = "0"
	;		$iIniFail += 1
	;	EndIf
	If $iniCheck = $aServerIP Then
		$aServerIP = "127.0.0.1"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServerName Then
		$aServerName = $aGameName
		$iIniFail += 1
	EndIf
	If $iniCheck = $aValidate Then
		$aValidate = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aSteamExtraCMD Then
		$aSteamExtraCMD = ""
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServerExtraCMD Then
		$aServerExtraCMD = "-log -server -servergamelog -NoBattlEye"
		$iIniFail += 1
	EndIf
;	If $iniCheck = $aServerSaveDir Then
;		$aServerSaveDir = "10"
;		$iIniFail += 1
;	EndIf
	If $iniCheck = $aServerAdminPass Then
		$aServerAdminPass = "AdMiN_PaSsWoRd"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServerMaxPlayers Then
		$aServerMaxPlayers = "40"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServerReservedSlots Then
		$aServerReservedSlots = "10"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServerQnty Then
		$aServerQnty = "4"
		$iIniFail += 1
	ElseIf $aServerQnty < 1 Then
		$aServerQnty = 1
	ElseIf $aServerQnty > 4 Then
		$aServerQnty = 4
	EndIf
	If $iniCheck = $aEnableRCON Then
		$aEnableRCON = "yes"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aRCONSaveDelaySec Then
		$aRCONSaveDelaySec = "10"
		$iIniFail += 1
	ElseIf $aRCONSaveDelaySec < 5 Then
		$aRCONSaveDelaySec = 5
	ElseIf $aRCONSaveDelaySec > 120 Then
		$aRCONSaveDelaySec = 120
	EndIf
	If $iniCheck = $aServer00Port Then
		$aServer00Port = "5790"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer00QueryPort Then
		$aServer00QueryPort = "57590"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer00RCONPort Then
		$aServer00RCONPort = "25720"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer00Folder Then
		$aServer00Folder = "a00"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer10Port Then
		$aServer10Port = "5792"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer10QueryPort Then
		$aServer10QueryPort = "57592"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer10RCONPort Then
		$aServer10RCONPort = "25722"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer10Folder Then
		$aServer10Folder = "a10"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer01Port Then
		$aServer01Port = "5794"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer01QueryPort Then
		$aServer01QueryPort = "57594"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer01RCONPort Then
		$aServer01RCONPort = "25724"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer01Folder Then
		$aServer01Folder = "a01"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer11Port Then
		$aServer11Port = "5796"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer11QueryPort Then
		$aServer11QueryPort = "57596"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer11RCONPort Then
		$aServer11RCONPort = "25726"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aServer11Folder Then
		$aServer11Folder = "a11"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aRemoteRestartUse Then
		$aRemoteRestartUse = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aRemoteRestartIP Then
		$aRemoteRestartIP = "192.168.1.10"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aRemoteRestartPort Then
		$aRemoteRestartPort = "57520"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aRemoteRestartKey Then
		$aRemoteRestartKey = "restart"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aRemoteRestartCode Then
		$aRemoteRestartCode = "password"
		$iIniFail += 1
	EndIf
;	If $iniCheck = $aUsePuttytel Then
;		$aUsePuttytel = "yes"
;		$iIniFail += 1
;	EndIf

;	If $iniCheck = $aTelnetCheck Then
;		$aTelnetCheck = "yes"
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
	EndIf
	If $iniCheck = $aCheckForUpdate Then
		$aCheckForUpdate = "yes"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aUpdateCheckInterval Then
		$aUpdateCheckInterval = "15"
		$iIniFail += 1
	ElseIf $aUpdateCheckInterval < 5 Then
		$aUpdateCheckInterval = 5
	EndIf
	If $iniCheck = $aRestartDaily Then
		$aRestartDaily = "yes"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aRestartDays Then
		$aRestartDays = "0"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aRestartHours Then
		$aRestartHours = "04,16"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aRestartMin Then
		$aRestartMin = "00"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExMem Then
		$aExMem = "6000000000"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExMemRestart Then
		$aExMemRestart = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aLogRotate Then
		$aLogRotate = "yes"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aLogQuantity Then
		$aLogQuantity = "10"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aLogHoursBetweenRotate Then
		$aLogHoursBetweenRotate = "24"
		$iIniFail += 1
	ElseIf $aLogHoursBetweenRotate < 1 Then
		$aLogHoursBetweenRotate = 1
	EndIf
	If $iniCheck = $sAnnounceScheduledMessage Then
		$sAnnounceScheduledMessage = "Scheduled server restart."
		$iIniFail += 1
	EndIf
	If $iniCheck = $sAnnounceNotifyTime Then
		$sAnnounceNotifyTime = "5"
		$iIniFail += 1
	ElseIf $sAnnounceNotifyTime < 5 Then
		$sAnnounceNotifyTime = 5
	EndIf
	If $iniCheck = $sAnnounceUpdateMessage Then
		$sAnnounceUpdateMessage = "New server update."
		$iIniFail += 1
	EndIf
	If $iniCheck = $sAnnounceRemoteRestartMessage Then
		$sAnnounceRemoteRestartMessage = "Server maintence."
		$iIniFail += 1
	EndIf
	If $iniCheck = $sInGameAnnounce Then
		$sInGameAnnounce = "yes"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sUseDiscordBotScheduled Then
		$sUseDiscordBotScheduled = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sUseDiscordBotUpdate Then
		$sUseDiscordBotUpdate = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sUseDiscordBotRemoteRestart Then
		$sUseDiscordBotRemoteRestart = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sDiscordWebHookURLs Then
		$sDiscordWebHookURLs = "https://discordapp.com/api/webhooks/XXXXXX/XXXX<-NO TRAILING SLASH AND USE FULL URL FROM WEBHOOK URL ON DISCORD"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sDiscordBotName Then
		$sDiscordBotName = $aGameName & " Bot"
		$iIniFail += 1
	EndIf
	If $iniCheck = $bDiscordBotUseTTS Then
		$bDiscordBotUseTTS = "yes"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sDiscordBotAvatar Then
		$sDiscordBotAvatar = ""
		$iIniFail += 1
	EndIf
	If $iniCheck = $sUseTwitchBotScheduled Then
		$sUseTwitchBotScheduled = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sUseTwitchBotUpdate Then
		$sUseTwitchBotUpdate = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sUseTwitchBotRemoteRestart Then
		$sUseTwitchBotRemoteRestart = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sTwitchNick Then
		$sTwitchNick = "twitchbotusername"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sChatOAuth Then
		$sChatOAuth = "oauth:1234(Generate OAuth Token Here: https://twitchapps.com/tmi)"
		$iIniFail += 1
	EndIf
	If $iniCheck = $sTwitchChannels Then
		$sTwitchChannels = "channel1,channel2,channel3"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExecuteExternalScript Then
		$aExecuteExternalScript = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExternalScriptDir Then
		$aExternalScriptDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\Scripts"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExternalScriptName Then
		$aExternalScriptName = "before.bat"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExecuteExternalScriptValidate Then
		$aExecuteExternalScriptValidate = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExternalScriptDirValidate Then
		$aExternalScriptDirValidate = "D:\Game Servers\" & $aGameName & " Dedicated Server\Scripts"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExternalScriptNameValidate Then
		$aExternalScriptNameValidate = "after.bat"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExternalScriptUpdate Then
		$aExternalScriptUpdate = "no"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExternalScriptUpdateDir Then
		$aExternalScriptUpdateDir = "D:\Game Servers\" & $aGameName & " Dedicated Server\Scripts"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aExternalScriptUpdateFileName Then
		$aExternalScriptUpdateFileName = "update.bat"
		$iIniFail += 1
	EndIf
	If $iniCheck = $aUpdateSource Then
		$aUpdateSource = "0"
		$iIniFail += 1
	EndIf
	If ($aUpdateSource = "1") And ($aUpdateCheckInterval <30) Then
		$aUpdateCheckInterval = 30
		FileWriteLine($aLogFile, _NowCalc() & "NOTICE: SteamDB will ban your IP if you check too often. Update check interval set to 30 minutes")
	EndIf
	If $iniCheck = $aDebug Then
		$aDebug = "no"
		$iIniFail += 1
	EndIf
	If $iIniFail > 0 Then
		iniFileCheck($sIniFile, $iIniFail)
	EndIf
	If $bDiscordBotUseTTS = "yes" Then
		$bDiscordBotUseTTS = True
	Else
		$bDiscordBotUseTTS = False
	EndIf
	Global $aDelayShutdownTime = 0
	If ($sUseDiscordBotScheduled = "yes") Or ($sUseDiscordBotUpdate = "yes") Or ($sUseTwitchBotScheduled = "yes") Or ($sUseTwitchBotUpdate = "yes") Or ($sInGameAnnounce = "yes") Then
		$aDelayShutdownTime = $sAnnounceNotifyTime
	EndIf
	If $aDebug = "yes" Then
		Global $aDebug = True
	Else
		Global $aDebug = False
	EndIf
;	If ($sInGameAnnounce = "yes") Or ($aTelnetCheck = "yes") And ($aTelnetRequired = "1") Then
;		FileWriteLine($aLogFile, _NowCalc() & "RCON/Telnet Required", "RCON/Telnet required for in-game announcements and ROCN/Telnet KeepAlive checks. RCON/Telnet enabled and set to port: " & $aTelnetPort & ".")
;	EndIf

EndFunc   ;==>ReadUini

Func iniFileCheck($sIniFile, $iIniFail)
	If FileExists($sIniFile) Then
		Local $aMyDate, $aMyTime
		_DateTimeSplit(_NowCalc(), $aMyDate, $aMyTime)
		Local $iniDate = StringFormat("%04i.%02i.%02i.%02i%02i", $aMyDate[1], $aMyDate[2], $aMyDate[3], $aMyTime[1], $aMyTime[2])
		FileMove($sIniFile, $sIniFile & "_" & $iniDate & ".bak", 1)
		UpdateIni($sIniFile)
		FileWriteLine($aLogFile, _NowCalc() & " INI MISMATCH: Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini. Backup created and all existing settings transfered to new INI. Please modify INI and restart.")
		MsgBox(4096, "INI MISMATCH", "Found " & $iIniFail & " missing variable(s) in " & $aUtilName & ".ini." & @CRLF & @CRLF & "Backup created and all existing settings transfered to new INI." & @CRLF & @CRLF & "Please modify INI and restart.")
		Exit
	Else
		UpdateIni($sIniFile)
		SplashOff()
		MsgBox(4096, "Default INI File Created", "Please Modify Default Values and Restart Program." & @CRLF & @CRLF & "IF NEW DEDICATED SERVER INSTALL:" & @CRLF & " - Once the server is installed and running," & @CRLF & "Rt-Click on 7dtdServerUpdateUtility icon and shutdown server." & @CRLF & " - Then modify default values in serverconfig.xml" & @CRLF & "and restart 7dtdServerUpdateUtility.exe")
		FileWriteLine($aLogFile, _NowCalc() & "  Default INI File Created . . Please Modify Default Values and Restart Program.")
		Exit
	EndIf
EndFunc   ;==>iniFileCheck

Func UpdateIni($sIniFile)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server name (for announcements and logs only)", $aServerName)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server directory (No trailing slash)", $aServerDirLocal)
	;	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Version (0-Stable,1-Experimental)", $aServerVer)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Extra commandine parameters for server.exe (ex. -serverpassword)", $aServerExtraCMD)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server IP", $aServerIP)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "SteamCMD directory (No trailing slash)", $aSteamCMDDir)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Extra commandine parameters for SteamCMD (ex. -latest_experimental)", $aSteamExtraCMD)
;	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Gamesave directory name", $aServerSaveDir)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Admin password", $aServerAdminPass)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Max players", $aServerMaxPlayers)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Reserved slots", $aServerReservedSlots)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Number of servers/grids (1-4)", $aServerQnty)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 1 (0,0) port", $aServer00Port)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 1 (0,0) query port", $aServer00QueryPort)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 1 (0,0) RCON port", $aServer00RCONPort)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 1 (0,0) save folder name", $aServer00Folder)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 2 (1,0) port", $aServer10Port)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 2 (1,0) query port", $aServer10QueryPort)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 2 (1,0) RCON port", $aServer10RCONPort)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 2 (1,0) save folder name", $aServer10Folder)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 3 (0,1) port", $aServer01Port)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 3 (0,1) query port", $aServer01QueryPort)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 3 (0,1) RCON port", $aServer01RCONPort)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 3 (0,1) save folder name", $aServer01Folder)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 4 (1,1) port", $aServer11Port)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 4 (1,1) query port", $aServer11QueryPort)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 4 (1,1) RCON port", $aServer11RCONPort)
	IniWrite($sIniFile, " ---------- SERVER INFORMATION ---------- ", "Server 4 (1,1) save folder name", $aServer11Folder)
;	IniWrite($sIniFile, " ---------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE ---------- ", "Use RCON/telnet to check if server is alive? (yes/no)", $aTelnetCheck)
;	IniWrite($sIniFile, " ---------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE ---------- ", "RCON/Telnet check interval in seconds (30-900)", $aTelnetCheckSec)
;	IniWrite($sIniFile, " ---------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE ---------- ", "RCON/Telnet port", $aTelnetPort)
;	IniWrite($sIniFile, " ---------- USE RCON/TELNET TO CHECK IF SERVER IS ALIVE ---------- ", "RCON/Telnet password", $aTelnetPass)
	IniWrite($sIniFile, " ---------- RESTART ON EXCESSIVE MEMORY USE ---------- ", "Restart on excessive memory use? (yes/no)", $aExMemRestart)
	IniWrite($sIniFile, " ---------- RESTART ON EXCESSIVE MEMORY USE ---------- ", "Excessive memory amount?", $aExMem)
	IniWrite($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Use Remote Restart? (yes/no)", $aRemoteRestartUse)
	IniWrite($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Server Local IP (ex. 192.168.1.10)", $aRemoteRestartIP)
	IniWrite($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Restart Port", $aRemoteRestartPort)
	IniWrite($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Restart Key", $aRemoteRestartKey)
	IniWrite($sIniFile, " ---------- REMOTE RESTART OPTIONS ---------- (http://IP:Port?RestartKey=RestartCode. ex: 192.168.1.10:57520?restart=password)", "Restart Code", $aRemoteRestartCode)
	IniWrite($sIniFile, " ---------- CHECK FOR UPDATE ---------- ", "Check for updates? (yes/no)", $aCheckForUpdate)
	IniWrite($sIniFile, " ---------- CHECK FOR UPDATE ---------- ", "Update check interval in minutes (05-59)", $aUpdateCheckInterval)
	IniWrite($sIniFile, " ---------- SCHEDULED RESTARTS ---------- ", "Use scheduled restarts? (yes/no)", $aRestartDaily)
	IniWrite($sIniFile, " ---------- SCHEDULED RESTARTS ---------- ", "Restart days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6)", $aRestartDays)
	IniWrite($sIniFile, " ---------- SCHEDULED RESTARTS ---------- ", "Restart hours (comma separated 00-23 ex.04,16)", $aRestartHours)
	IniWrite($sIniFile, " ---------- SCHEDULED RESTARTS ---------- ", "Restart minute (00-59)", $aRestartMin)
	IniWrite($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Announcement message: Scheduled", $sAnnounceScheduledMessage)
	IniWrite($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Announcement message: Updates", $sAnnounceUpdateMessage)
	IniWrite($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Announcement message: Remote Restart", $sAnnounceRemoteRestartMessage)
	IniWrite($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Announcement minutes before restart", $sAnnounceNotifyTime)
	IniWrite($sIniFile, " ---------- ANNOUNCEMENT MESSAGES ---------- (if announcements enabled)", "Send in-game message for restarts? Requires RCON/Telnet (yes/no)", $sInGameAnnounce)
	IniWrite($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Send Discord message for scheduled restarts? (yes/no)", $sUseDiscordBotScheduled)
	IniWrite($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Send Discord message for update restarts? (yes/no)", $sUseDiscordBotUpdate)
	IniWrite($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Send Discord message for Remote Restart restarts? (yes/no)", $sUseDiscordBotRemoteRestart)
	IniWrite($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "WebHook URL", $sDiscordWebHookURLs)
	IniWrite($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Bot Name", $sDiscordBotName)
	IniWrite($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Use TTS? (yes/no)", $bDiscordBotUseTTS)
	IniWrite($sIniFile, " ---------- DISCORD ANNOUNCEMENTS ---------- ", "Bot Avatar Link", $sDiscordBotAvatar)
	IniWrite($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Send Twitch message for scheduled restarts? (yes/no)", $sUseTwitchBotScheduled)
	IniWrite($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Send Twitch message for update restarts? (yes/no)", $sUseTwitchBotUpdate)
	IniWrite($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Send Twitch message for Remote Restart restarts? (yes/no)", $sUseTwitchBotRemoteRestart)
	IniWrite($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Nick", $sTwitchNick)
	IniWrite($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "ChatOAuth", $sChatOAuth)
	IniWrite($sIniFile, " ---------- TWITCH ANNOUNCEMENTS ---------- ", "Channels", $sTwitchChannels)
	IniWrite($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START ---------- ", "1-Execute external script BEFORE update? (yes/no)", $aExecuteExternalScript)
	IniWrite($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START ---------- ", "1-Script directory", $aExternalScriptDir)
	IniWrite($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START ---------- ", "1-Script filename", $aExternalScriptName)
	IniWrite($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START ---------- ", "2-Execute external script AFTER update but BEFORE server start? (yes/no)", $aExecuteExternalScriptValidate)
	IniWrite($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START ---------- ", "2-Script directory", $aExternalScriptDirValidate)
	IniWrite($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT AFTER SteamCMD BUT BEFORE SERVER START ---------- ", "2-Script filename", $aExternalScriptNameValidate)
	IniWrite($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER UPDATE ---------- ", "3-Execute external script for server update restarts? (yes/no)", $aExternalScriptUpdate)
	IniWrite($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER UPDATE ---------- ", "3-Script directory", $aExternalScriptUpdateDir)
	IniWrite($sIniFile, " ---------- EXECUTE EXTERNAL SCRIPT WHEN RESTARTING FOR SERVER UPDATE ---------- ", "3-Script filename", $aExternalScriptUpdateFileName)
	IniWrite($sIniFile, " ---------- LOG FILE OPTIONS ---------- ", "Rotate log files? (yes/no)", $aLogRotate)
	IniWrite($sIniFile, " ---------- LOG FILE OPTIONS ---------- ", "Number of logs", $aLogQuantity)
	IniWrite($sIniFile, " ---------- LOG FILE OPTIONS ---------- ", "Hours between log rotations", $aLogHoursBetweenRotate)
	IniWrite($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Validate files with SteamCMD update? (yes/no)", $aValidate)
	IniWrite($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Enable RCON? (yes/no)", $aEnableRCON)
	IniWrite($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Delay between saveworld and quit commands during shutdown in seconds (5-120)", $aRCONSaveDelaySec)
	IniWrite($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "For update checks, use (0-SteamCMD or 1-SteamDB.com)", $aUpdateSource)
;	IniWrite($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Use puttytel for telnet client? (puttytel is more reliable but has popup windows) (yes/no)", $aUsePuttytel)
	IniWrite($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Hide passwords in log files? (yes/no)", $sObfuscatePass)
	IniWrite($sIniFile, " ---------- ServerUpdateUtility MISC OPTIONS ---------- ", "Enable debug to output more log detail? (yes/no)", $aDebug)

EndFunc   ;==>UpdateIni
#EndRegion ;**** INI Settings - User Variables ****

; -----------------------------------------------------------------------------------------------------------------------


#Region ; **** Gamercide Shutdown Protocol ****
Func Gamercide()
	If @exitMethod <> 1 Then
		$Shutdown = MsgBox(4100, "Shut Down?", "Do you wish to shutdown Server " & $aServerName & "?", 60)
		If $Shutdown = 6 Then
			FileWriteLine($aLogFile, _NowCalc() & " [" & $aServerName & "] Server Shutdown - Intiated by User when closing " & $aUtilityVer & " Script")
			CloseServer()
		EndIf
		MsgBox(4096, "Thanks for using our Application", "Please visit http://www.Phoenix125.com and https://gamercide.com", 15)
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

Func CloseServer()
$aShutdown = 1
Local $aRCONSaveDelaySleep = $aRCONSaveDelaySec * 1000
FileWriteLine($aLogFile, _NowCalc() & " --------- Server(s) shutdown sequence beginning ---------")
SplashTextOn($aUtilName,"Server shutdown sequence beginning." & @CRLF & "Saving world(s) with " & $aRCONSaveDelaySec & " second delay before shutting down.",500,75, -1, -1, $DLG_MOVEABLE, "")
SendRCON($aServer00Port, $aServer00RCONPort, $aServerAdminPass, $aRCONSaveGameCMD)
If $aServerQnty > 1 Then
	SendRCON($aServer10Port, $aServer10RCONPort, $aServerAdminPass, $aRCONSaveGameCMD)
EndIf
If $aServerQnty > 2 Then
	SendRCON($aServer01Port, $aServer01RCONPort, $aServerAdminPass, $aRCONSaveGameCMD)
EndIf
If $aServerQnty > 3 Then
	SendRCON($aServer11Port, $aServer11RCONPort, $aServerAdminPass, $aRCONSaveGameCMD)
EndIf
FileWriteLine($aLogFile, _NowCalc() & " Waiting " & $aRCONSaveDelaySec & " seconds for save game to complete . . .")
Sleep($aRCONSaveDelaySleep)
SendRCON($aServer00Port, $aServer00RCONPort, $aServerAdminPass, $aRCONShutdownCMD)
If $aServerQnty > 1 Then
	SendRCON($aServer10Port, $aServer10RCONPort, $aServerAdminPass, $aRCONShutdownCMD)
EndIf
If $aServerQnty > 2 Then
	SendRCON($aServer01Port, $aServer01RCONPort, $aServerAdminPass, $aRCONShutdownCMD)
EndIf
If $aServerQnty > 3 Then
	SendRCON($aServer11Port, $aServer11RCONPort, $aServerAdminPass, $aRCONShutdownCMD)
EndIf
Sleep(5000)
SplashOff()
	If ProcessExists($aServerPIDRedis) Then
		FileWriteLine($aLogFile, _NowCalc() & " [Redis (PID: " & $aServerPIDRedis & ")] Killing Process")
		ProcessClose($aServerPIDRedis)
	EndIf
	If ProcessExists($aServerPID00) Then
		FileWriteLine($aLogFile, _NowCalc() & " [Server 00 (PID: " & $aServerPID00 & ")] Warning: Shutdown failed. Killing Process")
		ProcessClose($aServerPID00)
	EndIf
	If $aServerQnty > 1 Then
		If ProcessExists($aServerPID10) Then
			FileWriteLine($aLogFile, _NowCalc() & " [Server 10 (PID: " & $aServerPID10 & ")] Warning: Shutdown failed. Killing Process")
			ProcessClose($aServerPID10)
		EndIf
	EndIf
	If $aServerQnty > 2 Then
		If ProcessExists($aServerPID01) Then
			FileWriteLine($aLogFile, _NowCalc() & " [Server 01 (PID: " & $aServerPID01 & ")] Warning: Shutdown failed. Killing Process")
			ProcessClose($aServerPID01)
		EndIf
	EndIf
	If $aServerQnty > 3 Then
		If ProcessExists($aServerPID11) Then
			FileWriteLine($aLogFile, _NowCalc() & " [Server 11 (PID: " & $aServerPID11 & ")] Warning: Shutdown failed. Killing Process")
			ProcessClose($aServerPID11)
		EndIf
	EndIf
FileWriteLine($aLogFile, _NowCalc() & " ---------- Server(s) shutdown sequence completed ----------")
	$aShutdown = 0
EndFunc   ;==>CloseServer

; -----------------------------------------------------------------------------------------------------------------------

Func SendDiscordMsg($sHookURLs, $sBotMessage, $sBotName, $sBotTTS, $sBotAvatar)
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
		$sResponseText = "Message Response: " & $oHTTPOST.ResponseText
	Next
	If $aDebug Then
		FileWriteLine($aLogFile, _NowCalc() & " [Discord Bot] Message Sent: """ & $sBotMessage & """ {" & $oStatusCode & "} " & $sResponseText)
	Else
		FileWriteLine($aLogFile, _NowCalc() & " [Discord Bot] Message Sent: """ & $sBotMessage & """")
	EndIf
EndFunc   ;==>SendDiscordMsg
#EndRegion ;**** Function to Send Message to Discord ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Send In-Game Message via MCRCON ****
Func SendInGame($mIP, $mPort, $mPass, $mMessage)
	FileWriteLine($aLogFile, _NowCalc() & " [In-Game Message Sent] " & $mMessage)
	RunWait(@ScriptDir & '\mcrcon.exe -c -s -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "broadcast ' & $mMessage & '"', @ScriptDir, @SW_HIDE)
EndFunc   ;==>SendInGame
#EndRegion ;**** Send In-Game Message via MCRCON ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Send RCON Command via MCRCON ****
Func SendRCON($mIP, $mPort, $mPass, $mCommand)
	Local $aMCRCONcmd = @ScriptDir & '\mcrcon.exe -c -s -H ' & $mIP & ' -P ' & $mPort & ' -p ' & $mPass & ' "' & $mCommand & '"'
If $aDebug Then
	FileWriteLine($aLogFile, _NowCalc() & " [RCON] " & $aMCRCONcmd)
Else
	FileWriteLine($aLogFile, _NowCalc() & " [RCON] Port:" & $mPort & ". Command:" & $mCommand)
EndIf
	RunWait($aMCRCONcmd, @ScriptDir, @SW_HIDE)
EndFunc   ;==>SendInGame
#EndRegion ;**** Send RCON Command via MCRCON ****

; -----------------------------------------------------------------------------------------------------------------------

#Region ;**** Functions to Check for Update ****

Func UpdateCheck()
	Local $bUpdateRequired = False
	If $aUpdateSource = "1" Then
		Local $aLatestVersion = GetLatestVerSteamDB($aSteamAppID, $aServerVer)
	Else
		Local $aLatestVersion = GetLatestVersion($aSteamCMDDir)
	EndIf
	Local $aInstalledVersion = GetInstalledVersion($aServerDirFull)
	SplashOff()
	If ($aLatestVersion[0] And $aInstalledVersion[0]) Then
		If StringCompare($aLatestVersion[1], $aInstalledVersion[1]) = 0 Then
			FileWriteLine($aLogFile, _NowCalc() & " Server is Up to Date. Installed Version: " & $aInstalledVersion[1])
		Else
			FileWriteLine($aLogFile, _NowCalc() & " Server is Out of Date! Installed Version: " & $aInstalledVersion[1] & " Latest Version: " & $aLatestVersion[1])
			Global $aBotMsg = $sAnnounceUpdateMessage
			Global $aUpdateVerify = "yes"
			$TimeStamp = StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_")
			Local $sManifestExists = FileExists($aSteamAppFile)
			If $sManifestExists = 1 Then
				FileMove($aSteamAppFile, $aServerDirLocal & "\steamapps\appmanifest_" & $aSteamAppID & "_" & $TimeStamp & ".acf", 1)
				If $aDebug = "yes" Then
					FileWriteLine($aLogFile, _NowCalc() & " Notice: """ & $aSteamAppFile & """ renamed to ""appmanifest_" & $aSteamAppID & "_" & $TimeStamp & ".acf""")
				EndIf
			EndIf
		EndIf
	ElseIf Not $aLatestVersion[0] And Not $aInstalledVersion[0] Then
		FileWriteLine($aLogFile, _NowCalc() & " Something went wrong retrieving Latest & Installed Versions. Running update with -validate")
		SplashTextOn($aUtilName, "Something went wrong retrieving Latest & Installed Versions." & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 500, 125, -1, -1, $DLG_MOVEABLE, "")
		Global $aBotMsg = $sAnnounceUpdateMessage
		$bUpdateRequired = True
	ElseIf Not $aInstalledVersion[0] Then
		FileWriteLine($aLogFile, _NowCalc() & " Something went wrong retrieving Installed Version. Running update with -validate. (This is normal for new install)")
		SplashTextOn($aUtilName, "Something went wrong retrieving Installed Version." & @CRLF & "(This is normal for new install)" & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 450, 175, -1, -1, $DLG_MOVEABLE, "")
		Global $aBotMsg = $sAnnounceUpdateMessage
		$bUpdateRequired = True
	ElseIf Not $aLatestVersion[0] Then
		FileWriteLine($aLogFile, _NowCalc() & " Something went wrong retrieving Latest Version. Running update with -validate")
		SplashTextOn($aUtilName, "Something went wrong retrieving Latest Version." & @CRLF & "- Running update with -validate" & @CRLF & @CRLF & "(Restart will be delayed if 'announce restart' is enabled)", 450, 125, -1, -1, $DLG_MOVEABLE, "") 5
		Global $aBotMsg = $sAnnounceUpdateMessage
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
	If $hBuildID <100000 Then
		MsgBox($mb_ok, "ERROR", "Error retrieving buildid via SteamDB website. THIS IS NORMAL for first run. Please visit " & $aURL & " in Internet Explorer to authorize your PC or use SteamCMD for updates." & @CRLF & "! Press OK to close " & $aUtilName & " !")
	EndIf
EndFunc   ;==>GetLatestVerSteamDB

Func GetLatestVersion($sCmdDir)
	Local $aReturn[2] = [False, ""]
	DirRemove($sCmdDir & "\appcache",1)
	DirRemove($sCmdDir & "\depotcache",1)
	$sAppInfoTemp = "app_info_" & StringRegExpReplace(_NowCalc(), "[\\\/\: ]", "_") & ".tmp"
	$aSteamUpdateCheck = '"' & @ComSpec & '" /c "' & $sCmdDir & "\steamcmd.exe"" +login anonymous +app_info_update 1 +app_info_print " & $aSteamAppID & " +app_info_print " & $aSteamAppID & " +app_info_print " & $aSteamAppID & " +exit > " & $sAppInfoTemp
	RunWait($aSteamUpdateCheck, $aSteamCMDDir)
	Local Const $sFilePath = $sCmdDir & "\" & $sAppInfoTemp
	;	Local Const $sFilePath = $sCmdDir & "\app_info.tmp"
	Local $hFileOpen = FileOpen($sFilePath, 0)
	Local $hFileRead1 = FileRead($hFileOpen)
	If $hFileOpen = -1 Then
		$aReturn[0] = False
	Else
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
		If $aDebug And $aServerVer = 0 Then
			FileWriteLine($aLogFile, _NowCalc() & " Update Check via Stable Branch. Latest version: " & $hBuildID)
		EndIf
		If $aDebug And $aServerVer = 1 Then
			FileWriteLine($aLogFile, _NowCalc() & " Update Check via Experimental Branch. Latest version: " & $hBuildID)
		EndIf
	EndIf
	FileClose($hFileOpen)
	If FileExists($sFilePath) Then
		FileDelete($sFilePath)
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

#Region	 ;**** Restart Server Scheduling Scrips ****
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

#EndRegion ;**** Restart Server Scheduling Scrips ****

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
#EndRegion ;**** _RemoteRestart ****

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
Local $aPassFailure[1][3] = [[0, 0, 0]]
Func MultipleAttempts($sRemoteIP, $bFailure = False, $bSuccess = False)
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

#Region ;**** Start Remote Restart if Enabled ****
Func RemoteRestartUse()
	If $aRemoteRestartUse = "yes" Then
		TCPStartup()
		Local $aRemoteRestartSocket = TCPListen($aRemoteRestartIP, $aRemoteRestartPort, 100)
		If $aRemoteRestartSocket = -1 Then
			MsgBox(0x0, "TCP Error", "Could not bind to [" & $aRemoteRestartIP & "] Check server IP or disable Remote Restart in INI")
			FileWriteLine($aLogFile, _NowCalc() & " Remote Restart Enabled. Could not bind to " & $aRemoteRestartIP & ":" & $aRemoteRestartPort)
			Exit
		Else
			FileWriteLine($aLogFile, _NowCalc() & " Remote Restart Enabled. Listening for Restart Request at " & $aRemoteRestartIP & ":" & $aRemoteRestartPort)
		EndIf
	EndIf
EndFunc   ;==>RemoteRestartUse
#EndRegion ;**** Start Remote Restart if Enabled ****

; -----------------------------------------------------------------------------------------------------------------------

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

	If $aExecuteExternalScript = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptDir & "\" & $aExternalScriptName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External BEFORE Update Script Not Found", "Could not find " & $aExternalScriptDir & "\" & $aExternalScriptName & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExecuteExternalScript = "no"
				FileWriteLine($aLogFile, _NowCalc() & " External BEFORE Update Script Execution Disabled - Could not find " & $aExternalScriptDir & "\" & $aExternalScriptName)
			EndIf
		EndIf
	EndIf

	If $aExecuteExternalScriptValidate = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptDirValidate & "\" & $aExternalScriptNameValidate)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External AFTER Update Script Not Found", "Could not find " & $aExternalScriptDirValidate & "\" & $aExternalScriptNameValidate & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExecuteExternalScriptValidate = "no"
				FileWriteLine($aLogFile, _NowCalc() & " External AFTER Update Script Execution Disabled - Could not find " & $aExternalScriptDirValidate & "\" & $aExternalScriptNameValidate)
			EndIf
		EndIf
	EndIf

	If $aExternalScriptUpdate = "yes" Then
		Local $sFileExists = FileExists($aExternalScriptUpdateDir & "\" & $aExternalScriptUpdateFileName)
		If $sFileExists = 0 Then
			SplashOff()
			Local $ExtScriptNotFound = MsgBox(4100, "External BETWEEN Updates Script Not Found", "Could not find " & $aExternalScriptUpdateDire & "\" & $aExternalScriptUpdateFileName & @CRLF & "Would you like to Exit Now to fix?", 20)
			If $ExtScriptNotFound = 6 Then
				Exit
			Else
				$aExecuteExternalScriptValidate = "no"
				FileWriteLine($aLogFile, _NowCalc() & " External BETWEEN Updates Script Execution Disabled - Could not find " & $aExternalScriptUpdateDir & "\" & $aExternalScriptUpdateFileName)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>FileExistsFunc
#EndRegion ;**** Check for Files Exist ****


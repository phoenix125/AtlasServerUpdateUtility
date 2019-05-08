AtlasServerUpdateUtility - A Utility to Keep Your Atlas Dedicated Server updated (and schedule server restarts, download and install new server files, and more!)
- Latest version: AtlasServerUpdateUtility_v1.5.4 (2019-05-06)
- By Phoenix125 | http://www.Phoenix125.com | http://discord.gg/EU7pzPs | kim@kim125.com
- Based on Dateranoth's ConanExilesServerUtility-3.3.0 | https://gamercide.org/

Sections: (Use Search CTRL-F to quickly access) 
- Features | Getting Started | Instructions | Tips & Comments | Known Bugs | Upcoming Features | Requested Features |  To Create Discord Webhook for announcements |
- How to Use This Util For Multi-Server Setups | Remote Restart Instructions | Download Links | Credits |
-  Questions & Answers | FYI: Details of How This Util Performs Certain Actions | Current beta Version Notes | Stable Version History |

----------
 FEATURES
----------
- Works with up to 400 grids (20x20).
- Works with multiple server PC systems (See "HOW TO USE THIS UTIL FOR MULTI-SERVER SETUPS" below)
- Optionally automatically check for mod updates, install them, announce the update to in-Game/Discord/Twitch, and restart the server. (Looks for ModIDS in ServerGrid.json only)
- Automatically imports available server data from ServerGrid.json & GameServerUser.ini files (if enabled).
- Optionally start selected gri﻿d servers only.
- GUI INTERFACE for server info only... no config GUI window yet. (Still incomplete). The util can still run without the GUI for minimalists.
- Send RCON commands/messages to select servers only.
- Send custom command lines PER GRID during server startup.
- Scheduled events: Send RCON commands to All or Local grids or run any file at scheduled times.
- OK to use with most other server managers: Use this tool to install and maintain the server and use your other tools to manage game play features.
- Automatically download and install a new Atlas Dedicated Server: No need to do it manually.
- Automatically keeps server updated.
- Announce server updates and/or restarts in game, on Discord and Twitch.
- KeepServerAlive: Detects server crashes (checks for AtlasGame.exe via PID) and will restart the server.
- User-defined scheduled reboots.
- Remote restart via web browser, including your phone.
- Send RCON commands via web browser, including from your phone.
- Run multiple instances of AtlasServerUpdateUtility to manage multiple servers.
- Clean shutdown of your server(s).
More detailed features:
- Optionally execute external files for seven unique conditions, including at server updates, mod updates, scheduled restarts, remote restart, when first restart notice is announced.
  *These options are great executing a batch file to disable certain mods during a server update, to run custom announcement scripts, make config changes (enable PVP at scheduled times), etc.

-----------------
 GETTING STARTED
-----------------
NEW SERVER INSTALLATION: (Using this utility to download and install server files - STILL REQUIRES MAP (SERVERGRID.JSON) FILES - Google "how to set up an atlas dedicated server")
1) Place AtlasServerUpdateUtility.exe into any folder and run it.
- The file "AtlasServerUpdateUtility.ini" will be created and the program will exit.
2) Modify the default values in "AtlasServerUpdateUtility.ini" settings. PRIORITY SETTINGS ARE: Atlas DIR, SteamCMD DIR.
3) Run AtlasServerUpdateUtility.exe again.
- The file "AtlasServerUpdateUtilityGridStartSelect.ini" will be created. This file determines which of the grids will be started.
4) Run AtlasServerUpdateUtility.exe yet again.
- It will download and install the Atlas server files then start Atlas Dedicated Server.
- Once the BIG WHITE ERROR SCREENS start showing up, click "Exit: shutdown servers" o=in the tray icon.
5) Copy your existing ServerGrid files/folders to '.\ShooterGame' folder.
6) Run AtlasServerUpdateUtility.exe one last time.
CONGRATS! Your server should be up-to-date and running!
- If you are still having the BIG WHITE ERROR SCREENS:
  - Look at the _SERVER_SUMMARY_.txt file created by this util for any possible config errors.
  - Make sure all QueryPorts, Ports, RCONs, and DIRs are unique.. no duplicates!  These values (except RCON) are all imported from the ServerGrid.json file.
  - Set the "SeamlessIP" to your WAN (external) IP address.
  - Make sure all your ports are forwarded by your router.
  - Look for errors in the ports in the ServerGrid.json file.

EXISTING SERVER INSTALLATION:
1) Place AtlasServerUpdateUtility.exe into any folder and run it.
- The file "AtlasServerUpdateUtility.ini" will be created and the program will exit.
2) Modify the default values in "AtlasServerUpdateUtility.ini" settings. PRIORITY SETTINGS ARE: Atlas DIR, SteamCMD DIR, AltSaveDirectoryName(s) (Leave blank if you used the default 00 01 02 10 11 12 etc folder naming structure).
3) Run AtlasServerUpdateUtility.exe again.
- The file "AtlasServerUpdateUtilityGridStartSelect.ini" will be created. This file determines which of the grids will be started. Make changes as needed.
4) Run AtlasServerUpdateUtility.exe yet again.
-  It will install any updates and start the server(s).
CONGRATS! Your server should be up-to-date and running! 

--------------
 INSTRUCTIONS
-------------- 
To shut down your server:
- Click on the AtlasServerUpdateUtility (phoenix) icon in bottom right taskbar and select EXIT.

To restart your server:
- Run AtlasServerUpdateUtility.exe

To send RCON message via web browser: (Requires Remote Restart Enabled)
- Enter the link into any web browser, http://ip:port/ServerPwd@RCON_Message  ex. http://8.8.8.8:57520/AdMiN_PaSsWoRd@SaveWorld
- To send [space], use [%] without brackets.  ex. http://12.34.56.78:57520/AdMiN_PaSsWoRd@broadcast%Admin%Says%Hi

To restart your server remotely from any web browser, including your phone, see REMOTE RESTART INSTRUCTIONS below.

-----------------
 TIPS & COMMENTS
-----------------
Comments:
- Place ModIDs in ServerGrid.json only.
- If running multiple instances of this utility, each copy must be in a separate folder.
- If running multiple instances of this utility, rename AtlasServerUpdateUtility.exe to a unique name for each server. The phoenix icon in the lower right will display the filename.
  For example: I run 6 servers, so I renamed the AtlasServerUpdateUtility.exe files to Atlas-STABLE.EXE, Atlas-EXPERIMENTAL.EXE, CONAN-2X.EXE, CONAN-PIPPI.EXE, CONAN-LITMAN.EXE, & ATLAS.EXE.
- If using the "Request Restart From Browser" option, you have to use your local PC's IP address as the server's IP. ex: "Server Local IP=192.168.1.10" (127.0.0.1 and external IP do not work).
Tips:
- Use the "Run external script during server updates" feature to run a batch file that disables certain mods during a server update to prevent incompatibilities.
- External script execution for mod updates Runs the external script when mod update discovered... while server is still running.

------------
 KNOWN BUGS
------------
### ISSUE ###
- An issue when SteamCMD does not update and validate files properly and therefore performs an update with every update check.

REASON: 
Short answer: Steamcmd is not properly put the latest "buildid" in the appmanifest.acf file after an update.
Long Answer:
- The appmanifest_1006030.acf file is created by steamcmd during updates.
- It is what my util uses to check for the latest version. It looks at the "buildid" "3594004" within that file.
- When my util notices an update is available, it renames this file (adds date & time) then runs steamcmd update again.
- When running steamcmd update, it sets "buildid" to "0" until the update is finished, then it puts the proper latest buildid there.
- For some reason, steamcmd sometimes does not replace the "0" with "3594004" (or latest number).

WORKAROUND:
- A temporary quick "fix" is to Rt-Click the AtlasServerupdateUtilkity (Phoenix) icon in bottom right and pause the utility.  It will no longer do anything, but your server(s) will stay running.
- A better workaround is:
  - Replace "D:\Game Servers\Atlas Dedicated Server\steamapps\appmanifest.acf" with a backup version that does not have the buildid as "0" in it.
  
### ISSUE ###
- Update problems when running Atlas and/or AtlasServerUpdateUtility in C:\ partition

REASON:
- It appears that Windows block certain files from being downloaded or created by AtlasServerUpdateUtility.

WORKAROUND:
- Install on another partition such as D:

-------------------
 UPCOMING FEATURES
-------------------
- Second Discord webhook for admin use (announce server info into a separate Discord channel)
- html and/or PDF documentation

--------------------
 REQUESTED FEATURES  (Unknown whether they'll get added or not)
--------------------
- Cross chat (I would probably use an existing cross chat util as a "plug in" to this util)
- 7zip backups
- CPU Affinity (Reports state that Atlas itself does a job with CPU, though, so not likely add this one)
- GUI interface (will take a while to get done)
- Activate only the server start point: When it detects that a player enters a grid, automatically start surrounding grid servers.
   (Not as great as it sounds... when someone logs off of a non-home server, that server would have to remain online. Eventually, all servers would need to remain online).

---------------------------------------------
 To Create Discord Webhook for announcements
---------------------------------------------
Discord announcements are handled through Discord webhooks.
To create a Discord webhook:
- In Discord, click the Settings gear icon of the desired Discord channel.
- Click webhooks.
- Create webhook.
- Copy and paste the new URL into the AtlasServerUpdateUtility.ini as "URL ###=".
- Then save and restart the AtlasServerUpdateUtility (does NOT require server restart).

----------------------------------------------
 HOW TO USE THIS UTIL FOR MULTI-SERVER SETUPS
----------------------------------------------
( Disclaimer: I am only running a 2x2 server on a single server. I have NO experience in running larger multi-server setups.)
( The following is only my best guess as to how to use this utility on multi-server setups.)

- Use the same ServerGrid.json file on each server.
- Install and run this utility on each server.
    - On first run, it will create the file "AtlasServerUpdateUtility.ini"
    - Edit this file to match your desired server settings. It is recommended to change the following:
        Atlas DIR ###=
        Autostart and keep-alive redis-server.exe? Use NO to manage redis-server.exe yourself (yes/no) ###=no
        Server AltSaveDirectoryName(s) (comma separated. Leave blank for default 00,01,10, etc) ###=	
            a. Type in the folder names of ALL servers here, including folders for remote servers.
              (This util pairs each folder entry to each server listed in ServerGrid.json, therefore even folders not used on the local server need to be entered) *OR*
            b. Leave this blank [recommended] and change your existing folders to match this util's default assignment: (00 10 20 30 01 02 03 etc.)
- Run the utility again to create the AtlasServerUpdateUtilityGridStartSelect.ini file.  This file is used to determine which grid servers start on the local server.
    - Edit this file. Type "no" to any of the grids being run on remote servers. The local server will only run the grids marked as "yes".

Below is an example of how to have this utility start your existing redis server:
- Create a batch file in the following folder (the util's default external script folder):
    D:\Game Servers\Atlas Dedicated Server\Scripts\beforesteamcmd.bat
    Edit beforesteamcmd.bat and include the following (changing it to point to your existing redis-server file, of course!)
        start cmd /k Call D:\Game Servers\Atlas Dedicated Server\AtlasTools\RedisDatabase\redis-server_start.bat 3333
- Edit AtlasServerUpdateUtility.ini as follows:
    [--------------- EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START ---------------]
    1-Execute external script BEFORE update? (yes/no) ###=yes
    1-Script directory ###=D:\Game Servers\Atlas Dedicated Server\Scripts
    1-Script filename ###=beforesteamcmd.bat

-----------------------------
 REMOTE RESTART INSTRUCTIONS
-----------------------------
====> Request Restart From Browser <====
- If enabled on the server, use to remotely restart the server (for multiple system setups).
- When restarting, an announcement will be made in-game, on Discord, and in Twitch if enabled, with the set duration of delay (warning).
- Set Password in INI file to save, or type each time.
- Restart using IP or Domain Name
- Restart commands are now expecting HTTP headers, and can be sent to the server from a web browser using the format http://IP:PORT?restart=user_pass. The utility will respond if the password is accepted or not. There is also a limit for max password attempts. After 15 tries in 10 minutes the requesting IP will be locked out for 10 minutes.
- 404 Responses will be sent if the RestartKey does not match or the header is incorrect. You can enable Debugging for a full output to the log what is being received by the server if you have any trouble.
- These Are the Allowed Characters in the RestartCode (Password) 1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!@$%^&*()+=-{}[]\|:;./?

Usage Example:
INI SETTINGS
[Game Server IP]
ListenIP=192.168.0.1
[Use Remote Restart ?yes/no]
UseRemoteRestart=yes
[Remote Restart Request Key http://IP:Port?RestartKey=RestartCode (Ex: 192.168.1.30:57520?restart=password)]
ListenPort=57520
RestartKey=restart
RestartCode=password

- You can have multiple passwords. For example: RestartCode=password1,pass2,pwd3
In a standard web browser, type in the URL http://192.168.1.30:57520?restart=password. The Server would compare the pass and find that it is correct. It would respond with 200 OK And HTML Code stating the server is restarting.

----------------
 DOWNLOAD LINKS
----------------
Latest Stable Version:    http://www.phoenix125.com/share/atlas/AtlasServerUpdateUtility.zip
Previous Stable Versions: http://www.phoenix125.com/share/atlas/atlashistory/
Latest Beta Version:      http://www.phoenix125.com/share/atlas/AtlasServerUpdateUtilityBeta.zip
Previous Beta Versions:   http://www.phoenix125.com/share/atlas/atlasbetahistory/
Source Code (AutoIT):     http://www.phoenix125.com/share/atlas/AtlasServerUpdateUtility.au3
GitHub:	                  https://github.com/phoenix125/AtlasServerUpdateUtility

Website: http://www.Phoenix125.com
Discord: http://discord.gg/EU7pzPs
Forum:   https://phoenix125.createaforum.com/index.php

More ServerUpdateUtilities available: 7 Days To Die and Conan Exiles.  Rust and Empyrion coming soon!

---------
 CREDITS
---------
- Based on Dateranoth's ConanExilesServerUtility-3.3.0
https://gamercide.org/forum/topic/10558-conan-exiles-server-utility/

---------------------
 Questions & Answers  Q&A from commonly asked questions
---------------------
(WORK IN PROGRESS)
What changes does the utility make to the Atlas GameUserSettings.ini, Game.ini, etc. files?
- The utility makes no direct changes to any of Atlas' config files. Anything added to the "Atlas extra commandline parameters ###=" will get added by Atlas itself.

How does the utility shut down the servers?
- I removed the SaveWorld command because it wasn't working last time I checked.  The DoExit and CTRL-X both force a SaveWorld ... I've tested them quite a bit. Even if the RCON ports are wrong, the CTRL-X should safely shutdown servers. 

--------------------------------------------------------
 FYI: DETAILS OF HOW THIS UTIL PERFORMS CERTAIN ACTIONS
--------------------------------------------------------

 INFORMATION ON IMPORTING DATA (Details on what information is imported and how it is used)
-------------------------------
The following information is imported from the ServerGrid.json:
 (All servers)
    "totalGridsX" - Used in combination with totalGridsY to calculate total number of servers.
    "totalGridsY" - Used in combination with totalGridsX to calculate total number of servers.
 (Each server)
    "ip"          - Used to determine each server's IP address (In command line, sent as 'SeamlessIP=')
    "port"        - Used to determine each server's port       (In command line, sent as 'QueryPort=')
    "gamePort"    - Used to determine each server's gameport   (In command line, sent as 'Port=')
 
The following information is imported from each grid server's GameUserSettings.ini (when available):
    "RCONPort"    - Used to determine each server's RCON port  (In command line, sent as 'RCONEnabled=True?RCONPort=')

The grid servers are started in the order they are listed in the ServerGrid.json file.

Here's how the utility imports and assigns folders, ports, grids, etc.:
- It opens the ServerGrid.json file and uses the "totalGridsX" and "totalGridsY" to calculate the total number of servers.
- Next, it skips to "servers": [ "
- Then reads the first "gridX" , "gridY" , "ip" , "port" , "gamePort".
- It then assigns the first folder listed under "Server AltSaveDirectoryName(s)" in AtlasServerUpdateUtility.ini to that server. The first server's information is now complete.
It then repeats this process for the remainder of the servers listed in the ServerGrid.json file.
- The utility continues to import the data for each server listed in ServerGrid.json, even if the server isn't used or is disabled.

 METHOD USED FOR UPDATING MODS (Details on how mods are downloaded and checked for updates)
-------------------------------
At very first run of the util, all mods will be downloaded and installed. This is necessary to create temp file(s) used to determine current version of each mod.
- The util downloads another util I created, AtlasModDownloader.exe, to perform the downloading and updating. (Python was much better at uncompressing the .z files than AutoIT).
- Each mod is updated one-at-a-time. AtlasModDownloader uses SteamCMD to download new mod content, move the folder content to ../content/mods folder, uncompress the .z files, then delete the SteamCMD cache folder.
- The app_manifest file created by SteamCMD will then be renamed and moved to the Util folder. This what my util uses to determine current installed version.

For update checks:
- The util goes to this website: http://steamcommunity.com/sharedfiles/filedetails/changelog/[MODID] to check for latest version.
- It then reads the mod_[MODID]_appworkshop.tmp (created each time a mod is downloaded) and compares the two. If the same, it skips.
- If different buildid, it reruns the AtlasModDownloader.exe program again which redownloads and installs the mod.
- It then makes any announcements (ingame, Discord, Twitch) and will restart all servers when the announcement times are fulfilled.

----------------------------
 CURRENT BETA VERSION NOTES (To download beta version, see LINKS section above)
----------------------------
- The STABLE version and BETA version are the same at this time.

------------------------
 STABLE VERSION HISTORY  (To download beta version, see LINKS section above)
------------------------
(2019-05-04) v1.5.5
- Added: Shut down all or select servers with/without announcement to Discord/Twitch/In-Game.
- Added: Optional automatic util update download and install with no user input. (Default is disabled).
- Added: Port duplicate checker: Checks for duplicate ports assigned in ServerGrid.json & RCON ports in .ini or GUS.ini files.
- Fixed: Remove trailing \t in SeamlessIP if present upon import. Does NOT alter the ServerGrid.json file.
- Added: Programmable utility update check interval. (Default is every 4 hours).
- Fixed: When util updates, the .ini config file automatically updates without user input. Previously, it still asked for user input sometimes.
- Fixed: Condition in which Remote Restart would not announce (If Announce Daily or Update were disabled)

*** New Config Parameters/Changes: ***
- "Check for AtlasServerUpdateUtility updates every __ hours (0 to disable) (0-24) ###=3
- "Automatically install AtlasServerUpdateUtility updates? (yes/no) ###=yes
- "Announcement _ minutes before STOP SERVER (comma separated 0-60) ###=1,3
- In-Game: "Announcement STOP SERVER (\m - minutes) ###=Server is shutting down in \m minute(s) for maintenance."
- Discord: "Announcement STOP SERVER (\m - minutes) ###=Server is shutting down in \m minute(s) for maintenance."
- Discord: "Send Discord message for STOP SERVER? (yes/no) ###=no"
- Twitch:  "Announcement STOP SERVER (\m - minutes) ###=Server is shutting down in \m minute(s) for maintenance."
- Twitch:  "Send Twitch message for STOP SERVER? (yes/no) ###=no"


(2019-05-04) v1.5.4 (Thanks to Norlinri for reporting both problems)
- Fixed: "Line 35734 Unbalanced brackets in expression" error fixed.
- Fixed: Prompt "Utility exited unexpectedly.. Close utility?" If (NO) was selected and you are using your own redis manager, then the util would shut down all servers when it was not supposed to.

(2019-05-04) v1.5.3
- Fixed? Attempt to fix Discord message error "0x80020009". Also added a lot more detail to error code in case this didn't fix the error.
- Added: Option to start all servers minimized. Added to config.ini: "Start servers minimized (for a cleaner look)? (yes/no) ###=yes"  (Thanks to Infiniti for requesting).
- Fixed: SeamlessDataPort now reports correctly in the _Server_Summary_.txt file.

(2019-05-04) v1.5.2
- Added: Server PID check: When started,  util checks to make sure assigned PIDs are actually Atlas servers.
- Added: Removes trailing \t in SeamlessIP if present upon import. Does NOT alter the ServerGrid.json file.
- Added: Adds the SeamlessDataPorts to the _Server_Summary.txt file.

(2019-04-29) v1.5.1
- Fixed: The Setup Wizard had several bugs that were fixed.
- Added: The util now creates batch files (in folder "Batch Files (to run Atlas manually)") to manually run and update your Atlas servers in case of SHTF (utility failure!)
- Fixed: When new mod(s) are added/discovered, the util previously did nothing. It will now restart the servers (with announcements if servers were already running).
- Changed: 32-bit (x86) version of the utility is once again the default. I received a couple reports of instability possibly related to the 64-bit (x64) version.
- Fixed: Update Mod button now disables if no mods are used or if "Use this util to install mods and check for mod updates (as listed in ServerGrid.json)? (yes/no) ###=no" (Thanks to funtimes for reporting).

(2019-04-28) v1.5.0
- Added: GUI INTERFACE for server info only... no config GUI window yet. (Still incomplete). The util can still run without the GUI for minimalists.
- Added: Setup Wizard. It is now MUCH easier now for new users to start using this utility.
- Added: New default AltSaveDIR naming scheme: A1,A2,A3,B1,B2,B3,C1,etc.
- Added: Send custom command lines PER GRID during server startup.
- Added: Separate log files for Basic logging and Full logging (formerly debug).
- Added: Option to send RCON commands/messages to select servers only.
- Added: New "_start_AtlasServerUpdateUtility.bat" file that updates with each util update. If desired, add a shortcut of this file to your startup folder.
- Added: Button and config option to poll Remote Servers for online players and whether online.
- Added: Upon starting, the util skips the update checks if the time since last server update check is less than the update check interval for a much faster util restart.
- Added: Displays memory & CPU usage for each server grid.
- Added: Log entry when a server crashes.
- Added: New window for viewing and/or editing log files, config files, ServerGrid.json, DefaultGame.ini, DefaultGameUserSettings.ini, DefaultEngine.ini files.
- Changed: Util will now default to 64 bit version (was 32 bit only). The ZIP file includes the 32 bit version for compatibility.
- Changed: Added date to log files and moved them to "\_Log\" folder.
- Changed: All log files are now automatically deleted if older than user specified number of days.
- Changed: Moved all temp and work files into "\AtlasUtilFiles\" folder.
- Changed: Moved all log files into "\_Log\" folder.
- Changed: Removed "Server Name", "Debug", "SteamDIR", "Rotate Log Files", from config.
- Changed: Hard-coded SteamCMD folder as "\SteamCMD\". to simplify installation and because sharing SteamCMD with other programs can cause issues.
- Added: Window showing online users. Updates every 60 seconds by default, but is user definable.
- Fixed: Tray icon is much more responsive.
- Added: Tray icon turns gray when util is busy. 
- Added: Discord announcement and display notification when servers online and ready for connection.
- Added: Logs when users come online or go offline in new log file "AtlasServerUpdateUtility_OnlineUserLog.txt".
- Added: Pause Utility. Pauses all functions.
- Added: Disable Server Update Check tray menu option.
- Added: Force Server Update Check tray menu option.
- Added: Beta version and Stable version selectability.
- Added: Util now creates backup Server and Redis PID files to help prevent duplicate servers from being started.
- Changed: If managing the redis server, the redis server now only shuts down when the user requests.  It does not shut down for updates, Remote Restart, etc.
- Added: New Online Players text file written with each update, "AtlasUtilFiles\AtlasServerUpdateUtility_OnlineUsers.txt".
- Added: Config updates will now update automatically without user input, unless a required parameter is added.
- Added: SteamID to Online Users window and logfile.
- Added: Restart Server Now tray option.

(2019-03-12) v1.4.7
- Fixed: Server updates were identified but SteamCMD never executed.

(2019-03-12) v1.4.6
- Fixed: New servers would keep starting even when existing ones were running.

(2019-03-12) v1.4.5
- Fixed: SteamCMD boot loop which occurred when first grid was disabled.
- Fixed: Minor log file corrections.

(2019-03-11) v1.4.4
- Fixed: Instanced where some grid servers wouldn't start after a server restart. (Windows, by chance, could assign the same PID to conhost.exe as a previously existing Shooter.exe during server reboots) (Thanks to GooberGrape [Discord] for reporting)
- Fixed: Wrong mod name announced after first announcement
- Fixed: A "Line x error" could occur if number of mod minutes exceeded the number of update minutes.

(2019-03-10) v1.4.3
- Added: On server shutdown, if server(s) fail to shutdown using "DoExit" command, then CTRL-C is also sent to running server(s) with each countdown.
- Changed: Changed the default folder naming scheme. Removed the preceding letter "a". [I don't know why I put it there to begin with]. Also added a util to convert existing servers to new naming scheme.
- Added: Optionally send KillWildDinos command on day and hour schedule.
- Fixed: Corrected the wording of the "Initiate Remote Restart" in tray icon.
- Fixed: Adding mod names to mod update announcements is now working.
- Added: Util updater can now automatically download, install, and run updated version without affecting running Atlas servers or redis.
- Added: Util update checks every 8 hours. Update checks can be disabled in the .ini file or by selecting (no) in the update check popup screen.

(2019-03-08) v1.4.2
- Fixed: 'Line 8970' error: Occurred when redis was disabled on this util.  (Thanks Bandit [Discord] for reporting and testing)

(2019-03-08) v1.4.1
- Added: You can now reboot the utility without shutting down your Atlas servers.  The util now checks for existing servers and redis using last PID.
- Fixed: `Line 10622 Error`. Occurred when SteamCMD failed to DL an update. I had two "& &" signs next to each other.

(2019-03-06) v1.4.0
- Added: Tray Icon menu and commands with option to send RCON and broadcast messages, Check for utility updates, and initiate a Remote Restart.
- Added: Latest mod & util versions do not save to a file... handled internally now.  This may help with mod update errors on some systems.
- Added: Mod names to mod update announcements.
- Added: Log file entry for mod update errors: "If running Windows Server, Disable ""IE Enhanced Security Configuration"" for Administrators (via Server Manager > Local Server > IE Enhanced Security Configuration)" (Thanks to @McK1llen [Discord] for providing solution)
- Removed: "Mods are up to date" log entry unless mods are truly up-to-date (I found another instance).
- Added: Util will remove "<-NO TRAILING SLASH AND USE FULL URL FROM WEBHOOK URL ON DISCORD" in the Discord webhook if left in there.
- Added: Remote Restart & Remote RCON links in "_SERVER_SUMMARY_.txt" file.
- Added: If util update is available, "__UTIL_UPDATE_AVAILABLE__.txt" file will be created in script folder. Once up-to-date, the file will be deleted automatically.


(2019-03-05) v1.3.6
- Added: User defined delay between grid server shutdowns on first shutdown attempt. Sends shutdown command to all grids every second afterward if servers fail to shutdown.
- Added: User defined "redis" folder.
- Added: User defined "FINAL WARNING! Rebooting server in 10 seconds... " message.
- Added: Option to add mod number in mod update announcements.
- Added: Creates "___INI_FAIL_VARIABLES___.txt" file when .INI MISMATCH occurs to indicate which parameter(s) need(s) to be edited.
- Added: Creates "_SERVER_SUMMARY_.txt" file containing all server summary information.
- Fixed: Line 10250 Error! [AltSaveDir ($tFilePath[$i] = $zServerDirLocal & "\ShooterGame\Saved\" & $zServerAltSaveDir[$i - 1] & "\Config\WindowsServer\GameUserSettings.ini)]
- Changed: Now checks for grid servers running when sending the shutdown command for first run.
- Fixed: Does not send RCON commands to disabled servers anymore.
- Changed: The .ini now correctly states that RCON Ports are to be in ServerGrid,json order.
- Changed: debug = yes by default.
- Removed: "Mods are up to date" log entry unless mods are truly up-to-date.
- Removed: "[Mod] Something went wrong downloading update..." log entry when "use mods = no".
- Added: Show AtlasModupdater commands in log.
- Added: If SteamCMD and/or first grid server fails three times in a row, the utility displays warning message and stops to prevent steamcmd update loops.
- Fixed: When update check fails to get latest version, a warning message is displayed but the utility continues to function and check for updates. Previously it would run close servers and perform SteamCMD update loops.
- Fixed: If update needed at utility start, utility immediately begins update. Previously, it would wait until next update check.
- Fixed: If SteamCMD or SteamDB detected server out of date, it waited until next update check.
- Changed: Improved wording for SteamDB update check to make the "Must use Internet Explorer" requirement more prominent.
- Fixed: SteamCMD extra command line parameters were not being used correctly.

(2019-02-26) v1.3.5
- Added: AtlasServerUpdateUtility update check and downloader.
- Added: Ability to send RCON commands via Remote Restart

(2019-02-26) v1.3.4
- Fixed: Delay between grid server starts is now working after updates/restarts.
- Fixed: Redis no longer reboots during server reboots
- Fixed: Another "Line xxx variable not assigned" error when installing new server.
- Fixed: Now downloads AtlasModDownloader.exe before checking for mods, if necessary.
- Changed: "Delay in seconds between grid server starts (0-600)" from (1-60) to (0-600). 

(2019-02-26) v1.3.3
- Fixed: Update restart delay where it would recognize an update but not perform the update until next update check.
- Fixed: Line 10202 error. (Occurred when installing a new server... A temporary setting was required for the "Update mods?" option.  (Thanks to Minku [Discord] for reporting)

(2019-02-25) v1.3.2
- Added: Option to assign RCON IP so that port forwarding of RCON ports is not necessary.

(2019-02-25) v1.3.1
- Changed 'Ocean' to 'ocean' in the server startup commandline.

(2019-02-24) v1.3.0
- Added: Mod support!! Optionally automatically check for mod updates, install them, announce the update, and restart the server.
- Added: External script execution for mod updates (Runs the external script when mod update discovered... while server is still running)
- Added: External script execution: Option to "Wait for script to finish before continuing".
- Minor log file and notification window improvements.

(2019-02-24) v1.2.5
- Fixed: Error when manually assigning AltSaveFolders (Thanks UPPERKING [PlayAtlas.com] for reporting)
- Clarified two .ini entries.
- Log file improvements

(2019-02-23) v1.2.4
- Fixed: The utility no longer checks for GameUserSettings.ini on disabled grid servers (Thanks UPPERKING [PlayAtlas.com] for reporting)
- Removed log entries for unused grid servers.
- Added: Optionally use a different redis config file


(2019-02-23) v1.2.3
- Fixed: "Atlas extra commandline parameters" always put a [space] at beginning of command. If "Atlas extra commandline parameters" starts with ? , the util will remove the [space]. (Thanks Doublee [Discord] for reporting)

(2019-02-22) v1.2.2
- Fixed (again): "Line 10255" error. Occurs when Steamcmd fails to provide latest server version during update check. The verification process was improved.
- Fixed: Problem attaining Query Port from ServerGrid.json if more entries containing "ip" were at front of file. (Thanks Doublee [Discord] for reporting)
- Fixed: Removed "No GameUserSettings.ini" warning during new install.

(2019-02-21) v1.2.1
- Fixed: Extra space and quotation mark at end of Atlas server command line. (Thanks to Minku [Discord] and Doublee [Discord] for noticing and reporting error)
- Added some instructions to this readme.txt

(2019-02-21) v1.2.0
- Added option to start selected grid servers only.
- Shutdown sequence now closes as soon as servers have completed saving world and continues to send "DoExit" command every second until servers shutdown.
- Added user-defined maximum time to wait for SaveWorld before forced shutdown (taskkill) of servers.
- Added more info to startup and shutdown sequence windows.

(2019-02-21) v1.1.5
- Added user-defined delay between grid server startups.
- Added ability to import RCON ports from GameServerUser.ini on existing servers. (Thanks to Minku [Discord] for the suggestion!)
- Fixed: Error when Steamcmd fails to provide latest server version during update check.
- Fixed: No longer need to delete RCON ports and AltSaveDir during new installation. 
- Eliminated: "Failed to start at least twice within 1 minute" warning message. 
  This was first implemented in my 7DTD util to prevent endless server startup loops when server updates change critical config info, but this feature does not appear necessary for Atlas.

(2019-02-17) v1.1.4
- Hotfix - Temporarily disabled the "failed to start at least twice within 1 minute" warning message.

(2019-02-17) v1.1.3
- Added option to disable redis-server.exe autostart & keep-alive.
- Added error message if number of AltSaveDirectory entries does not match number of grid servers. 

(2019-02-17) v1.1.2
- Now closes redis-server.exe AFTER shutting down Atlas servers (prevents popups when servers do not shut down properly)
- Added error message if number of RCON port entries does not match number of grid servers. 
- Added error message if Atlas servers do not shut down properly AND multi-home IP is NOT blank.
- When the .ini has changed, the utility will now give a brief description of what changes were added to the .ini.

(2019-02-17) v1.1.1
- Fixed: CRITICAL ERROR that caused "Assertion Failed: usGamePort != usQueryPort" error. I had reversed the GamePort & Queryport.  (Thanks to Sorori (Discord) for the help!)

(2019-02-16) v1.1.0
- Added *theoretical* support for up to 100 grids (10x10).
- Automatically imports available server data from ServerGrid.json.
- Added more information to log file and popup info screens. 

(2019-02-16) v1.0.4
- Added error message if Atlas Server (ShooterGameServer.exe) fails to start twice within 1 minute.

(2019-02-15) v1.0.3
- Fixed: Line 8918 Variable used without being declared (Yep.. another one)

(2019-02-14) v1.0.2
- Fixed: Line 8918 Variable used without being declared 

(2019-02-13) v1.0.1
- Fixed: Remote Restart was monitoring server IP instead of Remote Restart IP.

(2019-02-13) v1.0 Initial Release
- Works with 1-4 grids on same computer only.
- OK to use with most other server managers: Use this tool to install and maintain the server and use your other tools to manage game play features.
- Automatically download and install a new Atlas Dedicated Server: No need to do it manually.
- Automatically keeps server updated.
- Announce server updates and/or restarts in game, on Discord and Twitch.
- KeepServerAlive: Detects server crashes (checks for AtlasGame.exe and telnet response) and will restart the server.
- User-defined scheduled reboots.
- Remote restart (via web browser).
- Run multiple instances of AtlasServerUpdateUtility to manage multiple servers.
- Clean shutdown of your server(s).
More detailed features:
- Optionally execute external files for six unique conditions, including at updates, scheduled restarts, remote restart, when first restart notice is announced
  *These options are great executing a batch file to disable certain mods during a server update, to run custom announcement scripts, make config changes (enable PVP at scheduled times), etc.
- Can validate files on first run, then optionally only when buildid (server version) changes. Backs up & erases appmanifest.acf to force update when client-only update is released by The Fun Pimps.

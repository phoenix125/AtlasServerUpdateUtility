AtlasServerUpdateUtility - A Utility to Keep Your Atlas Dedicated Server updated (and schedule server restarts, download and install new server files, and more!)
- Latest version: AtlasServerUpdateUtility_v1.9.9a (2019-08-16)
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
- Optionally start selected grid servers only.
- GUI INTERFACE for server info only... no config GUI window yet. (Still incomplete). The util can still run without the GUI for minimalists.
- Send RCON commands/messages to select servers only.
- Send custom command lines PER GRID during server startup.
- Shut down all or select servers with/without announcement to Discord/Twitch/In-Game.
- Scheduled events: Send RCON commands to All or Local grids or run any file at scheduled times.
- OK to use with most other server managers: Use this tool to install and maintain the server and use your other tools to manage game play features.
- Automatically download and install a new Atlas Dedicated Server: No need to do it manually.
- Automatically keeps server and mods updated.
- Announce server updates and/or restarts in game, on Discord and Twitch.
- KeepServerAlive: Detects server crashes (checks for AtlasGame.exe via PID) and will restart the server.
- User-defined scheduled reboots.
- Remote restart via web browser, including your phone.
- Send RCON commands via web browser, including from your phone.
- Run multiple instances of AtlasServerUpdateUtility to manage multiple servers.
- Clean shutdown of your server(s).
- Programmable PER GRID start delay. (in GridStartSelect.ini).
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
- Click on the AtlasServerUpdateUtility (phoenix) icon in bottom right task bar and select EXIT.

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
- Update problems when running Atlas and/or AtlasServerUpdateUtility in C:\ partition, especially the Desktop.

REASON:
- It appears that Windows block certain files from being downloaded or created by AtlasServerUpdateUtility.

WORKAROUND:
- Install on another partition such as D:

----
 UPCOMING FEATURES
----
- html and/or PDF documentation

-----
 REQUESTED FEATURES  (Unknown whether they'll get added or not)
-----
- Cross chat (I would probably use an existing cross chat util as a "plug in" to this util)
- CPU Affinity (Reports state that Atlas itself does a job with CPU, though, so not likely add this one)

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

-
 HOW TO USE THIS UTIL FOR MULTI-SERVER SETUPS
-
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
            b. Leave this blank [recommended] and change your existing folders to match this utility's default assignment: (00 10 20 30 01 02 03 etc.)
- Run the utility again to create the AtlasServerUpdateUtilityGridStartSelect.ini file.  This file is used to determine which grid servers start on the local server.
    - Edit this file. Type "no" to any of the grids being run on remote servers. The local server will only run the grids marked as "yes".

Below is an example of how to have this utility start your existing redis server:
- Create a batch file in the following folder (the util's default external script folder):
    D:\Game Servers\Atlas Dedicated Server\Scripts\beforesteamcmd.bat
    Edit beforesteamcmd.bat and include the following (changing it to point to your existing redis-server file, of course!)
        start cmd /k Call D:\Game Servers\Atlas Dedicated Server\AtlasTools\RedisDatabase\redis-server_start.bat 3333
- Edit AtlasServerUpdateUtility.ini as follows:
    [ EXECUTE EXTERNAL SCRIPT BEFORE SteamCMD UPDATE AND SERVER START ]
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

--------------------------------------------------------
 Questions & Answers  Q&A from commonly asked questions
--------------------------------------------------------
(WORK IN PROGRESS)
What changes does the utility make to the Atlas GameUserSettings.ini, Game.ini, Engine.ini, ServerGrid.json, etc. files?
- The utility makes no direct changes to any of Atlas' config files, unless using the Grid Configurator. Anything added to the "Atlas extra commandline parameters ###=" will get added by Atlas itself.

How does the utility shut down the servers?
- The SaveWorld command does not work with Atlas. The RCON "DoExit" and Alt-F4 both force a SaveWorld.
- The util also monitors the [mapname].atlas file fro each grid. It ensures the file has changed (a SaveWorld started) and that it has finished saving before task killing the grids.
1. The util first sends RCON "DoExit". This forces a Save World.
2. After a definable time, if "DoExiy" fails, it then sends Alt-F4 to each stuck grid (which is the same as clicking the "X" [Close] button). This also forces a Save World.
3. If that also fails, it will then Task Kill the grid.

--------------------------------------------------------
 FYI: DETAILS OF HOW THIS UTIL PERFORMS CERTAIN ACTIONS
--------------------------------------------------------
 INFORMATION ON IMPORTING DATA (Details on what information is imported and how it is used)
-
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
-
At very first run of the util, all mods will be downloaded and installed. This is necessary to create temp file(s) used to determine current version of each mod.
- The util downloads another util I created, AtlasModDownloader.exe, to perform the downloading and updating. (Python was much better at uncompressing the .z files than AutoIT).
- AtlasModDownloader uses SteamCMD to download new mod content, move the folder content to ../content/mods folder, uncompress the .z files, then delete the SteamCMD cache folder.
- The app_manifest file created by SteamCMD will then be renamed and moved to the Util folder. This what my util uses to determine current installed version.

For update checks:
- The util goes to this website: http://steamcommunity.com/sharedfiles/filedetails/changelog/[MODID] to check for latest version.
- It then reads the mod_[MODID]_appworkshop.tmp (created each time a mod is downloaded) and compares the two. If the same, it skips.
- If different buildid, it reruns the AtlasModDownloader.exe program again which re-downloads and installs the mod.
- It then makes any announcements (In-Game, Discord, Twitch) and will restart all servers when the announcement times are fulfilled.

-------------
 CURRENT BETA VERSION NOTES (To download beta version, see LINKS section above) or http://www.phoenix125.com/share/atlas/AtlasServerUpdateUtilityBeta.zip
-------------
- The STABLE version and BETA version are the same at this time.

---------
 STABLE VERSION HISTORY  (To download beta version, see LINKS section above)
---------
v1.9.9c (2019-08-16) Minor backup tweak.
- Fixed: If a redis-server was started, any reboot in process would be stopped. (Thanks to MsgAmmo for reporting)
- Fixed: Improved the "existing redis-server.exe" detection. Also now checks for existing redis-server every time it attempts to restart. (Thanks to MsgAmmo for reporting)
- Fixed: Improved the "Existing grid server" detection slightly.

v1.9.9b (2019-08-16) Minor backup tweak.
- Added: User-definable 7zip backup command line. (Thanks to Foppa for requesting)
[ New Config Parameters/Changes ]
BACKUP -> 7zip backup additional command line parameters (Default: a -spf -r -tzip -ssw) ###=a -spf -r -tzip -ssw

v1.9.9a (2019-08-16) Minor tweaks.
- Added: Blackwood Wizard: Added "AltSaveDIR" option. (Thanks to NEITFALL for reporting)
- Changed: Wizard: Changed the "Coming Soon!" description for Blackwood to the intended text. (Thanks to NEITFALL for reporting)
- Fixed: Util Update: The util wasn't completing the shutdown before running updated util. (Unfortunately, this won't help until NEXT update.)
- Added: Added Blackwood icon to "Select Wizard".

v1.9.9 (2019-08-16) New Blackwood Wizard! Try the new Blackwood map!
- Added: Blackwood Wizard!
- Fixed: Setup Wizard: If GridStartSelect file was too big, you could not edit the data. Buffer limit is now increased.
- Fixed: Setup Wizard: When closed during startup, the startup info screen was not displayed.
- Fixed: Line 36135 error when NOT using the "Poll Online Players" option. (Thanks to Eggonomicon for reporting)
- Added: When clicking button to open a window that is already open, that window will now to put to front.
- Added: Grid Configurator: "NetServerMaxTickRate" (Thanks Anorak for requesting) and "NoSeamlessServer" to default parameter list.

v1.9.8 (2019-08-12) More minor bug fixes and improvements.
- Added: Startup logo.
- Added: A Preview to the Blackwood Wizard! (in other words, I ran out of time to finish it.. lol)
- Fixed: Change Windows Priority: If enabled, it added log entries with every check instead of only when changes were made.
- Fixed again: Line 44680 (or close) error due to failure to get Memory Usage of a grid. If the error occurs, the util just won't show the affected grid's usage instead of crashing. (Thanks to Sgt. Rock and OG | The Owl Sky for reporting)
- Changed: Status announcements & log entries: Remote grids will now show "PID [Remote]" instead of "PID []". (Thanks to Nyt and AceMan for reporting)
- Fixed: Grid Configurator: Start Server button wasn't working.
- Fixed: "Daily restart skipped..." message was being sent even if grids were restarted, if they restart process took less than one minute. (Thanks to Nyt for reporting)
- Changed: Crash Watchdog: Added Online Player Check interval to the "Minutes to wait for RCON response before restarting grid" to prevent premature shutting down of grid. (Thanks to Nyt for inspiring)
- Fixed: Status: Sometimes the status would update before a grid was restarted, causing extra "Starting, Running, Starting" announcements.  (Thanks to Nyt and AceMan for reporting)
- Added: Util Already Running Detection: Added a second detection to help eliminate duplicate starts of the util. (Thanks to Infiniti for reporting)
- Added: Discord: If "Poll Remote Servers" is enabled, then you can now decide whether to wait for all remote grids to come online before announcing all servers are online. (Dedicated to AceMan)

[ New Config Parameters/Changes ]
DISCORD INTEGRATION -> Send Discord message: Wait for REMOTE grids to be online before [All servers are back online] announcement? (yes/no) ###=no

v1.9.7b (2019-08-10) Quick fix of Grid Auto Detect & Batch file change.
- Fixed: Grid auto-detected would crash or simply not work.
- Changed: If a grid is auto-detected, it now sets it to start in the GridStartSelect.ini file.
- Changed: Batch files: The util now makes batch files for ALL grids, a new "Launch_Atlas Select.bat" file for enabled grids and the "Launch_Atlas All.bat" now includes ALL grids.

v1.9.7a (2019-08-10) Quick Fix.
- Fixed: Line 44680 (or close) error due to failure to get Memory Usage of a grid. If the error occurs, the util just won't show the affected grid's usage instead of crashing. (Thanks to Sgt. Rock and OG | The Owl Sky for reporting)

v1.9.7 (2019-08-10) Critical Hotfixes! Shutdown sequence had several bugs.
- Fixed: Shutdown: Fixed several issues with the shut down sequence. (Thanks to Nyt, AceMan, OG | TheOwlSky, and many others for reporting)
- Changed: Crash Watchdog: The "timer" for unresponsive grids now starts after all grids have started. Servers with many grids and.or long waits between starts previously would time out prematurely. (Thanks to Nyt for reporting)
- Changed: KeepAlive: Improved the detection of a running KeepAlive program for shutdown. (Thanks to Infiniti for reporting)
- Changed: If a server restart is in progress (ie. a 10 minute wait after first Discord announcement), and another restart gets scheduled (ie. Mod update), the util will not restart timer anymore. (Thanks to Nyt for requsting)
- Fixed: ServerGrid.json new or removed mod: Fixed another instance that this would fail. (Thanks to Infiniti for reporting)
- Added: Rt-Click: Added option to send announcement when "Stop Grid" is selected.
- Added: Duplicate grid start prevention: Before starting ANY grid, the util makes sure one isn't already running for that grid location. (Disables if Multiple Instances of Util is enabled)

v1.9.6 (2019-08-08) Hotfixes. Fixed Restart and Stop grid buttons, error if ServerGrid.json has "Templates Section, Extra grid starts.
- Fixed: "Restart Grids" was always only restarting A2. (Thanks to Nyt, JOEW ALABEL, and others for reporting)
- Fixed: Rt-Click: "Stop Grid", "Start Grid", and "Restart Grid" were not working properly. (Thanks to Nyt, JOEW ALABEL, and others for reporting)
- Fixed: Mods: If latest version of mod not found, the util reported it as an update and restarted. (Thanks to Linearburn for reporting)
- Fixed: If ServerGrid.json has "  "serverTemplates": [" section, the util now ignores it completely. (Thanks to Daniel W for reporting and Daniel & Doublee for helping solve)
- Fixed: Extra grids were being started after a server restart. (Thanks to Infiniti for reporting)

v1.9.5 (2019-08-05) Improved Game Save reliability. New Parameter Editor. Minor big fixes.
- Added: Grid Shut Down: The util now monitors the [map].atlas file to ensure a game save has started and continues to make sure it has finished saving before task-killing grid. (Thanks to Nyt for reporting Game Save problems & AceMan/Nyt for helping with solution)
- Fixed: Undefined variable when editing a read-only file and have:
	"If GUS, Game, Engine, ServerGrid,json file is read-only, 1-Overwrite file, 2-Skip file, or 3-Ask every time (1-3) ###=1" (Thanks to Sgt.Rock for reporting)
- Added: "Detailed Log" entry added when Alt-F4 is used to shut down a server (after "DoExit" has failed). (Thanks to Nyt for reporting)
- Fixed: If Lower Priority is changed from yes to no, all grid priority will be set to normal. (Thanks to Anorak for reporting)
- Fixed: Line 47763 Undefined Variable error. Occurred when editing the "Added Commandline (This Grid)" in Grid Configurator. (Thanks to noelpy for reporting)
- Fixed: Grid Configurator: If a parameter was blank, such as "name": "", ASUU would blank that line in the ServerGrid.json.
- Added: Now notifies if ServerGrid.json file has mismatch in number of parameters, such as Port, Name, Gameport, SeamlessData, etc.
- Updated: Link to Atlas Setup Guide in Setup Wizard has been updated. (Thanks to SRZ and Demens for reporting)
- Added: Grid Configurator: Added "Parameters Editor". Easily edit the parameters list for customization. Don't forget, you can share the parameter file, too!

[ New Config Parameters/Changes ]
GAME SERVER CONFIGURATION -> Seconds allowed for GameSave before sending Alt-F4 (Close Window) to servers during reboots (10-600) ###=60
GAME SERVER CONFIGURATION -> Number of 3 second attempts to ensure game save has completed (1-99) ###=10

v1.9.4 (2019-07-22) Hotfixes. Set priority to Low on empty grids, Fixed support for 15x15 grids, Fixed Multiple Instances
- Added: Optionally set Windows priority to low/idle on empty grids.
- Added: Option to send Grid Status updates for Local, Remote, or Both. Previously sent messages for both. (Thanks to AceMan for noticing issues)
- Fixed: Start batch file: If using 64-bit version, the batch file will now update to run the 64-bit version.
- Fixed: Large ServerGrid.json files, such as the official 15x15, were too large for AutoIT to process. The util now trims the data down internally to only what it needs. This takes a little longer, but works :) (Thanks to Temil2006 for reporting)
- Fixed: When starting servers, the log states restarting. (Psychoboy & Nyt)
- Fixed: "Allow multiple instances of AtlasServerUpdateUtility": One section was missed when set to no. (Thanks to Nyt for reporting)
- Fixed: KeepUtilAlive: Several bug fixes. Now restarts util like it should; properly shuts down; Text fits into window, If util paused, KeepUtilAlive also pauses. (Thanks to @Infiniti for reporting failure to restart)
- Fixed: Main Window: When changing from Local to Remote or vice versa, both checks marks were displaying. Unused check mark is now removed. (Thanks to AceMan for reporting)

[ New Config Parameters/Changes ]
GAME SERVER CONFIGURATION -> Set Windows priority to Low/Idle on grids with no players? (yes/no) ###=no
ANNOUNCEMENT CONFIGURATION -> Send Grid Status for grids: Local, Remote, or Both? (local, remote, both) ###=local

v1.9.3 (2019-07-18) Crash Watchdog, Rt-Click Menu, Improved shutdown, Some hotfixes.
- Added: Right-click on server name to bring up a pop up menu with Send RCON, Send Msg, Restart, Stop, Start, Grid Configurator for that specific grid cell (Thanks to @Nyt for requesting)
- Added: Crash Watchdog: Uses Online Player poll to check for frozen grid. If no response in 5 minutes, or a lost response for 2 intervals (time and count user-definable), the util will restart the froze grid. (Thanks to Infiniti and others for requesting)
- Added: Crash Watchdog: If a grid still freezes after three restarts in 30 minutes (count and time user-definable), the affected grids will be disabled to stop restart looping.
- Added: Restart sequence (announcements with delay) are now skipped if all grids are offline. (Thanks to @Colvr for reporting)
- Added: Freeport grids are now started first. (Thanks to Deviliath for requesting)
- Added: SteamCMD Update: If update fails, the util now deletes the \SteamCMD folder and re-downloads all steamcmd files. Also leaves last .tmp file for troubleshooting. (Thanks to @AceMan for inspiring).
- Changed: Changed the secondary close grid method from CTRL-C to Alt-F4, which is comparable to clicking the X (Close) which still forces a game save. (Tested!)
- Fixed: The "Skip daily restarts" had a typo. Other improvements were made, too. It should work as intended now.
- Fixed: Send Msg to Select Servers was not adding "broadcast " before the command, thereby not sending the message.
- Fixed: When starting a grid, the Status would not display "Starting".
- Fixed: Grid Configurator: If "Start grid at startup" was changed to yes, the util reported it as crashed when starting.
- Fixed: Setup Wizard: More bug fixes. (Thanks to Karl Tibbs for reporting issue if no ServerGrid.json file exists)

[ New Config Parameters/Changes ]
CRASH WATCHDOG -> Number of failed RCON attempts (after grid had responded at least once) before restarting grid (0-Disable, 0-5) (Default is 2) ###=2
CRASH WATCHDOG -> Minutes to wait for RCON response before restarting grid (0-Disable, 0-10) (Default is 5) ###=5
CRASH WATCHDOG -> Number of crashes before disabling grid (0-Disable, 0-5) (Default is 3) ###=3
CRASH WATCHDOG -> Minutes the crashes have to occur within before disabling grid (5-720) ###=30
CRASH WATCHDOG -> Send In-Game announcement to ALL grids when grid is disabled due to too many crashes (yes/no) ###=no
CRASH WATCHDOG -> In-Game announcement when grid is disabled due to too many crashes (\g - grids) ###=Grid (\g) Disabled due to crashes.
CRASH WATCHDOG -> Send Discord announcement when grid is disabled due to too many crashes (yes/no) ###=no
CRASH WATCHDOG -> WebHook number(s) to send Discord announcement to (Comma separated. Blank for none) (1-3) ###=
CRASH WATCHDOG -> Discord announcement when grid is disabled due to too many crashes (\g - grids) ###=Grid (\g) Disabled due to crashes.

v1.9.2 (2019-07-13) Discord Hotfix!
- Fixed: "DiscordMainWHSel" parameter window that pops up with util restarts which caused all Discord announcements to fail.
- Added: Skip daily restarts if all servers restarted within _ minutes with optional Discord announcement. (Thanks to @Nyt for requesting)
- Added: Cancel Restart button with optional announcements.

[ New Config Parameters/Changes ]
	SCHEDULED RESTARTS -> Skip scheduled restart if servers restarted within _ minutes (0-720) ###=60
	DISCORD INTEGRATION -> Send Discord message for Skip scheduled restart if servers restarted recently? (yes/no) ###=no
	DISCORD INTEGRATION -> Announcement Skip scheduled restart if servers restarted recently ###=Daily restart skipped because servers restarted recently.
	IN-GAME ANNOUNCEMENT CONFIGURATION -> Announcement Skip scheduled restart if servers restarted recently ###=Daily restart skipped because servers restarted recently.

v1.9.1 (2019-07-13) Tiny potential hotfixes.
- Changed: Discord: Added "Comma separated" to each Discord webhook selection. (Thanks to Nyt for suggesting)
- Fixed: Removed any special characters from Online Players names for stability. (Thanks to Nyt for reporting)
- Changed: A ghost click was moved in the main window in an attempt to fix main window issues a couple people are having. Clicked cells will remain highlighted. (Thanks to AceMan and Psychoboy for reporting)

v1.9.0 (2019-07-11) 2 Hotfixes & a 3rd Discord Webhook.
- Added: Third Discord Webhook (Thanks to Linearburn for requesting)
- Fixed: Discord Log Message: If the log entry has quotes " in it, the Discord message gets messed up.
- Fixed: Backup: Backup should work as intended now. I also removed the \* requirement for folders. (The util will automatically add the trailing *)

v1.8.9 (2019-07-10) Another Hotfix
- Fixed: Line error 42279 Undefined variable. (Thanks to noelpy for reporting)

v1.8.8 (2019-07-10) Quick Hotfix
- Fixed: If "Include SteamID" was disabled, then the Online Players log would write an entry with every check.

v1.8.7 (2019-07-10) Two Hotfixes, Setup Wizard, and Grid Configurator improvements.
- Fixed: Line 42204 Undefined variable error. (Thanks to Noelpy for reporting)
- Fixed: Resizing the main window could fail to resize properly. (Thanks to Doublee for reporting).
- Added: Grid Status now includes "No Response" when a grid fails an RCON "ListPlayers" response.
- Fixed: (Hopefully) Randomly, some grids will switch to "Starting" status then "Ready" for no apparent reason. (Thanks to Inifini and Nyt for reporting)
- Added: Discord: Optionally send all log entries to selected Discord Webhook. (Thanks to Linearburn for requesting)
- Added: Backup: Option to manually perform a "save folder only" or a "Full Atlas folder" backup. (Inspired by Anorak1313)
- Fixed: Grid Configurator: Only files that are modified are backed up now. Was previously backing up all files.
- Fixed: Grid Configurator: "Added Commandline This Grid" was not always updating the GridStartSelect file properly.
- Added: Grid Configurator: Now shows commandline for each grid. (Thanks to Nyt for requesting)
- Added: Setup Wizard: RCON port generator option. (Thanks to Nyt for requesting)
- Added: Setup Wizard: Grid Start options to start all local grids or disable all grids. Also, grids default to disabled for new installs. (Thanks to Nyt for inspiring)
- Added: Option to Include SteamID or not in logs and in Online PLayers window. (Thanks to Nyt for requesting)
- Added: If Atlas password has a question mark ? in it, the util ignores the ? and sends a log warning message. (Thanks to Infiniti for reporting)

v1.8.6 (2019-07-05) Hotfixes
- Added: Added the option to send in-game select restart messages to all grids or only the affected grids. (Thanks to Nyt for requesting)
- Fixed: Online Players window was not updating. (Thanks to Nyt for reporting)
- Fixed: Error with in-game select grid restart announcement. (Thanks to Nyt for reporting)
- Changed: Changed the wording of Restart Grids in the config file to reflect the \g - grid substitution option.

v1.8.5 (2019-07-04) Hotfixes. Added "Restart Grid","Start With Windows", better Discord Webhook management. Read-Only file options.
- Added: Read-Only: (and all other attributes) are retained when working with GameUserSettings.ini, Game.ini, Engine.ini, ServerGrid.json, and default files. (AceMan)
- Added: Read-Only: If GameUserSettings.ini, Game.ini, Engine.ini, ServerGrid.json, and default files are Read-only, the util will ask to overwrite or use user-defined preset value. (Nyt)
- Added: Start with Windows option in .ini file and Setup Wizard (Thanks to @SłȺᵾǥħŧɇɍ fro requesting)
- Fixed: Setup Wizard Tab 2 AltSaveDIR: It would always use Custom Method 1 and the Folders list would often have duplicates. (Thanks to Kara for reporting)
- Added: "Restart ALL grids" and "Restart This Grid" buttons to configurator and "Restart Select Grids" button added to main window. (Thanks to AceMan, Nyt, and others for requesting).
- Fixed: All grids: "Send Msg" and "Send RCON" Line 41993 Error (Thanks to Infiniti for reporting)
- Added: Discord: Grid Status: Added two more text replacement options: Announcement grid status (\g - server, \s - status, \f - folder name, \n - server name) (Thanks to Linearburn for requesting)
- Added: Discord: New option: WebHook to send GENERAL messages to: 0-Disable, 1-WebHook Main, 2-WebHook Status, 3-Both ###=1
- Fixed: Discord: Minor tweak to response to hopefully improve reliability. (Thanks to Infiniti for reporting continued errors)
- Fixed: Discord: Grid name is added to announcement when "Stop Server" button is used in Grid Configurator. (Thanks to AceMan for reporting)
- Fixed: Discord: Grids duplicated in shutdown announcements: "(C2) (C2) Shutting down..." (Thanks to Nyt & Psychoboy for reporting)
- Fixed: Discord: WebHook 2 now ignores <-NO TRAILING SLASH AND USE FULL URL FROM WEBHOOK URL ON DISCORD. Default value changed for new users. (Thanks to Linearburn for reporting)
- Fixed: When Poll Online Players is Disabled, Grid Status in main window would show "starting" (Thanks to Anorak for reporting)
- Fixed: Grid Configurator: During parameter changes, the log logged the active grid for all parameter changes, instead of the affected grids. (Thanks to AceMan for reporting)

[ New Config Parameters/Changes ]
	GAME SERVER CONFIGURATION | Start AtlasServerUpdateUtility with Windows? (yes/no) ###=no
	ANNOUNCEMENT CONFIGURATION | Announcement grid status (\g - server, \s - status, \f - folder name, \n - server name) ###
	IN-GAME ANNOUNCEMENT CONFIGURATION | Announcement RESTART GRIDS (\m - minutes) ###
	DISCORD INTEGRATION | Send Discord message for RESTART GRIDS? (yes/no) ###
	DISCORD INTEGRATION | Announcement RESTART GRIDS (\m - minutes) ###
	DISCORD INTEGRATION | Announcement RESTART GRIDS when No Online Players ###
	DISCORD INTEGRATION | WebHook to send GENERAL Messages to: 0-Disable, 1-WebHook Main, 2-WebHook Status, 3-Both ###=1
	TWITCH INTEGRATION | Send Twitch message for RESTART GRIDS? (yes/no) ###
	TWITCH INTEGRATION | Announcement RESTART GRIDS (\m - minutes) ###
	TWITCH INTEGRATION | Announcement RESTART GRIDS when No Online Players ###
	AtlasServerUpdateUtility MISC OPTIONS | If GUS, Game, Engine, ServerGrid,json file is read-only, 1-Overwrite file, 2-Skip file, or 3-Ask every time (1-3) ###=3

v1.8.4 (2019-06-28) Many Hotfixes. Fixed Backups. Added GRID CRASH announcements. Improved Discord reliability.
- Added: User-definable "Server status labels (Comma separated. Defaults: Starting, Ready,CRASHED,Offline,Disabled,Poll Off) ###="Starting,Ready,CRASHED,Offline,Disabled,Poll Off (Thanks to Nyt for requesting)
- Fixed: Backups: Added 0 to disable Full Atlas backups (Thanks to Infiniti for requesting)
- Fixed: Backups: The Full Atlas and Util folder backup every __ backups was backing up the backups. (Excludes backup files now)
- Fixed: Backups: For additional folders/files, removed the quotes requirement.. it was causing issues.
- Fixed: "WebHook to use for error messages: 0-Disable, 1-WH Main, 2-WH Error, 3-Both ###=0" now defaults to zero. (Thanks to AceMan for reporting)
- Fixed: "Restart NOW" button would sometimes only shut down servers and not restart.
- Fixed: When new mods were detected while util running, new mods weren't downloaded. (Thanks to Infiniti for reporting)
- Added: Added name of selected servers to announcements when "Stop Server(s)" button used.
- Fixed: Remote Restart was getting shut down with any server shutdown.
- Fixed: "Atlas server online and ready for connection" announcement was once again announcing when only shutting down a server.
- Added: Optionally send CRASHED grid server status updates to Main and/or Status Discord webhook and/or In-Game. (Notify your players that a grid crashed and is restarting, then ready).
- Fixed: Grids sometimes would not restart after a crash detected. 
- Fixed: When all grids were disable, the Online Players log would write "[Online Players]  " with every check.
- Added: Announcement options added for immediate restarts ("0 minute(s)" when no online players). (Thanks for Doublee for reporting)
- Added: Second notice when shutting down servers, "Are you sure you want to shut down all servers?". (Thanks to AceMan for pointing out potential disaster)
- Added: Improved Discord response detection. Also, added a second attempt using DiscordSendWebhook.exe. If that fails, will use alternative method once. (Thanks to AceMan for reporting Discord issues still)
- Fixed: Broadcast scheduled event was opening and closing the "RCON command to send" window, but was not sending anything. (Thanks to Norlinri for reporting)

[ New Config Parameters/Changes ]
	AtlasServerUpdateUtility MISC OPTIONS | Server status labels Main Window (Comma separated. Default:Starting,Running,CRASHED,Offline,Disabled,Poll Off) ###=Starting,Ready,CRASHED,Offline,Disabled,Poll Off
	AtlasServerUpdateUtility MISC OPTIONS | Server status labels Announcements (Comma separated. Default:Starting,Ready,CRASHED,Offline,Disabled,Poll Off) ###=Starting,Ready,CRASHED,Offline,Disabled,Poll Off
	DISCORD INTEGRATION | Announcement DAILY when No Online Players ###=Daily server restart begins now.
	DISCORD INTEGRATION | Announcement UPDATES when No Online Players ###=A new server update has been released. Server is restarting now.
	DISCORD INTEGRATION | Announcement REMOTE RESTART when No Online Players ###=Admin has requested a server reboot. Server is restarting now.
	DISCORD INTEGRATION | Announcement STOP SERVER when No Online Players ###=Servers shutting down for maintenance.
	DISCORD INTEGRATION | Announcement MOD UPDATE when No Online Players (\x - Mod ID) ###=Mod \x released an update. Server is restarting now.
	TWITCH INTEGRATION | Announcement DAILY when No Online Players ###=Daily server restart begins now.
	TWITCH INTEGRATION | Announcement UPDATES when No Online Players ###=A new server update has been released. Server is restarting now.
	TWITCH INTEGRATION | Announcement REMOTE RESTART when No Online Players ###=Admin has requested a server reboot. Server is restarting now.
	TWITCH INTEGRATION | Announcement STOP SERVER when No Online Players ###=Servers shutting down for maintenance.
	TWITCH INTEGRATION | Announcement MOD UPDATE when No Online Players (\x - Mod ID) ###=Mod \x released an update. Server is restarting now.
	DISCORD INTEGRATION | Webhook to send CRASHED GRID Status Messages to: 0-Disable, 1-WebHook Main, 2-WebHook Status, 3-Both ###=0
	ANNOUNCEMENT CONFIGURATION | Announcement Grid Status (\g - server, \s - status) ###=(\g) Grid server status: \s
	IN-GAME ANNOUNCEMENT CONFIGURATION | Announce CRASHED GRID Status (notify when crash, restarting, and ready)(yes/no) ###=yes

v1.8.3 (2019-06-28) New! Detects running servers. Map name came be changed. Mod \x fixed. Server status change Discord announcements. More backup options.
- Added: Now checks for existing grids servers & redis-server and auto-assigns Process ID (PID) if possible to reduce duplicate server starts.
- Added: User-Definable map name added to in config: "Map Name ###=ocean" (Added option to change the Ocean part of the launch command). (Thanks to Colvr for requesting)
- Added: Backup: Added Multiple comma-separated folders  to backups. (Thanks to Infiniti for requesting)
- Added: Backup: Added "Full Atlas and Util folder backup every __ backups (1-99) ###"
- Changed: Backup: Disabled the timeout countdown timer so that the util can resume its functions without waiting for the backup to finish.
- Fixed: Line 43805 Error during Setup Wizard. (Thanks to Nyt for reporting)
- Fixed: "Mod \x released" announcements. (Thanks to Doublee and others for reporting)
- Changed: At util start, if any grid servers are started, it skips the initial Online Player check to speed up startup process. (Thanks to TheOgoPogo for requesting)
- Added: The util now checks for mod changes in the ServerGrid.json file and will download & install new mods (or remove them) then reboot the servers with announcements.
- Added: "Allow multiple instances of AtlasServerUpdateUtility? (yes/no) ###=no". Disables KeepAlive and Auto-Detect of running servers/Redis when PID file is corrupt.
- Added: Discord notification for grids crashing, restarting, disabled, and running. Optionally send message to a second Discord webhook, the main one, or both. (Thanks to Nyt & Infiniti for most recently requesting)
- Changed: Added a "Starting" status when the grid is starting but not ready for connection. Requires Poll Online Players enabled.
- Fixed: Main Window Status color didn't change when grid was Disabled.
- Fixed: Main Window Run status didn't update when changed.

[ New Config Parameters/Changes ]
	AtlasServerUpdateUtility MISC OPTIONS | Allow multiple instances of AtlasServerUpdateUtility? (yes/no) ###=no
	GAME SERVER CONFIGURATION | Map Name ###=ocean
	ANNOUNCEMENT CONFIGURATION | Announcement _ minutes before MOD LIST UPDATE reboot (comma separated 0-60) ###=1,2,5
	IN-GAME ANNOUNCEMENT CONFIGURATION | Announcement MOD LIST CHANGE (\m - minutes, \x - Mod ID) ###=Server Mod List changed. \x. Server is rebooting in \m minute(s).
	TWITCH INTEGRATION | Announcement MOD LIST CHANGE (\m - minutes, \x - Mod ID) ###=Server Mod List changed. \x. Server is rebooting in \m minute(s).
	DISCORD INTEGRATION | Announcement MOD LIST CHANGE (\m - minutes, \x - Mod ID) ###=Server Mod List changed. \x. Server is rebooting in \m minute(s).
	BACKUP | Full Atlas and Util folder backup every __ backups (1-99) ###=10
	BACKUP | Additional backup folders / files (in quotes, comma separated) ###=example: "C:\Temp","D:\Atlas"
	DISCORD INTEGRATION | WebHook 1 Main URL ###=(Previous Discord Webhook)
	DISCORD INTEGRATION | WebHook 2 Error Message URL (optional) ###=(Previous Discord Webhook)
	DISCORD INTEGRATION | WebHook to use for error messages: 0-Disable, 1-WH Main, 2-WH Error, 3-Both ###=1
	DISCORD INTEGRATION | Bot Name ###=Atlas Server
	DISCORD INTEGRATION | Bot 1 Main Name ###=(Previous Bot Name)
	DISCORD INTEGRATION | Bot 2 Error Name ###=Atlas Server Status

v1.8.2 (2019-06-25) Hotfix & Automatically closes the "AtlasGame has stopped working" window in case of grid crash.
- Fixed: If "Poll Online Players"=no (disabled), then the util would skip announcements during reboots. (Thanks to Anorak1313 for reporting)
- Added: Automatically closes the "AtlasGame has stopped working" window in case of grid crash. (Thanks to Telco for requesting)

v1.8.1 (2019-06-24) Hotfix
- Fixed: All Grids "Send RCON" was not working. (Thanks to infiniti for reporting)

v1.8.0 (2019-06-24) Hotfix
- Fixed: Line 45521 error when clicking on MOTD. (Thanks to infiniti for reporting)

v1.7.9 (2019-06-23) Hotfixes
- Fixed: Line x error when using Send RCON clicked. (Thanks to Nyt for reporting)
- Fixed: Event scheduler RCON commands would open the "RCON command to send to all grids" window. (Thanks to Norlinri for reporting)
- Changed: Added a timeout for all question windows, so that util resumes running when an input window is not completed. (Thanks to Norlinri for reporting)
- Added: Restart Now button now asks if you want to send a Discord announcement.
- Changed: Restart Now now restarts the servers immediately instead of waiting the default 10 seconds for the main window to refresh. (Thanks to Nyt for reporting)
- Fixed: When shutting down servers from main window, the "Atlas servers online and ready for connection" Discord message would send. (Thanks to Nyt for reporting)

v1.7.8 (2019-06-23) Several Hotfixes, including "!! ERROR !!! Could not find GameUserSettings.ini error".
- Fixed: Grid Configurator:
	-Params "changed count" did not include Command Line params. 
	-Command Line params now have bold text. 
	-Changed wording of log entries for consistency.
	-New parameters were not being added to blank GUS, Game, and Engine files.
	-If GameUserSettings.ini file did not exist on any local grids (ie. disabled grids), the util would give an error message. (Thanks to Deviliath for reporting).
	-Changed: The Grid Configurator can now modify all grids, including Remote grids by creating the Save folder and placing the files there.
- Fixed: Several bugs with the setup wizard. (Thanks to [A1] Steel for reporting).

v1.7.7 (2019-06-20) Grid Configurator Phase II Done!
- Added: Finished the Grid Configurator!  You can now quickly see/edit popular parameters and copy them to all/some grids.
- Fixed: KeepUtilAlive could activate during grid startups.
- Fixed: If no players are online, now makes a one-time announce to Discord/Twitch before restarting servers (to alert players wanting to connect).

Grid Configurator Notes:
- Parameters can be modified and shared to fit your needs.
- To revert back to default values (the ones I put in), just delete or rename GridParameters.csv and the util will create the default one.
- Add all your custom parameters to easily view the parameter settings on all your grids.
- Parameter text in green=has a value set.  Gray=No value set for that grid.
  File: "\_Config\GridParameters.csv". Edit with a spreadsheet (Excel) for easy view or use any text editor. Comma separated values.
  File key: "[Highlight],[ParamName],[DefaultValue],[File],[HeadingInFile],[Description]"
   Example: "True,Message,Welcome to your favorite Atlas server!,3,[MessageOfTheDay],Set message of the day (MOTD)"

v1.7.6 (2019-06-14) Minor Hotfix. Added Restart Util and Servers buttons to most editable windows.
- Fixed: v1.7.5 moved the main .exe file to the \Previous_Versions folder. (Thanks to Doublee and Psychoboy for reporting).
- Added: Restart Util and Servers buttons to most editable windows.
- Changed: All Grids: Send Msg and Send RCON now ask whether to send to Local only or Local & Remote grids (if remote grids present). (Thanks to Psychoboy for requesting).

v1.7.5 (2019-06-14) Greatly reduced Main Window update time. Several bug fixes and optimizations. 
NOTICE!! Config folder was renamed from "\Config" to "\_Config" to place config folder at top.
- Added: User-definable number of Online Players RCON retries. Default: 3 retries.
- Changed: Config folder was renamed from "\Config" to "\_Config" to place config folder at top.
- Added: Util now runs all update checks when started, but skips them if util is restarted & not due for an update check yet. (Thanks to Doublee for reporting issues when skipping update check).
- Added: If 0 players are online, announcements are skipped during server restarts. (No need to wait to restart/update when empty!) (Thanks to Doublee for requesting).
- Added: "Previous_Versions" Folder: On first ever run of this version, all older AtlasServerUpdateUtility_v(x).exe files will be moved to "Previous_Versions" folder and only the previous version will be moved with future auto-updates. (Thanks to Doublee and others for requesting).
- Fixed: During backups, Discord & Twitch announcements were not working correctly. (Thanks to Psychoboy for reporting).
- Changed: Faster main window updates when servers are disabled.
- Changed: Added more color to buttons: Red=Server Reboot, Yellow=UTIL reboot, Green=Server Start.
- Added: Every time when checking for Atlas updates via steamcmd, the util now checks for valid install of steamcmd. (Thanks to Inity for discovering).
- Added: More detailed information in status indicator during Main Window Updates.
- Fixed: The Atlas Server Version in window title now updates with all server restarts. (Thanks to Inity & AceMan for reporting).
- Fixed: Util line error if Remote Restart Port was <10000 and another used port ended in same port #.  Ex. RR Port 8000, but if another used port was 18000 or 28000, etc. , the util would error.

v1.7.4 (2019-06-12) Hotfix: Fixed Grid Configurator alignment when more than 30 grids are used.
- Fixed: Grid Configurator alignment when more than 30 grids are used.

v1.7.3 (2019-06-11) New Grid Configurator Phase I !
- Added: Grid Configurator Phase I: Easily view and edit common grid files. Phase II will have configurable common Atlas settings.
- Fixed: If server startup sequence took a long time, the KeepAlive util would restart the util.
- Fixed: A few minor issues if trying to open menus/windows more than once.

v1.7.2 (2019-06-09) Added programmable Broadcast Message display duration!
- Added: You can now set the approximate duration that messages sent in-game will be displayed.
         (The util adds extra spaces before and after the message which causes Atlas to display the message longer). (Thanks to Norlinri for requesting).

[ New Config Parameters/Changes ]
	[ IN-GAME ANNOUNCEMENT CONFIGURATION ]
	Approximate duration to display messages in-game (seconds)? (6-30) ###=15

v1.7.1 (2019-06-09) Scheduler Hotfix.
- Fixed: Several bugs with the Event Scheduler. (Thanks to Norlinri for reporting).
- Added: Minutes option to DestroyWildDinos. (Thanks to Norlinri for requesting).

[ New Config Parameters/Changes ]
	[ SCHEDULED DESTROYWILDDINOS ]
	Send DestroyWildDinos minute (0-59) ###=00

v1.7.0 (2019-06-08) Hotfixes. Fixed several bugs with new installation. Added config files to backups.
- Added: Backup now includes the AtlasServerUpdateUtility.ini and AtlasServerUpdateUtilityGridStartSelect.ini files. (Thanks to Linearburn for requesting).
- Changed: Backup now includes full path for all files for easier restoration of files. 
- Added: Checks for "Atlas\ShooterGame" in .ini under install DIR and removes the "\ShooterGame" part. (Thanks to TheOgopogo for reporting).
- Fixed: Line 40293 error due to unassigned Event Scheduler default values with new installation. (Thanks to TheOgopogo for reporting).
- Fixed: Several bug fixes and improvements for new installations.
- Changed: Online Players GUI and Main GUI buttons / Tray options never disable anymore. (Thanks to Psychoboy for reporting GUI issues).

v1.6.9 (2019-06-06) Backup tweaks. NOTICE!! Config files were moved to "\Config" Folder!! Online Players now checks twice if needed.
- Changed: The AtlasServerUpdateUtility.ini and AtlasServerUpdateUtilityGridStartSelect.ini files were moved to \Config folder for permissions purposes and to clean up install folder. (Thanks to Linearburn for requesting).
- Added: Added redis folder to backup. (You can manually set the redis backup folder if you manage the redis-server yourself).
- Added: When Backup initiated, optionally send announcement in-game, Discord, and/or Twitch. (Thanks to Dead Duck for requesting).
- Changed: Backup zip window is now hidden during automated backups.
- Fixed: Number of backups to keep (1-999) ### is now operational.
- Changed: After checking for Online Players, if any failed, the util now waits one second then tries the failed grid(s) once more.
- Changed: Improved Online Players log to only chart changes in online players (removed duplicate entries).

[ New Config Parameters/Changes ]
	[ BACKUP ]
	Redis folder (leave blank to use redis folder above or to disable) ###=
	In-Game announcement when backup initiated (Leave blank to disable) ###=Server backup in progress.
	Discord announcement when backup initiated (Leave blank to disable) ###=
	Twitch announcement when backup initiated (Leave blank to disable) ###=

	[ ATLASSERVERUPDATEUTILITY MISC OPTIONS ]
	Folder to place config files ###=

v1.6.8 (2019-06-02) Critical Hotfix if using KeepUtilAlive. Also added new Atlas Scheduler (Work in Progress: Only backs up at this time).
- Added: Atlas Backup with Scheduler. Still a Work In Progress: It only backs up at this time. Eventually a full recovery will be available. Also max backups not operation yet.
- Fixed: KeepUtilAlive would timeout if long mod downloads or shutdown.

	[ New Config Parameters/Changes ]
	[ BACKUP ]
	Use scheduled backups? (yes/no) ###=yes
	Backup days (comma separated 0-Everyday 1-Sunday 7-Saturday 0-7 ex.2,4,6) ###=0
	Backup hours (comma separated 00-23 ex.04,16) ###=06,12,18,00
	Backup minute (00-59) ###=00
	Output folder ###=D:\Game Servers\AtlasServerUpdateUtility\Backups
	Number of backups to keep (1-999) ###=56
	Max time in seconds to wait for backup to complete (30-999) ###=300

v1.6.7 (2019-06-01) Hotfixes. Mod Updater now has 3rd update check method and updates when the .mod file is missing from the Atlas Mod folder.
- Added: KeepUtilAlive now checks for AtlasServerUpdateUtility crashes and hangs.
- Added: Added a third option for checking for mod updates using wget.exe to hopefully eliminate the "IE Enhanced Security Configuration" error.
- Added: The Main Window refresh rate is now user-programmable. Default is 10 seconds.
- Fixed: Line 37544 and Line 40541 errors. A parenthesis ")" was missing in a line in the upgrade process. (Thanks to zozoman for reporting).
- Fixed: "Poll Remote Servers" was not correctly being checked at util startup. (Thanks to AceMan for reporting).
- Fixed: If 2 or mods are updated, it would only announce the first mod being updated. (Thanks to GooberGrape for reporting).
- Fixed: When a ".mod" file is deleted from the Atlas Mods folder after the util last updated the mod, it will now redownload and install the mod. (Thanks to Doublee for reporting).
- Fixed: Servers would not restart if "Announcement _ minutes before" only had only one number.
- Fixed: When servers are restarting, the Status indicator now says "Starting" instead of "CRASHED".

	[ New Config Parameters/Changes ]
	- Update the Main Window data every __ seconds (2-60) ###=10

v1.6.6 (2019-05-29) Critical Hotfix again. Fixed "Line 37744" error.
- Fixed "Line 37744" error. (Thanks to AceMan, Inity, and others for reporting).
- Added: Warning message on Setup Wizard when # of AltSafeDIRs does not match number of grids in ServerGrid.json. (Thanks to Kara for reporting).

v1.6.5 (2019-05-28) Critical Hotfix for Mod Users!
- Fixed: Mod Updater was failing on many mods. I changed the search criteria and hopefully fixed it.

v1.6.4 (2019-05-28)
- Added: Select All, Select None, Invert added to main GUI (Thanks to Shadowsong & Doublee for requesting).
- Added: "Start All Servers" button to main GUI (Thanks to Norlinri for requesting).
- Fixed: When all servers were disabled (unchecked), the "All servers online" Discord announcement was being sent. (Thanks to Norlinri & Dead Duck for reporting).
- Fixed: Fixed a possible cause of "Util update check failed to download latest version" failure.
- Added: Added User-defined RCON and Online Players check response wait time to hopefully help solve the "Online Players Count" failures.
- Fixed: When shutting down select servers, the countdown timer would go real slow. (Thanks to Infiniti for reporting).
- Fixed: Startup delay per grid was only working on initial startup. It is now working for all startups.
- Added: Added parenthesis around server IDs in announcements when shutting down select servers. ex: (A1 A2 B1 B2) Server is shutting down in 1 minute(s) for maintenance.
- Added: Added more log info when Online players check fails.
- Changed: The util no longer downloads AtlasModDownloader.exe or UtilityKeepAlive.exe unless used.
- Changed: If KeepUtilAlive fails (usually due to Windows Defender) then the util will disable it.

- Scheduler changes:
	- Send multiple RCON commands in each event.
	- Send custom Discord and In-game announcements with events.
	- Optionally reboot servers after event.
	- Scheduler now can be programmed by day of month and by the month.
	- A temporary basic schedule is displayed showing scheduled events in order.

v1.6.3 (2019-05-21) Quick Fix for Line error and Selecting grids on main GUI
- Fixed: Selecting grids on main GUI no longer has pop up window.
- Fixed: For about 30 minutes, I had uploaded the wrong test version which caused a line error.

v1.6.2 (2019-05-20) Minor "feel good" tweaks.
- Added: Manual Online Players update / refresh button. (Thanks to Doublee for requesting).
- Added: Finished Setup Wizard! You can now enter RCON ports and AltSaveDIR with server prompts.
- Fixed: Config editor window is now resizable.
- Fixed: The Online Players window can now be minimized.
- Fixed: When "Check for Atlas Updates = no", the util would still check for updates upon util shutdown. (Thanks to telco for reporting).
- Changed: When resizing main window, the "Total Players" is now centered.
- Fixed: Added a second AtlasKeepAlive shutdown routine to hopefully prevent multiple AtlasUtil restart.

v1.6.1 (2019-05-19) Several hotfixes and new Programmable Grid-Specific start delay, ExportData folder, Programmable mod download timeout.
- Fixed: GridStartSelect.ini: When disabling servers from the main window, it would write A1 A2 or 00 01 instead of 0,0 0,1. (Thanks to GooberGrape for reporting).
- Added: Startup delay between grids can now be grid-specific in the GridStartSelect.ini. (Thanks to Kara for requesting).
- Added: WorldFriendlyName (your server's name) and installed Atlas version to the utility's window title. (Thanks to Doublee for requesting).
- Fixed: When starting grids from the main window, they were previously hidden... now they start minimized.
- Fixed: Shutdown sequence is now faster. (Timers now subtract the RCON "DoExit" response time from overall shutdown delay time).
- Added: User-defined timeout timer for downloading mod updates. Default is 10 minutes.
- Added: ExportData folder containing the latest Online Players count and all the data from the main GUI table.
- Fixed: If using User-Defined redis folder, then the redis server is now started within that folder. (Thanks to Temil2006 for reporting).

v1.6.0 (2019-05-17) Several minor improvements and new "KeepUtilAlive", "Force update with -validate" option, "Network Connections Viewer"
- Fixed: Log/Ini window now is faster and resizable.
- Added: New warning message when ModIDs has an extra comma before the last quote. (Thanks to Reaper for reporting)
- Added: New option to force update Atlas with -validate. (Thanks to Doublee for requesting)
- Fixed: When checking for online players, the util waits up to 5 minutes for servers to come online before writing log entries.
- Added: If servers are to be started, a new 10 second window appears allowing the ability to cancel: helpful to prevent duplicate server starts. (Thanks to Norlinri for requesting)
- Added: Update icon in main window now shows exclamation point if utility update is available.
- Added: If Remote Restart port is in use upon util startup, it now asks if you want to close the program causing the interference.
- Added: "Send Discord" now uses the old method as a backup in case the new method fails.
- Added: Server name to logfile for in-game messages.
- Fixed: When | (vertical bar) was in a server name, it would cause the program to crash. (Thanks to Slaughter for reporting)
- Added: KeepUtilAlive: An optional second program is now executed to restart util if util crashes.
- Added: New warning message when more than one instance of the util is running.
- Added: Network Connections Viewer in Tools section. Displays all ports used by the local computer.
- Added: Grid Server Names was added to server_summary.txt file.

(2019-05-12) v1.5.7 Hotfix! Fixed some Discord announcement errors.
- Added: New "Send Discord" program was added for announcements. (Coming soon: the old method will be used as a backup once I get the bugs worked out.)
- Fixed: Fixed various Discord announcement errors that would cause the util to crash.
- Added: There are now two download sources for mcrcon.exe, AtlasModDownloader.exe, steamcmd.exe, and the new DiscordSendWebhook.exe... in case my main website is ever down.
- Changed: You can now continue the util after a "TCP Port in Use error" occurs, although the Remote Restart web interface will not function.

(2019-05-11) v1.5.6 Minor hotfixes and a couple new features.
- Changed: Duplicate Port Checker is no longer run at start of util.  It can now be manually run within the new Tools menu.
- Added: New Tools Button. Moved Duplicate Port Checker, Setup Wizard, Create Batch Files, Create Server Summary File to Tools menu.
- Added: Responses to RCON commands and Broadcast messages are now displayed.
- Fixed: Remote Restart failures: Line 36583 and possibly others. (I accidentally deleted a line). (Thanks Shadowsong & McK1llen for reporting).
- Added: Default grid naming scheme options for Announcements and Util/Log: "Server naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###=2", "Announcement naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###=2" (Thanks Shadowsong for requesting).

	[ New Config Parameters/Changes ]
	- Grid naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###=2
	- Announcement grid naming scheme: Use (1) 00 01 (2) A1 A2 (3) 0,0 0,1 ###=2

(2019-05-08) v1.5.5 
- Added: Shut down all or select servers with/without announcement to Discord/Twitch/In-Game.
- Added: Optional automatic util update download and install with no user input. (Default is disabled).
- Added: Port duplicate checker: Checks for duplicate ports assigned in ServerGrid.json & RCON ports in .ini or GUS.ini files.
- Fixed: Remove trailing \t in SeamlessIP if present upon import. Does NOT alter the ServerGrid.json file.
- Added: Programmable utility update check interval. (Default is every 4 hours).
- Fixed: When util updates, the .ini config file automatically updates without user input. Previously, it still asked for user input sometimes.
- Fixed: Condition in which Remote Restart would not announce (If Announce Daily or Update were disabled)

	[ New Config Parameters/Changes ]
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
- Changed: 'Ocean' to 'ocean' in the server startup commandline.

(2019-02-24) v1.3.0
- Added: Mod support!! Optionally automatically check for mod updates, install them, announce the update, and restart the server.
- Added: External script execution for mod updates (Runs the external script when mod update discovered... while server is still running)
- Added: External script execution: Option to "Wait for script to finish before continuing".
- Changed: Minor log file and notification window improvements.

(2019-02-24) v1.2.5
- Fixed: Error when manually assigning AltSaveFolders (Thanks UPPERKING [PlayAtlas.com] for reporting)
- Changed: Clarified two .ini entries.
- Changed: Log file improvements

(2019-02-23) v1.2.4
- Fixed: The utility no longer checks for GameUserSettings.ini on disabled grid servers (Thanks UPPERKING [PlayAtlas.com] for reporting)
- Removed: log entries for unused grid servers.
- Added: Optionally use a different redis config file


(2019-02-23) v1.2.3
- Fixed: "Atlas extra commandline parameters" always put a [space] at beginning of command. If "Atlas extra commandline parameters" starts with ? , the util will remove the [space]. (Thanks Doublee [Discord] for reporting)

(2019-02-22) v1.2.2
- Fixed: (again): "Line 10255" error. Occurs when Steamcmd fails to provide latest server version during update check. The verification process was improved.
- Fixed: Problem attaining Query Port from ServerGrid.json if more entries containing "ip" were at front of file. (Thanks Doublee [Discord] for reporting)
- Fixed: Removed "No GameUserSettings.ini" warning during new install.

(2019-02-21) v1.2.1
- Fixed: Extra space and quotation mark at end of Atlas server command line. (Thanks to Minku [Discord] and Doublee [Discord] for noticing and reporting error)
- Added: some instructions to this readme.txt

(2019-02-21) v1.2.0
- Added: option to start selected grid servers only.
- Shutdown sequence now closes as soon as servers have completed saving world and continues to send "DoExit" command every second until servers shutdown.
- Added: user-defined maximum time to wait for SaveWorld before forced shutdown (task-kill) of servers.
- Added: more info to startup and shutdown sequence windows.

(2019-02-21) v1.1.5
- Added: user-defined delay between grid server startups.
- Added: ability to import RCON ports from GameServerUser.ini on existing servers. (Thanks to Minku [Discord] for the suggestion!)
- Fixed: Error when Steamcmd fails to provide latest server version during update check.
- Fixed: No longer need to delete RCON ports and AltSaveDir during new installation. 
- Eliminated: "Failed to start at least twice within 1 minute" warning message. 
  This was first implemented in my 7DTD util to prevent endless server startup loops when server updates change critical config info, but this feature does not appear necessary for Atlas.

(2019-02-17) v1.1.4
- Hotfix - Temporarily disabled the "failed to start at least twice within 1 minute" warning message.

(2019-02-17) v1.1.3
- Added: option to disable redis-server.exe autostart & keep-alive.
- Added: error message if number of AltSaveDirectory entries does not match number of grid servers. 

(2019-02-17) v1.1.2
- Now closes redis-server.exe AFTER shutting down Atlas servers (prevents pop ups when servers do not shut down properly)
- Added: error message if number of RCON port entries does not match number of grid servers. 
- Added: error message if Atlas servers do not shut down properly AND multi-home IP is NOT blank.
- When the .ini has changed, the utility will now give a brief description of what changes were added to the .ini.

(2019-02-17) v1.1.1
- Fixed: CRITICAL ERROR that caused "Assertion Failed: usGamePort != usQueryPort" error. I had reversed the GamePort & Queryport.  (Thanks to Sorori (Discord) for the help!)

(2019-02-16) v1.1.0
- Added: *theoretical* support for up to 100 grids (10x10).
- Automatically imports available server data from ServerGrid.json.
- Added: more information to log file and pop up info screens. 

(2019-02-16) v1.0.4
- Added: error message if Atlas Server (ShooterGameServer.exe) fails to start twice within 1 minute.

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
- KeepServerAlive: Detects server crashes (checks for AtlasGame.exe and RCON response) and will restart the server.
- User-defined scheduled reboots.
- Remote restart (via web browser).
- Run multiple instances of AtlasServerUpdateUtility to manage multiple servers.
- Clean shutdown of your server(s).
More detailed features:
- Optionally execute external files for six unique conditions, including at updates, scheduled restarts, remote restart, when first restart notice is announced
  *These options are great executing a batch file to disable certain mods during a server update, to run custom announcement scripts, make config changes (enable PVP at scheduled times), etc.
- Can validate files on first run, then optionally only when buildid (server version) changes. Backs up & erases appmanifest.acf to force update when client-only update is released by The Fun Pimps.

AtlasServerUpdateUtility - A Utility to Keep Your Atlas Dedicated Server updated (and schedule server restarts, download and install new server files, and more!)
- Latest version: AtlasServerUpdateUtility_v1.3.0 (2019-02-24)
- By Phoenix125 | http://www.Phoenix125.com | http://discord.gg/EU7pzPs | kim@kim125.com
- Based on Dateranoth's ConanExilesServerUtility-3.3.0 | https://gamercide.org/

----------
 FEATURES
----------
- Works with up to 100 grids (10x10).  (As of v1.1.0, it is untested whether it will work on multiple system setups).
- Optionally automatically check for mod updates, install them, announce the update to in-Game/Discord/Twitch, and restart the server. (Looks for ModIDS in ServerGrid.json only)
- Automatically imports available server data from ServerGrid.json & GameServerUser.ini files (if enabled).
- Optionally start selected gri﻿d servers only.
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
- Optionally execute external files for seven unique conditions, including at server updates, mod updates, scheduled restarts, remote restart, when first restart notice is announced.
  *These options are great executing a batch file to disable certain mods during a server update, to run custom announcement scripts, make config changes (enable PVP at scheduled times), etc.
- Can validate files on first run, then optionally only when buildid (server version) changes. Backs up & erases appmanifest.acf to force update when client-only update is released.

-----------------
 GETTING STARTED
-----------------
NEW & EXISTING INSTALLATION: (Using this utility to download and install server files - STILL REQUIRES MAP (SERVERGRID.JSON) FILES - Google "how to set up an atlas dedicated server"
1) Run AtlasServerUpdateUtility.exe
- The file "AtlasServerUpdateUtility.ini" will be created and the program will exit.
2) Modify the default values in "AtlasServerUpdateUtility.ini" settings, such as install folder, and any other desired values.
3) Run AtlasServerUpdateUtility.exe again.
- The file "AtlasServerUpdateUtilityGridStartSelect.ini" will be created. This file determines which of the grids will be started. 
4) Copy your existing ServerGrid and save folders (if any) to the new folder.
5) Run AtlasServerUpdateUtility.exe yet again.
- New install: It will download, install, and validate your files, and start the server.
- Existing install: It will install any updates and start the server.
CONGRATS! Your server should be up-to-date and running! 

------------
 KNOWN BUGS
------------
- None reported at this time.

--------------
 INSTRUCTIONS
-------------- 
To shut down your server:
- Right-click on the AtlasServerUpdateUtility icon and select EXIT.
To restart your server:
- Run AtlasServerUpdateUtility.exe

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

---------------------------
 UPCOMING PLANNED FEATURES
---------------------------
- html documentation
- Ability to send RCON commands via Remote Restart
- Add AtlasServerUpdateUtility update check
- Discord announce shutdown and restart (back online)
- Second Discord webhook for admin use (announce server info into a separate Discord channel)

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
        Server AltSaveDirectoryName(s) (comma separated. Leave blank for default a00,a01,a10, etc) ###=	
            a. Type in the folder names of ALL servers here, including folders for remote servers.
              (This util pairs each folder entry to each server listed in ServerGrid.json, therefore even folders not used on the local server need to be entered) *OR*
            b. Leave this blank [recommended] and change your existing folders to match this util's default assignment: (a00 a10 a20 a30 a01 a02 a03 etc.)
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

-------------------------------
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
Latest Version:       http://www.phoenix125.com/share/atlas/AtlasServerUpdateUtility.zip
Previous Versions:    http://www.phoenix125.com/share/atlas/atlashistory/
Source Code (AutoIT): http://www.phoenix125.com/share/atlas/AtlasServerUpdateUtility.au3
GitHub:	              https://github.com/phoenix125/AtlasServerUpdateUtility

Website: http://www.Phoenix125.com
Discord: http://discord.gg/EU7pzPs
Forum:   https://phoenix125.createaforum.com/index.php

More ServerUpdateUtilities available: 7 Days To Die and Conan Exiles.  Rust and Empyrion coming soon!

---------
 CREDITS
---------
- Based on Dateranoth's ConanExilesServerUtility-3.3.0
https://gamercide.org/forum/topic/10558-conan-exiles-server-utility/

-----------------
 VERSION HISTORY
-----------------
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

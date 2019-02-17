AtlasServerUpdateUtility - A Utility to Keep Your Atlas Dedicated Server updated (and schedule server restarts, download and install new server files, and more!)
- Latest version: AtlasServerUpdateUtility_v1.1.0 (2019-02-16)
- By Phoenix125 | http://www.Phoenix125.com | http://discord.gg/EU7pzPs | kim@kim125.com
- Based on Dateranoth's ConanExilesServerUtility-3.3.0 | https://gamercide.org/

----------
 FEATURES
----------
- Works *theoretically* with 100 grids (10x10).  (As of v1.1.0, it is untested whether it will work on multiple system setups)
- Automatically imports available server data from ServerGrid.json.
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
- Can validate files on first run, then optionally only when buildid (server version) changes. Backs up & erases appmanifest.acf to force update when client-only update is released.

-----------------
 GETTING STARTED (Two sets of instructions: one for existing servers and the other to use the AtlasServerUpdateUtility tool to download and install a new dedicated server)
-----------------
1) Run AtlasServerUpdateUtility.exe
- The file "AtlasServerUpdateUtility.ini" will be created and the program will exit.
2) Modify the default values in "AtlasServerUpdateUtility.ini" settings, such as install folder, and any other desired values.
3) Run AtlasServerUpdateUtility.exe again.
- It will validate your files, install any updates, and start the server.
4) Your server should be up-to-date and running! 

------------
 KNOWN BUGS
------------
- Remote Restart not working at this time.

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
- If running multiple instances of this utility, each copy must be in a separate folder.
- If running multiple instances of this utility, rename AtlasServerUpdateUtility.exe to a unique name for each server. The phoenix icon in the lower right will display the filename.
  For example: I run 6 servers, so I renamed the AtlasServerUpdateUtility.exe files to Atlas-STABLE.EXE, Atlas-EXPERIMENTAL.EXE, CONAN-2X.EXE, CONAN-PIPPI.EXE, CONAN-LITMAN.EXE, & ATLAS.EXE.
- If using the "Request Restart From Browser" option, you have to use your local PC's IP address as the server's IP. ex: "Server Local IP=192.168.1.10" (127.0.0.1 and external IP do not work).
Tips:
- Use the "Run external script during server updates" feature to run a batch file that disables certain mods during a server update to prevent incompatibilities.

---------------------------
 UPCOMING PLANNED FEATURES
---------------------------
- Detailed instructions.

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

-----------------------
 DETAILED INSTRUCTIONS
-----------------------
====> Request Restart From Browser <====
- If enabled on the server, use to remotely restart the server.
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

-----------------
 VERSION HISTORY
-----------------
(2019-02-16) v1.0.5
- Added *theoretical* support for up to 100 grids (10x10).
- Automatically imports available server data from ServerGrid.json.

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

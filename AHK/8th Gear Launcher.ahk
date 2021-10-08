#SingleInstance, Force
#NoEnv
;#Warn
SetBatchLines -1
StringCaseSense, On
SetWorkingDir, %A_ScriptDir%

;Ahk2Exe Stuff
	;@Ahk2Exe-SetMainIcon icons\small_8G.ico
	;@Ahk2Exe-AddResource icons\8G_grey_logo.ico, 160  ; Replaces 'H on blue'
	;@Ahk2Exe-AddResource icons\8G_grey_logo.ico, 206  ; Replaces 'S on green'
	;@Ahk2Exe-AddResource icons\8G_grey_logo.ico, 207  ; Replaces 'H on red'
	;@Ahk2Exe-AddResource icons\8G_grey_logo.ico, 208  ; Replaces 'S on red'
	;@Ahk2Exe-SetName 8th Gear Launcher
	;@Ahk2Exe-SetVersion 1.5.1
	;@Ahk2Exe-SetCopyright Firecul666@gmail.com
	;@Ahk2Exe-SetDescription https://github.com/Firecul/8th-Gear-Launcher
	;@Ahk2Exe-SetLanguage 0x0809
	;@Ahk2Exe-Obey U_au, = "%A_IsUnicode%" ? 2 : 1    ; Script ANSI or Unicode?
	;@Ahk2Exe-PostExec "BinMod.exe" "%A_WorkFileName%"
	;@Ahk2Exe-Cont  "%U_au%.AutoHotkeyGUI.LauncherGUI"
	;@Ahk2Exe-Cont  "%U_au%2.>AUTOHOTKEY SCRIPT<. 8TH GEAR LAUNCHER "

FileCreateDir, 8thGearLauncher ;Creation stuff
	Fileinstall, ServerList.ini, 8thGearLauncher/ServerList.ini, 0
	Menu, Tray, Icon, % "HICON:*" . Create_8G_logo_ico()

LauncherVersion = v1.5.1

vFAQ =
	(
	READ THE WHOLE THING.
	)

MyProgress = ""

Global ServerNames



#LTrim

Global NormalWhitelist := "
	(Join,
	abnormally
	attempt new connection
	blocked
	can't
	Cannot
	Couldn't
	Could not
	crash
	Debug
	Dropping
	DumpServer		
	Error
	ERR_CONNECTION_REFUSED
	Exception
	Failed
	Fatal
	GlobalError
	handling entries
	INVALID
	is not a valid number
	MainThrd/   at 
	nui://racescript/
	#overriding
	parse
	RaceScript		
	#recieved
	#Recieving
	Render/
	streaming entry without blockmap
	SyntaxError
	Uncaught
	Unexpected
	warn
	Warning
	^1SCRIPT
	^3>
	----------------
	)"

Global NormalBlacklist := "
	(Join,
	DumpServer is active and waiting.
	fix the exporter
	f7c13cb204bc9aecf40b
	handling entries from dlc
	ignore-certificate-errors
	is not a platform image
	It leads to vertex
	NurburgringNordschleife/_manifest.ymf
	OnConnectionProgress:
	Physics validation failed
	script.js:214
	script.js:458
	script.js:461
	terrorbyte
	warmenu
	WarningScreen INIT_CORE
	1 handling entries
	)"

Global ServerWhitelist := "
	(Join,
	allowed to connect
	A player with the name
	Changing spectate for player 
	changing weather: 
	Checking Permissions for Player 
	Clearing PermCache
	Connecting UserID is
	Deregistering vehicle
	does dblist contain dropped player
	dbidlist 
	dropped (Reason: Exiting).
	Got new PB time from
	Got Perms for player 
	Got vote response
	In Ban Check
	[INFO]
	is now hotlapping
	[LOG] checkpoints:
	no handling found for 
	old handle: $
	Out of range
	Oversized assets
	Player Joined:
	RaceMeta rowid is
	Removing entity
	Removing vehicles for
	Saving Car Customization for player
	Saving laptime: Player: 
	Sending Car List To
	Sending Hoptlap Lap Time
	Sending Hotlap Lap Time
	Sending Hoptlap Track Data
	Sending Track List To
	sending vote options
	sent perms
	set to grid pos 
	to player 
	Updated Web PlayerCount
	Updated Web Weather
	vote winner:
	)"

GoSub, GenerateMainUI

GoSub, BetterDownloadServerList ;DO NOT ENABLE BOTH AT THE SAME TIME!!!!!
;GoSub, DontDownloadServerList ;DO NOT ENABLE BOTH AT THE SAME TIME!!!!!
GoSub, UpdateServerList
GoSub, FiveMExist
GoSub, PingAll
GoSub, UpdateFiles

Return


GenerateMainUI:
	Gui, Main: New ;Main Window
		;Gui, Main: +Caption -Border  ;Enable with alt Gui, add drag from anywhere, alter width?
		Gui, Main: Add, Picture, w465 h-1, % "HBITMAP:*" . Create_8GLogo_png()
		Gui, Main: Add, GroupBox, w220 h81, 8th Gear Servers:
		Gui, Main: Add, DropDownList, xp+10 yp+20 w133 vServerNameList,
		Gui, Main: Add, button, xp+139 yp-1 w60 gConnect Default, Connect
		Gui, Main: Add, button, xp-140 yp+30 w200 gLocalhost, &Localhost
		Gui, Main: Add, Groupbox, xp+220 yp-49 w236 h81, Disclaimer
		Gui, Main: Add, link, xp+10 yp+20 w215, By joining our servers you agree to be bound to the <a href="https://discord.gg/ygWU5ms">#rules</a> of our server.

		Gui, Main: Add, StatusBar,,
		SB_SetParts(206,140,140)


		Menu, FileMenu, Add, &Locate FiveM.exe, lookforfivem  ;Top Menu
		Menu, FileMenu, Add,
		Menu, FileMenu, Add, E&xit `tEsc, MenuOptionExit

		Menu, CacheMenu, Add, &Open Cache Folder `tCtrl+C, OpenCacheFolder
		Menu, CacheMenu, Add,
		Menu, CacheMenu, Add, &Back-up Cache, BackupCache
		Menu, CacheMenu, Add, Open Back-up Folder, OpenBackupCacheFolder
		Menu, CacheMenu, Add, &Restore Cache from Back-ups, RestoreCache


		Menu, LogMenu, Add, View &Current Logs `tCtrl+L, OpenLogManager
		Menu, LogMenu, Add, &Open Log Folder, OpenLogFolder
		Menu, LogMenu, Add,
		Menu, LogMenu, Add, View Backed Up Logs, OpenBackedupLogManager
		Menu, LogMenu, Add, &Back-up Logs, MenuOptionBackupLogs
		Menu, LogMenu, Add, Open Back-up Folder, OpenLogBackupFolder
		Menu, LogMenu, Add,
		Menu, LogMenu, Add, Open &Arbitrary log... `tCtrl+O, MenuOptionArbitraryLog
		Menu, LogMenu, Default, View &Current Logs `tCtrl+L

		Menu, GTASettingsMenu, Add, Open in &Default editor, MenuOptionOpenGTASettingsDefault
		Menu, GTASettingsMenu, Add, Open in &Notepad, MenuOptionOpenGTASettingsNotepad
		Menu, GTASettingsMenu, Add, Open &Containing Folder, MenuOptionOpenGTASettingsFolder

		Menu, ToolsMenu, Add, &Cache, :CacheMenu
		Menu, ToolsMenu, Add, &Logs, :LogMenu
		Menu, ToolsMenu, Add, &GTAV Settings, :GTASettingsMenu

		Menu, MenuBar, Add, &File, :FileMenu
		Menu, MenuBar, Add, &Tools, :ToolsMenu
		Menu, MenuBar, Add, &Rules, MenuOptionRules
		Menu, MenuBar, Add, FAQ, MenuOptionFAQ
		Menu, MenuBar, Add, &Discord, MenuOption8GDiscord
		Menu, MenuBar, Add, &About, MenuOptionAbout

		Gui, Menu, MenuBar

		Menu, submenu, Add, Log Viewer, openviewer ;Context Menu
		Menu, submenu, Default, Log Viewer
		Menu, submenu, Add, Default Editor, opendefault
		Menu, submenu, Add, Notepad, opennotepad
		Menu, ContextMenu, Add, Open With, :Submenu
		Menu, ContextMenu, Default, Open With
		Menu, ContextMenu, Add, Save To..., SaveLogCopy
		Menu, ContextMenu, Add, Delete, DeleteLog
		Menu, ContextMenu, Add, Properties, GetFileProperties

		Menu, Tray, NoStandard
		Menu, Tray, Add, Open Launcher, ReOpenLauncher
		Menu, Tray, Add, Manage Logs, OpenLogManager
		Menu, Tray, Add,
		Menu, Tray, Add, Open Cache Folder, OpenCacheFolder
		Menu, Tray, Add,
		Menu, Tray, Add, Exit, MenuOptionExit
		Menu, Tray, Default, Open Launcher
		Menu, Tray, Tip, 8th Gear Launcher
		Menu, Tray, Click, 2


		Menu, MenuBar, Disable, FAQ

		Gui, Main: Show,, 8th Gear FiveM Launcher


		Menu, LogViewerFileMenu, Add, Save To... `tCtrl+S, SaveLogCopy
		Menu, LogViewerFileMenu, Add,
		Menu, LogViewerFileMenu, Add, E&xit `tEsc, LogViewerWindowGuiEscape

		Menu, LogViewerToolsMenu, Add, &Parse `tCtrl+P, ParseLog
		Menu, LogViewerToolsMenu, Default, &Parse `tCtrl+P
		Menu, LogViewerToolsMenu, Add,
		Menu, LogViewerToolsMenu, Add, &Thorough Open (Slow), SlowOpen

		Menu, LogViewerMenuBar, Add, &File, :LogViewerFileMenu
		Menu, LogViewerMenuBar, Add, &Tools, :LogViewerToolsMenu

	Return

ReOpenLauncher:
	WinActivate, 8th Gear FiveM Launcher
	Return

MainGuiDropFiles:
	LogViewerWindowGuiDropFiles:

	Loop, Parse, A_GuiEvent, `n
	{
		FirstFile := A_LoopField
		break
	}
	Global FilePath
	FilePath := FirstFile
	OpenLogViewer("Dropped File", FilePath)
	Return

BetterDownloadServerList:
	DownloadObject := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	DownloadObject.Open("GET", "https://8thgear.racing/api/serverlist", true) ; Using 'true' allows the script to remain responsive.
	DownloadObject.Send()

	DownloadObject.WaitForResponse(1)
	DownloadedList := DownloadObject.ResponseText ;Error here Fix it TODO
		If (ErrorLevel = 0)
		{ ;Download successful
			If DownloadedList Contains 8th Gear Racing ;Prob Normal
			{
				If FileExist("8thGearLauncher/ServerList.ini")
					FileDelete, 8thGearLauncher/ServerList.ini
				FileAppend, %DownloadedList%, 8thGearLauncher/ServerList.ini, UTF-16
				If FileExist("8thGearLauncher/ServerList.ini")
				{
					IniRead, ServerNames, 8thGearLauncher/ServerList.ini
					Return
				}
			}
			If DownloadedList Contains [] ;No Servers Online
			{
				MsgBox 0x30,, % "No servers online.", 2
				Return
			}
			Else{
				MsgBox 0x30,, % "Website error detected!`n`nFalling back server list to back up.", 2
				IniRead, ServerNames, 8thGearLauncher/ServerList.ini
				Return
			}

		}
		If (ErrorLevel = 1)
		{ ;Download unsuccessful
			If FileExist("8thGearLauncher/ServerList.ini"){
				MsgBox 0x30,, % "Possible error detected!`n`nFalling back server list to back up.", 2
				IniRead, ServerNames, 8thGearLauncher/ServerList.ini
				}
			Return
		}
	Return

DontDownloadServerList:
	IniRead, ServerNames, 8thGearLauncher/ServerList.ini
	Return

UpdateServerList: ;Updates the list of servers from the ini file
	Global ServerNames
	If FileExist("AdditionalServers.ini"){
		IniRead, AdditionalServerNames, AdditionalServers.ini
		ServerNames := % ServerNames . "`n" . AdditionalServerNames
	}

	Gui Main: +Delimiter`n
	GuiControl,Main: , ServerNameList,`n
	SlimServerNames := StrReplace(ServerNames, "8th Gear Racing ")
	GuiControl,Main: , ServerNameList, %SlimServerNames%
	GuiControlGet, ServerNameList
	GuiControl, Main: ChooseString, ComboBox1, EU 2
	Gui, Main: Show,, 8th Gear FiveM Launcher
	Return

FiveMExist: ;Stuff to run at start up
	RegRead, FiveMPath, HKEY_CURRENT_USER\Software\CitizenFX\FiveM, Last Run Location
	If (FiveMPath = ""){
			MsgBox 	0x30,, FiveM.exe cannot be found.`nPlease locate it.
			GoSub, LookForFiveM
			Menu, FileMenu, Enable, &Locate FiveM.exe
		}
		else{
			StringTrimRight, FiveMExeFullPath, FiveMPath, 10
			FiveMExeFullPath := FiveMExeFullPath . "FiveM.exe"
			Menu, FileMenu, Disable, &Locate FiveM.exe
		}
	Return

LookForFiveM: ;Opens dialogue box to allow selecting FiveM.exe location
	Gui +OwnDialogs
	FileSelectFile, FiveMExeFullPath, 3, , Locate FiveM.exe, FiveM (FiveM.exe)
	If (FiveMExeFullPath = ""){
			MsgBox 0x30,, The user didn't select anything.
			LV_Delete()
			Menu, FileMenu, Enable, &Locate FiveM.exe
	}
	else{

		StringTrimRight, FiveMPath, FiveMExeFullPath, 9
		FiveMPath := % FiveMPath . "FiveM.app\"
		Menu, FileMenu, Disable, &Locate FiveM.exe
	}
	GoSub, UpdateFiles
	Return

PingAll:
	Gui, Main: Show,, 8th Gear FiveM Launcher
	Global ServerNames
	StringSplit, ServerArray, ServerNames, `n,
	Loop, %ServerArray0%
	{
		If (ServerArray%A_Index% = "8th Gear Racing EU 2"){
			Ping(ServerArray%A_Index%, Create_EU_ico(), 2) ;Pings EU 2
			Continue
		}
		If (ServerArray%A_Index% = "8th Gear Racing US East 1"){
			Ping(ServerArray%A_Index%, Create_US_ico(), 3) ;Pings US East 1
			Continue
		}
	}
	Return

Ping(ServerName, Image, Section)
	{
		LogFile := "8thGearLauncher\" "Ping_" A_Now ".log"

		IniRead, ServerIP, 8thGearLauncher/ServerList.ini, %ServerName%, IP
		IniRead, ActivePlayers, 8thGearLauncher/ServerList.ini, %ServerName%, Players
		IniRead, MaxPlayers, 8thGearLauncher/ServerList.ini, %ServerName%, MaxPlayers

		Runwait, %comspec% /c ping -n 1 -w 1000 %ServerIP% > %LogFile%, , Hide
		FileRead, Contents, %LogFile%
		RegExMatch(Contents, "O) = (\d+ms)[^,]", MatchGroup) ;Get average ping
		RegExMatch(Contents, "O)\((\d{1,3}% \w+)\)", PacketLossGroup) ;Get packet loss
		RegExMatch(PacketLossGroup.1, "O)(\d{1,3})%", PacketLossNumber) ;seperate number from packet loss

		SB_SetIcon("HICON:" Image,, Section)

		If (PacketLossNumber.1 > 0) ;If there is packet loss
		{
			RegExMatch(Contents, "O)(.*\)d{1,3}.\d{1,3}.\d{1,3}.\d{1,3}:[^ ]", PacketLossMessage) ;get ping statistics message
			MsgBox, 0x44, % PacketLossMessage.1 ServerName, % PacketLossGroup.1 "`n`nPlease check " LogFile " for details.`n`nWould you like to open this now?"
			IfMsgBox Yes
					Run C:\Windows\Notepad.exe %A_ScriptDir%\%LogFile%,, UseErrorLevel

			If (MatchGroup.1) ;If there is still an average ping
				{
					SB_SetText("*" MatchGroup.1 "* " ActivePlayers "/" MaxPlayers " Players", Section)
				}
				Else ;If there isn't an average ping
				{
					SB_SetText("(Error)", Section)
				}
			Return

		}
		Else ;if there isn't packet loss
		{
			FileDelete, %LogFile%
			SB_SetText(MatchGroup.1 " " ActivePlayers "/" MaxPlayers " Players", Section)
			Return
		}
	}

UpdateFiles: ;Updates the log list for the tools tab and populates related variables
	FiveMLogsPath := FiveMPath . "logs\"
	FiveMBackupLogsPath := FiveMPath . "Backed-up logs\"
	If !FileExist(FiveMPath . "Backed-up logs\"){
		Menu, LogMenu, Disable, Open Back-up Folder
		Menu, LogMenu, Disable, View Backed Up Logs
	}
	FiveMCachePath := FiveMPath . "cache\"
	FiveMBackupCachePath := FiveMPath . "CacheBackup\"
	If !FileExist(FiveMPath . "CacheBackup\"){
		Menu, CacheMenu, Disable, Open Back-up Folder
		Menu, CacheMenu, Disable, &Restore Cache from Back-ups
	}
	StringTrimRight, TrimmedExePath, FiveMExeFullPath, 10
	ShortcutPath := % TrimmedExePath . "\8GLauncher.lnk"
	Return

GetFileProperties:
	Global FilePath
	run, Properties "%FilePath%"
	Return

DeleteLog:
	Global FilePath
	MsgBox, 0x40124, Delete Log?, Are you sure you want to delete this file? `n%FilePath%
	IfMsgBox, Yes
		{
			FileDelete, %FilePath%
			Return
		}
	IfMsgBox, No
			Return
	Return

Connect: ;Connects to the selected server in the list
	GuiControlGet, ServerNameList
	If ServerNameList contains EU,Central
	{
		ServerNameList := % "8th Gear Racing " . ServerNameList
		IniRead, ServerIP, 8thGearLauncher/ServerList.ini, %ServerNameList%, IP
		IniRead, ServerPort, 8thGearLauncher/ServerList.ini, %ServerNameList%, Port
	}
	else{
		IniRead, ServerIP, AdditionalServers.ini, %ServerNameList%, IP
		IniRead, ServerPort, AdditionalServers.ini, %ServerNameList%, Port
	}

	GoSub, BackupLogs

	Run, % "cmd.exe /C explorer.exe fivem://connect/" . ServerIP . ":" . ServerPort,,hide
	Return

Localhost: ;Launches FiveM and connects to Localhost
	GoSub, BackupLogs
	Run, cmd.exe /C explorer.exe fivem://connect/127.0.0.1,,hide
	Return

OpenLogManager:
	OpenFolderExplorerWindow(FiveMLogsPath, "FiveM Logs")
	Return

OpenBackedupLogManager:
	OpenFolderExplorerWindow(FiveMBackupLogsPath, "Backed Up Logs")
	Return

OpenFolderExplorerWindow(Path, Title){
	Global MyNewListView
	Gui, FolderExplorerWindow: Default
	Gui, +Resize +Minsize460x120
	Gui, FolderExplorerWindow: Add, ListView, r9 Grid -Multi w460 gMyNewListView vMyNewListView, Name|Size (KB)|SortingSize|Modified|SortingDate|Path
	Gui, FolderExplorerWindow: Add, StatusBar

	SB_SetParts(472/7, 472/7)

	Loop %Path%*.*
		{
			FileSize := regExReplace(GetNumberFormatEx(A_LoopFileSizeKB), "[,.]?0+$")
			FormatTime, LogTimeAndDate, %A_LoopFileTimeModified%
			LV_Add("", A_LoopFileName, FileSize, A_LoopFileSizeKB, LogTimeAndDate, A_LoopFileTimeModified, A_LoopFileFullPath)

			FileCount += 1
			TotalSize += A_LoopFileSize
		}
	LV_ModifyCol() ;Auto-size each column
	LV_ModifyCol(1, "AutoHdr Text")
	LV_ModifyCol(2, "AutoHdr Integer")
	LV_ModifyCol(3, "AutoHdr Integer 0")
	LV_ModifyCol(4, "Text NoSort")
	LV_ModifyCol(5, "AutoHdr Digit SortDesc 0")
	LV_ModifyCol(6, "AutoHdr Text 0")
	GuiControl, FolderExplorerWindow: +Redraw, MyListView

	; Update the three parts of the status bar to show info about the currently selected folder:
	SB_SetText(FileCount . " files", 1)
	SB_SetText(Round(TotalSize / (1024*1024), 1) . " MB", 2)
	SB_SetText(Path, 3)

	Gui, FolderExplorerWindow: Show, AutoSize, %Title%
	Return
}

MyNewListView: ;Gets double-clicked file from FolderExplorerWindow listview
	If (A_GuiEvent = "DoubleClick")
		{
			LV_GetText(FileName, A_EventInfo, 1)
			LV_GetText(FilePath, A_EventInfo, 6)
			OpenLogViewer(FileName, FilePath)
		}
	If ( A_GuiEvent = "ColClick" And A_EventInfo = 2 )
		{
		If Sort
		LV_ModifyCol(3, "Sort")
		else
		LV_ModifyCol(3, "SortDesc")
		Sort := not Sort
		}
	If ( A_GuiEvent = "ColClick" And A_EventInfo = 4 )
		{
		If Sort
		LV_ModifyCol(5, "Sort")
		else
		LV_ModifyCol(5, "SortDesc")
		Sort := not Sort
		}
	Return

FolderExplorerWindowGuiContextMenu: ;FolderExplorerWindow
	Global FileName
	Global FilePath
	MouseGetPos, , , , control
	If (A_GuiControl = "MyNewListView" && control != "SysHeader321") {
			LV_GetText(FileName, A_EventInfo, 1)
			LV_GetText(FilePath, A_EventInfo, 6)
		Menu, ContextMenu, Show, %A_GuiX%, %A_GuiY%
	}
	Return

OpenLogViewer(FileName, FilePath) ;Opens the selected log with the Log Viewer
	{
		GoSub, LogViewerWindowGuiEscape
		Global LogContents
		Static Parse
		Static SlowOpen
		Static SaveLog

		Sleep 50
		Gui, LogViewerWindow:+Resize ;LogViewer Window
		Gui, LogViewerWindow: Menu, LogViewerMenuBar
		Gui, LogViewerWindow: font, s10 norm
		Gui, LogViewerWindow: font,, Lucida Console
		Gui, LogViewerWindow: Add, edit, w1000 r30 ReadOnly t10 vLogContents, (Loading)
		Gui, LogViewerWindow: font,
		Gui, LogViewerWindow: font, s10
		Gui, LogViewerWindow: Add, StatusBar,, % FilePath
		Gui, LogViewerWindow: show, AutoSize Center, %FileName%
		fileread, LogContents, %FilePath%
		Guicontrol, LogViewerWindow: text, LogContents, %LogContents%
		Return
	}

FolderExplorerWindowGuiSize:
  If A_EventInfo = 1  ; The window has been minimized.  No action needed.
    Return
  ; Otherwise, the window has been resized or maximized. Resize the controls to match.
  GuiControl Move, MyNewListView, % "H" . (A_GuiHeight-35) . " W" . (A_GuiWidth-20)
	Return

LogViewerWindowGuiSize:
  If A_EventInfo = 1  ; The window has been minimized.  No action needed.
    Return
  ; Otherwise, the window has been resized or maximized. Resize the controls to match.
  GuiControl Move, LogContents, % "H" . (A_GuiHeight-40) . " W" . (A_GuiWidth-20)
	Return

MakeMessageWindow(Text,Dir)
	{
		count = 0
		Loop, Files, %Dir%\*.log
			count++

		Global MyProgress
		Gui, MessageWindow: +AlwaysOnTop +Disabled -SysMenu +Owner
		Gui, MessageWindow: Font, s11 Norm
		Gui, MessageWindow: Add, Text,, % Text
		Gui, MessageWindow: Add, Progress, w420 vMyProgress Range0-%count% -Smooth
		Gui, MessageWindow: Show, NoActivate, Loading...
		Return count
	}

SaveLog:
	Global FilePath
	FileSelectFile, SavedLogName, S18, %FilePath%, Where to save the Log?, Log Files (*.log)
	FileAppend, %LogContents%, %SavedLogName%,
	Return

SaveLogCopy:
	Global FilePath
	FileSelectFile, NewLog, S18, %FilePath%, Where to save the Log?, Log Files (*.log)
		If (NewLog = ""){
			MsgBox 0x30,, The user didn't select a location.
	}else{
			FileCopy, %FilePath%, %NewLog% ;TODO improve, prob using dllcall.
		}
	Return

OpenCacheFolder: ;Opens normal cache folder
	run %FiveMCachePath%
	Return

BackupCache: ;Backs up cache priv folder
	Gui +OwnDialogs
	IfNotExist, %FiveMBackupCachePath%
	{
		MsgBox 0x40,, The target folder does not exist.`n`nCreating it., 2
		FileCreateDir, %FiveMBackupCachePath%
	}
	IfExist, %FiveMBackupCachePath%
	{
		MsgBox 0x40,, The target folder exists.`n`nCopying files.
		FileCopyDir, %FiveMCachePath%db\, %FiveMBackupCachePath%db\, 1
		FileCopy,  %FiveMCachePath%priv\*.*, %FiveMBackupCachePath%priv\*.*
		FileCopyDir, %FiveMCachePath%priv\db\, %FiveMBackupCachePath%priv\db\, 1
		FileCopyDir, %FiveMCachePath%priv\unconfirmed\, %FiveMBackupCachePath%priv\unconfirmed\ , 1
		MsgBox 0x40,, Cache Backed Up, 2
	}
	Return

OpenBackupCacheFolder: ;Opens the backup Cache folder
	run %FiveMBackupCachePath%
	Return

RestoreCache: ;Restores cache from backups
	Gui +OwnDialogs
	FileCopyDir, %FiveMBackupCachePath%db\, %FiveMCachePath%db\, 1
	FileCopy, %FiveMBackupCachePath%priv\*.*, %FiveMCachePath%priv\*.*
	FileCopyDir, %FiveMBackupCachePath%priv\db\, %FiveMCachePath%priv\db\, 1
	FileCopyDir, %FiveMBackupCachePath%priv\unconfirmed\, %FiveMCachePath%priv\unconfirmed\ , 1
	MsgBox 0x40,, Cache Restored, 2
	Return

ParseLog: ;Determines the type of log(old-style vs new-style vs server)
	Global LogContents
	Global FilePath
	LogLines := StrSplit(LogContents, "`n", "`r")
	logline :=
	TrimmedLinea :=




	NewNeedle := "CitizenFX_log_"
	OldNeedle := "CitizenFX.log"
	ServerNeedle := "fxserver_"

	If InStr(FilePath, NewNeedle){
		GoSub, ParseNewLog ;New-Style log
		Return
	}
	If InStr(FilePath, OldNeedle){
		GoSub, ParseOldLog ;Old-Style log
		Return
	}
	If InStr(FilePath, ServerNeedle){
		GoSub, ParseServerLog ;Server log TODO
		MsgBox, % "Server style"
		Return
	}
	Else
		MsgBox, % "Unknown style"
	Return

ParseNewLog: ;New-Style log parsing
	Global LogContents
	Loop, % LogLines.Count()
		{
			StringCaseSense Off
			logline := LogLines[a_index]
			If logline contains %NormalWhitelist%
				If logline not contains %NormalBlacklist%
				{
					stringtrimleft, TrimmedLine, logline, 52

					TrimmedLine := StrReplace(TrimmedLine, "^2[RaceScript] [", "[RaceScript] [")
					TrimmedLine := StrReplace(TrimmedLine, "^3[RaceScript] [", "[RaceScript] [")
					TrimmedLine := StrReplace(TrimmedLine, "^5[RaceScript] [", "[RaceScript] [")
					TrimmedLine := StrReplace(TrimmedLine, "]^7  ", "]  ")

					TrimmedLinea = %TrimmedLinea%Line #%A_Index%:%A_Tab%%TrimmedLine%`n
				}
		}
	Guicontrol, LogViewerWindow: text, LogContents, %TrimmedLinea%
	Return

ParseOldLog: ;Old-Style log parsing
	Global LogContents
	Loop, % LogLines.Count()
		{
			logline := LogLines[a_index]
			If logline contains %NormalWhitelist%
				If logline not contains %NormalBlacklist%
				{
					stringtrimleft, TrimmedLine, logline, 13
					TrimmedLinea = %TrimmedLinea%Line #%A_Index%:%A_Tab%%TrimmedLine%`n
				}
		}
	Guicontrol, LogViewerWindow: text, LogContents, %TrimmedLinea%

	MsgBox, 0x40, Log Format, Old-Style log suspected, 2
	Return

ParseServerLog:
	ServerContains := NormalWhitelist . ServerWhitelist
	Global LogContents
	Loop, % LogLines.Count()
	{
			logline := LogLines[a_index]
			If logline contains %ServerWhitelist%
				If logline not contains %NormalBlacklist%
				{
					RegExMatch(logline, "O)\[\d+;\d+;\d+m\[[\s*\S*]{20}\]\s(.*$)", newlogline)
					newloglinea = % newloglinea "Line #" A_Index ":" A_Tab newlogline.1 "`n"
				}
		}

	Guicontrol, LogViewerWindow: text, LogContents, %newloglinea%

	Return

SlowOpen: ;Opens the log ignoring any found null characters that normally cause issues
	Global LogContents
	Global FilePath
	Guicontrol, LogViewerWindow: text, LogContents, % Nonulls(FilePath)
	Return

NoNulls(Filename)
	{ ;Reads the given file character by charcter
	f := FileOpen(Filename, "r")
	While Not f.AtEOF {
		If Byte := f.ReadUChar()
		Result .= Chr(Byte)
		}
	f.Close
	Return, Result
	}

GetNumberFormatEx(Value, LocaleName := "!x-sys-default-locale"){
	If (Size := DllCall("GetNumberFormatEx", "str", LocaleName, "uint", 0, "str", Value, "ptr", 0, "ptr", 0, "int", 0)) {
		VarSetCapacity(NumberStr, Size << !!A_IsUnicode, 0)
		If (DllCall("GetNumberFormatEx", "str", LocaleName, "uint", 0, "str", Value, "ptr", 0, "str", NumberStr, "int", Size))
			Return NumberStr
	}
	Return false
	}

RulesBold(text)
	{
	Gui, RulesWindow: font, bold
	Gui, RulesWindow: Add, text, w600, %text%
	}

RulesNormal(text)
	{
		Gui, RulesWindow: font, Norm
		Gui, RulesWindow: Add, text, w600, %text%
	}

OpenLogFolder: ;Opens the log folder
	run %FiveMLogsPath%
	Return

OpenLogBackupFolder: ;Opens the log backup folder
	run %FiveMBackupLogsPath%
	Return

BackupLogs: ;Backs up logs to the backup folder for safe keeping
	Gui +OwnDialogs
	IfNotExist, %FiveMBackupLogsPath%
		FileCreateDir, %FiveMBackupLogsPath%
	FileCopy, %FiveMLogsPath%*.log, %FiveMBackupLogsPath%*.*, 1
	Return

MenuOptionBackupLogs: ;Backs up logs to the backup folder for safe keeping
	Gui +OwnDialogs
	IfNotExist, %FiveMBackupLogsPath%
		FileCreateDir, %FiveMBackupLogsPath%
	FileCopy, %FiveMLogsPath%*.log, %FiveMBackupLogsPath%*.*, 1
	MsgBox, 0x40,, Logs Backed Up, 2
	Return

openviewer:
	Global FileName
	Global FilePath
	OpenLogViewer(FileName, FilePath)
	Return

opendefault: ;Opens the selected log with the users default editor for .log files
	Global FilePath
	Gui +OwnDialogs
	Run %FilePath%,, UseErrorLevel
	If ErrorLevel
		MsgBox, 0x30,, Could not open %FilePath%
	Return

opennotepad: ;Opens the selected log with Notepad
	Global FilePath
	Gui +OwnDialogs
	Run C:\Windows\Notepad.exe %FilePath%,, UseErrorLevel
	If ErrorLevel
		MsgBox, 0x30,, Could not open %FilePath%
	Return

MenuOption8GDiscord: ;Opens 8G Main discord channel
	Run https://discord.gg/4Xd2uwy
	Return

MenuOptionAbout: ;Opens about window
	IniRead, NewestVersion, 8thGearLauncher/VERSION_INFO.ini, NewestVersion, Version
	GoSub, AboutWindowGuiEscape
	Sleep 50
	Gui, AboutWindow: font, s10 norm
	Gui AboutWindow:+ToolWindow +AlwaysOnTop
	Gui, AboutWindow: Add, link, w620, Hello and welcome to the 8th Gear FiveM Launcher.`n`nThis Launcher serves as the hub for everything you need to play on the 8th Gear servers and a few useful tools that will help you along the way. `n`nThis launcher is built using AHK by Firecul and is open-source and can be found on <a href="https://github.com/Firecul/8th-Gear-Launcher">GitHub</a>.`n`nThis launcher is version: %LauncherVersion%`nTo download another version please go to <a href="https://github.com/Firecul/8th-Gear-Launcher/releases">My Github releases page</a>`n`nIf you would like to contribute to this program, you are welcome to contact me there or submit a <a href="https://github.com/Firecul/8th-Gear-Launcher/pulls">pull request</a>.`n`nIf you find any problems please <a href="https://github.com/Firecul/8th-Gear-Launcher/issues/new">let me know</a>.
	Gui, AboutWindow: show, AutoSize Center, About
	Return

MenuOptionArbitraryLog:
	Gui +OwnDialogs
	FileSelectFile, FilePath, 3, , Open a FiveM Log, Log (*.log*)
	If (FilePath = ""){
			MsgBox 0x40,, The user didn't select anything., 2
	}
	else{
		OpenLogViewer(FilePath, FilePath)
	}
	Return

MenuOptionFAQ: ;Opens FAQ Window
	GoSub, FAQWindowGuiEscape
	Sleep 50
	Gui FAQWindow:+ToolWindow +AlwaysOnTop
	Gui, FAQWindow: font, s10 norm
	Gui, FAQWindow: Add, edit, w620 h700 Multi ReadOnly, %vFAQ%
	Gui, FAQWindow: show, AutoSize Center, FAQWindow
	Return

MenuOptionOpenGTASettingsDefault:
	Run %A_MyDocuments%\Rockstar Games\GTA V\settings.xml,, UseErrorLevel
	If ErrorLevel{
		MsgBox 0x30,, Could not open %A_MyDocuments%\Rockstar Games\GTA V\settings.xml
	}
	Return

MenuOptionOpenGTASettingsFolder:
	Run %A_MyDocuments%\Rockstar Games\GTA V,, UseErrorLevel
	If ErrorLevel{
		MsgBox 0x30,, %A_MyDocuments%\Rockstar Games\GTA V
	}
	Return

MenuOptionOpenGTASettingsNotepad:
	Run C:\Windows\Notepad.exe %A_MyDocuments%\Rockstar Games\GTA V\settings.xml,, UseErrorLevel
	If ErrorLevel{
		MsgBox 0x30,, Could not open %A_MyDocuments%\Rockstar Games\GTA V\settings.xml
	}
	Return

MenuOptionRules: ;Opens rules window
	GoSub, RulesWindowGuiEscape
	Sleep 50
	Gui RulesWindow:+ToolWindow +AlwaysOnTop
	Gui, RulesWindow: font, s10 Norm
	Gui, RulesWindow: Add, GroupBox, w620 h790, 8th Gear Specific Rules:
	Gui, RulesWindow: font, bold
	Gui, RulesWindow: Add, text, xp+10 yp+20 w550, 1) THE GOLDEN RULE: Don't be a Dick
	RulesNormal("Personal attacks, harassment, hate speech, etc. will not be tolerated. Treat others with respect at all times.")
	RulesBold("2) Follow Discord TOS and Community Guidelines")
	Gui, RulesWindow: font, Norm
	Gui, RulesWindow: Add, Link,, <a href="https://discordapp.com/terms">https://discordapp.com/terms</a> && <a href="https://discordapp.com/guidelines">https://discordapp.com/guidelines</a>
	RulesBold("3) No NSFW/NSFL Content")
	RulesBold("4) No Spamming or Trolling")
	RulesBold("5) English Only")
	RulesNormal("Please speak English at all times while on the server. This helps everyone to understand each other.")
	RulesBold("6) No Cheating on the Server")
	RulesNormal("Using 3rd-party menus to gain an unfair advantage will result in a ban.")
	RulesBold("7) No Drama")
	RulesNormal("Arguments should be resolved in a respectful manner or kept out of the discord entirely.")
	RulesBold("8) Keep channels on-topic")
	RulesNormal("Try to keep conversations in their appropriate channels. A little spillover is fine, but don't let it get out of hand.")
	RulesBold("9) No Politics")
	RulesNormal("This server is for people to have fun playing games together. Other servers exist for political discussion and this is not one of them.")
	RulesBold("10) No Advertising")
	RulesNormal("Links to youtube channels, streams, other discords, etc. are prohibited unless approved by a staff member.")
	RulesBold("8) Listen to the Staff")
	RulesNormal("Staff have the final say and are free to moderate at their own discretion.")
	RulesBold("By taking part in this community you acknowledge that you understand and accept these rules. Ignoring them or not knowing them does not excuse you from them.")
	Gui, RulesWindow: font, norm
	Gui, RulesWindow: Add, link, w600, The rules found on the official discord channel superceed the ones found on this launcher, please refer to the <a href="https://discord.gg/ygWU5ms">discord #rules channel</a> for the most up to date list.
	Gui, RulesWindow: show, AutoSize Center, Rules
	Return

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_8G_logo_ico(NewHandle := False) {
	Static hBitmap := Create_8G_logo_ico()
	If (NewHandle)
		hBitmap := 0
	If (hBitmap)
		Return hBitmap
	VarSetCapacity(B64, 1192 << !!A_IsUnicode)
	B64 := "AAABAAEAEBAAAAEAGABoAwAAFgAAACgAAAAQAAAAIAAAAAEAGAAAAAAAAAAAACwBAAAsAQAAAAAAAAAAAAAHDRoDBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0HDRoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBw0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBw0DBw0AAAAAAAAAAAAAAAAAAAAAAABpaWlkZGRkZGRkZGRhYWFWVlYLCwsAAAADBw1cYGaTk5OXl5eZmZmZmZl4eHguLi7///////////////////////+QkJAAAAADBw31+f/////////////////////g4OAmJiYnJycAAAAAAAAkJCTExMT6+voAAAADBw3P09n///+goKAfHx8gICDX19f///8PDw8AAABEREQ+Pj4AAAAEBAT///9JSUkDBw09QEfi4uLQ0NB+fn6IiIjt7e3///8/Pz8AAADz8/P///9/f38AAADAwMDCwsIDBw0DBw23t7f////////w8PDV1dX///+VlZUAAABwcHD///////+QkJDX19f+/v4DBw0DBw3T09P///+Hh4cfHx8mJibu7u7///8XFxcAAABkZGRycnKLi4t6enr///9AQ0oDBw1lZWX////////////////////////R0dEWFhYAAAAAAAAAAAAAAADs7OyvsrkDBw0AAACIiIjc3Nzs7Ozs7Ozg4ODZ2dlubm6srKz////////////////////1+f8DBw0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAApKSlsbGxtbW1tbW1tbW1bW1tYW2EDBw0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAADBw0AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAHDRoDBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0DBw0HDRoAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	VarSetCapacity(Dec, DecLen, 0)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
	; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
	hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
	pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
	hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
	VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
	DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
	DllCall("Gdiplus.dll\GdipCreateHICONFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
	DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
	DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
	DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
	DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
	Return hBitmap
	}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_8GLogo_png(NewHandle := False) {
	Static hBitmap := Create_8GLogo_png()
	If (NewHandle)
		hBitmap := 0
	If (hBitmap)
		Return hBitmap
	VarSetCapacity(B64, 157332 << !!A_IsUnicode)
	B64 := "iVBORw0KGgoAAAANSUhEUgAAAdEAAAHRCAIAAAC6oRTMAAAACXBIWXMAAAsTAAALEwEAmpwYAAAF2GlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPD94cGFja2V0IGJlZ2luPSLvu78iIGlkPSJXNU0wTXBDZWhpSHpyZVN6TlRjemtjOWQiPz4gPHg6eG1wbWV0YSB4bWxuczp4PSJhZG9iZTpuczptZXRhLyIgeDp4bXB0az0iQWRvYmUgWE1QIENvcmUgNi4wLWMwMDIgNzkuMTY0MzUyLCAyMDIwLzAxLzMwLTE1OjUwOjM4ICAgICAgICAiPiA8cmRmOlJERiB4bWxuczpyZGY9Imh0dHA6Ly93d3cudzMub3JnLzE5OTkvMDIvMjItcmRmLXN5bnRheC1ucyMiPiA8cmRmOkRlc2NyaXB0aW9uIHJkZjphYm91dD0iIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtbG5zOmRjPSJodHRwOi8vcHVybC5vcmcvZGMvZWxlbWVudHMvMS4xLyIgeG1sbnM6cGhvdG9zaG9wPSJodHRwOi8vbnMuYWRvYmUuY29tL3Bob3Rvc2hvcC8xLjAvIiB4bWxuczp4bXBNTT0iaHR0cDovL25zLmFkb2JlLmNvbS94YXAvMS4wL21tLyIgeG1sbnM6c3RFdnQ9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9zVHlwZS9SZXNvdXJjZUV2ZW50IyIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgMjEuMSAoV2luZG93cykiIHhtcDpDcmVhdGVEYXRlPSIyMDE5LTExLTA4VDA0OjQzOjA5WiIgeG1wOk1vZGlmeURhdGU9IjIwMjEtMDEtMzBUMjM6Mzg6NDFaIiB4bXA6TWV0YWRhdGFEYXRlPSIyMDIxLTAxLTMwVDIzOjM4OjQxWiIgZGM6Zm9ybWF0PSJpbWFnZS9wbmciIHBob3Rvc2hvcDpDb2xvck1vZGU9IjMiIHBob3Rvc2hvcDpJQ0NQcm9maWxlPSJzUkdCIElFQzYxOTY2LTIuMSIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDplMDY3MjdmMi1lNzI4LTljNGYtYTBjNy1mNDhmOGM5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"
	B64 .= "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"
	B64 .= "LBFXobN5ZBrK89wENx0GOvmFHOFXjYlCugWYjarDQOmCEN3TnC1PmEZTqqj1AdntfOzYqRK5hmolmNTM0piwIE9VAIxAvfYBHYgMOGjARXpjxFIMARGrNOLjr9ficKAdrKihAQXGz7HBwG0qxvjhCNc/YOZ5aQzCXFoCepgJASETmog4V3dMcjTEuZ+s0JtXS9B60etCJ7nJzRdqo2J1FYiR7AllF7P/zIxRVYT/cv2RXrIjQ0xDgukbo76J66OWRlyTnuPhVGtDzYsg6RSwBfclbYeZKflq9s1l9aiVBnEGDaAgEoDgmSrRO7vs0EhHiCYXhmJHWyxxYMOsaNmV6Q4odB+6dfarBXKqIYA6INELCjjyp/V7Vph7pQ9UCf4urHAgATow4U/GGNMYY5oQeg38/42BEWMaY1yY9mFZ0u0RcOEChe5oxUvuu5PxYeNEQbyoysSACLW7tRQXbH0Xysnjagk8BVnknoNgqNhQsBl8biukTX3cTJkabj0aEWMJg1THebGdgNTaVKVJJhHhuB60pKgapRqHIzTGk98gohCjDWvejOoGNznae2Gf9qeRUxQZgAyDtoBY6xANxw900Jj6lorzCSbUKFIOFEYLjATdiRBF6UbZ/B9SSZNgWfdcE3cRCFIbN6RIkULD6ODea5eNWOpM5rmhrzeQECXb756u3XYMJQ7aXNQMZGsEqnxyASzIf3FgMEiUZEUXPaaV84mZxT+Pokkx3ZD6v6RAvA+r+rZIAB2yWzjeu8lAMJV/eanqIzh6kxTS/1uvPGZ3m+pTpBNADGwB4ZpR8CibdaKSotY68wHXRXLut/SApwPFHVPVSWyXQS8kFxARhPTVhOS2gYFpmsY0MP6PMI0BjGkAH4dXphFxWbLxfRbnCwCfLTFKCeZpQ/Z1utaQ0fdGyhacnycoLCK86Gw2hxhIh9JhJcYcnEH1uTf9FjgSmXa+y8G8WreD3JQxUpBZ7cA8yuYEtBA2lGxcn8lDQSlSO/0XK2wUYjS2jLJUR3TMSbHqWRJ0MWDgkZW4VQTj9cjYdtaQAOmE5ZJvlnUUBX9j+TngDPZxkTbG1OhiyWhEmYCCAtj1eg4SKTMhtS2yzI4HMiYZPiRXUzRa1CgHJZqDYkCgqoI6j3kGGVYAYM9FjJ0kLrbyNWNaCr13WVj6QZMcGUnRERNCZhPbUjZMIVDj9CQiisAkcA6PhrkaOaSxQaQxInpl4A74oWrYA0qiGTMWcr6jFAl+76LNdvx15KZJbAHjyTA6VyckrOIiqVo6aFNbbUWtFVrbehsCUQbpWF975DE3ZOaIHX0P67pk1odRA2OaxjTGAKZZNT7xbTzi0DQtjMt4EZPiELgdw99E4rqiR9rz+grBTysUPQliCKmuSlgX0WVB1MLNhYddhiHt9+hXRK0kyMN60zH3jTXnr3nMkU64OeTajmkqRkQBUTXGuIwUHouOhJDgeObXKDXxBpQOAPdr2NtbqFCt0jh1R3hUSAB1tBERFU1qGiVTsbzzO8wZdF0/vZqks7k0EJogq0YBaYwJHsdinOkK3FMcI0GtukXhWWIwIqLG2SA7kzgovF+lmx4BQNtIEwTOAt3LMCfAIA01xBG18KugQRaMPWpjkRhQWlxNV48llh9k1Uu7xgw5ztUDOpcApenncL2KfNF3qbhd5RqE9iyScG50RdVsf9cAwvmwpr4u8oCBQxpV4r9ClAzWfxJcAHO2o/etdDFG0lvH+JPTHVyikm1R/qC0yE9TW6m6dXVEe6TUCuYsYki9l1ZJR5RjUTiZLlPFaYyoUpyboctqlepsErwdmFrrfxvRzWAdzhjDsmo7ZiI+CfS9NPHggcd2AdOsDGCaxhj3L2NMYxrEKBz+5IAJlwu7caVY8jJvC7KYgWA+LcEC/8maUslbwe07Vr0yjdpOhcSeNGUgSpAQQNOoS8gcNFhFRI/JcHtoiCSiIo1BGkSjSL5U3ZxO6USpnr/DxmPFRtTSjfw6VyG1ClFp2LAhxYiJyEi/6GKHSMPcXwHMWJCRGUaKiEXqSllRZx4paiDWWg/4qhFQrDFGrETzTf9NXLAN479UVcDAeLAbaWTGnRNjrGgTstgwfswoIe0TNBPoe8FNImtkpCFI5oyxSX+0lVRqTOnTftLMbeJj1ZEHDEzCpzIK89vjYKVgHnjnGKJDHIx5pYaJYITa10NMmt0u2lUqyfs6kWiTQkNkm4eps+ymysJH7vnnF7ymWcN0s8aRX5HubR00p4p58GrURN7SkJmjEos5C+xy3l2YZabxoqq0pLZ240hSVm3rJ7CsbyY5klU8H4EmnUMVGXEMcWYzQrRojJtKc1jDBh7ZbRofahvT+PCLBk3TGNM0DeB+3DTGwBiXIwXGWSg9WVQUnb8WIkXUtm03ftSs1SCL62Rtjjebtj1yf2rtxtrWnQVVm6P/RZcvaqah67KhzFaRh0MB4zYO41hyK2Nc+zBMT0g0wXQFRj6OEeFgAziIvGmaZr1aN+v1er1e7+zs7KzXO6vVyjRN06waB++Y4LeegOWu4kKnm4tKiJBogu6/ftj0Aus6ZJrZT+If3A66cgfbrJvGww9BHsUP5LGJ9QEhQUhMIIBX2i1YCwHsR9FYIsq1eMIpMTqfCE7LpSa0v/jYeIBaI9917RhK9AqTrXIWw1tFmlt8TMlv91MQISVFqLJUhBpk4jQ534WsJCrxpSaYw2cRqnAmQM0JQTu+g/8ThV0oOMpX+0gMxt6+0xIJVzKOgWate0apneRB0cF9B0lc6D+JQ2ae45vedEDW6JLozpR1gtdq1battk5bwOpGI2fVtfBdKZ6oY8G1vLdLIL9NwzS8gYj1dz9M4yicLgI1DYCQ6jaNAZpV0zQNsGqaVdOYpmm0adSsGtOgaQgamHC3MX1cNn3G0rGC1Na2bdsa4ML+xbvOXTy3d37drJ1jubVuxrfNpcpV1f2bIXz2t0NktWDmUM4ETKm3MY+Arr8Dje/5eOwkw5oYkWWrlhnrPNdAiZwQtxs1pmlWq1WzalbNatU0DjFfGSBvQLoKgazKOosMIYzVGBNogZn/R+AKxFFgNw1mjEOcVPX64fUr16+8f/3K0bHurHdW61VjGpAqCjFoSFrCGDFq3YYM7whBQSN+NMmYOHbuhhydri5ckubVevs+uVHFBSYHhTswLit6QKuu+So5Fnn7dpGhs4IK4DvLk3n8iSGn1w7JWkqtu5w5kH8bTwFjybEMiGpqazAN4tFR3uNyDUywrEjLuKaB9qgRZmCmye+rt1hKamY2VUAxeaMm9ABzuC9luKzn+GWMRd7SrNwHI6d7Kgx356pDpu4TVg2ysJa2ta22rTf9ajcUPx3g4N5swiCTbUtd+ZR8MJYwKSYh8ljdUJo45i6MANYYGGsg4npsMM0qpHBNa5vVatWorrURaRBZscbfe5AubF6cmOP2+Oj4cG9n755b73nk3sceuefRO2+9+/L5y/u7e6tmlU2g5iZKRVUdXRHZHwPMVfuICXg+q3eCPksxbOhRnwCiplwFzBtNzpAsP99kR90YvnbyNQC6RBqMrKMxCe58JQWBn95k04ABjaoebg6vXLvy+juvf/mFr3z1xa++f+293d29nZ0dx1OEmjxTdpfFRPMC1UyDxkRfQxROYcV3cz5IKBwVur0u9CbQ+l91VZ4RzCIMTXkLDxu/Dg68D78nhrBM3zHWDkshRoLQV/OTuOpngzW7vVOgTKkHUmMkD6y+gNYItmaobmifiB8kDllbmjJyFN0UajW2r2IjK5M5Cwdc014owqhfKawMP0SllDE0ZiajZGQZhLJAVcWq1zHcWPX2CDbkua214j1vtdxqSpsdZjx0HwMihhbuSDD4EYbhSycoFXRSFMaV2wJrrTWmaaxpGm1Wqqv1ymV9FrIWiDRciQEaERUD491JewoeThf8+uG11Wr99MMf/+6Pfe9TDz19++U7KvD22cibfqc/auSp3d3dyxcuP3D3A5/92Gefe/W5X/rtX/6tZz+nqns7e2jEO687QoTvNoqqhWlCRo3Mn9IXnM7RDoaDs2QcIlfNAXMDP7dfdSKX2QZmnYVa6TBCVMjr3+qqjblApuNVDB1mCkmipUgN4g+DTY7GtkOIyNG5Gk5Ln1GwP1L2U2xWVQpo1ZuCRA2QKIvngq4iMJ8kb2nH1lviraTGXKzPMxmVIekblmF0yJ44lxUpLDCnyQxSkf0eznhdG9+qoyB4NFN9NW3txlq1to3NtN4WQ+kW74gAkpMaTPrRTlAjKJ2IU9HyCjdJw8+3PAzEKgAaqlFtAsVfhStRijSButkYERtdZ1zpykxO062lw81Rq+0TD3zshz/zo59+4jOmaYQSeG+8GRI/xAcAA/PY/Y89dv9jf+/X7//5X/sfjzebXeyq0LUT4ZwwlEDgiwlcfcQ4nOS0kuhpFPkfMrf2boQlaWBA6SXFHYHz5C+DqFneAQ5Yjs3OUk4tx/nCf5pw70+tyzGFMVTAS0aP60xzIY6MZY59PhYGccXAHQ1NaKsaKDi+NWYDN5aBZBkyYnW4Q5rjjL9zYjqOfp6zd31yjMC2Tc05ZRS2doEpcTaYi5j1KbcsebfV5LOk3mU07qX5RH/7ZBYX/flRVbbqY21rdWNbL2So3hGBqjbWD1nQTQopyf8r0eQQG2GrZuX+ZRzfEoRTuREmu3DPgXcStEGMloQaF7XbRiDWwkBgYYy1CuPFVYmm8bThCMw5aWZLvXZ47Zbzt/zez/7Ij332J/Z296jcbDY3g92NkgGTlrbVdqfZ+fHv+fFzu+d+9pf+xvHmeGe9o26+17OOA+7tumqqMMavEIe8mAjRBg5DlDsPYdUrkxUWvwWYx3qqWxTrdb2FDBREcbthG80/hJJ+/rA/pZBFiEG27I3mnlSuew4/H5QBqCHVZUc+MbSBE9OWYeI2c1kJ8K2jkQXTVDdC5XBmDcRxWiZ5ogRcJPDX6Z1s2s3h5khUdtY7ezu7F89d2t/d31vv7e3u7ezsCOA64JGqGynvOYDXsarspVqcAm5lOebQ82BL6b6Lu6FbRmu1de0y60JtoHoUaGMYWCG724djO6jq0ebo8Ojw8Ojg2sG1awdXD64cCGR/99zezk7TrOKKLIbl/RgTPeZAiFG18AJxUMfndHQotXTcTRE6ucLCwxLS2vba0bVH73nsn/zhP/z0I8+IyGazGbG4vvn40LJdwbE93sHOD3zyB15967Vf+q1fWpnGywqLIKi7R+JhcNqDs5v2czKAMOgzxxyVRESyKMSQAbBJfdChjJLisAWRnnZ4LfhKkloCFqdJkuvrcbzz3q9n+55g9LoDSN3/QMVwfkqBlu8hBfWQnEbuSIHF+lSVVAK0NjTBgkC0C6OWhKpKbNG7/4ccWqNbhCec2tBNshtrrTVNs7+3f+dtd99165133nLXHbfecevlW2+9dNvlC5cvnLuws94Z8Xi78Zf8qeN3rW2vH1y/ev3Ke1fefevdt15789VX3nj5+Ze/+fXnv/r6m69evf7+er1ar9ar1Tp2SMJsEF2yaoyDe/ycgBhYqy5RVlg1jRpCCdA4iqrxS9wJ11lrD48PPv34Z/753/fHL1+83LZthOEpN/GEG/FxtDna3dn9ye/5iW++8twrb718fv+8jwDGiN+JjR+3CBWxQ359nYVMpsmjSyb1M1HTM/CDEqhtxHUFilV/THh0PaWpiyW3Tz0SY1i9TEo9716vnLkmQ/TRi0EyPicgtBlEEKfHpBByVvUUXZ8lRw0Az9wXr9Invj1PQfJQ1UQIo+WmPT7aHLetXTfN/u7+5fOX77jlrgfvefC+u++787a7br98++Xzl1frVX6CVLW1LXPbg2+b/GO710CMMZcuXrp08dJ9d98ff2WtffVbr3zzpW/8xhf/4f/yW7/y/CvffPe9d9brnXN754zJXSzD7ZA2aVFLY7z+gGEcXqHXkEsEPwDYtPZoc/BD3/V7/uiP/zP7e/vHx8c3I9pHI9s9Pr544eKnn/zUa2+/aqkrabzKttfKd5aapoHnjTCHErzmqjFBDLSr5VNZzyY4uHHQJ678zSof+ZGSpiMV8bDtbiGwyoigM84kpc+pTrbMFd+HMv9NT1YgF7n15Fp6oSDG2c2AmKrngkUlFrpsVrJnxbFzDZqvGibWAr3UBeXWtkdHB5tNu7e7d+flO++5496H7n3ooXsffuDu+2+5eOvuzm4mOS5ta4OUdG2LuplFDbRKmlXzwL0PPnDvg7/3+37k3ffe+c0v/vrf+aW//Suf+6W33nnz4vmLO+vdlKJIuOhBv1shqjRen9sL0RKUhlG4y4IGsNZeP7j2uz75g//MT/5zuzu7NwPuRw3ilaceeup//eI/fP/gysp4/BbOxMcPLntNRwGoXkYzA22zIQS4+XwxphM9xwlhqLLhg64YTF/3ElLhBqZJoMkCuBfyM3OLlK2WgG8KuAWEXEaljGMlmkRk4qBCCPEZFcz1JDXw9z3g4KGEACwgqvx7EILqpKFE1CuxeO0oeqECrx9t6SasNpvjVbO6/84Hn3zoyccefOyR+x695457IgAb09ibPe4TtkrssY3x95ZLt/7YD/7kj/3gT/7Wlz73137up3/ul/72+1ffO3fu3KpZuf6l8w81oDfQcm5fVkKWG/TXlHRgriHEkDw4OPjk49/1x37fP38z4H4UH9baOy7dfuctd75z9T02hBgx8NCTetkGz6KNusUB6Q1EaohXLM8tVVxGbDgErxJ5QMsx0hwCXkk+ISYmGyfoxNcFcqsjXi1ZnJWqSZqXbRfTTwPzMTaN0gq5ZkwJF0jwytPgAOGGxyRKmMa4HIflY4D1ev+xAE0DvtG2um3bg8ODBua2y7d//PFPfNcT3/XwvQ/fcvkW3wjK4L+bjzOJv2opXJnVp5/5zKef+cxP/tDv/3M/85/9+ud/bXdn59y58yTVEsZQoSJNA6rQqqt8vOmuFTXSUFQFhqAY4PD48L677v+nfuyPnts/dzPgfjTTXO6sd26/dAftVyXQq1FIDzi+rqMjQjJfbpgEKXhJWMeEceJDZeKYyTIY6TEWIHV/61X8e65k1cckkFm8zbgluvtA1UsYeeO98onOpFAKY5cBYZyMw5Ds9/x/vYKNRE+SyO1N4dVnuB01kEDZ9U8L2rukqBweHrTWPnLfo9//ye//1JOfuvv2u706lVVr7U104APD76xae2x3dnZ++Pt+9NNPffa/+Gv/n//6Z//C1atXzp+74BrW9ETM3giiUpry/iE2tl0163/sd/9j99/9wE1C2Ec36JrGXNy/4EfLvIG9H4twkQjq461oX5exn1aaIUJCIaMIqQbZTvhdRZvqrvlE8amaXtqhhg4oRrJUY0ZnGJlVe48wYRg8GChpuFtpM1Qi4/uTudABmahfUeArTDg4PTqFwt9yKgnPDQMOqoRSRC3VafczcMXc3WqtvX5wcNetd/ze7/6RH/rsD108f9H9UAfw2ZuPD+BxfHwM4PKly//an/o/Pvrg4//3P/8fv/3eW5cuXKKBl82CUkAYFdJSjKBBXBomTGweXL/2I9/zY9/99Pck0aKbj4/mw1O+lDQiSmmSyAEomSqjNz/zrEzCmCiFE6NZER4hoDpKmRdn8KKjUTfCBy7Tg2ER81z09WiqcGo1cx5g3eYjGd3li5J2UdNhMbl4hk/ymTaAaNoYlGayga0o+pUF3JjMuvQ2ZriSnGLin9Uxcf3oRDAYdGyy6wfXjJjv+8T3/WM//I/fd9e9Qjk6Orq5vm8QwOHw8HC9Xv+TP/lH7rjljv/Ln/n3X379xVsv3RqaasES1AqNH0rzcrbGb8+Hxwe3X7rzR777R2HMzcv6kcYWSLatDbYugR8mbGACw5YpYrqgFFR0I/0LfnIsShojt43wrw0OqSEkIgtu/bE0Bmmg4THhZPsz1KdjN4AOALxZBs56+EY2+xzhha57SnCqM9J4KflMv6ZQJo2cfac8HnJjX1laZq6UjG4Fzow6ekd6jNeqKNXaK9eu3Hbp9n/uD/yxP/WH/tR9d93bbtqj45t35o0ENQCbzcZa+7u/94f/o3/9P77n9nvfv3qlJGMLo+1wZAcGmU5V/e6Pf8+D9z10E8b9qENOVu2V61eQrJjcaKLJXNCNMND5PaNfggdQgxjxcp8wsgh6SIADUoAWybyE0Dc9yyFhpKem10gc1whqb/GfHjMBQ/+UkReRsJUGYbOpM3hel8SDjmMOyVpdGQhhMAGu82b2Gm4oJ5fgvaDC3ITC9akR4rWNiK4Gr2zvmK1R8Z/k4fHRtevXPvHYJ/7Vf/Zf/eHv+2EAR0dHVu3N5X0Dht22bW1rv/dT3//v/+//w0vnL75/5YqIc4bUIO3rFCVFnUG6FSpb295y8Zbvfvq7ZVID6ObjRg+52Gw2b73/tjHGhQV49VwfhtzMr/cLERfN3NAEoipCCl90lpWIZpBBbdlHWyMmC3cGkiepkF48NBMLuBs3OymwAQzE/7OEvYv6X9jHhTvSNoA3rDPijUqjhS+CTJsP0LTimbkqoj6IindqiLltwBGSWrm7J72Quahcu36NKr/vh/7An/6n//QD9zxwfHzctu3NlX0jPzbtZrPZ/PDv+tF/60//ezvr3esHB4itU40wkpPvdg69enR8/Mh9jz14z0O2vbmVfrQfTdO8c+Xdt999u5EmRE/jrM1MrNxjhPVzat5KDR6YNd6EL+jZiw+7xjjR0AIj7fwjwc5N4gflOe9qZnBEbjtbCZARzlDpkcAGjCl7Y2+1+YDAl8iMl1xgja7phIgNo7siXoUmSQGHfpqEaBstH0IjW6Ouc1TRTwSGa9evXTx38Y/85B/+oc/+kMhN9PYjk+1aa1fN6g/+xB9+8dUX/7Of+k/bnd21WTMxVowGHx0aUbJt26cefXp3d3dzfJOu8BG/+gYvv/7ylWtXGueaAe98J0mD2SekgIhJHuro+HQkLZvyv/7ppioklvlMoEhfU5a9dDGXWXSm8RwZvvBCaVmOPIY8eHBA0h9KMXbvEMUwIhKIP8k5NWq/B0VE77kuPtX17+GkcelZX0KxNvjyOaFBq2HaTKliW/v+tffvvv3uf/mf+pd/6LM/ZK29GXA/WmH3aHMkIv/SP/2nf+x3/cS777+jGnQ1bASeHMigx5vjSxcuPXrvwyJpjvHm4yMKLIjIN1/+5tHRUWMakeCeIQY0TkrXi+fSgKaJwdZltYxQLAgYgQlEsTJwmaQClvkG5R5CWQzMfgYYSHMChRLIIG7biBj3Tzq+igZrObxbZsGqJerANGnmZYgl9+YGFT62qjMy1TD/4KBe7ypJ6wd6hUILT7x1Rl1KS1Jl026uXr3y8Uef+d/+M//K0489tTne3MQTPoq33/HR8e7u3r/+p/6th+975P0r7zm1IwZxyShFeXB48NA9D9975/03kdyP+mO1Wr1/5b2XvvVKQmOjQwbgvO98iubTVuP9eaILVEj7jPhXpxZZD6oN8Rs12LSaBfvBt6VobD34jmbHZqTD5n/LXLAxGUt2IIg0jcYgzEbJbXI9FCuaQQeSyeBmQ2UOyrMZt9eSlptNe/Xq1e966lN/8p/8k/fede/x8fHNdtlH9KHU4+PjRx589F/8I/+SMea43QRl6iRO36pa2z7+wOP7+/s35yA+6g/TmOdfefGtd99er3YCrEoSTi8us6pGjKa5vm1AYCXjESSDuh41gIOtqRyNKKctku9vaeNTt+zmjKw+rfbBYF+ycaNxcfaCIH/rpSMDGQHJhVegXnUv9NAYnHjC8FrwlaVX+lM3jabeJEKjxIKKUK1XErOtvXLt6vd9/Hv/hT/4xy5duHx4eFjE+puPj1zYVaXyn/iJP/KL/+sv/srnfnl3dxeZwBzJdnN84dzFJx96UnJBj5uPj2LANUZEnn/1havXrly+eEuINkYyy97g6G4ExgRWA0LvPTM7BbLAhW4IK+IoCwkySClNAxFGtgJ1KL3FjH8mvn6xIQS4VoYUIzVaOMRBsniQXolagkOuj/++JxbeTvM7ydPDvIhf1FIQqlDV0gEJGn5uvUdWu2mvH1z/wU//4J/8Q//ipQuXDw4Obq7jb4PH8eZ4b2/vT/yhP3nh3Pmjo6PI4VYVUjZ28+DdDz58/6NqbwbcjzywcPXq1edefs4YEwQA4GcNGUubEH8yomqWMjo6F5IXsIhDJEzyrKya8HTK/YGnOMii0+8ahQgw75nFEaDYNCKm0fQ6eBnlmCinLcKUfG73IMFwVlxglTQUHKx8owCuaiTciu+UOZcu90NLKtq2vXL96qc+9ul/7h/9Z/f39w8PD4GbdgDfDg9HQfneT33/7/6eH752cD3IwzmQX4XyyP2P3nLx8k1g4dsgz331zddeffP1nfUumVxfAusUUpfrYjShdJhvDHgQoBO6PDmXvUCLKigQ4GHG+YrVKD7QPzTOeeaAwktx7JnNX277IplnWWiOeWaCH/SFt+GJcC5dIozwIlgJkw1ub1P4EQehVa8wHjrWQdxG1Nqr169+4rGP//E/+C9cPH8hQgo3H98ej6Pjo729vX/ix//wr/7mPzg4PLy4XgsJiqru7ux+/LGPe9e9JQ8/8RnZ8oOu1fN+Wr+Vlr1kCv1b9LmnD6b5+fuzeTihrudffeHatWvn9vddiasKl/M6J3pVNoaBbEqKmOipgxzRLc6X/6vJrPcirSyMAfdM6PtaX0lXrAMUzD/RWzvJxAN1r47Tvcb7lWdQb6d1RkL8YAPEu0d6ADekLn6KggpmUmFaqDySUUXXugCu1w+vPf7A43/iD/7xWy7dcnBwcDPD/fZ7bDabH/j0D3zm49/993/t71+4cMEtrNa29919/+MPPk47axkbmNVqbZpSqlT96HDWWQFKX9btBP+x7fN5gjcZPN5Ct2rZB7gXuQTnjG6uxjRHR0df/ebXHGPU+/gikxKQkLk1FUzAxEFhxpEJP3xrvDqDQWBLQQzTXLC3UBuVu404MVaSdYeQAAsOnDhMJbO1p42Im6cIGxQqQy0Q7WXLbL2UXhCpaYqpp+P6GO3FFrzMuAaw10vdECLXrl+/fOHyP/37/+idd9x5dHR0M+B+Wz7atl3vr3/ws7/n1z//a7a169WaIpt288SDT9x2y+3j1JRVs4p2SsfHR2+9/fa7V95+7+p77199972r71+9/v71w4PjzZG7X9WL2Em03hQNZAnJc6yB+yxvlufhLrmplploLICNn5dyEYRJjMUReaDOXSqWicmD2c+yGgFgjDEwMKZZGWOaBsYYNI0x7vcmG9/yDepisKlIlCQ6j1KOjo+eeOTxP/Cjf0BwJr3KxjSvvPHqa2++1hjnT6rQJtg0CUkTzygjL0xQqCXAj/m6WCsmsmpNMG2KoxJxjK2Inv5tIYP7VeHNE2a8UG2RcTiwooYtJGS6ZgjeN0432UILXAOB04ASsZGd62wcHAMMcCTcMFIRhUy8sXow8nUsBT8z4SXE1D8DB4cHBs0f+Yk/8sTDTxwfH9/kJ3y7PhwK9+mnP33LpduuXr/iOeBWP/nkd63X6/7Ai4FpmqZpGoEcHh6+8Nrzz738zRdff/6lN1587c1X333/7feuv3dweJ2O85IJMzuzY/WdBAkglhcO9chaJvfcyUrjKFQeVmOg9tL7fSnABg2AxkAclR9hGl6c4wmVaq1rF8fZy3QDerq+aRpjTLNq1k3TrNfrVbNqVutVs2qapjGN8eP+yFpRoFqv7SeRkuklAKn+W6jaw6PDP/FH//jO7s4ZzRahwbMvPPv+1Sur1cpbJsKb/nLFLNdNs7VICa34kTQXdQ0Ms7/6eGqM0Nv0GALGteiM7z2RYzl/+tBVLWhOFigLYa+eZ0TSTyD7GXGYfMj82RhdbhjGi4PCYnJ38H/0lDK14jBcDaJhqrQU610pXeqhVo+Pj3/iB378Bz7zu46Pj629ycP9dn5Ya++5/Z47b7vj/avvCnl8fHTXbXc+/sDjUrLEVs1qvbMWlXeuvPPiay988RtfePalr7/y5suvv/nq+9fea1bNqlkZoIE5v3/BExEjkBX16ayPwmq9n17Me0NWQlQzIU8HBXr0zFxxvwP3usjQeINbQda39odkqVRaST0MLdozEIExjTHGNKv1qmmaplmvV+umWTWmWTUr98s4ayBxqD56sHqGpvdcyG/wzeb41su3fv9nv1/OBtIFQMrXnvv64dHhpfWl0LcPO1bqnkVDhzAUHObKTEQSouBNyOmdVG78rcMWJPXSnNcpOirkRfSLUrzC1ewvxW7ZMw9b6IALkEx8MTnxZPashWCadGzTVNQr1BChykIy35UcrY05r99xq4+Dg+uP3v/IP/KDP6GqbdveRBW+vR8kd3Z2b7/1jq89/zWKHB4dPfHwx+6+4x7HEiNpjNnb2xPKcy8999tf++3Pf/13XnrjpfeuvLNpN0a4s7t75+7dSuun2NR6lTtRY4wPJciShkBX8relShDOy7np4cle5rpq6BJcTxygCEnwgiBNn3p1bamzOZ1JK4JiycD9y1y/MGRuTs7bhxiDgBhgPgptW/vAPQ88cM8DZ5TWrFfrN95+49U3X29Mk+ncwuR5LYMdbhIkRzzNLn83blAYAWNBpCl4yMEApBhI0OSV6BgcPxfVkx97aANRpo+Wo6d9O44/YCDPZVxE6JXxzqVI4qqkQKBUJtzD+M0TWV8sZBY+sHoRG6coFvQYnfaNxi1eSDk+3qxX69//u3/f7bfefpMZ9h0Sc40xF/YvugY6gGce//je3t7h4aExZndnV1W/+PUv/upv/+rnv/47b777pqun93f393b2yLZVq0p4OxcYB1YZx38gDFTVigUMhBBLX66pk2cN65pudjKksZhRHfpA6nIMaDSoLeplIgMgkbOB/A4Qu+7OlDVkaZKIF4hSUEFZWGLz2o8SeBsxj3YggsYh0Ku7j4NStW9jbdrNJ5/6xOVLl9ozIORBpFk1zz7/jbfffWd3ZzdRayGd2QRk+ooiYsSYmLG6MAvxoRYmQ3Mb70/pNGyjzwTEuwa7PweAOPwsD29GQGdyvpraqTDWx5wEGVj9QTwNQa09UhhEC+Eyvz798glCt4GakbJtL1FBKFSC/r9393EKOFQr2dywu+WuH1z73Z/93d/9zGfaTXsTxv3Oebgu82azue3W25959BkR2dvbo+WXnv3iL//mL//ml3/znavvnd/fv3j+YhTFsbRUY4RirKgR4/rfRr3hE4xRVQWMMWLVhtiWrKhT6RZiJYvIyuw2G9v92U2G4iBnyVeLGbLL7pi17+I7MPP3rrErQvTO2kSQsQSXIaei5hmaUo0xn3zmk8YYexbds6ZR1W+89M2Dw4NbLl0uM0Unb2NMCCResSZKjkGMaQBjBJn0IoKWo/OXhJ+NyAbMwjMZx2gbwGW8oVlnyiBqREQMV7Mj6QjIu320ylcAiGA8zLz3mVaVQGhUNOfw+m5a6EuEms29lc1s2ZBavRQhDw8Pbrl4649+/4+gMZubdg/fSanu8WYjIq22D93z4GMPPCYib7z1xs//6s//g9/85XeuvLu3u3vbpVvSbk4k3ZPIH/Iq2GqkodGodAdoaH8TEI1BDhCl+1cyICwR2fR3FLbbPmB7hkCM3+V9hwTYhTDKSB9OGlK1+zVr4BeAsvdUVbIpwQqUSGFM1ZlN7eclMeXw8OjhBx5+6P4Hz+iarlfrt95757mXXlytVp2GVb6NgCF5zcOr19R1XDDjlRE9byEIwjhgN0AQIRiZdN1AQmCMBHu14kwVWFA9z8VoGO0bA6OPZw/F8UyAsfI7yRi7MR9wtg4aFXMJT8dJY2cIFr5e4Nw7rXiagnficbN/4sd/2Vr7mac//eiDjxwcHJwdZ/Dm48Z6QNq2ff/quyJYNavPfvy798+d+4Vf/YW/9Yt/8+VvvXx+/8KlC5ca04Rg5xQ9oky+NxuEMfDdJ2dN7aTs6O5MGMIP39NA1b0qleERKZBYsmc3UoQd/Og/MszXAYYOWMuT5DwGUilNZ+zTN8iUxgnuaXwvSM46y0RZQkPe91RK68OYL4LuzBBUso5gUoTctMef/Ngn77jtjvaMtImBF1954Y23Xt/d2fUYi0e3aZjp5kZ1MMDHkchJEDGmcdQFY1IgTg454jNiiZNcDtvVAJmaINuQYltAhECAQiMiVnQSW+D0Ki6fholXmegiXI/I+ct9OguKQmMctiGvBfPmKY3QgnDh1+ErZGYxKaA4uRxu2s1tl2/7gc98v1rLDu/35uPbOugeHB689e7bAG67dNttl+/4cz/zn//3f/+/N01zy6VbmmYV7AJSfgJvX9m7IZAXaiIGUAKlIAqMQOP9l6rqsMw7Nw+D2FXoeKAI0mS4qVHXmyIM/PRTBySghPFN49phzGG+7Ft0uzcZk7XMixlooKiIX6XkWmTTtns7e8987CljzGF7+uOdxpjWts+++M3D48Pz5y+62apazQ63UcDnqCZzyQEcqxkmv3gUY5Jeo4eDKfQ/pYcfguINovh54ffL0LlzPVJiNWOIZE4wwlTu22nKddwfuh8ShW7KeWBSgyxQYpUXFAVG39/g/htgYDeW5rm6m+PN08889dA9Dx0db25G2+8gJBfmjXfeeP/q++tmLcDf+Ht//ZVvvbK/f+783jkkMVRIVMaXzNc0aH74lgKzmYJOv0oCwdaPrVNc0yqPRazEcB/jksYgw1hmmqEgsxQqsSpj1M068f3MCP7/OdIW34FjFgb5GGwX+vV7AejrxfKOOt4c33fPfU8++qTjzJ1B6YJr169//YVvGNMgnD8/ZOWGGYBCozHivL0vSI8nmCArk5HKUtqKxOVDYvwBJTwUNm1HVEMGLpgRMFwKgGemnFi5+vLZiPByVxtFEkZ8S6/PX1wWL9Ye5H0daOC6FoSGLlsM1M7kgQhTwEjhm56jDsqmtTvrnc889emd9Y7eFMb9Tno0jfnmi89eu351tV4dHh688q1X9vbO7ezsiisnmaSkHNM0ZxhqNCxVWqVVq1RrrQ3U3ODeTinHTZnpW2fmLxAUmQaTKBR8GVd0giJNAZIm+5H+GiKBJIKCZyswGlpFh5j+EBxiyw9Brs+bibtpo5jY593/uJX1Uy+fBVNIeeKRx++5857js+maNE3z8uuvfOvNb62apkhwc7mrvDeUk5rzYOwWgEnGDhl71xlGoDCDMD1/CImQQ4ZHhBgdQRtTC7WcaqZhMuwyLzgomXwCQznjACsjlaGJQKLxVZBkbV8/bOfSBo8eKEXdeHUwPlME3pj6z4yJsMrh4cEDdz/w8P0Pt/am9cN3UOvM3Rdff/5r165fN8bAmPV6pzEmFX6501Roz6oz8/Hqn9Za26q1alWto+k6MqJVDezFFBJzbTykKSWw3hqRsv9TirAWg58o7ixkTy/o7AFi8JuImXcXM7qyJD5RCgtZe4qhgZSpIOasCyNGqTvr9ceffGZnZ23PRN2Gq6b5+nNfv35wYNDk47ySjdSm0Cj5v4OFOUM1AZYJpsE4ky+RqhHlzzlwTWMWuBrtj43AC5hDFGP3r0x9WSk0yguiole9FI+F5XMSyZ49tNCYoPqwuLL53/gq9XmLVWutfeKhx2+9fMv1g+s3gYXvFBwXOHfu3LfeeP0f/s7/KkLj6ZVZtwfI+kkMkveaSYFaq6pqKdYblfpFrFFeKRf/0BzYZc5jzf4bEQTOgPaKqac6EZPIMQkJ6G//6W5MAwVqEYEMSL0hlgwT0nfyYAIiUaz4HGt56eKljz/5TNvas7jXDMzR8fE3Xvzmxm72m/3CmwGZ9mw27hspYhEgMJ5166fLvKK5AL2eFYq+VJYwk30L9ciZyiRmKZw7h4YBcHZ4hQxZn6UoG1dHrpDBPBpHeXI/Zs4EpqSA7dJbeG0nR5b0FtpuGkKjzSRpuTneXDx/4dEHH5WzlJW7+bjRAu758+efe/Gb/+Gf+b9+7bmvXbp4ORbx6I4jicQZcqqSVq0Va21rXXprbXT18du7+PEehsaBqGuqJKsUOC4RoYEU0BmyZIrCvWMP"
	B64 .= "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"
	B64 .= "L776Uia1qILGTVTRFPbxXo0mLQHk26t4Hx1Joual/L/njGXSUWldKDWCCZaWqmpbu2lb27ab1lqrLvI6WQ4rPuIGF/Oo7ZDciVUgK4HxIh+FOVSMvlk8js49IS2tXNRKqEw/cj6R8GiDH7BT+CmGNNwQqGQArBt8Z5Lup18B+ewvKYS6EdYIXfvXOVOGX/zVX7qwf+7Hf+j3UuTm4OYN/lg1qwsXLrz4yot/4Wf+q5//+z9P8PKly57wF4QVktEZkclXR9gAyXTdPzWmRoXOddy2UcfSQCWApx95andn5+AGa6AZY46Ojn7ny19obbtvouGIyfTS0rhzXo+GG9o4nVShSiYRFBVTBCq2scYq0UDUKiCmBYwRStu2Tzz82M7OzvWD66ec54pcvXb1lW+9tlqtJA20BE1xEYgTZPTIhwdLXTLs0Wh4ElkUcvRKykHuhpLN2TOjMRTRQ12qT9sGOOG4PbbWtpvNxlpq21prGeQ/GXW3ctIIEnZLP4eWC3cx32rCCu50FJCjC97cnSqRA8vuiH+It2QiKEhQqkm/jvwVvz2oJmFGZmhDVM/NHdCilZoinqsYpVdmdf344L/9uf/u4OjwJ3/Pj57fP3f98Kba9I2X3gob05zbP7c53vzNn/tbf+lnf+rrzz976cKlnZ2d1JKmv9GSfimYjTbEQCPJurVwpzdhisL1ZLqDz5Ed5lv8yk27ue3SrY/e/yhgbsCBxm+9+cYXv/LF1Wotkr65UxDOdK161aJDFzQgel6lsHheoOY6SqfXo/BYrzGHh4d33nHXow89jNNGckWkMc3rb7359nvvuu6Zj1cQP3zmCx1T+jW7LTWRdZOvg3uHxoRZRYiIaUxkE4bdOjWblGqpQrGWVlurdtNuHKaw2Wxa27Zt29qY5GqIuQ788Gl3ly/uOweRn5u7T2ZBGDE4Fn3d7H2iZHpSGh9TcY3yKWkWuCuvmzA4BrDf/zEyJgsZlqDt71X9CYhqJt1NUri73jk8OvhbP/8/vP7Gt/7RH/nJ++697+q1q1Yt5CbOcKPgCTs7OxcvXHz2uWd/+m/8zP/wP/3c9cPrt1y8bNYr3xfykFin7Rx5P7VJs/TEsLxRr8wSsSGXaKOIyMHh4dOPPnX/nfduNjccmNuY5tnnv/HaG6+vvBBzDimYWvrIqOBCgUAT77Qz7c94vjQOhiCmx1auXLnyvZ/+nvvuuf/4+PRPC0Veeu2Vo81mf2c3pYCMmuCh04eoPw9f+hTQtd8jIobgabxpjVTSf1I1SCi7Zlmrtm3bTetCrQ+5m9hDs1bzTFJAK0a0Km7ty7gCmYWRpGrQHXkY6rAh16tVBYRK9L9LGa41xMUQgpOUnic4hN4qHSBBrzKYpAgdR0EEVPURN448M3HkAgV8Z7Wz4eaX/pdf+cbzz//jP/n7v/e7PkPh4dFN39YbIl87v3/u+sH1n/7Zv/Iz/91fff6lF87tn7t86RZjDNxsfLpFgjQqsykzl/wmPX+JLYscTSsFSuvCl2mYnKCIJUXk8Qceu3D+4pVrNxzvZbVa/c6Xf+f9a++f3z+fbIyTC0Y2bofMHsZArDo5UEYTPKCr+kPJfLeLnGmjSsjHHn/ywrnz711579QZC9cOrr/6xmuOep3MzUOTNDqAMHhBCEiDJm7LJvbJvPO6tydFapMFKiESe8UZgoiSdAmsVWvbTdvqxh5b65Lb9tjluNZaa1svZl+K1ELsoGMhBFh19aVYf17UPxDWsoQMedCER3jHWajGvDRaTnX6ahokWwFYtdJRjNBuOy26yND7H4QjSmTdwDOTFIpN05w/d+6l117+cz/1X3/561/9fb/3x+69+56Do8PNZnOzsfZhpberZrVqVv/wt37tr/zNv/oP/uGvUHjp0qXIUCpQRiBj7kfKAnrTOdXEIHWWIs7VDRZlXw7A5nhz26XbnnzoibZtbzSJjPVq/e67737pa19WS69R58FDlL1ByRUHs9ynNhAfGc2I4FyMvkm1+uDg8Pbbbn/myac2Z6AjvF6vXnz9lTfeeadpGp/JBQOHPHcPOmJehdEIhEbgwqswSCezEDhK4zPei8efgpDTOioY1VoHJah1BAXdbFpr23ZjtY0x1+tza6mQOmTN7dVZKbJiP/etiO92SAUoTLdA9uDgfFKbbvKHKsxFoqOPpIcItJhHCwYxjEZdmZCu5PlsBl0HrwnmroHMBWNJkYvnzh8cHPzd//nvPfuNZ3/ih3/sE089vb+3/+G62H7ntstWq4ODg7/wV/6rv/0//p1r16+eP3d+J7DBXJKSADdkdoFStHzy7m/uylKuYUzgSJTMrcP/pG03d9/zwEP3PHgDjp/t7ux+/qtfeOX1V3d2d5BRVFF805KM7MMRnSoWMlNvVs4Du8Vs+O/R5vj+e+57/JHHDw4OT7t7BgPz6huvX71+bX//XLI6KwRyPRXBlA7qRJJa9C7rrpGWvZRxRC2DO90YWeuIYLS23WysbdUBttrajUtrW2tba9UGdq7v50s35qb5xlIXLOxZqwxA5eBS7KC82XUIO2C0DOpkMbEroR4Id91Q+LAtEUugOP0FBrKXSpifowooNsg0qoNclB70ZpSWcIRkSQzuFJM9NUIpIqpcrVardvXbX/7iG2+/9b/5Y3/iu575uNuybgbBD+Vx4fwF52Tl+tRxjihidojQrEnKCamAjMhD9NSQkiWGDKDt42IDP3XaJI8++MjFc+evHFy7oWyejDFNs/rS177y5ttvXrx4MTMW8d+WKmi8GCGYxVKNPPwk8adO3oWMRF0Wbk3ISwJ3+zzz5DMXz51/9/33Tn0Pvnr96svfeg1uejmgQ8Yg3zlhDAwIeE1xJ3cDEqZxjmbip4R9McQge+MSZvhZYKU6aNLlra1jJLSbjW1DhpsYC1ZpbWtba4MHTR5t8wjbMYbs2PQu0Vuor8689QXVznRZQobyGQeHDadr735vBCrUZDZD38ETEiqq3p8y1jieoYCYNWtqrKkyWA/Gdp8IRK1ev35I2rvvuPMnf++PfvYTn7rrzruOP1QX2+/kx/Hx8d7e3r/6L/4r3/+Z7/3//qX/4jc+/7lz5/Z29/YgZboK6fBn0beSC6ywNMSZUg4TnLdjwU2YPhhRxGBVXty/+LEHn9y09kbz1Vuv1u9deeeLX/sig4pjmfCnjSOorWRoLYJSlGY0DYmzab50LfpqIbqJiJXNLZdv+fTHv+sshNubxnzrrXdffeNbOzs7hNCI8ZqdbgzNKS54ZkBgsgSMyTj8XwTO+Fl8Yuv5DCgUW8RP5zoHPKtqrd1sNtZujjebjW3VZ7vWhpBsPfzgaQoRHEvRlh2R8URJkODosjDmJlw4DB/UzRwkz7eDtG+QYKdkFjAxC80NATV9gSC2rqnL5hVJNExAJxpdlJ/IRRfK8uh4c3xw7eCuO+78/s989/d++rP33nX3arU6PDxsbwILH95js9m8+/67n/3kZ/69/8O//ed/+i/8nf/p7wpwbu8cc1QgQxu6YdKYgpzQ+wMSChz9rqQcUC9mcYIQtai1d91+13133XcDjvyuVqtnX3j2my89d+H8+eS+mUUVFK4p/kuHWwjMRvRzne0UjnJjUiaDF0CUvPeeex954KG2tacOLAjl9bffunLt6rn9fWQKCTkBLC+8XWRViPF9/9htc+lx0XeNQBQhUEQHG0cLbNWq2uO23bRt27Ybta227bENQdkGQ9IMqZTeHI1UpbqRP2WVLTvICMjAHtQL4+fC1ANpYcpB4JluyYM1z3/p2QhBIS3JKDieb5RCz3umftQ3pLEa+2oE1PXg/CA5vdBEWDduV9pYe3BwcOnc+R/+vh/6we/9vgfvuf94c3x8fHyTt3AjPNq2fff9926/7fZ/80//6w/cc/9P/exfOTg8PLe/FzUJY9rrhlyCbxWRBdYYevLWfTKGTXdo7Fb70pvBm7vDFWtt+8h9D91y8bLLbm4oYEFVv/bNr7/z3jt7u/u+22ikIG1oyHDcGXFTD745klQTOgP7TIB4/ufMnxHYtPYTTz5z6+VbTl273RhzeHT44msvB/FG99GgCIwf3vAwLrxNhOMtIBik+ZXg5yS8bY/xabqB81APap3CaFRL1xFr1Qko2Na2G9u2ttWoHhYGt7wwgZd69KW1ZAlt5kJWTX9l1dfzZreHNoTzZl3lgswQlc/8bCKLPmncajWK7Yb2maaNV1UcZuujMCDWz0m4L61EJCK7/hucba0nfat3phRVvXr9+nrVfPYT/3/2/vTJsivJDwPd/dwXEZmJfSsABaAAFFBLd3UXu9lsUs3hPlookdLIbDSSzGTzL43ZfJfZfBkbjumDFiNnSJFGk0zdHKpbFNdaUdgSOxIJIJGZsbx3j//mwznux8+590UGurOIRHVGd1UlEpkR7913rx/3n/+W3/grf/4vvvrSt1X15u1b9yvdPfUF4Pbt25eOLv1f/8//1eVLl//rv/P/OD45eeDKlaK1X7pAtULaL+qZ4q0o/k/gcXXiG4oaBzAQYwgpbV5+7sUpTafz6T11rZj59Oz0Rz//EchyZbwnNWl+R0+nsLuOY+jwr+3f1AUbOz20oTdZ9ejw8Ne/873NNN11bIGZP79588Pr16ZKw6jVvyIIUptYVKKXjS9CzWSiUXG57zJDnhlXbJ/N+7BehxrujKzFNEx1Rs5a9BHuaxjrn7oZAVbQgH3H0USB27B6amHPtreuvhBoYKvxELTYqjkmW44tDYb8lrfaFnANgiANWASa9W5FE7Ss3RBJEXS2252cHD/z1Df+6l/4vR9+7zcuXzo6OT25T1G4Z7+OT4+z5v/0P/hPbh3f/n/+d39nN8+bzcbTVp2pieC8h6CCYHduxJKnMHSy5fZjUG8ewvWGPNvNjz382LNPPlMexnvqKiWWDz/56I133j6YNswrpaV47fXltC3SXG/X7Xo6UyquvACM8+3p9uyFbz73rW++UPq/u/y+hD+8/skXt26WrIeAZHpR7TUtzCiBZxTQ2gBC1Pyz5rRrdwXGPAWAFY3oVPxwzSc2cqMiZ3bN0aJDqBa/WfHcIHVYJZbtGx+4c87g8a8gGJmj+ZYRGBzKdfsq4gYu1us1crU69Vg/W7Mn3HiiEhjKxdGslBWEXGRpqienp5PI7/327/4ff+8vPfXEkycnJ7ePj+/XtXv5i4m32y0B/8V//H+5cfPG3/3Hf3/abKQ5S1f1JPqMX9dI2G0M2L4bNDxiLlmS2jPBG+WO1nB2dvbCK8899diTu3zPud1P0/Sz139+/bPrKU0NFalhF047cENBtJCWHnhccxJ2/pgQEM8qsDLk5OTkOy+9+vzTz55tt3e9yQXo3Q/f2+62lSVWzMy4br/B4grgWOpgrjeoGb9MUv5YDaC0miz11C7FRwogWd9dCB1tBNOsIfa5O7KIWKqvS5WidO61WMK54eyaLnIt7J5d0m9XnBtjW93skNH/qxpsTFTSN5U8XRVsdwya8L1ZNWgR+Soy6iRQq3NthEt13m53x6cnzz7x1F//C/+HH37/14noi5s371e0r8vX2XZ75fKV//I//s/feOetH7/2k4cferi3I/QmN5ATuDNsHHsB9NklBYeKlaYJK5iYM/I0pW898/zR5vDGvWZSzsQiP3rtJ7dPjh+88mCw9BmrJq2MuHG/1mBFtN0K8SAEDhayu7w7PDj8/suvHh4c3Dq+y6FwU5pu3Lr54fVrsYK4WxgAaZM7Gy0BVBhlVLLWiwJNCsOsmkMgdpO1jvuv6+nC2kYokDIpCxV5GzPAdTNUYZew2a2ru2B/MFpndp9KmSAuzFvAGHpGfdxk3+RSrLnoUiLbotBAAVP6UnUg1+h8ozWAvSK3Wkssw+DeslLTDAuB227PzrbbH7z63X/v9/7qc08/fbbd7u4biX3dvm4f33780cf/i7/9n/3f/uv/+/HpyeVLl+uNLn0zgGYW1kIXA0RbnzVx7lg/kJmq1PZF8J3e4w8/9vzT3zzb3XMkws20+eSz66+/8waAJmuuwIJ2Zo210adg1cheR5szK2hMrHSOglWZ8u22Z2dPP/mNV1/69snp3d88b6bpo+vXPvn8s5Sm2rwaNRv9Sqplp1dtmdTkmy6Y1/TBS0zX3ymXuPVi8mOiG2GaByx4BA0Wv/ZYhv5G5IW7UHEfDlG5obd2kSAWtJoBc0DdhcGZWy01J/yOJTCVDSpKJW2dLBV2bWEcsOWacTFdUBTPCWguQAMIFkEEaEbWjCIiySdnpznnv/4X/uJ/+R/9p08/8eSt4+Pt/SS0r+GXqt46vvXD7/3mc888d3J2ak99s7GxTo3N2bE9l+bU5/2cLZeaOQrc5QUWlWV+ZUygOes3Hn/q6ce/cbbb3mtX5ujg8Cev/fSjjz8+Ojiyp7ABAk7wEJGShsAS0h/CTM7OWq3jt3BvaFgAQviuG7qbdy8998ILzz53173/i0bq6ofv3zy+JcU/wCxc6iEgAimRQNKoLCxSSLtSYihRfo24Z7XG1qVRSpTrwKzqub3U4E9aUBS9kGo9tllr5C2DK2/VT/FSu8sOX7Fnh7Z2y4fZDOPq7E4NcWhpNTTJCqaGikARVO8gsBrtV43hkq2sQrXAJCgVObsIQqFQo3Pcun378GDz7/7Fv/F7f+bPzjkf251xnw32dfzaTJs3rr75yWefVDfugudaEELURFQLk7jNaCBn4Jo2w1CuWQh1Pd9t25RoSum5b3xzM22OT++tBUBKSVV//sZrN7648dBDD1etO8DixDnXfdTZWoyNH5AWO4nKv8ECUYhjqVmnZtVN2nzv29/ZbA5Oz+4y3nKwOfj85o13PnyPQFmVNZfKJZWX77xAi7oRqeVYnAhV09RRaS52roKhRKLEQloMfTxHPKtqRunYNPsOKRICQlCCzwPa1UOpMj3rpBGjdZl08BkHpj/RpRprma6WZoRNcfFQoLgKdGgYJtxAXCGS8VZaYk9ozWu1JdXjk+MHLl/+9/7iX/2zv/Yb23l337bm6/3FPKXpx7/4ybXr146OjoKH2GqT1M97fcwJ90bc7bZzkWTphl0xgHzl0pUXnn5uzvccJLWZNp/d+Pxnr/+8RIFZzg43smahoFYWs0UFMMKeh13K22n1ELaQiKvHuvLOOT/y0CPfe+U7v4wI7Smljz/95J0P3mPmeZ49LyejyLjLUtQqKbt9Tc06k1JbwXVD395qRQ5yhtsGu2VApupnozrPmufSuvU3SGVw21wVziVp8Q390uwOHd4F8FwetmctaLKrp+5grpEV6KQwM1Vsa8CW6qYVpaWyP7QEt7ous/2aqR6qUW71pciVPHd8enL56NJ/8tf/g197+Tsnp6dZ8/329mv9dbDZ3D65/dNf/Gy7m69cTgTzQo0W28GGIWxcalRrmJRh++0qBgcUyEBq6SRotLE556cf/8aTjzx+r3mJMXMSeeu9t99+/92joytUPdVa189+4jiLzp8ARd33w9h19giaN2ZmJfhcgNavlQIwz/mFbz7/zaef3e3uspeYiGTNb7139dMbnz/80MNzSc+Siq5CBWIwZLWb8zWWULC8Ke+SS/Nnb7PUFe1XqEUYogAo54y5Ju7orFlLfWECI5BjCi5uygPvdoswb9/VWKWBrWILsWhb/FRzNMcfS3nevWNy1ra7kBuWX8ESjVyF4v+rVJAE9Q0cVX5ZKbhH/9Ff/ne//9Irx6cn961qfhWAhc3B2++9/ebVNy8dHkavr0oVqvelDXBciQe9ICKQnVTBUlJPWQGizJDqSl0SXpt8fp7n55965vLRpXyP9bnMPOf82puv3z65feXSZWYhMxceicgIK8PKAOAQ8sadbBUttcv+RRf+UH612+1+7dXvPfTAg6dnd10KQccnJz9/8/XieFBedvHGhYgKOJg/GMiLSskqNC8t+7AmfWkkr8qXY/Wp2cRZpepmRXEKm+esmHPRpOXq7qK1IkZzTGlMWL/eiw0b7ym49CX9FvrmGZ3BfDA6iPhCk7t0P7el9IClmpGXdtg2alq2yuTxEIWNC+pJdHq22146PPz3f++vff+l7xyfnt4vuL8SuAIDePPqW9c+v745OBj9//2WNnzX1VMR1+Je5K5lUZaRi5HHzBnKm7ku0UQgYOGseZM233zq2Sml3W6He8nbhomOT45/8vrPRERE0My7OxgF69J9LHcz7BSoCIG3IG4vbDRrvnLlyndffiVJcj+tu9bncvrokw/feu8d1bzdblE+VEk5iQCsWZDgqXW+3WdWgEkZUqsvVGsOBlpgTvUd1AZoMnWp4mSwLmZV3RnCYCmMwahmYbYM6jxdcM6p4hMGYSJaz/x0pKe7vm5wa6bG9lEG7gKRspKS8TDc8bZ+g56WYia52XBtUlJwdXV0oXOGFq1DRkG9VQnYzTMT/7U/9xd/8Mr3Ts5OVPXewXCZl6pp0HlX+k5/6ALP5J1/+06XBxbc+dVeurPt2U9+8bN5zkeHR11gYMmhLAmECBfPmfscfG20hfIQkTISIyuQMknhJCoSdEJKIiLMcro9e+bJp5545PE5ZyW9p6KbUkrvfPDeux+8d7A5KJpfHgK6x64rRHIaa6w+q2WutCEd7jRmKyN7tGs/fHp6+v1Xvvv8s89td7u7+5QB2EzTa2+/fu3T65eOjnLOkmXWnHLOOUlSAZSQyicIMJNWMFWhJbNJa4KQIlKaFMiac6m9WeGuVyFkrCAGVRkAVVBGLn8fWlq8cp6Taql5avmPQXTAfZUMcul29Dc/MJ7OK7ihHHszrdx6XYxYgWE/Wlm6XK0QnH5W5ZbdfkwVuXSyWt40l6tXCqtqCATWljtJ2M67eTf/7g//7A+/++tn221R9N4LGC4zHx4crsT67S/A/CdsqGLGB++rrrxYO3H8xzK6np6efuWXcUrTZ59/9vO3Xpum1E115Gyo1r6xraetbaPOQEAjBahAE5xVVKCpsBA15TxNU0oiLMcnx08/+tRjDz58tttBcU/1ucLpZ2+89sWtWylNwa/Sl2DV1gbcBwtG81xqFicwc4bwZ4cEl9Y0nG23r7787aeeePL28e2VifZP9rDsdrufvv6Lk9PTw4PDnHPKqTiIJ7TIWRMt+IgNhRCBKFOuhFKAy4Znbs6LOTuL3+drk/+yGdKpSQhy+WXmlgJW/praBYke4jFDckX7y2jBHdwsv74Ub8FiGLidgkxdDbfb2t3B1DHZlgYZjfSKosxYCoWQS6TIHGyPoiu5lXKGYrvdfvelV373B79VUjnvkQ6XmXPO/+anP/ri5k1JKRrIxWBW11MhTNPdCM3LTni9Fe6fEkLPGaGYomGXU83I3UySFMCc56ODox/82q8/cPmBr3Zln0Rev/rm9U8/nWRqNYU5qoBWz5X6XNQZzBxHYawYqiqjojbSpFlSSklT0jyntAFBiJ976pnNNJ2c3XO+NjnPP33jtbPt2ZXLV6gj/MfE2FZEB/OT5mXdOt76TOtQlz2SkIiItrt85fID333pO0mkLrju3tfh5uD9ax++/f67hZafvRxE6pIvewKQUrp1C5RRM6ax4Bxkr7iquRFvmxtHJfWSeF0SJa2Yf2n7Nbh1R3PYXkky7KvifVkRZu7Cdi5Uc7G4te80MsP3jBwqLRcwXGFbsmzW9FrPrGZmo2GjXEgL1R+yfBbb3e7Jxx7/8z/8HRYp0u97hKVwcHBw7dPr/+//4b+9/sknB4eHZEYb9XAtvsrNYNo9uVuCeD2DudF1BiDOmhrLTtZQXepgUewtTfIX3CvQ/Jd13s0lRm/OOc/z9c8+/Xf+3J//rR/+GRHR3VcHizMx809f/9nxye1Lly43pYO1D+ywI1PxTa3iKkVbH9mQrJ7vZJeEKp/KFmp1EhVV3c67bzz+1DNPPn16dnavLQaODg8/vP7xOx+8S56fGHOM3V+hZq6EVf3yhG69jJlbm3l55cbXCE4txWm727743Asvv/Di8fHxXW9yDw4O3rj69gcff3RweGBPv4aya+TXsi635rF+NlrgyGLDmPOcc97Nmuc5Z81ZZ88sq++qhljWAOBcfDcQJ4ISgVAJY0qD28LqG+cYzGBXWSqXbFE9Qfu4YitpqNTRDvpFRfMdr0E9bMaSGn6b2qdbvByVCBAPFSpFVrNXWw7JZpVCqCCiPOcpye/+4Lcffejhk9N7qx9Jkt56++3Pb9zYHBxKEgYX73oPjCk+nhKNmKl6cVBz0Ip7+G6I8eqTGj5lORsVoNNy5QQoecmV3MfMqsruUQ2WxKRcd7pIafrB93/wyEOP3Pjixld4gG3SdPP2zdfe/MUu6xV2M0ZLmBIX0lufw/UX3Ayxons0mEr4SFjoVlwQYCmXQlVU89n27MlHH3/i0cfOtveWqzIzT2l67Y1fXPv0k4PNQSmJDEucrFsRbok7o1vaEKplImGb3NHKGFNvRVGgzZee/9Y3nnjiZHuX08+SyG63+9kbr98+Ob50+VI3y4ciZf/NrvJqXSRV3p9mzZp3FqWzyzu1nEjUw6VyllWYmQWlE4IqB0m0Ux26lFI2a9rQ3nJvgdC8mynMIMyyAp19KWjBzsC46qxpzV25Do7QZA06G7zGIUmSm1F7NuO0UPSDd6OJihXQ7bz7/kuvvvTci9vd7itf+AzPxjzPv3j7zXk3X7p8SUqIopS8phLq5BnQEnSsreCK+9YxDyLx5b7ElrCo4Rq17xXfzzIA5eKBpKyVyijM2hyWSkXb7XZPPv7E91/9XiGlfoWX9ODg8Kdv/PzDax8dHBz0Le4IQpv3tLFJWwNc/zRMJSyt2/C1UMGAlYizkpDmTEL84jPPT2k6Ozu7pwQ1IrKbdz9/8/Xbt08eevDBGr/STC0r0NdsWLB/KB3mV11vtJxMllUPDw+/98qrSZLmu7w9m6bpw08+/sXVNw8ODgfvTSewOcENoS9xvCmqXqEKpZzzDMswUw1RNEW/xi3RGIgZIsPPjtgBugPAGQOD9fhg6bBScLXmRESy2Z761ZoEoEFl7M+7VnM9JoUycSYta1HWskomES425B7vQLkww8pAnLkykd1RrJDulBlEWqzHyjpte7Z95MEHf/CdXytUSrqXtA+bg82nn3/63vvvVe84opKUF4ISm+l2sbwX7mA3Dm7NAcjt/7nRV+osrcykjKqPLrZ27Ed0OAL9fnL0poK6Z7vtq08/8/KLLxUp/Vd1SYu86rU3X//i1heXL11Bjc8Oez+AxI6Kom9tvNyCzZALgROEuDBzC6ygLbYp6GCZqx7poQcffuHZ54vO6p7qcw82m08+/fS1t1+fpmRjpbSu1IhM1fHHqhT6oxpY0/JzM3504DTeaTnnJx577NsvvLj9JVyWJOmdD957/9qHl44O3RYdXOf/CqQKUYlfAi0eDWtItawORTGXpFmLLGipXS6lKJ1GtX9cpfVwdG6kaGgRbTzqosz2tsp87oK7cfEmDBswmOCC+414M8sho+A0QNkpYAyC1oJr6b2m9y3EAy05atrIKlqpZQ6dMGkT1amFBmsxyVFi+t5L333koYfPzs7oHvs6PDi4+s67H338cXHa5hZQYIyc6mEk/XKs/tFg0YLWEQfDK9M59mW0uM4xPD/QiXzErBSdDzUOLVrTkCmrish3XvnOQw8++NWaXk5punnz5s/e+LkqhIURRJzunFCbOTUHRkgrs0xEnMjpDJVWBErEqJ6wYrdZ95Bs592zTz395KOP32vpZwXqf/v9q+9//OHhwUFE+FHyFZu4rC6Yea13BQvFWuJTa+38tZWYBvjSbt699PyL33jiqfmXkMSzm+efvfn68enpIw89NExx8K2pJVC2trLo0wDLW6rwgzIgRNkm6pb/DXI3BpCWSJ+aZkSwBAp4GUO12HVLYgX3klvxab3ZB2FhI97L0v3aTVijbEZPSG6hHV0wBLnruGvWjXjc2mjU7jRooGu0b4RMSqEo20JqhGyfC1qQxG63e+KRx19+/lvz7p6LBRSReTe/cfWt49OThx96eMi2N5lqs5iuT0fnOshMHfukigAx6F7YhULhL8GXb1G1aSLPxuEeIgGISFUffPCh73/ne7uv+qpOaXrzo7fefufq0cEhBaMWRVmWFSoU13a+xm7HvF+7chIkSbbm4HI8qUFadX1bb/A5zy8//+KVS5fvtYg8Zt5uz37+xutnZ9srly/bvcI8+BsG37WY6zZ6W3fhCC2ip53h/Vuf5/z9V79z5dLl45Pju5w4yfz5zRs/e/P1zbShzm1SKlrKfio4CCcO7jOLgflERSucKaaELDb9IMtD01DaWYwDQY1F1Ktj19a85s2LEICKC4GzNEG1i0yvfZPBJeFhrf+n6jGh7l7LFEKdy7GZK+isqii+5Fp1z9WPUwvWWJ4IpVJwy8/NZZlGmk0aUSLOVAF69cVvXzq8tL0XjU2n659/9va770zTJpzY3OYDuGTb/2XUAAnFfpYDPMQc+CMxfq5ZwgsLGFS27Y58AVLJIuB++dB+CjDn+dmnn33x+W/tdruv8KoW3f3rb7/xxe0vjg6PiJQgqJAJlFhEiRKpEjOlwj6ox4z3Q/Y8xhZDzOOuXPlSwOuOQASqNOf5yqXL33r2BWZW6L1Wc49PTn765s9TSmamMJIKYzelsasK+jMj3EbyU72rbLj15MISJYDdPD/68MMvP/8iMavq3b0oSdJ7H3344bWPU0potvHNRL0rb+XJMdfJmEEujMwlGU4k22yjQqw1PCKl2tsxh3WslNqmqPhexcQd7mXmSgGo7hRce0bflvHgaXEeI56848KERkHoPzaQCzwqcwTmf1aDeNU2W3FiBTNpNhCuEi+K9bi28DS1dZm2uDP7IRbHQwqikgBXTHLPzs6eevSJ55765l1XH96lHi19+PFH77z33uHBgfN4pKLk0mPjLQO6GBdJ9OIefmHbDKY9SDsRr8F01v9qJf8GyEi4ptCVQ3W3m7/7yquPP/rYV+swUKIVf/zaT4sCSIuIXou3qgpYM7MoqsutjwawCKx60ojx7CypsFyQ+uAhCRWaboUsmAnbk+13XvzO0098Yzffe7HqKf3ig/c++PijaZrYu72htzdbGu0kDmO4LBa7sjGBIKS6gHFyevprr3732aeePttu7+5FAWgzpZ++/tqNWzcvHR2B3A2Ri54XYStVS4m7Hw/pCxw576Usi7AKUxYmt2YUXhRA912OTxN3VyMGkNHApgDOkynynt6Xpy4VfRVjQFl6V/+vnDMoE5Bzo6+ZuiUYBVdehrujN9zZ/Wu8oJO3yRa9aSSFFkJZnsNnnnr60tFREWXfUw8GM+/m+e133jk9O3vogQd80d5xR6SHeqjlFoDRW0ovYkvjAh9tdzIGWXXTkPHIgcWtED5jxWaavvvKdzababs9+wovq7B8/Om1N995O0myJANuSCXATEEpw7HwuPO2Z22HFqmBetZNoPCOYLjXnPO3nn3+kYcePj45uadqbik9P3/zF6dnZ9Nm05b7zMttOxB2Yms+AMtpu/t1/49FO/vKiy8/+vAjX9y6edfB3JOzs9fefnM37y7zpQ4SWfSN1W4+tobMzovl0v8Kc/ZK2le9et/UDVqjrcC/s0MKxaNbQ2Htzi7Ek+qc69FySshJaO0QVVXLHo4uF+yJdjUBUrPmrIqMWYsiOVs2JOC4mVTmEwlLYaR6ilF5Ztg4ti1E05MkathOBYWzIiObtzt28+5gc/DEo48XwuC91uQmkZu3b7/+9pubKXWlrcobUFBJTjYlOaGAiwSxUXCDGzet53x6ZorGTKtqmhyONweHEZUwbqtabtvtbvuNp77xredeKBL1r/YavvbmL2588XniZECeFtiMU+18pFp0c5jWKgFOyp+rvU5jOtheggmFw0zMrKyUqzPfrPmBK1deeu5bTFRcQO+p++rs7Oz1t9/YzfPh0VGLEu83+IPMwTcAXVV1JIrJJ9kY2l3VwFotrre73cMPPvSdF1+uHc/d3TZvNm+8e/W9jz9M09Qh8fFV+kbLVxeIrQub7lDKCUrClGvYB8rKlOygtqtVHkEm1obxuRCYGouVnQRrjQw4aPywBvEuItbR4JFImJkWDBJQUzEoFBk5Z0URd2huX5qLAQ2RotoBk7CkkqBBIiJJRKjVX2tlq3aqdBnVXsMDjivSW71t1Bwrdrv5kcceeezhR3fz7h4EFkTk2vVrH3704SS2NYdNQxVb4LYri0W1z/fcx3+MptoMX5IEUVDoZ7kjDiKWp1jIy21yfHr8ykvf/uYz3zz7SndHzJyhP3ntZ2fbs0uXLi+JQfHoYSLxHoUtCVZS/zY73yA795xCxzAHxzzPzz393HNPf/PkHtueEdHB5uDN966+89EH02bD7R3zEF1m8BO48n54GHy7qQgro3LX+oKIaLebX3nhxW998/m73vsz85Q2r731xrVPr1+6dFRLJLthLWKH0XzZPYqpucpFNFXIBpziq9taH1TZoe+viUigRImqb47dZ1JOq5bdZDgL6UAVwsrF28NEGFG/CdUXY7BZ8fzyPOc556xz3mn55a6U3NltJgPzJokkkSRpSimxaEqJuRRf5mq5FgzGXPHQ9H5mJ1bjhKqzmIKIH3/ksU2azrZn92AABIu8/c47t27enjZpaFEdFRC5A8a+0t6uQ2FtkYu1Z+dOTwjCx6yb6eCVl799eHBwfPJV5tBsps1nn3/21ntX3UWbPDWHwx7SlK9wY54OkhmdfFZaksYDqXg3sbz8/MtPP/n0drs9Ojy682e0xwJubw8Ub4IvY1TGwpePLr317tXPb90sCpEoFw+sMDReuw/TqzdO76vaemNuC2wYGsjCL37zhYcffPiup58lkZOz09euvr3d7R64cgV+glIvLODQPRqG1K+muW3/OdAFTftTPeprD8ImGKljQun4hDvUj6jYKcPJylik7i4eJF55tngvlWGCiVqCKoPMDS0X+5ic87ybd/Mu57l4SMya8y7nYqxuPghcEuBEJkmbzbRJ05STJJlYkKYk4NBGVwuFkmfmNo7Fv0fVbBzLb2rWvNlsnnrsCTWd8L3W5J5tt29efXunuwPexPSC+N++S2Pvunq8lpdoa7eCpojgckt4RtySYXXL5t+B280Lou12+/STT337xZe/coLUZrN54+pb165/spk2rY6KlVzn2pHRKburW1ErHlcirRt0TqNfCF86Hx4cHh0evfHOGydnZx2DNWiB1poXjg9+3fUzLax+hxsWC++MfZ0Sp5SI6N/84qcgTSmJndshD6L2gY1hScPNEs/pMAYpiPqRFwF3YFbopaOj773ynV/G47bZbN798IM337l6VAzp2Yn4xl4Tbm2ZVWMQQ7hkThppt8YGcamU7Ds0rhEazMKipB6Szq5KEq7L2Kqh5sjTbEbCQXWLNRx8veDSmj1rkXsU7a9ROwspC0SUC4yg827WUmPn3XY373bzvNvN2zzX9lezJbeVC8XCkkSmlOY86TRp2qSUkCYGUwI3Vht6lzGy3VlJ3SnfshgCZQA55wcfeOCxhx/OOd+DwMJm2nzw0Yfvf/hB6paeIBbDn4wtC+aBPLbaTEUL7uFji48ROhBJzT2re9Aj5lAtn+EODnOev/nsN5975punp6df4YVNkjTnt66+ffvk+MqlSxcgO3aLo6aKbOWIF6uPbrI2o0Iwc0ryh//qj/7Xf/GHtqAoNvkFBaMmlnSfJVc2lVk3JRESsZYjSW2/A8ID84UsfBwEnzcMJdIoyVxtXfRse3b58LL0DGQ20BPnTbfhPkC8hbrNKsKu21dwWfXZp55+8bnnd/P2rgMLBHr7/feKd4SjnNJnlCvRMOD0HsFGRK/MFqEibfdJh4sBSY6NB3w/zVWeyEygFM4+9gerJAGZB3M0AOeVNV9vHrQEebs+N8CFRi8AVHWe51nn3W7e7Xaqu+1ut9vttrt5nne7POe51Fx3B64/P4kkljmlzax0AE06yQYbEDBRmjjVWj8mvJfDRP1kUYd4QQDNOT/+0KOHm8N7kyV2cLB594P3rl+/flASavtb3ikJ3Gms5U5z5hpi1NyFPIBu6MP4"
	B64 .= "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"
	B64 .= "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"
	B64 .= "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"
	B64 .= "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"
	B64 .= "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"
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	VarSetCapacity(Dec, DecLen, 0)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
	; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
	hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
	pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
	hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
	VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
	DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
	DllCall("Gdiplus.dll\GdipCreateHBITMAPFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
	DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
	DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
	DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
	DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
	Return hBitmap
	}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_EU_ico(NewHandle := False) {
	Static hBitmap := Create_EU_ico()
	If (NewHandle)
		hBitmap := 0
	If (hBitmap)
		Return hBitmap
	VarSetCapacity(B64, 424 << !!A_IsUnicode)
	B64 := "AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAAAAAAFoAAABaAAAAEAAAAAAAAACbR0EAmkpEAKA8MwCdQjsApDIoAKgoHACIdXkAcau8AJdRTQBhzeAAf4iNAJNaWQCRYF8AeJmiAI5kZgBmw9MAAAAAEyEAAAAAAAQ74CIQAAADik2VZiAAATW5gwR3UhADigQwMSRmIALJEgAABHdAAUQAAAABNTEx/iAAAAM/YjDbMAAAAz3DAEQQAAABJTECyYMAAAR3QAOKBBMhJGYgATW5GMV3UhAAA4pN9WYgAAABNAEQIhAAAAAAAzEAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	VarSetCapacity(Dec, DecLen, 0)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
	; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
	hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
	pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
	hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
	VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
	DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
	DllCall("Gdiplus.dll\GdipCreateHICONFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
	DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
	DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
	DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
	DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
	Return hBitmap
	}

; ##################################################################################
; # This #Include file was generated by Image2Include.ahk, you must not change it! #
; ##################################################################################
Create_US_ico(NewHandle := False) {
	Static hBitmap := Create_US_ico()
	If (NewHandle)
		hBitmap := 0
	If (hBitmap)
		Return hBitmap
	VarSetCapacity(B64, 424 << !!A_IsUnicode)
	B64 := "AAABAAEAEBAQAAEABAAoAQAAFgAAACgAAAAQAAAAIAAAAAEABAAAAAAAAAAAAFoAAABaAAAAEAAAAAAAAAD7+/YArGllALN1cAB9dv0AiYL8AKRVTQA9Mv8ATEH/AO/8/wDDi3sAkTUvAObTzACBZ9EATzXcAISD/wBCQP8Ad3d3d3d3d3cAAAAAAAAAADMzMzMzMzMzRERERERERESAAAAAAAAAAGZmZmZmZmZmiIiIiIgAAACZmZmZmUMzM6VaWlpVzkREEiIREiWwAAASIRERJdZmZhIhERElsAAAEiERESXDMzMSIhESJc5ERBIhERElsAAApVpaWlXfd3cAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA"
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", 0, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	VarSetCapacity(Dec, DecLen, 0)
	If !DllCall("Crypt32.dll\CryptStringToBinary", "Ptr", &B64, "UInt", 0, "UInt", 0x01, "Ptr", &Dec, "UIntP", DecLen, "Ptr", 0, "Ptr", 0)
		Return False
	; Bitmap creation adopted from "How to convert Image data (JPEG/PNG/GIF) to hBITMAP?" by SKAN
	; -> http://www.autohotkey.com/board/topic/21213-how-to-convert-image-data-jpegpnggif-to-hbitmap/?p=139257
	hData := DllCall("Kernel32.dll\GlobalAlloc", "UInt", 2, "UPtr", DecLen, "UPtr")
	pData := DllCall("Kernel32.dll\GlobalLock", "Ptr", hData, "UPtr")
	DllCall("Kernel32.dll\RtlMoveMemory", "Ptr", pData, "Ptr", &Dec, "UPtr", DecLen)
	DllCall("Kernel32.dll\GlobalUnlock", "Ptr", hData)
	DllCall("Ole32.dll\CreateStreamOnHGlobal", "Ptr", hData, "Int", True, "PtrP", pStream)
	hGdip := DllCall("Kernel32.dll\LoadLibrary", "Str", "Gdiplus.dll", "UPtr")
	VarSetCapacity(SI, 16, 0), NumPut(1, SI, 0, "UChar")
	DllCall("Gdiplus.dll\GdiplusStartup", "PtrP", pToken, "Ptr", &SI, "Ptr", 0)
	DllCall("Gdiplus.dll\GdipCreateBitmapFromStream",  "Ptr", pStream, "PtrP", pBitmap)
	DllCall("Gdiplus.dll\GdipCreateHICONFromBitmap", "Ptr", pBitmap, "PtrP", hBitmap, "UInt", 0)
	DllCall("Gdiplus.dll\GdipDisposeImage", "Ptr", pBitmap)
	DllCall("Gdiplus.dll\GdiplusShutdown", "Ptr", pToken)
	DllCall("Kernel32.dll\FreeLibrary", "Ptr", hGdip)
	DllCall(NumGet(NumGet(pStream + 0, 0, "UPtr") + (A_PtrSize * 2), 0, "UPtr"), "Ptr", pStream)
	Return hBitmap
	}

MessageWindowGuiEscape: ;Backup window escape stuff
	MessageWindowGuiClose:
	Gui MessageWindow:Cancel
	Gui MessageWindow:Destroy
	WinActivate, 8th Gear FiveM Launcher
	Return

FAQWindowGuiEscape: ;FAQ window escape stuff
	FAQWindowGuiClose:
	Gui FAQWindow:Cancel
	Gui FAQWindow:Destroy
	WinActivate, 8th Gear FiveM Launcher
	Return

FolderExplorerWindowGuiEscape: ;LogViewer window escape stuff
	FolderExplorerWindowGuiClose:
	Gui FolderExplorerWindow:Cancel
	Gui FolderExplorerWindow:Destroy
	Return

LogViewerWindowGuiEscape: ;LogViewer window escape stuff
	LogViewerWindowGuiClose:
	Gui LogViewerWindow:Cancel
	Gui LogViewerWindow:Destroy
	Return

RulesWindowGuiEscape: ;Rules window escape stuff
	RulesWindowGuiClose:
	Gui RulesWindow:Cancel
	Gui RulesWindow:Destroy
	WinActivate, 8th Gear FiveM Launcher
	Return

AboutWindowGuiEscape: ;About window escape stuff
	AboutWindowGuiClose:
	Gui AboutWindow:Cancel
	Gui AboutWindow:Destroy
	WinActivate, 8th Gear FiveM Launcher
	Return

MainGuiEscape: ;Main window escape Stuff
	MainGuiClose:
	MainButtonCancel:
	MenuOptionExit:
	If FileExist("8thGearLauncher")
		FileRemoveDir, 8thGearLauncher, 1
	If FileExist(ShortcutPath)
		FileDelete, % ShortcutPath

	ExitApp

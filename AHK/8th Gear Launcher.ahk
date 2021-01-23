#SingleInstance, Force
#NoEnv
#Include Anchor.ahk
StringCaseSense, On
SetWorkingDir, %A_ScriptDir%

FileCreateDir, 8thGearLauncher ;Creation stuff
	Fileinstall, pictures/8GLogo.png, 8thGearLauncher/8GLogo.png, 0
	Fileinstall, icons/8G.ico, 8thGearLauncher/8G.ico, 0
	Fileinstall, ServerList.ini, 8thGearLauncher/ServerList.ini, 0
	Fileinstall, ServerList.ini, 8thGearLauncher/VERSION_INFO.ini, 0
	Menu, Tray, Icon, 8thGearLauncher/8G.ico, 1, 1

LauncherVersion = v1.0

vFAQ =
	(
	READ THE WHOLE THING.
	)

RulesBold(text)
	{	Gui, RulesWindow: font, bold
		Gui, RulesWindow: Add, text, w600, %text%
	}

RulesNormal(text)
	{	Gui, RulesWindow: font, Norm
		Gui, RulesWindow: Add, text, w600, %text%
	}

Gui, New ;Main Window
	Gui, Add, Tab3,, Connect|Misc

	Gui, Tab, 1 ;Connect
		Gui, Add, Picture, w465 h-1, 8thGearLauncher/8GLogo.png
		Gui, Add, GroupBox, w220 h81, 8th Gear Servers:
		gui, add, DropDownList, xp+10 yp+20 w133 vServerName,
		gui, add, button, xp+139 yp-1 w60 gConnect, Connect
		Gui, add, button, xp-140 yp+30 w200 gLocalhost, &Localhost
		Gui, add, Groupbox, xp+220 yp-49 w236 h81, Disclaimer
		Gui, add, link, xp+10 yp+20 w215, By joining our servers you agree to be bound to the <a href="https://discord.gg/ygWU5ms">#rules</a> of our server.
		;gui, add, groupbox, xp-10 yp+21 w370 h40,
		;gui, add, link, xp+10 yp+15 w350, <a href="https://8thgear.racing/status">To see server status, click here to go to the website</a>

	Gui, Tab, 2 ;Misc
		Gui, font, s10 norm
		Gui, Add, groupbox, xp-239 yp-496 w465 h290, Current Logs:
		Gui, Add, ListView, xp+10 yp+20 r10 w445 AltSubmit Grid -LV0x10 -Multi gMyListView vMyListView, Name|Size (KB)|Modified|SortingDate
		Gui, add, button, xp+339 yp+234 gupdatefiles, Refresh Log list

	Gui, Tab ;All Tabs
		Gui, font, norm
		Gui, add, button, xp-1 yp+596 w100 g8GDiscord, Discord
		GUi, add, button, xp+391 w100 gGuiClose, Exit
		Gui, Show, Center h657, 8th Gear FiveM Launcher

Menu, FileMenu, Add, &Locate FiveM.exe, lookforfivem  ;Top Menu
	Menu, FileMenu, Add, E&xit, MenuOptionExit

	Menu, CacheMenu, Add, &Open Cache Folder, OpenCacheFolder
	Menu, CacheMenu, Add, &Back-up Cache, BackupCache
	Menu, CacheMenu, Add, Open Back-up Folder, OpenBackupCacheFolder
	Menu, CacheMenu, Add, &Restore Cache from Back-ups, RestoreCache

	Menu, LogMenu, Add, &Open Log Folder, OpenLogFolder
	Menu, LogMenu, Add, &Back-up Logs, MenuOptionBackupLogs
	Menu, LogMenu, Add, &Manage Backed-up Logs, OpenBackupWindow
	Menu, LogMenu, Add, Open Back-up Folder, OpenLogBackupFolder
	Menu, LogMenu, Add, Open &Arbitrary log..., MenuOptionArbitraryLog

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
	Menu, MenuBar, Add, &About, MenuOptionAbout

	Gui, Menu, MenuBar

menu, submenu, add, Log Viewer, OpenLogViewer ;Context Menu
	menu, submenu, Default, Log Viewer
	menu, submenu, add, Default Editor, opendefault
	menu, submenu, add, Notepad, opennotepad
	Menu, ContextMenu, Add, Open With, :Submenu
	Menu, ContextMenu, Default, Open With
	Menu, ContextMenu, Add, Save To..., SaveLogCopy
	Menu, ContextMenu, Add, Delete, DeleteLog
	Menu, ContextMenu, Add, Properties, GetFileProperties

GoSub, StartUpStuff
Return

StartUpStuff: ;Stuff to run at start up
	req := ComObjCreate("Msxml2.XMLHTTP")
	req.open("GET", "https://8thgear.racing/api/serverlist", true)
	req.onreadystatechange := Func("Ready") ; Send the request.  Ready() will be called when it's complete.
	req.send()
	/*
	while req.readyState != 4
		sleep 100
	*/
	#Persistent

	Ready() {
		global req
		if (req.readyState != 4)  ; Not done yet.
				return
		if (req.status == 200) ; OK.
		{
			DownloadedList := req.responseText
			FileDelete, 8thGearLauncher/ServerList.ini
			FileAppend, %DownloadedList%, 8thGearLauncher/ServerList.ini, UTF-16
			Return
		}
		if (req.status >= 400 && req.status <= 599)
		{
			MsgBox 16,, % "Error " req.status " detected, falling back server list."
		}
		else{
			;MsgBox 16,, % "Status " req.status
			Return
		}
	}

	Menu, MenuBar, Disable, FAQ

	RegRead, FiveMPath, HKEY_CURRENT_USER\Software\CitizenFX\FiveM, Last Run Location
	if (FiveMPath = ""){
			MsgBox, FiveM.exe cannot be found.`nPlease locate it using the option in the File menu
			gosub lookforfivem
			Menu, FileMenu, Enable, &Locate FiveM.exe
		}
		else{
			StringTrimRight, FiveMExeFullPath, FiveMPath, 10
			FiveMExeFullPath := FiveMExeFullPath . "FiveM.exe"
			Menu, FileMenu, Disable, &Locate FiveM.exe
		}
	GoSub, updatefiles
	sleep, 750
	GoSub, UpdateList
	return

GetNumberFormatEx(Value, LocaleName := "!x-sys-default-locale"){
	if (Size := DllCall("GetNumberFormatEx", "str", LocaleName, "uint", 0, "str", Value, "ptr", 0, "ptr", 0, "int", 0)) {
		VarSetCapacity(NumberStr, Size << !!A_IsUnicode, 0)
		if (DllCall("GetNumberFormatEx", "str", LocaleName, "uint", 0, "str", Value, "ptr", 0, "str", NumberStr, "int", Size))
			return NumberStr
		}
	return false
	}

Localhost: ;Launches FiveM and connects to Localhost
	GoSub, BackupLogs
	Run, cmd.exe /C %FiveMExeFullPath% +connect 127.0.0.1,,hide
	Sleep 5000
	GoSub, updatefiles
	Return

GetFileProperties:
	run, Properties "%SelectedLog%"
	Return

DeleteLog:
	MsgBox, 0x40124, Delete Log?, Are you sure you want to delete this file? `n%SelectedLog%
	IfMsgBox, Yes
		{
			FileDelete, %SelectedLog%
			Return
		}
	IfMsgBox, No
			Return
	Return

UpdateList: ;Updates the list of servers from the ini file
	Gui +Delimiter`n
	guicontrol,, ServerName, `n
	IniRead, ServerName, 8thGearLauncher/ServerList.ini,,
	guicontrol, , ServerName, %ServerName%
	GuiControl, ChooseString, ComboBox1, 8th
	Gui, Show, NoActivate
	return

Connect: ;Connects to the selected server in the list
	GuiControlGet, ServerName
	iniread, ServerIP, 8thGearLauncher/ServerList.ini, %ServerName%, IP
	iniread, ServerPort, 8thGearLauncher/ServerList.ini, %ServerName%, Port
	GoSub, BackupLogs
	Run, cmd.exe /C %FiveMExeFullPath% +connect %ServerIP%:%ServerPort%,,hide
	Sleep 5000
	GoSub, updatefiles
	Return

lookforfivem: ;Opens dialogue box to allow selecting FiveM.exe location
	Gui +OwnDialogs
	FileSelectFile, FiveMExeFullPath, 3, , Locate FiveM.exe, FiveM (FiveM.exe)
	if (FiveMExeFullPath = ""){
			MsgBox, The user didn't select anything.
			LV_Delete()
			Menu, FileMenu, Enable, &Locate FiveM.exe
	}
	else{
		Menu, FileMenu, Disable, &Locate FiveM.exe
	}
	gosub, updatefiles
	return

updatefiles: ;Updates the log list for the tools tab and populates related variables
	FiveMLogsPath := FiveMPath . "logs\"
	FiveMBackupLogsPath := FiveMPath . "Backed-up logs\"
	FiveMCachePath := FiveMPath . "cache\"
	FiveMBackupCachePath := FiveMPath . "CacheBackup\"
	LV_Delete()
	Loop, %FiveMLogsPath%*.log*
	{
		FileSize := regExReplace(GetNumberFormatEx(A_LoopFileSizeKB), "[,.]?0+$")
		FormatTime, LogTimeAndDate, %A_LoopFileTimeModified%
		LV_Add("", A_LoopFileName, FileSize, LogTimeAndDate, A_LoopFileTimeModified, A_LoopFileFullPath)
		LV_ModifyCol() ;Auto-size each column
		LV_ModifyCol(1, "AutoHdr Text")
		LV_ModifyCol(2, "AutoHdr Integer")
		LV_ModifyCol(3, "AutoHdrText NoSort")
		LV_ModifyCol(4, "AutoHdr Digit SortDesc 0")
	}
	Gui, Show, NoActivate
	Return

GetFileSelected: ;Gets right-clicked file from main gui log listview
	RowNumber := 0 ;start at the top
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber ;if no more selected rows
			break
		LV_GetText(Text, RowNumber)
		SelectedLog := FiveMLogsPath . Text
	}
	return

BackupWindowGetFileSelected: ;Gets right-clicked file from backedup log listview
	RowNumber := 0 ;start at the top
	Loop
	{
		RowNumber := LV_GetNext(RowNumber)
		if not RowNumber ;if no more selected rows
			break
		LV_GetText(Text, RowNumber)
		SelectedLog := FiveMBackupLogsPath . Text
	}
	return

MyListView: ;Gets double-clicked file from main gui log listview
	if (A_GuiEvent = "DoubleClick")
		{
		SelectedLog :=
		LV_GetText(FileName, A_EventInfo, 1)
		SelectedLog := FiveMLogsPath . FileName
		gosub, OpenLogViewer
		}
	if ( A_GuiEvent = "ColClick" And A_EventInfo = 3 )
		{
		If Sort
		LV_ModifyCol(4, "Sort")
		else
		LV_ModifyCol(4, "SortDesc")
		Sort := not Sort
		}
	return

MyNewerListView: ;Gets double-clicked file from backedup log listview
	if (A_GuiEvent = "DoubleClick")
		{
		SelectedLog :=
		LV_GetText(FileName, A_EventInfo, 1)
		SelectedLog := FiveMBackupLogsPath . FileName
		gosub, OpenLogViewer
		}
	if ( A_GuiEvent = "ColClick" And A_EventInfo = 3 )
		{
		If Sort
		LV_ModifyCol(4, "Sort")
		else
		LV_ModifyCol(4, "SortDesc")
		Sort := not Sort
		}
	return

GuiContextMenu: ;MainUI context menu control
	if (A_GuiControl = "MyListView") {
		gosub, GetFileSelected
		Menu, ContextMenu, Show, %A_GuiX%, %A_GuiY%
	}
	return

BackupWindowGuiContextMenu: ;BackedupLogUI context menu control
	if (A_GuiControl != "MyNewerListView")
		return
	gosub, BackupWindowGetFileSelected
	Menu, ContextMenu, Show, %A_GuiX%, %A_GuiY%
	return

LogViewerWindowGuiSize: ;Makes LogViewer resize correctly
	Anchor("GB","w")
	Anchor("SelLog","w")
	Anchor("LogContents","wh")
	Anchor("Parse","y")
	Anchor("SlowOpen","y")
	Anchor("SaveLog","y")
	return

OpenLogViewer: ;Opens the selected log with the Log Viewer
	GoSub, LogViewerWindowGuiEscape
	Sleep 50
	Gui, LogViewerWindow:+ToolWindow +Resize ;LogViewer Window
	gui, LogViewerWindow: font, s10 norm
	gui, LogViewerWindow: add, groupbox, w1000 h50 vGB, Selected log file:
	gui, LogViewerWindow: add, text, xp+10 yp+20 w980 vSelLog, (Error)
	gui, LogViewerWindow: font,, Lucida Console
	gui, LogViewerWindow: add, edit, xp-10 yp+39 w1000 r30 ReadOnly t10 vLogContents, (Loading)
	gui, LogViewerWindow: font,
	gui, LogViewerWindow: font, s10
	gui, LogViewerWindow: add, button, vParse gParseLog, Parse
	gui, LogViewerWindow: add, button, vSlowOpen gSlowOpen, Thorough Open (Slow)
	gui, LogViewerWindow: add, button, vSaveLog gSaveLog, Save Log...
	gui, LogViewerWindow: show, AutoSize Center, Log Viewer
	Guicontrol, LogViewerWindow: text, SelLog, %SelectedLog%
	fileread, LogContents, %SelectedLog%
	Guicontrol, LogViewerWindow: text, LogContents, %LogContents%
	Return

F5::
	SetTitleMatchMode, 3
	IfWinActive, Log Viewer
	{
		fileread, LogContents, %SelectedLog%
		Guicontrol, LogViewerWindow: text, LogContents, %LogContents%
	}
	Return

OpenBackupWindow: ;Opens the Log backup management window
	Gui +OwnDialogs
	GoSub, BackupWindowGuiEscape
	Sleep 50
	Gui, BackupWindow: +Resize +ToolWindow ;LogBackupManager Window
	gui, BackupWindow: font, s10 Norm
	Gui, BackupWindow: Add, groupbox, w485 h260 vGB2, Backed-up Logs:
	Gui, BackupWindow: Add, ListView, xp+10 yp+20 r10 w465 AltSubmit Grid -Multi gMyNewerListView vMyNewerListView, Name|Size (KB)|Modified|SortingDate
	IfExist, %FiveMBackupLogsPath%
		Gui, MessageWindow:+ToolWindow
		Gui, MessageWindow: Font, s11 Norm
		Gui, MessageWindow: Add, Text,, Scanning for backed up logs, Please Wait.
		Gui, MessageWindow: Show
		Gui, BackupWindow:Default
		LV_Delete()
		Loop, %FiveMBackupLogsPath%*.log
		{
			FileSize := regExReplace(GetNumberFormatEx(A_LoopFileSizeKB), "[,.]?0+$")
			FormatTime, LogTimeAndDate, %A_LoopFileTimeModified%
			LV_Add("", A_LoopFileName, FileSize, LogTimeAndDate, A_LoopFileTimeModified, A_LoopFileFullPath)
			LV_ModifyCol() ;Auto-size each column
			LV_ModifyCol(1, "AutoHdr Text")
			LV_ModifyCol(2, "AutoHdr Integer")
			LV_ModifyCol(3, "Text NoSort")
			LV_ModifyCol(4, "AutoHdr Digit SortDesc 0")
		}
		Gui, MessageWindow: Destroy
		Gui, BackupWindow: Show, AutoSize Center, Log Backups
	IfNotExist, %FiveMBackupLogsPath%
		MsgBox, No logs are currently backed up.
	return

SaveLog:
	FileSelectFile, SavedLogName, S18, %SelectedLog%, Where to save the Log?, Log Files (*.log)
	FileAppend, %LogContents%, %SavedLogName%,
	return

SaveLogCopy:
	FileSelectFile, NewLog, S18, %SelectedLog%, Where to save the Log?, Log Files (*.log)
	FileCopy, %SelectedLog%, %NewLog% ;TODO improve, prob using dllcall.
	Return

OpenCacheFolder: ;Opens normal cache folder
	run %FiveMCachePath%
	return

BackupCache: ;Backs up cache priv folder
	Gui +OwnDialogs
	IfNotExist, %FiveMBackupCachePath%
	{
		MsgBox, The target folder does not exist. Creating it.
		FileCreateDir, %FiveMBackupCachePath%
	}
	IfExist, %FiveMBackupCachePath%
	{
		MsgBox, The target folder exists. Copying files.
		FileCopyDir, %FiveMCachePath%db\, %FiveMBackupCachePath%db\, 1
		FileCopy,  %FiveMCachePath%priv\*.*, %FiveMBackupCachePath%priv\*.*
		FileCopyDir, %FiveMCachePath%priv\db\, %FiveMBackupCachePath%priv\db\, 1
		FileCopyDir, %FiveMCachePath%priv\unconfirmed\, %FiveMBackupCachePath%priv\unconfirmed\ , 1
		msgbox, Cache Backed Up
	}
	Return

OpenBackupCacheFolder: ;Opens the backup Cache folder
	run %FiveMBackupCachePath%
	return

RestoreCache: ;Restores cache from backups
	Gui +OwnDialogs
	FileCopyDir, %FiveMBackupCachePath%db\, %FiveMCachePath%db\, 1
	FileCopy, %FiveMBackupCachePath%priv\*.*, %FiveMCachePath%priv\*.*
	FileCopyDir, %FiveMBackupCachePath%priv\db\, %FiveMCachePath%priv\db\, 1
	FileCopyDir, %FiveMBackupCachePath%priv\unconfirmed\, %FiveMCachePath%priv\unconfirmed\ , 1
	msgbox, Cache Restored
	return

BackupWindowGuiSize: ;Makes BackupWindow resize correctly
	Anchor("GB2","wh")
	Anchor("MyNewerListView","wh")
	Anchor("LogContents","wh")
	return

ParseLog: ;Determines the type of log(old-style vs new-style)
	StringSplit, LogLines, LogContents, `r, `n
	logline :=
	TrimmedLinea :=

	LogContains := "abnormally,attempt new connection,blocked,can't,Cannot,couldn't,Couldn't,Could not,crash,Debug,Dropping,DumpServer,error,Error,ERROR,ERR_CONNECTION_REFUSED,exception,Exception,failed,Failed,Fatal,GlobalError,invalid,INVALID,is not a valid number,MainThrd/   at ,nui://racescript/,#overriding,parse,racescript,Racescript,RaceScript,#recieved,#Recieving,streaming entry without blockmap,SyntaxError,Uncaught,unexpected,Unexpected,warn,warning,Warning,^1SCRIPT,handling entries,^3>,----------------"
	LogDoesNotContain := "DumpServer is active and waiting.,fix the exporter,f7c13cb204bc9aecf40b,handling entries from dlc,ignore-certificate-errors,is not a platform image,It leads to vertex,NurburgringNordschleife/_manifest.ymf,Physics validation failed,script.js:214,script.js:458,script.js:461,terrorbyte,warmenu,WarningScreen INIT_CORE, 1 handling entries"

	Needle := "CitizenFX_log_"

	IfInString, SelectedLog, %Needle%
	{
		gosub, ParseNewLog ;New-Style log
		return
	}
	else{
		gosub, ParseOldLog ;Old-Style log
		return
	}
	Return

ParseNewLog: ;New-Style log parsing
	Loop, %LogLines0%
		{
			logline := LogLines%a_index%
			if logline contains %LogContains%
				if logline not contains %LogDoesNotContain%
				{
					stringtrimleft, TrimmedLine, logline, 52
					TrimmedLinea = %TrimmedLinea%Line #%A_Index%:%A_Tab%%TrimmedLine%`n
				}
		}
	Guicontrol, LogViewerWindow: text, LogContents, %TrimmedLinea%
	return

ParseOldLog: ;Old-Style log parsing
	Loop, %LogLines0%
		{
			logline := LogLines%a_index%
			if logline contains %LogContains%
				if logline not contains %LogDoesNotContain%
				{
					stringtrimleft, TrimmedLine, logline, 13
					TrimmedLinea = %TrimmedLinea%Line #%A_Index%:%A_Tab%%TrimmedLine%`n
				}
		}
	Guicontrol, LogViewerWindow: text, LogContents, %TrimmedLinea%
	Gui, MessageWindow:+ToolWindow
	Gui, MessageWindow: Font, s12 Norm
	Gui, MessageWindow: Add, Text,, Old-Style log suspected.
	Gui, MessageWindow: Show
	Sleep, 2000
	Gui, MessageWindow: Destroy
	return

SlowOpen: ;Opens the log ignoring any found null characters that normally cause issues
	Guicontrol, LogViewerWindow: text, LogContents, % Nonulls(SelectedLog)
	return

NoNulls(Filename) { ;Reads the given file character by charcter
	f := FileOpen(Filename, "r")
	While Not f.AtEOF {
		If Byte := f.ReadUChar()
		Result .= Chr(Byte)
		}
	f.Close
	Return, Result
	}

OpenLogFolder: ;Opens the log folder
	run %FiveMLogsPath%
	return

OpenLogBackupFolder: ;Opens the log backup folder
	run %FiveMBackupLogsPath%
	return

BackupLogs: ;Backs up logs to the backup folder for safe keeping
	Gui +OwnDialogs
	IfNotExist, %FiveMBackupLogsPath%
		;MsgBox, The target folder does not exist. Creating it.
		FileCreateDir, %FiveMBackupLogsPath%
	IfExist, %FiveMBackupLogsPath%
		;MsgBox, The target folder exists. Copying files.
	FileCopy, %FiveMLogsPath%*.log, %FiveMBackupLogsPath%*.*, 1
	;msgbox, Logs Backed Up
	Gui, Show, NoActivate
	return

MenuOptionBackupLogs: ;Backs up logs to the backup folder for safe keeping
	Gui +OwnDialogs
	IfNotExist, %FiveMBackupLogsPath%
		;MsgBox, The target folder does not exist. Creating it.
		FileCreateDir, %FiveMBackupLogsPath%
	IfExist, %FiveMBackupLogsPath%
		;MsgBox, The target folder exists. Copying files.
	FileCopy, %FiveMLogsPath%*.log, %FiveMBackupLogsPath%*.*, 1
	msgbox, Logs Backed Up
	Gui, Show, NoActivate
	return

opendefault: ;Opens the selected log with the users default editor for .log files
	Gui +OwnDialogs
	gosub, GetFileSelected
	Run %SelectedLog%,, UseErrorLevel
	if ErrorLevel
	MsgBox Could not open %SelectedLog%
	return

opennotepad: ;Opens the selected log with Notepad
	Gui +OwnDialogs
	gosub, GetFileSelected
	Run C:\Windows\Notepad.exe %SelectedLog%,, UseErrorLevel
	if ErrorLevel
	MsgBox Could not open %SelectedLog%
	return

8GDiscord: ;Opens 8G Main discord channel
	Run https://discord.gg/4Xd2uwy
	return

MenuOptionAbout: ;Opens about window
	IniRead, NewestVersion, 8thGearLauncher/VERSION_INFO.ini, NewestVersion, Version
	GoSub, AboutWindowGuiEscape
	Sleep 50
	Gui, AboutWindow: font, s10 norm
	Gui AboutWindow:+ToolWindow +AlwaysOnTop
	Gui, AboutWindow: Add, link, w620, Hello and welcome to the 8th Gear FiveM Launcher.`n`nThis Launcher serves as the hub for everything you need to play on the 8th Gear servers and a few useful tools that will help you along the way. `n`nThis launcher is built using AHK by Firecul and is open-source and can be found on <a href="https://github.com/Firecul/8th-Gear-Launcher">GitHub</a>.`n`nThis launcher is version: %LauncherVersion%`nTo download another version please go to <a href="https://github.com/Firecul/8th-Gear-Launcher/releases">My Github releases page</a>`n`nIf you would like to contribute to this program, you are welcome to contact me there or submit a <a href="https://github.com/Firecul/8th-Gear-Launcher/pulls">pull request</a>.`n`nIf you find any problems please <a href="https://github.com/Firecul/8th-Gear-Launcher/issues/new">let me know</a>.
	gui, AboutWindow: show, AutoSize Center, About
	Return

MenuOptionArbitraryLog:
	Gui +OwnDialogs
	FileSelectFile, SelectedLog, 3, , Open a FiveM Log, Log (*.log*)
	if (SelectedLog = ""){
			MsgBox, The user didn't select anything.
	}
	else{
		GoSub, OpenLogViewer
	}
	return

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
	if ErrorLevel{
		MsgBox Could not open %SelectedLog%
	}
	Return

MenuOptionOpenGTASettingsFolder:
	Run %A_MyDocuments%\Rockstar Games\GTA V,, UseErrorLevel
	if ErrorLevel{
		MsgBox, Could not open %A_MyDocuments%
	}
	Return

MenuOptionOpenGTASettingsNotepad:
	Run C:\Windows\Notepad.exe %A_MyDocuments%\Rockstar Games\GTA V\settings.xml,, UseErrorLevel
	if ErrorLevel{
		MsgBox Could not open %SelectedLog%
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
	gui, RulesWindow: show, AutoSize Center, Rules
	Return

BackupWindowGuiEscape: ;Backup window escape stuff
	BackupWindowGuiClose:
	Gui BackupWindow:Cancel
	Gui BackupWindow:Destroy
	WinActivate, 8th Gear FiveM Launcher
	Return

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
	return

LogViewerWindowGuiEscape: ;LogViewer window escape stuff
	LogViewerWindowGuiClose:
	Gui LogViewerWindow:Cancel
	Gui LogViewerWindow:Destroy
	ifWinExist, Log Backups
	{
		WinActivate
		Return
	}
	else
	{
		WinActivate, 8th Gear FiveM Launcher
		Return
	}
	return

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

GuiEscape: ;Main window escape Stuff
	GuiClose:
	ButtonCancel:
	MenuOptionExit:
	FileRemoveDir, 8thGearLauncher, 1
	ExitApp

#SingleInstance, Force
#Include Anchor.ahk
StringCaseSense, On
FileCreateDir, 8thGearLauncher ;Creation stuff
	Fileinstall, pictures/8GLogo.png, 8thGearLauncher/8GLogo.png, 0
	Fileinstall, icons/8G.ico, 8thGearLauncher/8G.ico, 0
	Fileinstall, ServerList.ini, 8thGearLauncher/ServerList.ini, 0
	Menu, Tray, Icon, 8thGearLauncher/8G.ico, 1, 1

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
		Gui, add, link, xp+10 yp+20 w215, By joining our servers you agree to be bound to the <a href="https://discord.gg/Ts2kEEH">#rules</a> of our server.
		;gui, add, groupbox, xp-10 yp+21 w370 h40,
		;gui, add, link, xp+10 yp+15 w350, <a href="https://8thgear.com/status">To see server status, click here to go to the website</a>

	Gui, Tab, 2 ;Misc
		Gui, font, s10 norm
		Gui, Add, groupbox, xp-239 yp-496 w465 h290, Current Logs:
		Gui, Add, ListView, xp+10 yp+20 r10 w445 AltSubmit Grid -Multi gMyListView vMyListView, Name|Size (KB)|Modified
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
	Menu, LogMenu, Add, &Back-up Logs, BackupLogs
	Menu, LogMenu, Add, &Manage Backed-up Logs, OpenBackupWindow
	Menu, LogMenu, Add, Open Back-up Folder, OpenLogBackupFolder

	Menu, ToolsMenu, Add, &Cache, :CacheMenu
	Menu, ToolsMenu, Add, &Logs, :LogMenu

	Menu, MenuBar, Add, &File, :FileMenu
	Menu, MenuBar, Add, &Tools, :ToolsMenu
	Menu, MenuBar, Add, &Rules, MenuOptionRules
	Menu, MenuBar, Add, FAQ, MenuOptionFAQ
	Menu, MenuBar, Add, &About, MenuOptionAbout

	Gui, Menu, MenuBar

Gui, LogViewerWindow: +Resize ;LogViewer Window
	gui, LogViewerWindow: font, s10 norm
	gui, LogViewerWindow: add, groupbox, w1000 h50 vGB, Selected log file:
	gui, LogViewerWindow: add, text, xp+10 yp+20 w980 vSelLog, (Error)
	gui, LogViewerWindow: font,, Lucida Console
	gui, LogViewerWindow: add, edit, xp-10 yp+39 w1000 r30 ReadOnly t10 vLogContents, (Loading)
	gui, LogViewerWindow: font,
	gui, LogViewerWindow: font, s10
	gui, LogViewerWindow: add, button, vParse gParse, Parse
	gui, LogViewerWindow: add, button, vSlowOpen gSlowOpen, Thorough Open (Slow)

Gui, BackupWindow: +Resize ;LogBackupManager Window
	gui, BackupWindow: font, s10 Norm
	Gui, BackupWindow: Add, groupbox, w620 h260 vGB2, Backed-up Logs:
	Gui, BackupWindow: Add, ListView, xp+10 yp+20 r10 w600 AltSubmit Grid -Multi gMyNewerListView vMyNewerListView, Name|Size (KB)|Modified

Gui, RulesWindow: ;Rules Window
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
	Gui, RulesWindow: Add, link, w600, The rules found on the official discord channel superceed the ones found on this launcher, please refer to the <a href="https://discord.gg/Ts2kEEH">discord #rules channel</a> for the most up to date list.

Gui, FAQWindow: ;FAQ Window
	Gui, FAQWindow: font, s10 norm
	Gui, FAQWindow: Add, edit, w620 h700 Multi ReadOnly, %vFAQ%

gui, AboutWindow: ;About Window
	Gui, AboutWindow: font, s10 norm
	Gui, AboutWindow: Add, link, w620, Hello and welcome to the 8th Gear FiveM Launcher! `n`nThis Launcher serves as the hub for everything you need to play on the 8th Gear servers and a few useful tools that will help you along the way. `n`nThis launcher is built using AHK by Firecul and is open-source and can be found on <a href="https://github.com/Firecul/8th-Gear-Launcher">GitHub</a>.`n`nIf you would like to contribute to this program, you are welcome to contact me there or submit a <a href="https://github.com/Firecul/8th-Gear-Launcher/pulls">pull request</a>.`n`nIf you find any problems please <a href="https://github.com/Firecul/8th-Gear-Launcher/issues/new">let me know</a>.
	gui, AboutWindow:+Owner

menu, submenu, add, Log Viewer, OpenLogViewer ;Context Menu
	menu, submenu, Default, Log Viewer
	menu, submenu, add, Default Editor, opendefault
	menu, submenu, add, Notepad, opennotepad
	Menu, ContextMenu, Add, Open In, :Submenu

EnvGet, LOCALAPPDATA, LOCALAPPDATA ;Searches Fivem default location
	Loop, %LOCALAPPDATA%\FiveM\FiveM.exe, , 1
	SelectedFile := A_LoopFileFullPath
	Menu, MenuBar, Disable, FAQ
	if (SelectedFile = ""){
			MsgBox, FiveM.exe cannot be found.`nPlease locate it using the option in the File menu
			LV_Delete()
			gosub lookforfivem
			Menu, FileMenu, Enable, &Locate FiveM.exe
		}
		else{
			Menu, FileMenu, Disable, &Locate FiveM.exe
		}
	gosub updatefiles
	gosub UpdateList
	return

Localhost: ;Launches FiveM and connects to Localhost
	Run fivem://connect/127.0.0.1
	return

UpdateList: ;Updates the list of servers from the ini file
	Gui +Delimiter`n
	guicontrol,, ServerName, `n
	IniRead, ServerName, 8thGearLauncher/ServerList.ini,,
	guicontrol, , ServerName, %ServerName%
	GuiControl, ChooseString, ComboBox1, 8th
	gui, show
	return

Connect: ;Connects to the selected server in the list
	GuiControlGet, ServerName
	iniread, ServerIP, ServerList.ini, %ServerName%, IP
	iniread, ServerPort, ServerList.ini, %ServerName%, Port
	Run fivem://connect/%ServerIP%:%ServerPort%
	return

lookforfivem: ;Opens dialogue box to allow selecting FiveM.exe location
	Gui +OwnDialogs
	FileSelectFile, SelectedFile, 3, , Locate FiveM.exe, FiveM (FiveM.exe)
	if (SelectedFile = ""){
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
	StringTrimRight, seldir, selectedfile, 9
	seldir2 := seldir . "FiveM.app\logs\"
	seldir5 := seldir . "FiveM.app\Backed-up logs\"
	cachedir := seldir . "FiveM.app\cache\priv\"
	CacheBackupLocation := seldir . "FiveM.app\CacheBackup\"
	LV_Delete()
	Loop, %seldir2%\*.log*
	LV_Add("", A_LoopFileName, A_LoopFileSizeKB, A_LoopFileTimeModified, A_LoopFileFullPath)
	LV_ModifyCol() ;Auto-size each column
	LV_ModifyCol(2, "AutoHdr Integer")
	LV_ModifyCol(3, "Digit")
	LV_ModifyCol(3, "SortDesc")
		Gui, Show
	return

GetFileSelected: ;Gets right-clicked file from main gui log listview
	RowNumber := 0 ;start at the top
	Loop
	{
			RowNumber := LV_GetNext(RowNumber)
			if not RowNumber ;if no more selected rows
					break
			LV_GetText(Text, RowNumber)
			SelectedLog := seldir2 . Text
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
			SelectedLog := seldir5 . Text
	}
	return

MyListView: ;Gets double-clicked file from main gui log listview
	if (A_GuiEvent = "DoubleClick")
		{
		SelectedLog :=
		LV_GetText(FileName, A_EventInfo, 1)
		SelectedLog := seldir2 . FileName
		gosub, OpenLogViewer
		}
	return

MyNewerListView: ;Gets double-clicked file from backedup log listview
	if (A_GuiEvent = "DoubleClick")
		{
		SelectedLog :=
		LV_GetText(FileName, A_EventInfo, 1)
		SelectedLog := seldir5 . FileName
		gosub, OpenLogViewer
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
	return

OpenLogViewer: ;Opens the selected log with the Log Viewer
	gui, LogViewerWindow: show, AutoSize Center, Log Viewer
	Guicontrol, LogViewerWindow: text, SelLog, %SelectedLog%
	fileread, LogContents, %SelectedLog%
	Guicontrol, LogViewerWindow: text, LogContents, %LogContents%
	return

OpenBackupWindow: ;Opens the Log backup management window
	Gui +OwnDialogs
	gosub, updatefiles
	gui, BackupWindow: show, AutoSize Center, Log Backups
	IfExist, %seldir5%
		Gui, BackupWindow:Default
		LV_Delete()
		Loop, %seldir5%\*.log
		LV_Add("", A_LoopFileName, A_LoopFileSizeKB, A_LoopFileTimeModified, A_LoopFileFullPath)
		LV_ModifyCol() ;Auto-size each column
		LV_ModifyCol(2, "AutoHdr Integer")
		LV_ModifyCol(3, "Digit")
		LV_ModifyCol(3, "SortDesc")
	IfNotExist, %seldir5%
		MsgBox, No logs are currently backed up.
	return

OpenCacheFolder: ;Opens normal cache folder
	run %cachedir%
	return

BackupCache: ;Backs up cache priv folder
	Gui +OwnDialogs
	IfNotExist, %CacheBackupLocation%
		MsgBox, The target folder does not exist. Creating it.
		FileCreateDir, %CacheBackupLocation%
	IfExist, %CacheBackupLocation%
		MsgBox, The target folder exists. Copying files.
	FileCopyDir, %cachedir%\db\, %CacheBackupLocation%\db\, 1
	FileCopyDir, %cachedir%\unconfirmed\, %CacheBackupLocation%\unconfirmed\ , 1
	msgbox, Done

OpenBackupCacheFolder: ;Opens the backup Cache folder
	run %CacheBackupLocation%
	return

RestoreCache: ;Restores cache from backups
	Gui +OwnDialogs
	FileCopy, %CacheBackupLocation%\*.*, %cachedir%\*.*
	FileCopyDir, %CacheBackupLocation%\db\, %cachedir%\db\, 1
	FileCopyDir, %CacheBackupLocation%\unconfirmed\, %cachedir%\unconfirmed\ , 1
	msgbox, Done
	return

BackupWindowGuiSize: ;Makes BackupWindow resize correctly
	Anchor("GB2","wh")
	Anchor("MyNewerListView","wh")
	Anchor("LogContents","wh")
	return

Parse: ;Parses logs looking for meaningfull errors
	StringSplit, LogLines, LogContents, `r, `n
	logline :=
	TrimmedLinea :=
	Loop, %LogLines0%
		{
			logline := LogLines%a_index%
			stringtrimleft, TrimmedLine, logline, 52
			if TrimmedLine contains can't,Cannot,couldn't,Could not parse,crash,error,Error,ERROR,Exception,failed,Failed,GlobalError,nui://racescript/,#overriding,unexpected,warning,^1SCRIPT
				if TrimmedLine not contains f7c13cb204bc9aecf40b,ignore-certificate-errors,is not a platform image,terrorbyte,NurburgringNordschleife/_manifest.ymf
					TrimmedLinea = %TrimmedLinea%Line #%A_Index%:%A_Tab%%TrimmedLine%`n
		}
	Guicontrol, LogViewerWindow: text, LogContents, %TrimmedLinea%
	return

SlowOpen: ;Opens the log ignoring any found null characters that normally cause issues
	Guicontrol, LogViewerWindow: text, LogContents, % Nonulls(seldirthree)
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
	run %seldir2%
	return

OpenLogBackupFolder: ;Opens the log backup folder
	run %seldir5%
	return

BackupLogs: ;Backs up logs to the backup folder for safe keeping
	Gui +OwnDialogs
	IfNotExist, %seldir5%
		MsgBox, The target folder does not exist. Creating it.
		FileCreateDir, %seldir5%
	IfExist, %seldir5%
		MsgBox, The target folder exists. Copying files.
	FileCopy, %seldir2%\*.log, %seldir5%\*.*, 1
	msgbox, Done
	LV_Delete()
	Loop, %seldir5%\*.log
		LV_Add("", A_LoopFileName, A_LoopFileSizeKB, A_LoopFileTimeModified, A_LoopFileFullPath)
		LV_ModifyCol()
		LV_ModifyCol(2, "AutoHdr Integer")
		LV_ModifyCol(3, "Digit")
		LV_ModifyCol(3, "SortDesc")
	Gui, Show
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
	Gui AboutWindow:+ToolWindow +AlwaysOnTop
	gui, AboutWindow: show, AutoSize Center, About
	Return

MenuOptionFAQ: ;Opens FAQ Window
	Gui FAQWindow:+ToolWindow +AlwaysOnTop
	Gui, FAQWindow: show, AutoSize Center, FAQWindow
	Return

MenuOptionRules: ;Opens rules window
	Gui RulesWindow:+ToolWindow +AlwaysOnTop
	gui, RulesWindow: show, AutoSize Center, Rules
	Return

AboutWindowGuiEscape: ;About window escape stuff
	AboutWindowGuiClose:
	Gui AboutWindow:Cancel
	WinActivate, 8th Gear FiveM Launcher
	return

RulesWindowGuiEscape: ;Rules window escape stuff
	RulesWindowGuiClose:
	Gui RulesWindow:Cancel
	WinActivate, 8th Gear FiveM Launcher
	return

GuiEscape: ;Main window escape Stuff
	GuiClose:
	ButtonCancel:
	MenuOptionExit:
	FileRemoveDir, 8thGearLauncher, 1
	ExitApp

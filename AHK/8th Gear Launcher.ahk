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

Bold(text)
	{	Gui, font, bold
		Gui, Add, text, w600, %text%
	}

Normal(text)
	{	Gui, font, Norm
		Gui, Add, text, w600, %text%
	}

Gui, New ;Main Window
	Gui, Add, Tab3,, Connect|Rules|FAQ|Tools

	Gui, Tab, 1 ;Connect
		Gui, Add, Picture, w620 h-1, 8thGearLauncher/8GLogo.png
		Gui, Add, GroupBox, w220 h81, 8th Gear Servers:
		gui, add, DropDownList, xp+10 yp+20 w133 vServerName,
		gui, add, button, xp+139 yp-1 w60 gConnect, Connect
		GUi, add, button, xp-140 yp+30 w200 gLocalhost, &Localhost
		Gui, add, Groupbox, xp+220 yp-49 w370 h45, Disclaimer
		Gui, add, link, xp+10 yp+20 w350, By joining our servers you agree to be bound to the <a href="https://discordapp.com/channels/">#rules</a> of our server.
		gui, add, groupbox, xp-10 yp+21 w370 h40,
		gui, add, link, xp+10 yp+15 w350, <a href="https://8thgear.com/status">To see server status, click here to go to the website</a>

	Gui, Tab, 2 ;Rules
		Gui, Add, GroupBox, w620 h700, 8th Gear Specific Rules:
		Gui, font, bold
		Gui, Add, text, xp+10 yp+20 w550, 1) THE GOLDEN RULE: Don't be a Dick
		Normal("Personal attacks, harassment, hate speech, etc. will not be tolerated. Treat others with respect at all times.")
		Bold("2) Follow Discord TOS and Community Guidelines")
		Gui, font, Norm
		Gui, Add, Link,, <a href="https://discordapp.com/terms">https://discordapp.com/terms</a> && <a href="https://discordapp.com/guidelines">https://discordapp.com/guidelines</a>
		Bold("3) No NSFW/NSFL Content")
		Bold("4) No Spamming or Trolling")
		Bold("5) No Cheating on the Server")
		Normal("Using 3rd-party menus to gain an unfair advantage will result in a ban.")
		Bold("6) No Drama")
		Normal("Arguments should be resolved in a respectful manner or kept out of the discord entirely.")
		Bold("7) No Advertising")
		Normal("Links to youtube channels, streams, other discords, etc. are prohibited unless approved by a staff member.")
		Bold("8) Listen to the Staff")
		Normal("Staff have the final say and are free to moderate at their own discretion.")
		Bold("By taking part in this community you acknowledge that you understand and accept these rules. Ignoring them or not knowing them does not excuse you from them.")

	Gui, Tab, 3 ;FAQ
		Gui, font, s10 norm
		Gui, Add, edit, w620 h700 Multi ReadOnly, %vFAQ%

	Gui, Tab, 4 ;Tools
		Gui, font, s10 norm
		Gui, Add, groupbox, w620 h50, FiveM install location:
		Gui, add, text, xp+10 yp+20 w300 vselfile, (Not found)
		Gui, add, button, xp+470 yp-6 glookforfivem, Locate FiveM install
		Gui, Add, groupbox, xp-480 yp+40 w620 h290, Current Logs:
		Gui, Add, ListView, xp+10 yp+20 r10 w600 AltSubmit Grid -Multi gMyListView vMyListView, Name|Size (KB)|Modified
		Gui, add, button, xp-1 yp+234 gOpenLogFolder, Open Log Folder
		Gui, add, button, xp+495 gupdatefiles, Refresh Log list
		Gui, Add, groupbox, xp-504 yp+40 w620 h56, Log Backups:
		Gui, add, button, xp+9 yp+20 gBackupLogs, Backup Current Logs
		gui, add, button, xp+145 gOpenBackupWindow, Manage Saved Logs
		gui, add, groupbox, xp-154 yp+40 w620 h56, Cache Backups:
		gui, add, button, xp+9 yp+20 gOpenCacheFolder vOpenCacheFolder, Open Cache Folder
		gui, add, button, xp+138 gBackupCache, Backup Cache Files
		gui, add, button, xp+141 gOpenBackupCacheFolder, Open Backup Folder
		gui, add, button, xp+145 gRestoreCache, Restore Backups

	Gui, Tab ;All Tabs
		Gui, font, norm
		Gui, add, button, w100 g8GDiscord, Discord
		GUi, add, button, xp+545 w100 gGuiClose, Exit
		Gui, Show, AutoSize Center, 8th Gear FiveM Launcher

Menu, FileMenu, Add, Exit, MenuOptionExit  ;Top Menu
	Menu, ToolsMenu, Add, Back-up Logs, BackupLogs

	Menu, MenuBar, Add, File, :FileMenu
	Menu, MenuBar, Add, Tools, :ToolsMenu
	Menu, MenuBar, Add, About, MenuOptionAbout

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

gui, AboutWindow: +Resize ;About Window
	Gui, AboutWindow: font, s10 norm
	Gui, AboutWindow: Add, link, w620, Hello and welcome to the 8th Gear FiveM Launcher! `n`nThis Launcher serves as the hub for everything you need to play on the 8th Gear servers and a few useful tools that will help you along the way. `n`n<Blurb goes here>
	gui, AboutWindow:+Owner

menu, submenu, add, Log Viewer, OpenLogViewer ;Context Menu
	menu, submenu, Default, Log Viewer
	menu, submenu, add, Default Editor, opendefault
	menu, submenu, add, Notepad, opennotepad
	Menu, ContextMenu, Add, Open In, :Submenu

EnvGet, LOCALAPPDATA, LOCALAPPDATA ;Searches Fivem default location
	Loop, %LOCALAPPDATA%\FiveM\FiveM.exe, , 1
	SelectedFile := A_LoopFileFullPath
	Guicontrol, , selfile, %SelectedFile%
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
	if (SelectedFile = "")
			MsgBox, The user didn't select anything.
			LV_Delete()
	Guicontrol, , selfile, %SelectedFile%
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

BackupLogs: ;Backs up logs to the backup folder for safe keeping
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
	gosub, GetFileSelected
	Run %SelectedLog%,, UseErrorLevel
	if ErrorLevel
	MsgBox Could not open %SelectedLog%
	return

opennotepad: ;Opens the selected log with Notepad
	gosub, GetFileSelected
	Run C:\Windows\Notepad.exe %SelectedLog%,, UseErrorLevel
	if ErrorLevel
	MsgBox Could not open %SelectedLog%
	return

8GDiscord: ;Opens 8G Main discord channel
	Run https://discord.gg/
	return

MenuOptionAbout:
	Gui AboutWindow:+ToolWindow +AlwaysOnTop
	gui, AboutWindow: show, AutoSize Center, About
	Return

GuiEscape: ;Escape Stuff
	GuiClose:
	ButtonCancel:
	MenuOptionExit:
	FileRemoveDir, 8thGearLauncher, 1
	ExitApp

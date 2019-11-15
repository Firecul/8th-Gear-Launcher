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
	Gui, Add, Tab3,, Connect|Rules|FAQ|Tools|About

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
		Gui, Add, groupbox, xp-480 yp+40 w620 h260, Found Logs:
		Gui, Add, ListView, xp+10 yp+20 r10 w600 AltSubmit Grid -Multi gMyListView vMyListView, Name|Size (KB)|Modified

	Gui, Tab, 5 ;About
		Gui, font, s10 norm
		Gui, Add, link, w620, Hello and welcome to the 8th Gear FiveM Launcher! `n`nThis Launcher serves as the hub for everything you need to play on the 8th Gear servers and a few useful tools that will help you along the way. `n`n<Blurb goes here>

	Gui, Tab ;All Tabs
		Gui, font, norm
		Gui, add, button, w100 g8GDiscord, Discord
		GUi, add, button, xp+545 w100 gGuiClose, Exit
		Gui, Show, AutoSize Center, 8th Gear FiveM Launcher

Gui, LogViewerWindow: +Resize
	gui, LogViewerWindow: font, s10 norm ;LogViewer Window
	gui, LogViewerWindow: add, groupbox, w1000 h50 vGB, Selected log file:
	gui, LogViewerWindow: add, text, xp+10 yp+20 w980 vSelLog, (Error)
	gui, LogViewerWindow: font,, Lucida Console
	gui, LogViewerWindow: add, edit, xp-10 yp+39 w1000 r30 vLogContents, (File Empty?)
	gui, LogViewerWindow: font,
	gui, LogViewerWindow: font, s10
	gui, LogViewerWindow: add, button, gParse, Parse

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

Localhost:
	Run fivem://connect/127.0.0.1
	return

UpdateList:
	Gui +Delimiter`n
	guicontrol,, ServerName, `n
	IniRead, ServerName, 8thGearLauncher/ServerList.ini,,
	guicontrol, , ServerName, %ServerName%
	GuiControl, ChooseString, ComboBox1, 8th
	gui, show
	return

Connect:
	GuiControlGet, ServerName
	iniread, ServerIP, ServerList.ini, %ServerName%, IP
	iniread, ServerPort, ServerList.ini, %ServerName%, Port
	Run fivem://connect/%ServerIP%:%ServerPort%
	return

lookforfivem:
	Gui +OwnDialogs
	FileSelectFile, SelectedFile, 3, , Locate FiveM.exe, FiveM (FiveM.exe)
	if (SelectedFile = "")
			MsgBox, The user didn't select anything.
			LV_Delete()
	Guicontrol, , selfile, %SelectedFile%
	gosub, updatefiles
	return

updatefiles:
	StringTrimRight, seldir, selectedfile, 9
	seldir2 := seldir . "FiveM.app\logs\"
	Loop, %seldir2%\*.log*
	LV_Add("", A_LoopFileName, A_LoopFileSizeKB, A_LoopFileTimeModified, A_LoopFileFullPath)
	LV_ModifyCol() ;Auto-size each column
	LV_ModifyCol(2, "AutoHdr Integer")
	LV_ModifyCol(3, "Digit")
	LV_ModifyCol(3, "SortDesc")
	Gui, Show
	return

GetFileSelected:
	RowNumber := 0 ;start at the top
	Loop
	{
			RowNumber := LV_GetNext(RowNumber)
			if not RowNumber ;if no more selected rows
					break
			LV_GetText(Text, RowNumber)
			seldirthree := seldir2 . Text
	}
	return

MyListView:
	if (A_GuiEvent = "DoubleClick")
		{
		LV_GetText(FileName, A_EventInfo, 1)
		seldirthree := seldir2 . FileName
		gosub, OpenLogViewer
		}
	return

GuiContextMenu:
	if (A_GuiControl != "MyListView")
		return
	gosub, GetFileSelected
	Menu, ContextMenu, Show, %A_GuiX%, %A_GuiY%
	return

LogViewerWindowGuiSize:
	Anchor("GB","w")
	Anchor("SelLog","w")
	Anchor("LogContents","wh")
	Anchor("Parse","y")
	return

OpenLogViewer:
	gosub, GetFileSelected
	gui, LogViewerWindow: show, AutoSize Center, Log Viewer
	Guicontrol, LogViewerWindow: text, SelLog, %seldirthree%
	fileread, LogContents, %seldirthree%
	Guicontrol, LogViewerWindow: text, LogContents, %LogContents%
	return

Parse:
	chat :=
	file := seldirthree
	Loop, read, %file%
		if A_LoopReadLine contains can't,Cannot,couldn't,Could not parse,error,Error,ERROR,Exception,failed,Failed,GlobalError,nui://racescript/,#overriding,unexpected,warning,^1SCRIPT,
		 	if A_LoopReadLine not contains ignore-certificate-errors,terrorbyte,is not a platform image,f7c13cb204bc9aecf40b
				chat = %chat%%A_LoopReadLine%`n
			Guicontrol, LogViewerWindow: text, LogContents, %chat%
	return

opendefault:
	gosub, GetFileSelected
	Run %seldirthree%,, UseErrorLevel
	if ErrorLevel
	MsgBox Could not open %seldirthree%
	return

opennotepad:
	gosub, GetFileSelected
	Run C:\Windows\Notepad.exe %seldirthree%,, UseErrorLevel
	if ErrorLevel
	MsgBox Could not open %seldirthree%
	return

8GDiscord:
	Run https://discord.gg/
	return

GuiEscape: ;Escape Stuff
	GuiClose:
	ButtonCancel:
	FileRemoveDir, 8thGearLauncher, 1
	ExitApp

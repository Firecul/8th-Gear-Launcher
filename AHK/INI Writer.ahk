#SingleInstance, Force

Gui, New ;Main Window
	Gui, font,
	Gui +Delimiter|
	gui, Add, Tab3,, Write|Read

	Gui, Tab, 1 ;Write
	gui, add, text, xp+10 yp+30, Server Name
	gui, add, edit, xp+100 yp-3 w80 vServerName, Name
	gui, add, text, xp-100 yp+30, IP Address
	gui, add, edit, xp+100 yp-3 w80 vServerIP, 127.0.0.1
	gui, add, text, xp-100 yp+30, Port
	gui, add, edit, xp+100 yp-3 w80 vServerPort, 30120
	gui, add, text, xp-100 yp+30, Max Players
	Gui, Add, Edit, xp+100 yp-3 w80
	gui, add, UpDown, vMaxPlayers Range1-255, 30
	gui, add, text, xp-100 yp+30, OneSync Enabled
	gui, add, checkbox, xp+100 w80 vOneSync,
	gui, add, button, xp-101 yp+27 w80 gSave, Save

	Gui, Tab, 2 ;Read
	Gui, Add, DropDownList, vServerList,
	gui, add, text, w80 h135 vStam, (empty)

	Gui, Tab ;All Tabs
	gui, add, button, xp+123 yp+203 w80 gGuiClose, Exit
	gui, show, AutoSize Center, INI Writer

	goto UpdateDetails

	return

Save:
	GuiControlGet, ServerName
	GuiControlGet, ServerIP
	GuiControlGet, ServerPort
	GuiControlGet, MaxPlayers
	GuiControlGet, OneSync

	IniWrite, %ServerIP%, ServerList.ini, %ServerName%, IP
	IniWrite, %ServerPort%, ServerList.ini, %ServerName%, Port
	IniWrite, %MaxPlayers%, ServerList.ini, %ServerName%, MaxPlayers
	IniWrite, %OneSync%, ServerList.ini, %ServerName%, OneSync
	if ErrorLevel
	MsgBox There has been an error writing to the file.`n`rPlease check output file.
	goto UpdateDetails
	return

UpdateDetails:
	Gui +Delimiter`n
	guicontrol,, ServerList, `n
	IniRead, FetchedServerList, ServerList.ini,,
	guicontrol, , ServerList, %FetchedServerList%
	guicontrol, , Stam, %FetchedServerList%
	;MsgBox %ServerList%
	gui, show
	return

GuiEscape: ;Escape Stuff
	GuiClose:
	ButtonCancel:
	ExitApp

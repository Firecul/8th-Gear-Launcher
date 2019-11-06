#SingleInstance, Force

Gui, New ;Main Window
	Gui, font,
	Gui +Delimiter|

	gui, add, text, yp+10, Current Servers
	Gui, Add, DropDownList, xp+100 yp-3 w80 vServerList,
	gui, add, text, xp-100 yp+30, Server Name
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
	gui, add, button, xp-101 yp+27 w80 gWrite, Write
	gui, add, text, w80 h145 vStam, (empty)

	gui, add, button, xp+102 yp+152 w80 gGuiClose, Exit
	gui, show, AutoSize Center, INI Writer

	goto UpdateList

	return

Write:
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
	goto UpdateList
	return

UpdateList:
	Gui +Delimiter`n
	guicontrol,, ServerList, `n
	IniRead, FetchedServerList, ServerList.ini,,
	guicontrol, , ServerList, %FetchedServerList%
	guicontrol, , Stam, %FetchedServerList%
	;MsgBox %ServerList%
	gui, show
	return

UpdateDetails:
	GuiControlGet, ServerList
	iniread, ServerIP, ServerList.ini, %ServerList%, IP
	iniread, ServerPort, ServerList.ini, %ServerList%, Port
	iniread, MaxPlayers, ServerList.ini, %ServerList%, MaxPlayers
	iniread, OneSync, ServerList.ini, %ServerList%, OneSync
	guicontrol, , ServerName, %ServerList%
	guicontrol, , ServerIP, %ServerIP%
	guicontrol, , ServerPort, %ServerPort%
	guicontrol, , MaxPlayers, %MaxPlayers%
	guicontrol, , OneSync, %OneSync%

 return

GuiEscape: ;Escape Stuff
	GuiClose:
	ButtonCancel:
	ExitApp

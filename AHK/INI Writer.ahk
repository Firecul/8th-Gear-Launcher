#SingleInstance, Force

Gui, New ;Main Window
	Gui, font,
	Gui +Delimiter`n

	gui, add, text, yp+10, Current Servers
	Gui, Add, ComboBox, xp+100 yp-3 w100 vServerName gUpdateDetails,
	gui, add, text, xp-100 yp+30, IP Address
	gui, add, edit, xp+100 yp-3 w100 vServerIP,
	gui, add, text, xp-100 yp+30, Port
	gui, add, edit, xp+100 yp-3 w100 vServerPort,
	gui, add, text, xp-100 yp+30, Max Players
	Gui, Add, Edit, xp+100 yp-3 w100, 30
	gui, add, UpDown, vMaxPlayers Range1-255,
	gui, add, text, xp-100 yp+30, OneSync Enabled
	gui, add, checkbox, xp+100 w100 vOneSync,
	gui, add, button, xp-101 yp+27 w80 gWrite, Write

	gui, add, button, xp+102 w80 gGuiClose, Exit
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

	guicontrol,, ServerName, `n
	IniRead, ServerName, ServerList.ini,,
	guicontrol, , ServerName, %ServerName%
	guicontrol, text, ServerIP
	guicontrol, text, ServerPort
	guicontrol, text, MaxPlayers
	guicontrol, text, OneSync
	gui, show
	return

UpdateDetails:
	GuiControlGet, ServerName
	iniread, ServerIP, ServerList.ini, %ServerName%, IP
	iniread, ServerPort, ServerList.ini, %ServerName%, Port
	iniread, MaxPlayers, ServerList.ini, %ServerName%, MaxPlayers
	iniread, OneSync, ServerList.ini, %ServerName%, OneSync
	guicontrol, , ServerName, %ServerName%
	guicontrol, , ServerIP, %ServerIP%
	guicontrol, , ServerPort, %ServerPort%
	guicontrol, , MaxPlayers, %MaxPlayers%
	guicontrol, , OneSync, %OneSync%
	guicontrol, text, OneSync

 return

GuiEscape: ;Escape Stuff
	GuiClose:
	ButtonCancel:
	ExitApp

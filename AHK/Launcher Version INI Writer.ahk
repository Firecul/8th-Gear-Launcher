#SingleInstance, Force

Gui, New ;Main Window
	Gui, font,
	Gui +Delimiter`n

	gui, add, text, yp+10, Newest Version
	Gui, Add, ComboBox, xp+100 yp-3 w100 vNewestVersion gUpdateDetails,
	gui, add, text, yp+10, Version Number
	Gui, Add, ComboBox, xp+100 yp-3 w100 vVersionNumber gUpdateDetails,
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
	gui, add, button, xp+122 w80 gDelete, Delete

	gui, add, button, w80 gGuiClose, Exit
	gui, show, AutoSize Center, INI Writer

	goto UpdateList

	return

Write:
	GuiControlGet, NewestVersion
	GuiControlGet, VersionNumber
	GuiControlGet, ServerIP
	GuiControlGet, ServerPort
	GuiControlGet, MaxPlayers
	GuiControlGet, OneSync

	
	IniWrite, %ServerIP%, VERSION_INFO.ini, %VersionNumber%, IP
	IniWrite, %ServerPort%, VERSION_INFO.ini, %VersionNumber%, Port
	IniWrite, %MaxPlayers%, VERSION_INFO.ini, %VersionNumber%, MaxPlayers
	IniWrite, %OneSync%, VERSION_INFO.ini, %VersionNumber%, OneSync
	if ErrorLevel
	MsgBox There has been an error writing to the file.`n`rPlease check output file.
	goto UpdateList
	return

Delete:
	inidelete, VERSION_INFO.ini, %VersionNumber%
	goto UpdateList
	return

UpdateList:
	guicontrol,, VersionNumber, `n
	IniRead, VersionNumber, VERSION_INFO.ini,,
	guicontrol, , VersionNumber, %VersionNumber%
	guicontrol, text, ServerIP
	guicontrol, text, ServerPort
	guicontrol, text, MaxPlayers
	guicontrol, text, OneSync
	gui, show
	goto UpdateDetails
	return

UpdateDetails:
	GuiControlGet, VersionNumber
	iniread, ServerIP, VERSION_INFO.ini, %VersionNumber%, IP
	iniread, ServerPort, VERSION_INFO.ini, %VersionNumber%, Port
	iniread, MaxPlayers, VERSION_INFO.ini, %VersionNumber%, MaxPlayers
	iniread, OneSync, VERSION_INFO.ini, %VersionNumber%, OneSync
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

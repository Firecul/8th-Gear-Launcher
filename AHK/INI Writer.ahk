#SingleInstance, Force

Gui, New ;Main Window
	Gui, font, norm
	gui, add, text, yp+10, Server Name
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

	gui, add, button, xp-101 yp+26 w80 gSave, Save
	gui, add, button, xp+102 w80 gGuiClose, Exit
	gui, show, AutoSize Center, INI Writer
	return

Save:
	GuiControlGet, ServerName
	GuiControlGet, ServerIP
	GuiControlGet, ServerPort
	GuiControlGet, MaxPlayers
	GuiControlGet, OneSync

	IniWrite, %ServerIP%, Launcherdata.ini, %ServerName%, IP
	IniWrite, %ServerPort%, Launcherdata.ini, %ServerName%, Port
	IniWrite, %MaxPlayers%, Launcherdata.ini, %ServerName%, MaxPlayers
	IniWrite, %OneSync%, Launcherdata.ini, %ServerName%, OneSync
	if ErrorLevel
	MsgBox There has been an error writing to the file.`n`rPlease check output file.
	return

GuiEscape: ;Escape Stuff
	GuiClose:
	ButtonCancel:
	ExitApp

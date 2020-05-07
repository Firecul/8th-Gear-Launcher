#SingleInstance, Force

Gui, New ;Main Window
	Gui, font,
	Gui +Delimiter`n

	gui, add, text, yp+10, Newest Version
	Gui, Add, ComboBox, xp+100 yp-3 w100 vNewestVersion gUpdateDetails,
	gui, add, text, xp-100 yp+30, Version Number
	Gui, Add, ComboBox, xp+100 yp-3 w100 vVersionNumber gUpdateDetails,
	gui, add, text, xp-100 yp+30, Update Log
	gui, add, edit, xp+100 yp-3 w200 r10 Multi vChanges,
	gui, add, button, xp-101 yp+147 w80 gWrite, Write
	gui, add, button, xp+122 w80 gDelete, Delete
	gui, add, button, w80 gGuiClose, Exit
	gui, show, AutoSize Center, INI Writer

	goto UpdateList
	return

Write:
	GuiControlGet, NewestVersion
	GuiControlGet, VersionNumber
	GuiControlGet, Changes
	StringReplace, Changes, Changes, `n, ``n, All
	IniWrite, %NewestVersion%, VERSION_INFO.ini, NewestVersion, Version
	IniWrite, %Changes%, VERSION_INFO.ini, %VersionNumber%, Changes
	if ErrorLevel
	MsgBox There has been an error writing to the file.`n`rPlease check output file.
	goto UpdateList
	return

Delete:
	inidelete, VERSION_INFO.ini, %VersionNumber%
	goto UpdateList
	return

UpdateList:
	guicontrol,, NewestVersion, `n
	guicontrol,, VersionNumber, `n
	IniRead, NewestVersion, VERSION_INFO.ini, NewestVersion, Version
	IniRead, VersionNumber, VERSION_INFO.ini
	guicontrol, , NewestVersion, %NewestVersion%
	guicontrol, , VersionNumber, %VersionNumber%
	gui, show
	goto UpdateDetails
	return

UpdateDetails:
	GuiControlGet, VersionNumber
	iniread, Changes, VERSION_INFO.ini, %VersionNumber%, Changes
	StringReplace, Changes, Changes, ``n, `n, All" Seems to work
	guicontrol, , Changes, %Changes%
	return

GuiEscape: ;Escape Stuff
	GuiClose:
	ButtonCancel:
	ExitApp

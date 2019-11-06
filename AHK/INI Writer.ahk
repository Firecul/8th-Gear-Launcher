#SingleInstance, Force

Gui, New ;Main Window
	Gui, font, norm
	gui, add, edit, w80 vServerName, Name
	gui, add, edit, w80 vServerIP, 127.0.0.1
	gui, add, edit, w80 vServerPort, 30120
	gui, add, edit, w80 vMaxPlayers, 30
	gui, add, edit, w80 vOneSync, False
	Gui, add, button, w100 gSave, Save
	GUi, add, button, xp+545 w100 gGuiClose, Exit
	Gui, Show, AutoSize Center, INI Writer
	return

Save:
	return

GuiEscape: ;Escape Stuff
	GuiClose:
	ButtonCancel:
	ExitApp

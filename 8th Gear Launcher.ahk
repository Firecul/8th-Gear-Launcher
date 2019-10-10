#SingleInstance, Force

FileCreateDir, 8thGearLauncher
Fileinstall, pictures/8GLogo.png, 8thGearLauncher/8GLogo.png, 0
Fileinstall, icons/8G.ico, 8thGearLauncher/8G.ico, 0
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

Gui, New
Gui, Add, Tab3,, Connect|Rules|FAQ|Tools|About

;Tab1
Gui, Add, Picture, w620 h-1, 8thGearLauncher/8GLogo.png
Gui, Add, GroupBox, w220 h115, 8thGear Servers:
GUi, add, button, xp+10 yp+20 w200 +Default gRace, &Main Server
Gui, add, Groupbox, xp+240 yp-20 w370 h45, Disclaimer
Gui, add, link, xp+10 yp+20 w350, By joining our servers you agree to be bound to the <a href="https://discordapp.com/channels/">#rules</a> of our server.
gui, add, groupbox, xp-10 yp+30 w370 h40,
gui, add, link, xp+10 yp+15 w350, <a href="https://8thgear.com/status">To see server status, click here to go to the website</a>

Gui, Tab, 2
Gui, Add, GroupBox, w620 h700, 8thGear Specific Rules:
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

Gui, Tab, 3
Gui, font, s10 norm
Gui, Add, edit, w620 h700 Multi ReadOnly, %vFAQ%


Gui, Tab, 4
Gui, font, s10 norm
Gui, Add, groupbox, w620 h50, FiveM install location:
Gui, add, text, xp+10 yp+20 w300 vselfile, (Not found)
Gui, add, button, xp+470 yp-6 glookforfivem, Locate FiveM install
Gui, Add, groupbox, xp-480 yp+40 w620 h690, Found Logs:
Gui, Add, ListView, xp+10 yp+20 r10 w600 gMyListView, Name|Size (KB)|Modified
gui, add, button, xp+213 yp+235 gOpenDefault, Open log in Default
gui, add, button, xp+130 gOpenNotepad, Open Log in Notepad
Gui, add, button, xp+144 gParse, Parse and Open
Gui, add, text, xp-490 yp+50 w600 vFileContent, (No log open.)

Gui, Tab, 5
Gui, font, s10 norm
Gui, Add, link, w620, Hello and welcome to the 8thGear FiveM Launcher! `n`nThis Launcher serves as the hub for everything you need to play on the 8thGear servers and a few useful tools that will help you along the way. `n`n<Blurb goes here>


Gui, Tab
Gui, font, norm
Gui, add, button, w100 g8GDiscord, Discord
GUi, add, button, xp+545 w100 gGuiClose, Exit
Gui, Show, AutoSize Center, 8thGear FiveM Launcher
;Gui, -SysMenu +Owner

EnvGet, LOCALAPPDATA, LOCALAPPDATA
Loop, %LOCALAPPDATA%\FiveM\FiveM.exe, , 1
SelectedFile := A_LoopFileFullPath
Guicontrol, , selfile, %SelectedFile%
goto updatefiles
return

;Tab1 Stuff
race:
	Run fivem://connect/149.56.15.167
	return

lookforfivem:
Gui +OwnDialogs
FileSelectFile, SelectedFile, 3, , Locate FiveM.exe, FiveM (FiveM.exe)
if (SelectedFile = "")
		MsgBox, The user didn't select anything.
		LV_Delete()
;else
		;MsgBox, The user selected the following:`n%SelectedFile%

Guicontrol, , selfile, %SelectedFile%
goto updatefiles
return

updatefiles:
;dirvar = FiveM Application Data
;MsgBox, %dirvar%
StringTrimRight, seldir, selectedfile, 9
seldir2 := seldir . "FiveM.app\"

Loop, %seldir2%\CitizenFX.log*
		LV_Add("", A_LoopFileName, A_LoopFileSizeKB, A_LoopFileTimeModified, A_LoopFileFullPath)

LV_ModifyCol()	; Auto-size each column to fit its contents.
LV_ModifyCol(2, "75 Integer")	; For sorting purposes, indicate that column 2 is an integer.
LV_ModifyCol(3, "digit")

; Display the window and return. The script will be notified whenever the user double clicks a row.
Gui, Show
return

MyListView:
if (A_GuiEvent = "DoubleClick")
{
	LV_GetText(FileName, A_EventInfo, 1) ; Get the text of the first field.
	;LV_GetText(FileDir, A_EventInfo, 4)	; Get the text of the second field.
	Run %seldir2%%FileName%,, UseErrorLevel
	if ErrorLevel
		MsgBox Could not open %seldir2%%FileName%
		;LV_GetText(RowText, A_EventInfo)	; Get the text from the row's first field.

	;ToolTip You double-clicked row number %A_EventInfo%. Text: "%RowText%"
}
return

opendefault:
RowNumber := 0  ; This causes the first loop iteration to start the search at the top of the list.
Loop
{
    RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_GetText(Text, RowNumber)
		Guicontrol, , FileContent, %seldir2%%Text%
		seldirthree := seldir2 . Text
		Run %seldirthree%,, UseErrorLevel
		if ErrorLevel
			MsgBox Could not open %seldirthree%
}
return

opennotepad:
RowNumber := 0  ; This causes the first loop iteration to start the search at the top of the list.
Loop
{
    RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_GetText(Text, RowNumber)
		Guicontrol, , FileContent, %seldir2%%Text%
		seldirthree := seldir2 . Text
		Run C:\Windows\Notepad.exe %seldirthree%,, UseErrorLevel
		if ErrorLevel
			MsgBox Could not open %seldirthree%
}
return


Par:
	lv_gettext(carName,LV_GetNext())
	fileread,fileContents,%carsFolderPath%\%carName%\%carDataFileListbox%
	guicontrol,text,filecontentsbox,%fileContents%
return

Parse:
RowNumber := 0  ; This causes the first loop iteration to start the search at the top of the list.
Loop
{
    RowNumber := LV_GetNext(RowNumber)  ; Resume the search at the row after that found by the previous iteration.
    if not RowNumber  ; The above returned zero, so there are no more selected rows.
        break
    LV_GetText(Text, RowNumber)
    MsgBox The next selected row is #%RowNumber%, whose first field is "%Text%".
}
return


8GDiscord:
 Run https://discord.gg/
return

;Escape Stuff
GuiEscape:
GuiClose:
ButtonCancel:
FileRemoveDir, 8thGearLauncher, 1
	ExitApp

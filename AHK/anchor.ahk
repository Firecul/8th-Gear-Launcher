/*
	Function: Anchor
		Defines how controls should be automatically positioned relative to the new dimensions of a window when resized.

	Parameters:
		i - a control HWND, associated variable name or ClassNN to operate on
		a - (optional) one or more of the anchors: 'x', 'y', 'w' (width) and 'h' (height),
			optionally followed by a relative factor, e.g. "x h0.5"
		r - (optional) true to redraw controls, recommended for GroupBox and Button types

	Examples:
> "xy" ; bounds a control to the bottom-left edge of the window
> "w0.5" ; any change in the width of the window will resize the width of the control on a 2:1 ratio
> "h" ; similar to above but directrly proportional to height

	Remarks:
		To assume the current window size for the new bounds of a control (i.e. resetting) simply omit the second and third parameters.
		However if the control had been created with DllCall() and has its own parent window,
			the container AutoHotkey created GUI must be made default with the +LastFound option prior to the call.
		For a complete example see anchor-example.ahk.

	License:
		- Version 4.60a <http://www.autohotkey.net/~polyethene/#anchor>
		- Dedicated to the public domain (CC0 1.0) <http://creativecommons.org/publicdomain/zero/1.0/>
*/
Anchor(i, a = "", r = False)
{
	Static Ptr, PtrSize, GetParent, GetWindowInfo, SetWindowPos, RedrawWindow, c, cs, cl = 0, g, gs, gl = 0, gi, gpi, gw, gh
	If !Ptr {
		Ptr := A_PtrSize ? "Ptr" : "UInt"
		, PtrSize := A_PtrSize ? A_PtrSize : 4
		, AStr := A_IsUnicode ? "AStr" : "Str"
		, Module := DllCall("GetModuleHandle", "Str", "user32", Ptr)
		, GetParent := DllCall("GetProcAddress", Ptr, Module, AStr, "GetParent", Ptr)
		, GetWindowInfo := DllCall("GetProcAddress", Ptr, Module, AStr, "GetWindowInfo", Ptr)
		, SetWindowPos := DllCall("GetProcAddress", Ptr, Module, AStr, "SetWindowPos", Ptr)
		, RedrawWindow := DllCall("GetProcAddress", Ptr, Module, AStr, "RedrawWindow", Ptr)
		, cs := PtrSize + 8
		, gs := PtrSize + 4
		, VarSetCapacity(c, cs * 255, 0)
		, VarSetCapacity(g, gs * 99, 0)
		, VarSetCapacity(gi, 60, 0) ; WINDOWINFO structure http://msdn.microsoft.com/library/ms632610
		, NumPut(60, gi, 0, "UInt") ; WINDOWINFO.cbSize = sizeof(WINDOWINFO)
	}
	If !WinExist("ahk_id " i) {
		GuiControlGet, t, Hwnd, %i%
		If ErrorLevel = 0
			i := t
		Else, ControlGet, i, Hwnd, , %i%
	}
	DllCall(GetWindowInfo ; http://msdn.microsoft.com/library/ms633516
		, Ptr, gp := DllCall(GetParent, Ptr, i, Ptr) ; http://msdn.microsoft.com/library/ms633510
		, Ptr, &gi
		, "Int")
	, giw := NumGet(gi, 28, "Int") - NumGet(gi, 20, "Int")
	, gih := NumGet(gi, 32, "Int") - NumGet(gi, 24, "Int")
	If (gp != gpi) {
		gpi := gp
		Loop, %gl%
			If (NumGet(g, cb := gs * (A_Index - 1), Ptr) == gp) {
				gw := NumGet(g, cb + PtrSize, "Short")
				, gh := NumGet(g, cb + PtrSize + 2, "Short")
				, gf := 1
				Break
			}
		If !gf
			NumPut(gp, g, gl, Ptr)
			, NumPut(gw := giw, g, gl + PtrSize, "Short")
			, NumPut(gh := gih, g, gl + PtrSize + 2, "Short")
			, gl += gs
	}
	ControlGetPos, dx, dy, dw, dh, , ahk_id %i%
	Loop, %cl%
		If (NumGet(c, cb := cs * (A_Index - 1), Ptr) == i) {
			If (a = "") {
				cf = 1
				Break
			}
			giw -= gw
			, gih -= gh
			, as := 1
			, dx := NumGet(c, cb + PtrSize, "Short")
			, dy := NumGet(c, cb + PtrSize + 2, "Short")
			, cw := dw
			, dw := NumGet(c, cb + PtrSize + 4, "Short")
			, ch := dh
			, dh := NumGet(c, cb + PtrSize + 6, "Short")
			Loop, Parse, a, xywh
				If A_Index > 1
					av := SubStr(a, as, 1)
					, as += 1 + StrLen(A_LoopField)
					, d%av% += (InStr("yh", av) ? gih : giw) * (A_LoopField + 0 ? A_LoopField : 1)
			DllCall(SetWindowPos ; http://msdn.microsoft.com/library/ms633545
				, Ptr, i
				, Ptr, 0 ; HWND_TOP
				, "Int", dx
				, "Int", dy
				, "Int", InStr(a, "w") ? dw : cw
				, "Int", InStr(a, "h") ? dh : ch
				, "UInt", 0x0004 ; SWP_NOZORDER
				, "Int")
			If r != 0
				DllCall(RedrawWindow ; http://msdn.microsoft.com/library/dd162911
					, Ptr, i
					, Ptr, 0
					, Ptr, 0
					, "UInt", 0x0001 | 0x0100 ; RDW_INVALIDATE | RDW_UPDATENOW
					, "Int")
			Return
		}
	If cf != 1
		cb := cl
		, cl += cs
	bx := NumGet(gi, 48, "UInt")
	, by := NumGet(gi, 16, "Int") - NumGet(gi, 8, "Int") - gih - NumGet(gi, 52, "UInt")
	If cf = 1
		dw -= giw - gw
		, dh -= gih - gh
	NumPut(i, c, cb, Ptr)
	, NumPut(dx - bx, c, cb + PtrSize, "Short")
	, NumPut(dy - by, c, cb + PtrSize + 2, "Short")
	, NumPut(dw, c, cb + PtrSize + 4, "Short")
	, NumPut(dh, c, cb + PtrSize + 6, "Short")
	Return, True
}

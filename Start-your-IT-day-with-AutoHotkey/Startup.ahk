#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
#Warn  ; Enable warnings to assist with detecting common errors.

SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode, RegEx
SetTitleMatchMode, Slow

programs := Object()
programs.Insert(new TProgram(" - Notepad++", "notepad++.exe", TWindowState.Min))
programs.Insert(new TProgram(" - Microsoft Visual Studio", "devenv.exe", TWindowState.Max))
programs.Insert(new TProgram(" - Outlook", "outlook.exe", TWindowState.Max))
programs.Insert(new TProgram("Fiddler Web Debugger", "Fiddler.exe", TWindowState.Min))

for index, prog in programs {
	Run % prog.ProcessName
}

Loop {
	index := 1
	
	if (programs.Length() = 0) {
		break
	}
		
	for index, prog in programs {
		title := prog.ProgramTitle

		WinWait %title%,, 10
		if (ErrorLevel = 0) {
			Sleep, 4000
			if (prog.State = TWindowState.Min) {
				WinMinimize % prog.ProgramTitle
			} else if (prog.State = TWindowState.Max) {
				WinMaximize % prog.ProgramTitle
			} else if (prog.State = TWindowState.Hide) {
				WinHide % prog.ProgramTitle
			}
			
			programs.RemoveAt(index)
		}
	}

	index := index + 1
}

Return

class TProgram {
	ProgramTitle := ""
	ProcessName := ""
	State := ""

	__New(programTitle, processName, state) {
		this.ProgramTitle := programTitle
		this.ProcessName := processName
		this.State := state
	}
}

class TWindowState {
	static Normal := 0
	static Min := 1
	static Max := 2
	static Hide := 3
}
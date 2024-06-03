#SingleInstance force

highlightSeconds := 60
intervalMinutes := 5

MyGui := Gui()
MyGui.AddText("", "当前时间:")
CurrentTimeText := MyGui.AddText("vCurrentTime", GetCurrentTime())
MyGui.AddButton("设置当前时间", "SetCurrentTime")
MyGui.AddText("", "高亮时间间隔（秒）:")
HighlightSecondsEdit := MyGui.AddEdit("vHighlightSeconds w100", highlightSeconds)
MyGui.AddText("", "时间间隔（分钟）:")
IntervalMinutesEdit := Gui.AddEdit("vIntervalMinutes w100", intervalMinutes)
MyGui.AddButton("更新设置", "UpdateSettings")
MyGui.AddText("Section", "表格")
ListView := MyGui.AddListView("r10 w800", ["序号", "时间"])

MyGui.AddButton("添加行", "AddRow")
MyGui.AddButton("添加列", "AddColumn")
MyGui.AddButton("删除列", "DeleteColumn")
MyGui.Show()

SetTimer(UpdateTime, 1000)
return

UpdateTime() {
    CurrentTimeText.Value := GetCurrentTime()
    rowCount := ListView.GetCount()
    Loop rowCount {
        rowIndex := A_Index
        baseTimeString := ListView.GetText(rowIndex, 2)
        if (baseTimeString) {
            currentDate := Format("{:04}-{:02}-{:02}", A_Year, A_Mon, A_MDay)
            baseTime := currentDate . " " . baseTimeString
            try {
                baseTimeObj := StrReplace(baseTime, " ", "T")
            } catch {
                continue
            }
            colCount := ListView.GetColumnCount()
            Loop colCount - 2 {
                colIndex := A_Index + 2
                newTime := DateAdd(baseTimeObj, (colIndex - 2) * intervalMinutes, "Minutes")
                newTimeString := Format("{:02}:{:02}:{:02}", newTime.Hour, newTime.Min, newTime.Sec)
                ListView.SetText(rowIndex, colIndex, newTimeString)
                cellTime := StrReplace(currentDate . "T" . newTimeString, " ", "T")
                diff := Abs(DateDiff(cellTime, A_Now, "Seconds"))
                if (diff < highlightSeconds) {
                    ListView.SetText(rowIndex, colIndex, newTimeString " highlight")
                } else {
                    ListView.SetText(rowIndex, colIndex, newTimeString)
                }
            }
        }
    }
}

SetCurrentTime() {
    rowCount := ListView.GetCount()
    Loop rowCount {
        rowIndex := A_Index
        ListView.SetText(rowIndex, 2, Format("{:02}:{:02}:{:02}", A_Hour, A_Min, A_Sec))
    }
}

AddRow() {
    row := ["序号 " ListView.GetCount() + 1, "时间"]
    colCount := ListView.GetColumnCount()
    Loop colCount - 2 {
        row.Push("")
    }
    ListView.Add("", row*)
}

AddColumn() {
    ListView.InsertCol(ListView.GetColumnCount() + 1, "新列 " ListView.GetColumnCount())
    rowCount := ListView.GetCount()
    Loop rowCount {
        rowIndex := A_Index
        ListView.SetText(rowIndex, ListView.GetColumnCount(), "")
    }
}

DeleteColumn() {
    ListView.DeleteCol(ListView.GetColumnCount())
}

UpdateSettings() {
    highlightSeconds := HighlightSecondsEdit.Value
    intervalMinutes := IntervalMinutesEdit.Value
}

GuiClose() {
    ExitApp()
}

GetCurrentTime() {
    return Format("{:04}-{:02}-{:02} {:02}:{:02}:{:02}", A_Year, A_Mon, A_MDay, A_Hour, A_Min, A_Sec)
}

DateAdd(dateTime, addValue, addUnit) {
    date := DateParse(dateTime, "UTC")
    date += addValue, addUnit
    return date
}

DateDiff(dateTime1, dateTime2, diffUnit) {
    date1 := DateParse(dateTime1, "UTC")
    date2 := DateParse(dateTime2, "UTC")
    return date2 - date1
}

DateParse(dateTime, timezone := "") {
    ; static regex := ORegExCreate("(\d{3})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})")
    if !RegExMatch.Match(dateTime, "(\d{3})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})")
        throw Error("Invalid dateTime format", -1, dateTime)
    parts := regex.NamedMatchArray()
    if timezone = "UTC"
        parts.1 -= 0
    date := parts.1 . parts.2 . parts.3 . parts.4 . parts.5 . parts.6
    return date
}

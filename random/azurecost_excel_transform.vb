' ALt + F11 to use Macro in Excel

Public Sub GenerateMonthlyCostSummary_WithBackupAndStyling()
    Dim wb As Workbook
    Dim wsSource As Worksheet
    Dim wsDest As Worksheet
    Dim ptCache As PivotCache
    Dim pt As PivotTable
    Dim chartObj As ChartObject
    Dim rng As Range
    Dim costFieldName As String
    Dim staticStart As Range
    Dim i As Long

    Set wb = ActiveWorkbook

    ' Validate "Data" sheet exists
    On Error Resume Next
    Set wsSource = wb.Sheets("Data")
    On Error GoTo 0

    If wsSource Is Nothing Then
        MsgBox "Could not find a sheet named 'Data' in the active workbook.", vbCritical
        Exit Sub
    End If

    ' Create backup
    Application.DisplayAlerts = False
    On Error Resume Next
    wb.Sheets("Data_Backup").Delete
    On Error GoTo 0
    wsSource.Copy After:=wsSource
    ActiveSheet.Name = "Data_Backup"
    Application.DisplayAlerts = True

    ' Delete columns (reverse order)
    Application.DisplayAlerts = False
    On Error Resume Next
    wsSource.Columns("I").Delete
    wsSource.Columns("H").Delete
    wsSource.Columns("F").Delete
    wsSource.Columns("C").Delete
    wsSource.Columns("B").Delete
    On Error GoTo 0
    Application.DisplayAlerts = True

    costFieldName = wsSource.Cells(1, 4).Value ' typically "CostUSD"

    ' Ensure valid headers exist
    Dim headersOk As Boolean
    headersOk = True
    For i = 1 To 4
        If Trim(wsSource.Cells(1, i).Value) = "" Then
            headersOk = False
            Exit For
        End If
    Next i

    If Not headersOk Then
        MsgBox "One or more column headers (A1:D1) are missing or blank.", vbCritical
        Exit Sub
    End If

    ' Delete old summary if exists
    On Error Resume Next
    wb.Sheets("Monthly Cost Summary").Delete
    On Error GoTo 0

    ' Add output sheet
    Set wsDest = wb.Sheets.Add
    wsDest.Name = "Monthly Cost Summary"

    ' Use CurrentRegion for reliable pivot source
    Dim srcRange As Range
    Set srcRange = wsSource.Range("A1").CurrentRegion

    Set ptCache = wb.PivotCaches.Create( _
        SourceType:=xlDatabase, _
        SourceData:=srcRange)

    ' Create Pivot Table
    Set pt = ptCache.CreatePivotTable( _
        TableDestination:=wsDest.Range("A3"), _
        TableName:="CostSummary")

    With pt
        .PivotFields("ServiceName").Orientation = xlRowField
        .PivotFields("UsageDate").Orientation = xlColumnField
        .AddDataField .PivotFields(costFieldName), "Sum of " & costFieldName, xlSum
        .DataFields(1).NumberFormat = "$#,##0.00"
        .PivotFields("ServiceName").PivotFilters.Add2 _
            Type:=xlTopCount, DataField:=.DataFields(1), Value1:=15
    End With

    ' Create chart
    Dim lastCol As Long, lastRow As Long
    lastCol = wsDest.Cells(3, Columns.Count).End(xlToLeft).Column
    lastRow = wsDest.Cells(Rows.Count, 1).End(xlUp).Row
    Set rng = wsDest.Range(wsDest.Cells(3, 1), wsDest.Cells(lastRow, lastCol))

    Set chartObj = wsDest.ChartObjects.Add(Left:=400, Width:=500, Top:=50, Height:=300)
    With chartObj.Chart
        .SetSourceData Source:=rng
        .ChartType = xlColumnClustered
        .HasTitle = True
        .ChartTitle.Text = "Monthly Cost by Service"
        .Legend.Position = xlLegendPositionBottom
    End With

    ' === Copy Pivot to Static Table ===
    Set staticStart = wsDest.Cells(lastRow + 3, 1)
    pt.TableRange1.Copy
    staticStart.PasteSpecial Paste:=xlPasteValuesAndNumberFormats

    ' === Locate header row with dates
    Dim headerRow As Long
    Dim testVal As String
    headerRow = 0
    For i = staticStart.Row To staticStart.Row + 5
        For j = 2 To 20
            testVal = Trim(wsDest.Cells(i, j).Text)
            If testVal Like "####-##-##" Then
                headerRow = i
                Exit For
            End If
        Next j
        If headerRow > 0 Then Exit For
    Next i

    If headerRow = 0 Then
        MsgBox "Could not locate month column headers.", vbCritical
        Exit Sub
    End If

    ' === Calculate % Change between last 2 months
    Dim colDate1 As Long, colDate2 As Long
    Dim dateCols() As Long
    Dim dcCount As Long: dcCount = 0
    Dim maxCol As Long: maxCol = wsDest.Cells(headerRow, Columns.Count).End(xlToLeft).Column
    ReDim dateCols(1 To maxCol)

    For i = 2 To maxCol
        testVal = Trim(wsDest.Cells(headerRow, i).Text)
        If testVal Like "####-##-##" Then
            dcCount = dcCount + 1
            dateCols(dcCount) = i
        End If
    Next i

    If dcCount < 2 Then
        MsgBox "Not enough months found to calculate % Change.", vbCritical
        Exit Sub
    End If

    colDate1 = dateCols(dcCount - 1)
    colDate2 = dateCols(dcCount)

    Dim colChangePos As Long
    colChangePos = maxCol + 1
    wsDest.Cells(headerRow, colChangePos).Value = "% Change"

    Dim dataRow As Long
    Dim prevMonthVal As Variant, latestMonthVal As Variant

    For dataRow = headerRow + 1 To wsDest.Cells(headerRow, 1).End(xlDown).Row
        prevMonthVal = wsDest.Cells(dataRow, colDate1).Value
        latestMonthVal = wsDest.Cells(dataRow, colDate2).Value

        If IsNumeric(prevMonthVal) And prevMonthVal <> 0 Then
            wsDest.Cells(dataRow, colChangePos).Value = (latestMonthVal - prevMonthVal) / prevMonthVal
            wsDest.Cells(dataRow, colChangePos).NumberFormat = "0.00%"
        Else
            wsDest.Cells(dataRow, colChangePos).Value = ""
        End If
    Next dataRow

    wsDest.Columns(colChangePos).AutoFit

    ' === Create formatted copy of final table
    Dim styledStart As Range
    Set styledStart = wsDest.Cells(wsDest.Cells(Rows.Count, 1).End(xlUp).Row + 3, 1)

    Dim copyRange As Range
    Set copyRange = wsDest.Range(wsDest.Cells(headerRow, 1), wsDest.Cells(wsDest.Cells(headerRow, 1).End(xlDown).Row, colChangePos))
    copyRange.Copy
    styledStart.PasteSpecial Paste:=xlPasteValuesAndNumberFormats

    ' Header styling
    With wsDest.Range(styledStart, styledStart.Offset(0, colChangePos - 1))
        .Font.Bold = True
        .Interior.Color = RGB(0, 112, 192)
        .Font.Color = RGB(255, 255, 255)
    End With

    ' Conditional formatting on % Change
    Dim formatRange As Range
    Set formatRange = wsDest.Range(styledStart.Offset(1, colChangePos - 1), styledStart.Offset(copyRange.Rows.Count - 1, colChangePos - 1))

    With formatRange.FormatConditions
        .Delete
        .Add Type:=xlCellValue, Operator:=xlGreater, Formula1:="=0"
        .Item(1).Font.Color = RGB(255, 0, 0) ' Red = increase
        .Add Type:=xlCellValue, Operator:=xlLess, Formula1:="=0"
        .Item(2).Font.Color = RGB(0, 176, 80) ' Green = decrease
    End With

    MsgBox "Cost summary, chart, and formatted table generated successfully!", vbInformation
End Sub



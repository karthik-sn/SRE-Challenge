#Requires -Version 7
#Importing conent of the file
$file = Get-Content -Path .\fp-sre-challenge.log

#Creating a blank list to be used later
$dataList = New-Object -TypeName 'System.Collections.ArrayList';
$statusWiseBreakup = New-Object -TypeName 'System.Collections.ArrayList';
$statusTable = New-Object -TypeName 'System.Collections.ArrayList';

#Converting text file into Objects for ease of trasformations
$null = foreach ($line in $file) {
    if ($line -notmatch '- -') { continue }
    $data = $line.Split(' ')
    $tempobj = New-Object psobject @{
        HostName   = $data[0]
        Time       = $data[3] + ' ' + $data[4]
        API        = $data[5] + ' ' + $data[6] + ' ' + $data[7]
        StatusCode = $data[8]
        Size       = $data[9]
    }
    $dataList.add($tempobj)
}
$hostlist = $dataList.HostName | Get-Unique
foreach ($onehost in $hostlist) {
    $dataListforhost = $dataList | where { $_.HostName -imatch $onehost }
    $totalrequestMade = $dataList | where { $_.HostName -imatch $onehost } | Measure | select -expand count
    Write-Output "Total Request made by the Host $onehost is $totalrequestMade"
    #Get a unique list of status codes 
    $statusList = $dataListforhost | Group-Object -Property StatusCode    
    $null = $statusList | foreach { 
        $teobj = New-Object psobject @{
            HostName = $onehost
            ResposeCode = $_.Name
            RequestCount = $_.Count
        }
        $statusWiseBreakup.add($teobj)
    }
    Write-Output "Breakup of requests done by the host $onehost based on the response code:"
    $statusWiseBreakup | select  HostName, ResposeCode, RequestCount | ft -AutoSize

    #Loop through each status code and create an Array of Object statusTable with all required fields 
    $null = foreach ($statusCodes in $statusList) {
        if ($statusCodes.Name -notmatch '[\d][\d][\d]') { continue }
        $temObj = $statusCodes.Group | Group-Object API | Sort-Object -Property Count -Descending | Select-Object Count, Name
        $temObj | Add-Member -NotePropertyName StatusCode -NotePropertyValue $statusCodes.Name  
        $temObj | Select-Object StatusCode, Count, Name | ForEach-Object { $statusTable.Add($_) }
    }

    #Loop though the result of the previous step to add a new column named Status
    $statusTable | ForEach-Object {
        if ($_.statuscode -match '1[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "Informational" }
        elseif ($_.statuscode -match '2[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "Success" }
        elseif ($_.statuscode -match '3[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "Redirect" }
        elseif ($_.statuscode -match '4[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "ClientError" }
        elseif ($_.statuscode -match '5[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "ServerError" }
    
    }
    #Output The summary result on screen
    $statusTable | Format-Table @{Label = "HostName"; Expression = { $onehost } }, Status, statuscode, count, @{Label = "API"; Expression = { $_.name } }

    #Export to CSV for sharing this summary report
    $statusTable | Select-Object @{Label = "HostName"; Expression = { $onehost } }, Status, statuscode, count, @{Label = "API"; Expression = { $_.name } } | Export-Csv -Path .\$onehost.csv -NoTypeInformation
}


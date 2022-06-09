#Importing conent of the file
$file = Get-Content -Path .\Httplogs.txt

#Creating a blank list to be used later
$dataList = New-Object -TypeName 'System.Collections.ArrayList';
$statusTable = New-Object -TypeName 'System.Collections.ArrayList';

#Converting text file into Objects for ease of trasformations
$null = foreach ($line in $file) {
    if($line -notmatch '- -') { continue }
    $data = $line.Split(' ')
    $tempobj = New-Object psobject @{
        IP = $data[0]
        Time = $data[3]+ ' ' + $data[4]
        API = $data[5]+' '+ $data[6]+ ' ' + $data[7]
        StatusCode = $data[8]
        Size = $data[9]
    }
    $dataList.add($tempobj)
}

#Get a unique list of status codes 
$statusList = $dataList | Group-Object -Property StatusCode

#Loop through each status code and create an Array of Object statusTable with all required fields 
$null = foreach($statusCodes in $statusList) {
    if($statusCodes.Name -notmatch '[\d][\d][\d]') { continue }
    $temObj = $statusCodes.Group | Group-Object API | Sort-Object -Property Count -Descending | Select-Object Count, Name
    $temObj | Add-Member -NotePropertyName StatusCode -NotePropertyValue $statusCodes.Name  
    $temObj | Select-Object StatusCode, Count, Name | ForEach-Object {$statusTable.Add($_)}
}

#Loop though the result of the previous step to add a new column named Status
$statusTable | ForEach-Object {
    if($_.statuscode -match '1[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "Informational"}
    elseif($_.statuscode -match '2[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "Success"}
    elseif($_.statuscode -match '3[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "Redirect"}
    elseif($_.statuscode -match '4[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "ClientError"}
    elseif($_.statuscode -match '5[\d][\d]') { $_ | Add-Member -NotePropertyName Status -NotePropertyValue "ServerError"}
    
}
#Output The summary result on screen
$statusTable | Format-Table Status, statuscode, count, @{Label="API"; Expression={$_.name}}

#Export to CSV for sharing this summary report
$statusTable | Select-Object Status, statuscode, count, @{Label="API"; Expression={$_.name}} | Export-Csv -Path .\output.csv -NoTypeInformation

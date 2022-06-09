# Q3: Program to Analyze log file

Assumption:

Logfile is created from a HTTPS requests log

Powershell v7+ is installed on the machine that runs this script

Script is hosted under the github page [https://github.com/karthik-sn/SRE-Challenge/blob/6a1bfe994830bb8134d881c7abb0e3dabaed16cb/PSScript/LogSummary.ps1](https://github.com/karthik-sn/SRE-Challenge/blob/6a1bfe994830bb8134d881c7abb0e3dabaed16cb/PSScript/LogSummary.ps1)

Script is designed to take log file as an input and show summary of the contents in 3 different formats

- Shows the number of request with each source IP that is listed
    
    ![Untitled](Q3%20Program%20to%20Analyze%20log%20file%20ce11bbf22f3e47de8ac782eb7f989b8a/Untitled.png)
    
- Shows the breakup count based on the response code originated from a specific host
    
    ![Untitled](Q3%20Program%20to%20Analyze%20log%20file%20ce11bbf22f3e47de8ac782eb7f989b8a/Untitled%201.png)
    
- Shows the aggregated count against individual API endpoint with the number of times it has called

![Untitled](Q3%20Program%20to%20Analyze%20log%20file%20ce11bbf22f3e47de8ac782eb7f989b8a/Untitled%202.png)

How to run this script: 

On linux machine install pwsh using this [Guide](https://docs.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-linux?view=powershell-7.2). 

Open Terminal and create a dir which holds the log file and the script

If you are using a different log file, make sure to give the path in Line 3 of the script file:

![Untitled](Q3%20Program%20to%20Analyze%20log%20file%20ce11bbf22f3e47de8ac782eb7f989b8a/Untitled%203.png)

Command to run the script

```powershell
pwsh.exe .\PSScript.ps1
```
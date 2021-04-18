# Script of RVTools Report

## Scope:
Script that creates RVTools export and sents mail with the excel file via mail to admins. it keeps the files for a timeframe that you specify on the script
 

## Requirements:
* Windows Server 2K12 and above // Windows 10
* Powershell 5.1 and above
* PowerCli either standalone or import the module in Powershell (Preferred)
* RVTools 3.10 

## Configuration

 Set vCenter info
 ```pwsh
  $Server  = @("vcenter name or ip")
```
Set retention in days for the files. By default is 60 days
```pwsh  
 ### $RetentionDays = 60 ###
```
Set path and details in order to run RVTools
```pwsh
. "C:\Program Files (x86)\Robware\RVTools\RVTools.exe"  -u ###< User in order to access vcenter > ### -p ###<encrypted password > ### -s "$Server" -c ExportAll2xls -d "$BasePath\$Date\$Server"
```

Set mail parameters in order to sent mail with attach xls file.
```pwsh
send-mailmessage -from "###< mail from >### " -to "###< mail address to >###" -subject "Customer: Daily RVTools report $(get-date -f "dd-MM-yyyy")" -body "Below you can find the rvtools report. Please see attachment. `n `n `n Do Not Reply to this mail. This is auto generated mail. `n `n `n " -Attachments $destination -smtpServer ###<smtp ip> ###``` 
```

## Frequetly Asked Questions:
* Can RVTools being used in GTS?
  > RVTools is a free for use in Enterprise environments until 3.10 version. Above 3.10 is prohibited to be used in any environment. More information regarding the guidance of RVTools in GTS can be found here: https://w3.ibm.com/w3publisher/gts-cyber-security-hub/advisories-and-actions/2019-gts-rvtools-usage 
  
* The script cannot sent mail?
  > Check if the smtp IP is correct or if the ip is allowed to sent mail.
  ```cmd
   Telnet  <SMTP_IP>  25
  ```
  
* How can I decrypt password inside the script.
  > RVTools has a tool in order to decrypt the password in location 
   ```
   C:\Program Files (x86)\Robware\RVTools\RVToolsPasswordEncryption.exe
   ```
   ![Alt text](/screens/rvtools_enc.jpg?raw=true "RVTools Encryption Tool")
   
  

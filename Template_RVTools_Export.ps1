<#
.Description 
   Performs full RVTools export from vcenters and sents the zip file to DPE/SAM/SIL via mail 
   
.Verison
   1.2
#>
param
(
 # Get current day 
   $Date = (Get-Date -f "ddMMyyyy"),

 # vCenters list
  ### < $Server  = @("vcenter name or ip"),  >###
   
 # Folders that are going to be used for temp export and archive
   $source = "C:\scripts\RVTools\"+$Date,
   $destination = "C:\scripts\RVTools\Archives\"+$Date+".zip",
   $BasePath = "C:\scripts\RVTools",
   
 # Retention variables
   $checkfolder =  "C:\scripts\RVTools\Archives",
   $RetentionDays = 60
)

# Add the plugin for file compression
   Add-Type -assembly "system.io.compression.filesystem"

# Create Directory
   New-Item -Path "$BasePath\$Date\$Server" -ItemType Directory -ErrorAction SilentlyContinue | Out-Null
   
# Run RVTools and export all to excel
  . "C:\Program Files (x86)\Robware\RVTools\RVTools.exe"  -u ###< User in order to access vcenter > ### -p ###<encrypted password > ### -s "$Server" -c ExportAll2xls -d "$BasePath\$Date\$Server"
  
#Compress the folder and place it to Archive folder. Delete the original folder
   Start-Sleep -s 100
   [io.compression.zipfile]::CreateFromDirectory($Source, $destination)
   Start-Sleep -s 60
   Remove-Item -path $source -recurse

# Sent mail with the attachment.
   If (Test-Path $destination) {
   # If file exists then sent mail to DPE / SAM / SIL
     send-mailmessage -from "###< mail from >### " -to "###< mail address to >###" -subject "Customer: Daily RVTools report $(get-date -f "dd-MM-yyyy")" -body "Below you can find the rvtools report. Please see attachment. `n `n `n Do Not Reply to this mail. This is auto generated mail. `n `n `n " -Attachments $destination -smtpServer ###<smtp ip> ###
 }
#In case the report has issues sent mail with different message 
else {
     send-mailmessage -from "###< mail from >### " -to "###< mail address to >###" -subject "Customer: problem with RVTools script output report  $(get-date -f "dd-MM-yyyy")" -body "Report has not been generated" -smtpServer ###<smtp ip> ###
}

# Delete files older than 60 days in the archive folder  
   Get-ChildItem -Path $checkfolder -Recurse -Force | Where-Object { !$_.PSIsContainer -and $_.CreationTime -lt $RetentionDays } | Remove-Item -Force

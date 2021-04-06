#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

Set-PSDebug -Off

try {

   # Search & Find the DelphixConnector path
   # Get the drive above B
   $drives=(Get-PSDrive -PSProvider FILESYSTEM | where {$_.name -gt "B"})
   foreach ( $drive in $drives ) {
      $driveName = "${drive}:\";
      $delphixConnectorPath = (Get-Childitem $driveName -Recurse  -Name DelphixConnector)
      if ($delphixConnectorPath) {
         $delphixConnectorPath = "${driveName}${delphixConnectorPath}"
         break
      }
   }
   # Set the toolkit, scripts, logs, & mount directory
   $toolkitDir = "${delphixConnectorPath}\${env:DLPX_TOOLKIT_NAME}"
   if(!(Test-Path $toolkitDir)) {
      md ${toolkitDir}  | Out-Null
      md ${toolkitDir}\logs  | Out-Null
      md ${toolkitDir}\mnt  | Out-Null
      md ${toolkitDir}\scripts  | Out-Null
      echo "Creating toolkit:${toolkitDir} Directories" | Out-File -append -filepath ${toolkitDir}\logs\RepositoryDebug.log
   }
   if(!(Test-Path $toolkitDir\scripts)) {
      md ${toolkitDir}\scripts
   }
   if(!(Test-Path $toolkitDir\logs)) {
      md ${toolkitDir}\logs
   }
   if(!(Test-Path $toolkitDir\mnt)) {
      md ${toolkitDir}\mnt
   }
   Set-Content -Path "$toolkitDir\scripts\delphixLibrary.ps1" -Value "$env:DLPX_LIBRARY_SOURCE"
   Set-Content -Path "$toolkitDir\scripts\oracleLibrary.ps1" -Value "$env:ORA_LIBRARY_SOURCE"
   echo ("""${toolkitDir}""").Replace('\','\\')

}
catch {
   $timestamp = "$(Get-Date -Format 'MM-dd-yy HH:mm:ss')"
   if(!(Test-Path $toolkitDir)) {
      if(!(Test-Path c:\temp)) {
         md c:\temp
      }
      echo "Caught an exception (${timestamp}):" | Out-File -append -filepath c:\temp\RepositoryDebug.log
      echo "Exception Type: $($_.Exception.GetType().FullName)" | Out-File -append -filepath c:\temp\RepositoryDebug.log
      echo "Exception Message: $($_.Exception.Message)" | Out-File -append -filepath c:\temp\RepositoryDebug.log
   } else {
      echo "Caught an exception (${timestamp}):" | Out-File -append -filepath ${toolkitDir}\logs\RepositoryDebug.log
      echo "Exception Type: $($_.Exception.GetType().FullName)" | Out-File -append -filepath ${toolkitDir}\logs\RepositoryDebug.log
      echo "Exception Message: $($_.Exception.Message)" | Out-File -append -filepath ${toolkitDir}\logs\RepositoryDebug.log
   }
}
finally {
   exit 0
}

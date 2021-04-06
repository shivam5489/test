#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

Set-PSDebug -Off

try {
if ($Host.Version -eq "2.0") {
   powershell -File $MyInvocation.MyCommand.Definition
   exit
}
$delphixToolkitPath = $env:DLPX_TOOLKIT_PATH
$scriptDir = "${delphixToolkitPath}\scripts"
Add-Content "C:\temp\debug.log" -value "env = $scriptDir"
. $scriptDir\delphixLibrary.ps1

$programName = 'repoDiscovery.ps1'
log "Executing $programName"
log "ENVIRONMENT VARS"
$psVersion = $Host.Version
log "psVersion: $psVersion"

$allVariables = $(ls env: | select name,value)
foreach ( $variable in $allVariables) {
   $envVars = [string]$variable.Name + " : " + [string]$variable.Value
   log $envVars
}

$toolkitName = "$env:DLPX_TOOLKIT_NAME"
Add-Content "C:\temp\debug.log" -value "toolkitName = $toolkitName"
$firstInstance=0

#Get a list of Oracle homes from the registry
$homes = Get-ChildItem -Path HKLM:\SOFTWARE\Oracle | where {$_.Name -match 'KEY_Ora'}

#Loop through each home and add the desired information to the display object
foreach ($path in $homes)
{
   $odir = Split-Path $path.Name -Leaf
   $oraObject = Get-ItemProperty "HKLM:\SOFTWARE\Oracle\$odir"

   $oraInst = @{toolkitName=$toolkitName}
   $oraInst += @{delphixToolkitPath=$delphixToolkitPath}
   $oraInst += @{oraHomeName=$oraObject.ORACLE_HOME_NAME}
   $oraInst += @{oraHome=$oraObject.ORACLE_HOME}
   $oraInst += @{oraEdition=$oraObject.ORACLE_BUNDLE_NAME}
   $oraInst += @{oraSvcUser=$oraObject.ORACLE_SVCUSER}
   $oraInst += @{oraBase=$oraObject.ORACLE_BASE}
   $oraInst += @{oraHomeKey=$oraObject.ORACLE_HOME_KEY}
   $prettyName = $toolkitName + " - " + $oraObject.ORACLE_HOME_NAME + " (" + $oraObject.ORACLE_HOME + ")"
   $oraInst += @{prettyName=$prettyName}

   if ($firstInstance -eq 0) {
    $json = @($oraInst)
 } else {
    $json += @($oraInst)
 }
 $firstInstance += 1
}

$json=( ConvertTo-Json $json)

echo $json

log "REPOSITORIES: $json"
   exit 0
}
catch {
   Add-content "c:\temp\debug.log" -value "Error: $($error[0])"
   Add-content "c:\temp\debug.log" -value "Error: $($error[0].Line)"
}
finally {
   exit 0
}

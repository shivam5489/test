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
$programName = 'vdb_postSnapshot.ps1'
$delphixToolkitPath = $env:DLPX_TOOLKIT_PATH
$oracleHome = $env:ORACLE_HOME
$oraInstName = $env:ORACLE_INST
$oraUser = $env:ORACLE_USER
$oraPwd = $env:ORACLE_PASSWD
$oraBase = $env:ORACLE_BASE
$oraBkpLoc = $env:ORACLE_BKP_LOC
$oraSrc = $env:ORACLE_SRC_NAME
$oraUnq = $env:ORA_UNQ_NAME
$srcType = "VDB"

$scriptDir = "${delphixToolkitPath}\scripts"

. $scriptDir\delphixLibrary.ps1

log "Executing $programName"

$snapshotMeta = @{oracleHome=$oracleHome}
$snapshotMeta += @{delphixToolkitPath=$delphixToolkitPath}
$snapshotMeta += @{oraInstName=$oraInstName}
$snapshotMeta += @{oraUser=$oraUser}
$snapshotMeta += @{oraBase=$oraBase}
$snapshotMeta += @{oraBkpLoc=$oraBkpLoc}
$snapshotMeta += @{oraDbid=$oraDbid}
$snapshotMeta += @{oraSrc=$oraSrc}
$snapshotMeta += @{oraUnq=$oraUnq}
$snapshotMeta += @{srcType=$srcType}

$json=( ConvertTo-Json $snapshotMeta)

echo $json

log "Snapshot Metadata: $json"

exit 0
}
catch {
Add-content "c:\temp\debug.log" -value "Error: $($error[0])"
Add-content "c:\temp\debug.log" -value "Error: $($error[0].Line)"
}
finally {
exit 0
}

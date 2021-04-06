#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

$programName = 'vdb_copy_to_vdbdir.ps1'
$delphixToolkitPath = $env:DLPX_TOOLKIT_PATH
$oraInstName = $env:ORACLE_INST
$oraUser = $env:ORACLE_USER
$oraPwd = $env:ORACLE_PASSWD
$oraUnq = $env:ORA_UNQ_NAME
$oraDBName = $env:ORA_DB_NAME
$virtMnt = $env:VDB_MNT_PATH
$oraSrc = $env:ORA_SRC
$scriptDir = "${delphixToolkitPath}\scripts"

. $scriptDir\delphixLibrary.ps1

### create new directory under VDB mount path

if(!(Test-Path $virtMnt\$oraUnq)) {
      md $virtMnt\$oraUnq
log "[Creating Directory for VDB] md $virtMnt\$oraUnq"
}
else {
log "[Already Exist Directory for VDB] $virtMnt\$oraUnq"
   }

#### copy the data from original mount to new VDB directory

cp "$virtMnt\$oraSrc\*" "$virtMnt\$oraUnq\"

log "[Copied Everything from dSource to VDB dir] cp $virtMnt\$oraSrc\* $virtMnt\$oraUnq\"

#### remove dSource directory from mount path
#### excluding newly created directory for VDB

Remove-Item $virtMnt\$oraSrc -Recurse

log "[Removed dSoure Dir] Remove-Item $virtMnt\$oraSrc -Recurse"

#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

$programName = 'vdb_change_dbname_dbid.ps1'
$delphixToolkitPath = $env:DLPX_TOOLKIT_PATH
$oraInstName = $env:ORACLE_INST
$oraUser = $env:ORACLE_USER
$oraPwd = $env:ORACLE_PASSWD
$oraUnq = $env:ORA_UNQ_NAME
$oraDBName = $env:ORA_DB_NAME
$virtMnt = $env:VDB_MNT_PATH
$oraSrc = $env:ORA_SRC
$oraStg = $env:ORA_STG
$oraBase = $env:ORACLE_BASE
$oracleHome = $env:ORACLE_HOME
$DBlogDir = ${delphixToolkitPath}+"\logs\"+${oraUnq}
$deletetempfile = "$DBlogDir\${oraUnq}.dltemp"
$nid_log = "$DBlogDir\${oraUnq}_nid.log"
$scriptDir = "${delphixToolkitPath}\scripts"

. $scriptDir\delphixLibrary.ps1
. $scriptDir\oracleLibrary.ps1

log "Executing $programName"

$Env:ORACLE_BASE=$oraBase
$Env:ORACLE_SID=$oraUnq
$Env:ORACLE_HOME=$oracleHome
$initfile = "${oracleHome}\database\init${oraUnq}.ora"

log "ORACLE_BASE: $oraBase"
log "ORACLE_HOME: $oracleHome"
log "ORACLE_SID: $oraUnq"

######### VDB shutdown ######

shutdown "immediate"

######### VDB mount with pfile ######

start_mount_pfile $initfile

######### Delete temp files #########
# set powershell default encoding to UTF8
log "delete temp files...."
log "This is to avoid NID-00137: All datafiles that are not dropped should be readable"

$PSDefaultParameterValues['*:Encoding'] = 'ascii'

$sqlQuery=@"
WHENEVER SQLERROR EXIT SQL.SQLCODE
set linesize 200 heading off feedback off
col file_name format a200
select 'alter database tempfile '''||name||''' drop including datafiles;' as cmd from v`$tempfile;
exit
"@

log "[SQL Query - delete_temp_files] $sqlQuery"

$result = $sqlQuery |  . $Env:ORACLE_HOME\bin\sqlplus.exe -silent " /as sysdba"

log "[delete_temp_files] $result"

if ($LASTEXITCODE -ne 0){
echo "Sql Query failed with ORA-$LASTEXITCODE"
exit 1
}

echo $result > $deletetempfile
echo "exit" >> $deletetempfile

## remove empty lines
remove_empty_lines $deletetempfile

#### Executing delete temp files

log "Executing delete temp files script, $deletetempfile STARTED"

$dlt_temp =  . $Env:ORACLE_HOME\bin\sqlplus.exe "/ as sysdba" "@$deletetempfile"

log "[SQL- delete_temp_files] $dlt_temp"

log "Executing delete temp files script, $deletetempfile FINISHED"

######## generate new DB ID

log "Generate new DBID for, $oraUnq STARTED"

$nid_log=$nid_log.replace("\\","\")

cd $DBlogDir

nid TARGET=/ DBNAME=$oraUnq LOGFILE="${oraUnq}_nid.log"

log "Generate new DBID for, $oraUnq FINISHED"
log "NID Log, $DBlogDir\${oraUnq}_nid.log"

$nid_log = Get-Content "$DBlogDir\${oraUnq}_nid.log"

log "Content of nid log, $nid_log"

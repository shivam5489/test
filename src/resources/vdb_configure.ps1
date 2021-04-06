#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

$programName = 'vdb_configure.ps1'
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
$clearloggrpfile = "$DBlogDir\${oraUnq}.clr"
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

######### VDB Disable Flashback ######

disable_flashback

######### VDB Clear Log Group #########
# set powershell default encoding to UTF8
$PSDefaultParameterValues['*:Encoding'] = 'ascii'

$sqlQuery=@"
WHENEVER SQLERROR EXIT SQL.SQLCODE
set linesize 200 heading off feedback off
col file_name format a200
select 'alter database clear logfile group '||group#|| ';' file_name from v`$logfile;
exit
"@

log "[SQL Query - clr_log_group_sql] $sqlQuery"

$result = $sqlQuery |  . $Env:ORACLE_HOME\bin\sqlplus.exe -silent " /as sysdba"

log "[clr_log_group_sql] $result"

if ($LASTEXITCODE -ne 0){
echo "Sql Query failed with ORA-$LASTEXITCODE"
exit 1
}

echo $result > $clearloggrpfile
echo "exit" >> $clearloggrpfile

#### Executing clear log groups

log "Executing Clear log groups script, $clearloggrpfile STARTED"

$clr_log_grp =  . $Env:ORACLE_HOME\bin\sqlplus.exe "/ as sysdba" "@$clearloggrpfile"

log "[SQL - clear log group] $clr_log_grp"

log "Executing Clear log groups script, $clearloggrpfile FINISHED"

## remove empty lines
remove_empty_lines $clearloggrpfile

######### VDB open reset logs ######

db_open_resetlogs

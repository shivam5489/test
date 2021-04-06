#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

$programName = 'ds_startup_nomount.ps1'
$delphixToolkitPath = $env:DLPX_TOOLKIT_PATH
$oracleHome = $env:ORACLE_HOME
$oraInstName = $env:ORACLE_INST
$oraUser = $env:ORACLE_USER
$oraPwd = $env:ORACLE_PASSWD
$oraBase = $env:ORACLE_BASE
$oraUnq = $env:ORA_UNQ_NAME
$scriptDir = "${delphixToolkitPath}\scripts"

. $scriptDir\delphixLibrary.ps1

log "Executing $programName"

$Env:ORACLE_BASE=$oraBase
$Env:ORACLE_SID=$oraInstName
$Env:ORACLE_HOME=$oracleHome
$initfile = "$oracleHome\database\init${oraUnq}.ora"

log "ORACLE_BASE: $oraBase"
log "ORACLE_HOME: $oracleHome"
log "ORACLE_SID: $oraInstName"

log "Startup nomount database with pfile, $initfile STARTED"

$sqlQuery = @"
    WHENEVER SQLERROR EXIT SQL.SQLCODE
		set NewPage none
		set heading off
		set feedback off
		startup nomount pfile='${initfile}'
		exit
"@

log "[SQL Query - sql_start_nomount] $sqlQuery"

$result = $sqlQuery | . $Env:ORACLE_HOME\bin\sqlplus.exe " /as sysdba"

log "[start_nomount] $result"

if ($LASTEXITCODE -ne 0){
echo "Sql Query failed with ORA-$LASTEXITCODE"
exit 1
}

log "Startup nomount database with pfile, $initfile FINISHED"

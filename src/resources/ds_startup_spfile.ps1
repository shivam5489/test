#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

$programName = 'ds_startup_spfile.ps1'
$delphixToolkitPath = $env:DLPX_TOOLKIT_PATH
$oracleHome = $env:ORACLE_HOME
$oraInstName = $env:ORACLE_INST
$oraUser = $env:ORACLE_USER
$oraPwd = $env:ORACLE_PASSWD
$oraBase = $env:ORACLE_BASE
$oraUnq = $env:ORA_UNQ_NAME
$scriptDir = "${delphixToolkitPath}\scripts"

. $scriptDir\delphixLibrary.ps1
. $scriptDir\oracleLibrary.ps1

log "Executing $programName"

$Env:ORACLE_BASE=$oraBase
$Env:ORACLE_SID=$oraUnq
$Env:ORACLE_HOME=$oracleHome
$initfile = "$oracleHome\database\init${oraUnq}.ora"

log "ORACLE_BASE: $oraBase"
log "ORACLE_HOME: $oracleHome"
log "ORACLE_SID: $oraUnq"

log "Create spFile from pFile, $initfile STARTED"

$sqlQuery = @"
    WHENEVER SQLERROR EXIT SQL.SQLCODE
		set NewPage none
		set heading off
		set feedback off
		create spfile from pfile='$initfile';
		exit
"@

log "[SQL Query - create_spfile_from_pfile] $sqlQuery"

$result = $sqlQuery | . $Env:ORACLE_HOME\bin\sqlplus.exe " /as sysdba"

log "[create_spfile_from_pfile] $result"

log "Create spFile from pFile, $initfile FINISHED"

shutdown "immediate"

startup_mount

get_db_status

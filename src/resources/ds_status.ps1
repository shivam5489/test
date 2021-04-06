#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

$programName = 'ds_status.ps1'
$delphixToolkitPath = $env:DLPX_TOOLKIT_PATH
$oracleHome = $env:ORACLE_HOME
$oraInstName = $env:ORACLE_INST
$oraUser = $env:ORACLE_USER
$oraPwd = $env:ORACLE_PASSWD
$oraBase = $env:ORACLE_BASE
$oraBkpLoc = $env:ORACLE_BKP_LOC
$stgMnt = $env:STG_MNT_PATH
$oraDbid = $env:ORACLE_DBID
$oraSrc = $env:ORA_SRC
$oraUnq = $env:ORA_UNQ_NAME

$scriptDir = "${delphixToolkitPath}\scripts"

. $scriptDir\delphixLibrary.ps1

log "Executing $programName"

$Env:ORACLE_BASE=$oraBase
$Env:ORACLE_SID=$oraUnq
$Env:ORACLE_HOME=$oracleHome

log "ORACLE_BASE: $oraBase"
log "ORACLE_HOME: $oracleHome"
log "ORACLE_SID: $oraUnq"

######### dSource Status ######

log "Status dSource, $oraUnq STARTED"

$sqlQuery=@"
WHENEVER SQLERROR EXIT SQL.SQLCODE
set serveroutput off
set feedback off
set heading off
set echo off
select open_mode from v`$database;
exit
"@

log "[SQL Query - ds_status] $sqlQuery"

$result = $sqlQuery |  . $Env:ORACLE_HOME\bin\sqlplus.exe -silent " /as sysdba"

log "[SQL - ds_status] $result"

if (($result -eq "READ WRITE") -or ($result -eq "MOUNTED")){
  echo "ACTIVE"
}
else {
   echo "INACTIVE"
}

log "Status dSource, $oraUnq FINISHED"

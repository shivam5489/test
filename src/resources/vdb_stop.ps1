#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

$programName = 'vdb_stop.ps1'
$delphixToolkitPath = $env:DLPX_TOOLKIT_PATH
$oraInstName = $env:ORACLE_INST
$oraUser = $env:ORACLE_USER
$oraPwd = $env:ORACLE_PASSWD
$oraUnq = $env:ORA_UNQ_NAME
$oraDBName = $env:ORA_DB_NAME
$oraBase = $env:ORACLE_BASE
$oracleHome = $env:ORACLE_HOME

$scriptDir = "${delphixToolkitPath}\scripts"

. $scriptDir\delphixLibrary.ps1
. $scriptDir\oracleLibrary.ps1

log "Executing $programName"

$Env:ORACLE_BASE=$oraBase
$Env:ORACLE_SID=$oraUnq
$Env:ORACLE_HOME=$oracleHome

log "ORACLE_BASE: $oraBase"
log "ORACLE_HOME: $oracleHome"
log "ORACLE_SID: $oraUnq"

######### VDB shutdown ######

log "Stop VDB, $oraUnq STARTED"

stop_OraService $oraUnq "srvc,inst" "immediate"

log "Stop VDB, $oraUnq FINISHED"

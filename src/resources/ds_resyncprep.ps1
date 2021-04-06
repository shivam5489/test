#
# Copyright (c) 2020 by Delphix. All rights reserved.
#
# Author: Jatinder Luthra
# Date: 09-23-2020
###########################################################

$programName = 'ds_resyncprep.ps1'
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

$Env:ORACLE_BASE=$oraBase
$Env:ORACLE_SID=$oraUnq
$Env:ORACLE_HOME=$oracleHome

. $scriptDir\delphixLibrary.ps1
. $scriptDir\oracleLibrary.ps1

log "Executing $programName"

log "Resync Prep of $oraUnq STARTED"

$srvc_status = check_srvc_status $oraUnq

log "Status of $oraUnq Service, $srvc_status"

if ($srvc_status -eq "Running"){
    shutdown "abort"
  }

log "Resync Prep of $oraUnq FINISHED"

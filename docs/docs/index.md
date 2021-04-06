# Overview

Oracle on Windows plugin is developed to virtualize Oracle data source on Windows Server.

This plugin cover following use-cases:

1. Full (Incremental Level 0) non-multitenant database dSource creation from existing RMAN backups on disk of database in archivelog mode.
2. Full (Incremental Level 0) non-multitenant database dSource creation from existing RMAN backups on disk of database in no archivelog mode.

Ingest Oracle Database
----------------

1. Oracle database single instance offline backups using RMAN (Zero Touch Production).
2. Oracle single instance online backups using RMAN.

Prerequisites
----------------
### <a id="support matrix"></a>Support Matrix
|                         | Windows Server 2012              | Windows Server 2016              | Windows Server 2019              |
| :-------------:         | :----------:                     | :----------:                     | :----------:                     |
| Oracle 11gR1/R2         | ![Screenshot](image/check.svg)   | ![Screenshot](image/check.svg)   | ![Screenshot](image/check.svg)   |
| Oracle 12c R1/R2        | ![Screenshot](image/check.svg)   | ![Screenshot](image/check.svg)   | ![Screenshot](image/check.svg)   |
| Oracle 18c              | ![Screenshot](image/check.svg)   | ![Screenshot](image/check.svg)   | ![Screenshot](image/check.svg)   |
| Oracle 19c              | ![Screenshot](image/check.svg)   | ![Screenshot](image/check.svg)   | ![Screenshot](image/check.svg)   |

### <a id="staging requirements-plugin"></a>Staging Requirements
***O/S user with following privileges***  
1. Regular o/s user (oracle or non-oracle).   
2. Credentials of oracle user.  
3. Execute access on Oracle binaries (if using non-oracle user).  
4. Delphix Connector software is installed and running.   
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Install Delphix Connector, https://docs.delphix.com/docs/datasets/sql-server-environments-and-data-sources/managing-sql-server-environments-and-hosts/installing-the-delphix-connector-service-on-the-target-database-servers     
5. Access to source instance backup file(s) (local or SMB location) from Staging host logged as delphix o/s user.     
6. Recommended iSCSI Registry settings must be in place.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Requirements for Windows iSCSI Configuration, https://docs.delphix.com/docs/datasets/sql-server-environments-and-data-sources/sql-server-support-and-requirements/requirements-for-windows-iscsi-configuration    


### <a id="target requirements-plugin"></a>Target Requirements  
***O/S user with following privileges***  
1. Regular o/s user (oracle or non-oracle).   
2. Credentials of oracle user.  
3. Execute access on Oracle binaries (if using non-oracle user).  
4. Delphix Connector software is installed and running.   
    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Install Delphix Connector, https://docs.delphix.com/docs/datasets/sql-server-environments-and-data-sources/managing-sql-server-environments-and-hosts/installing-the-delphix-connector-service-on-the-target-database-servers    
5. Recommended iSCSI Registry settings must be in place.  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- Requirements for Windows iSCSI Configuration, https://docs.delphix.com/docs/datasets/sql-server-environments-and-data-sources/sql-server-support-and-requirements/requirements-for-windows-iscsi-configuration 

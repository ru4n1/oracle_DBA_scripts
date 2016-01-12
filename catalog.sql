set verify off
ACCEPT sysPassword CHAR PROMPT 'Enter new password for SYS: ' HIDE
ACCEPT systemPassword CHAR PROMPT 'Enter new password for SYSTEM: ' HIDE
ACCEPT sysmanPassword CHAR PROMPT 'Enter new password for SYSMAN: ' HIDE
ACCEPT dbsnmpPassword CHAR PROMPT 'Enter new password for DBSNMP: ' HIDE
host /u01/app/oracle/product/11.2.0/db_1/bin/orapwd file=/u01/app/oracle/product/11.2.0/db_1/dbs/orapwcatalog force=y
@/export/home/oracle/DBscripts/Creation_Scripts/CreateDB.sql
@/export/home/oracle/DBscripts/Creation_Scripts/CreateDBFiles.sql
@/export/home/oracle/DBscripts/Creation_Scripts/CreateDBCatalog.sql
@/export/home/oracle/DBscripts/Creation_Scripts/JServer.sql
@/export/home/oracle/DBscripts/Creation_Scripts/xdb_protocol.sql
@/export/home/oracle/DBscripts/Creation_Scripts/ordinst.sql
@/export/home/oracle/DBscripts/Creation_Scripts/interMedia.sql
@/export/home/oracle/DBscripts/Creation_Scripts/emRepository.sql
@/export/home/oracle/DBscripts/Creation_Scripts/apex.sql
@/export/home/oracle/DBscripts/Creation_Scripts/lockAccount.sql
@/export/home/oracle/DBscripts/Creation_Scripts/postDBCreation.sql

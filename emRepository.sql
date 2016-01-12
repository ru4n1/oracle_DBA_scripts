SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo off
spool /export/home/oracle/DBscripts/Creation_Scripts/emRepository.log append
@/u01/app/oracle/product/11.2.0/db_1/sysman/admin/emdrep/sql/emreposcre /u01/app/oracle/product/11.2.0/db_1 SYSMAN &&sysmanPassword TEMP ON;
WHENEVER SQLERROR CONTINUE;
spool off

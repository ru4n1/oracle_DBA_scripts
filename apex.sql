SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /export/home/oracle/DBscripts/Creation_Scripts/apex.log append
@/u01/app/oracle/product/11.2.0/db_1/apex/catapx.sql change_on_install SYSAUX SYSAUX TEMP /i/ NONE;
spool off

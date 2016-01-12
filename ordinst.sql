SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /export/home/oracle/DBscripts/Creation_Scripts/ordinst.log append
@/u01/app/oracle/product/11.2.0/db_1/ord/admin/ordinst.sql SYSAUX SYSAUX;
spool off

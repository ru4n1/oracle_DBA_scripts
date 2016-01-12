SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /export/home/oracle/DBscripts/Creation_Scripts/interMedia.log append
@/u01/app/oracle/product/11.2.0/db_1/ord/im/admin/iminst.sql;
spool off

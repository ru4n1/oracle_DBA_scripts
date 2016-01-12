SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /export/home/oracle/DBscripts/Creation_Scripts/xdb_protocol.log append
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catqm.sql change_on_install SYSAUX TEMP;
connect "SYS"/"&&sysPassword" as SYSDBA
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catxdbj.sql;
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catrul.sql;
spool off

SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /export/home/oracle/DBscripts/Creation_Scripts/JServer.log append
@/u01/app/oracle/product/11.2.0/db_1/javavm/install/initjvm.sql;
@/u01/app/oracle/product/11.2.0/db_1/xdk/admin/initxml.sql;
@/u01/app/oracle/product/11.2.0/db_1/xdk/admin/xmlja.sql;
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catjava.sql;
@/u01/app/oracle/product/11.2.0/db_1/rdbms/admin/catexf.sql;
spool off

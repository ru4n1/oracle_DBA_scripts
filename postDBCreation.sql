SET VERIFY OFF
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
spool /export/home/oracle/DBscripts/Creation_Scripts/postDBCreation.log append
select 'utl_recomp_begin: ' || to_char(sysdate, 'HH:MI:SS') from dual;
execute utl_recomp.recomp_serial();
select 'utl_recomp_end: ' || to_char(sysdate, 'HH:MI:SS') from dual;
connect "SYS"/"&&sysPassword" as SYSDBA
set echo on
create spfile='/u01/app/oracle/product/11.2.0/db_1/dbs/spfilecatalog.ora' FROM pfile='/export/home/oracle/DBscripts/Creation_Scripts/init.ora';
shutdown immediate;
connect "SYS"/"&&sysPassword" as SYSDBA
startup ;
host /u01/app/oracle/product/11.2.0/db_1/bin/emca -config dbcontrol db -silent -DB_UNIQUE_NAME catalog -PORT 1521 -EM_HOME /u01/app/oracle/product/11.2.0/db_1 -LISTENER LISTENER -SERVICE_NAME catalog.ardfield -SID catalog -ORACLE_HOME /u01/app/oracle/product/11.2.0/db_1 -HOST solaris11 -LISTENER_OH /u01/app/oracle/product/11.2.0/db_1 -LOG_FILE /export/home/oracle/DBscripts/Creation_Scripts/emConfig.log;
spool off
exit;

-------------------------------------------------
---    ***Training purposes only***
---    ***Not appropriate for production use***
---    version 1.4   last updated January 2011
-------------------------------------------------

-------------------------------------------------
---    USEFUL QUERIES FOR PERFORMANCE MONITORING 
-------------------------------------------------
connect / as sysdba
set lines 1000
set echo on
set term on
set timing on
set pagesize 30

----------------------------------------------------------------
--- ENVIRONMENT  
----------------------------------------------------------------
select * from v$sys_optimizer_env ;

select * from v$flash_recovery_area_usage ;

column component format a25
column "granule" format a7
select component, current_size, min_size, max_size, 
       user_specified_size as "User sized as", 
       '  ' || round(granule_size/(1024*1024)) || 'Mb' as "granule"
from   v$memory_dynamic_components; 
 
----------------------------------------------------------------
--- ++++  V I E W  "I N T E R E S T I N G"  S T A T S                         
----------------------------------------------------------------
column  name format a45

select * from v$sysstat 
where  lower(name) like '%pass%' 
or     lower(name) like '%sort%'
or     lower(name) like '%physical%'  
or     lower(name) like '%logical%'  
or     lower(name) like '%table%scan%'
order by class, name;

----------------------------------------------------------------
--- ++++  V I E W  "S E R V I C E "   S T A T S                         
----------------------------------------------------------------
column service_name format a20
column stat_name format a20

select * from v$service_stats
order by service_name; 


----------------------------------------------------------------
--- TOP "n" wait events
----------------------------------------------------------------  
column wait_class format a20
column event      format a30

select * from 
( select event, wait_class,TIME_WAITED, AVERAGE_WAIT, TOTAL_WAITS, TOTAL_TIMEOUTS 
  from v$system_event
  where wait_class <> 'Idle'
  order by 3 desc, 4 desc )
where rownum <= 20 ;
 

---------------------------------------------------------------
--- VIEW V$SESSION_EVENT;
--- review eevents for chosen user session             
---------------------------------------------------------------
column  event       format a25
column  wait_class  format a15
column  "User"      format a5

select b.serial#,
       b.sid, b.username as "User" ,
       --- a.sid, 
       substr(a.event,1,25) as event ,
       a.wait_class, a.TOTAL_WAITS, a.TOTAL_TIMEOUTS, 
       a.TIME_WAITED as "time wtd s/100",
       round(a.TIME_WAITED/100,1) as "s",
       a.AVERAGE_WAIT  as "Avg wait"
from v$session_event a, v$session b
where a.sid = b.sid
and   b.username = 'HR'
order by a.sid, a.event;


-----------------------------------------------------------------
--- VIEW EVENTS BY SERVICE 
-----------------------------------------------------------------
column  service_name  format a20

select service_name, event,TOTAL_WAITS, TOTAL_TIMEOUTS, TIME_WAITED, AVERAGE_WAIT  
from v$service_event
order by service_name, event;

----------------------------------------------------------------
--- HOT SQL  
----------------------------------------------------------------
column sql_text   format a30
select sql_id, 
       -- address,         -- points to handle of parent cursor
       -- hash_value,      -- of sql text 
       plan_hash_value, -- literally true
       -- is_bind_sensitive, 
       -- is_bind_aware,
       child_number, parse_calls,
       fetches, disk_reads, direct_writes, buffer_gets,
       executions, sorts, rows_processed,
       optimizer_cost ,
       substr (sql_text,1,30) as sql_text
from   v$sql
where  upper(sql_text) like '%EMPLOYEES%'
order by executions desc;

----------------------------------------------------------------
--- HOT RELATED WORKAREA(s) FOR CHOSEN SQL
--- Note: run this fairly quickly after SQL is executed
----------------------------------------------------------------
select * 
from v$sql_workarea
where hash_value = 
       ( select hash_value 
         from   v$sql
         where  upper(sql_text) like '%XXcatchy text from sqlXXX%'
         and    upper(sql_text) not like '%LIKE%'  
       );


----------------------------------------------------------------
--- HOT SESSIONS   
----------------------------------------------------------------
column program          format a20
column username         format a15
column service_name     format a15
column wait_class       format a20
column resource_consumer_group  format a15
column r_c_grp          format a15
column seconds_in_wait  format 9999999 
column "Wait s"      t  format 9999999 
column event            format a30

select  s.sid, s.username,s.program, t.stat_name, t.stat_value
from    v$sess_time_model t, v$session s
where   t.sid = s.sid
and     s.username in ('HR');

select sid, username, service_name, 
       to_char(logon_time, 'YYYYMMDD:HH24:MI:SS') as logon_time,
       resource_consumer_group  as R_C_Grp,
       substr(wait_class,1,30) as wait_class , wait_time, seconds_in_wait as "Wait s"
from v$session
where  username is not null
and    username not in ('SYS', 'SYSMAN', 'DBSNMP')
;

----------------------------------------------------------------
--- HOT TOP "N" APPLICATION-BASED SEGMENTS  
----------------------------------------------------------------
select * 
from ( select   owner, object_name, object_type, statistic_name, sum(value)
       from  v$segment_statistics
       where owner not in ('SYS', 'SYSMAN')
       group by owner, object_name, object_type, statistic_name 
       order by sum(value) desc 
     )
where rownum <= 10;

----------------------------------------------------------------
--- I/O  HOT DATABASE FILES  
----------------------------------------------------------------
select  file#, phyrds,phywrts,phyblkrd, phyblkwrt,singleblkrds, 
        readtim, writetim, singleblkrdtim,avgiotim
from v$filestat
order by 1;

----------------------------------------------------------------
--- IO   OVERALL STATISTICS   
----------------------------------------------------------------
select file_no, filetype_name, asynch_io,
       small_read_Megabytes    as sm_rd,
       large_read_Megabytes    as lge_rd,
       small_write_Megabytes   as sm_wrte,
       large_write_Megabytes   as lge_wrte,     
       --- total service time spent on calls in milli-seconds
       small_read_servicetime  as sm_rd_stime,
       large_read_servicetime  as lge_rd_stime,
       small_write_servicetime as sm_wrte_stime,
       large_write_servicetime as lge_wrte_stime,
       null 
from v$iostat_file
order by 1; 

select file#, phyrds,phywrts,phyblkrd, phyblkwrt,singleblkrds, 
       readtim, writetim, singleblkrdtim,avgiotim
from v$tempstat;

select function_name, 
       number_of_waits, 
       wait_time, -- in milliseconds
       small_read_Megabytes  as sm_rd,
       large_read_Megabytes  as lg_rd,
       small_write_Megabytes as sm_wrte,
       large_write_Megabytes as lg_wrte 
from v$iostat_function
order by 1; 

----------------------------------------------------------------
--- I/O  HOT TABLESPACES  
----------------------------------------------------------------
column    tablespace_name format a15
select    tablespace_name, sum(phyrds), sum(phywrts), sum(phyblkwrt), 
          sum(phyblkrd), sum(singleblkrds),
          sum (readtim), sum(writetim)   
from      (select (select tablespace_name 
                   from dba_data_files 
                   where file_id = file# ) as tablespace_name,
                  file#, phyrds, phywrts, phyblkwrt, phyblkrd, singleblkrds,
                  readtim, writetim       
           from   v$filestat
          )
group by tablespace_name
order by tablespace_name;

----------------------------------------------------------------
--- HOT LATCHES 
----------------------------------------------------------------
column  namespace format a20
select  namespace, gets, gethits,gethitratio, pins, pinhits, reloads
from    v$librarycache
order   by gethitratio desc; 

----------------------------------------------------------------
--- HIT RATIO available Caches 
----------------------------------------------------------------
select name, physical_reads, consistent_gets, db_block_gets,
            round( ( 1 - physical_reads/(consistent_gets + db_block_gets)  ) * 100 ) as hit_ratio
from v$buffer_pool_statistics
order by name;

----------------------------------------------------------------
--- ONLINE REDO LOG SWITCH ACTIVITY  
----------------------------------------------------------------
select sequence#, to_char(first_time, 'YYYY MM DD: HH24:MI:SS') as "Switch Time", 
       first_change#
from   v$log_history
where  first_time > sysdate - interval '7' day
order by  1;

----------------------------------------------------------------
--- ONLINE REDO LOG SWITCH ACTIVITY PER HOUR
----------------------------------------------------------------
select to_char(first_time, 'YYYY MON DD: HH24') as "per hour",  
       count(*) as "Log switches per hour"
from   v$log_history
where  first_time > sysdate - interval '7' day
group by  to_char(first_time, 'YYYY MON DD: HH24')
order by  1;

----------------------------------------------------------------
--- ORACLE FEEDBACK ON SGA LARGE POOL (very little info available)
----------------------------------------------------------------
select * 
from   v$sgastat 
where  pool = 'large pool'; 


----------------------------------------------------------------
---  system wide parsing activity v1
----------------------------------------------------------------
column name format a30
select * 
from v$sysstat a
where a.name like 'parse%'
;

----------------------------------------------------------------
---  system wide parsing activity v2
----------------------------------------------------------------
select a.*, round(sysdate - b.startup_time,2)   as "Days Old" 
from v$sysstat a, v$instance b
where a.name like 'parse%'
;

----------------------------------------------
---  current session parsing activity  
----------------------------------------------
column name     format a20
column username format a15

select a.sid, c.username, b.name, a.value,
       round (  ( sysdate - c.logon_time ) * 24)  "Hours Connected"
from v$sesstat a, v$statname b,  v$session c 
where a.sid = c.sid
and   a.statistic# = b.statistic#
and   a.value > 0
and   b.name  like 'parse%hard%' 
--and   c.username not in ('SYS', 'SYSMAN', 'DBSNMP')
order by a.value desc; 

----------------------------------------------------------------
--- ++++  C O M P L E T E D  
----------------------------------------------------------------





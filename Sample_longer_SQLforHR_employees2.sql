-------------------------------------------------
---    ***Training purposes only***
---    ***Not appropriate for production use***
-------------------------------------------------
-------------------------------------
--- HR based workload             ---
--- using employees2              ---
-------------------------------------
connect hr/hr

set linesize 300
set timing on
set echo on
set term on
set numwidth 10
set pagesize 100

column first_name        format a15
column last_name         format a15
column email             format a10
column department_name   format a18

select 1, count(*)
from  hr.employees2;

select 2, min(salary), max(salary), count(*)
from  hr.employees2;

select 3,count(*)
from  hr.employees2, hr.employees2;



select distinct 5, first_name, last_name, email, salary
from   hr.employees2 LL
where  salary in (select max(salary)
                  from   hr.employees2 L
                  where  L.department_id = LL.department_id
                  and    L.hire_date between '01-JAN-1995' and  '01-JAN-2000')
order by 2
;

select 6, department_id, count(*), min(salary), max(salary)
from   hr.employees2 LL
group  by department_id
order  by 1;

select 7, department_id, count(*), min(salary), max(salary)
from   hr.employees2  LL
group  by department_id
order  by 1;

select 8, to_char(hire_date, 'YYYY') as year_hired, count(*), min(salary), max(salary)
from   hr.employees2 LL
group  by to_char(hire_date, 'YYYY')
order  by 1;


select 9, trunc(salary/1000) * 1000  as salary_in_k , count(*), min(salary), max(salary)
from   hr.employees2 LL
group  by trunc(salary/1000) * 1000 
order  by 1;


select 10, a.first_name, a.last_name, a.email, a.salary, a.job_id, b.department_name
from   hr.employees2 a, hr.departments b
where  a.department_id = b.department_id;

select 11, a.first_name, a.last_name, a.email, a.salary, a.job_id, b.department_name
from   hr.departments b
left   outer join hr.employees2 a
on     a.department_id = b.department_id;

select 12, a.first_name, a.last_name, a.email, a.salary, a.job_id, b.department_name
from   hr.departments b
right  outer join hr.employees2 a
on     a.department_id = b.department_id;

select 13, a.first_name, a.last_name, a.email, a.salary, a.job_id, b.department_name
from   hr.departments b
full   outer join hr.employees2 a
on     a.department_id = b.department_id
order by 1 ;

select distinct 13B, a.first_name, a.last_name, a.email, a.salary, a.job_id, b.department_name
from   hr.departments b
full   outer join hr.employees2 a
on     a.department_id = b.department_id
order by 1 ;

select 14, a.first_name, a.last_name, a.email, a.salary, a.job_id, b.department_name, c.postal_code
from   hr.employees2 a, hr.departments b, locations c
where  a.department_id = b.department_id
and    b.location_id   = c.location_id ;

select 15, a.first_name, a.last_name, a.email, a.salary, a.job_id, b.department_name, 
       c.postal_code, d.country_name
from   hr.employees2 a, hr.departments b, locations c, countries d
where  a.department_id = b.department_id
and    b.location_id   = c.location_id 
and    c.country_id    = d.country_id;

select 16, a.first_name, a.last_name, a.email, a.salary, a.job_id, b.department_name, 
       c.postal_code, d.country_name
from   hr.employees2 a  
inner join hr.departments b 
on  a.department_id = b.department_id
inner join    hr.locations c 
on    b.location_id   = c.location_id 
inner join    hr.countries d
on   c.country_id    = d.country_id;

select 17, first_name, last_name, email, salary
from   hr.employees2 LL
where  salary in (select max(salary)
                  from   hr.employees2 L
                  where  L.department_id = LL.department_id
                  and    L.hire_date > '01-JAN-2000')
;

select 18,first_name, last_name, salary, email from hr.employees2
union
select 18,first_name, last_name, salary, email from hr.employees2
union
select 18,first_name, last_name, salary, email from hr.employees2
union
select 18,first_name, last_name, salary, email from hr.employees2
;


select 19,first_name, last_name, salary, email from hr.employees2
union  all
select 19,first_name, last_name, salary, email from hr.employees2
union  all
select 19,first_name, last_name, salary, email from hr.employees2
union  all
select 19,first_name, last_name, salary, email from hr.employees2
order by 4 ;

select 20,first_name, last_name, salary, email from hr.employees2  
intersect
select 20,first_name, last_name, salary, email from hr.employees2
intersect
select 20,first_name, last_name, salary, email from hr.employees2
intersect
select 20,first_name, last_name, salary, email from hr.employees2
order by 4 ;

select 21,count(*) from hr.employees2 
where salary = 2500;

select 22,count(*) from hr.employees2 
where salary + 1 = 2600;

update hr.employees2 set salary = salary +23;

update hr.employees2 set salary = salary +24
where salary = 2500;

update hr.employees2 set salary = salary +25
where salary + 15 = 2500;

update hr.employees2 set salary = salary + 26
where salary < (select avg(salary) from hr.employees2) ;

update hr.employees2 a set salary = salary + 27
where salary < (select avg(salary) 
                from hr.employees2 b 
                where a.department_id = b.department_id) ;

select 4,count(*), sum (a.salary)
from  hr.employees2 a, hr.employees2 ;

prompt -------------------------------------
prompt ---    ++++ C O M P L E T E D  
prompt -------------------------------------





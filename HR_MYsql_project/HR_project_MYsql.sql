create database HR;
use HR;
select * from hr ;
alter table hr
change column ï»؟id emp_id varchar (20) not null ;
describe hr ;

select birthdate from hr ;


set sql_safe_updates=0;

update hr set 
 birthdate =case 
	when birthdate like '%/%' then date_format(str_to_date(birthdate , '%m/%d/%Y'),'%Y-%m-%d')
	when birthdate like '%-%' then date_format(str_to_date(birthdate , '%m-%d-%Y'),'%Y-%m-%d')
	else null
end;
select birthdate from hr ;

alter table hr
Modify column birthdate date ;

update hr set 
 hire_date =case 
	when hire_date like '%/%' then date_format(str_to_date(hire_date , '%m/%d/%Y'),'%Y-%m-%d')
	when hire_date like '%-%' then date_format(str_to_date(hire_date , '%m-%d-%Y'),'%Y-%m-%d')
	else null
end;

alter table hr 
modify column hire_date date
;

update hr 
set termdate= date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null	and termdate != ''
;

UPDATE hr
SET termdate = NULL
WHERE termdate = '';


alter table hr 
modify column termdate date
;

select termdate from hr ;

alter table hr
add column age int  ;

set sql_safe_updates =0;

UPDATE hr 
SET age = TIMESTAMPDIFF(YEAR, birthdate, CURDATE())
WHERE birthdate IS NOT NULL 
  AND birthdate <= CURDATE()
  AND birthdate <= DATE_SUB(CURDATE(), INTERVAL 15 YEAR);
 

select * from hr ;

DELETE FROM hr 
WHERE birthdate >= CURDATE();


UPDATE hr 
SET birthdate = NULL
WHERE birthdate >= CURDATE();

select  min(age) as Youngest,
		max(age) As oldest
from hr ;

SELECT * FROM hr ;

-- what is the gender breakdowen of employees in the company ?
select gender ,count(*) as count
 from hr
 where termdate is null
 group by gender;

-- what is the race / ethnicity breakdowen of employees in the company?
select race ,count(*) as count 
from hr
where termdate is null 
group by race 
order by count(*) desc ;

-- what is the age distribution of employees in the company ?

select count(*) as count,
case
	when age >= 20 and age <=30 then '20-30'
    when age >= 31 and age <=40 then '31-40'
    when age >= 41 and age <=50 then '41-50'
	else '51+'
end as Age_Group
from hr
where termdate is null
group by Age_Group
order by count(*) desc;

-- how many employees work at headquarters versus remote locations?
select location,count(*) as count 
from hr
where termdate is null
group by location
order by count(*) desc;

-- List the length of employment in years and the full name of employees who have been terminated

select timestampdiff(year,hire_date,termdate), concat(first_name,' ',last_name) as full_name
from hr 
where termdate is not null
;

-- How does the gender distribution vary across department and job titles?
select  count(*) as count ,gender,department,jobtitle
from hr 
where termdate is null
group by gender,department,jobtitle
ORDER BY count(*) desc;
;

-- Top 15 Job Titles Distribution (Current Employees)
select jobtitle,count(*) as count 
from hr 
where termdate is null
group by jobtitle
order by count(*) desc
limit 15;

-- which department has the highest turnover rate ?
select department ,  count(termdate)
from hr 
where termdate is not null
group by department 
;

-- What percentage of current employees have stayed for more than 3 years?

SELECT 
  COUNT(*) AS total_current_employees,
  SUM(CASE WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) > 3 THEN 1 ELSE 0 END) AS stayed_more_than_3_years,
  ROUND(
    SUM(CASE WHEN TIMESTAMPDIFF(YEAR, hire_date, CURDATE()) > 3 THEN 1 ELSE 0 END) / COUNT(*) * 100, 2
  ) AS percentage
FROM hr
WHERE termdate IS  NULL;


-- What is the average tenure (length of employment) in each department?
SELECT 
  department,
  ROUND(AVG(TIMESTAMPDIFF(YEAR, hire_date, termdate)), 2) AS avg_tenure_years
FROM hr
WHERE termdate IS NOT NULL
GROUP BY department
ORDER BY avg_tenure_years DESC;



-- How many employees were hired each year?
SELECT 
  YEAR(hire_date) AS hire_year,
  COUNT(*) AS hires
FROM hr
GROUP BY hire_year
ORDER BY hire_year;


-- What is the turnover rate by gender ?

SELECT 
  gender,
  SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) as terminated_employees,
  COUNT(*) AS total,
  ROUND(SUM(CASE WHEN termdate IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS turnover_rate
FROM hr
GROUP BY gender;

-- What is the age group distribution by department?

SELECT 
  department,
  CASE
    WHEN age BETWEEN 20 AND 30 THEN '20-30'
    WHEN age BETWEEN 31 AND 40 THEN '31-40'
    WHEN age BETWEEN 41 AND 50 THEN '41-50'
    ELSE '51+'
  END AS age_group,
  COUNT(*) AS count
FROM hr
WHERE termdate IS NULL
GROUP BY department, age_group
;

-- What is the race distribution in each department

select count(*) as count ,race,department
from hr
where termdate is null
group by race,department ;


-- Calculate the number of terminated employees grouped by gender
select  gender ,
		sum(case when  termdate is not null then 1 else 0 end ) AS terminated_count
from hr 
group by gender;


-- Average Time Between Hire and Termination per Department
select  department , 
		round(avg(timestampdiff(month,hire_date,termdate)), 2) AS avg_employment_months
from hr
WHERE termdate IS NOT NULL
group by department;

	
	









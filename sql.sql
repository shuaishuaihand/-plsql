/*1.  Show all data of the clerks who have been hired after the year 1997.*/
select * from employees where to_char(HIRE_DATE,'yyyy')>='1997'
/*2.	Show the last name,  job, salary, and commission of those employees who earn commission. Sort the data by the salary in descending order.*/
select LAST_NAME,JOB_ID,SALARY,COMMISSION_PCT
from employees
where COMMISSION_PCT is not NULL
order by SALARY  desc
/*3. Show the employees that have no commission with a 10% raise in their salary (round off thesalaries).*/
select 'The salary of '|| LAST_NAME ||' after a 10% raise is '||SALARY*(1+0.1)  AS "New salary"
from employees
where COMMISSION_PCT is NULL
/* 4.	Show the last names of all employees together with the number of years and the number ofcompleted months that they have been employed.*/
select LAST_NAME, trunc(round(months_between(sysdate,HIRE_DATE))/12) as "YEARS" ,round(months_between(sysdate,HIRE_DATE))-trunc(round(months_between(sysdate,HIRE_DATE))/12)*12 as "MONTHS"/* round(months_between(sysdate,HIRE_DATE))共有多少个月*/
from employees                                                                                                                                                                             /* trunc(round(months_between(sysdate,HIRE_DATE))/12)年数取整*/
/*5.	Show those employees that have a name starting with J, K, L, or M.*/
select LAST_NAME 
from employees
where LAST_NAME like 'J%' or LAST_NAME like 'K%' or LAST_NAME like 'L%' or  LAST_NAME like 'M%'
/* 6.	Show all employees, and indicate with “Yes” or “No” whether they receive a commission.*/
select LAST_NAME,SALARY,NVL2(COMMISSION_PCT,'YES','NO')
from employees
/* 7. Show the department names, locations, names, job titles, and salaries of employees who workin location 1800.*/
select DEPARTMENT_NAME,LOCATION_ID,LAST_NAME,JOB_ID,SALARY
from employees,departments
where employees.department_id=departments.department_id and LOCATION_ID=1800
/*8. How many employees have a name that ends with an n? Create two possible solutions. */
select count(*)
from employees
where LAST_NAME like '%n'
/*9. Show the names and locations for all departments, and the number of employees working in each department. Make sure that departments without employees are included as well. */
select D.DEPARTMENT_ID,D.DEPARTMENT_NAME,D.LOCATION_ID,COUNT(E.EMPLOYEE_ID)
from departments D left outer join employees E on E.DEPARTMENT_ID=D.DEPARTMENT_ID
group by D.DEPARTMENT_ID,D.DEPARTMENT_NAME,D.LOCATION_ID
/* 10. Which jobs are found in departments 10 and 20*/
select JOB_ID 
from employees
where DEPARTMENT_ID in (10,20)
/* 11. Which jobs are found in the Administration and Executive departments, and how manyemployees do these jobs? Show the job with the highest frequency first. */
select JOB_ID,count(*) as "FREQUENCY"
from employees
where JOB_ID like 'AD%'
group by JOB_ID
order by JOB_ID desc
/* 12. Show all employees who were hired in the first half of the month (before the 16th of the month).*/
select LAST_NAME,HIRE_DATE
from employees
where to_char(HIRE_DATE,'dd')<'16'
/* 13. Show the names, salaries, and the number of dollars (in thousands) that all employees earn.*/
select LAST_NAME,SALARY,trunc(SALARY/1000) as "THOUSANDS"
from employees
/* 14.	Show all employees who have managers with a salary higher than $15,000. Show thefollowing data: employee name, manager name, manager salary, and salary grade of the manager.*/
select x.LAST_NAME,y.LAST_NAME,y.salary,g.grade_level
from employees x,employees y,job_grades g
where x.manager_id=y.employee_id and y.salary>15000 and (y.salary between g.lowset_sal and g.highest_sal)
/*?15.	Show the department number, name, number of employees, and average salary of all departments, together with the names, salaries, and jobs of the employees working in each department. */
select d.department_id, d.department_name,count(e.employee_id),AVG(e.salary),e.last_name,e.salary,e.job_id
from employees e left outer join departments d on e.department_id=d.department_id 
group by d.department_id,d.department_name,e.last_name,e.salary,e.job_id
/*16.	Show the department number and the lowest salary of the department with the highest average 	salary. */
select department_id,min(salary)
from employees 
group by department_id
having department_id in (
      select department_id
      from employees
      group by department_id
      having MAX(salary)>=(
           select  MAX(avg(salary))
           from employees  
           group by department_id
           )
)

/* 17.Show the department numbers, names, and locations of the departments where no sales representatives work.*/
select DEPARTMENT_ID,DEPARTMENT_NAME,MANAGER_ID,LOCATION_ID
from departments
where DEPARTMENT_NAME <> 'Sales'
/* 18.	Show the department number, department name, and the number of employees working in each department that:
          a.  Includes fewer than 3 employees:
*/
select d.DEPARTMENT_ID,d.DEPARTMENT_NAME,count(*)
from departments d,employees e
where e.department_id=d.department_id 
group by d.DEPARTMENT_ID,d.DEPARTMENT_NAME
having count(*)<3
  /*? b.  Has the highest number of employees:  */
select d.DEPARTMENT_ID,d.DEPARTMENT_NAME,count(*)
from departments d,employees e
where e.department_id=d.department_id 
group by d.DEPARTMENT_ID,d.DEPARTMENT_NAME
having count(*)=(
       select max(count(*))
       from employees
       group by department_id   
)
 /*? c.  Has the lowest  number of employees: */
select d.DEPARTMENT_ID,d.DEPARTMENT_NAME,count(*)
from departments d,employees e
where e.department_id=d.department_id 
group by d.DEPARTMENT_ID,d.DEPARTMENT_NAME
having count(*)=(
       select min(count(*))
       from employees
       group by department_id   
)

/*19.	Show the employee number, last name, salary, department number, and the average salary in their department for all employees. */
         /* 写法一：左外连接*/
          select x.EMPLOYEE_ID,x.LAST_NAME,y.department_id, avg(y.salary)
          from employees x left outer join employees y on (x.department_id=y.department_id)
          where y.department_id is not NULL
          group by y.department_id, x.EMPLOYEE_ID,x.LAST_NAME
          order by x.employee_id
          
          /* 写法二*/
          select x.EMPLOYEE_ID,x.LAST_NAME,y.department_id, avg(y.salary)
          from employees x,  employees y 
          where x.department_id=y.department_id 
          group by x.EMPLOYEE_ID,x.LAST_NAME,y.department_id
          order by x.employee_id
                    
/* 20.	Show all employees who were hired on the day of the week on which the highest number of employees were hired.*/
 select LAST_NAME,to_char(HIRE_DATE,'DAY')
 from employees 
 where to_char(HIRE_DATE,'DAY')in( 
   select to_char(HIRE_DATE,'DAY')
   from employees
   group by to_char(HIRE_DATE,'DAY')
   having count(to_char(HIRE_DATE,'D')) in(
       select max(count(to_char(HIRE_DATE,'day')))
       from employees
       group by to_char(HIRE_DATE,'day')
   )
   )
/* 21.	Create an anniversary overview based on the hire date of the employees. Sort the anniversaries in ascending order.*/
select LAST_NAME,to_char(HIRE_DATE,'mm/dd')
from employees
order by to_char(HIRE_DATE,'mm/dd') 
/*22. Find the job that was filled in the first half of 1990 and the same job that was filled during the 		same period in 1991. */
select distinct JOB_ID
from employees
where  to_char(HIRE_DATE,'YYYY')=1990 and to_char(HIRE_DATE,'mm')<7 or  to_char(HIRE_DATE,'YYYY')=1991 
/* 23. Write a compound query to produce a list of employees showing raise percentages, employee 	
	     IDs, and old salary and new salary increase. Employees in departments 10, 50, and 110 are 
		   given a 5% raise, employees in department 60 are given a 10% raise, employees in 	
    	 departments 20 and 80 are given a  15% raise, and employees in department 90 are not given a raise.	*/
       
/* 24. 	Alter the session to set the NLS_DATE_FORMAT to  DD-MON-YYYY HH24:MI:SS.*/
   ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MON-YYYY HH24:MI:SS';

/* 25 .	a. Write queries to display the time zone offsets (TZ_OFFSET) for the following time zones.Australia/Sydney */
       SELECT TZ_OFFSET ('Australia/Sydney') from dual; 
   /*Chile/Easter Island  */
       SELECT TZ_OFFSET ('Chile/EasterIsland') from dual;
   /* b. Alter the session to set the TIME_ZONE parameter value to the time zone offset of 				Australia/Sydney.*/ 
       ALTER SESSION SET TIME_ZONE = '+10:00';
   /* c. Display the SYSDATE, CURRENT_DATE, CURRENT_TIMESTAMP, and 
   			LOCALTIMESTAMP for this session. */
       SELECT SYSDATE,CURRENT_DATE, CURRENT_TIMESTAMP, LOCALTIMESTAMP
       FROM DUAL; 
   

/*26. 	Write a query to display the last names, month of the date of join, and hire date of those  
             employees who have joined in the month of January, irrespective of the year of join.*/

select LAST_NAME,to_char(HIRE_DATE,'mm'),HIRE_DATE
from employees
where to_char(HIRE_DATE,'mm')=1

/*27. 	Write a query to display the following for those departments whose department ID is greater          	than 80:
The total salary for every job within a department 
The total salary  
The total salary for those cities in which the departments are located
The total salary for every job, irrespective of the department 
The total salary for every department irrespective of the city
The total salary of the cities in which the departments are located
Total salary for the departments, irrespective of  job titles and cities  */

/* 29. Write a query to display the top three earners in the EMPLOYEES table. Display their last 	names and salaries.*/
select LAST_NAME,salary
from employees
where rownum<4
order by salary desc
/*30. Write a query to display the employee ID and last names of the employees who work in the 	state of California. 
	Hint: Use scalar subqueries.  */
select EMPLOYEE_ID,LAST_NAME
from employees,departments,locations
where employees.department_id=departments.department_id and departments.location_id=locations.location_id
and locations.state_province='California'
order by EMPLOYEE_ID

/*31. Write a query to delete the oldest JOB_HISTORY row of 
 an employee by looking up the 	JOB_HISTORY table for the 
 MIN(START_DATE) for the employee.Delete the records of 
 only those employees who have changed at least two jobs. 
 If your query executes correctly, 	you will get the feedback:	
	Hint: Use a correlated DELETE command. */
  DELETE FROM job_history J
  WHERE employee_id =
	   (SELECT employee_id 
	    FROM employees E
	    WHERE JH.employee_id = E.employee_id
         AND START_DATE = (SELECT MIN(start_date)  
	          FROM job_history J
	 	  WHERE JH.employee_id = E.employee_id)
	 AND 3 >  (SELECT COUNT(*)  
	          FROM job_history J
	 	  WHERE J.employee_id = E.employee_id
		  GROUP BY EMPLOYEE_ID
		  HAVING COUNT(*) >= 2));
  /*32.  Roll back the transaction. */
  
 /* 33. Write a query to display the job IDs of those jobs whose maximum salary is above half the
	maximum salary in the whole company. Use the WITH clause to write this query. Name the 	
  query MAX_SAL_CALC.*/
  WITH 
  MAX_SAL_CALC AS (
   SELECT job_title, MAX(salary) AS job_total
   FROM employees, jobs
   WHERE employees.job_id = jobs.job_id
   GROUP BY job_title)
   SELECT job_title, job_total
   FROM MAX_SAL_CALC
   WHERE job_total > (
                    SELECT MAX(job_total) * 1/2
                    FROM MAX_SAL_CALC)
  ORDER BY job_total DESC;
 
/* 34.	Write a SQL statement to display employee number, last name, start date, and salary, 		showing:
  		a. De Haan’s direct reports */
     SELECT employee_id, last_name, hire_date, salary
     FROM   employees
     WHERE  manager_id = (
           SELECT employee_id
           FROM   employees
	         WHERE last_name = 'De Haan'); 
     /* b. The organization tree under De Haan (employee number 102)*/
      SELECT employee_id, last_name, hire_date, salary
      FROM   employees
      WHERE  employee_id != 102
      CONNECT BY manager_id = PRIOR employee_id
      START WITH employee_id = 102;
 
/* 	35. 	Write a hierarchical query to display the employee number, 
    manager number, and employee  		last name for all employees who are two 
    levels below employee De Haan (employee 		number 102). Also display the
    level of the employee.*/
    SELECT employee_id, manager_id, level, last_name
    FROM   employees
    WHERE LEVEL = 3
    CONNECT BY manager_id = PRIOR employee_id
    START WITH employee_id= 102; 
    
 /* 36.		Produce a hierarchical report to display the employee number, manager number, the LEVEL 			pseudocolumn, and employee last name. For every row in the EMPLOYEES table, you 			should print a tree structure showing the employee, the employee’s manager, then the 			manager’s manager, and so on. Use indentations for the NAME column.*/  
    COLUMN name FORMAT A25
    SELECT  employee_id, manager_id, LEVEL,
    LPAD(last_name, LENGTH(last_name)+(LEVEL*2)-2,'_')  LAST_NAME        
    FROM    employees
    CONNECT BY employee_id = PRIOR manager_id;
    COLUMN name CLEAR

 
 /*37.Write a query to do the following:  */ 
     /*Retrieve the details of the employee ID, hire date, salary, and manager ID of those employees whose employee ID is more than or equal to 200 from the EMPLOYEES table. */
    select EMPLOYEE_ID,HIRE_DATE,employees.SALARY,departments.MANAGER_ID
    from employees,departments
    where employees.department_id=departments.department_id and EMPLOYEE_ID>=200
     
     /*If the salary is less than $5,000, insert the details of employee ID and salary into the SPECIAL_SAL table. */
          /* 复制,创建SPECIAL_SAL表，没数据*/
    create table  SPECIAL_SAL as select EMPLOYEE_ID,SALARY from employees where 1=2
          /*向SPECIAL_SAL表中插入所需的数据 */
    insert into SPECIAL_SAL(EMPLOYEE_ID,SALARY)
    select EMPLOYEE_ID,SALARY
    from employees
    where SALARY<5000
    commit
    /* Insert the details of employee ID, hire date, and salary into the SAL_HISTORY table. */
          /* 复制,创建SAL_HISTORY表，没数据*/
     create table  SAL_HISTORY as select EMPLOYEE_ID,HIRE_DATE,SALARY from employees where 1=2     
           /*向SAL_HISTORY表中插入所需的数据 */
     insert into SAL_HISTORY(EMPLOYEE_ID,HIRE_DATE,SALARY)
     select EMPLOYEE_ID,HIRE_DATE,SALARY
     from employees
     commit
     /*Insert the details of employee ID, manager ID, and salary into the MGR_HISTORY table. */
              /* 复制,创建MGR_HISTORY表，没数据*/
     create table  MGR_HISTORY as select EMPLOYEE_ID,MANAGER_ID,SALARY from employees where 1=2          
              /*向MGR_HISTORY表中插入所需的数据 */
     insert into MGR_HISTORY(EMPLOYEE_ID,MANAGER_ID,SALARY)
     select EMPLOYEE_ID,MANAGER_ID,SALARY
     from employees
     commit        
              
 /* 38. Query the SPECIAL_SAL, SAL_HISTORY and the MGR_HISTORY tables to view the inserted records.*/
       /*第(1)题 */
      select EMPLOYEE_ID,SALARY
      from SPECIAL_SAL
      where  EMPLOYEE_ID=200
        /*第(2)题 */
      select EMPLOYEE_ID,HIRE_DATE,SALARY
      from SAL_HISTORY
      where  EMPLOYEE_ID>200
       /*第(3)题 */
      select EMPLOYEE_ID,MANAGER_ID,SALARY
      from MGR_HISTORY
      where  EMPLOYEE_ID>200
      
/*39. Create the LOCATIONS_NAMED_INDEX table based on the following table instance chart. 
		Name the index for the PRIMARY KEY column as LOCATIONS_PK_IDX. */
  select * from LOCATIONS_NAMED_INDEX

/* 40. 	Query the USER_INDEXES table to display the INDEX_NAME for the 			LOCATIONS_NAMED_INDEX table. */
    select INDEX_NAME ,TABLE_NAME from user_indexes where table_name='LOCATIONS_NAMED_INDEX' 

 
 





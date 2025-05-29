SELECT job_posted_date
FROM job_postings_fact
LIMIT 10;


SELECT 
        '2023-02-19'::DATE,
        '123'::INTEGER,
        'true'::BOOLEAN,
        '3.14'::REAL;


SELECT 
    job_title_short AS title,
    job_location AS location,
    job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'EST'AS date_time, 
    EXTRACT(MONTH FROM job_posted_date) AS date_month,
    EXTRACT(YEAR FROM job_posted_date) AS date_year
FROM
    job_postings_fact
LIMIT 5;    

SELECT
      COUNT(job_id) AS job_posted_count,
      EXTRACT(MONTH FROM job_posted_date) AS month 
FROM
      job_postings_fact
WHERE
     job_title_short = 'Data Analyst'      
GROUP BY  
   month
ORDER BY
       job_posted_count DESC;

SELECT           
      job_schedule_type,
      AVG(salary_year_avg) AS avg_yearly_salary,
      AVG(salary_hour_avg) AS avg_hourly_salary
FROM
    job_postings_fact
WHERE
    job_posted_date > '2023-06-01'
GROUP BY
    job_schedule_type;     
/* practice_question_1 
write a query to find the average salary both yearlyb and hourly for job postings
that were posted after june 1,2023. group the result by job schdule type*/

SELECT
    EXTRACT(MONTH FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_york') AS month,
    COUNT(*) AS job_count 
FROM
    job_postings_fact
WHERE
     EXTRACT(YEAR FROM job_posted_date AT TIME ZONE 'UTC' AT TIME ZONE 'America/New_york') = 2023        
GROUP BY
     month 
ORDER BY  
    month            
/* practice_question_2
write a query to count the no of job postings for each month in 2023
,adjusting the job_posted_date to be 'America/New_York' time zone befor extracting(hint) the month
Assume the job_posted_date is stored in UTC. Group by and order by the month */

SELECT 
  companies.name AS company 
FROM
   job_postings_fact AS job_postings
JOIN company_dim AS companies   
   ON job_postings.company_id=companies.company_id
WHERE
        job_postings.job_health_insurance = TRUE 
        AND EXTRACT(QUARTER FROM job_postings.job_posted_date) = 2
        AND EXTRACT(YEAR FROM job_postings.job_posted_date )= 2023;       
      

/* write a query to find companies(including company name) that have posted jobs offering health insurance,
where these postings were made in the second quarter of2023. use data extraction to filter by quater*/




    
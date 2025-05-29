CREATE TABLE january_jobs AS
    SELECT*
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 1;

CREATE TABLE febuary_jobs AS
    SELECT*
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 2;

 CREATE TABLE march_jobs AS
    SELECT*
    FROM job_postings_fact
    WHERE EXTRACT(MONTH FROM job_posted_date) = 3;   

SELECT job_posted_date
FROM march_jobs;

/*CASE EXPRESSION*/

SELECT
    COUNT(job_id) AS number_of_jobs,
    CASE
        WHEN job_location = 'Anywhere' THEN 'REMOTE'
        WHEN job_location = 'New York, NY' THEN 'LOCAL'
        ELSE 'ONSITE'
    END AS location_category
FROM
    job_postings_fact
WHERE   
    job_title_short = 'Data Analyst'  
GROUP BY
    location_category    
ORDER BY
    location_category DESC;    

/*
Label new column as follows:
- 'Anywhere' jobs as 'Remote'
- 'New York, NY' jobs as 'Local'
- Otherwis 'Onsite'
*/


SELECT
    job_title_short,
    salary_year_avg,
    CASE
        WHEN salary_year_avg > 100000 THEN 'High'
        WHEN salary_year_avg >= 60000 THEN 'Standard'
        ELSE 'Low'
    END AS salary_category
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC;

/* Question:
"I want to categorize the salaries from each job posting. 
To see if it fits in my desired salary range.
Put salary into different buckets
Define what’s a high, standard, or low salary with our own conditions
Why? 
It is easy to determine which job postings are worth looking at based on salary. 
Bucketing is a common practice in data analysis when viewing categories
Only want to look at data analyst roles
Order from highest to lowest"   
*/
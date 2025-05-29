SELECT*
   FROM(--SubQuery starts here
       SELECT*
       FROM job_postings_fact
       WHERE EXTRACT(MONTH FROM job_posted_date) = 1
       )AS january_jobs;
       -- SubQuery ends here


/*Common Table Expression(CTEs): define a temporary result set that you can reference
  can reference within a SELECT, INSERT , UPDATE , or DELETE statement
  Defined with WITH*/  

WITH january_jobs AS (--CTE definition starts here
                     SELECT*
                     FROM job_postings_fact
                     WHERE EXTRACT(MONTH FROM job_posted_date) = 1
       )--CTE definition ends here

       SELECT*
       FROM january_jobs;

/*SUBQUERY*/


  SELECT 
  company_id,
  name AS company_name 
  FROM  company_dim
  WHERE company_id IN (
        SELECT
              company_id
        FROM
              job_postings_fact
        WHERE
              job_no_degree_mention = true
        ORDER BY
              company_id
  )   

/*
Find the companies that have the most job openings.
-Get the total number of job posting per company_id(job_postings_fact)
-Return the total number of jobs with the company name(company_dim)
*/

WITH company_job_count AS (
SELECT
        company_id,
         COUNT(*) AS total_jobs
FROM
       job_postings_fact
GROUP BY
         company_id
)
SELECT 
company_dim.name AS company_name,
company_job_count.total_jobs
FROM company_dim
LEFT JOIN company_job_count ON company_job_count.company_id = company_dim.company_id
ORDER BY  total_jobs DESC


/*Practical Question 1
identify the top 5 skills that are most frequently mentioned in job postings.
Use a subquery to find the skill IDs with the highest
counts in the  skills_job_dim table and 
then join this result with the skills_dim table to get the skill names.
*/

WITH skill_counts AS (  
  SELECT
       skill_id,
       COUNT(*) AS skill_count
       FROM 
       skills_job_dim
       GROUP BY
       skill_id
       ORDER BY
       skill_count DESC
       LIMIT 5
       )
SELECT
      skills_dim.skills,
      skill_counts.skill_count 
FROM      
     skill_counts   
INNER JOIN
skills_dim
ON
skill_counts.skill_id = skills_dim.skill_id
ORDER BY
skill_counts.skill_count DESC;  

/*Practice Problem 2
Question: 
Determine the size category ('Small', 'Medium', or 'Large') for each company by first identifying the number of job postings they have. 
A company is 
'Small' if it has less than 10 job postings, 
'Medium' if the number of job postings is between 10 and 50, and 
'Large' if it has more than 50 job postings.
i(chotu) made  asmall change here, by adding company name also.
*/

WITH job_counts AS (
    SELECT 
        company_id,
        COUNT(*) as job_count
    FROM 
        job_postings_fact
    GROUP BY 
        company_id
)
SELECT 
    job_counts.company_id,
    company_dim.name,
    job_counts.job_count,
    CASE 
        WHEN job_counts.job_count < 10 THEN 'Small'
        WHEN job_counts.job_count >= 10 AND job_count <= 50 THEN 'Medium'
        WHEN job_counts.job_count > 50 THEN 'Large'
    END as company_size
FROM 
    job_counts
LEFT JOIN
      company_dim
      ON
      job_counts.company_id = company_dim.company_id    
ORDER BY 
    job_count DESC;

/*Question 7: 
Find the count of the number of remote job postings per skill. 
Display the top 5 skills by their demand in remote jobs. 
Include skill ID, name, and count of postings requiring the skill.
*/

WITH remote_skill_counts AS (
    SELECT 
        skills_job_dim.skill_id,
        COUNT(*) as remote_job_count
    FROM 
        job_postings_fact
    INNER JOIN 
        skills_job_dim
    ON 
        job_postings_fact.job_id = skills_job_dim.job_id
    WHERE 
        job_postings_fact.job_work_from_home = TRUE AND
        job_postings_fact.job_title =  'Advanced Data Analyst'
    GROUP BY 
        skills_job_dim.skill_id
    ORDER BY 
        remote_job_count DESC
    LIMIT 15
)
SELECT 
    remote_skill_counts.skill_id,
    skills_dim.skills,
    remote_skill_counts.remote_job_count
FROM 
    remote_skill_counts
INNER JOIN 
    skills_dim
ON 
    remote_skill_counts.skill_id = skills_dim.skill_id
ORDER BY 
    remote_skill_counts.remote_job_count DESC;

    
      





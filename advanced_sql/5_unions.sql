--Get jobs and companies from january
SELECT job_title_short,
       company_id,
       job_location
FROM january_jobs

UNION ALL -- combine another table

--Get jobs and companies from february
SELECT job_title_short,
       company_id,
       job_location
FROM febuary_jobs

UNION ALL--combine another table

--Get jobs and companies from march

SELECT job_title_short,
       company_id,
       job_location
FROM march_jobs;

/* Practice problem 1
get corresponding skill and skill type for 
each job posting in q1
include those  without any skills, too
Why?Look at the skills and the type for each
job in the first quarter that has a salary>$ 70000
*/

SELECT 
    q1_jobs_subquery.job_id,
    skills_dim.skill_id,
    skills_dim.skills,
    skills_dim.type
FROM 
    (
        SELECT 
            job_postings_fact.job_id
        FROM 
            job_postings_fact
        WHERE 
            job_postings_fact.job_posted_date >= '2023-01-01' 
            AND job_postings_fact.job_posted_date <= '2023-03-31'
            AND job_postings_fact.salary_year_avg > 70000
    ) q1_jobs_subquery
INNER JOIN 
    skills_job_dim
ON 
    q1_jobs_subquery.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim
ON 
    skills_job_dim.skill_id = skills_dim.skill_id

UNION ALL

SELECT 
    q1_jobs_subquery.job_id,
    NULL as skill_id,
    NULL as skills,
    NULL as type
FROM 
    (
        SELECT 
            job_postings_fact.job_id
        FROM 
            job_postings_fact
        WHERE 
            job_postings_fact.job_posted_date >= '2023-01-01' 
            AND job_postings_fact.job_posted_date <= '2023-03-31'
            AND job_postings_fact.salary_year_avg > 70000
    ) q1_jobs_subquery
LEFT JOIN 
    skills_job_dim
ON 
    q1_jobs_subquery.job_id = skills_job_dim.job_id
WHERE 
    skills_job_dim.job_id IS NULL

ORDER BY 
    job_id;


/* Question 8 : Get the corresponding skill and skill type for each job posting in Q1. 
Include those without any skills, too. Look at the skills and the type for each job in the first quarter that has a salary > $70,000.
*/

SELECT 
    job_postings_fact.job_id,
    skills_dim.skill_id,
    skills_dim.skills,
    skills_dim.type
FROM 
    job_postings_fact
INNER JOIN 
    skills_job_dim
ON 
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN 
    skills_dim
ON 
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE 
    job_postings_fact.job_posted_date >= '2023-01-01' 
    AND job_postings_fact.job_posted_date <= '2023-03-31'
    AND job_postings_fact.salary_year_avg > 70000

UNION ALL

SELECT 
    job_postings_fact.job_id,
    NULL as skill_id,
    NULL as skills,
    NULL as type
FROM 
    job_postings_fact
LEFT JOIN 
    skills_job_dim
ON 
    job_postings_fact.job_id = skills_job_dim.job_id
WHERE 
    job_postings_fact.job_posted_date >= '2023-01-01' 
    AND job_postings_fact.job_posted_date <= '2023-03-31'
    AND job_postings_fact.salary_year_avg > 70000
    AND skills_job_dim.job_id IS NULL

ORDER BY 
    job_id;
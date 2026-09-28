SELECT 
    job_id,
    job_title_short,
    salary_year_avg,
    company_id
FROM 
    job_postings_fact
LIMIT 10;

SELECT 
    * 
FROM 
    company_dim
WHERE 
    name in ('Facebook', 'Meta');

select *
from skills_job_dim
limit 5;

select * 
from skills_dim
limit 5;

SELECT * 
FROM information_schema.tables
WHERE table_catalog = 'data_jobs';

show schemas;
use md_information_schema;
show tables;

SELECT * 
FROM information_schema.tables;

SELECT * 
FROM information_schema.columns
where table_catalog = 'data_jobs';
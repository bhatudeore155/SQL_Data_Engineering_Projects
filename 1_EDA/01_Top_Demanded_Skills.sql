/* What are the most in-demanded skills in the job
 market? Let's find out by analyzing the job 
 postings data. We'll extract the skills mentioned 
 in the job descriptions and count their occurrences 
 to identify the top demanded skills. 
 focus on remote job postings 
 */

SELECT 
    sd.skills,
    COUNT(jpf.job_id) AS demand_count
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
AND jpf.job_work_from_home = True
GROUP BY sd.skills
ORDER BY demand_count DESC
LIMIT 10;

/* RESULTS:
┌────────────┬──────────────┐
│   skills   │ demand_count │
│  varchar   │    int64     │
├────────────┼──────────────┤
│ sql        │        29221 │
│ python     │        28776 │
│ aws        │        17823 │
│ azure      │        14143 │
│ spark      │        12799 │
│ airflow    │         9996 │
│ snowflake  │         8639 │
│ databricks │         8183 │
│ java       │         7267 │
│ gcp        │         6446 │
└────────────┴──────────────┘*/
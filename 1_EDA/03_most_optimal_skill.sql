/*
What are the most optimal skills for Data Engineers to learn?
balance between demand and pay
1. create a ranking column that combines the demand count and median salary for each skill
2. rank the skills based on the combined ranking column.
3. focus on remote job postings
*/

SELECT 
    sd.skills,
    ROUND(MEDIAN(jpf.salary_year_avg),0) AS median_salary,
    COUNT(jpf.*) AS demand_count,
    ROUND(LN(COUNT(jpf.*)),0) AS ln_demand_count,
    ROUND((MEDIAN(jpf.salary_year_avg) * LN(COUNT(jpf.*)))/1_000_000, 2) AS optimal_score
FROM job_postings_fact AS jpf
INNER JOIN skills_job_dim AS sjd
ON jpf.job_id = sjd.job_id
INNER JOIN skills_dim AS sd
ON sjd.skill_id = sd.skill_id
WHERE jpf.job_title_short = 'Data Engineer'
AND jpf.job_work_from_home = True
AND jpf.salary_year_avg IS NOT NULL
GROUP BY sd.skills  
HAVING COUNT(jpf.salary_year_avg) > 100
ORDER BY optimal_score DESC
LIMIT 25;

/* RESULTS:
┌────────────┬───────────────┬──────────────┬─────────────────┬───────────────┐
│   skills   │ median_salary │ demand_count │ ln_demand_count │ optimal_score │
│  varchar   │    double     │    int64     │     double      │    double     │
├────────────┼───────────────┼──────────────┼─────────────────┼───────────────┤
│ terraform  │      184000.0 │          193 │             5.0 │          0.97 │
│ python     │      135000.0 │         1133 │             7.0 │          0.95 │
│ sql        │      130000.0 │         1128 │             7.0 │          0.91 │
│ aws        │      137320.0 │          783 │             7.0 │          0.91 │
│ airflow    │      150000.0 │          386 │             6.0 │          0.89 │
│ spark      │      140000.0 │          503 │             6.0 │          0.87 │
│ snowflake  │      135500.0 │          438 │             6.0 │          0.82 │
│ kafka      │      145000.0 │          292 │             6.0 │          0.82 │
│ azure      │      128000.0 │          475 │             6.0 │          0.79 │
│ java       │      135000.0 │          303 │             6.0 │          0.77 │
│ scala      │      137290.0 │          247 │             6.0 │          0.76 │
│ kubernetes │      150500.0 │          147 │             5.0 │          0.75 │
│ git        │      140000.0 │          208 │             5.0 │          0.75 │
│ databricks │      132750.0 │          266 │             6.0 │          0.74 │
│ redshift   │      130000.0 │          274 │             6.0 │          0.73 │
│ gcp        │      136000.0 │          196 │             5.0 │          0.72 │
│ nosql      │      134415.0 │          193 │             5.0 │          0.71 │
│ hadoop     │      135000.0 │          198 │             5.0 │          0.71 │
│ pyspark    │      140000.0 │          152 │             5.0 │           0.7 │
│ docker     │      135000.0 │          144 │             5.0 │          0.67 │
│ mongodb    │      135750.0 │          136 │             5.0 │          0.67 │
│ go         │      140000.0 │          113 │             5.0 │          0.66 │
│ r          │      134775.0 │          133 │             5.0 │          0.66 │
│ github     │      135000.0 │          127 │             5.0 │          0.65 │
│ bigquery   │      135000.0 │          123 │             5.0 │          0.65 │
└────────────┴───────────────┴──────────────┴─────────────────┴───────────────┘
*/

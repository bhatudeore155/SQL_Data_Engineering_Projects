/* 
Find the top 10 companies for posting jobs they must have 
> 3000 postings. for only US jobs

SQL Order of Execution:
1. FROM / JOIN -> load the base tables and combine rows
2. WHERE -> filter rows before grouping
3. GROUP BY -> aggregate rows into groups
4. HAVING -> filter groups after aggregation
5. SELECT -> choose the columns to return
6. ORDER BY -> sort the result set
7. LIMIT -> return only the first N rows

This query first joins job_postings_fact to company_dim, filters to US jobs,
then groups by company name, keeps only companies with more than 3000 postings,
orders the totals descending, and finally shows the top 10 results.

Plain English explanation:
- We want to know which companies in the United States posted more than 3000 jobs.
- The join connects each job posting to its company record.
- WHERE removes jobs that are not in the United States.
- GROUP BY combines all job rows for each company.
- COUNT(job_id) tells us how many jobs each company has.
- HAVING keeps only groups whose totals are greater than 3000.
- ORDER BY sorts from largest to smallest posting count.
- LIMIT shows only the top 10 companies.

Analysis comment:
- This is an aggregation query, so the database will likely group by company_name.
- It is efficient to filter by job_country before grouping, because it reduces the number
  of rows processed early.
- HAVING is applied after aggregation, so it is the correct place to filter based on
  COUNT(job_id) > 3000.
- ORDER BY on the aggregated count may require a sort, but only after the final grouped data
  is built, which is expected for a top-N report.
*/

SELECT 
    cd.name as company_name,
    COUNT(jpf.job_id) as total_postings
FROM job_postings_fact as jpf
LEFT JOIN company_dim as cd
ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY COUNT(jpf.job_id) DESC
LIMIT 10;


-- EXPLAIN and EXPLAIN ANALYZE are used to show the query plan and performance metrics.
-- They help you understand how the database will execute the statement, including:
-- - which tables are scanned or joined
-- - whether indexes are used
-- - how many rows pass through each step
-- - how long each operation takes
--
-- EXPLAIN shows the plan only.
-- EXPLAIN ANALYZE runs the query and includes actual timing and row counts.
-- This is useful for checking if the query is efficient and where bottlenecks occur.

EXPLAIN ANALYZE
SELECT 
    cd.name as company_name,
    COUNT(jpf.job_id) as total_postings
FROM job_postings_fact as jpf
LEFT JOIN company_dim as cd
ON jpf.company_id = cd.company_id
WHERE jpf.job_country = 'United States'
GROUP BY cd.name
HAVING COUNT(jpf.job_id) > 3000
ORDER BY COUNT(jpf.job_id) DESC
LIMIT 10;

/*┌────────────────────────────────────────────────┐
│┌──────────────────────────────────────────────┐│
││               Total Time: 1.88s              ││
│└──────────────────────────────────────────────┘│
└────────────────────────────────────────────────┘
┌───────────────────────────┐
│           QUERY           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│         EXTENSION         │
│    ────────────────────   │
│          md_type:         │
│   HYBRID_STATS_COLLECTOR  │
│                           │
│                           │
│                           │
│           0 rows          │
│           0.00s           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│      EXPLAIN_ANALYZE      │
│    ────────────────────   │
│                           │
│           0 rows          │
│           0.00s           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│         EXTENSION         │
│    ────────────────────   │
│          md_type:         │
│       HYBRID_RUNNER       │
│                           │
│                           │
│                           │
│           0 rows          │
│           0.00s           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│         EXTENSION         │
│    ────────────────────   │
│          md_type:         │
│      DOWNLOAD_SOURCE      │
│                           │
│        bridge_id: 1       │
│                           │
│                           │
│                           │
│           8 rows          │
│           0.03s           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│         EXTENSION         │
│    ────────────────────   │
│          md_type:         │
│    BATCH_DOWNLOAD_SINK    │
│                           │
│        bridge_id: 1       │
│       parallel: true      │
│                           │
│                           │
│                           │
│           0 rows          │
│           0.00s           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│           TOP_N           │
│    ────────────────────   │
│          Top: 10          │
│                           │
│         Order By:         │
│   count(jpf.job_id) DESC  │
│                           │
│                           │
│                           │
│           8 rows          │
│           0.00s           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│           FILTER          │
│    ────────────────────   │
│   (count(job_id) > 3000)  │
│                           │
│                           │
│                           │
│           8 rows          │
│           0.00s           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│       HASH_GROUP_BY       │
│    ────────────────────   │
│         Groups: #0        │
│   Aggregates: count(#1)   │
│                           │
│                           │
│                           │
│        57,752 rows        │
│           0.02s           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│         PROJECTION        │
│    ────────────────────   │
│            name           │
│           job_id          │
│                           │
│                           │
│                           │
│        464,483 rows       │
│           0.00s           │
└─────────────┬─────────────┘
┌─────────────┴─────────────┐
│         HASH_JOIN         │
│    ────────────────────   │
│      Join Type: RIGHT     │
│                           │
│        Conditions:        │
│  company_id = company_id  ├──────────────┐
│                           │              │
│                           │              │
│                           │              │
│        464,483 rows       │              │
│           0.05s           │              │
└─────────────┬─────────────┘              │
┌─────────────┴─────────────┐┌─────────────┴─────────────┐
│         TABLE_SCAN        ││         TABLE_SCAN        │
│    ────────────────────   ││    ────────────────────   │
│           Table:          ││           Table:          │
│ data_jobs.main.company_dim││       data_jobs.main      │
│                           ││     .job_postings_fact    │
│   Type: Sequential Scan   ││                           │
│                           ││   Type: Sequential Scan   │
│        Projections:       ││                           │
│         company_id        ││        Projections:       │
│            name           ││         company_id        │
│                           ││           job_id          │
│      Dynamic Filters:     ││                           │
│ optional: company_id>=4593││          Filters:         │
│  AND optional: company_id<││job_country='United States'│
│          =1620479         ││                           │
│                           ││                           │
│                           ││                           │
│                           ││                           │
│        215,940 rows       ││           0.37s           │
│           0.07s           ││          (0.37s)          │
└───────────────────────────┘└───────────────────────────┘*/
-- LEFT JOIN keeps every row from the left table (job_postings_fact), even when
-- there is no matching company_id in company_dim. Matching company details are
-- added to the result; for an unmatched job, the company_dim columns are NULL.
-- Diagram: LEFT rows  [LEFT ONLY] [MATCHING]
--         RIGHT rows              [MATCHING] (right-only rows excluded)
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
FROM 
    job_postings_fact as jpf
LEFT JOIN 
    company_dim as cd
ON 
    jpf.company_id = cd.company_id
LIMIT 10;

/* RIGHT JOIN

   RIGHT JOIN keeps every row from the right table (company_dim), even when
   there is no matching company_id in job_postings_fact. Matching job details are
   added to the result; for an unmatched company, the job_postings_fact columns are NULL.

    Diagram: LEFT rows   [MATCHING] (left-only rows excluded)
                RIGHT rows  [MATCHING] [RIGHT ONLY]
*/
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
FROM 
    job_postings_fact as jpf
RIGHT JOIN 
    company_dim as cd
ON 
    jpf.company_id = cd.company_id
LIMIT 10;

/* INNER JOIN

   INNER JOIN keeps only the rows that have matching company_id values in both
   tables. Unmatched rows from either table are excluded from the result.

    Diagram: LEFT rows   [LEFT ONLY] [MATCHING] [RIGHT ONLY]
                RIGHT rows              [MATCHING]
                Result:                 [MATCHING]
*/
SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
FROM 
    job_postings_fact as jpf
INNER JOIN 
    company_dim as cd
ON 
    jpf.company_id = cd.company_id
LIMIT 10;

/* FULL OUTER JOIN

   FULL OUTER JOIN keeps every row from both tables, even when there is no matching
   company_id in either table. Matching details are added to the result; for unmatched
   rows, the columns from the other table are NULL.

    Diagram: LEFT rows   [LEFT ONLY] [MATCHING]
                RIGHT rows              [MATCHING] [RIGHT ONLY]
                Result:     [LEFT ONLY] [MATCHING] [RIGHT ONLY]
*/

SELECT 
    jpf.job_id,
    jpf.job_title_short,
    cd.company_id,
    cd.name as company_name,
    jpf.job_location
FROM 
    job_postings_fact as jpf
FULL OUTER JOIN 
    company_dim as cd
ON 
    jpf.company_id = cd.company_id
LIMIT 10;
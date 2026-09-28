# Exploratory Data Analysis with SQL: Data Engineer Job Market

![EDA Project Overview](../Images/1_1_Project1_EDA.png)

This project uses SQL to explore data engineer job postings and identify which skills appear most often, which are associated with the highest median salaries, and which offer a useful balance of demand and compensation. The analysis focuses on remote roles and uses joins and aggregations across a job-posting data warehouse.

## Project Summary

Three queries investigate complementary views of the job market:

1. **Demand:** Count skill mentions in remote data engineer postings and return the top 10.
2. **Compensation:** Compare median annual salary by skill, keeping skills with more than 100 associated postings, and return the top 20.
3. **Demand and compensation:** Rank skills using a score that combines median annual salary and the natural logarithm of salary-qualified posting counts, returning the top 25.

The results are descriptive signals from the analyzed dataset. They can help prioritize further research, but they are not a guarantee of salary or employment outcomes.

## Questions This Analysis Answers

- Which skills are mentioned most often in remote data engineer job postings?
- Which skills have the highest median annual salary among the analyzed postings?
- Which skills combine a relatively strong salary with repeated demand?

## Data Model

The queries use a warehouse organized around job postings, skills, and their relationship:

![Data Warehouse Schema](../Images/1_2_Data_Warehouse.png)

- `job_postings_fact` contains posting-level attributes used by the analysis, including job title, remote-work flag, and annual salary.
- `skills_dim` is the skill catalog, including skill names.
- `skills_job_dim` links postings to skills. This bridge represents the many-to-many relationship: one posting can list multiple skills, and a skill can occur in multiple postings.
- `company_dim` contains company attributes in the wider schema but is not required by these three queries.

Each query joins `job_postings_fact` to `skills_job_dim` by `job_id`, then joins to `skills_dim` by `skill_id`. Grouping by skill produces one result row per skill.

## Analysis Files

| File | Purpose | Main output |
| --- | --- | --- |
| [01_Top_Demanded_Skills.sql](./01_Top_Demanded_Skills.sql) | Measures skill demand for remote data engineer roles | Skill and posting count; top 10 |
| [02_top_paying_skills.sql](./02_top_paying_skills.sql) | Compares median annual salary by skill | Skill, median salary, and posting count; top 20 |
| [03_most_optimal_skill.sql](./03_most_optimal_skill.sql) | Combines salary and salary-qualified demand | Skill, median salary, count, log count, and score; top 25 |

## Method and Metric Definitions

### Demand

The demand query filters for `job_title_short = 'Data Engineer'` and `job_work_from_home = True`, joins each posting to its skills, and counts the resulting posting-skill rows. The top 10 skills are ordered by that count. A posting with several skills contributes to the count for each listed skill.

### Salary

The salary query groups remote data engineer postings by skill and calculates `MEDIAN(salary_year_avg)`. The median is less sensitive to unusually high or low salaries than the average. The query requires more than 100 associated posting rows using `HAVING COUNT(jpf.*) > 100`; `MEDIAN` ignores null salary values. It sorts by median salary and returns 20 rows.

### Demand-and-Salary Score

The combined query excludes postings where `salary_year_avg` is null before grouping. Its score is:

```text
median_salary * LN(salary_qualified_posting_count) / 1,000,000
```

The score gives higher values to skills with both higher median salaries and more salary-qualified postings, while the logarithm reduces the influence of raw count differences. The displayed `ln_demand_count` is rounded for readability; the score is calculated using the unrounded logarithm. The query also requires more than 100 salary-qualified posting rows and returns the top 25 scores.

## Results at a Glance

The result tables are included as SQL comments in each query file. In those results:

- **SQL and Python** lead the demand query, with 29,221 and 28,776 posting-skill rows respectively. AWS, Azure, and Spark follow.
- **Rust** has the highest median salary in the top-paying query at $210,000, while Terraform and Golang each show a $184,000 median. These results should be read alongside their posting counts.
- **Terraform, Python, SQL, and AWS** rank highly in the combined score. Terraform leads that query at 0.97, followed by Python at 0.95.
- **Airflow, Spark, Snowflake, and Kafka** also appear among the higher combined scores, showing a mix of orchestration, processing, and platform skills.

These figures come from different query populations. In particular, the combined score only counts postings with a non-null annual salary, so its demand counts are not directly comparable with counts from the demand-only query.

## Running the Queries

Run the scripts with DuckDB connected to a database that contains the tables named in the data model. The scripts analyze existing tables; they do not create or load the source dataset. Execute each file independently to reproduce its result set.

## SQL Techniques Demonstrated

- Multi-table `INNER JOIN` operations across fact, bridge, and dimension tables
- Conditional filtering with `WHERE` and null checks
- Grouped analysis with `GROUP BY` and aggregate filtering with `HAVING`
- `COUNT`, `MEDIAN`, `ROUND`, and `LN` aggregate and mathematical functions
- Top-N ranking with `ORDER BY` and `LIMIT`
- Salary-aware filtering to make the combined demand-and-pay comparison explicit

## Scope and Limitations

- The analysis is limited to rows classified as data engineer roles and marked as work-from-home in the source data.
- Salary comparisons use `salary_year_avg`; roles without a reported annual salary do not contribute to median salary, and are excluded entirely from the combined-score query.
- Counts represent posting-skill associations, not unique people, hires, or necessarily unique employers.
- The score is a project-defined ranking aid, not a standard labor-market statistic. Its ordering depends on the salary field, filters, and dataset represented by the warehouse.
- No date range or geographic comparison is applied in these three queries, so interpret the results within the dataset's coverage.
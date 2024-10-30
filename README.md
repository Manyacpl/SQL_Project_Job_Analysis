# Introduction
The project presents an analysis of the job market, focusing on positions related to data analysis. It seeks to identify the highest-paying positions and the most in-demand skills.

# Background

Data was taken from [Data Nerd Site](https://datanerd.tech/). It includes data such as: job titles, salaries, locations, and essential skills.

### Questions I want to answer in the analysis

1. What are the top-paying data analyst jobs and how it looks in Poland?
2. What skills are required for top-paying jobs?
3. What skills are most in demand for data analysts?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I used

I leveraged **SQL** and **PostgreSQL** to extract and analyze the data. **VSCode** provided a convenient coding environment, while **Git** and **GitHub** enabled version control and collaboration. Finally, **Google Gemini** assisted in various aspects of the analysis, from data exploration to report writing. 


# The Analysis

Each query addresses the questions outlined above.

## 1. Top Paying Data Analyst Jobs


To identify the highest-paying positions, I filtered for data analyst roles by average yearly salary and set the location to "Anywhere," indicating remote work. In the second query, I filtered based on the location "Poland."

``` sql

SELECT
    job_id,
    job_title,
    job_location,
    job_schedule_type,
    salary_year_avg,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location = 'Anywhere' AND
    -- job_location = 'Poland' AND
    salary_year_avg IS NOT NULL
ORDER BY salary_year_avg DESC
LIMIT 10
```

To summarize:

**Top Paying Data Analyst Job:** A Data Analyst position at Mantys offers the highest average annual salary of $650,000.

**High-Paying Data Analyst Roles:** Several companies like Meta, AT&T, and Pinterest offer Data Analyst and Director-level positions with average salaries ranging from $200,000 to $336,500.

**Remote and Hybrid Opportunities:** Many of these top-paying positions offer remote or hybrid work arrangements, providing flexibility for data analysts.

**For Poland Location:** Allegro has the highest-paying positions.

| Job Title | Company Name | Average Salary (USD) |
|---|---|---|
| Data Analyst | Mantys | $650,000.00 |
| Director of Analytics | Meta | $336,500.00 |
| Associate Director- Data Insights | AT&T | $255,829.50 |
| Data Analyst, Marketing | Pinterest Job Advertisements | $232,423.00 |
| Data Analyst (Hybrid/Remote) | Uclahealthcareers | $217,000.00 |
| Principal Data Analyst (Remote) | SmartAsset | $205,000.00 |
| Director, Data Analyst - HYBRID | Inclusively | $189,309.00 |
| Principal Data Analyst, AV Performance Analysis | Motional | $189,000.00 |
| Principal Data Analyst | SmartAsset | $186,000.00 |
| ERM Data Analyst | Get It Recruit - Information Technology | $184,000.00 |

## 2. Skills for Top Paying Jobs

To understand which skills are most in demand for the highest-paying positions, I joined two tables: job postings and skills data.

``` sql
WITH top_paying_jobs AS (
    SELECT
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location = 'Anywhere' AND
        salary_year_avg IS NOT NULL
    ORDER BY salary_year_avg DESC
    LIMIT 10
)

SELECT
    top_paying_jobs.*,
    skills,
    type
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
```
The results for the most in-demand skills in the top 10 highest-paying data analyst jobs.

**Python libraries:** Matplotlib, Seaborn, Plotly

**R libraries:** ggplot2

**Spreadsheet software:** Excel, Google Sheets

**Data visualization tools:** Tableau, Power BI

Here's a breakdown of the skill counts by category:

| Skill Category | Count |
|---|---|
| Programming | 63 |
| Cloud | 32 |
| Libraries | 22 |
| Analyst Tools | 19 |
| Other | 19 |
| Async | 2 |

## 3. In-Demand Skills for Data Analysts

This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.

``` sql
SELECT
    skills,
    COUNT(skills_job_dim.skill_id) AS demand_count

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst'
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5
```
**Foundational skills in SQL and Excel** remain crucial for data processing and manipulation. 

**Technical skills in Python, Tableau, and Power BI** are increasingly essential for data analysis, visualization, and decision-making.

| Skill | Demand Count |
|---|---|
| SQL | 92,628 |
| Excel | 67,031 |
| Python | 57,326 |
| Tableau | 46,554 |
| Power BI | 39,468 |

### 4. Skills Based on Salary

By examining average salaries, I determined which skills are most lucrative in the job market.

``` sql
SELECT
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary

FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 10
```

Summary:

**Pyspark**, a powerful tool for big data processing, tops the list of highest-paying skills, with an average salary of $208,172. Other high-paying skills include version control tools like **Bitbucket and Gitlab**, as well as data science and machine learning tools like **Watson, Datarobot, and Jupyter.**

| Skill | Average Salary |
|---|---|
| Pyspark | $208,172 |
| Bitbucket | $189,155 |
| Watson | $160,515 |
| Couchbase | $160,515 |
| Datarobot | $155,486 |
| Gitlab | $154,500 |
| Swift | $153,750 |
| Jupyter | $152,777 |
| Pandas | $151,821 |
| Elasticsearch | $145,000 |

### 5. Most Optimal Skills to Learn

This query combined data on skill demand and average salaries to identify skills that offer a high potential for both career growth and financial reward.

``` sql
SELECT
    skills_dim.skill_id,
    skills_dim.skills,
    COUNT(skills_job_dim.job_id) AS demand_count,
    ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    salary_year_avg IS NOT NULL AND
    job_work_from_home = TRUE
GROUP BY
    skills_dim.skill_id
HAVING
    COUNT(skills_job_dim.job_id) > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25
```
**Key Findings:**

**Go and Confluence** emerged as the top two skills, offering a lucrative blend of demand and salary.

**Cloud technologies** like **Snowflake, Azure, AWS, BigQuery**, and Oracle are highly sought-after, reflecting the increasing importance of cloud-based solutions.

**Data engineering and data warehousing skills**, including **Hadoop, Spark, and SQL Server**, remain crucial for data-driven organizations.

**Data science and machine learning skills**, such as **Python, R, and SAS**, continue to be in high demand, driving innovation and business growth.

**Business intelligence and data visualization** tools like **Tableau, Looker, Qlik, and Power BI** are essential for effective data-driven decision-making.

| Skill | Demand Count | Average Salary |
|---|---|---|
| Go | 27 | $115,320 |
| Confluence | 11 | $114,210 |
| Hadoop | 22 | $113,193 |
| Snowflake | 37 | $112,948 |
| Azure | 34 | $111,225 |
| BigQuery | 13 | $109,654 |
| AWS | 32 | $108,317 |
| Java | 17 | $106,906 |
| SSIS | 12 | $106,683 |
| Jira | 20 | $104,918 |

# Conclusions

### Key Insights from the Data Analyst Job Market

Our analysis of data analyst job postings and salaries has yielded several key insights:

**High-Paying Remote Opportunities:**

* Remote data analyst roles offer a significant advantage, with top-tier positions commanding salaries exceeding $650,000 annually.
* This trend highlights the increasing flexibility and global reach of data analyst careers.

**SQL: The Foundation of Data Analysis:**

* SQL remains the cornerstone skill for data analysts, consistently appearing in both high-demand and high-paying job postings.
* A strong foundation in SQL is essential for data cleaning, manipulation, and analysis.

**Niche Skills, Premium Pay:**

* Specialized skills like SVN and Solidity can lead to significantly higher salaries.
* While these skills may be less widely demanded, they can provide a competitive edge and open doors to high-paying niche roles.

**Strategic Skill Development:**

* By prioritizing SQL skills, data analysts can position themselves for a wide range of opportunities and competitive salaries.
* Continuous learning and upskilling in emerging technologies and tools can further enhance career prospects.

Understanding these trends can help aspiring and experienced data analysts make informed decisions about their career paths. By focusing on in-demand skills and seeking out remote opportunities, data analysts can maximize their earning potential and achieve professional success.

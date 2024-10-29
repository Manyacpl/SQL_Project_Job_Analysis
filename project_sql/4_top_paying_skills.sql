/*
What are the top skills based on salary?
- Look at the average salary associated with each skill for DA?
- Focused on roles with specified salaries, regardless of location.
*/

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
LIMIT 25

/*
Data engineering and big data tools lead the way: Skills like PySpark, Couchbase, and DataRobot—focused 
on large-scale data processing, analysis, and AI automation—dominate top salary brackets, 
reflecting demand for high-volume, complex data management capabilities.

Version control and DevOps knowledge pay off: Tools like Bitbucket, GitLab, and Jenkins highlight a growing trend 
where DevOps skills are valuable for data analysts, especially in collaborative environments needing streamlined, 
scalable workflows.

Programming languages and data science libraries are essentials: Proficiency in languages like Swift and Golang, 
alongside libraries like Pandas, NumPy, and scikit-learn, is rewarded, emphasizing that coding and data manipulation skills 
remain central to high-paying analyst roles.
*/
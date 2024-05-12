
-- EXploratory data analysis

SELECT *
from layoffs_test2;

SELECT   max(total_laid_off), max(percentage_laid_off)
FROM layoffs_test2;

SELECT 
    *
FROM
    layoffs_test2
WHERE
    percentage_laid_off = 1
ORDER BY percentage_laid_off DESC;

-- Company wiht the bigest LAid_OFF
SELECT 
    company, total_laid_off, date, country
FROM
    layoffs_test2
WHERE
    total_laid_off = (SELECT 
            MAX(total_laid_off)
        FROM
            layoffs_test2);

SELECT company, MAX(total_laid_off)
from layoffs_test2
	group by company
	order by MAX(total_laid_off) desc;
    
-- Companies with Total Layoff Counts

SELECT company, sum(total_laid_off)
from layoffs_test2
	group by company
	order by 2 desc;
SELECT *
FROM layoffs_test2
	WHERE company LIKE 'Amazon%';
    
-- Total Layoffs per Year

SELECT 
    YEAR(date), SUM(total_laid_off)
FROM
    layoffs_test2
GROUP BY YEAR(date)
ORDER BY 1 ASC;

--  Total Layoffs by Industry
SELECT 
    industry, SUM(total_laid_off) AS Total_Layoffs
FROM
    layoffs_test2
GROUP BY industry
ORDER BY Total_Layoffs DESC;
-- Total Layoffs by Country
SELECT 
    country, SUM(total_laid_off)
FROM
    layoffs_test2
GROUP BY country
ORDER BY 2 DESC;


--------------
-- Query: Total Layoffs by Month


SELECT 
    SUBSTRING(date, 1, 7) AS MONTH,
    SUM(total_laid_off) AS Total_Layoffs
FROM
    layoffs_test2
WHERE
    SUBSTRING(date, 1, 7) IS NOT NULL
GROUP BY MONTH
ORDER BY 1 desc;
-- This query first calculates the total layoffs per month in the CTE (monthly_totals) 
-- and then computes the rolling total by applying the SUM window function over the sorted months in the main query.

WITH rolling_total AS (
    SELECT 
        SUBSTRING(date, 1, 7) AS Month,
        SUM(total_laid_off) AS Total_Layoffs
    FROM 
        layoffs_test2
    WHERE 
        SUBSTRING(date, 1, 7) IS NOT NULL
    GROUP BY 
        Month
    ORDER BY 
        Month ASC
)

SELECT 
    Month, Total_Layoffs,
    SUM(Total_Layoffs) OVER (ORDER BY Month) AS Rolling_Total
FROM 
    rolling_total;
    

    -- Earlier we looked at Companies with the most Layoffs. Now let's look at that per year. 
    
SELECT 
    company, YEAR(date), SUM(total_laid_off)
FROM
    layoffs_test2
GROUP BY company , YEAR(date)
ORDER BY 3 desc;

with company_year(company, years, total_laid_off) AS  
(SELECT 
    company, YEAR(date), SUM(total_laid_off)
FROM
    layoffs_test2
GROUP BY company , YEAR(date)
)


  SELECT *,
  DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) as ranking
  FROM Company_Year
  where years is not null
  order by ranking asc;
--------------------------------------------------------------------------------------------------------------------
-- furder more 
SELECT 
    company, YEAR(date), SUM(total_laid_off)
FROM
    layoffs_test2
GROUP BY company , YEAR(date)
ORDER BY 3 desc;

with company_year(company, years, total_laid_off) AS  
(SELECT 
    company, YEAR(date), SUM(total_laid_off)
FROM
    layoffs_test2
GROUP BY company , YEAR(date)
), company_year_rank as 
(
  SELECT *,
  DENSE_RANK() OVER (PARTITION BY years ORDER BY total_laid_off DESC) as ranking
  FROM Company_Year
  where years is not null
  )
  select *
  from company_year_rank
  where ranking <= 3
  ;
--3-Year Moving Average
WITH YearlySale AS (
    SELECT 
        EXTRACT (YEAR FROM sale_date) AS year,
        SUM(units_sold) AS Total_units
        FROM global_sales
        WHERE region = 'Europe'
        GROUP BY EXTRACT (YEAR FROM sale_date)
)
SELECT 
    year,
    Total_units,
    LAG (Total_units) OVER (ORDER BY year) AS previous_year_units,
    CASE 
        WHEN LAG (Total_units) OVER (ORDER BY year) IS NULL THEN '0'
        ELSE 
            ROUND (
            ((Total_units - LAG (Total_units)OVER (ORDER BY year)) * 100.0 ) 
            / LAG (Total_units) OVER (ORDER BY year),
             2
        )   ::TEXT ||'%'
    END AS yoy_growth,
    CASE 
        WHEN Total_units > LAG (Total_units)OVER (ORDER BY year) THEN 'Increase'
        WHEN Total_units < LAG (Total_units)OVER (ORDER BY year) THEN 'Decrease'
        WHEN Total_units = LAG (Total_units)OVER (ORDER BY year) THEN 'Constant'
        ELSE 'N/A'
    END AS trend_status,
 ROUND(
    AVG(Total_units) OVER (
        ORDER BY year
        ROWS BETWEEN 2 PRECEDING AND CURRENT ROW
        ), 2
) AS moving_avg_3yr
   FROM YearlySale
    ORDER BY year DESC;

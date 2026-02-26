--The best-selling product for each European country
WITH ProductSales AS (
    SELECT
    country,
    product_name,
    SUM(units_sold) AS Total_sold,
    RANK () OVER (PARTITION BY country ORDER BY SUM(units_sold)DESc) AS sales_rank
    FROM global_sales
    WHERE region = 'Europe'
    GROUP BY country, product_name
    )
SELECT
    country,
    product_name,
    Total_sold
FROM ProductSales
WHERE sales_rank = 1;    
create Database Store_project;
USE Store_project;
Show databases;
select * from superstore;
DESCRIBE superstore;
ALTER TABLE superstore MODIFY `Order Date` DATE;
ALTER TABLE superstore MODIFY `Ship Date` DATE;

-- 1. Profile the data and write a cleaning log with row counts
-- Total rows
SELECT COUNT(*) AS total_rows FROM superstore;

-- Null ya khali values (har important column ke liye)
SELECT
  SUM(`Order ID` IS NULL OR `Order ID` = '')     AS blank_order_id,
  SUM(`Order Date` IS NULL)                      AS blank_order_date,
  SUM(Sales IS NULL)                             AS blank_sales,
  SUM(Profit IS NULL)                            AS blank_profit
FROM superstore;

-- Duplicate lines (Row ID chhod kar)
SELECT COUNT(*) - COUNT(DISTINCT `Order ID`,`Product ID`,Sales,Quantity,Discount,Profit) AS dup_rows
FROM superstore;

-- Date range aur ship date check
SELECT MIN(`Order Date`), MAX(`Order Date`) FROM superstore;
SELECT COUNT(*) FROM superstore WHERE `Ship Date` < `Order Date`;

-- Sales, discount, profit ka reality check
SELECT SUM(Sales), SUM(Profit), SUM(Profit)/SUM(Sales) AS margin,
       SUM(Sales < 0) AS neg_sales, SUM(Profit < 0) AS loss_lines,
       MIN(Discount), MAX(Discount)
FROM superstore;

-- 2.Write the revenue and profit summary queries by category, sub-category, region and month
-- Category
SELECT Category, SUM(Sales) AS sales, SUM(Profit) AS profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS margin_pct
FROM superstore GROUP BY Category ORDER BY sales DESC;

-- Sub-Category
SELECT `Sub-Category`, SUM(Sales) AS sales, SUM(Profit) AS profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS margin_pct
FROM superstore GROUP BY `Sub-Category` ORDER BY profit;

-- Region
SELECT Region, SUM(Sales) AS sales, SUM(Profit) AS profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS margin_pct
FROM superstore GROUP BY Region ORDER BY sales DESC;

-- Month
SELECT DATE_FORMAT(`Order Date`,'%Y-%m') AS month, SUM(Sales) AS sales, SUM(Profit) AS profit,
       ROUND(SUM(Profit)/SUM(Sales)*100,2) AS margin_pct
FROM superstore GROUP BY month ORDER BY month;

-- 3. Revenue rank vs profit rank (“busy but poor”)
WITH p AS (
  SELECT `Product Name` AS product, SUM(Sales) AS sales, SUM(Profit) AS profit
  FROM superstore GROUP BY `Product Name`
),
r AS (
  SELECT *, RANK() OVER (ORDER BY sales DESC)  AS revenue_rank,
            RANK() OVER (ORDER BY profit DESC) AS profit_rank
  FROM p
)
SELECT *, profit_rank - revenue_rank AS gap
FROM r
WHERE revenue_rank <= 100 AND profit_rank > 1000   -- thresholds apne hisaab se
ORDER BY gap DESC;

-- 4. Discount bands vs margin
SELECT
  CASE WHEN Discount = 0 THEN '0%'
       WHEN Discount <= 0.2 THEN 'Up to 20%'
       WHEN Discount <= 0.4 THEN '20-40%'
       ELSE 'Above 40%' END AS discount_band,
  COUNT(*) AS line, SUM(Sales) AS sales, SUM(Profit) AS profit,
  ROUND(SUM(Profit)/SUM(Sales)*100,2) AS margin_pct
FROM superstore
GROUP BY discount_band
ORDER BY MIN(Discount);

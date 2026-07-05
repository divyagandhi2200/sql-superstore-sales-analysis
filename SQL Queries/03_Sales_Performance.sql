/*
===============================================================================
                       SALES PERFORMANCE ANALYSIS
===============================================================================

Project : Superstore Sales Analysis

Description:
This file analyzes the company's sales performance from multiple business
perspectives.

The objective is to understand:

• Which categories generate the most revenue?
• Which sub-categories drive sales?
• Which regions perform the best?
• How has sales performance changed over time?
• Which years generated the highest revenue?
• What are the overall business trends?

The insights generated in this section help management identify growth
opportunities, allocate resources effectively, and make informed
business decisions.

===============================================================================
*/

/*
===============================================================================
Business Question:
Which product categories generate the highest revenue?

Objective:
Compare total sales across product categories.

Business Value:
Understanding category performance helps management prioritize
high-revenue product lines and optimize inventory planning.

===============================================================================
*/

SELECT
    Category,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM dbo.superstore
GROUP BY Category
ORDER BY Total_Sales DESC;

/*
===============================================================================
Business Question:
Which product sub-categories generate the highest revenue?

Objective:
Identify the best-performing product groups within each category.

Business Value:
Sub-category analysis enables better merchandising decisions,
marketing strategies, and inventory optimization.

===============================================================================
*/

SELECT
    Sub_Category,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM dbo.superstore
GROUP BY Sub_Category
ORDER BY Total_Sales DESC;

/*
===============================================================================
Business Question:
Which geographical regions generate the highest revenue?

Objective:
Compare sales performance across different regions.

Business Value:
Regional analysis helps identify strong markets and areas
requiring additional business attention.

===============================================================================
*/

SELECT
    Region,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM dbo.superstore
GROUP BY Region
ORDER BY Total_Sales DESC;

/*
===============================================================================
Business Question:
How have monthly sales changed over time?

Objective:
Analyze sales trends across months and years.

Business Value:
Understanding seasonal trends helps improve demand forecasting,
inventory management, and marketing planning.

===============================================================================
*/

SELECT
    YEAR(Order_Date) AS Sales_Year,
    MONTH(Order_Date) AS Month_Number,
    DATENAME(MONTH, Order_Date) AS Month_Name,
    ROUND(SUM(Sales),2) AS Total_Sales
FROM dbo.superstore
GROUP BY
    YEAR(Order_Date),
    MONTH(Order_Date),
    DATENAME(MONTH, Order_Date)
ORDER BY
    Sales_Year,
    Month_Number;

/*
===============================================================================
Business Question:
How has business performance changed year over year?

Objective:
Compare annual sales, profit, order volume, and profit margin.

Business Value:
Year-over-year analysis helps evaluate business growth and
identify changes in profitability over time.

===============================================================================
*/

SELECT
    YEAR(Order_Date) AS Year,
    COUNT(DISTINCT Order_ID) AS Total_Orders,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit,
    CAST(ROUND(SUM(Profit)*100.0/SUM(Sales),2) AS VARCHAR)+'%' AS Profit_Margin
FROM dbo.superstore
GROUP BY YEAR(Order_Date)
ORDER BY Year;

/*
===============================================================================
Business Question:
How does monthly sales performance change throughout the year?

Objective:
Measure month-over-month sales growth.

Business Value:
Identifying periods of growth and decline helps improve
forecasting, marketing strategy, and inventory planning.

===============================================================================
*/

WITH Monthly_Sales AS (
    SELECT
        YEAR(Order_Date) AS Sales_Year,
        MONTH(Order_Date) AS Sales_Month,
        DATENAME(MONTH, Order_Date) AS Month_Name,
        COUNT(DISTINCT Order_ID) AS Total_Orders,
        ROUND(SUM(Sales),2) AS Total_Sales
    FROM dbo.superstore
    GROUP BY
        YEAR(Order_Date),
        MONTH(Order_Date),
        DATENAME(MONTH, Order_Date)
), 
Monthly_Growth AS (
    SELECT *,
        Total_Sales - LAG(Total_Sales) OVER ( PARTITION BY Sales_Year ORDER BY Sales_Month) AS Monthly_Sales_Change
    FROM Monthly_Sales
)
SELECT *,
    CASE
        WHEN Monthly_Sales_Change > 0 THEN 'Growth'
        WHEN Monthly_Sales_Change < 0 THEN 'Decline'
        ELSE 'No Change'
    END AS Trend_Description
FROM Monthly_Growth
ORDER BY
    Sales_Year,
    Sales_Month;

/*
===============================================================================
Business Question:
Which month generated the highest sales each year?

Objective:
Identify peak-performing months.

Business Value:
Knowing peak sales periods supports inventory planning,
marketing campaigns, and workforce scheduling.

===============================================================================
*/

WITH MonthlySales AS
(
SELECT
  YEAR(Order_Date) AS Sales_Year,
  MONTH(Order_Date) AS Sales_Month,
  SUM(Sales) AS Total_Sales
FROM dbo.superstore
GROUP BY
  YEAR(Order_Date),
  MONTH(Order_Date)
),
RankedMonths AS
(
SELECT*,
  ROW_NUMBER() OVER (PARTITION BY Sales_Year ORDER BY Total_Sales DESC) AS Month_Rank
FROM MonthlySales
)
SELECT *
FROM RankedMonths
WHERE Month_Rank=1;

/*
===============================================================================
Key Business Takeaways

• Sales performance was analyzed across categories, sub-categories,
  regions, months, and years.
• Time-series analysis revealed seasonal trends and month-over-month
  performance changes.
• Year-over-year comparisons highlighted changes in revenue,
  profitability, and overall business growth.
• High-performing categories and regions were identified,
  helping prioritize future business investments.
• These insights support better forecasting, strategic planning,
  and revenue optimization.

===============================================================================
*/

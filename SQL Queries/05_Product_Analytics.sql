/*
===============================================================================
                        PRODUCT ANALYTICS
===============================================================================

Project : Superstore Sales Analysis

Description:
This file evaluates product performance by analyzing sales, profitability,
and product rankings across different categories.

The objective is to answer the following business questions:

• Which products generate the highest revenue?
• Which products generate the highest profit?
• Which products are causing financial losses?
• Which categories have the best profit margins?
• How do products rank within each category?

These insights help businesses optimize inventory, improve pricing
strategies, discontinue underperforming products, and maximize
overall profitability.

===============================================================================
*/

/*
===============================================================================
Business Question:
Which products generate the highest sales revenue?

Objective:
Identify the top-performing products based on total sales.

Business Value:
Understanding which products drive revenue helps businesses prioritize
inventory planning, marketing efforts, and demand forecasting.

===============================================================================
*/

SELECT TOP 10
    Product_Name,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM dbo.superstore
GROUP BY Product_Name
ORDER BY Total_Sales DESC;

/*
===============================================================================
Business Question:
Which high-selling products are generating losses?

Objective:
Identify products that achieve strong sales but fail to generate profit.

Business Value:
High sales do not always translate into business success.

Products generating high revenue but negative profit should be reviewed
for pricing strategies, discount policies, supplier costs, or operational
inefficiencies.

===============================================================================
*/

WITH Product_Performance AS (
	SELECT
		Product_Name,
		ROUND(SUM(Sales), 2) AS Total_Sales,
		ROUND(SUM(Profit), 2) AS Total_Profit
	FROM dbo.superstore
	GROUP BY Product_Name
)
SELECT *
FROM Product_Performance
WHERE Total_Sales > 10000 AND Total_Profit < 0
ORDER BY Total_Sales DESC;

/*
===============================================================================
Business Question:
Which products are the top performers within each product category?

Objective:
Rank products based on total sales inside each category.

Business Value:
Ranking products helps identify category leaders and supports inventory
planning, merchandising, and promotional strategies.

===============================================================================
*/

SELECT
	Category,
	Product_Name,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	RANK() OVER (PARTITION BY Category ORDER BY SUM(Sales) DESC) AS Product_Rank
FROM dbo.superstore
GROUP BY Category, Product_Name;

/*
===============================================================================
Business Question:
Which product categories generate the highest profit margins?

Objective:
Compare category profitability by calculating profit margin.

Business Value:
Profit margin provides a better measure of business performance than
sales alone because it reflects how efficiently revenue is converted
into profit.

===============================================================================
*/

SELECT 
	Category, 
	ROUND(SUM(Sales), 2) AS Total_sales, 
	ROUND(SUM(profit), 2) AS Total_profit, 
	CAST(ROUND(SUM(Profit) * 100.0 / SUM(Sales), 2) AS VARCHAR) + '%' AS Profit_margin 
FROM dbo.superstore 
GROUP BY Category 
ORDER BY SUM(profit) DESC; 

/*
===============================================================================
Business Question:
Which product sub-categories are operating at a loss?

Objective:
Identify product groups that negatively impact business profitability.

Business Value:
Recognizing consistently loss-making sub-categories allows management
to review pricing strategies, supplier costs, product quality,
or discontinue underperforming product lines.

===============================================================================
*/

SELECT 
	Sub_Category, 
	ROUND(SUM(Sales), 2) AS Total_Sales, 
	ROUND(SUM(Profit), 2) AS Total_Profit 
FROM dbo.superstore 
GROUP BY Sub_Category 
HAVING SUM(Profit) < 0 
ORDER BY SUM(Profit); 

/*
===============================================================================
Summary

Key analyses completed in this file:

✓ Top Revenue-Generating Products
✓ High-Sales, Loss-Making Products
✓ Product Rankings Within Categories
✓ Category Profit Margin Analysis
✓ Loss-Making Sub-Categories

These analyses provide a comprehensive understanding of product
performance and help identify opportunities to improve profitability,
pricing strategies, and inventory management.

===============================================================================
*/

/*
===============================================================================
                    PROFITABILITY ANALYSIS
===============================================================================

Project : Superstore Sales Analysis

Description:
This file evaluates the company's profitability by analyzing profit margins,
discount strategies, shipping methods, and other key business factors that
directly impact financial performance.

The objective is to answer the following business questions:

• Which categories generate the highest profit margins?
• Are discounts negatively affecting profitability?
• Which shipping modes are the most profitable?
• Which discount ranges maximize profit?
• Which business areas require profitability improvements?

These insights help businesses optimize pricing strategies, control costs,
improve operational efficiency, and maximize long-term profitability.

===============================================================================
*/

/*
===============================================================================
Business Question:
Which product categories generate the highest profit margins?

Objective:
Compare category profitability by calculating the percentage of profit
earned from total sales.

Business Value:
Profit margin is a key performance indicator that helps identify
which product categories contribute most efficiently to the company's
financial success.

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
How do different discount levels impact profitability?

Objective:
Analyze the relationship between discount ranges, sales, and profit.

Business Value:
Understanding discount performance helps businesses balance customer
acquisition with profitability and avoid excessive discounting that
reduces overall profit.

===============================================================================
*/

SELECT 
	CAST(Discount * 100 AS VARCHAR) + '%' AS Discount, 
	ROUND(SUM(Profit), 2) AS Total_Profit, 
	ROUND(SUM(Sales), 2) AS Total_Sales,
  CASE
    WHEN Discount = 0 THEN '0%'
    WHEN Discount <= 0.2 THEN '0-20%'
    WHEN Discount <= 0.5 THEN '21-50%'
    ELSE 'More than 50%'
  END
FROM dbo.superstore 
GROUP BY Discount 
ORDER BY Discount; 

/*
===============================================================================
Business Question:
Which shipping modes generate the highest profitability?

Objective:
Evaluate sales, profit, and profit margins across different shipping methods.

Business Value:
Shipping efficiency affects both customer satisfaction and business costs.

Identifying the most profitable shipping methods supports logistics
optimization and cost management.

===============================================================================
*/

SELECT
	Ship_Mode,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Profit), 2) AS Total_Profit,
	CAST(ROUND(SUM(Profit)/SUM(Sales) * 100, 2) AS VARCHAR) + '%' AS Profit_Margin
FROM dbo.superstore
GROUP BY Ship_Mode
ORDER BY Total_Profit DESC;

/*
===============================================================================
Business Question:
Which states generate high revenue while operating at a loss?

Objective:
Identify geographical markets where strong sales fail to produce
positive profitability.

Business Value:
These markets require immediate investigation into pricing,
discount policies, shipping costs, or operational expenses.

===============================================================================
*/

SELECT
	State_Province AS State,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Profit), 2) AS Total_Profit
FROM dbo.superstore
GROUP BY State_Province
HAVING SUM(Profit) < 0
ORDER BY Total_Sales DESC;

/*
===============================================================================
                    Key Business Takeaways
===============================================================================

• Profitability depends on pricing strategy, discount management,
  and operational efficiency rather than sales alone.

• Moderate discount levels help maintain profitability,
  while excessive discounting significantly reduces profit.

• Certain shipping methods deliver stronger profit margins,
  indicating opportunities for logistics optimization.

• Some high-revenue markets continue operating at a loss,
  requiring immediate strategic review.

• Improving profit margins should be prioritized alongside
  revenue growth to ensure sustainable business performance.

===============================================================================
*/

/*
===============================================================================
                      CUSTOMER ANALYTICS
===============================================================================

Project : Superstore Sales Analysis

Description:
This file analyzes customer purchasing behavior to identify the company's
most valuable customers, customer segments, purchasing patterns, and
opportunities to improve customer retention.

The objective is to answer the following business questions:

• Which customer segments generate the highest revenue and profit?
• Who are the top revenue-generating customers?
• How many customers are repeat buyers?
• Which customers drive the majority of sales?
• Who qualifies as a VIP customer based on purchasing behavior?

These insights help businesses improve customer retention, personalize
marketing campaigns, and maximize customer lifetime value.

===============================================================================
*/
/*
===============================================================================
Business Question:
Which customer segments generate the highest sales and profit?

Objective:
Compare sales and profitability across different customer segments.

Business Value:
Understanding customer segment performance helps businesses allocate
marketing budgets, prioritize customer groups, and improve profitability.

===============================================================================
*/

SELECT
    Segment,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM dbo.superstore
GROUP BY Segment
ORDER BY Total_Profit DESC;

/*
===============================================================================
Business Question:
Who are the company's top 10 revenue-generating customers?

Objective:
Identify the customers contributing the highest sales.

Business Value:
High-value customers are ideal candidates for loyalty programs,
personalized marketing campaigns, and retention initiatives.

===============================================================================
*/

SELECT TOP 10
    Customer_Name,
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit
FROM dbo.superstore
GROUP BY Customer_Name
ORDER BY Total_Sales DESC;

/*
===============================================================================
Business Question:
How many customers are repeat buyers compared to one-time buyers?

Objective:
Classify customers based on purchasing frequency.

Business Value:
Repeat customers generally have higher lifetime value and indicate
strong customer loyalty.

===============================================================================
*/

WITH Customer_Order_Count AS
(
    SELECT
        Customer_Name,
        COUNT(DISTINCT Order_ID) AS Orders_Per_Customer
    FROM dbo.superstore
    GROUP BY Customer_Name
)

SELECT
    CASE
        WHEN Orders_Per_Customer = 1 THEN 'One-Time Customer'
        ELSE 'Repeat Customer'
    END AS Customer_Type,

    COUNT(*) AS Total_Customers

FROM Customer_Order_Count

GROUP BY
CASE
    WHEN Orders_Per_Customer = 1 THEN 'One-Time Customer'
    ELSE 'Repeat Customer'
END;

/*
===============================================================================
Business Question:
Which customers contribute to the top 20% of total revenue?

Objective:
Identify the highest-performing customers using Pareto Analysis.

Business Value:
Businesses often generate a large percentage of revenue from a relatively
small group of customers. Identifying these customers supports targeted
marketing and customer retention strategies.

===============================================================================
*/

WITH Customer_sales AS (
SELECT
	DISTINCT Customer_Name,
	ROUND(SUM(Sales), 2) AS Total_Sales
FROM dbo.superstore
GROUP BY Customer_Name
),
Customers_ranked AS (
SELECT
	*,
	RANK() OVER (ORDER BY total_sales DESC) AS Customer_rank
FROM Customer_sales
)
SELECT 
	*
FROM Customers_ranked
WHERE Customer_rank <= (
    SELECT COUNT(*) * 0.2 FROM Customer_sales
)
ORDER BY total_sales DESC;

/*
===============================================================================
Business Question:
Which customers qualify as VIP customers based on their purchasing behavior?

Objective:
Perform RFM (Recency, Frequency, Monetary) Analysis to identify the company's
most valuable and loyal customers.

Business Value:
RFM Analysis is a widely used customer segmentation technique that evaluates
customers based on:

• Recency   - How recently the customer made a purchase.
• Frequency - How often the customer places orders.
• Monetary  - How much revenue the customer generates.

Identifying VIP customers enables businesses to improve customer retention,
design loyalty programs, personalize marketing campaigns, and maximize
customer lifetime value.

===============================================================================
*/

/*
----------------------------------------------------------------------------
Step 1: Monetary Analysis

Objective:
Calculate the total sales and total profit generated by each customer.

Purpose:
The Monetary score measures the financial value of each customer.
Customers with higher spending contribute more revenue to the business
and are generally considered more valuable.
----------------------------------------------------------------------------
*/

WITH Mon_Analysis AS (
SELECT
	Customer_ID,
	Customer_Name,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Profit), 2) AS Total_Profit
FROM dbo.superstore
GROUP BY Customer_ID, Customer_Name
),

/*
----------------------------------------------------------------------------
Step 2: Recency Analysis

Objective:
Determine how recently each customer placed an order.

Purpose:
Customers who have purchased recently are more likely to make future
purchases and respond positively to marketing campaigns.

The analysis also groups customers into recency buckets to simplify
customer segmentation.
----------------------------------------------------------------------------
*/

Rec_Analysis AS (
SELECT
	Customer_ID,
	Customer_Name,
	MAX(Order_Date) AS Last_Order_Date,
	DATEDIFF (DAY, MAX(Order_Date), GETDATE()) AS Days_Since_Last_Order,
	CASE
		WHEN DATEDIFF (DAY, MAX(Order_Date), GETDATE()) < 0 THEN 'NULL'
		WHEN DATEDIFF (DAY, MAX(Order_Date), GETDATE()) <= 30 THEN '0-30 days'
		WHEN DATEDIFF (DAY, MAX(Order_Date), GETDATE()) <= 60 THEN '31-60 days'
		WHEN DATEDIFF (DAY, MAX(Order_Date), GETDATE()) <= 90 THEN '61-90 days'
		ELSE '90+ days'
	END AS Recency_Bucket,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Profit), 2) AS Total_Profit
FROM dbo.superstore
GROUP BY Customer_ID, Customer_Name
),

/*
----------------------------------------------------------------------------
Step 3: Frequency Analysis

Objective:
Measure how often each customer places orders.

Purpose:
Customers who purchase more frequently generally demonstrate stronger
engagement and higher loyalty.

Frequency analysis helps distinguish repeat customers from occasional
buyers.
----------------------------------------------------------------------------
*/

Freq_Analysis AS (
SELECT
	Customer_ID,
	Customer_Name,
	CASE
		WHEN COUNT(DISTINCT Order_ID) = 1 THEN '1 order'
		WHEN COUNT(DISTINCT Order_ID) <= 5 THEN '2-5 orders'
		WHEN COUNT(DISTINCT Order_ID) <= 10 THEN '6-10 orders'
		ELSE '10+ orders'
	END AS Frequency_Bucket,
	COUNT(DISTINCT Order_ID) AS Total_Orders,
	ROUND(SUM(Sales), 2) AS Total_Sales,
	ROUND(SUM(Profit), 2) AS Total_Profit
FROM dbo.superstore
GROUP BY Customer_ID, Customer_Name
)

/*
----------------------------------------------------------------------------
Step 4: Identify VIP Customers

Objective:
Combine Recency, Frequency, and Monetary metrics to identify customers
who provide the greatest business value.

VIP Customer Criteria:

• Purchased within the last 30 days
• Placed at least 5 orders
• Generated more than $1,000 in sales

These thresholds are used to identify highly engaged, high-value
customers who are ideal candidates for loyalty programs, personalized
marketing campaigns, and long-term retention initiatives.
----------------------------------------------------------------------------
*/

SELECT
	Rec_Analysis.Customer_ID,
	Rec_Analysis.Recency_Bucket,
	Freq_Analysis.Frequency_Bucket,
	Rec_Analysis.Days_Since_Last_Order AS Recency_Value,
	Freq_Analysis.Total_Orders AS Frequency_Value,
	Mon_Analysis.Total_Sales AS Monetary_Value
FROM Rec_Analysis 
LEFT JOIN Freq_Analysis 
	ON Rec_Analysis.Customer_ID = Freq_Analysis.Customer_ID
LEFT JOIN Mon_Analysis 
	ON Rec_Analysis.Customer_ID = Mon_Analysis.Customer_ID
WHERE Rec_Analysis.Days_Since_Last_Order BETWEEN 0 AND 30 AND Freq_Analysis.Total_Orders >= 5 AND Mon_Analysis.Total_Sales >= 1000;

/*
===============================================================================
Business Insight:

The RFM analysis identified customers who are both highly engaged and
financially valuable to the business.

These customers have purchased recently, order frequently, and contribute
significantly to overall revenue.

Retaining these customers is critical because acquiring a new customer is
typically more expensive than retaining an existing one.

Recommended Actions:
• Offer exclusive loyalty rewards.
• Provide early access to new products.
• Personalize promotional campaigns.
• Monitor purchasing behavior to reduce customer churn.

===============================================================================
*/

/*
===============================================================================
Summary

Key analyses completed in this file:

✓ Customer Segment Performance
✓ Top 10 Customers by Revenue
✓ Repeat vs One-Time Customers
✓ Pareto Analysis (Top 20% Customers)
✓ VIP Customer Analysis (RFM)

These analyses identify the company's most valuable customers,
measure customer loyalty,
and highlight opportunities to improve customer retention
and long-term business growth.

===============================================================================
*/

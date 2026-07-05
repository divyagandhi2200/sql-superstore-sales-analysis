/*
===============================================================================
                         DATA EXPLORATION
===============================================================================

Project : Superstore Sales Analysis

Description:
Before performing business analysis, it is important to understand the
structure, quality, and overall characteristics of the dataset.

The exploratory analysis in this file answers questions such as:

• How large is the dataset?
• How many customers and products exist?
• What is the reporting period?
• Which business dimensions are available?
• Are there any missing values?
• Is the data suitable for further analysis?

===============================================================================
*/

/*
===============================================================================
Business Question:
How many records are available in the dataset?

Objective:
Determine the total number of transactions available for analysis.

Business Value:
This confirms the dataset size and verifies that the data has been
imported successfully.

===============================================================================
*/

SELECT
    COUNT(*) AS Total_Records
FROM dbo.superstore;

/*
===============================================================================
Business Question:
What are the overall business KPIs?

Objective:
Calculate the company's overall sales, profit, and total number of orders.

Business Value:
These KPIs provide an executive summary of business performance before
performing detailed analysis.

===============================================================================
*/

SELECT
    ROUND(SUM(Sales),2) AS Total_Sales,
    ROUND(SUM(Profit),2) AS Total_Profit,
    COUNT(DISTINCT Order_ID) AS Total_Orders
FROM dbo.superstore;

/*
===============================================================================
Business Question:
How many unique customers does the company serve?

Objective:
Determine the size of the customer base.

Business Value:
Understanding the customer base helps evaluate market reach and supports
future customer segmentation analysis.

===============================================================================
*/

SELECT
    COUNT(DISTINCT Customer_ID) AS Total_Customers
FROM dbo.superstore;

/*
===============================================================================
Business Question:
How many unique products are available?

Objective:
Determine the size of the product catalog.

Business Value:
Understanding the number of products provides context for product
performance and inventory analysis.

===============================================================================
*/

SELECT
    COUNT(DISTINCT Product_Name) AS Total_Products
FROM dbo.superstore;

/*
===============================================================================
Business Question:
Which product categories are available?

Objective:
Identify all product categories included in the dataset.

Business Value:
These categories will be used throughout the project to compare
sales, profit, and profitability.

===============================================================================
*/

SELECT DISTINCT
    Category
FROM dbo.superstore
ORDER BY Category;

/*
===============================================================================
Business Question:
Which product sub-categories are available?

Objective:
Identify the detailed product classifications within each category.

Business Value:
Sub-categories provide deeper insights into product-level performance.

===============================================================================
*/

SELECT DISTINCT
    Sub_Category
FROM dbo.superstore
ORDER BY Sub_Category;

/*
===============================================================================
Business Question:
Which customer segments exist?

Objective:
Identify the customer groups represented in the dataset.

Business Value:
Customer segments will later be analyzed to compare revenue,
profitability, and purchasing behavior.

===============================================================================
*/

SELECT DISTINCT
    Segment
FROM dbo.superstore
ORDER BY Segment;

/*
===============================================================================
Business Question:
Which regions are included in the dataset?

Objective:
Identify the geographical regions where business operations take place.

Business Value:
Regional analysis helps evaluate market performance across different
locations.

===============================================================================
*/

SELECT DISTINCT
    Region
FROM dbo.superstore
ORDER BY Region;

/*
===============================================================================
Business Question:
What is the reporting period covered by the dataset?

Objective:
Identify the first and last order dates.

Business Value:
Understanding the analysis period is essential before performing
time-series and trend analysis.

===============================================================================
*/

SELECT
    MIN(Order_Date) AS First_Order_Date,
    MAX(Order_Date) AS Last_Order_Date
FROM dbo.superstore;

/*
===============================================================================
Business Question:
Are there any missing values in critical business columns?

Objective:
Assess data quality before performing analysis.

Business Value:
Missing values may impact calculations and reduce the reliability
of business insights.

===============================================================================
*/

SELECT
    SUM(CASE WHEN Order_ID IS NULL THEN 1 
        ELSE 0 
        END) AS Missing_Order_ID,
    SUM(CASE WHEN Customer_ID IS NULL THEN 1 
        ELSE 0 
        END) AS Missing_Customer_ID,
    SUM(CASE WHEN Product_Name IS NULL THEN 1 
        ELSE 0 
        END) AS Missing_Product_Name,
    SUM(CASE WHEN Sales IS NULL THEN 1 
        ELSE 0  
        END) AS Missing_Sales,
    SUM(CASE WHEN Profit IS NULL THEN 1 
        ELSE 0 
        END) AS Missing_Profit
FROM dbo.superstore;

/*
===============================================================================
Key Business Takeaways

• The dataset was successfully explored and validated before analysis.
• Key business dimensions such as products, customers, categories,
  regions, and order dates were identified.
• The reporting period was confirmed, ensuring accurate time-based analysis.
• Data quality checks verified that critical fields contained no significant
  missing values, making the dataset suitable for reliable business insights.
• Exploratory analysis established a strong foundation for deeper sales,
  customer, product, and profitability analyses.

===============================================================================
*/

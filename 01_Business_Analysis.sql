/*
============================================================
Project : Financial Transaction Analytics & Fraud Insights
Author  : Ayushi Sahani
Tools   : PostgreSQL, Python, Power BI
Dataset : 5 Million Financial Transactions

Objective:
Analyze financial transactions to identify fraud patterns,
customer spending behavior, payment trends, and business insights.
============================================================
*/

/*============================================================
SECTION 1 : DATASET OVERVIEW
============================================================*/

-- Q1. Total number of transactions

SELECT COUNT(*) AS total_transactions
FROM banking.transactions;
-- Business Insight:
-- The dataset contains 5 million financial transactions.

------------------------------------------------------------

-- Q2. Count total features (columns)

SELECT COUNT(*) AS total_features
FROM information_schema.columns
WHERE table_schema = 'banking'
AND table_name = 'transactions';
-- Output:
-- Total Features = 24

-- Business Insight:
-- The dataset contains 24 features describing transaction,
-- customer, merchant, payment, device, and fraud information.

/*============================================================
Q3. Preview the Dataset
Business Question:
What does a typical financial transaction record look like?
============================================================*/

SELECT *
FROM banking.transactions
LIMIT 10;

-- Output:
-- Displays the first 10 transaction records with all 24 attributes.

-- Business Insight:
-- Inspecting sample records validates that the data has been
-- imported correctly and helps understand the available features.

/*============================================================
Q4. Identify Transaction Types
Business Question:
What types of financial transactions are processed?
============================================================*/

SELECT DISTINCT transaction_type
FROM banking.transactions
ORDER BY transaction_type;

-- Output:
-- deposit
-- payment
-- transfer
-- withdrawal

-- Business Insight:
-- The dataset contains four transaction types, enabling analysis
-- of customer behavior and fraud patterns across different activities.

/*============================================================
Q5. Identify Payment Channels
Business Question:
Which payment channels are available for customers?
============================================================*/

SELECT DISTINCT payment_channel
FROM banking.transactions
ORDER BY payment_channel;

-- Output:
-- ACH
-- card
-- UPI
-- wire_transfer

-- Business Insight:
-- Transactions are processed through multiple payment channels,
-- allowing channel-wise performance and fraud analysis.

/*============================================================
Q6. Count Merchant Categories
Business Question:
How many unique merchant categories exist?
============================================================*/

SELECT COUNT(DISTINCT merchant_category) AS merchant_categories
FROM banking.transactions;

-- Output:
-- Merchant Categories = 8

-- Business Insight:
-- Multiple merchant categories enable sector-wise transaction
-- and fraud analysis across different industries.

/*============================================================
Q7. Count Transaction Locations
Business Question:
How many unique transaction locations are available?
============================================================*/

SELECT COUNT(DISTINCT location) AS total_locations
FROM banking.transactions;

-- Output:
-- Total Locations = 8

-- Business Insight:
-- Geographic diversity in transactions enables location-wise
-- analysis of customer activity and fraud distribution.

/*============================================================
SECTION 2 : EXECUTIVE KPIs
============================================================*/

/*============================================================
Q8. Calculate Total Transaction Value
Business Question:
What is the total value of all financial transactions?
============================================================*/

SELECT
ROUND(SUM(amount::NUMERIC),2) AS total_transaction_value
FROM banking.transactions;

-- Output:
-- Total Transaction Value = 1794671343.82
-- Business Insight:
-- Represents the overall transaction value processed, serving
-- as a key indicator of business volume and financial activity.

/*============================================================
Q9. Calculate Average Transaction Value
Business Question:
What is the average value of a financial transaction?
============================================================*/

SELECT
ROUND(AVG(amount::NUMERIC),2) AS average_transaction_value
FROM banking.transactions;

-- Output:
-- Average Transaction Value = 358.93

-- Business Insight:
-- Average transaction value helps understand customer spending
-- behavior and supports anomaly detection.

/*============================================================
Q10. Identify Highest Transaction Value
Business Question:
What is the highest transaction recorded?
============================================================*/

SELECT
MAX(amount::NUMERIC) AS highest_transaction
FROM banking.transactions;

-- Output:
-- Highest Transaction = 3520.57
-- Business Insight:
-- Identifies the maximum transaction amount processed and helps
-- detect unusually high-value transactions.

/*============================================================
Q11. Identify Lowest Transaction Value
Business Question:
What is the lowest transaction recorded?
============================================================*/

SELECT
MIN(amount::NUMERIC) AS lowest_transaction
FROM banking.transactions;

-- Output:
-- Lowest Transaction = 0.01

-- Business Insight:
-- Determines the minimum transaction amount processed and helps
-- validate transaction limits and data quality.


/*============================================================
Q12. Calculate Median Transaction Value
Business Question:
What is the median transaction amount?
============================================================*/

SELECT
PERCENTILE_CONT(0.5)
WITHIN GROUP (ORDER BY amount::NUMERIC) AS median_transaction
FROM banking.transactions;

-- Output:
-- Median Transaction = 138.67

-- Business Insight:
-- The median is less affected by extreme values and better
-- represents the typical transaction amount.

/*============================================================
SECTION 3 : FRAUD ANALYSIS
============================================================*/

/*============================================================
Q13. Count Fraudulent and Genuine Transactions
Business Question:
How many transactions are fraudulent and genuine?
============================================================*/

SELECT
is_fraud,
COUNT(*) AS total_transactions
FROM banking.transactions
GROUP BY is_fraud
ORDER BY is_fraud;

-- Output:
-- False = 4820447
-- True  = 179553

-- Business Insight:
-- Provides the overall fraud distribution and helps quantify
-- the proportion of fraudulent transactions.

/*============================================================
Q14. Calculate Fraud Rate
Business Question:
What percentage of transactions are fraudulent?
============================================================*/

SELECT
ROUND(
100.0 * SUM(CASE WHEN is_fraud='True' THEN 1 ELSE 0 END)
/ COUNT(*),2
) AS fraud_rate_percentage
FROM banking.transactions;

-- Output:
-- Fraud Rate = 3.59 %

-- Business Insight:
-- Fraud rate is a key KPI used to assess financial risk and
-- monitor the effectiveness of fraud detection systems.

/*============================================================
Q15. Fraud by Payment Channel
Business Question:
Which payment channels experience the most fraud?
============================================================*/

SELECT
payment_channel,
COUNT(*) AS fraud_transactions
FROM banking.transactions
WHERE is_fraud='True'
GROUP BY payment_channel
ORDER BY fraud_transactions DESC;

-- Output:
-- wire_transfer = 45034
-- UPI           = 44896
-- Card          = 44885
-- ACH           = 44738

-- Business Insight:
-- Identifies payment channels with the highest fraud volume,
-- enabling targeted fraud prevention strategies.

/*============================================================
Q16. Fraud by Merchant Category
Business Question:
Which merchant categories report the highest fraud?
============================================================*/

SELECT
merchant_category,
COUNT(*) AS fraud_transactions
FROM banking.transactions
WHERE is_fraud='True'
GROUP BY merchant_category
ORDER BY fraud_transactions DESC;

-- Output:
-- entertainment = 22573
-- other         = 22556
-- grocery       = 22516
-- travel        = 22503
-- retail        = 22453
-- restaurant    = 22367
-- online        = 22324
-- utilities     = 22261

-- Business Insight:
-- Highlights merchant categories that are more susceptible
-- to fraudulent transactions.

/*============================================================
Q17. Fraud by Location
Business Question:
Which locations have the highest number of fraud cases?
============================================================*/

SELECT
location,
COUNT(*) AS fraud_transactions
FROM banking.transactions
WHERE is_fraud='True'
GROUP BY location
ORDER BY fraud_transactions DESC;

-- Output:
-- Toronto   : 22,501
-- London    : 22,478
-- Singapore : 22,461
-- New York  : 22,460
-- Sydney    : 22,458
-- Berlin    : 22,435
-- Tokyo     : 22,420
-- Dubai     : 22,340

-- Business Insight:
-- Reveals geographical fraud hotspots that may require
-- additional monitoring and security measures.

/*============================================================
Q18. Average Fraud Transaction Amount
Business Question:
What is the average amount involved in fraudulent transactions?
============================================================*/

SELECT
ROUND(AVG(amount::NUMERIC),2) AS average_fraud_amount
FROM banking.transactions
WHERE is_fraud='True';

-- Output:
-- Average Fraud Amount = 358.53

-- Business Insight:
-- Helps estimate the financial impact of an average fraud case
-- and supports risk assessment.

/*============================================================
SECTION 4 : CUSTOMER & TRANSACTION ANALYSIS
============================================================*/
/*============================================================

Q19. Most Used Payment Channels
Business Question:
Which payment channels are used most frequently?
============================================================*/

SELECT
payment_channel,
COUNT(*) AS total_transactions
FROM banking.transactions
GROUP BY payment_channel
ORDER BY total_transactions DESC;

-- Output:
-- wire_transfer : 1251219
-- ACH           : 1250241
-- card          : 1249693
-- UPI           : 1248847

-- Business Insight:
-- Identifies the most preferred payment channels and helps
-- understand customer payment preferences.

/*============================================================
Q20. Transaction Volume by Merchant Category
Business Question:
Which merchant categories process the highest transaction volume?
============================================================*/

SELECT
merchant_category,
COUNT(*) AS total_transactions
FROM banking.transactions
GROUP BY merchant_category
ORDER BY total_transactions DESC;

-- Output:
-- Retail         : 626,319
-- Travel         : 625,656
-- Restaurant     : 625,483
-- Entertainment  : 625,332
-- Grocery        : 624,954
-- Other          : 624,589
-- Utilities      : 624,086
-- Online         : 623,581

-- Business Insight:
-- Highlights merchant categories with the highest customer
-- activity and transaction volume.

/*============================================================
Q21. Transaction Value by Merchant Category
Business Question:
Which merchant categories generate the highest transaction value?
============================================================*/

SELECT
merchant_category,
ROUND(SUM(amount::NUMERIC),2) AS total_transaction_value
FROM banking.transactions
GROUP BY merchant_category
ORDER BY total_transaction_value DESC;

-- Output:
-- Output:
-- Travel        : 224,741,389.37
-- Retail        : 224,709,269.46
-- Entertainment : 224,586,150.31

-- Business Insight:
-- Travel, Retail, and Entertainment generated the highest
-- transaction values, although transaction values remain
-- fairly balanced across all merchant categories.

/*============================================================
Q22. Average Transaction Amount by Payment Channel
Business Question:
Which payment channels have the highest average transaction value?
============================================================*/

SELECT
payment_channel,
ROUND(AVG(amount::NUMERIC),2) AS average_transaction_value
FROM banking.transactions
GROUP BY payment_channel
ORDER BY average_transaction_value DESC;

-- Output:
-- ACH    : 359.15
-- UPI    : 359.15
-- card   : 358.86
-- wire_transfer : 358.57

-- Business Insight:
-- Compares customer spending behavior across different
-- payment channels.

/*============================================================
Q23. Transaction Value by Location
Business Question:
Which locations contribute the highest transaction value?
============================================================*/

SELECT
location,
ROUND(SUM(amount::NUMERIC),2) AS total_transaction_value
FROM banking.transactions
GROUP BY location
ORDER BY total_transaction_value DESC;

-- Output:
-- Tokyo  : 225,649,626.07
-- Berlin : 224,551,955.00
-- Sydney : 224,479,895.50

-- Business Insight:
-- Identifies the locations contributing the largest share
-- of financial transactions.

/*============================================================
Q24. Average Transaction Amount by Location
Business Question:
Which locations have the highest average transaction value?
============================================================*/

SELECT
location,
ROUND(AVG(amount::NUMERIC),2) AS average_transaction_value
FROM banking.transactions
GROUP BY location
ORDER BY average_transaction_value DESC;

-- Output:
-- Tokyo  : 360.47
-- Berlin : 359.12
-- Sydney : 359.10

-- Key Finding:
-- Tokyo recorded the highest average transaction value (360.47),
-- while average transaction amounts remained highly consistent
--  across all locations.

/*============================================================
SECTION 5 : TIME-SERIES ANALYSIS
============================================================*/

/*============================================================
Q25. Monthly Transaction Volume
Business Question:
Which months record the highest transaction volume?
============================================================*/

SELECT
month,
COUNT(*) AS total_transactions
FROM banking.transactions
GROUP BY month
ORDER BY COUNT(*) DESC;

-- Output:
-- August   : 425,546
-- March    : 425,454
-- October  : 424,906

-- Key Finding:
-- August, March, and October recorded the highest transaction
-- volumes, while monthly activity remained fairly balanced
-- throughout the year.


/*============================================================
Q26. Monthly Transaction Value
Business Question:
Which months generate the highest transaction value?
============================================================*/

SELECT
month,
ROUND(SUM(amount::NUMERIC),2) AS total_transaction_value
FROM banking.transactions
GROUP BY month
ORDER BY total_transaction_value DESC;

-- Output:
-- December : 152,963,916.44
-- August   : 152,767,105.48
-- March    : 152,612,627.10

-- Key Finding:
-- December generated the highest transaction value, although
-- transaction values remained relatively consistent across
-- all months.

/*============================================================
Q27. Monthly Fraud Cases
Business Question:
Which months record the highest number of fraud cases?
============================================================*/

SELECT
month,
COUNT(*) AS fraud_transactions
FROM banking.transactions
WHERE is_fraud='True'
GROUP BY month
ORDER BY fraud_transactions DESC;

-- Output:
-- July      : 15,395
-- December  : 15,376
-- October   : 15,331

-- Key Finding:
-- Fraud incidents were distributed fairly evenly throughout
-- the year, with July recording the highest number of fraud
-- transactions.

/*============================================================
Q28. Transaction Volume by Day of Month
Business Question:
Which days of the month record the highest transaction volume?
============================================================*/

SELECT
day,
COUNT(*) AS total_transactions
FROM banking.transactions
GROUP BY day
ORDER BY total_transactions DESC;

-- Output:
-- Day 21 : 165,429
-- Day 4  : 164,933
-- Day 20 : 164,916

-- Key Finding:
-- Transaction volume remained evenly distributed across the
-- month, with the 21st recording the highest activity.

/*============================================================
Q29. Hourly Transaction Volume
Business Question:
At what hour do customers perform the most transactions?
============================================================*/

SELECT
hour,
COUNT(*) AS total_transactions
FROM banking.transactions
GROUP BY hour
ORDER BY total_transactions DESC;

-- Output:
-- 05:00 : 209,498
-- 10:00 : 209,166
-- 09:00 : 208,983

-- Key Finding:
-- Customer transaction activity was relatively uniform
-- throughout the day, with the highest volume occurring
-- around 5 AM.


/*============================================================
Q30. Hourly Fraud Cases
Business Question:
At what hour are fraud cases most frequent?
============================================================*/

SELECT
hour,
COUNT(*) AS fraud_transactions
FROM banking.transactions
WHERE is_fraud='True'
GROUP BY hour
ORDER BY fraud_transactions DESC;

-- Output:
-- 08:00 : 7,627
-- 12:00 : 7,621
-- 05:00 : 7,580

-- Key Finding:
-- Fraud transactions were fairly evenly distributed across
-- all hours, with a slight increase during the morning hours.

/*============================================================
SECTION 6 : ADVANCED SQL ANALYTICS
============================================================*/

/*============================================================
Q31. Rank Merchant Categories by Transaction Value
Business Question:
How do merchant categories rank based on total transaction value?
============================================================*/

SELECT
merchant_category,
ROUND(SUM(amount::NUMERIC),2) AS total_transaction_value,
RANK() OVER (
ORDER BY SUM(amount::NUMERIC) DESC
) AS merchant_rank
FROM banking.transactions
GROUP BY merchant_category;

-- Output:
-- Travel         : 224,741,389.37 (Rank 1)
-- Retail         : 224,709,269.46 (Rank 2)
-- Entertainment  : 224,586,150.31 (Rank 3)

-- Key Finding:
-- Travel ranked first in total transaction value, followed closely
-- by Retail and Entertainment, indicating a balanced revenue
-- contribution across merchant categories.

/*============================================================
Q32. Rank Locations by Fraud Transactions
Business Question:
Which locations rank highest in fraud cases?
============================================================*/

SELECT
location,
COUNT(*) AS fraud_transactions,
RANK() OVER (
ORDER BY COUNT(*) DESC
) AS fraud_rank
FROM banking.transactions
WHERE is_fraud='True'
GROUP BY location;

-- Output:
-- Toronto    : 22,501 (Rank 1)
-- London     : 22,478 (Rank 2)
-- Singapore  : 22,461 (Rank 3)

-- Key Finding:
-- Toronto recorded the highest number of fraudulent transactions,
-- although fraud cases remained fairly balanced across all
-- locations.

/*============================================================
Q33. Top 5 Highest Transactions
Business Question:
Which are the highest-value transactions in the dataset?
============================================================*/

SELECT
transaction_id,
sender_account,
receiver_account,
amount::NUMERIC,
RANK() OVER (
ORDER BY amount::NUMERIC DESC
) AS transaction_rank
FROM banking.transactions
LIMIT 5;

-- Output:
-- Rank 1 : T3297438 | 3,520.57
-- Rank 2 : T1209509 | 3,419.97
-- Rank 3 : T2331497 | 3,411.59
-- Rank 4 : T3636719 | 3,281.96
-- Rank 5 : T2514235 | 3,228.86

-- Key Finding:
-- The highest-value transactions exceeded 3,200 units,
-- highlighting potential candidates for high-value
-- transaction monitoring and anomaly detection.

/*============================================================
Q34. Payment Channel Contribution
Business Question:
What percentage of transactions does each payment channel contribute?
============================================================*/

SELECT
payment_channel,
COUNT(*) AS total_transactions,
ROUND(
100.0*COUNT(*)/
SUM(COUNT(*)) OVER (),
2
) AS percentage_share
FROM banking.transactions
GROUP BY payment_channel
ORDER BY percentage_share DESC;

-- Output:
-- Wire Transfer : 25.02%
-- ACH           : 25.00%
-- Card          : 24.99%
-- UPI           : 24.98%

-- Key Finding:
-- Transaction volume was almost equally distributed across
-- all payment channels, with Wire Transfer contributing the
-- highest share (25.02%).


/*============================================================
Q35. Running Monthly Transaction Value
Business Question:
How does cumulative transaction value grow over the year?
============================================================*/

WITH monthly_value AS
(
SELECT
month_number::INTEGER,
month,
ROUND(SUM(amount::NUMERIC),2) AS monthly_value
FROM banking.transactions
GROUP BY month_number,month
)

SELECT *,
SUM(monthly_value)
OVER(
ORDER BY month_number
) AS cumulative_transaction_value
FROM monthly_value
ORDER BY month_number;

-- Output:
-- January   : 152,052,196.83 | Cumulative: 152,052,196.83
-- February  : 137,326,562.08 | Cumulative: 289,378,758.91
-- March     : 152,612,627.10 | Cumulative: 441,991,386.01
-- ...
-- December  : 152,963,916.44 | Cumulative: 1,794,671,343.82

-- Key Finding:
-- The cumulative transaction value increased steadily
-- throughout the year, reaching approximately 1.79 billion
-- by December, indicating consistent transaction activity.


/*============================================================
Q36. Fraud Percentage by Merchant Category
Business Question:
Which merchant categories have the highest fraud percentage?
============================================================*/

SELECT
merchant_category,
ROUND(
100.0*
SUM(
CASE
WHEN is_fraud='True' THEN 1
ELSE 0
END
)
/COUNT(*),
2
) AS fraud_percentage
FROM banking.transactions
GROUP BY merchant_category
ORDER BY fraud_percentage DESC;

-- Output:
-- Entertainment : 3.61%
-- Other         : 3.61%
-- Grocery       : 3.60%

-- Key Finding:
-- Entertainment and Other recorded the highest fraud rates
-- (3.61%), although fraud percentages remained highly
-- consistent across all merchant categories.


/*============================================================
SECTION 7 : EXECUTIVE BUSINESS CASE STUDIES
============================================================*/

/*============================================================
Q37. High-Revenue High-Fraud Merchant Categories
Business Question:
Which merchant categories generate high revenue while also
having a high number of fraud cases?
============================================================*/

SELECT
merchant_category,
ROUND(SUM(amount::NUMERIC),2) AS total_revenue,
COUNT(CASE WHEN is_fraud='True' THEN 1 END) AS fraud_cases
FROM banking.transactions
GROUP BY merchant_category
ORDER BY total_revenue DESC, fraud_cases DESC;

-- Output:
-- Travel         : Revenue = 224,741,389.37 | Fraud Cases = 22,503
-- Retail         : Revenue = 224,709,269.46 | Fraud Cases = 22,453
-- Entertainment  : Revenue = 224,586,150.31 | Fraud Cases = 22,573

-- Key Finding:
-- Travel generated the highest transaction revenue, while
-- Entertainment recorded the highest fraud count among the
-- top revenue-generating merchant categories.

/*============================================================
Q38. Safest Payment Channel
Business Question:
Which payment channel has the lowest fraud rate?
============================================================*/

SELECT
payment_channel,
COUNT(*) AS total_transactions,
COUNT(CASE WHEN is_fraud='True' THEN 1 END) AS fraud_cases,
ROUND(
100.0*COUNT(CASE WHEN is_fraud='True' THEN 1 END)
/COUNT(*),2
) AS fraud_rate
FROM banking.transactions
GROUP BY payment_channel
ORDER BY fraud_rate;

-- Output:
-- ACH           : 1,250,241 Transactions | Fraud Rate = 3.58%
-- Card          : 1,249,693 Transactions | Fraud Rate = 3.59%
-- UPI           : 1,248,847 Transactions | Fraud Rate = 3.59%
-- Wire Transfer : 1,251,219 Transactions | Fraud Rate = 3.60%

-- Key Finding:
-- ACH recorded the lowest fraud rate (3.58%), although fraud
-- rates remained nearly identical across all payment channels.

/*============================================================
Q39. Highest Average Fraud Amount
Business Question:
Which merchant categories record the highest average fraud amount?
============================================================*/

SELECT
merchant_category,
ROUND(AVG(amount::NUMERIC),2) AS avg_fraud_amount
FROM banking.transactions
WHERE is_fraud='True'
GROUP BY merchant_category
ORDER BY avg_fraud_amount DESC;

-- Output:
-- Entertainment : 362.11
-- Grocery       : 360.51
-- Other         : 360.21

-- Key Finding:
-- Entertainment recorded the highest average fraudulent
-- transaction amount, followed closely by Grocery and Other.


/*============================================================
Q40. Fraud Loss by Payment Channel
Business Question:
Which payment channels contribute the highest fraud value?
============================================================*/

SELECT
payment_channel,
ROUND(SUM(amount::NUMERIC),2) AS fraud_loss
FROM banking.transactions
WHERE is_fraud='True'
GROUP BY payment_channel
ORDER BY fraud_loss DESC;

-- Output:
-- Card          : 16,124,295.08
-- Wire Transfer : 16,117,586.50
-- ACH           : 16,076,509.66
-- UPI           : 16,056,422.56

-- Key Finding:
-- Card payments contributed the highest fraud loss, although
-- fraud losses were distributed fairly evenly across all
-- payment channels.


/*============================================================
Q41. Highest Spending Locations
Business Question:
Which locations have the highest average transaction amount?
============================================================*/

SELECT
location,
ROUND(AVG(amount::NUMERIC),2) AS average_transaction
FROM banking.transactions
GROUP BY location
ORDER BY average_transaction DESC;

-- Output:
-- Tokyo     : 360.47
-- Berlin    : 359.12
-- Sydney    : 359.10

-- Key Finding:
-- Tokyo recorded the highest average transaction amount,
-- followed closely by Berlin and Sydney, indicating only
-- minor variations in spending across locations.

/*============================================================
Q42. Fraud Risk Ranking
Business Question:
Rank merchant categories based on fraud percentage.
============================================================*/

WITH fraud_summary AS
(
SELECT
merchant_category,
ROUND(
100.0*
SUM(CASE WHEN is_fraud='True' THEN 1 ELSE 0 END)
/COUNT(*),2
) AS fraud_percentage
FROM banking.transactions
GROUP BY merchant_category
)

SELECT *,
DENSE_RANK() OVER(
ORDER BY fraud_percentage DESC
) AS fraud_risk_rank
FROM fraud_summary;

-- Output:
-- Entertainment : 3.61% (Rank 1)
-- Other         : 3.61% (Rank 1)
-- Grocery       : 3.60% (Rank 2)

-- Key Finding:
-- Entertainment and Other shared the highest fraud risk rank,
-- while fraud percentages remained relatively consistent
-- across merchant categories.


/*============================================================
Q43. Monthly Fraud Trend
Business Question:
How does fraud activity change over the year?
============================================================*/

SELECT
month,
COUNT(*) AS fraud_cases
FROM banking.transactions
WHERE is_fraud='True'
GROUP BY month
ORDER BY COUNT(*) DESC;

-- Output:
-- July      : 15,395
-- December  : 15,376
-- October   : 15,331

-- Key Finding:
-- Fraud activity remained stable throughout the year, with
-- July recording the highest number of fraud cases.


/*============================================================
Q44. Top 10 Highest-Value Transactions
Business Question:
Which transactions require priority monitoring?
============================================================*/

SELECT
transaction_id,
amount::NUMERIC
FROM banking.transactions
ORDER BY amount::NUMERIC DESC
LIMIT 10;

-- Output:
-- Rank 1  : T3297438 | 3,520.57
-- Rank 2  : T1209509 | 3,419.97
-- Rank 3  : T2331497 | 3,411.59
-- Rank 4  : T3636719 | 3,281.96
-- Rank 5  : T2514235 | 3,228.86

-- Key Finding:
-- The top ten transactions exceeded 3,150 units, making them
-- suitable candidates for high-value transaction monitoring.

/*============================================================
Q45. Executive KPI Summary
Business Question:
What are the key performance indicators of the dataset?
============================================================*/

SELECT

COUNT(*) AS total_transactions,

ROUND(SUM(amount::NUMERIC),2) AS total_value,

ROUND(AVG(amount::NUMERIC),2) AS average_transaction,

COUNT(CASE WHEN is_fraud='True' THEN 1 END) AS fraud_transactions,

ROUND(
100.0*
COUNT(CASE WHEN is_fraud='True' THEN 1 END)
/COUNT(*),2
) AS fraud_rate

FROM banking.transactions;

-- Output:
-- Total Transactions : 5,000,000
-- Total Value        : 1,794,671,343.82
-- Average Value      : 358.93
-- Fraud Transactions : 179,553
-- Fraud Rate         : 3.59%

-- Key Finding:
-- The dataset contains 5 million financial transactions with
-- a total transaction value of approximately 1.79 billion.
-- Fraud transactions account for 3.59% of overall activity.

/*============================================================
PROJECT SUMMARY
============================================================*/

-- Key Conclusions

-- 1. The dataset contains over 5 million financial transactions
--    across multiple payment channels and merchant categories.

-- 2. Fraud transactions account for approximately 3.6% of all
--    transactions.

-- 3. Transaction volume and value remain relatively balanced
--    across merchants, payment channels, locations and months.

-- 4. Window Functions, CTEs, Ranking, Running Totals and
--    Business KPIs were used to perform advanced SQL analysis.

-- 5. Insights generated through SQL will be visualized using
--    Power BI for executive-level reporting.
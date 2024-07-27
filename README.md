# E-commerce
## I. Introduction
This project involves analyzing an eCommerce dataset using SQL on Google BigQuery. The dataset originates from the Google Analytics public dataset and includes data from an eCommerce website.

## II. Dataset access
To access the eCommerce dataset stored in a public Google BigQuery dataset, follow these steps:
* Log in to your Google Cloud Platform account and create a new project.
* Navigate to the BigQuery console and select your newly created project.
* In the navigation panel, select “Add Data” and then “Search a project.”
* Enter the project ID “bigquery-public-data.google_analytics_sample.ga_sessions” and click “Enter.”
* Click on the “ga_sessions_” table to open it.

## III. Exploring the Dataset
In this project, I will write eight queries in BigQuery based on the Google Analytics dataset. 
### Query 1: Calculate total visit, pageview, transaction for Jan, Feb and March 2017 (order by month)
* SQL code

![image](https://github.com/user-attachments/assets/5178b4fd-f6d9-407d-befc-3187f90dd663)
* query result

![image](https://github.com/user-attachments/assets/1e7191c5-9dce-4f14-8bea-1a287f6d2b0d)

### Query 2: Bounce rate per traffic source in July 2017
/* --Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
--Bounce session is the session that user does not raise any click after landing on the website */

* SQL code
![image](https://github.com/user-attachments/assets/a6da93d0-e0c2-41a5-8e50-1c3ff8d215c8)

* Query result
![image](https://github.com/user-attachments/assets/fc4d6b9d-aaaf-409a-b6a7-71fe6fc0ce6f)

### Query 3: Revenue by traffic source by week, by month in June 2017
/* Hint 1: separate month and week data then union all.
Hint 2: at time_type, you can [SELECT 'Month' as time_type] to print time_type column
Hint 3: use "productRevenue" to calculate revenue. You need to unnest hits and product to access productRevenue field (example at the end of page).
Hint 4: To shorten the result, productRevenue should be divided by 1000000 */

* SQL code
![image](https://github.com/user-attachments/assets/48de9bde-9a86-48e3-905d-465ed2a2ca80)

* Query result
![image](https://github.com/user-attachments/assets/d4a389c2-d9b2-4a79-8115-6272b2530313)

### Query 4: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
/* + fullVisitorId field is user id.
+ We have to  , UNNEST(hits) AS hits
  , UNNEST(hits.product) to access productRevenue"
Hint 1: purchaser: totals.transactions >=1; productRevenue is not null.
Hint 2: non-purchaser: totals.transactions IS NULL;  product.productRevenue is null 
Hint 3: Avg pageview = total pageview / number unique user. */

* SQL code
![image](https://github.com/user-attachments/assets/7d348ed0-fc63-40e5-ad4b-0c9b6c7aae7f)

* Query result
![image](https://github.com/user-attachments/assets/65fda789-f75d-48e9-b11c-bb5909efdb6d)

### Query 5: Average number of transactions per user that made a purchase in July 2017
/* Hint 1: purchaser: totals.transactions >=1; productRevenue is not null. fullVisitorId field is user id.
Hint 2: Add condition "product.productRevenue is not null" to calculate correctly */
* SQL Code
![image](https://github.com/user-attachments/assets/7056e941-70f2-441f-818d-eb88c883a8f5)

* Query result
![image](https://github.com/user-attachments/assets/a6e2bf90-04c1-410e-82a0-4d8fa9d80667)

### Query 6: Average amount of money spent per session. Only include purchaser data in July 2017
### Query 7: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
### Query 8: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.


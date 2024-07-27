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
https://github.com/DaiTran2210/E-commerce-/issues/1#issue-2433564517
![image](https://github.com/user-attachments/assets/5178b4fd-f6d9-407d-befc-3187f90dd663)

### Query 2: Bounce rate per traffic source in July 2017
### Query 3: Revenue by traffic source by week, by month in June 2017
### Query 4: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
### Query 5: Average number of transactions per user that made a purchase in July 2017
### Query 6: Average amount of money spent per session. Only include purchaser data in July 2017
### Query 7: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
### Query 8: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.


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
*SQL code

![image](https://github.com/user-attachments/assets/5178b4fd-f6d9-407d-befc-3187f90dd663)
* query result
* 
![image](https://github.com/user-attachments/assets/1e7191c5-9dce-4f14-8bea-1a287f6d2b0d)

### Query 2: Bounce rate per traffic source in July 2017
* SQL code
![image](https://github.com/user-attachments/assets/a6da93d0-e0c2-41a5-8e50-1c3ff8d215c8)

* Query result
![image](https://github.com/user-attachments/assets/fc4d6b9d-aaaf-409a-b6a7-71fe6fc0ce6f)

### Query 3: Revenue by traffic source by week, by month in June 2017
* SQL code
![image](https://github.com/user-attachments/assets/48de9bde-9a86-48e3-905d-465ed2a2ca80)

* Query result
![image](https://github.com/user-attachments/assets/d4a389c2-d9b2-4a79-8115-6272b2530313)

### Query 4: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.

* SQL code
![image](https://github.com/user-attachments/assets/05373264-0a4e-414f-9144-1e4650f5a7ee)

* Query result
  
### Query 5: Average number of transactions per user that made a purchase in July 2017
### Query 6: Average amount of money spent per session. Only include purchaser data in July 2017
### Query 7: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
### Query 8: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.


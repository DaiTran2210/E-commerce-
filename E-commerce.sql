/* eCommerce Project */
--query 1
SELECT 
  FORMAT_DATE("%Y%m",parse_date('%Y%m%d',date)) month,
  SUM(totals.visits) visits,
  sum(totals.pageviews) pageviews,
       sum(totals.transactions) transactions

FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*` 
where _table_suffix between '20170101' and '20170331'
group by month
order by month


--query 2 --Bounce rate per traffic source in July 2017 (Bounce_rate = num_bounce/total_visit) (order by total_visit DESC)
--Bounce session is the session that user does not raise any click after landing on the website

SELECT
    trafficSource.source,
    sum(totals.visits) total_visits,
    sum(totals.bounces) total_no_of_bounces,
    round(sum(totals.bounces)/sum(totals.visits)*100, 8) bounce_rate
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*` 
Where _table_suffix between '20170701' and '20170731'
GROUP BY trafficSource.source
ORDER BY total_visits DESC


/* 
Query 3: Revenue by traffic source by week, by month in June 2017
step 1: separate month and week data then union all.
step 2: at time_type, you can [SELECT 'Month' as time_type] to print time_type column
step 3: use "productRevenue" to calculate revenue. You need to unnest hits and product to access productRevenue field (example at the end of page).
step 4: To shorten the result, productRevenue should be divided by 1000000 */

select
    'week' time_type,
    format_date("%Y%W", parse_date('%Y%m%d', date)) week,
    trafficSource.source source,
    sum(totals.transactionRevenue)/1000000 revenue
from `bigquery-public-data.google_analytics_sample.ga_sessions_*`
where _table_suffix between '20170601' and '20170630'
group by week, source

union all

select
    'month' time_type,
    format_date("%Y%m", parse_date('%Y%m%d', date)) month,
    trafficSource.source source,
    sum(totals.transactionRevenue)/1000000 revenue
from `bigquery-public-data.google_analytics_sample.ga_sessions_*`
where _table_suffix between '20170601' and '20170630'
group by month, source
order by revenue desc  




/* 
Query 04: Average number of pageviews by purchaser type (purchasers vs non-purchasers) in June, July 2017.
"Note: 
+ fullVisitorId field is user id.
+ We have to  , UNNEST(hits) AS hits
  , UNNEST(hits.product) to access productRevenue"
step 1: purchaser: totals.transactions >=1; productRevenue is not null.
step 2: non-purchaser: totals.transactions IS NULL;  product.productRevenue is null 
step 3: Avg pageview = total pageview / number unique user. */

 
WITH non_purchaser as (
    SELECT
        FORMAT_DATE("%Y%m",PARSE_DATE('%Y%m%d',date)) as month,
        ROUND(sum(totals.pageviews)/count(distinct fullVisitorId),8) as avg_pageviews_non_purchaser
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`, 
        unnest(hits) hits,
        unnest(product) product
    Where 
        _table_suffix between '20170601' and '20170731'
        AND totals.transactions IS NULL
        and product.productRevenue is null
    GROUP BY month
)
, purchaser as (
    SELECT
        FORMAT_DATE("%Y%m",PARSE_DATE('%Y%m%d',date)) as month,
        ROUND(sum(totals.pageviews)/count(distinct fullVisitorId),8) as avg_pageviews_purchaser
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
        unnest(hits) hits,
        unnest(product) product
    Where 
        _table_suffix between '20170601' and '20170731'
        AND totals.transactions >= 1
        and productRevenue is not null
    GROUP BY month
)

SELECT
    non_purchaser.month,
    purchaser.avg_pageviews_purchaser,
    non_purchaser.avg_pageviews_non_purchaser
FROM non_purchaser
JOIN purchaser USING(month) 
ORDER BY month

-->
with 
purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      (sum(totals.pageviews)/count(distinct fullvisitorid)) as avg_pageviews_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
    ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions>=1
  and product.productRevenue is not null
  group by month
),

non_purchaser_data as(
  select
      format_date("%Y%m",parse_date("%Y%m%d",date)) as month,
      sum(totals.pageviews)/count(distinct fullvisitorid) as avg_pageviews_non_purchase,
  from `bigquery-public-data.google_analytics_sample.ga_sessions_2017*`
      ,unnest(hits) hits
    ,unnest(product) product
  where _table_suffix between '0601' and '0731'
  and totals.transactions is null
  and product.productRevenue is null
  group by month
)

select
    pd.*,
    avg_pageviews_non_purchase
from purchaser_data pd
full join non_purchaser_data using(month)
order by pd.month;




/* Query 05: Average number of transactions per user that made a purchase in July 2017
step 1: purchaser: totals.transactions >=1; productRevenue is not null. fullVisitorId field is user id.
step 2: Add condition "product.productRevenue is not null" to calculate correctly */

SELECT
    FORMAT_DATE("%Y%m",PARSE_DATE('%Y%m%d',date)) as Month,
    sum(totals.transactions)/count(distinct fullVisitorId) as Avg_total_transactions_per_user
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    unnest(hits) hits,
    unnest(product) product
Where 
    _table_suffix between '20170701' and '20170731'
    AND totals.transactions >= 1
    and productRevenue is not null
GROUP BY month



/* Query 06: Average amount of money spent per session. Only include purchaser data in July 2017
step 1: Where clause must be include "totals.transactions IS NOT NULL" and "product.productRevenue is not null"
step 2: avg_spend_per_session = total revenue/ total visit
step 3: To shorten the result, productRevenue should be divided by 1000000
***Notice: per visit is different to per visitor */

select 
  format_date("%Y%m", parse_date('%Y%m%d', date)) month,
  round(sum(product.productRevenue)/count(totals.visits)/1000000, 2) avg_spend_per_session,
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
  unnest(hits) hits,
  unnest(product) product
Where _table_suffix between '20170701' and '20170731'
  and totals.transactions IS NOT NULL
  and product.productRevenue is not null
group by month



/* Query 07: Other products purchased by customers who purchased product "YouTube Men's Vintage Henley" in July 2017. Output should show product name and the quantity was ordered.
"Step 1: We have to   , UNNEST(hits) AS hits
  , UNNEST(hits.product) as product to get v2ProductName."
step 2: Add condition "product.productRevenue is not null" to calculate correctly
step 3: Using productQuantity to calculate quantity. */

with product as(
    select
        fullVisitorId,
        product.v2ProductName,
        product.productRevenue,
        product.productQuantity 
    from `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
        unnest(hits) as hits,
        unnest(hits.product) as product
    where
        _table_suffix between '20170701' and '20170731'
        and product.productRevenue is not null
)

select
    product.v2ProductName as other_purchased_products,
    sum(product.productQuantity) as quantity
from product
where
    product.fullVisitorId in (
        select fullVisitorId
        from product
        where product.v2ProductName = "YouTube Men's Vintage Henley"
    )
    and product.v2ProductName <> "YouTube Men's Vintage Henley"
group by other_purchased_products
order by quantity desc


select
    product.v2productname as other_purchased_product,
    sum(product.productQuantity) as quantity
from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
    unnest(hits) as hits,
    unnest(hits.product) as product
where fullvisitorid in (select distinct fullvisitorid
                        from `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`,
                        unnest(hits) as hits,
                        unnest(hits.product) as product
                        where product.v2productname = "YouTube Men's Vintage Henley"
                        and product.productRevenue is not null)
and product.v2productname != "YouTube Men's Vintage Henley"
and product.productRevenue is not null
group by other_purchased_product
order by quantity desc;

--CTE:

with buyer_list as(
    SELECT
        distinct fullVisitorId
    FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
    , UNNEST(hits) AS hits
    , UNNEST(hits.product) as product
    WHERE product.v2ProductName = "YouTube Men's Vintage Henley"
    AND totals.transactions>=1
    AND product.productRevenue is not null
)

SELECT
  product.v2ProductName AS other_purchased_products,
  SUM(product.productQuantity) AS quantity
FROM `bigquery-public-data.google_analytics_sample.ga_sessions_201707*`
, UNNEST(hits) AS hits
, UNNEST(hits.product) as product
JOIN buyer_list using(fullVisitorId)
WHERE product.v2ProductName != "YouTube Men's Vintage Henley"
 and product.productRevenue is not null
GROUP BY other_purchased_products
ORDER BY quantity DESC;




/* "Query 08: Calculate cohort map from product view to addtocart to purchase in Jan, Feb and March 2017. For example, 100% product view then 40% add_to_cart and 10% purchase.
Add_to_cart_rate = number product  add to cart/number product view. Purchase_rate = number product purchase/number product view. The output should be calculated in product level."
step 1: hits.eCommerceAction.action_type = '2' is view product page; hits.eCommerceAction.action_type = '3' is add to cart; hits.eCommerceAction.action_type = '6' is purchase
step 2: Add condition "product.productRevenue is not null"  for purchase to calculate correctly
step 3: To access action_type, you only need unnest hits */

with product_view as (
  select
    format_date("%Y%m", parse_date('%Y%m%d', date)) as month,
    count(product.productSKU) as num_product_view
  from `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    unnest(hits) as hits,
    unnest(product) as product
  where
    _table_suffix between '20170101' and '20170331'
    and eCommerceAction.action_type = '2'
    
  group by month
)

, add_to_cart as (
  select 
    format_date("%Y%m", parse_date('%Y%m%d', date)) as month,
    count(product.productSKU) as num_add_to_cart
  from `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    unnest(hits) as hits,
    unnest(product) as product
  where
    _table_suffix between '20170101' and '20170331'
    and eCommerceAction.action_type = '3'
  group by month
)  

, purchase as (
  select 
    format_date("%Y%m", parse_date('%Y%m%d', date)) as month,
    count(product.productSKU) as num_purchase
  from `bigquery-public-data.google_analytics_sample.ga_sessions_*`,
    unnest(hits) as hits,
    unnest(product) as product
  where
    _table_suffix between '20170101' and '20170331'
    and eCommerceAction.action_type = '6'
    and totals.transactions IS NOT NULL
    and product.productRevenue is not null
    
  group by month
)



select
  product_view.month,
  product_view.num_product_view,
  add_to_cart.num_add_to_cart,
  purchase.num_purchase,
  round((num_add_to_cart/num_product_view)*100,2) as add_to_cart_rate,
  round((num_purchase/num_product_view)*100,2) as purchase_rate
from product_view
join add_to_cart using(month)  --> left join
join purchase using(month)     --> left join
order by month



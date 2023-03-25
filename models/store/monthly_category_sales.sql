{{ config(
    materialized='incremental',
    cluster_by=['store_number', 'category'],
    incremental_strategy = 'insert_overwrite'
    )
}}

with source_data as (

SELECT  
  store_number,
  APPROX_TOP_COUNT(store_name, 1)[safe_offset(0)].value AS store_name,
  category,
  APPROX_TOP_COUNT(category_name, 1)[safe_offset(0)].value AS category_name,
  DATE(extract(year from date), extract(month from date), 1)  as sales_month,
  count(distinct(invoice_and_item_number)) as num_purchases,
  count(distinct(item_number)) as num_unique_items, 
  sum(sale_dollars) as total_sales,
  sum(volume_sold_gallons) as total_gallons,
  sum(volume_sold_liters) as total_liters,
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY store_number, category, sales_month
ORDER BY sales_month, total_sales desc
)

select *
from source_data
{{ config(materialized='table') }}

with source_data as (

SELECT  
  category, 
  count(distinct(category_name)) as num_names,
  APPROX_TOP_COUNT(category_name, 1)[safe_offset(0)].value AS category_name,
  APPROX_TOP_COUNT(category_name, 5) AS top_five_names,
  count(distinct(item_number)) as num_unique_items, 
  sum(sale_dollars) as total_sales 
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY category
ORDER BY total_sales desc

)

select *
from source_data
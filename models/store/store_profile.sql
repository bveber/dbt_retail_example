/*
    This will override configurations stated in dbt_project.yml
*/
{{ config(materialized='view') }}

with source_data as (

SELECT  
  store_number,
  APPROX_TOP_COUNT(store_name, 1)[safe_offset(0)].value AS store_name,
  count(distinct(date_trunc(date, MONTH))) as num_months,
  min(date) as min_date,
  max(date) as max_date,
  count(distinct(category)) as num_unique_categrories, 
  count(distinct(item_number)) as num_unique_items, 
  sum(sale_dollars) as total_sales,
  sum(volume_sold_gallons) as total_gallons,
  sum(volume_sold_liters) as total_liters,
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY store_number
ORDER BY num_months desc

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
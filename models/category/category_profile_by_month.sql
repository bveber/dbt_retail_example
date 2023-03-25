/*
    This will override configurations stated in dbt_project.yml
*/
{{ config(materialized='view') }}

with source_data as (

SELECT  
  category,
  extract(year from date) as sales_year,
  extract(month from date) as sales_month,
  APPROX_TOP_COUNT(category_name, 1)[safe_offset(0)].value AS category_name,
  count(distinct(item_number)) as num_unique_items, 
  sum(sale_dollars) as total_sales 
FROM `bigquery-public-data.iowa_liquor_sales.sales` 
GROUP BY category, sales_year, sales_month
ORDER BY sales_year desc, sales_month desc, total_sales desc

)

select *
from source_data

/*
    Uncomment the line below to remove records with null `id` values
*/

-- where id is not null
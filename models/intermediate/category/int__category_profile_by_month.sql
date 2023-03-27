WITH source_data AS (

SELECT  
  category,
  APPROX_TOP_COUNT(category_name, 1)[safe_offset(0)].value AS category_name,
  DATE_TRUNC(CURRENT_DATE(), MONTH) as sales_month,
  COUNT(DISTINCT(item_number)) AS num_unique_items, 
  COUNT(DISTINCT(store_number)) AS num_unique_stores, 
  SUM(sale_dollars) AS total_sales,
  SUM(volume_sold_gallons) as total_gallons
FROM {{ ref('stg__iowa_liquor_sales') }}
GROUP BY category, sales_year, sales_month
ORDER BY sales_year desc, sales_month desc, total_sales desc

)

SELECT *
FROM source_data
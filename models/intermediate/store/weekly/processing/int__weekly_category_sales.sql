WITH source_data AS (

SELECT  
  store_number,
  APPROX_TOP_COUNT(store_name, 1)[safe_offset(0)].value AS store_name,
  category,
  APPROX_TOP_COUNT(category_name, 1)[safe_offset(0)].value AS category_name,
  DATE_TRUNC(date, WEEK(MONDAY)) as sales_week,
  COUNT(DISTINCT(invoice_and_item_number)) AS num_purchases,
  COUNT(DISTINCT(item_number)) AS num_unique_items, 
  SUM(sale_dollars) AS total_sales,
  SUM(volume_sold_gallons) AS total_gallons,
  SUM(volume_sold_liters) AS total_liters,
FROM {{ ref('stg__iowa_liquor_sales') }}
GROUP BY store_number, category, sales_week
ORDER BY sales_week, total_sales desc

)

SELECT *
FROM source_data
WITH source_data AS (

SELECT  
  category, 
  COUNT(DISTINCT(category_name)) AS num_names,
  APPROX_TOP_COUNT(category_name, 1)[safe_offset(0)].value AS category_name,
  APPROX_TOP_COUNT(category_name, 5) AS top_five_names,
  COUNT(DISTINCT(item_number)) AS num_unique_items, 
  COUNT(DISTINCT(store_number)) AS num_unique_stores,
  SUM(sale_dollars) AS total_sales,
  SUM(volume_sold_gallons) as total_gallons
FROM {{ ref('stg__iowa_liquor_sales') }}
GROUP BY category
ORDER BY total_sales desc
)

SELECT *
FROM source_data
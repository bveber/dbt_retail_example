WITH source_data AS (

SELECT  
  category,
  EXTRACT(year FROM date) AS sales_year,
  EXTRACT(month FROM date) AS sales_month,
  APPROX_TOP_COUNT(category_name, 1)[safe_offset(0)].value AS category_name,
  COUNT(DISTINCT(item_number)) AS num_unique_items, 
  SUM(sale_dollars) AS total_sales 
FROM {{ ref('stg__iowa_liquor_sales') }}
GROUP BY category, sales_year, sales_month
ORDER BY sales_year desc, sales_month desc, total_sales desc

)

SELECT *
FROM source_data
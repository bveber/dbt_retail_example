WITH min_max_dates AS (

SELECT 
    MIN(sales_week) AS min_date,
    max(sales_week) AS max_date
FROM {{ ref('int__weekly_category_sales') }}

),
base AS (

SELECT distinct
    s.store_number,
    s.store_name,
    s.category,
    s.category_name,
    m AS sales_week
FROM {{ ref('int__weekly_category_sales') }} s,
UNNEST(
    GENERATE_DATE_ARRAY((SELECT min_date FROM min_max_dates), (SELECT max_date FROM min_max_dates), INTERVAL 1 WEEK)
) m

),
filled AS (

SELECT 
  base.*,
  s.num_purchases,
  s.num_unique_items, 
  s.total_sales,
  s.total_gallons,
  s.total_liters,
FROM base 
LEFT JOIN {{ ref('int__weekly_category_sales') }} s
  ON s.store_number = base.store_number
  AND s.category = base.category
  AND s.sales_week = base.sales_week

)
SELECT * FROM filled
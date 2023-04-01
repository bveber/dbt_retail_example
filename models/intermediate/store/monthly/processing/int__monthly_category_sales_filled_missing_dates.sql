{{ config(
    materialized="table",
    partition_by={
      "field": "sales_month",
      "data_type": "date",
      "granularity": "month",
    },
    cluster_by=["store_number", "category"]
) }}

WITH min_max_dates AS (

SELECT 
    MIN(sales_month) AS min_date,
    max(sales_month) AS max_date
FROM {{ ref('int__monthly_category_sales') }}

),
unique_stores AS (

SELECT distinct store_number
FROM {{ ref('int__monthly_category_sales') }}

),
unique_categories as (

SELECT distinct category
FROM {{ ref('int__monthly_category_sales') }}

),
base AS (

SELECT distinct
    unique_stores.store_number,
    unique_categories.category,

    m AS sales_month
FROM 
  unique_stores,
  unique_categories,
  UNNEST(
      GENERATE_DATE_ARRAY((SELECT min_date FROM min_max_dates), (SELECT max_date FROM min_max_dates), INTERVAL 1 MONTH)
  ) m

),
filled AS (

SELECT 
  base.store_number,
  sp.store_name,
  base.category,
  cp.category_name,

  s.num_purchases,
  s.num_unique_items, 
  s.total_sales,
  s.total_gallons,
  s.total_liters,

  base.sales_month,
FROM base 
LEFT JOIN {{ ref('int__monthly_category_sales') }} s
  ON s.store_number = base.store_number
  AND s.category = base.category
  AND s.sales_month = base.sales_month
JOIN {{ ref('int__store_profiles') }} sp 
ON sp.store_number = base.store_number
JOIN {{ ref('int__category_profiles') }} cp
ON cp.category = base.category

)
SELECT * FROM filled
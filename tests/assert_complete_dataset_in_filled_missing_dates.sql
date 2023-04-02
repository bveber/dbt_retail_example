WITH combo_counts as (

SELECT count(distinct store_number) * count(distinct category) * count(distinct sales_month) as cnt
FROM {{ ref('int__monthly_category_sales') }}

),
record_counts as (

SELECT count(*) as cnt 
FROM {{ ref('int__monthly_category_sales_filled_missing_dates') }}

)
SELECT 1 
FROM combo_counts, record_counts
WHERE combo_counts.cnt != record_counts.cnt
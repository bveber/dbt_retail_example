{{ config(
    materialized='table',
    cluster_by=['store_number', 'category']
    )
}}

WITH min_max_dates as (
  SELECT 
    min(sales_month) as min_date,
    max(sales_month) as max_date
    from {{ ref('monthly_category_sales') }}
),
base as (
    select distinct
      s.store_number,
      s.store_name,
      s.category,
      s.category_name,
      m as sales_month
    from {{ ref('monthly_category_sales') }} s,
    UNNEST(
        GENERATE_DATE_ARRAY((select min_date from min_max_dates), (select max_date from min_max_dates), INTERVAL 1 MONTH)
    ) m
),
filled as (
select 
  base.*,
  s.num_purchases,
  s.num_unique_items, 
  s.total_sales,
  s.total_gallons,
  s.total_liters,
  from base 
  left join {{ ref('monthly_category_sales') }} s
  on s.store_number = base.store_number
  and s.category = base.category
  and s.sales_month = base.sales_month
)
select * from filled
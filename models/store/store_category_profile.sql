{{ config(
    materialized='view'
    )
}}
with profiles as (
    select 
        store_number,
        store_name,
        category,
        category_name,
        count(*) as num_months,
        min(sales_month) as min_date,
        max(sales_month) as max_date
    from {{ ref('monthly_category_sales') }}
    group BY
        store_number, store_name,
        category, category_name
)
select * from profiles
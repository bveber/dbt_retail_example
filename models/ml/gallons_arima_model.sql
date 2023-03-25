{{
    config(
        materialized='model',
        ml_config={
            'model_type': 'ARIMA_PLUS',
            'time_series_timestamp_col': 'sales_month',
            'time_series_data_col': 'total_gallons',
            'time_series_id_col': ['store_number', 'category'],
            'horizon': 12,
            'data_frequency': 'MONTHLY'
        }
    )
}}


SELECT
   store_number, 
   category, 
   sales_month, 
   case when total_gallons is null then 0 else total_gallons end as total_gallons
FROM
  {{ ref('monthly_category_sales_filled_missing_dates') }}
WHERE store_number='4004'
and category is not null
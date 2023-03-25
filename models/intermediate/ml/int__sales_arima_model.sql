{{
    config(
        materialized='model',
        ml_config={
            'model_type': 'ARIMA_PLUS',
            'time_series_timestamp_col': 'sales_month',
            'time_series_data_col': 'total_sales',
            'time_series_id_col': ['store_number', 'category'],
            'horizon': 12,
            'data_frequency': 'MONTHLY'
        }
    )
}}

WITH model AS (

SELECT
   store_number, 
   category, 
   sales_month, 
   CASE WHEN total_sales IS NULL THEN 0 ELSE total_sales END AS total_sales
FROM
  {{ ref('int__monthly_category_sales_filled_missing_dates') }}
WHERE store_number='4004'
AND category IS NOT NULL

)

SELECT * 
FROM model
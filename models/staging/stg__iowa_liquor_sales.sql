WITH source_data as (
    SELECT * 
    FROM `bigquery-public-data.iowa_liquor_sales.sales` 
)
SELECT * FROM source_data
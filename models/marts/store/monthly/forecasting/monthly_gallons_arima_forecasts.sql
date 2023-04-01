{% set partitions_to_replace = [
  'DATE_TRUNC(CURRENT_DATE(), MONTH)'
] %}

{{ config(
    materialized="incremental",
    incremental_strategy = 'insert_overwrite',
    partition_by={
      "field": "forecast_generation_date",
      "data_type": "date",
      "granularity": "month",
    },
    partitions = partitions_to_replace
) }}

WITH source_data AS (

<<<<<<<< HEAD:models/marts/store/monthly/forecasting/monthly_category_gallons_forecasts.sql
SELECT 
  *,
  DATE_TRUNC(CURRENT_DATE(), MONTH) AS forecast_generation_date
FROM {{ ref('int__monthly_category_gallons_forecasts') }}
========
SELECT *
FROM {{ ref('int__monthly_gallons_arima_forecasts') }}
>>>>>>>> b7b46d77738887a285bbc5dfe174182dd4c3fb57:models/marts/store/monthly/forecasting/monthly_gallons_arima_forecasts.sql

)

SELECT *
FROM source_data
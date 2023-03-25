WITH source_data AS (

SELECT * 
FROM {{ ref('int__sales_arima_forecast') }}

)

SELECT *
FROM source_data
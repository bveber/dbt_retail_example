WITH source_data AS (

SELECT * 
FROM {{ ref('int__gallons_arima_forecast') }}

)

SELECT *
FROM source_data
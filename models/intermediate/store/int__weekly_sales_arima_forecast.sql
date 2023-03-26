WITH forecasts AS (

SELECT 
    s.store_name,
    c.category_name,
    p.*,
    CASE WHEN p.forecast_value < 0 THEN 0 ELSE p.forecast_value END AS forecast_value_floor,
    DATE_TRUNC(CURRENT_DATE(), MONTH) AS forecast_generation_date
FROM {{ iowa_liquor_sales.my_forecast(ref('int__weekly_sales_arima_model')) }} p
JOIN {{ ref('int__category_profile') }} c
    ON c.category = p.category
JOIN {{ ref('int__store_profile') }} s
    ON s.store_number=p.store_number

)

SELECT * 
FROM forecasts
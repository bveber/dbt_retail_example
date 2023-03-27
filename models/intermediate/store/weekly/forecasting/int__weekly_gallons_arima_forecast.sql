WITH forecasts AS (

SELECT 
    s.store_name,
    c.category_name,
    p.store_number,
    p.category,
    p.forecast_timestamp,
    p.forecast_value,
    p.standard_error,
    p.confidence_level,
    p.prediction_interval_lower_bound,
    p.prediction_interval_upper_bound,
    p.confidence_interval_lower_bound,
    p.confidence_interval_upper_bound,
    CASE WHEN p.forecast_value < 0 THEN 0 ELSE p.forecast_value END AS forecast_value_floor,
    DATE_TRUNC(CURRENT_DATE(), MONTH) AS forecast_generation_date
FROM {{ iowa_liquor_sales.my_forecast(ref('int__weekly_gallons_arima_model'), '12') }} p
JOIN {{ ref('int__category_profile') }} c
    ON c.category = p.category
JOIN {{ ref('int__store_profile') }} s
    ON s.store_number=p.store_number
)

SELECT * FROM forecasts
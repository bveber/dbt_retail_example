with forecasts as (
    select 
        s.store_name,
        c.category_name,
        p.*,
        case when p.forecast_value < 0 then 0 else p.forecast_value end as forecast_value_floor
    from {{ sales.my_forecast(ref('sales_arima_model')) }} p
    join {{ ref('category_profile') }} c
        on c.category = p.category
    join {{ ref('store_profile') }} s
        on s.store_number=p.store_number
)

select * from forecasts
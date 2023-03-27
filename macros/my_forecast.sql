{% macro my_forecast(relation, horizon='3') %}
    ml.forecast(
        model {{ relation }},
        STRUCT({{horizon}} as horizon)
    )
{% endmacro %}
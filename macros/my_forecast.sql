{% macro my_forecast(relation) %}
    ml.forecast(
        model {{ relation }}
    )
{% endmacro %}
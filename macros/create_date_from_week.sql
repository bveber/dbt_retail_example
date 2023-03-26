{% macro create_date_from_week(input_date) %}
    PARSE_DATE(
        '%Y-%V', 
        CAST(
            EXTRACT(YEAR FROM {{input_date}}) AS STRING) || 
            '-' || 
            CAST(EXTRACT(YEAR FROM {{input_date}}) AS STRING
        )
    )
{% endmacro %}
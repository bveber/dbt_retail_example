WITH source_data AS (

SELECT * 
FROM {{ ref('int__category_profiles_by_month') }}

)

SELECT * 
FROM source_data
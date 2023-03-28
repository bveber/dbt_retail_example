WITH source_data as (

SELECT * 
FROM {{ ref('int__category_profiles') }}

)

SELECT * 
FROM source_data
WHERE category IS NOT NULL
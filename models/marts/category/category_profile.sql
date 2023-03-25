WITH source_data as (

SELECT * 
FROM {{ ref('int__category_profile') }}

)

SELECT * 
FROM source_data
WHERE category in not NULL
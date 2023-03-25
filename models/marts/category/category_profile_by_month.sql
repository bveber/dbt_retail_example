WITH source_data as (

SELECT * 
FROM {{ ref('int__category_profile_by_month') }}

)

SELECT * 
FROM source_data
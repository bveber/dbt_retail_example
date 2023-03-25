WITH source_data as (
    SELECT *
    FROM {{ ref('int__store_profile') }}
)

SELECT * FROM source_data
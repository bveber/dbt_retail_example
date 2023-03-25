WITH source_data AS (
    SELECT *
    FROM {{ ref('int__store_profile') }}
)

SELECT * FROM source_data
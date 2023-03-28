WITH source_data AS (
    SELECT *
    FROM {{ ref('int__store_profiles') }}
)

SELECT * FROM source_data
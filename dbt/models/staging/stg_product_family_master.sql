-- Deduplicated product family master with data quality validation
{{ config(materialized='view') }}

select
    family_code,
    family_name,
    category_code,
    launch_year,
    created_at,
    source_system,
    case
        when family_code is null then false
        when family_name is null or trim(family_name) = '' then false
        when category_code is null then false
        when launch_year is null then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from {{ source('bronze', 'PRODUCT_FAMILY_MASTER') }}
qualify row_number() over (
    partition by family_code
    order by __load_ts desc, __row_number desc
) = 1

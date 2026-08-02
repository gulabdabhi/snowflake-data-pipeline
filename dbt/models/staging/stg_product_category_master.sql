-- Deduplicated product category master with data quality validation
{{ config(materialized='view') }}

select
    category_code,
    category_name,
    reporting_segment,
    created_at,
    source_system,
    case
        when category_code is null then false
        when category_name is null or trim(category_name) = '' then false
        when reporting_segment is null then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from {{ source('bronze', 'PRODUCT_CATEGORY_MASTER') }}
qualify row_number() over (
    partition by category_code
    order by __load_ts desc, __row_number desc
) = 1

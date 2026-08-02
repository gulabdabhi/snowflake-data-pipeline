-- Deduplicated product model master with data quality validation
{{ config(materialized='view') }}

select
    model_code,
    model_name,
    family_code,
    launch_date,
    discontinue_date,
    lifecycle_status,
    created_at,
    source_system,
    case
        when model_code is null then false
        when model_name is null or trim(model_name) = '' then false
        when family_code is null then false
        when launch_date is null then false
        when lifecycle_status not in ('ACTIVE', 'DISCONTINUED') then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from {{ source('bronze', 'PRODUCT_MODEL_MASTER') }}
qualify row_number() over (
    partition by model_code
    order by __load_ts desc, __row_number desc
) = 1

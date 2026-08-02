-- Deduplicated region master with data quality validation
{{ config(materialized='view') }}

select
    region_code,
    region_name,
    is_active,
    effective_start_date,
    effective_end_date,
    created_at,
    source_system,
    case
        when region_code is null then false
        when region_name is null or trim(region_name) = '' then false
        when is_active not in ('Y', 'N') then false
        when effective_start_date is null then false
        when effective_end_date < effective_start_date then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from {{ source('bronze', 'REGION_MASTER') }}
qualify row_number() over (
    partition by region_code
    order by __load_ts desc, __row_number desc
) = 1

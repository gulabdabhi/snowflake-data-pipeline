-- Deduplicated tax master with data quality validation
{{ config(materialized='view') }}

select
    tax_code,
    tax_type,
    tax_rate,
    tax_inclusive_flag,
    effective_start_date,
    effective_end_date,
    is_active,
    created_at,
    source_system,
    case
        when tax_code is null then false
        when tax_type is null or trim(tax_type) = '' then false
        when tax_rate is null or tax_rate < 0 or tax_rate > 1 then false
        when tax_inclusive_flag not in ('Y', 'N') then false
        when is_active not in ('Y', 'N') then false
        when effective_start_date is null then false
        when effective_end_date < effective_start_date then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from {{ source('bronze', 'TAX_MASTER') }}
qualify row_number() over (
    partition by tax_code
    order by __load_ts desc, __row_number desc
) = 1

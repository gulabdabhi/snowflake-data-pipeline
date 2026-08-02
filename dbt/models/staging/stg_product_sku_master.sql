-- Deduplicated product SKU master with data quality validation
{{ config(materialized='view') }}

select
    sku_code,
    model_code,
    variant,
    price_tier,
    global_launch_date,
    is_active,
    created_at,
    source_system,
    case
        when sku_code is null then false
        when model_code is null then false
        when variant is null or trim(variant) = '' then false
        when price_tier not in ('Standard', 'Premium') then false
        when global_launch_date is null then false
        when is_active not in ('Y', 'N') then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from {{ source('bronze', 'PRODUCT_SKU_MASTER') }}
qualify row_number() over (
    partition by sku_code
    order by __load_ts desc, __row_number desc
) = 1

-- DIM_STORE: Store dimension with location and operational attributes
{{ config(materialized='table') }}

select
    sha2(concat(
        coalesce(store_code, ''),
        coalesce(to_varchar(__bronze_load_ts, 'YYYY-MM-DD HH24:MI:SS.FF6'), '')
    ), 256) as store_dim_key,

    store_code,
    store_name,
    format_code,
    lifecycle_status,
    country_code,
    region_code,
    state_code,
    city,
    postal_code,
    address_line1,
    latitude,
    longitude,
    tax_jurisdiction_code,
    floor_area_sqft,
    annual_rent_usd,
    store_open_date,
    store_close_date,
    is_active,

    __bronze_load_ts as effective_start_ts,
    cast('9999-12-31 23:59:59' as timestamp_ntz) as effective_end_ts,
    true as is_current

from {{ ref('stg_store_master') }}
where is_valid_record = true

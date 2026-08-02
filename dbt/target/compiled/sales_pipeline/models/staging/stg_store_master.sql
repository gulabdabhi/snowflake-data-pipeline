-- Deduplicated store master with data quality validation


select
    store_code,
    store_name,
    format_code,
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
    lifecycle_status,
    is_active,
    case
        when store_code is null then false
        when store_name is null or trim(store_name) = '' then false
        when country_code is null then false
        when format_code not in ('MALL', 'MINI', 'FLAGSHIP') then false
        when is_active not in ('Y', 'N') then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from SALES_DEV.BRONZE.STORE_MASTER
qualify row_number() over (
    partition by store_code
    order by __load_ts desc, __row_number desc
) = 1
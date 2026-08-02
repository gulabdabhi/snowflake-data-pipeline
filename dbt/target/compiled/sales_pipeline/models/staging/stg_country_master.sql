-- Deduplicated country master with data quality validation


select
    country_code,
    country_name,
    region_code,
    currency_code,
    tax_code,
    primary_language,
    timezone,
    ecommerce_supported,
    retail_store_supported,
    market_tier,
    case
        when country_code is null then false
        when country_name is null or trim(country_name) = '' then false
        when region_code is null then false
        when currency_code is null then false
        when ecommerce_supported not in ('Y', 'N') then false
        when retail_store_supported not in ('Y', 'N') then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from SALES_DEV.BRONZE.COUNTRY_MASTER
qualify row_number() over (
    partition by country_code
    order by __load_ts desc, __row_number desc
) = 1
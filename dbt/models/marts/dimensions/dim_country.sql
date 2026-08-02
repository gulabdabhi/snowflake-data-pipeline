-- DIM_COUNTRY: Geography dimension combining region, currency, and tax
{{ config(materialized='table') }}

select
    sha2(concat(
        coalesce(c.country_code, ''),
        coalesce(to_varchar(c.__bronze_load_ts, 'YYYY-MM-DD HH24:MI:SS.FF6'), '')
    ), 256) as country_dim_key,

    c.country_code,
    c.country_name,
    c.primary_language,
    c.timezone,
    c.market_tier,
    c.ecommerce_supported,
    c.retail_store_supported,

    r.region_code,
    r.region_name,

    cu.currency_code,
    cu.currency_name,
    cu.currency_symbol,

    t.tax_code,
    t.tax_type,
    t.tax_rate,
    t.tax_inclusive_flag,

    c.__bronze_load_ts as effective_start_ts,
    cast('9999-12-31 23:59:59' as timestamp_ntz) as effective_end_ts,
    true as is_current

from {{ ref('stg_country_master') }} c
left join {{ ref('stg_region_master') }} r
    on c.region_code = r.region_code and r.is_valid_record = true
left join {{ ref('stg_currency_master') }} cu
    on c.currency_code = cu.currency_code and cu.is_valid_record = true
left join {{ ref('stg_tax_master') }} t
    on c.tax_code = t.tax_code and t.is_valid_record = true
where c.is_valid_record = true

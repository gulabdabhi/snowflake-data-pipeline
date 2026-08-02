-- DIM_PRODUCT: Full product hierarchy Category > Family > Model > SKU
{{ config(materialized='table') }}

select
    sha2(concat(
        coalesce(s.sku_code, ''),
        coalesce(to_varchar(s.__bronze_load_ts, 'YYYY-MM-DD HH24:MI:SS.FF6'), '')
    ), 256) as product_dim_key,

    s.sku_code,
    s.variant,
    s.price_tier,
    s.global_launch_date as sku_launch_date,
    s.is_active as sku_is_active,

    m.model_code,
    m.model_name,
    m.launch_date as model_launch_date,
    m.discontinue_date as model_discontinue_date,
    m.lifecycle_status,

    f.family_code,
    f.family_name,
    f.launch_year as family_launch_year,

    c.category_code,
    c.category_name,
    c.reporting_segment,

    s.__bronze_load_ts as effective_start_ts,
    cast('9999-12-31 23:59:59' as timestamp_ntz) as effective_end_ts,
    true as is_current

from {{ ref('stg_product_sku_master') }} s
join {{ ref('stg_product_model_master') }} m
    on s.model_code = m.model_code and m.is_valid_record = true
join {{ ref('stg_product_family_master') }} f
    on m.family_code = f.family_code and f.is_valid_record = true
join {{ ref('stg_product_category_master') }} c
    on f.category_code = c.category_code and c.is_valid_record = true
where s.is_valid_record = true

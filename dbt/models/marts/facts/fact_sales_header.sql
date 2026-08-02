-- FACT_SALES_HEADER: Transaction-level fact table
{{
    config(
        materialized='incremental',
        unique_key='fact_sales_header_key',
        incremental_strategy='merge'
    )
}}

select
    sha2(concat(
        coalesce(sh.transaction_id, ''),
        coalesce(to_varchar(sh.__bronze_load_ts, 'YYYY-MM-DD HH24:MI:SS.FF6'), '')
    ), 256) as fact_sales_header_key,

    c.customer_dim_key,
    s.store_dim_key,
    cn.country_dim_key,
    d.date_dim_key,

    sh.transaction_id,
    sh.transaction_number,
    sh.transaction_timestamp,
    sh.channel_id,
    sh.payment_method,
    sh.currency,
    sh.gross_amount,
    sh.total_discount,
    sh.total_tax,
    sh.net_total,
    1 as transaction_count,

    sh.__bronze_load_ts as __source_load_ts

from {{ ref('stg_sales_header') }} sh
join {{ ref('dim_customer') }} c
    on sha2(concat(coalesce(sh.customer_id, ''), coalesce(to_varchar(c.effective_start_ts, 'YYYY-MM-DD HH24:MI:SS.FF6'), '')), 256) = c.customer_dim_key
join {{ ref('dim_store') }} s
    on sha2(concat(coalesce(sh.store_id, ''), coalesce(to_varchar(s.effective_start_ts, 'YYYY-MM-DD HH24:MI:SS.FF6'), '')), 256) = s.store_dim_key
join {{ ref('dim_country') }} cn
    on s.country_code = cn.country_code and cn.is_current = true
join {{ ref('dim_date') }} d
    on sh.transaction_timestamp = d.date_key
where sh.is_valid_record = true

{% if is_incremental() %}
    and sh.__bronze_load_ts > (select max(__source_load_ts) from {{ this }})
{% endif %}

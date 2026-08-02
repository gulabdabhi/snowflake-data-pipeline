-- Deduplicated sales header with data quality validation
{{ config(materialized='view') }}

select
    transaction_id,
    transaction_number,
    transaction_timestamp,
    customer_id,
    store_id,
    channel_id,
    payment_method,
    currency,
    gross_amount,
    total_discount,
    total_tax,
    net_total,
    created_at,
    case
        when transaction_id is null then false
        when transaction_number is null then false
        when customer_id is null then false
        when store_id is null then false
        when currency is null then false
        when gross_amount < 0 then false
        when total_discount < 0 then false
        when total_tax < 0 then false
        when net_total < 0 then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from {{ source('bronze', 'SALES_HEADER') }}
qualify row_number() over (
    partition by transaction_id
    order by __load_ts desc, __row_number desc
) = 1


  create or replace   view SALES_DEV.GOLD_SILVER.stg_sales_item
  
   as (
    -- Deduplicated sales line items with data quality validation


select
    transaction_line_id,
    transaction_id,
    sku_code,
    quantity,
    unit_price,
    discount_amount,
    tax_amount,
    line_total,
    created_at,
    case
        when transaction_line_id is null then false
        when transaction_id is null then false
        when sku_code is null then false
        when quantity is null or quantity <= 0 then false
        when unit_price < 0 then false
        when discount_amount < 0 then false
        when tax_amount < 0 then false
        when line_total < 0 then false
        else true
    end as is_valid_record,
    __file_name,
    __row_number as __source_row_number,
    __load_ts as __bronze_load_ts
from SALES_DEV.BRONZE.SALES_ITEM
qualify row_number() over (
    partition by transaction_line_id
    order by __load_ts desc, __row_number desc
) = 1
  );


-- FACT_SALES_ITEM: Line-item level fact table


select
    sha2(concat(
        coalesce(si.transaction_line_id, ''),
        coalesce(to_varchar(si.__bronze_load_ts, 'YYYY-MM-DD HH24:MI:SS.FF6'), '')
    ), 256) as fact_sales_item_key,

    fh.fact_sales_header_key,
    fh.customer_dim_key,
    p.product_dim_key,
    fh.store_dim_key,
    fh.country_dim_key,
    fh.date_dim_key,

    si.transaction_line_id,
    si.transaction_id,
    fh.transaction_number,
    fh.transaction_timestamp,
    fh.channel_id,
    fh.currency,
    si.quantity,
    si.unit_price,
    si.discount_amount,
    si.tax_amount,
    si.line_total,
    1 as line_count,

    si.__bronze_load_ts as __source_load_ts

from SALES_DEV.GOLD_SILVER.stg_sales_item si
join SALES_DEV.GOLD_GOLD.fact_sales_header fh
    on si.transaction_id = fh.transaction_id
join SALES_DEV.GOLD_GOLD.dim_product p
    on sha2(concat(coalesce(si.sku_code, ''), coalesce(to_varchar(p.effective_start_ts, 'YYYY-MM-DD HH24:MI:SS.FF6'), '')), 256) = p.product_dim_key
where si.is_valid_record = true


    and si.__bronze_load_ts > (select max(__source_load_ts) from SALES_DEV.GOLD_GOLD.fact_sales_item)

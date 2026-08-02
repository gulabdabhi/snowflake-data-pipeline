-- FACT_SALES_MONTHLY: Monthly aggregated sales for executive reporting


select
    d.year_number,
    d.month_number,
    d.year_month,
    d.month_name,
    d.quarter_number,
    d.year_quarter,

    cn.country_dim_key,
    cn.country_code,
    cn.country_name,
    cn.region_code,
    cn.region_name,

    fh.channel_id,
    fh.currency,

    count(*) as transaction_count,
    sum(fh.gross_amount) as total_gross_amount,
    sum(fh.total_discount) as total_discount,
    sum(fh.total_tax) as total_tax,
    sum(fh.net_total) as total_net_sales,
    avg(fh.net_total) as avg_transaction_value,
    count(distinct fh.customer_dim_key) as unique_customers,
    count(distinct fh.store_dim_key) as active_stores,
    count(distinct d.date_key) as selling_days

from SALES_DEV.GOLD_GOLD.fact_sales_header fh
join SALES_DEV.GOLD_GOLD.dim_date d on fh.date_dim_key = d.date_dim_key
join SALES_DEV.GOLD_GOLD.dim_country cn on fh.country_dim_key = cn.country_dim_key
group by 1,2,3,4,5,6,7,8,9,10,11,12,13
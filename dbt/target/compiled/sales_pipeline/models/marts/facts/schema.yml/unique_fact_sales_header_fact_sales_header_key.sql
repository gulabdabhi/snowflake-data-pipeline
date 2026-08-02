
    
    

select
    fact_sales_header_key as unique_field,
    count(*) as n_records

from SALES_DEV.GOLD_GOLD.fact_sales_header
where fact_sales_header_key is not null
group by fact_sales_header_key
having count(*) > 1



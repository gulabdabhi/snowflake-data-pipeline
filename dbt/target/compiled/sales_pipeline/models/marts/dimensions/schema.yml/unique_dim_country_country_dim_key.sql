
    
    

select
    country_dim_key as unique_field,
    count(*) as n_records

from SALES_DEV.GOLD_GOLD.dim_country
where country_dim_key is not null
group by country_dim_key
having count(*) > 1



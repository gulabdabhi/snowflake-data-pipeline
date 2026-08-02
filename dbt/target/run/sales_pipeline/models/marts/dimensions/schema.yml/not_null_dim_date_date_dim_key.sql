select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select date_dim_key
from SALES_DEV.GOLD_GOLD.dim_date
where date_dim_key is null



      
    ) dbt_internal_test
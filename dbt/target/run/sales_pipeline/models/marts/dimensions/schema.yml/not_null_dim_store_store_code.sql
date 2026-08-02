select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select store_code
from SALES_DEV.GOLD_GOLD.dim_store
where store_code is null



      
    ) dbt_internal_test
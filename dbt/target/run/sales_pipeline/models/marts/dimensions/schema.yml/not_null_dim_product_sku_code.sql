select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select sku_code
from SALES_DEV.GOLD_GOLD.dim_product
where sku_code is null



      
    ) dbt_internal_test
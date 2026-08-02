select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select MODEL_CODE
from SALES_DEV.BRONZE.PRODUCT_MODEL_MASTER
where MODEL_CODE is null



      
    ) dbt_internal_test
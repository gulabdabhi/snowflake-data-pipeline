select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select SKU_CODE
from SALES_DEV.BRONZE.PRODUCT_SKU_MASTER
where SKU_CODE is null



      
    ) dbt_internal_test
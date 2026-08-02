select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select CATEGORY_CODE
from SALES_DEV.BRONZE.PRODUCT_CATEGORY_MASTER
where CATEGORY_CODE is null



      
    ) dbt_internal_test
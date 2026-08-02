select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select FAMILY_CODE
from SALES_DEV.BRONZE.PRODUCT_FAMILY_MASTER
where FAMILY_CODE is null



      
    ) dbt_internal_test
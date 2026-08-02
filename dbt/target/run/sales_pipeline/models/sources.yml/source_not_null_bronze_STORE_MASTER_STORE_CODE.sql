select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select STORE_CODE
from SALES_DEV.BRONZE.STORE_MASTER
where STORE_CODE is null



      
    ) dbt_internal_test
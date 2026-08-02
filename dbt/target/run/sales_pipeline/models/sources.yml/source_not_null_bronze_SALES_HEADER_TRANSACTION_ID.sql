select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select TRANSACTION_ID
from SALES_DEV.BRONZE.SALES_HEADER
where TRANSACTION_ID is null



      
    ) dbt_internal_test
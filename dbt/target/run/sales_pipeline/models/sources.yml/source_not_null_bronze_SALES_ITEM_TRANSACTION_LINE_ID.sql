select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select TRANSACTION_LINE_ID
from SALES_DEV.BRONZE.SALES_ITEM
where TRANSACTION_LINE_ID is null



      
    ) dbt_internal_test
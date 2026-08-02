select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select CUSTOMER_ID
from SALES_DEV.BRONZE.CUSTOMER_MASTER
where CUSTOMER_ID is null



      
    ) dbt_internal_test
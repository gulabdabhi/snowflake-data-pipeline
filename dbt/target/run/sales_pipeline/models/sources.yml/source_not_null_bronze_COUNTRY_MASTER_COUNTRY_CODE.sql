select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select COUNTRY_CODE
from SALES_DEV.BRONZE.COUNTRY_MASTER
where COUNTRY_CODE is null



      
    ) dbt_internal_test
select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select REGION_CODE
from SALES_DEV.BRONZE.REGION_MASTER
where REGION_CODE is null



      
    ) dbt_internal_test
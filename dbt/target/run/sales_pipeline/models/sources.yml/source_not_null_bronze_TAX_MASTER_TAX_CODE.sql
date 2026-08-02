select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select TAX_CODE
from SALES_DEV.BRONZE.TAX_MASTER
where TAX_CODE is null



      
    ) dbt_internal_test
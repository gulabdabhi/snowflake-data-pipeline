select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    



select fact_sales_header_key
from SALES_DEV.GOLD_GOLD.fact_sales_item
where fact_sales_header_key is null



      
    ) dbt_internal_test
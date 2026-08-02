select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

select
    fact_sales_item_key as unique_field,
    count(*) as n_records

from SALES_DEV.GOLD_GOLD.fact_sales_item
where fact_sales_item_key is not null
group by fact_sales_item_key
having count(*) > 1



      
    ) dbt_internal_test
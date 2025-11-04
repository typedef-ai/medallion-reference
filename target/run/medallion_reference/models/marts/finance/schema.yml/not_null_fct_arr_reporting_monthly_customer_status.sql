
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select customer_status
from DEMO_AGENTS_DAVID.marts.fct_arr_reporting_monthly
where customer_status is null



  
  
      
    ) dbt_internal_test
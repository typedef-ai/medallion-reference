
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select month_end
from DEMO_AGENTS_DAVID.marts.fct_arr_reporting_monthly
where month_end is null



  
  
      
    ) dbt_internal_test
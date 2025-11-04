
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select opportunity_id
from DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity
where opportunity_id is null



  
  
      
    ) dbt_internal_test
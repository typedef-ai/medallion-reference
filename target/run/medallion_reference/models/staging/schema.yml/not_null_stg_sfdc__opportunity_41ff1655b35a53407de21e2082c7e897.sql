
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select opportunity_line_item_id
from DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity_line_item
where opportunity_line_item_id is null



  
  
      
    ) dbt_internal_test
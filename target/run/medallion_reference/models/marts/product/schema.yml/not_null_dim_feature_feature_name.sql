
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select feature_name
from DEMO_AGENTS_DAVID.marts.dim_feature
where feature_name is null



  
  
      
    ) dbt_internal_test

    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    



select user_license_id
from DEMO_AGENTS_DAVID.staging.stg_product__user_licenses
where user_license_id is null



  
  
      
    ) dbt_internal_test
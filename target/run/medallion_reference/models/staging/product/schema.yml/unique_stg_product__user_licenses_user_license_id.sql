
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

select
    user_license_id as unique_field,
    count(*) as n_records

from DEMO_AGENTS_DAVID.staging.stg_product__user_licenses
where user_license_id is not null
group by user_license_id
having count(*) > 1



  
  
      
    ) dbt_internal_test
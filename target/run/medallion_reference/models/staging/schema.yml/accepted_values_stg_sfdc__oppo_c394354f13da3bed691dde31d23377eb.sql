
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        type as value_field,
        count(*) as n_records

    from DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity
    group by type

)

select *
from all_values
where value_field not in (
    'New Subscription','Renewal','Expansion','Monthly Billing'
)



  
  
      
    ) dbt_internal_test
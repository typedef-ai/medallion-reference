
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        product_family as value_field,
        count(*) as n_records

    from DEMO_AGENTS_DAVID.staging.stg_sfdc__opportunity_line_item
    group by product_family

)

select *
from all_values
where value_field not in (
    'License','Other'
)



  
  
      
    ) dbt_internal_test
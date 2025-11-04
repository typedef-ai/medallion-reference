
    select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
  
    
    

with all_values as (

    select
        customer_status as value_field,
        count(*) as n_records

    from DEMO_AGENTS_DAVID.marts.fct_arr_reporting_monthly
    group by customer_status

)

select *
from all_values
where value_field not in (
    'Active','Churned','Pipeline Only'
)



  
  
      
    ) dbt_internal_test